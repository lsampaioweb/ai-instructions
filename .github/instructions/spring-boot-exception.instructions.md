---
description: "Spring exception hierarchy, translation, localized API errors, validation, and trace exposure."
applyTo: "**/*Exception*.java, **/*ExceptionHandler*.java, **/*ExceptionHandling*.java, **/*ExceptionAdvice*.java, **/GlobalExceptionHandler.java, **/ErrorResponse.java, **/ValidationError.java, **/*Advice*.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for Java structure and the model contract in `spring-boot-model.instructions.md` for error payloads.
- Apply HTTP response rules only to MVC API boundaries; translate messaging, startup, and outbound-client failures at their owning boundary.
- For `@RestControllerAdvice` and shared error-DTO placement, defer to `spring-boot-architecture.instructions.md`.

## Naming Conventions
- Name domain exception classes with the `*Exception` suffix, named after the failed business outcome (e.g., `HolidayNotFoundException`, `InsufficientBalanceException`).
- Name infrastructure wrappers after the failing boundary, such as `DatabaseException` or `OrderPublishException`.
- Use domain-specific exception names (never `AppException` or `CustomException` without a project-established base type).
- Name exception handler classes with the `*ExceptionHandler` suffix.
- Name global advice classes with the `*Advice` or `*ControllerAdvice` suffix (e.g., `GlobalControllerAdvice`, `ApiExceptionAdvice`).

## Rules

### Exception hierarchy and translation
- Extend all domain exceptions from a common base exception class (e.g., `DomainException` or the established module-equivalent base type) to enable a shared base `@ExceptionHandler` and consistent HTTP status derivation.
- Declare the base domain exception class as `abstract`.
- Embed `HttpStatus` and an i18n message key in the base exception constructor; resolve the message in the handler via `MessageSource`.
- Give each application exception a message key, interpolation arguments, and an HTTP status when it can reach an MVC API boundary.
- Preserve the original cause when wrapping an unexpected infrastructure failure.
- Throw domain exceptions for expected business outcomes.
- Rethrow expected domain exceptions unchanged when a broad infrastructure catch surrounds the operation.
- Translate unexpected persistence, broker, startup, or client failures at the boundary that understands them.
- Do not use HTTP response types or status annotations in messaging listeners, startup code, or outbound-client adapters.

### HTTP exception handling
- Centralize MVC API exception-to-response translation in one `@RestControllerAdvice`, not `@ControllerAdvice`.
- Add a single `@ExceptionHandler` for the base exception type that reads `ex.getStatus()` and resolves the user-facing message via `MessageSource` using `LocaleContextHolder.getLocale()`.
- Map not-found failures to HTTP 404, invalid-input failures to HTTP 400, conflict failures to HTTP 409, and forbidden failures to HTTP 403.
- Map missing static resources to `404 NOT_FOUND`; add `@ExceptionHandler(NoResourceFoundException.class)` in the global advice to return a structured 404 error response for unmapped routes.
- Map `MethodArgumentNotValidException` to `400 BAD_REQUEST` with field-level validation details.
- Map unhandled exceptions to `500 INTERNAL_SERVER_ERROR` with a safe error message.
- Build API error responses with the status, reason, message, request path, UTC timestamp, and an optional trace.
- Follow `spring-boot-error-code.instructions.md` when the API contract requires a stable error code.
- Keep validation-error handling distinct from domain-error handling.
- When validation failures return a different payload shape than the domain-error envelope (e.g., `List<ValidationError>`), document the intentional divergence in handler-level notes or API documentation.
- Control stack trace inclusion in `ErrorResponse` via the `server.error.include-stacktrace` configuration property.
- Include stack traces in error responses only when `server.error.include-stacktrace=always` is explicitly configured.
- Declare a named exception class for each distinct failure.

## Safety Guards
- Never expose credentials, tokens, raw SQL, internal implementation details, or unfiltered third-party exception messages in API error payloads.
- Never catch `Exception` unless the boundary translates unexpected failures or the handler maps them to a safe response.
- Never use HTTP 500 for predictable, named domain failures.
- Never instantiate anonymous subclasses of the base domain exception class.

## Reference
- Use [samples/spring-boot-app-exception.tpl](samples/spring-boot-app-exception.tpl) for the shared application exception.
- Use [samples/spring-boot-error-response.tpl](samples/spring-boot-error-response.tpl) for API error envelopes.
- Use [samples/spring-boot-validation-error.tpl](samples/spring-boot-validation-error.tpl) for field-level validation errors.
- Use [samples/spring-boot-global-exception-handler.tpl](samples/spring-boot-global-exception-handler.tpl) for centralized MVC API exception translation.
