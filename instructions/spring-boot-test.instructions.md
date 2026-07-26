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
- Use explicit slice annotations by layer: `@WebMvcTest` (package `org.springframework.boot.webmvc.test.autoconfigure`, dependency `spring-boot-starter-webmvc-test`) for controllers, `@JdbcTest` (package `org.springframework.boot.jdbc.test.autoconfigure`, dependency `spring-boot-jdbc-test`) for JDBC repositories, plain unit tests for services, and `@SpringBootTest` for full integration flows or context-bootstrap smoke tests.
- Use `@SpringBootTest` + `@AutoConfigureMockMvc` for security-chain tests that assert actuator endpoint access; `@WebMvcTest` slices do not represent full actuator exposure.
- When using `@JdbcTest` with an explicit datasource configured in a test profile, add `@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)` to prevent the slice from replacing the configured datasource.
- When using `@JdbcTest` with custom non-Spring-Data `@Repository` implementations, explicitly `@Import` the repository implementation class and the `JdbcClient` configuration class; the slice does not component-scan custom `@Repository` beans.
- Any `@Configuration` class imported via `@Import` in a test slice must have `public` class visibility; a package-private configuration class causes a silent import failure when the test is in a different package.
- Remove `@MockitoBean` stubs for beans not present in the imported slice; unused mocks signal that the slice is too narrow or the context is too wide.
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
- Never use test method names that hide operation, condition, or expected outcome.
- Never couple tests to unstable internal implementation details without need.
