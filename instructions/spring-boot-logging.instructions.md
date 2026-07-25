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
- Keep sensitive data out of logs.
- Prefer parameterized log messages and use structured log fields when the active sink/aggregation tooling supports structured ingestion.
- Keep exception logs single-source to avoid duplication.

## Review Plan Layout
- Report new or changed log points with expected value.
- Report level changes and production impact.
- Report redaction controls for sensitive fields.
- Report removed noisy logs and reason.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never log credentials, tokens, or personal data.
- Never use error level for normal control flow.
- Never emit high-volume logs inside tight loops without need.
