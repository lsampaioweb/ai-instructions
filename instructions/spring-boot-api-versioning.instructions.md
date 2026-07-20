---
description: "API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions."
applyTo: "**/*Controller.java, **/*Api.java, **/*Request.java, **/*Response.java, **/*OpenApiConfig*.java, **/*Test.java"
---

# Spring Boot API-Versioning Engine

## Scope & Analysis
- Inspect API route prefixes and versioning strategy in controllers.
- Inspect request and response compatibility across touched endpoints.
- Inspect whether changes are additive or breaking.
- Apply this contract to REST API controllers only.
- Exclude MVC page controllers from version-prefix enforcement and govern them under the Thymeleaf contract.

## Resolution Rules
- Use URL path versioning with explicit v1 prefix.
- Keep v1 changes additive and backward compatible.
- Create a new API version for breaking contract changes.
- Keep one canonical versioning strategy across the project.
- Keep version changes explicit in route mappings.
- Document version behavior in API-facing documentation.

## Review Plan Layout
- Report changed routes and version impact.
- Report additive versus breaking change classification.
- Report compatibility guarantees for existing clients.
- Report migration notes when new versions are introduced.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never introduce breaking changes silently inside v1 routes.
- Never mix incompatible payload contracts under same route version.
- Never apply multiple versioning strategies in the same project.
