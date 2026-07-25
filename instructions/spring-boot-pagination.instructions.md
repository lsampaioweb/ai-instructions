---
description: "Spring Boot pagination contract for pageable queries, deterministic ordering, and consistent paged response metadata."
applyTo: "**/*Controller.java,**/*Service.java,**/*ServiceImpl.java"
---

# Spring Boot Pagination Engine

## Scope & Analysis
- Inspect listing endpoints for page, size, and sort behavior.
- Inspect service and repository handling of pageable inputs.
- Inspect response payload metadata for pagination consistency.

## Resolution Rules
- Use pageable request parameters for collection endpoints.
- Allow custom pagination with validated `page` and `size` request parameters when Spring Data Pageable is not used.
- Use `page=0` and `size=20` as default pagination values unless the user explicitly requests different defaults.
- Enforce `size` upper bound with `max=100` unless module constraints require a stricter limit.
- Return paged responses with metadata for total elements and pages.
- Keep sort behavior deterministic for repeatable results.
- Use ascending sort by a stable resource key by default unless the user explicitly requests different sorting defaults.
- Validate page and size boundaries with explicit defaults.
- Enforce explicit max-page-size protection when custom pagination configuration exists.
- Keep pagination semantics consistent across resources.
- Keep pagination mapping in service layer aligned with API contract.

## Review Plan Layout
- Report paginated endpoint behavior and defaults.
- Report metadata fields exposed in response payloads.
- Report sorting and boundary validation decisions.
- Report compatibility impact on existing consumers.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never return unbounded collections for pageable endpoints.
- Never omit total count metadata when contract requires pagination.
- Never use unstable ordering for paged responses.
