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
- Use pageable request parameters for collection endpoints that are declared paginated by module contract.
- Allow custom pagination with validated `page` and `size` request parameters when Spring Data Pageable is not used.
- Externalize pagination defaults and limits in configuration, not in controllers.
- Use `spring.data.web.pageable` properties for Spring Data Pageable defaults.
- Use typed `@ConfigurationProperties` (for example `app.pagination.*`) for custom pagination defaults and limits.
- Use `page=0`, `size=20`, and `max=100` only as reference defaults when no module-specific values are defined.
- Return paged responses with metadata for total elements and pages when the endpoint contract is paginated.
- Keep sort behavior deterministic for repeatable results.
- Use ascending sort by a stable resource key by default for paginated endpoints unless the module contract defines different sorting defaults.
- Validate page and size boundaries with explicit defaults.
- Enforce explicit max-page-size protection when custom pagination configuration exists.
- Validate custom `page`/`size` constraints in the service layer once per use case and reuse that path across endpoints.
- Avoid repeating numeric fallback literals across multiple controllers.
- Keep pagination semantics consistent across resources.
- Keep pagination mapping in service layer aligned with API contract.
- Extract shared pagination link-building logic (e.g., RFC-5988 Link headers) into a single common utility class when the same structure is used by two or more controllers; never copy-paste it.

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

