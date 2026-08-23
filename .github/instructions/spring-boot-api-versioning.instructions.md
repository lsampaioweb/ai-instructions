---
description: "API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions."
applyTo: "**/*Controller.java"
---

# Spring Boot API-Versioning Engine

## Rules
- Use URL path versioning with an explicit `/api/v1` prefix for all REST endpoints.
- Use integer version numbers in the format `/api/vN` (e.g., `/api/v1`, `/api/v2`).
- Do not use floating-point or date-based version identifiers such as `/api/v1.1` or `/api/2024-01`.
- Exclude MVC page controllers and view routes from API version-prefix enforcement.
- Use one canonical versioning strategy across the entire project.
- Declare version changes explicitly in controller route mappings.
- Declare a shared base-path constant at the controller class level when the versioned route is reused across methods.
- Keep v1 changes additive and backward compatible.
- Treat these changes as additive and backward compatible: adding optional request fields with defaults, adding new response fields, and adding new endpoints.
- Create a new API version for every breaking contract change.
- Treat these changes as breaking: removing or renaming a field, changing a field type, making an optional field required, removing an endpoint, changing an endpoint path, or changing an HTTP method.
- Keep request and response DTO changes backward compatible within the same version.
- Use version-specific DTO suffixes when payload contracts diverge across versions (e.g., `HolidayV1Response`, `HolidayV2Response`).
- Share the same DTO across versions only when the payload contract is identical.
- Keep route versioning distinct from OpenAPI document version metadata.
- Keep controller tests aligned with the active versioned route prefix.
- When v2 or later is introduced, keep old and new versions available side by side until the old version is explicitly deprecated.
- When v2 or later is introduced, document migration notes and client impact.
- Announce a deprecated API version via a `Deprecation` response header per RFC 8594.
- Announce a deprecated API version via a `Sunset` response header per RFC 8594.
- Always set both `Deprecation` and `Sunset` headers together when a version is scheduled for removal.
- Maintain a deprecated API version for at least one full release cycle after the deprecation announcement; remove a version only in a later release than the one that deprecates it.

## Safety Guards
- Never mix REST API versioned routes and unversioned REST routes in the same public API surface.
- Never introduce breaking changes silently inside an existing versioned route.
- Never mix incompatible payload contracts under the same route version.
