---
description: "Spring Boot controller contract for deterministic HTTP boundaries, validation, status semantics, and thin transport behavior in production-grade projects."
applyTo: "**/src/main/java/**/*Controller.java"
---

# Spring Boot Controller Contract
Use this file to enforce deterministic HTTP boundary behavior.

## Scope
1. Apply to REST controllers and page controllers.
2. Keep controller behavior limited to transport concerns.

## Coordination Order
1. Apply [spring-boot-api-versioning.instructions.md](./spring-boot-api-versioning.instructions.md) for /api/* version-routing behavior when API versioning is in scope.
2. Apply [spring-boot-pagination.instructions.md](./spring-boot-pagination.instructions.md) for list-endpoint pagination shape and Link header behavior when pagination is in scope.

## Conflict Resolution
1. Apply this file first for baseline HTTP boundary and status semantics.
2. Apply API versioning rules second for /api/vN routing behavior.
3. Apply pagination rules third for list-endpoint response shape and Link headers.
4. Apply OpenAPI rules last for documentation alignment only.

## Transport Boundary Rules
1. Keep request mapping paths explicit and versioned for API controllers.
2. Keep request validation at the controller boundary using Jakarta Validation annotations.
3. Keep controller methods delegating business decisions to feature services.
4. Keep response models separated from persistence and mapper internals.
5. Keep exception-to-response translation centralized in global exception handling.

## Response Semantics Rules
1. Return 200 for successful read and update operations with response body.
2. Return 201 with Location header for successful create operations.
3. Return 204 for successful delete operations with empty body.
4. Return deterministic machine-readable error payloads through exception contracts.
5. Keep pagination responses explicit and include Link header semantics when pagination is enabled.

## Security and Authorization Rules
1. Keep write operations protected by authentication and authorization rules.
2. Keep controller-level role and permission requirements aligned with security configuration.
3. Do not encode security rules as hardcoded role literals when role constants exist.

## Spring Boot 4.x Testability Rules
1. Keep controller dependencies override-friendly for @WebMvcTest via @MockitoBean in tests.
2. Keep security negative-path assertions in full-context tests when @WebMvcTest does not apply the full SecurityFilterChain behavior.

## Quality Gates
1. Forbid business-rule orchestration in controller methods.
2. Forbid inline SQL, repository calls, or persistence decisions in controllers.
3. Keep URI building deterministic for created-resource Location headers.
