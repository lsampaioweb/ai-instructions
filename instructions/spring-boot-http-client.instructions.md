---
description: "HTTP client rules: RestClient setup, configuration, and usage patterns for calling external APIs."
applyTo: "**/*Client.java, **/*ApiClient.java, **/*HttpClient.java"
---

# HTTP Client Rules

## RestClient
- Use `RestClient` (Spring 6.1+) as the HTTP client for all outbound API calls; never use `RestTemplate` or third-party HTTP clients unless `RestClient` cannot provide a required capability

## Configuration
- Declare external API base URLs in `application.yml` under a dedicated key group (e.g. `external.api.*`) and bind them with `@ConfigurationProperties`
- Inject `RestClient.Builder` and a typed `@ConfigurationProperties` class (e.g. `{Feature}ApiProperties`) via constructor; do not instantiate `RestClient` directly and never use `@Value` for domain-specific URL settings
- Initialize the `RestClient` instance in a `@PostConstruct` method using `restClientBuilder.baseUrl(url).build()`; see `## Templates` for the full setup

## Usage
- Return `Optional.ofNullable(result)` for single-resource responses that may be absent
- Use `.retrieve().body(Type.class)` for typed responses
- Use `.retrieve().toBodilessEntity()` for responses with no body (e.g. DELETE)
- Set `Content-Type` explicitly on requests with a body: `.contentType(MediaType.APPLICATION_JSON)`

## Error Handling
- Catch `RestClientException` and its subtypes when you need to translate HTTP errors into domain exceptions; let unexpected exceptions propagate to `@RestControllerAdvice`

## Templates

**API client setup.** Replace `{Feature}` and the properties type with actual values.

```java
@Service
class {Feature}ApiClient {

  private final RestClient.Builder restClientBuilder;
  private final {Feature}ApiProperties apiProperties;
  private RestClient restClient;

  {Feature}ApiClient(RestClient.Builder restClientBuilder, {Feature}ApiProperties apiProperties) {
    this.restClientBuilder = restClientBuilder;
    this.apiProperties = apiProperties;
  }

  @PostConstruct
  private void init() {
    this.restClient = restClientBuilder.baseUrl(apiProperties.baseUrl()).build();
  }
}
```

```java
@ConfigurationProperties(prefix = "external.api.{feature}")
public record {Feature}ApiProperties(String baseUrl) {}
```
