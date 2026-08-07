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

## Dependencies
- To generate OpenAPI specifications, add `springdoc-openapi-starter-webmvc-ui` dependency in pom.xml (provides @OpenAPIDefinition, @Schema, and Swagger UI).
- For OpenAPI without UI bundling, use `springdoc-openapi-starter-webmvc-api` instead.
- For Spring Boot 4.0+, ensure springdoc-openapi version is 2.4.0 or higher (required for Spring Boot 4.0 compatibility).

## Resolution Rules
- Keep one OpenAPI configuration class per runnable module.
- Keep the configuration class name as `OpenApiConfig`.
- Keep API title, version, and description explicit.
- Set `info.version` to the current API version in semantic version format (e.g., `1.0.0`); keep it synchronized with the active route version prefix.
- Set `info.description` to a one-paragraph summary covering the module's purpose, base URL, and authentication requirements; never leave it empty or set to a placeholder.
- Keep OpenAPI configuration in dedicated configuration classes.
- Place the configuration either at module root or in an `openapi` package.
- Prefer the existing module placement unless the module is already being reorganized.
- Configure `springdoc.swagger-ui.path=/swagger-ui.html` and `springdoc.api-docs.path=/api-docs` in `application.yml` for stable, discoverable documentation URLs.
- When the API uses JWT authentication, declare a Bearer token security scheme in `OpenApiConfig` using `@SecurityScheme` and apply it globally with `@SecurityRequirement` so all protected endpoints show the lock in Swagger UI.
- SpringDoc auto-detects endpoints from `@RequestMapping` annotations; use `@Tag` and `@Operation` consistently across all touched endpoints when the module adopts richer per-endpoint documentation.
- Keep endpoint documentation aligned with controller contracts.
- Keep schema names stable for existing public responses.
- For route versioning strategy and API version-metadata alignment, defer to `spring-boot-api-versioning.instructions.md`.
- Keep documentation changes synchronized with versioning rules.

## Safety Guards
- Never publish stale API docs after route contract changes.
- Never duplicate conflicting OpenAPI configurations in one module.
- Never change public schema semantics without versioning decision.
- Never mix conflicting endpoint documentation styles in the same module without an explicit documentation strategy.

## Review Plan Layout
- Report OpenAPI metadata changes.
- Report endpoint documentation additions and updates.
- Report schema compatibility impacts.
- Report unresolved documentation gaps in touched scope.

