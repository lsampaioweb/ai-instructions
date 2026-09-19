---
description: "URI path versioning for Spring REST API routes, coexistence strategy, deprecation headers, DTO evolution, and versioned endpoint tests."
applyTo: "**/*Controller.java, **/*Api.java, **/*ControllerTest.java, **/*Api*Test.java"
---

## Dependencies
- Follow `spring-boot-controller.instructions.md` for controller routing, request binding, and response responsibilities.

## Naming Conventions
- Use the URI prefix `/api/v1` for versioned REST routes.
- Keep the resource segment plural for collection resources, such as `/api/v1/users`.
- Use integer version numbers in the format `/api/vN` (e.g., `/api/v1`, `/api/v2`).
- Do not use floating-point or date-based version identifiers such as `/api/v1.1` or `/api/2024-01`.

## Rules

### URI path versioning
- Version every REST API route through its URI path.
- Do not apply `/api/v1` path versioning to `*PageController` or `*PageRoutes` endpoints.
- Use `/api/v1/{resource}` as the class-level route format for versioned REST resources.
- Keep the version prefix before the resource path and command subpath.
- Use `v1` as the current API version.
- Use the same versioned base path in outbound client configuration when a client calls a project REST API.
- Do not use query-parameter, request-header, or media-type versioning for REST API routes.
- Use one canonical versioning strategy across the entire project.
- Declare a shared base-path constant at the controller class level when the versioned route is reused across methods.

### Coexistence and deprecation
- Keep v1 changes additive and backward compatible; treat adding optional request fields with defaults, adding new response fields, and adding new endpoints as additive.
- Create a new API version for every breaking contract change; treat removing or renaming a field, changing a field type, making an optional field required, removing an endpoint, changing an endpoint path, or changing an HTTP method as breaking.
- When v2 or later is introduced, keep old and new versions available side by side until the old version is explicitly deprecated, and document migration notes and client impact.
- Announce a deprecated API version via a `Deprecation` response header per RFC 8594.
- Announce a deprecated API version via a `Sunset` response header per RFC 8594.
- Always set both `Deprecation` and `Sunset` headers together when a version is scheduled for removal.
- Maintain a deprecated API version for at least one full release cycle after the deprecation announcement; remove a version only in a later release than the one that deprecates it.

### DTO evolution
- Keep request and response DTO changes backward compatible within the same version.
- Use version-specific DTO suffixes when payload contracts diverge across versions (e.g., `HolidayV1Response`, `HolidayV2Response`).
- Share the same DTO across versions only when the payload contract is identical.
- Keep route versioning distinct from OpenAPI document version metadata.

### Versioned endpoint tests
- Use the versioned URI when testing REST endpoints.
- Keep controller tests aligned with the active versioned route prefix.
- Update endpoint tests and client configuration when a REST API version changes.

## Reference
- Use [samples/spring-boot-controller.tpl](samples/spring-boot-controller.tpl) for the canonical versioned REST controller mapping.
