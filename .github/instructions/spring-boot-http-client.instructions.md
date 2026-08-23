---
description: "Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries."
applyTo: "**/src/main/java/**/*HttpClient*.java, **/src/main/java/**/*HttpAdapter*.java, **/src/main/java/**/*HttpConfiguration*.java, **/src/main/java/**/*HttpProperties*.java"
---

# Spring Boot HTTP Client

## Naming Conventions
- Suffix HTTP client classes with `HttpClient`.
- Suffix HTTP adapter classes with `HttpAdapter`.
- Suffix HTTP configuration properties classes with `HttpProperties`.
- Name HTTP client `@Configuration` classes with the `*HttpConfiguration` suffix (e.g., `UserHttpConfiguration`, `PaymentHttpConfiguration`).

## Rules
- Keep outbound client configuration centralized in a dedicated configuration class.
- Use `RestClient` (Spring Framework 6.1+) as the default for imperative HTTP calls.
- Use `WebClient` only when reactive streams are required.
- Keep endpoint URLs and credentials externalized in properties.
- Bind HTTP client properties using `@ConfigurationProperties` annotated with `@Validated`.
- Inject `RestClient.Builder` into the `*HttpClient` class and construct the `RestClient` instance in a `@PostConstruct` method using the bound properties.
- Use `connectionTimeout=5s` and `readTimeout=30s` as default timeout values unless the remote API's SLA explicitly requires different values.
- Register `.onStatus()` handlers on every `RestClient` call chain to map HTTP error responses to domain exceptions before they propagate to the service caller.
- Map known remote API error classes to named feature-scoped exceptions in the `.onStatus()` handler.
- Apply retry logic only for idempotent HTTP methods (GET, PUT, DELETE, HEAD), or for POST/PATCH when the remote API explicitly confirms idempotency.
- Use `ParameterizedTypeReference` for all generic response types (e.g., `List<T>`, `PagedModel<EntityModel<T>>`) to preserve type information at deserialization.
- Use `UriComponentsBuilder` for all dynamic URL construction in outbound calls.

## Safety Guards
- Never mix outbound transport concerns into domain models.
- Never disable SSL/TLS certificate verification for outbound HTTP connections.
- Never log outbound request bodies or authorization headers.
