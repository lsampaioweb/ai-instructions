---
description: "HTTP client rules: RestClient setup, configuration, and usage patterns for calling external APIs."
applyTo: "**/*Client.java, **/*ApiClient.java, **/*HttpClient.java"
---

# HTTP Client Rules

## Message i18n
HTTP client error handling must follow i18n principles: if an error message is shown to operators (logged or thrown as an exception), define it as an i18n key in `messages.properties` and resolve it via `LogMessages`; never hardcode error message text in client classes.
For shared operator-facing message-key conventions, follow `spring-boot-logging.instructions.md`.

## RestClient
- Use `RestClient` (Spring 6.1+) as the HTTP client for all outbound API calls; never use `RestTemplate` or third-party HTTP clients unless `RestClient` cannot provide a required capability

## Configuration
- Declare external API base URLs in `application.yml` under a dedicated key group (e.g. `external.api.*`) and bind them with `@ConfigurationProperties`
- Inject `RestClient.Builder` and a typed `@ConfigurationProperties` class (e.g. `{Feature}ApiProperties`) via constructor; do not instantiate `RestClient` directly and never use `@Value` for domain-specific URL settings
- Initialize the `RestClient` instance at construction time by default using `restClientBuilder.baseUrl(url).build()`; use `@PostConstruct` only when deferred initialization is required

## Usage
- Return `Optional.ofNullable(result)` when missing resources are a valid domain outcome; otherwise translate null/empty responses to a domain exception
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
