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
- Keep one canonical file trio per runnable module: `application.yml`, `application-development.yml`, and `application-production.yml`.
- Use `production` as the default active profile in `application.yml` unless the user explicitly requests another default.
- Use `8080` as the default development HTTP port and `9443` as the default production HTTPS port unless module-specific integration constraints require different values.
- Keep one configuration-properties registration strategy per runnable module: either component-scanned properties classes or explicit `@EnableConfigurationProperties`, but not both.
- Keep sensitive values out of source-controlled defaults.
- Use clear, stable property keys with domain prefixes.
- Keep default values safe for local development.
- Prefer class-level configuration properties over scattered value injection.
- Require explicit documentation for new public configuration keys.

## Review Plan Layout
- Report created or changed properties with owner and effect.
- Report profile-specific overrides and fallback behavior.
- Report secret-handling decisions and redaction strategy.
- Report removed properties and migration notes.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never commit real secrets, credentials, or private tokens.
- Never change production-critical defaults without explicit approval.
- Never change default profile and port conventions without documenting the module-specific reason.
- Never assume environment-specific infrastructure values.
- Never mix component-scanned and explicitly enabled registration strategies in the same module without explicit approval.
