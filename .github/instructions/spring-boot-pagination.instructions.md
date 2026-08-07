---
description: "Spring Boot pagination contract for pageable queries, deterministic ordering, and consistent paged response metadata."
applyTo: "**/*Controller.java,**/*Service.java,**/*ServiceImpl.java"
---

# Spring Boot Pagination Engine

## Scope & Analysis
- Inspect listing endpoints for page, size, and sort behavior.
- Inspect service and repository handling of pageable inputs.
- Inspect response payload metadata for pagination consistency.
- Inspect where pagination defaults and max limits are sourced.

## Resolution Rules
- Use Spring Data Pageable as the default pagination strategy for collection endpoints; use custom validated `page`/`size` parameters only when Spring Data integration is not available.
- Declare `Pageable` as a direct controller method parameter for paginated endpoints; never wrap it in request DTOs or adapter objects.
- Keep pagination semantics consistent across resources.
- Externalize pagination defaults and limits in configuration, not in controllers.
- Use `spring.data.web.pageable` properties for Spring Data Pageable defaults.
- Use typed `@ConfigurationProperties` (for example `app.pagination.*`) for custom pagination defaults and limits.
- Configure `page=0`, `size=20`, and `max=100` as the definitive defaults in `spring.data.web.pageable` or `app.pagination.*` properties unless a business requirement explicitly overrides them; never invent custom values without documented justification.
- Return paged responses with metadata for total elements and pages when the endpoint contract is paginated.
- Always include `content`, `totalElements`, `totalPages`, `page` (current page index), and `size` (page size) in paged response payloads; map Spring's `Page<T>` to a stable custom response DTO to avoid exposing Spring internal fields in the public API contract.
- Use zero-based page numbering (page 0 is the first page); document this convention explicitly in OpenAPI annotations and API documentation so consumers know page 0 returns the first result set.
- Keep sort behavior deterministic for repeatable results.
- Use ascending sort by a stable resource key by default for paginated endpoints unless the module contract defines different sorting defaults.
- When using custom pagination, accept sort via a `sort` request parameter in `field,asc|desc` format, consistent with Spring Data Pageable conventions; never invent a proprietary sort format.
- Validate page and size boundaries with explicit defaults.
- Enforce explicit max-page-size protection when custom pagination configuration exists.
- Validate custom `page`/`size` constraints in the service layer once per use case and reuse that path across endpoints.
- Avoid repeating numeric fallback literals across multiple controllers.
- Extract shared pagination link-building logic (e.g., RFC-5988 Link headers) into a single common utility class when the same structure is used by two or more controllers; never copy-paste it.
- Keep pagination mapping in service layer aligned with API contract.

## Safety Guards
- Never return unbounded collections for pageable endpoints.
- Never omit total count metadata when contract requires pagination.
- Never use unstable ordering for paged responses.
- Never duplicate pagination header-building or link-generation logic across multiple controllers.

## Review Plan Layout
- Report paginated endpoint behavior and defaults.
- Report metadata fields exposed in response payloads.
- Report sorting and boundary validation decisions.
- Report compatibility impact on existing consumers.

