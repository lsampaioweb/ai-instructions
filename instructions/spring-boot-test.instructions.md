---
description: "Spring Boot testing contract for layer-focused tests, API-contract assertions, and cross-cutting governance checks."
applyTo: "**/src/test/java/**/*.java, **/*Test.java"
---

# Spring Boot Test Engine

## Scope & Analysis
- Inspect test coverage for touched controllers, services, and data paths.
- Inspect active test profiles, fixtures, and test configuration boundaries.
- Inspect assertion quality for response contracts and failure paths.

## Resolution Rules
- Use layer-appropriate test slices for the target behavior.
- Use explicit slice annotations by layer: `@WebMvcTest` for controllers, `@DataJdbcTest` for JDBC repositories, plain unit tests for services, and `@SpringBootTest` only for full integration flows.
- Use `@Transactional` on database-touching `@SpringBootTest` integration tests to ensure rollback isolation between test methods.
- Use BDD-style test method names in the format `<operation>_when<Condition>_should<ExpectedResult>`.
- Keep controller tests focused on HTTP contract behavior.
- Keep service tests focused on business rules and edge cases.
- Assert success and failure paths for each changed behavior.
- Keep response-structure assertions explicit for API tests.
- Add governance tests when architecture invariants require enforcement.

## Review Plan Layout
- Report added and updated tests by layer and purpose.
- Report uncovered risk paths and planned follow-up.
- Report profile and fixture assumptions used by tests.
- Report architectural invariants enforced by governance tests.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never skip failure-path assertions for changed logic.
- Never rely only on happy-path tests for API changes.
- Never use `@SpringBootTest` for single-layer tests that can be covered by a narrower test slice.
- Never leave database state shared across integration tests when rollback isolation is required.
- Never use ambiguous test method names that hide operation, condition, or expected outcome.
- Never couple tests to unstable internal implementation details without need.
