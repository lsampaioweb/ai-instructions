---
description: "Spring Boot testing contract for deterministic coverage of feature behavior, failure paths, and security boundaries in production-grade projects."
applyTo: "**/src/test/java/**/*Test.java, **/src/test/java/**/*Tests.java"
---

# Spring Boot Test Contract
Use this file to enforce deterministic and architecture-aligned testing.

## Scope
1. Apply to unit, slice, and integration tests in src/test/java.
2. Keep tests organized by feature package, not top-level technical package.
3. Keep assertions focused on externally observable behavior.

## Test Type Selection
1. Use plain unit tests with mocked collaborators for feature logic.
2. Use @WebMvcTest only for HTTP transport behavior and request validation.
3. Use persistence integration tests for mapper XML and JDBC query behavior.
4. Use @SpringBootTest only when full-context behavior is required.
5. Do not use context-load tests as primary evidence for feature correctness.
6. In Spring Boot 4.x test slices, use @MockitoBean for Spring-managed bean overrides.
7. Do not rely on @WebMvcTest for unauthenticated or forbidden-path assertions when SecurityFilterChain behavior requires full context.

## Determinism Rules
1. Keep test data explicit, local, and repeatable.
2. Keep tests independent and order-agnostic.
3. Mock or stub external systems unless integration behavior is the explicit target.
4. Control clock, random, and async boundaries through deterministic test doubles.
5. Fail tests on ambiguous timing by using bounded waits and explicit completion checks.

## Coverage Requirements
1. Cover success and failure paths for each public feature behavior.
2. Cover validation failure and exception translation behavior at boundary tests.
3. Cover authorization and forbidden access paths when security is enabled.
4. Cover pagination bounds and default behavior when pagination is enabled.
5. Cover locale fallback and message resolution when i18n is enabled.
6. Cover transactional rollback behavior for multi-step feature operations.

## Architecture Alignment
1. Validate feature-level behavior without enforcing top-level technical package splits.
2. Keep persistence tests aligned with MyBatis mapper XML or JDBC adapters.
3. Forbid tests that depend on JPA, Hibernate, or Spring Data repository abstractions.
4. Keep test visibility and helper scope minimal to reduce cross-feature coupling.

## Quality Gates
1. Forbid placeholder tests with no domain assertions.
2. Require explicit assertions for status, payload, and machine-readable error code where applicable.
3. Keep test profile configuration isolated from production secrets and production endpoints.
