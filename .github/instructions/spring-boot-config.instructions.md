---
description: "Spring Boot configuration contract for externalized, profile-aware, and safe configuration management."
applyTo: "**/src/main/resources/application*.yml"
---

# Spring Boot Config Engine

## Scope & Analysis
- Inspect base and profile-specific configuration files.
- Map each property to runtime behavior and owning component.
- Detect duplicated, conflicting, or dead properties.

## Resolution Rules
- Keep configuration externalized and profile-aware.
- Keep `application.yml` as the base configuration file for each runnable module.
- Add `application-development.yml` and `application-production.yml` when the module has distinct runtime environments.
- Use `production` as the default active profile in `application.yml` when the module defines profile-specific runtime files, unless the user explicitly requests another default.
- Keep ports explicit only when runtime, TLS, container, or integration requirements need non-default values.
- Keep one configuration-properties registration strategy per runnable module: either component-scanned properties classes or explicit `@EnableConfigurationProperties`, but not both.
- When using `@EnableConfigurationProperties`, register each `@ConfigurationProperties` class in the owning `@Configuration` class, not the main class.
- Keep feature-scoped `@ConfigurationProperties` classes package-private; only module-root properties classes may be public; ensure the chosen registration strategy is compatible with test slices.
- Keep default values safe for local development.
- Prefer class-level configuration properties over scattered value injection.
- Annotate `@ConfigurationProperties` classes with `@Validated` and use Bean Validation constraints (e.g., `@NotNull`, `@NotBlank`, `@Min`) on required fields; a startup failure from missing or invalid config is preferable to a silent runtime failure.
- Keep sensitive values out of source-controlled defaults.
- Allow environment placeholders such as `${ENV_VAR}` in source-controlled defaults when they do not disclose real secret values.
- Use clear, stable property keys with domain prefixes for custom application properties.
- Use dot-separated lowercase keys with a consistent root namespace prefix (e.g., `app.pagination.default-size`, `app.security.jwt.expiry`); never use camelCase or underscore-separated keys in property files.
- Keep each custom property namespace owned by a specific feature, integration, or infrastructure component.
- Keep shared configuration in the module-root config/ package only for cross-feature infrastructure properties (e.g., pagination, locale, JDBC client); keep feature-specific configuration properties in feature package config/ subdirectories and owned by that feature.
- Keep external configuration imports explicit, environment-safe, and non-blocking unless startup failure is intentional.
- Require explicit documentation for new public configuration keys.
- Configure HikariCP connection pool settings explicitly: set `spring.datasource.hikari.maximum-pool-size`, `spring.datasource.hikari.connection-timeout`, and `spring.datasource.hikari.idle-timeout`; never rely on Spring Boot defaults for production connection pools.
- For package-private enforcement of feature-scoped @Configuration classes, defer to `spring-boot-architecture.instructions.md`.

## Safety Guards
- Never commit real secrets, credentials, or private tokens.
- Never change production-critical defaults without explicit approval.
- Never change default profile or explicit port conventions without documenting the module-specific reason.
- Never assume environment-specific infrastructure values.
- Never mix component-scanned and explicitly enabled registration strategies in the same module without explicit approval.
- Never place `@EnableConfigurationProperties` on the application main class when individual `@Configuration` classes are the better owner.

## Review Plan Layout
- Report created or changed properties with owner and effect.
- Report profile-specific overrides and fallback behavior.
- Report configuration import decisions and precedence behavior.
- Report secret-handling decisions and redaction strategy.
- Report removed properties and migration notes.

