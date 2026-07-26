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
- Use `@WebMvcTest` for controller tests.
- Use `@JdbcTest` for JDBC repository tests.
- Use plain unit tests for service tests.
- Use `@SpringBootTest` for full integration flows or context-bootstrap smoke tests.
- For `@WebMvcTest`, use package `org.springframework.boot.webmvc.test.autoconfigure` and dependency `spring-boot-starter-webmvc-test`.
- For `@JdbcTest`, use package `org.springframework.boot.jdbc.test.autoconfigure` and dependency `spring-boot-jdbc-test`.
- Use `@SpringBootTest` + `@AutoConfigureMockMvc` for security-chain tests that assert actuator endpoint access; `@WebMvcTest` slices do not represent full actuator exposure.
- When using `@JdbcTest`, rely on its built-in H2 auto-provisioning.
- Do NOT add `@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)` in `@JdbcTest` slices by default.
- Do NOT activate a test profile via `@ActiveProfiles("test")` in `@JdbcTest` slices.
- Add `@AutoConfigureTestDatabase(replace=NONE)` only when a real external datasource must be preserved.
- When using `@JdbcTest` with custom non-Spring-Data `@Repository` implementations, explicitly `@Import` the repository implementation class.
- When using `@JdbcTest` with custom non-Spring-Data `@Repository` implementations, explicitly `@Import` the `JdbcClient` configuration class.
- The `@JdbcTest` slice does not component-scan custom `@Repository` beans.
- When the project uses a `LogMessages` component (`@Component` backed by `MessageSource`), declare `@MockitoBean LogMessages logMessages` in every `@WebMvcTest` class.
- When the project uses a `LogMessages` component (`@Component` backed by `MessageSource`), declare `@MockitoBean LogMessages logMessages` in every `@JdbcTest` class.
- `@WebMvcTest` auto-detects `@ControllerAdvice` beans that depend on `LogMessages`.
- `@JdbcTest` does not load `spring.messages.basename`, so injecting a real `LogMessages` bean fails in the slice.
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
- Never add `@ActiveProfiles("test")` to `@JdbcTest` or `@WebMvcTest` slices.
- Never create `application-test.yml`; keep test overrides in inline test configuration, explicit test annotations, or environment variables.
- Never add `@AutoConfigureTestDatabase(replace=NONE)` to `@JdbcTest` when the slice can use its built-in H2 auto-provisioning.
- Never skip failure-path assertions for changed logic.
- Never rely only on happy-path tests for API changes.
- Never use `@SpringBootTest` for single-layer tests that can be covered by a narrower test slice.
- Never leave database state shared across integration tests when rollback isolation is required.
- Never use test method names that hide operation, condition, or expected outcome.
- Never couple tests to unstable internal implementation details without need.
