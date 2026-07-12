---
description: "Spring Boot pagination contract for bounded request parameters, deterministic response shape, and predictable navigation semantics in production-grade projects."
applyTo: "**/src/main/java/**/*Controller.java, **/src/main/resources/mapper/**/*.xml, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml"
---

# Spring Boot Pagination Contract
Use this file to enforce deterministic pagination behavior.

## Scope
1. Apply to list endpoints that return collections.
2. Keep pagination behavior aligned across controller request handling, persistence query SQL, and runtime configuration.

## Coordination Order
1. Apply [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) first for generic HTTP status and transport boundary rules.
2. Apply this file next for pagination-specific request, response, and Link header behavior.
3. Apply [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) for generic mapper interface and persistence adapter constraints.

## Request Parameter Rules
1. Keep page parameter zero-based and validated with minimum 0.
2. Keep size parameter validated with minimum 1.
3. Keep maximum size bounded by configured max-page-size.
4. Keep default size sourced from configured default-page-size when size is omitted.
5. Keep invalid page or size values rejected with deterministic validation errors.

## Response Shape Rules
1. Keep paginated response shape explicit with fields items, page, size, totalElements, and totalPages.
2. Keep page and size in response equal to validated request values after defaults and max-size clamping.
3. Keep totalPages computed deterministically from totalElements and size.
4. Keep empty results represented as items empty array with totalElements 0 and totalPages 0.

## Navigation Rules
1. Keep Link header generation deterministic for first and last pages.
2. Keep prev link only when page is greater than 0.
3. Keep next link only when page + 1 is less than totalPages.
4. Keep link query parameters synchronized with effective page and size values.

## Persistence and Query Rules
1. Keep mapper queries using deterministic limit and offset derived from page and size.
2. Keep total count query executed for paginated endpoints.
3. Keep sorting behavior explicit and bounded when sorting is supported.
4. Forbid unbounded list queries in paginated endpoints.

## Configuration Rules
1. Keep pagination defaults externalized in application configuration.
2. Keep README pagination defaults and limits aligned with runtime configuration.
3. Keep tests covering default size, max size clamp, and navigation header behavior.
