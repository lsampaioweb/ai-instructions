---
description: "Error code rules: machine-readable API error codes, ErrorResponse contract, and OpenAPI documentation."
applyTo: "**/*Exception.java, **/*ControllerAdvice.java, **/*ExceptionHandler.java, **/*ErrorResponse.java, **/*Controller.java, **/*Api.java, **/*OpenApiConfig*.java, **/*SwaggerConfig*.java"
---

# Error Code Rules

## Scope
- Use this file as the canonical source for machine-readable error codes in API responses.

## ErrorResponse Contract
- Include `errorCode` in `ErrorResponse` for every error response that uses the standard error payload.
- Keep `errorCode` stable and machine-readable (for example: `COUNTRY_NOT_FOUND`, `VALIDATION_FAILED`, `FOREIGN_KEY_CONFLICT`).
- Keep `errorCode` independent from localized user-facing message text.
- Do not derive `errorCode` by parsing `message` text.

## Mapping Rules
- Define one deterministic `errorCode` per domain exception type.
- Keep mapping logic centralized in the global exception handler.
- For unknown exceptions, return a generic fallback code (for example: `INTERNAL_ERROR`).
- Keep fallback behavior consistent across environments.

## Naming Conventions
- Use uppercase snake case for `errorCode` values.
- Keep codes domain-oriented and action-neutral.
- Avoid embedding transport details (HTTP status numbers) into code names.

## Validation Errors
- Return a dedicated top-level code for request validation failures (for example: `VALIDATION_FAILED`).
- Keep field-level validation details separate from `errorCode`.

## OpenAPI Documentation
- Document `errorCode` in the `ErrorResponse` schema.
- For explicitly annotated endpoints, include representative error codes in response examples.
- Keep documented codes synchronized with actual exception mappings.

## Compatibility Policy
- Treat removal or renaming of published error codes as a breaking change.
- Prefer additive evolution: introduce new codes while preserving existing codes when possible.
