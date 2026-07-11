---
description: "API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions."
applyTo: "**/*Controller.java, **/*Api.java, **/*Request.java, **/*Response.java, **/*OpenApiConfig*.java, **/*SwaggerConfig*.java, **/*Test.java, **/*IT.java, **/README.md"
---

# API Versioning Rules

## Scope
- Use this file as the canonical source for REST API version evolution and coexistence behavior.

## Versioning Strategy
- Use URL path versioning (`/api/v1/...`, `/api/v2/...`) as the default strategy.
- Keep existing major versions available during migration windows unless explicitly decommissioned.
- Introduce `v2` only for backward-incompatible changes.

## Controller Structure
- Keep one controller class per versioned contract (for example: `CountryControllerV1`, `CountryControllerV2`).
- Do not retrofit breaking behavior into existing `v1` endpoints.
- Keep shared business logic in services; version differences stay at API contract boundaries.

## DTO Evolution
- Use version-specific request/response DTOs when contracts diverge.
- Reuse shared DTOs only when fields and semantics are identical across versions.
- Avoid cross-version DTO mutation that changes old-client behavior.

## Deprecation Signaling
- When a version is planned for retirement, include `Deprecation` and `Sunset` headers in responses.
- Document deprecation timeline and replacement version in API docs.
- Keep deprecation headers consistent across all endpoints in the deprecated version.

## OpenAPI Documentation
- Publish versioned endpoint groups clearly in OpenAPI.
- Keep `v1` and `v2` schemas and examples separate when payloads differ.
- Document migration notes from older versions to newer versions.

## Testing
- Keep regression tests for active versions (`v1`, `v2`, etc.) while they coexist.
- Add contract tests for version-specific behavior differences.
- Do not remove prior-version tests until that version is formally decommissioned.

## Retirement Policy
- Remove a deprecated version only after announced sunset criteria are met.
- Record version retirement decisions in release notes and README migration sections.
