---
description: "Spring Boot exception-handling contract for centralized response mapping, stable error payloads, and controlled failure semantics."
applyTo: "**/*Exception*.java, **/*ExceptionHandler*.java, **/*Advice*.java"
---

# Spring Boot Exception Engine

## Naming Conventions
- Name domain exception classes with the `*Exception` suffix (e.g., `HolidayNotFoundException`, `DuplicateHolidayException`).
- Name exception handler classes with the `*ExceptionHandler` suffix (e.g., `HolidayExceptionHandler`).
- Name global advice classes with the `*Advice` suffix or `*ControllerAdvice` suffix (e.g., `GlobalControllerAdvice`, `ApiExceptionAdvice`).
- Use domain-specific exception names (never `AppException` or `CustomException`).

## Rules
- Use centralized exception handling for all API error responses.
- Annotate global REST exception handling classes with `@RestControllerAdvice`, not `@ControllerAdvice`.
- Define a stable error response DTO with at minimum `timestamp`, `status` (HTTP status code), `error` (brief reason phrase), `message` (user-facing i18n text), and `path` (request URI) as required fields.
- Place feature-specific exception classes in the owning feature package.
- For `@RestControllerAdvice` and shared error-DTO placement, defer to `spring-boot-architecture.instructions.md`.
- Extend all domain exceptions from a common base exception class (e.g., `DomainException`) to enable a shared base `@ExceptionHandler` and consistent HTTP status derivation.
- Declare the base domain exception class as `abstract`.
- Embed `HttpStatus` and an i18n message key in the base exception constructor; resolve the message in the handler via `MessageSource`.
- Map not-found failures to HTTP 404, invalid-input failures to HTTP 400, conflict failures to HTTP 409, and forbidden failures to HTTP 403.
- Add a single `@ExceptionHandler` for the base exception type that reads `ex.getStatus()` and resolves the user-facing message via `MessageSource`.
- Add `@ExceptionHandler(NoResourceFoundException.class)` in the global advice to return a structured 404 error response for unmapped routes.
- Keep validation-error handling distinct from domain-error handling.
- When validation failures return a different payload shape than the domain-error envelope (e.g., `List<ValidationError>`), document the intentional divergence in handler-level notes or API documentation.
- Control stack trace inclusion in `ErrorResponse` via the `server.error.include-stacktrace` configuration property.
- Include stack traces in error responses only when `server.error.include-stacktrace=always` is explicitly configured.
- Declare a named exception class for each distinct failure.

## Safety Guards
- Never use HTTP 500 for predictable, named domain failures.
- Never instantiate anonymous subclasses of the base domain exception class.
