---
description: "Configuration rules: mandatory profile files, @ConfigurationProperties, @Value policy, secrets pointer, and @Bean organization."
applyTo: "**/application*.yml, **/*ConfigurationProperties.java, **/*Configuration.java"
---

# Configuration Rules

## Files
- Use only `application.yml`; no `application.properties`
- **Three-file configuration structure**:
  - `application.yml`: Shared settings (name, logging, management, messages, datasource, app properties)
  - `application-development.yml`: Dev overrides (port 8080, detailed error/health, swagger enabled)
  - `application-production.yml`: Prod overrides (strict error/health, swagger disabled)
- For new project slices, create all three files
- For existing projects, enforce this structure only when the requested change touches configuration concerns
- Set `spring.profiles.active: production` in base config with `development` commented; override with `SPRING_PROFILES_ACTIVE` environment variable if needed

## YAML Skeletons

See `snippets/config/application.yml`, `snippets/config/application-development.yml`, and `snippets/config/application-production.yml` for the required profile file structures.

## Rules
- **Base config**: Application name, logging, management, datasource/broker, app properties
- **Dev config**: Lower ports, verbose output
- **Prod config**: Strict output, explicit non-standard ports (e.g., 9443 instead of defaulting)
- Profile templates use fixed port defaults (`8080` in development and `9443` in production)
- For environment-driven port overrides, replace fixed profile values with Spring placeholders (`${SERVER_PORT:8080}` and `${SERVER_PORT:9443}`)
- **Never hardcode** in code: URLs, ports, queue names, endpoints; use `application*.yml` + `@ConfigurationProperties`
- Use `${VAR_NAME:default}` for non-sensitive infrastructure values (host, port, path, feature flags); never provide fallback defaults for credentials, tokens, and keys
- Virtual threads: Include `spring.threads.virtual.enabled: true` in base config
- Never put `spring.profiles.active` in profile files; only in base config
- Logging config path: `src/main/resources/log/logback-spring.xml`

## Test Configuration
- Create `application-test.yml` when tests need profile-specific overrides (e.g., in-memory datasource, mock URLs, reduced timeouts)
- Keep test overrides isolated to test scope; never reuse production credentials or production endpoints in test profile values
- Use `@ActiveProfiles("test")` in tests that require these overrides

See `snippets/config/` for the YAML skeleton structure to adapt for test overrides.

## Secrets
Never hardcode credentials, tokens, or secrets. See `spring-boot-security.instructions.md`.

## Organization
- One `@Configuration` class = one concern (security, messaging, database, web, etc.)
- Each config class owns its `@Bean` definitions
- Use `@ConfigurationProperties` (implemented as immutable Java records) for all grouped external configuration; `@Value` is permitted only for single-value constructor parameters where `@RequiredArgsConstructor` cannot be used — see `spring-boot-architecture.instructions.md`

## Startup Initialization and Validation
When a resource is needed at startup (e.g., connection pooling, cache warming, configuration validation):
- Create a `@Component` class with a `@PostConstruct` method to initialize the resource
- Use `@PostConstruct` to fail fast: if initialization fails, throw an exception (typically `IllegalStateException` with an i18n message key) so the application cannot start with incomplete/invalid configuration
- Example use case: loading secrets from an external service, validating critical configuration dependencies, or prewarming caches required by services
- Fail-fast startup prevents silent configuration errors from cascading into runtime failures; always prefer immediate failure over deferred/lazy initialization for critical resources
- Never swallow exceptions in `@PostConstruct`; let them propagate to cause startup failure
