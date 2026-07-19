---
description: "Spring Boot configuration contract for profile-aware, secure, and externalized runtime settings in production-grade projects."
applyTo: "**/src/main/resources/application*.yml"
---

# Spring Boot Config Contract
Use this file to enforce configuration consistency across environments.

## Configuration Baseline
1. Keep a base application.yml for shared defaults.
2. Use profile-specific files for environment overrides.
3. Keep spring.application.name defined.
4. Keep logging configuration explicit when custom logback configuration is used.
5. When i18n is in scope, keep spring.messages.basename set to i18n/messages.
6. When i18n is in scope, keep spring.messages.encoding set to UTF-8 when MessageSource defaults are overridden.

## Profiles and Environment Separation
1. Use development and production profiles for runtime-specific behavior.
2. Use file names `application-development.yml` and `application-production.yml` for profile-specific overrides.
3. Keep `application.yml` as the shared baseline.
4. Keep production-safe defaults in production profile settings.
5. Keep debug-friendly settings limited to development profile.
6. Do not duplicate unchanged values across profile files.

## Externalization Rules
1. Externalize secrets, credentials, and host-specific values with environment placeholders.
2. Use safe defaults only for non-sensitive values.
3. Do not hardcode passwords, tokens, keys, or private certificates.
4. Keep configuration keys stable and descriptive.

## Security Rules
1. Disable stacktrace disclosure in production responses.
2. Restrict actuator health detail exposure in production.
3. Disable OpenAPI and Swagger UI in production when API docs are not explicitly required.
4. Use TLS settings in production profiles when HTTPS is in scope.

## Observability and Runtime Rules
1. Keep management endpoint exposure explicit and minimal.
2. Keep health and metrics visibility aligned with operational requirements.
3. Keep server port and transport settings configurable by environment.

## Data and Performance Rules
1. Configure datasource and pool settings explicitly when database access is enabled.
2. Keep timeout and retry settings configurable for external integrations.
3. Avoid unbounded resource settings.

## Custom App Properties
1. Namespace custom keys under a dedicated top-level prefix.
2. Provide defaults only when behavior is safe and deterministic.

## Coordination Order
1. Apply this file first as the generic baseline for application*.yml and application*.yaml files.
2. Apply feature-specific configuration contracts after this file only when their feature scope is active.
3. Treat feature-specific configuration rules as supplements unless explicit precedence is declared.
4. For Java-side binding annotations such as @ConfigurationProperties and @Value, apply [spring-boot-architecture.instructions.md](./spring-boot-architecture.instructions.md) and Java-scoped component contracts.
