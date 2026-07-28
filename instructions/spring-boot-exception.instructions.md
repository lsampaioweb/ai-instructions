---
description: "Spring Boot exception-handling contract for centralized response mapping, stable error payloads, and controlled failure semantics."
applyTo: "**/*Exception*.java,**/*ExceptionHandler*.java,**/*Advice*.java"
---

# Spring Boot Exception Engine

## Scope & Analysis
- Inspect exception hierarchy used by touched features.
- Inspect global exception handlers and HTTP mapping rules.
- Inspect error response payload structure and required fields.

## Naming Conventions
- Domain exceptions must be named with the `*Exception` suffix (e.g., `UserNotFoundException`, `InsufficientBalanceException`).
- Exception handler classes must be named with the `*ExceptionHandler` suffix (e.g., `UserExceptionHandler`, `PaymentExceptionHandler`).
- Use domain-specific exception names (never `AppException`, `CustomException`, or generic names).
- Global advice classes should use the `*Advice` suffix or `*ControllerAdvice` suffix (e.g., `GlobalControllerAdvice`, `ApiExceptionAdvice`).

## Resolution Rules
- Use centralized exception handling for API error responses.
- Keep a stable error response contract within each module or public API surface.
- Place exception handlers in the module root `exception` package or within the owning feature package; never create layer-based common/exception packages.
- Map domain exceptions to explicit HTTP status codes.
- For every custom domain exception type, add a corresponding `@ExceptionHandler` method that maps to an explicit HTTP status code and stable error response.
- Keep validation-error handling distinct from domain-error handling.
- When validation failures return a different payload shape (e.g., `List<ValidationError>`) than the domain-error envelope, document the intentional divergence in handler-level notes or API documentation.
- Keep exception-to-response mapping deterministic.
- Keep stack traces out of client-facing error payloads by default.

## Safety Guards
- Never leak internal stack traces to external clients by default.
- Never return generic 500 when a domain mapping is available.
- Never duplicate exception handling logic across controllers.
- Never silently return a different error payload shape without explicit documentation of the intentional divergence.

## Review Plan Layout
- Report handled exception types and mapped HTTP statuses.
- Report response payload fields added or changed.
- Report validation-failure behavior and payload shape.
- Report any unhandled exception paths found in scope.

