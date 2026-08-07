---
description: "Spring Boot Logback contract for sink routing, structured output, and resilient transport configuration in production-grade projects."
applyTo: "**/src/main/resources/**/logback-spring.xml, **/pom.xml"
---

# Spring Boot Logback Engine

## Scope & Analysis
- Inspect appenders, encoders, loggers, and root level.
- Inspect profile-specific overrides and environment behavior.
- Detect conflicting logger levels and duplicate appenders.

## Resolution Rules
- Keep root level conservative for production safety.
- Set root log level to `INFO` for production profiles and `DEBUG` for development profiles.
- Configure package logger levels by operational need.
- Keep application name and log directory sourced from Spring properties.
- Keep appender responsibilities explicit and non-overlapping.
- Keep file sinks behind an async appender boundary for non-trivial workloads.
- Configure async appender with `queueSize=512` and `discardingThreshold=0`; never silently discard log events.
- Keep rotation policy bounded for disk safety.
- Keep rotation limits explicit (file size, retention history, and total size cap).
- Set file rotation limits to `10MB` max file size, `30` days retention history, and `1GB` total size cap as defaults unless operational requirements differ.
- Use structured encoders when log aggregation requires them.
- Keep profile overrides minimal and intentional.
- Keep production/default profiles routed to file appenders by default; use console output in debug/development profiles unless explicitly required.

## Safety Guards
- Never route sensitive data to unprotected appenders.
- Never disable error logging for application failures.
- Never ship debug-heavy defaults for production profiles.

## Review Plan Layout
- Report appender changes and routing impact.
- Report level changes and expected signal-to-noise effect.
- Report profile-specific differences and rationale.
- Report rotation and retention decisions.

