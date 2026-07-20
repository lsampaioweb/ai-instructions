---
description: "Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries in production-grade projects."
applyTo: "**/src/main/java/**/*Http*Client*.java, **/src/main/java/**/*Http*Adapter*.java, **/src/main/java/**/*Configuration*.java, **/src/main/java/**/config/**/*.java, **/src/main/resources/application*.yml, **/pom.xml"
---

# Spring Boot HTTP-Client Engine

## Scope & Analysis
- Inspect client configuration classes and external endpoint properties.
- Inspect service methods that perform outbound HTTP calls.
- Inspect error handling, timeouts, and response mapping behavior.

## Resolution Rules
- Keep outbound client configuration centralized in config classes.
- Keep endpoint URLs and credentials externalized in properties.
- Keep external-call initialization explicit and deterministic.
- Keep error handling explicit for non-success HTTP responses.
- Keep generic response mapping type-safe.
- Keep outbound request construction isolated from controller layer.

## Review Plan Layout
- Report client config and property changes.
- Report outbound call behavior changes and affected integrations.
- Report error and fallback behavior for remote failures.
- Report compatibility risks for external API contract changes.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never hardcode external URLs or secrets in service logic.
- Never ignore non-success responses from external APIs.
- Never mix outbound transport concerns into domain models.
