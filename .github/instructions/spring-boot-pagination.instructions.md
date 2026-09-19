---
description: "Spring HATEOAS pagination and sorting for REST endpoints, services, repositories, and HTTP-client proxies."
applyTo: "**/*PageQuery.java, **/*Pagination*.java, **/*Controller.java, **/*Service.java, **/*ServiceImpl.java, **/*Repository.java, **/*HttpClient*.java, **/*RestClient*.java, **/*ExternalApi*.java, **/http_client/**/*Service.java, **/application*.yml"
---

## Naming Conventions
- Name the pagination query record `PageQuery`.
- Name pagination record components `page`, `size`, and `sort`.
- Name pagination helpers by intent, such as `getPaginatedList(...)` and `getPagingAndSortingUrl(...)`.

## Rules

### Default policy
- Treat every REST GET collection endpoint as paginated by default.
- Require an explicit documented exception before using a non-paginated GET collection endpoint; when approved, define and enforce a deterministic server-side result limit.
- Store pagination defaults and limits in configuration properties, not in controller classes; configure `page=0`, `size=20`, and `max=100` as the definitive pagination defaults in `app.pagination.*` properties.

### Endpoint contract
- Use Spring HATEOAS `PagedModel` and `EntityModel` for a paginated REST collection.
- When an endpoint exposes a paginated collection, bind `page`, `size`, and `sort` through `@ModelAttribute PageQuery`.
- Default a missing page to `0`, a missing size to `20`, and a missing sort value to `id,asc` in `PageQuery`.
- Return paginated REST collections as `ResponseEntity<PagedModel<EntityModel<T>>>`.
- Pass `PageQuery` to the service without applying controller-specific pagination logic.
- Use zero-based page numbering; document zero-based page numbering explicitly in OpenAPI annotations for every paginated endpoint.

### Pagination and sorting behavior
- Normalize a negative page to `0` and a size smaller than `1` to `1` in `PageQuery`.
- Sort the complete collection before selecting the requested page; use ascending sort by a stable resource key as the default sort order.
- Return an empty page (with correct total-count metadata) when the requested page begins beyond the available collection.
- Create `PagedModel.PageMetadata` with the normalized size, normalized page, total item count, and total page count when the service creates the page locally.
- Calculate total pages as `0` for an empty collection; otherwise round the total-item-count divided by normalized size up.
- Parse sort options as comma-separated property and direction pairs; reject a sort value with an incomplete property-direction pair.
- Declare an explicit allowlist of valid sort field names for each paginated endpoint; reject unsupported or unknown sort properties with the project localized invalid-sort message and HTTP 400.
- Treat `asc` as ascending and `desc` as descending; reject every other direction value.

### HTTP-client proxies
- Forward `PageQuery.page()` and `PageQuery.size()` to an upstream paginated endpoint.
- Forward `PageQuery.sort()` only when it has text.
- Deserialize upstream pages as `PagedModel<EntityModel<T>>` using `ParameterizedTypeReference`.
- Return `PagedModel.empty()` when an upstream paged response body is absent.
- Preserve upstream page metadata and collection links when mapping the page content to a local response type, including links for each mapped `EntityModel`.

### Database-backed pagination
- Pass `PageQuery` to a repository only when that repository performs database-backed pagination; accept offset, limit, and sort column as explicit method parameters for such queries.
- Keep in-memory pagination and upstream-proxy pagination in the service that owns that behavior.
- Extract shared pagination link-building logic into a single utility class in the `shared` package when the same structure is used by two or more features.

## Safety Guards
- Never invent custom pagination default values without documented justification.

## Reference
- Use [samples/spring-boot-page-query.tpl](samples/spring-boot-page-query.tpl) for `PageQuery` normalization.
- Use [samples/spring-boot-local-pagination-service.tpl](samples/spring-boot-local-pagination-service.tpl) for local page construction.
- Use [samples/spring-boot-pagination-proxy-service.tpl](samples/spring-boot-pagination-proxy-service.tpl) for paginated upstream forwarding.
