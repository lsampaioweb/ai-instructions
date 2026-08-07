---
description: "Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries in production-grade projects."
applyTo: "**/src/main/java/**/*Http*Client*.java, **/src/main/java/**/*Http*Adapter*.java, **/src/main/java/**/config/**/*Http*Configuration*.java, **/src/main/java/**/config/**/*Http*Properties*.java, **/src/main/resources/application*.yml"
---

# Spring Boot HTTP-Client Engine

## Scope & Analysis
- Inspect client configuration classes and external endpoint properties.
- Inspect service methods that perform outbound HTTP calls.
- Inspect error handling, timeouts, and response mapping behavior.

## Dependencies
- For RestTemplate-based outbound calls (imperative), no dedicated starter required (available in `spring-boot-starter-web` or `spring-boot-starter-webmvc`).
- For WebClient-based outbound calls (reactive), add `spring-boot-starter-webflux` dependency in pom.xml.
- For HTTP client resilience with retry and circuit breaker patterns, add `resilience4j-spring-boot3` or `spring-cloud-starter-circuitbreaker-resilience4j` when failure recovery is required.

## Resolution Rules
- Keep outbound client configuration centralized in config classes.
- Use `RestClient` (Spring Framework 6.1+) as the default for imperative HTTP calls; use `WebClient` only when reactive streams are required.
- Keep endpoint URLs and credentials externalized in properties.
- Keep external-call initialization explicit and deterministic.
- Keep outbound connection and read timeout values explicit and externally configurable for all integrations with externally owned APIs.
- Use `connectionTimeout=5s` and `readTimeout=30s` as default timeout values unless the remote API's SLA explicitly requires different values.
- Keep error handling explicit for non-success HTTP responses.
- Keep status-specific failure mapping explicit when remote APIs expose known error classes.
- Apply retry logic only for idempotent HTTP methods (GET, PUT, DELETE, HEAD); never auto-retry POST or PATCH without explicit idempotency confirmation from the remote API.
- Keep generic response mapping type-safe.
- Keep outbound request construction isolated from controller layer.

## Safety Guards
- Never hardcode external URLs or secrets in service logic.
- Never ignore non-success responses from external APIs.
- Never mix outbound transport concerns into domain models.
- Never disable SSL/TLS certificate verification for outbound HTTP connections.

## Review Plan Layout
- Report client config and property changes.
- Report outbound call behavior changes and affected integrations.
- Report error and fallback behavior for remote failures.
- Report compatibility risks for external API contract changes.

