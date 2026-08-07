---
description: "Spring Boot testing contract for layer-focused tests, API-contract assertions, and cross-cutting governance checks."
applyTo: "**/src/test/java/**/*.java, **/*Test.java"
---

# Spring Boot Test Engine

## Scope & Analysis
- Inspect test coverage for touched controllers, services, and data paths.
- Inspect active test profiles, fixtures, and test configuration boundaries.
- Inspect assertion quality for response contracts and failure paths.

## Spring 4 Import Requirements
- `@WebMvcTest` is located in `org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest` (NOT `org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest`).
- `@JdbcTest` is located in `org.springframework.boot.jdbc.test.autoconfigure.JdbcTest` (NOT `org.springframework.boot.test.autoconfigure.jdbc.JdbcTest`).
- Mockito bean overrides use `org.springframework.test.context.bean.override.mockito.MockitoBean` (NOT deprecated `org.springframework.boot.test.mock.mockito.MockBean`).
- `@MockBean` from `org.springframework.boot.test.mock.mockito.MockBean` does not exist; use `@MockitoBean` instead.
- `@SpringBootTest + @AutoConfigureMockMvc` no longer auto-configures security chain testing; use explicit `SecurityMockMvcConfigurers.springSecurity()` and `webAppContextSetup()` instead.
- Agents trained on Spring 3.x will emit wrong package paths; validate all test imports against Spring 4.0+ documentation before approval.

## Resolution Rules
- Use layer-appropriate test slices: `@WebMvcTest(ControllerClass.class)` for HTTP contract tests, `@JdbcTest` for repository tests, `@ExtendWith(MockitoExtension.class)` for unit tests, `@SpringBootTest` for full integration tests.
- For `@WebMvcTest`, add `spring-boot-starter-webmvc-test` dependency and keep controller tests focused on HTTP contract behavior.
- For `@WebMvcTest` classes that serialize JSON fixtures, explicitly enable JSON auto-configuration in the test slice before autowiring `ObjectMapper`.
- For `@WebMvcTest`, serialize request and response fixtures using the slice-configured `ObjectMapper` (or `JacksonTester`); never handcraft JSON strings except for intentionally malformed-payload tests.
- For `@WebMvcTest` classes that invoke controller methods with `Pageable` parameters, enable Spring Data web argument-resolver auto-configuration for the slice before executing `MockMvc` requests.
- When `LogMessages` is used in `@WebMvcTest`, declare `@MockitoBean LogMessages logMessages` (Spring 4: `org.springframework.test.context.bean.override.mockito.MockitoBean`); `@WebMvcTest` auto-detects `@ControllerAdvice` beans that depend on it.
- For `@JdbcTest`, add `spring-boot-jdbc-test` dependency; rely on built-in H2 auto-provisioning and do not override it.
- Do NOT add `@AutoConfigureTestDatabase(replace=NONE)` by default; only add when preserving a real external datasource (rare).
- Never add an explicit test datasource configuration (profile or properties file) for test slices; slice annotations auto-provision their own infrastructure and explicit overrides conflict with auto-provisioning.
- `@JdbcTest` does not load `spring.messages.basename` or component-scan custom `@Repository` beans; for custom implementations, explicitly `@Import({RepositoryImpl.class, JdbcConfig.class})` and ensure `JdbcClient` is a `@Bean`.
- Any `@Configuration` imported via `@Import` must be `public` and in a scannable package; package-private configuration silently fails to load beans.
- For security-chain tests with `@SpringBootTest`, manually configure MockMvc using `webAppContextSetup(context).apply(springSecurity()).build()` with static imports from `org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers` and `org.springframework.test.web.servlet.setup.MockMvcBuilders`.
- Use `@Transactional` on database-touching integration tests for rollback isolation; do NOT use `@SpringBootTest` for single-layer tests; prefer narrower slices.
- Use BDD-style test names: `<operation>_when<Condition>_should<ExpectedResult>` (e.g., `transfer_whenSufficientBalance_shouldTransferSuccessfully`).
- Use builder methods or dedicated factory methods for test data construction; never construct complex test objects inline with multiple chained `new` calls directly inside assertion blocks.
- Keep service tests focused on business rules and edge cases; keep response-structure assertions explicit for API tests.
- Assert success and failure paths for each changed behavior; add governance tests when architecture invariants require enforcement.
- Write at minimum one happy-path test and one failure-path test for each public service method and each REST controller endpoint; never ship a public method with only happy-path test coverage.
- Use AssertJ (`assertThat(...)`) for all test assertions; never use `assertTrue`/`assertFalse` for conditions where a descriptive failure message would improve debuggability.
- Remove unused `@MockitoBean` stubs; unused mocks signal slice misconfiguration.

## Safety Guards
- [Profiles] Never use `@ActiveProfiles("test")` with `@WebMvcTest` or `@JdbcTest`; test slices ignore profiles and cause silent configuration failures. Override via `@Bean` methods, test properties, or mock injection instead.
- [Profiles] Never create `application-test.yml`; use inline `@Bean` methods, `@Bean` + `@Profile("test")`, or environment variable overrides in test classes.
- [Spring 4] Never import test annotations from Spring 3.x packages (`org.springframework.boot.test.autoconfigure.web.servlet.*`, `org.springframework.boot.test.mock.mockito.MockBean`); they do not exist in Spring 4.x and cause compilation failures.
- [Assertions] Never skip failure-path assertions or rely only on happy-path tests for API changes.
- [Assertions] Never leave database state shared across integration tests; use `@Transactional` for isolation.
- [Assertions] Never use test names that hide operation/condition/outcome or couple tests to unstable implementation details.

## Review Plan Layout
- Report added and updated tests by layer and purpose (unit, slice, integration).
- Report slice dependencies: which beans are mocked, which are auto-configured, which are imported.
- Report uncovered risk paths and planned follow-up.
- Report Spring 4 package compliance: verify all test annotations use correct Spring 4 import paths.
- Report architectural invariants enforced by governance tests.

