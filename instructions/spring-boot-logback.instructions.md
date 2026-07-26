---
description: "Spring Boot Logback contract for sink routing, structured output, and resilient transport configuration in production-grade projects."
applyTo: "**/src/main/resources/log/logback-spring.xml, **/pom.xml"
---

# Spring Boot Logback Engine

## Scope & Analysis
- Inspect appenders, encoders, loggers, and root level.
- Inspect profile-specific overrides and environment behavior.
- Detect conflicting logger levels and duplicate appenders.

## Resolution Rules
- Keep root level conservative for production safety.
- Configure package logger levels by operational need.
- Keep appender responsibilities explicit and non-overlapping.
- Keep application name and log directory sourced from Spring properties.
- Keep file sinks behind an async appender boundary for non-trivial workloads.
- Keep rotation policy bounded for disk safety.
- Keep rotation limits explicit (file size, retention history, and total size cap).
- Use structured encoders when log aggregation requires them.
- Keep profile overrides minimal and intentional.
- Keep production/default profiles routed to file appenders by default; use console output in debug/development profiles unless explicitly required.

## Review Plan Layout
- Report appender changes and routing impact.
- Report level changes and expected signal-to-noise effect.
- Report profile-specific differences and rationale.
- Report rotation and retention decisions.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never route sensitive data to unprotected appenders.
- Never disable error logging for application failures.
- Never ship debug-heavy defaults for production profiles.
