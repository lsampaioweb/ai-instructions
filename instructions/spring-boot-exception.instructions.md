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

## Templates

**Abstract base exception.** Replace `AppException` with a name relevant to the project. Use as-is otherwise.

```java
public abstract class AppException extends RuntimeException {

  private final String messageKey;
  private final Object[] args;
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

**@RestControllerAdvice skeleton.** Replace `AppException` with the actual base class name used in the project.

```java
@Slf4j
@RestControllerAdvice
class GlobalExceptionHandler {

  private static final String ERR_INTERNAL = "error.internal.server";

  private final MessageSource messageSource;

  GlobalExceptionHandler(MessageSource messageSource) {
    this.messageSource = messageSource;
  }

  @ExceptionHandler(AppException.class)
  public ResponseEntity<ErrorResponse> handleAppException(AppException ex, HttpServletRequest request) {
    String message = messageSource.getMessage(ex.getMessageKey(), ex.getArgs(), LocaleContextHolder.getLocale());

    return ResponseEntity.status(ex.getStatus())
      .body(buildError(ex.getStatus().value(), ex.getStatus().getReasonPhrase(), message, request, ex));
  }

  @ExceptionHandler(NoResourceFoundException.class)
  @ResponseStatus(HttpStatus.NOT_FOUND)
  public ErrorResponse handleNoResourceFound(NoResourceFoundException ex, HttpServletRequest request) {
    HttpStatus status = HttpStatus.NOT_FOUND;

    return buildError(status.value(), status.getReasonPhrase(), ex.getMessage(), request, ex);
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  @ResponseStatus(HttpStatus.BAD_REQUEST)
  public List<FieldError> handleValidation(MethodArgumentNotValidException ex) {
    return ex.getBindingResult()
      .getFieldErrors()
      .stream()
      .map(fe -> new FieldError(fe.getField(), fe.getDefaultMessage()))
      .toList();
  }

  @ExceptionHandler(Exception.class)
  @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
  public ErrorResponse handleGeneric(Exception ex, HttpServletRequest request) {
    HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;
    String message = messageSource.getMessage(ERR_INTERNAL, null, LocaleContextHolder.getLocale());

    return buildError(status.value(), status.getReasonPhrase(), message, request, ex);
  }

  private ErrorResponse buildError(int status, String error, String message, HttpServletRequest request, Exception ex) {
    // Keep trace null by default; include it conditionally only when explicitly exposed (e.g., development profile).
    return new ErrorResponse(LocalDateTime.now(), status, error, message, request.getRequestURI(), null);
  }

  private record FieldError(String field, String message) {}
}
```
