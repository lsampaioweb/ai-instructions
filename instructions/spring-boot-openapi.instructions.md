---
description: "Spring Boot OpenAPI contract for documented API metadata, discoverable endpoints, and stable specification output."
applyTo: "**/OpenApiConfig.java,**/openapi/**/*.java, **/*Controller.java, **/*Api.java"
---

# Spring Boot OpenAPI Engine

## Scope & Analysis
- Inspect OpenAPI configuration classes and metadata fields.
- Inspect API documentation coverage for touched endpoints.
- Inspect version and title consistency between routes and docs.
- Inspect whether each runnable module keeps exactly one OpenAPI configuration class.

## Resolution Rules
- Keep one OpenAPI configuration class per runnable module.
- Keep the configuration class name as `OpenApiConfig`.
- Keep API title, version, and description explicit.
- Keep OpenAPI configuration in dedicated configuration classes.
- Place the configuration either at module root or in an `openapi` package.
- Prefer the existing module placement unless the module is already being reorganized.
- SpringDoc auto-detects endpoints from `@RequestMapping` annotations; `@Tag` and `@Operation` are optional and should be used consistently when a module adopts richer per-endpoint documentation.
- Keep endpoint documentation aligned with controller contracts.
- Keep schema names stable for existing public responses.
- Keep documentation changes synchronized with versioning rules.

## Review Plan Layout
- Report OpenAPI metadata changes.
- Report endpoint documentation additions and updates.
- Report schema compatibility impacts.
- Report unresolved documentation gaps in touched scope.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never publish stale API docs after route contract changes.
- Never duplicate conflicting OpenAPI configurations in one module.
- Never change public schema semantics without versioning decision.
- Never mix conflicting endpoint documentation styles in the same module without an explicit documentation strategy.
