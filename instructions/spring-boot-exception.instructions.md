---
description: "Exception handling rules: single @RestControllerAdvice, domain exception hierarchy, ErrorResponse DTO, and stacktrace policy."
applyTo: "**/*Exception.java, **/*ControllerAdvice.java, **/*ExceptionHandler.java, **/*ErrorResponse.java"
---

# Exception Handling Rules

## @RestControllerAdvice
- One single `@RestControllerAdvice` class handles all exceptions for the entire application
- Always include a catch-all `@ExceptionHandler(Exception.class)` handler mapped to HTTP 500
- Handle `NoResourceFoundException` (from `org.springframework.web.servlet.resource`) explicitly, mapped to HTTP 404 and returning a standard `ErrorResponse`; without this, Spring MVC routes it to the catch-all and every missing path becomes a 500
- Handle `MethodArgumentNotValidException` separately; return a list of `{field, message}` records — one per validation failure — not a single `ErrorResponse`
- Never expose stack traces by default; set `server.error.include-stacktrace: "never"` in `application.yml` and `server.error.include-stacktrace: "always"` in `application-development.yml`

## Domain Exceptions
- All domain exceptions extend a shared abstract base class that extends `RuntimeException`
- The base class stores three fields: `String messageKey`, `Object[] args`, `HttpStatus status`
- Declare `Object[] args` as `transient` — `RuntimeException` is `Serializable` by inheritance, and a non-`transient` `Object[]` triggers Sonar S1948 because individual elements may not be serializable
- Exception constructors are plain data holders: never hardcode message text (pass an i18n key as `messageKey`) and never call `MessageSource` or any Spring infrastructure
- Domain exceptions pass key, args, and status to the base constructor; message text resolution happens in `@RestControllerAdvice` using `MessageSource` and the request locale from `LocaleContextHolder.getLocale()`

## Operational Exceptions
Not all exceptions are domain exceptions caught by `@RestControllerAdvice`. Integration clients, utilities, and startup validators may throw operational exceptions (e.g., `IllegalStateException`, `IllegalArgumentException`) that are **never** intended for HTTP response handling. These exceptions are logged or cause startup failure.
For shared operator-facing message-key conventions, follow `spring-boot-logging.instructions.md`.

### Pattern for Operational Exception Messages
Operational exception messages follow the same i18n principle as logs:
1. Define message key constants at the top of the class (e.g., `ERROR_VAULT_RESPONSE_EMPTY = "error.vault.response.empty"`)
2. Define the message keys and translations in `messages.properties` and `messages_pt_BR.properties`
3. Inject `LogMessages` via constructor
4. Resolve the message when throwing the exception: `throw new IllegalStateException(logMessages.get(ERROR_VAULT_RESPONSE_EMPTY))`

### When to Use Operational Exceptions
- Integration client validation: Vault client throws `IllegalStateException` for malformed responses
- Startup validators: Configuration validators throw `IllegalArgumentException` for missing required values
- Utility preconditions: Utility methods throw `IllegalStateException` for invalid state
- **Never** for business logic that should result in an HTTP response — use domain exceptions instead

### Example
```java
@Service
public class VaultSecretService {
  private static final String ERROR_EMPTY_RESPONSE = "error.vault.response.empty";
  private static final String ERROR_KEY_NOT_FOUND = "error.vault.secret.key.not.found";

  private final LogMessages logMessages;

  VaultSecretService(LogMessages logMessages) {
    this.logMessages = logMessages;
  }

  String readSecret(String path, String key) {
    Map<String, Object> response = vaultClient.read(path);
    if (response == null) {
      throw new IllegalStateException(logMessages.get(ERROR_EMPTY_RESPONSE));
    }
    Object value = response.get(key);
    if (value == null) {
      throw new IllegalStateException(logMessages.get(ERROR_KEY_NOT_FOUND, key));
    }
    return String.valueOf(value);
  }
}
```

## ErrorResponse
- Every exception handler (except the `MethodArgumentNotValidException` handler) returns the same `ErrorResponse` DTO
- `ErrorResponse` fields: `timestamp` (LocalDateTime), `status` (int), `error` (HTTP reason phrase), `message` (resolved i18n string), `path` (request URI), `trace` (stack trace string, null when not exposed)
- The `message` field is always locale-aware; the same exception may return different text depending on the `Accept-Language` header
- Use `LocalDateTime.now(ZoneOffset.UTC)` for the `timestamp` field; never use bare `LocalDateTime.now()` — the architecture rule requiring an explicit `ZoneId` applies here; `LocalDateTime` with UTC is acceptable for this informational, non-cross-service field even though the architecture instruction prefers `OffsetDateTime` for API timestamps
- The `trace` field is `null` by default; populate it conditionally based on `server.error.include-stacktrace` — see `## Stacktrace Exposure`

## Stacktrace Exposure

Inject `Environment` to read `server.error.include-stacktrace` at request time and conditionally populate the `trace` field. This allows toggling between `"never"` (base/production) and `"always"` (development) without code changes.

Required dependency on the handler: `private final Environment environment` (constructor-injected alongside `MessageSource`).

Constants and helpers — copy as-is:

```java
private static final String SERVER_ERROR_INCLUDE_STACKTRACE = "server.error.include-stacktrace";
private static final String STACKTRACE_ALWAYS = "always";

private boolean shouldIncludeStackTrace() {
  String value = environment.getProperty(SERVER_ERROR_INCLUDE_STACKTRACE, "never").toLowerCase();
  return STACKTRACE_ALWAYS.equals(value);
}

private String getStackTraceAsString(Exception ex) {
  StringWriter sw = new StringWriter();
  ex.printStackTrace(new PrintWriter(sw));
  return sw.toString();
}
```

Use inside the `newErrorResponse()` helper:

```java
shouldIncludeStackTrace() ? getStackTraceAsString(ex) : null
```

## Templates

**Abstract base exception.** Replace `AppException` with a name relevant to the project. Use as-is otherwise.

```java
public abstract class AppException extends RuntimeException {

  private final String messageKey;
  private final transient Object[] args;
  private final HttpStatus status;

  protected AppException(String messageKey, Object[] args, HttpStatus status) {
    super(messageKey);

    this.messageKey = messageKey;
    this.args = args;
    this.status = status;
  }

  public String getMessageKey() { return messageKey; }
  public Object[] getArgs() { return args; }
  public HttpStatus getStatus() { return status; }
}
```

**Concrete domain exception.** One class per domain concept. Replace `{Resource}` and the i18n message key.

```java
public class {Resource}NotFoundException extends AppException {
  public {Resource}NotFoundException(Object id) {
    super("{resource}.not.found", new Object[]{id}, HttpStatus.NOT_FOUND);
  }
}
```

**ErrorResponse record.** Same in every project; use as-is.

```java
public record ErrorResponse(
  LocalDateTime timestamp,
  int status,
  String error,
  String message,
  String path,
  String trace) {}
```

**ValidationError record.** Returned as a list by the `MethodArgumentNotValidException` handler; one item per failing field. Declare as a top-level file — do not nest it inside the handler class.

```java
public record ValidationError(String field, String message) {}
```

**@RestControllerAdvice skeleton.** Replace `AppException` with the actual base class name used in the project.

```java
@Slf4j
@RestControllerAdvice
class GlobalExceptionHandler {

  private static final String SERVER_ERROR_INCLUDE_STACKTRACE = "server.error.include-stacktrace";
  private static final String STACKTRACE_ALWAYS = "always";
  private static final String ERR_INTERNAL = "error.internal.server";

  private final MessageSource messageSource;
  private final Environment environment;

  GlobalExceptionHandler(MessageSource messageSource, Environment environment) {
    this.messageSource = messageSource;
    this.environment = environment;
  }

  @ExceptionHandler(AppException.class)
  public ResponseEntity<ErrorResponse> handleAppException(AppException ex, HttpServletRequest request) {
    String message = messageSource.getMessage(ex.getMessageKey(), ex.getArgs(), LocaleContextHolder.getLocale());
    ErrorResponse response = newErrorResponse(message, ex, request, ex.getStatus());

    return ResponseEntity.status(ex.getStatus()).body(response);
  }

  @ExceptionHandler(NoResourceFoundException.class)
  @ResponseStatus(HttpStatus.NOT_FOUND)
  public @ResponseBody ErrorResponse handleNoResourceFound(NoResourceFoundException ex, HttpServletRequest request) {
    return newErrorResponse(ex.getMessage(), ex, request, HttpStatus.NOT_FOUND);
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  public @ResponseBody List<ValidationError> handleValidation(MethodArgumentNotValidException ex) {
    return ex.getBindingResult()
      .getFieldErrors()
      .stream()
      .map(fe -> new ValidationError(fe.getField(), fe.getDefaultMessage()))
      .toList();
  }

  @ExceptionHandler(Exception.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  public @ResponseBody ErrorResponse handleGeneric(Exception ex, HttpServletRequest request) {
    String message = messageSource.getMessage(ERR_INTERNAL, null, LocaleContextHolder.getLocale());

    return newErrorResponse(message, ex, request, HttpStatus.INTERNAL_SERVER_ERROR);
  }

  private ErrorResponse newErrorResponse(String message, Exception ex, HttpServletRequest request, HttpStatus status) {
    return new ErrorResponse(
      LocalDateTime.now(ZoneOffset.UTC),
      status.value(),
      status.getReasonPhrase(),
      message,
      request.getRequestURI(),
      shouldIncludeStackTrace() ? getStackTraceAsString(ex) : null);
  }

  private boolean shouldIncludeStackTrace() {
    String value = environment.getProperty(SERVER_ERROR_INCLUDE_STACKTRACE, "never").toLowerCase();
    return STACKTRACE_ALWAYS.equals(value);
  }

  private String getStackTraceAsString(Exception ex) {
    StringWriter sw = new StringWriter();
    ex.printStackTrace(new PrintWriter(sw));
    return sw.toString();
  }
}
```
