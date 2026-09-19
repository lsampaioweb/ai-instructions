---
description: "Stable API error codes, localized error message keys, and error-code response mapping."
applyTo: "**/*Exception.java, **/GlobalExceptionHandler.java, **/ErrorResponse.java, **/*ErrorCode*Test.java, **/src/main/java/**/*ErrorCode.java"
---

## Dependencies
- Follow `spring-boot-exception.instructions.md` for exception hierarchy, HTTP exception translation, and safe error payloads.
- Follow `spring-boot-i18n.instructions.md` for localized `error.*` message bundles and bundle consistency.
- Follow `spring-boot-model.instructions.md` for error response records.

## Naming Conventions
- Name error-code enums or constants with the `*ErrorCode` suffix (e.g., `HolidayErrorCode`, `PaymentErrorCode`).
- Use UPPER_SNAKE_CASE for all error-code enum values, including the resource or domain name as a prefix to prevent ambiguity across modules (e.g., `HOLIDAY_NOT_FOUND`, not `NOT_FOUND`).
- Use domain-specific error-code catalog names (never `AppErrorCode`, `CommonErrorCode`, or `GeneralErrorCode`).
- Name localized error message keys with the `error.` prefix and a lowercase domain-specific path, such as `error.user.not.found` or `error.vault.response.empty`.
- Name Java constants for localized error message keys with the `ERROR_` prefix in `UPPER_SNAKE_CASE`.

## Rules

### Localized error message keys
- Declare reusable localized error message keys as named constants in the owning Java class.
- Follow `spring-boot-i18n.instructions.md` for `error.*` bundle keys, placeholder arity, and locale coverage.
- Pass interpolation arguments in the same semantic order as the message-key placeholders.
- Resolve user-facing error messages through `MessageSource` using the active locale.
- Do not expose a localized message key directly as an API error message.

### Stable API error codes
- Keep error codes stable after public release.
- Keep message keys separate from error codes.
- Map each error code to exactly one failure scenario.
- When adding a new failure path, declare the error code constant in the `*ErrorCode` enum before writing any code that references it.
- Add an `errorCode` field to `ErrorResponse` only when API clients need stable programmatic error classification.
- Keep stable error codes independent from localized message text and message keys.
- Format the `errorCode` field, when exposed, as the UPPER_SNAKE_CASE enum constant name.
- Use one canonical error-code strategy per module: either a dedicated `*ErrorCode` catalog or handler-local constants, but not both.
- Use a dedicated `*ErrorCode` catalog when error-code values are shared across multiple exception types or handlers in the same module.
- Use handler-local constants only when error-code ownership is isolated to a single handler.
- Scope each `*ErrorCode` catalog to a single feature; create separate `*ErrorCode` catalogs per feature when a module has multiple resources with distinct failure domains.
- Create a module-level error code catalog (e.g., `ApiErrorCode`) in `shared` for HTTP-framework failures that are not owned by any feature, such as unmapped routes, request validation, and unexpected server errors.
- Resolve a domain exception to its stable error code in the centralized exception handler.
- Add stable-error-code resolution to the canonical `GlobalExceptionHandler` in [samples/spring-boot-global-exception-handler.tpl](samples/spring-boot-global-exception-handler.tpl); do not define a second exception-handler class.
- Return the same stable error code regardless of the active locale.
- When retiring an error code, annotate it `@Deprecated`, keep it active for at least one major version, and document the replacement code in the deprecation annotation.

### Verification
- When an endpoint exposes stable error codes, test each API error-code mapping.
- When an endpoint exposes stable error codes, test that localized error messages change with locale without changing the stable error code.
- Test that error-code responses do not expose credentials, tokens, raw remote payloads, or internal implementation details.

## Safety Guards
- Never use a feature-scoped error code (e.g., `HolidayErrorCode`) in a shared exception handler for failures that are not owned by that feature.

## Reference
- Use [samples/spring-boot-error-code.tpl](samples/spring-boot-error-code.tpl) for stable error-code response mapping.
- Use [samples/spring-boot-error-code-response.tpl](samples/spring-boot-error-code-response.tpl) when an API error response exposes `errorCode`.
- Use [samples/spring-boot-app-exception.tpl](samples/spring-boot-app-exception.tpl) for application exception message keys and arguments.
