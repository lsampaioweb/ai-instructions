---
description: "Spring Boot configuration contract for application.yml structure, profile overrides, immutable property records, and safe externalized configuration."
applyTo: "**/src/main/resources/application*.yml, **/src/main/java/**/*ConfigurationProperties.java, **/src/main/java/**/*Properties.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for property model structure and formatting.

## Naming Conventions
- Name property models after the feature they configure, using the `*ConfigurationProperties` or `*Properties` suffix.
- Use lowercase dot-separated property keys with a consistent root namespace prefix (e.g., `app.pagination.default-size`, `app.security.jwt.expiry`).
- Use camelCase record components that bind to YAML kebab-case keys.

## Rules

### File organization
- Use YAML format (`application.yml`) for all configuration files.
- Use `application.yml` as the base file shared across all profiles.
- Name profile overrides `application-{profile}.yml`, such as `application-development.yml` and `application-production.yml`.
- Keep profile files limited to keys whose effective values differ from `application.yml`.
- Use `production` as the default active profile, unless the user explicitly requests another default.

### Base file content and order
- Include `spring.application.name` (lowercase, matches pom.xml artifactId).
- Include `spring.threads.virtual.enabled: true` for Java 25 modules.
- Include `spring.profiles.active` with production active and development commented.
- Include `logging.config: "classpath:log/logback-spring.xml"`.
- Include `logging.file.*` for rolling policy configuration (max-size, max-history, total-size-cap).
- Include `spring.messages.basename` for i18n.
- Include `spring.devtools.restart.enabled: true` when `spring-boot-devtools` is declared.
- Configure `spring.datasource.hikari.*` with explicit pool sizing for JDBC modules.
- May include `spring.datasource.*` with environment variables for secrets.
- May include `spring.autoconfigure.exclude` when deliberately disabling features.
- Keep the section order as: spring -> logging -> management -> other settings.
- Verify every `logging.config` classpath location resolves to a tracked `logback-spring.xml` resource in the same module.
- Verify every active external integration has a deterministic test startup path that does not require the integration service unless the test is explicitly integration-scoped.

### Profile files
- Do not repeat properties from the base unless overriding them.
- Set `server.port: 8080` in `application-development.yml`.
- Set `server.port: 9443` in `application-production.yml`.
- Set `server.error.include-stacktrace: "always"` in `application-development.yml`.
- Set `server.error.include-stacktrace: "never"` as the safe base default in `application.yml`; do not repeat it in `application-production.yml`.
- Set `springdoc.swagger-ui.enabled: true` in `application-development.yml`.
- Set `springdoc.swagger-ui.enabled: false` as the safe base default in `application.yml`; do not repeat it in `application-production.yml`.
- Set `springdoc.api-docs.enabled: false` in production profiles when the API specification must not be publicly exposed.
- Add comments only for non-obvious settings where intent is not clear from the key name.

### Property models
- Bind each property model with `@ConfigurationProperties`.
- Prefer an immutable record for property models.
- Place a property model beside the domain or configuration code that consumes it.
- Map nested YAML objects to nested records.
- Map YAML sequences to `List<T>` components.
- Annotate `@ConfigurationProperties` classes with `@Validated` and use Bean Validation constraints (e.g., `@NotNull`, `@NotBlank`, `@Min`) on required fields when startup validation is required.
- Add a JavaDoc comment to every new `@ConfigurationProperties` field stating its purpose and the environment in which its value differs from the base default.

### Registration
- Keep one configuration-properties registration strategy per runnable module: either component-scanned properties classes or explicit `@EnableConfigurationProperties`, but not both.
- When using `@EnableConfigurationProperties`, register each `@ConfigurationProperties` class in the owning `@Configuration` class, not the main class.
- Check the owning configuration or application class whenever a property model is added or changed.

### Sensitive property models and values
- Use environment variable placeholders without defaults for sensitive attributes (credentials, usernames, passwords, tokens, private keys, connection secrets).
- Use environment variable placeholders without defaults in `application.yml` for runtime infrastructure selectors such as datasource URLs, broker URLs, and telemetry exporter endpoints.
- Use fail-fast configuration behavior for sensitive attributes so application startup fails when required sensitive environment values are missing.
- Allow default values only for non-sensitive values, such as `${DB_HOST:localhost}`.
- Keep local-development-only fallback values in `application-development.yml`, not in `application.yml`.
- Do not expose secret values through `toString()`, logs, errors, or diagnostics.

## Safety Guards
- Never commit real secrets, credentials, or private tokens in source-controlled configuration files.

## Reference
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for `application.yml`.
- Use [samples/spring-boot-application-development.tpl](samples/spring-boot-application-development.tpl) for `application-development.yml`.
- Use [samples/spring-boot-application-production.tpl](samples/spring-boot-application-production.tpl) for `application-production.yml`.
- Use [samples/spring-boot-configuration-properties.tpl](samples/spring-boot-configuration-properties.tpl) for an immutable property record.
- Use [samples/spring-boot-configuration.tpl](samples/spring-boot-configuration.tpl) for explicit property-model registration.
- Use [samples/spring-boot-configuration-yml.tpl](samples/spring-boot-configuration-yml.tpl) for matching YAML binding.
