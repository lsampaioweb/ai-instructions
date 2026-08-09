---
description: "Spring Boot testing contract for layer-focused tests, API-contract assertions, and cross-cutting governance checks."
applyTo: "**/src/test/java/**/*.java"
---

# Spring Boot Test Engine

## Naming Conventions
- Name test methods using the pattern `<operation>_when<Condition>_should<ExpectedResult>` (e.g., `transfer_whenSufficientBalance_shouldTransferSuccessfully`).

## Rules
- Use `spring-boot-java-style.instructions.md` as the cross-cutting baseline for repeated string-literal extraction in test classes.
- Use layer-appropriate test slices: `@WebMvcTest(ControllerClass.class)` for HTTP contract tests, `@JdbcTest` for repository tests, `@ExtendWith(MockitoExtension.class)` for unit tests, `@SpringBootTest` for full integration tests.
- Prefer narrow test slices (`@WebMvcTest`, `@JdbcTest`) over `@SpringBootTest` for single-layer tests.
- Import `@WebMvcTest` from `org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest` (module `spring-boot-webmvc-test`).
- Import `@JdbcTest` from `org.springframework.boot.jdbc.test.autoconfigure.JdbcTest` (module `spring-boot-jdbc-test`).
- Import `@MockitoBean` from `org.springframework.test.context.bean.override.mockito.MockitoBean`.
- Use Spring Boot 4.x test import paths only.
- Do not import `@MockBean` or annotations from `org.springframework.boot.test.mock.mockito` / `org.springframework.boot.test.autoconfigure.web.servlet`.
- Use `MockMvcTester` (from `org.springframework.test.web.servlet.assertj.MockMvcTester`) for AssertJ-native controller assertions in `@WebMvcTest` slices.
- Use `RestTestClient` (from `org.springframework.test.web.servlet.client.RestTestClient`, module `spring-boot-resttestclient`) for testing REST endpoints against a running server in `@SpringBootTest(webEnvironment = RANDOM_PORT)` tests.
- For `@WebMvcTest` classes that serialize JSON fixtures, explicitly enable JSON auto-configuration in the test slice before autowiring `ObjectMapper`.
- For `@WebMvcTest`, serialize request and response fixtures using the slice-configured `ObjectMapper` (or `JacksonTester`).
- Handcraft JSON strings only for intentionally malformed-payload tests.
- For `@WebMvcTest` classes that invoke controller methods with `Pageable` parameters, enable Spring Data web argument-resolver auto-configuration with `@ImportAutoConfiguration(SpringDataWebAutoConfiguration.class)`.
- Confirm `PageableHandlerMethodArgumentResolver` is active in those `@WebMvcTest` classes.
- Execute at least one request that includes `page`, `size`, and `sort` query parameters in those `@WebMvcTest` classes.
- When a controller under test depends on a `*LogMessages` component in `@WebMvcTest`, declare a matching `@MockitoBean` for that concrete `*LogMessages` type.
- Classify test failures caused by SGBD runtime unavailability as environment blockers.
- Skip only database-coupled tests when the SGBD runtime is unavailable.
- Continue non-database tests when the SGBD runtime is unavailable.
- Report the concrete SGBD failure signal when the runtime is unavailable.
- Keep database-coupled tests enabled when the required SGBD runtime is healthy and reachable.
- When `@JdbcTest` requires a custom repository implementation, explicitly `@Import({RepositoryImpl.class, JdbcConfig.class})` and ensure `JdbcClient` is a `@Bean`.
- Declare `@Configuration` classes imported via `@Import` as `public` when required by the test slice; this overrides architecture package-private for that class only.
- Place imported `@Configuration` classes in a scannable package.
- For security-chain tests with `@SpringBootTest`, manually configure MockMvc with `webAppContextSetup(context).apply(springSecurity()).build()`.
- Use static imports from `org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers` and `org.springframework.test.web.servlet.setup.MockMvcBuilders`.
- Apply `@Transactional` to database-touching integration tests for rollback isolation.
- Use builder or dedicated factory methods for test data.
- Use `java.time.Month` enum constants for static date fixtures in `LocalDate.of` calls.
- Keep service tests focused on business rules and edge cases.
- Keep response-structure assertions explicit for API tests.
- Assert success and failure paths for each changed behavior.
- Write at minimum one happy-path test and one failure-path test for each public service method and each REST controller endpoint.
- Add governance tests when architecture invariants require enforcement.
- Use AssertJ (`assertThat(...)`) for all test assertions.
- Remove unused `@MockitoBean` stubs.
- Run tests under `development` or `production`; no dedicated test profile exists.
- Use inline `@Bean` methods or environment variable overrides in test classes instead of a dedicated test profile file.
- Add `@AutoConfigureTestDatabase(replace=NONE)` only when explicitly targeting a real external datasource.

## Approved Exception Handling
- Keep empty string literals inline only when the test explicitly validates blank-input behavior.
- Keep single-use malformed payload fragments inline only in intentionally invalid-payload tests.
- Keep single-use domain fixture labels inline only when they appear in exactly one test method and extracting them would reduce readability.

## Safety Guards
- Never use `@ActiveProfiles("test")` on any test class.
- Never create `application-test.yml`.
- Never add an explicit test datasource configuration for test slices.
- Never diagnose `Pageable` constructor/instantiation failures in `@WebMvcTest` as controller logic defects before confirming Spring Data web resolver auto-configuration is active.
