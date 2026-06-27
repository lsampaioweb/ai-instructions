---
description: "Configuration rules: mandatory profile files, @ConfigurationProperties, @Value policy, secrets pointer, and @Bean organization."
applyTo: "**/application*.yml, **/*ConfigurationProperties.java, **/*Configuration.java"
---

# Configuration Rules

## Files
- Use only `application.yml`; no `application.properties`
- **Mandatory three-file structure**:
  - `application.yml`: Shared settings (name, logging, management, messages, datasource, app properties)
  - `application-development.yml`: Dev overrides (port 8080, detailed error/health, swagger enabled)
  - `application-production.yml`: Prod overrides (strict error/health, swagger disabled)
- Set `spring.profiles.active: production` in base config with `development` commented; override with `SPRING_PROFILES_ACTIVE` environment variable if needed

## application.yml Template
```yaml
spring:
  application:
    name: "{app-name}"
  messages:
    basename: "i18n/messages"
  threads:
    virtual:
      enabled: true
  profiles:
    active:
      # - "development"
      - "production"
  datasource: ...  # if project uses DB
  rabbitmq: ...    # if project uses messaging

logging:
  config: "classpath:log/logback-spring.xml"

management:
  endpoints:
    web:
      exposure:
        include: "health,info"
  endpoint:
    health:
      show-details: "when-authorized"

app:
  {feature}: ...
```

## application-development.yml Template
```yaml
server:
  port: 8080
  error:
    include-stacktrace: "always"
management:
  endpoint:
    health:
      show-details: "always"
# include only when OpenAPI is part of the project scope
springdoc:
  swagger-ui:
    enabled: true
```

## application-production.yml Template
```yaml
server:
  port: 9443
  error:
    include-stacktrace: "never"
management:
  endpoint:
    health:
      show-details: "never"
# include only when OpenAPI is part of the project scope
springdoc:
  swagger-ui:
    enabled: false
```

## Rules
- **Base config**: Application name, logging, management, datasource/broker, app properties
- **Dev config**: Lower ports, verbose output
- **Prod config**: Strict output, explicit non-standard ports (e.g., 9443 instead of defaulting)
- **Never hardcode** in code: URLs, ports, queue names, endpoints; use `application*.yml` + `@ConfigurationProperties`
- Use `${VAR_NAME:default}` for environment-dependent values; avoid default values for credentials, tokens, and keys
- Virtual threads: Include `spring.threads.virtual.enabled: true` in base config
- Never put `spring.profiles.active` in profile files; only in base config
- Logging config path: `src/main/resources/log/logback-spring.xml`

## Secrets
Never hardcode credentials, tokens, or secrets. See `spring-boot-security.instructions.md`.

## Organization
- One `@Configuration` class = one concern (security, messaging, database, web, etc.)
- Each config class owns its `@Bean` definitions
- Use `@ConfigurationProperties` for related config groups; `@Value` for single properties only

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
