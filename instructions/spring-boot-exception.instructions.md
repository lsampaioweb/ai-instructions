---
description: "Spring Boot exception-handling contract for centralized response mapping, stable error payloads, and controlled failure semantics."
applyTo: "**/*Exception*.java,**/*ExceptionHandler*.java,**/*Advice*.java"
---

# Spring Boot Exception Engine

## Scope & Analysis
- Inspect exception hierarchy used by touched features.
- Inspect global exception handlers and HTTP mapping rules.
- Inspect error response payload structure and required fields.

## Resolution Rules
- Use centralized exception handling for API error responses.
- Keep a stable error response contract within each module or public API surface.
- Map domain exceptions to explicit HTTP status codes.
- Keep validation-error handling distinct from domain-error handling.
- When validation failures return a different payload shape (e.g., `List<ValidationError>`) than the domain-error envelope, document the intentional divergence in handler-level notes or API documentation.
- Keep exception-to-response mapping deterministic.
- Keep stack traces out of client-facing error payloads by default.

## Review Plan Layout
- Report handled exception types and mapped HTTP statuses.
- Report response payload fields added or changed.
- Report validation-failure behavior and payload shape.
- Report any unhandled exception paths found in scope.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never leak internal stack traces to external clients by default.
- Never return generic 500 when a domain mapping is available.
- Never duplicate exception handling logic across controllers.
- Never silently return a different error payload shape without explicit documentation of the intentional divergence.
