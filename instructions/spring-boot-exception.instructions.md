---
description: "Spring Boot exception contract for centralized, secure, and deterministic API error handling in production-grade projects."
applyTo: "**/src/main/java/**/*AppException.java, **/src/main/java/**/*GlobalExceptionHandler.java, **/src/main/java/**/*ErrorResponse.java, **/src/main/java/**/*ValidationError.java, **/src/main/java/**/*Exception.java"
---

# Spring Boot Exception Contract
Use this file to enforce exception structure and API error behavior.

## Ownership Boundary
1. Keep all exception-handling behavior rules in this file.
2. Keep machine-readable error-code taxonomy and mapping rules in spring-boot-error-code.instructions.md.
3. When applying error-code behavior, consume this file first, then the error-code file.

## File and Class Conventions
1. Keep exception artifacts in src/main/java/<base-package>/<feature-or-common> and avoid technical sub-packages such as exception.
2. Keep a centralized handler class named GlobalExceptionHandler.
3. Keep the base application exception type named AppException.
4. Keep transport error payload type named ErrorResponse.
5. Keep field validation payload type named ValidationError when validation details are returned.

## Domain Exception Model
1. Keep domain exceptions extending AppException.
2. Store message key, optional message arguments, and target HTTP status in application exceptions.
3. Keep domain exceptions free from web framework response construction.
4. Keep cause chaining when wrapping infrastructure exceptions.

## Centralized Handler Rules
1. Handle application exceptions in a centralized @RestControllerAdvice.
2. Handle validation exceptions explicitly and return deterministic field-level details.
3. Handle unknown exceptions with a generic localized message and stable error semantics.
4. Do not return raw internal exception messages to API clients for generic failures.
5. Log server-side exception details while keeping client payloads safe.

## Error Payload Semantics
1. Keep HTTP status and reason aligned with exception mapping.
2. Keep timestamps in a deterministic zone format.
3. Keep request path included in API error responses.
4. Keep optional stacktrace exposure controlled by explicit configuration.

## i18n and Error Codes
1. Resolve user-facing error messages through MessageSource and request locale.
2. Keep machine-readable error codes stable and independent from localized text.
3. Do not expose unresolved message keys in API payloads.
4. Delegate error-code taxonomy and centralized mapping policy to spring-boot-error-code.instructions.md.

## Security and Reliability
1. Keep internal stack traces hidden by default in production profiles.
2. Avoid leaking infrastructure details, SQL text, or credentials in API error payloads.
3. Ensure exception handling failures do not replace primary business responses with ambiguous errors.

## Testing Requirements
1. Validate mapped status and payload shape for domain exceptions.
2. Validate localization behavior for at least one non-default locale.
3. Validate generic error fallback behavior and stacktrace exposure policy.
