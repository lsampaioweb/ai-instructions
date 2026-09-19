---
description: "Spring RestClient/WebClient configuration, outbound HTTP calls, response mapping, error handling, and integration tests."
applyTo: "**/*HttpClient*.java, **/*RestClient*.java, **/*ExternalApi*.java, **/http_client/**/*Service*.java, **/*VaultSecretService.java, **/src/main/java/**/*HttpAdapter*.java, **/src/main/java/**/*HttpConfiguration*.java, **/src/main/java/**/*HttpProperties*.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for formatting, imports, visibility, injection, constants, and JavaDoc.
- Follow `spring-boot-pagination.instructions.md` when a RestClient proxies a paginated collection.

## Naming Conventions
- Name a client configuration class after the integration, such as `HttpClientConfiguration`, `VaultConfiguration`, or `{Feature}HttpConfiguration`.
- Name configuration properties after the remote integration, using the `HttpProperties` suffix, such as `ExternalApiProperties` or `VaultHttpClientProperties`.
- Name a configured client bean after the remote system, such as `vaultRestClient`.
- Suffix HTTP client classes with `HttpClient` and HTTP adapter classes with `HttpAdapter`.
- Name endpoint constants after their purpose, such as `ID_PARAMETER` or `RESPONSE_FIELD_DATA`.

## Rules

### Client configuration
- Use Spring `RestClient` (Spring Framework 6.1+) as the default for imperative outbound HTTP calls.
- Use `WebClient` only when reactive streams are required.
- Keep outbound client configuration centralized in a dedicated configuration class.
- Provide a `RestClient.Builder` bean for integrations that configure the base URL in their service.
- Create a dedicated `RestClient` bean when an integration requires a shared base URL, headers, request factory, or timeout configuration.
- Inject `RestClient.Builder` into the `*HttpClient` class and construct the `RestClient` instance in a `@PostConstruct` method using the bound properties.
- Bind HTTP client properties using `@ConfigurationProperties` annotated with `@Validated`.
- Read base URLs, endpoint templates, timeouts, and credentials from configuration properties; do not hardcode environment-specific values.
- Use `connectionTimeout=5s` and `readTimeout=30s` as default timeout values unless the remote API's SLA explicitly requires different values.
- Configure constant integration headers with `defaultHeader(...)` when every request requires them.
- Keep credentials out of source code and pass authentication values through external configuration.

### Outbound requests
- Build the `RestClient` from its injected builder or dedicated client bean; do not construct a separate client for each request.
- Use `get()`, `post()`, `put()`, or `delete()` to match the upstream HTTP operation.
- Use `uri(...)` path variables or `UriComponentsBuilder` query parameters rather than concatenating dynamic query strings.
- Set `MediaType.APPLICATION_JSON` for JSON request bodies.
- Deserialize simple response bodies directly to their target type.
- Use `ParameterizedTypeReference` for all generic response types (e.g., `List<T>`, `PagedModel<EntityModel<T>>`) to preserve type information at deserialization.
- Use `toBodilessEntity()` when only the upstream status is required.
- Handle an absent response body explicitly when the calling contract permits it.

### Response mapping and errors
- Keep remote calls, response mapping, and remote error translation in the service that owns the integration.
- Map upstream transport models to local response models before returning them from the service.
- Preserve HATEOAS page metadata, collection links, and item links when mapping a proxied `PagedModel`.
- Register `.onStatus(...)` handlers on every `RestClient` call chain to map HTTP error responses to domain exceptions before they propagate to the service caller.
- Map known remote API error classes to named feature-scoped exceptions in the `.onStatus()` handler.
- Translate expected remote failures to localized project error messages without exposing credentials or raw remote payloads.
- Validate required response structure before accessing nested values and fail with a domain-specific error when a required value is absent.
- Apply retry logic only for idempotent HTTP methods (GET, PUT, DELETE, HEAD), or for POST/PATCH when the remote API explicitly confirms idempotency.

### Verification
- Test outbound HTTP services with `MockRestServiceServer` bound to the `RestClient.Builder`.
- Assert the HTTP method and request URI for each tested remote interaction.
- Verify the mock server after the behavior under test completes.
- Test successful responses, expected HTTP status failures, absent bodies, and malformed required response data when those outcomes are part of the integration contract.

## Safety Guards
- Never mix outbound transport concerns into domain models.
- Never disable SSL/TLS certificate verification for outbound HTTP connections.
- Never log outbound request bodies or authorization headers.

## Reference
- Use [samples/spring-boot-http-client.tpl](samples/spring-boot-http-client.tpl) for the canonical configured `RestClient` structure.
