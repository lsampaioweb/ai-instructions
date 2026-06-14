---
description: "Configuration rules: mandatory profile files, @ConfigurationProperties, @Value policy, secrets pointer, and @Bean organization."
applyTo: "**/application*.yml, **/*ConfigurationProperties.java, **/*Configuration.java"
---

# Configuration Rules

## Files
- Use `application.yml` as the only configuration format; do not use `application.properties`
- These three profile files are mandatory in every project: `application.yml` (shared defaults), `application-development.yml` and `application-production.yml`
- Set `spring.profiles.active: "production"` in `application.yml` as the default active profile; override it with the `SPRING_PROFILES_ACTIVE` environment variable or `--spring.profiles.active` argument at runtime
- Keep `development` visible in `application.yml` as a commented option under `spring.profiles.active` when using list form, with `production` as the single uncommented default entry

## Binding
- Bind groups of related settings (paths, directories, URLs) to a `@ConfigurationProperties` class; use `@Value` only for single isolated properties that do not belong to a larger config group
- Never hardcode environment-dependent URLs, hosts, ports, queue names, routing keys, file paths, or endpoint roots in Java code; store them in `application*.yml` and bind via `@ConfigurationProperties`

## Secrets
Never hardcode credentials, tokens, or secrets in configuration files or code. See `spring-boot-security.instructions.md` for the full secrets rule.

## Organization
- Keep each `@Configuration` class focused on one concern (security, messaging, persistence, web, etc.)
- Each `@Configuration` class owns its own `@Bean` definitions; do not scatter beans across unrelated classes

## YAML Section Ordering
- In every `application*.yml`, place shared/system sections first (`spring`, `management`, `server`, `logging`), and put application-specific blocks (`app.*`) after them
- Keep section order stable across profile files to reduce cognitive load during review

## Logging
Always declare the logging configuration file in `application.yml`:

```yaml
logging:
  config: "classpath:log/logback-spring.xml"
```

Place the `logback-spring.xml` file under `src/main/resources/log/`.

## Server
- Always set `server.port` explicitly in `application.yml`; do not rely on the Spring Boot default of 8080
- Enable virtual threads in `application.yml`:

```yaml
spring:
  threads:
    virtual:
      enabled: true
```

## Database
Only add database configuration when the project requires a database — confirm this before generating any datasource code. Configure the datasource using environment variables with fallback defaults where appropriate. Use Hikari as the connection pool with these baseline settings:

```yaml
spring:
  datasource:
    url: "jdbc:postgresql://${DB_HOST:localhost}:${DB_PORT:5432}/${DB_NAME}"
    username: "${DB_USER}"
    password: "${DB_PASSWORD}"
    hikari:
      maximum-pool-size: 10
      minimum-idle: 2
      idle-timeout: 30000
      connection-timeout: 20000
```

Standard environment variable names: `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`.

## Templates

`@ConfigurationProperties` record. Replace `app.{feature}` with the actual prefix, and adjust fields to match the project's configuration group. Register the class with `@EnableConfigurationProperties` on a `@Configuration` class.

```java
@ConfigurationProperties(prefix = "app.{feature}")
public record {Feature}ConfigurationProperties(String baseUrl, Duration timeout, int maxRetries) {}
```

Corresponding YAML block (in `application.yml` or the appropriate profile file):

```yaml
# Replace feature, property names, and env var names with actual values.
app:
  {feature}:
    base-url: "${FEATURE_BASE_URL}"
    timeout: "5s"
    max-retries: 3
```

Enable the properties class:

```java
@Configuration
@EnableConfigurationProperties({Feature}ConfigurationProperties.class)
class {Feature}Configuration {
    // @Bean definitions that depend on {Feature}ConfigurationProperties go here
}
```
