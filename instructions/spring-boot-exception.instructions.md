---
description: "Exception handling rules: single @RestControllerAdvice, domain exception hierarchy, ErrorResponse DTO, and stacktrace policy."
applyTo: "**/*Exception.java, **/*ControllerAdvice.java, **/*ExceptionHandler.java, **/*ErrorResponse.java, **/application*.yml"
---

# Exception Handling Rules

See `spring-boot-soft-delete.instructions.md` for soft-delete related not-found and inactive-entity behavior.
See `spring-boot-referential-integrity.instructions.md` for foreign-key violation to HTTP `409 Conflict` mapping.
See `spring-boot-error-code.instructions.md` for machine-readable `errorCode` contract and mappings.

## @RestControllerAdvice
- One single `@RestControllerAdvice` class handles all exceptions for the entire application
- Always include a catch-all `@ExceptionHandler(Exception.class)` handler mapped to HTTP 500
- Handle `NoResourceFoundException` (from `org.springframework.web.servlet.resource`) explicitly, mapped to HTTP 404 and returning a standard `ErrorResponse`; without this, Spring MVC routes it to the catch-all and every missing path becomes a 500
- Handle `MethodArgumentNotValidException` separately; return a list of `{field, message}` records — one per validation failure — not a single `ErrorResponse`
- Never expose stack traces by default; set `server.error.include-stacktrace: "never"` in `application.yml` and `server.error.include-stacktrace: "always"` in `application-development.yml`

## Exception Types
- Domain exceptions are HTTP-facing and are translated by `@RestControllerAdvice`
- Operational exceptions are startup/infrastructure exceptions and are not returned as HTTP error payloads

## Domain Exceptions
- All domain exceptions extend a shared abstract base class that extends `RuntimeException`
- The base class stores three fields: `String messageKey`, `Object[] args`, `HttpStatus status`
- Declare `Object[] args` as `transient` — `RuntimeException` is `Serializable` by inheritance, and a non-`transient` `Object[]` triggers Sonar S1948 because individual elements may not be serializable
- Exception constructors are plain data holders: never hardcode message text (pass an i18n key as `messageKey`) and never call `MessageSource` or any Spring infrastructure
- Domain exceptions pass key, args, and status to the base constructor; message text resolution happens in `@RestControllerAdvice` using `MessageSource` and the request locale from `LocaleContextHolder.getLocale()`

## Operational Exceptions
Not all exceptions are domain exceptions caught by `@RestControllerAdvice`. Integration clients, utilities, and startup validators may throw operational exceptions (e.g., `IllegalStateException`, `IllegalArgumentException`) that are **never** intended for HTTP response handling. These exceptions are logged or cause startup failure.
See `spring-boot-logging.instructions.md` for shared operator-facing message-key conventions.

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

See `snippets/exception/GlobalExceptionHandler.java` for the operational exception message pattern (i18n key constant, `LogMessages` injection, throw with resolved message).

## ErrorResponse
- Every exception handler (except the `MethodArgumentNotValidException` handler) returns the same `ErrorResponse` DTO
- `ErrorResponse` fields: `timestamp` (OffsetDateTime), `status` (int), `error` (HTTP reason phrase), `errorCode` (machine-readable string code), `message` (resolved i18n string), `path` (request URI), `trace` (stack trace string, null when not exposed)
- The `message` field is locale-aware; the same exception may return different text depending on the `Accept-Language` header
- Use `OffsetDateTime.now(ZoneOffset.UTC)` for the `timestamp` field; never use bare `now()` without explicit zone context.
- The `trace` field is `null` by default; populate it conditionally based on `server.error.include-stacktrace` — see `## Stacktrace Exposure`

## Stacktrace Exposure

Inject `Environment` to read `server.error.include-stacktrace` at request time and conditionally populate the `trace` field. This allows toggling between `"never"` (base/production) and `"always"` (development) without code changes.
Implement a helper method (e.g., `shouldIncludeStackTrace()`) to read this property and return a boolean.

Required dependency on the handler: `private final Environment environment` (constructor-injected alongside `MessageSource`).

The `shouldIncludeStackTrace()` and `getStackTraceAsString()` private helpers are shown in `snippets/exception/GlobalExceptionHandler.java`. Use inside `newErrorResponse()` as: `shouldIncludeStackTrace() ? getStackTraceAsString(ex) : null`.

