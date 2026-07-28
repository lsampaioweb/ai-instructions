---
description: "API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions."
applyTo: "**/*Api.java, **/*Request.java, **/*Response.java, **/*OpenApiConfig*.java, **/*Test.java"
---

# Spring Boot API-Versioning Engine

## Scope & Analysis
- Inspect API route prefixes and versioning strategy in controllers.
- Inspect request and response compatibility across touched endpoints.
- Inspect whether changes are additive or breaking.
- Apply this contract to REST API controllers only.
- Exclude MVC page controllers from version-prefix enforcement and govern them under the Thymeleaf contract.

## Resolution Rules
- Use URL path versioning with an explicit `/api/v1` prefix for REST endpoints.
- Exclude MVC page controllers and view routes from API version-prefix enforcement.
- Keep one canonical versioning strategy across the project.
- Keep version changes explicit in controller or API route mappings.
- Prefer a shared controller-level base-path constant when the versioned route is reused across methods or tests.
- Keep v1 changes additive and backward compatible.
- Create a new API version for breaking contract changes.
- Keep request and response DTO changes backward compatible within v1.
- Keep route versioning distinct from OpenAPI document version metadata.
- Document API route version behavior in API-facing documentation.
- Keep controller and integration tests aligned with the active versioned route prefix.
- When v2 or later is introduced, keep old and new versions available side by side until deprecation is explicit.
- When v2 or later is introduced, document migration notes and client impact.

## Safety Guards
- Never introduce breaking changes silently inside v1 routes.
- Never mix REST API versioned routes and unversioned REST routes in the same public API surface.
- Never change a v1 request or response contract in a breaking way without creating a new version.
- Never remove an older API version before documenting migration and deprecation behavior.
- Never mix incompatible payload contracts under same route version.
- Never apply multiple versioning strategies in the same project.

## Review Plan Layout
- Report REST routes that define or reuse versioned base paths.
- Report additive versus breaking change classification for touched request and response contracts.
- Report whether DTO changes remain backward compatible within the active route version.
- Report whether OpenAPI metadata and route versioning remain semantically aligned.
- Report whether controller or integration tests lock the versioned route prefix.
- Report migration notes and coexistence behavior when a new API version is introduced.

