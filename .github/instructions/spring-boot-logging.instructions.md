---
description: "Spring Boot logging contract for secure, consistent, and operationally useful application log events in production-grade projects."
applyTo: "**/src/main/java/**/*.java, **/src/test/java/**/*.java"
---

# Spring Boot Logging Engine

## Scope & Analysis
- Inspect log statements in touched code paths.
- Classify logs by level, intent, and operational value.
- Detect noisy, duplicate, or context-free log lines.

## Resolution Rules
- Log events with clear operational value.
- Use consistent level semantics across features.
- Include correlation identifiers when available.
- Add the request correlation identifier to MDC under the key `traceId` before processing begins; make it automatically available in all log statements within the request thread.
- Keep sensitive data out of logs.
- Prefer parameterized log messages and use structured log fields when the active sink/aggregation tooling supports structured ingestion.
- Keep exception logs single-source to avoid duplication.
- Log unexpected exceptions (unmapped, unhandled) at ERROR level; log known domain failures that map to 4xx responses at WARN level; never use ERROR level for client errors.
- Prefer `@Slf4j` for logger declaration when Lombok is available in the module.
- When a `LogMessages` component is available in the module, use it for user-facing log message resolution; for debug and trace technical log lines where no message key applies, use `@Slf4j` directly; defer LogMessages structure and locale behavior to `spring-boot-i18n.instructions.md`.
- In controller classes, log only warning/error conditions; never log success paths.
- In service classes, log business state transitions (for example create, update, delete) at info level with stable resource identifiers.
- In repository classes, log degraded execution paths (for example SQL feature fallback) at warn level; never log success paths.

## Safety Guards
- Never log credentials, tokens, or personal data.
- Never use error level for normal control flow.
- Never emit high-volume logs inside tight loops without need.
- Never replace `@Slf4j` with manual logger fields unless the user explicitly requests that change.
- Never log the same failure event at multiple layers when one layer already emits the full diagnostic context.

## Review Plan Layout
- Report new or changed log points with expected value.
- Report level changes and production impact.
- Report redaction controls for sensitive fields.
- Report removed noisy logs and reason.

