---
description: "Pagination rules: request parameters, response wrapper, size limits, SQL strategy, and Link headers."
applyTo: "**/*Controller.java, **/*Api.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Response.java, **/mapper/**/*.xml, **/sql/**/*.xml, **/application*.yml"
---

# Pagination Rules

## Scope
- Use this file as the canonical pagination contract for REST list endpoints.
- Apply these rules to controllers, repositories, SQL mapper files, and paged response DTOs.

## Request Contract
- Use query parameters `page` and `size` for paged list endpoints.
- Treat `page` as zero-based.
- Default `page` to `0` when omitted.
- Default `size` to `20` when omitted.
- Cap `size` at `100`.
- Reject negative `page` values with HTTP 400.
- Reject `size` values lower than `1` or higher than `100` with HTTP 400.

## Service and Controller Behavior
- Pass pagination arguments as explicit method parameters from controller to service to repository.
- Keep pagination validation at the HTTP boundary using parameter constraints.
- Do not implement pagination decisions in controllers beyond parameter validation and response headers.

## Response Contract
- Return a typed wrapper record named `PagedResponse<T>` for paged endpoints.
- Include fields `items`, `page`, `size`, `totalElements`, and `totalPages` in `PagedResponse<T>`.
- Keep `items` as the current page payload only.
- Keep the existing non-paged response contract unchanged for endpoints that are explicitly non-paginated.

## HTTP Link Header
- Add RFC 5988 `Link` headers to paged responses when a next, previous, first, or last page exists.
- Build links with `rel="first"`, `rel="prev"`, `rel="next"`, and `rel="last"`.
- Keep existing query filters in generated links.

## Repository and SQL Strategy
- Use `LIMIT` and `OFFSET` for default pagination strategy.
- Provide a separate `COUNT(*)` query for total element calculation.
- Keep list and count queries aligned to the same filter predicates.
- Use deterministic ordering for every paged query.

## Keyset Pagination Exception
- Use keyset pagination only for large datasets or deep-page access paths where offset performance is unacceptable.
- Keep offset pagination as the default unless the user explicitly requests keyset mode.
- Document the keyset cursor field and ordering contract when keyset mode is introduced.

## OpenAPI Documentation
- Document `page` and `size` query parameters on every paged endpoint.
- Document `PagedResponse<T>` as the response schema for paged endpoints.
- Document the `Link` response header for paged endpoints.
