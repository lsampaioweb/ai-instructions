---
description: "Spring Boot error-code contract for deterministic machine-readable API error semantics and stable message-key mapping."
applyTo: "**/src/main/java/**/*ErrorCode.java, **/src/main/java/**/*Exception*.java, **/src/main/resources/i18n/messages*.properties"
---

# Spring Boot Error-Code Engine

## Scope & Analysis
- Inspect exception handlers, domain exceptions, and error response models.
- Inspect message bundles for error key naming and placeholder consistency.
- Inspect where each module owns machine-readable error codes.

## Resolution Rules
- Keep error codes stable after public release.
- Keep message keys separate from error codes.
- Resolve user-facing error messages through i18n message keys.
- Keep placeholder count and order consistent across locales.
- Keep one canonical mapping from error code to failure scenario.
- Keep each module's active error-code ownership explicit.
- Prefer a dedicated `ErrorCode` catalog when the module already defines one.
- Keep one canonical error-code strategy per module: dedicated `ErrorCode` catalog or handler-local constants.
- Use a dedicated `ErrorCode` catalog when error-code values are shared across multiple exception types or handlers in the same module.
- Allow handler-local constants when error-code ownership is isolated to a single handler and remains explicit.
- Keep machine-readable error-code fields explicit only for modules whose public error payload contract exposes an `errorCode` property.
- Keep error-code declarations out of service orchestration logic.

## Review Plan Layout
- Report new or changed error codes with owning module.
- Report whether each touched module uses an `ErrorCode` catalog or handler-local constants.
- Report key-to-code mappings added or changed.
- Report placeholder compatibility checks across locales.
- Report deprecated error codes and migration notes.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never reuse one error code for different failure scenarios.
- Never scatter the same error-code declaration across multiple classes in one module.
- Never hardcode translated error text in exception classes.
- Never remove active error codes without compatibility plan.
