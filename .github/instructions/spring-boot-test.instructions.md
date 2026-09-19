---
description: "Spring Boot test scope selection, isolation, deterministic fixtures, Spring Boot 4.x import paths, and contract-focused assertions."
applyTo: "**/src/test/java/**/*.java, **/src/test/resources/**"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for test-source structure and formatting.
- Follow `spring-boot-security.instructions.md` for security-chain test scope and authorization assertions; this file owns only generic test-slice mechanics.

## Naming Conventions
- Name test classes after the component or behavior they verify, ending in `Test`, `Tests`, or `IntegrationTest`.
- Name test methods in camelCase starting with `should`, stating the expected result, followed by `when<Condition>` when a condition is relevant (e.g., `shouldTransferSuccessfullyWhenSufficientBalance`). Do not use underscores in test method names.

## Rules

### Test scope and isolation
- Select the narrowest test scope that exercises the required contract.
- Use layer-appropriate test slices: `@WebMvcTest(ControllerClass.class)` for HTTP contract tests, `@JdbcTest` for repository tests, `@ExtendWith(MockitoExtension.class)` for unit tests, `@SpringBootTest` only when the test requires the full application context or end-to-end framework wiring.
- Prefer narrow test slices (`@WebMvcTest`, `@JdbcTest`) over `@SpringBootTest` for single-layer tests.
- Isolate external systems with collaborator mocks, mock HTTP servers, or bounded test configuration.
- Provide test resource configuration only when a feature needs deterministic framework startup settings.

### Spring Boot 4.x import paths
- Import `@WebMvcTest` from `org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest` (module `spring-boot-webmvc-test`).
- Import `@JdbcTest` from `org.springframework.boot.jdbc.test.autoconfigure.JdbcTest` (module `spring-boot-jdbc-test`).
- Import `@MockitoBean` from `org.springframework.test.context.bean.override.mockito.MockitoBean`.
- Do not import `@MockBean` or annotations from `org.springframework.boot.test.mock.mockito` / `org.springframework.boot.test.autoconfigure.web.servlet`.
- Use `MockMvcTester` (from `org.springframework.test.web.servlet.assertj.MockMvcTester`) for AssertJ-native controller assertions in `@WebMvcTest` slices.
- Use `RestTestClient` (from `org.springframework.test.web.servlet.client.RestTestClient`, module `spring-boot-resttestclient`) for testing REST endpoints against a running server in `@SpringBootTest(webEnvironment = RANDOM_PORT)` tests.

### WebMvcTest specifics
- For `@WebMvcTest` classes that serialize JSON fixtures, explicitly enable JSON auto-configuration in the test slice before autowiring `ObjectMapper`; serialize request and response fixtures using the slice-configured `ObjectMapper` (or `JacksonTester`).
- Handcraft JSON strings only for intentionally malformed-payload tests.
- For `@WebMvcTest` classes that invoke controller methods with `Pageable` parameters, enable Spring Data web argument-resolver auto-configuration with `@ImportAutoConfiguration(SpringDataWebAutoConfiguration.class)` and confirm `PageableHandlerMethodArgumentResolver` is active.
- Execute at least one request that includes `page`, `size`, and `sort` query parameters in those `@WebMvcTest` classes.
- When a controller under test depends on a `*LogMessages` component in `@WebMvcTest`, declare a matching `@MockitoBean` for that concrete `*LogMessages` type.

### JdbcTest and security tests
- When `@JdbcTest` requires a custom repository implementation, explicitly `@Import({RepositoryImpl.class, JdbcConfig.class})` and ensure `JdbcClient` is a `@Bean`.
- Declare `@Configuration` classes imported via `@Import` as `public` when required by the test slice, in a scannable package; this overrides architecture package-private for that class only.
- For security-chain tests with `@SpringBootTest`, manually configure MockMvc with `webAppContextSetup(context).apply(springSecurity()).build()`, using static imports from `org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers` and `org.springframework.test.web.servlet.setup.MockMvcBuilders`.

### Environment classification
- Classify test failures caused by DBMS runtime unavailability as environment blockers.
- Skip only database-coupled tests when the DBMS runtime is unavailable; continue non-database tests and report the concrete DBMS failure signal.
- Keep database-coupled tests enabled when the required DBMS runtime is healthy and reachable.
- For tests covering applications with Redis listeners, message consumers, schedulers, or other startup-managed external clients, disable external startup in the context test and test the client behavior separately with a focused unit or integration test.

### Assertions and fixtures
- Assert observable behavior: returned values, HTTP status and body, configured values, or explicit exception contracts.
- Keep fixtures focused on the behavior under test; make test data deterministic using builder or dedicated factory methods.
- Use `java.time.Month` enum constants for static date fixtures in `LocalDate.of` calls.
- Restore mutated global state, such as `LocaleContextHolder`, after each test.
- Verify mock-server expectations when using `MockRestServiceServer`.
- Apply `@Transactional` to database-touching integration tests for rollback isolation.
- Use AssertJ (`assertThat(...)`) for all test assertions.
- Remove unused `@MockitoBean` stubs.

### Test quality
- Test real behavior instead of implementation details.
- Do not add production-only methods solely to make code testable.
- Do not rely on incomplete mocks; stub every collaborator interaction required by the exercised path.
- Keep service tests focused on business rules and edge cases; keep response-structure assertions explicit for API tests.
- Write at minimum one happy-path test and one failure-path test for each public service method and each REST controller endpoint.
- Add governance tests when architecture invariants require enforcement.
- Keep empty string literals inline only when the test explicitly validates blank-input behavior.
- Keep single-use malformed payload fragments inline only in intentionally invalid-payload tests.
- Keep single-use domain fixture labels inline only when they appear in exactly one test method and extracting them would reduce readability.
- Run the module's Maven test command and collect IDE diagnostics for every modified source file before reporting completion; treat remaining diagnostics as unresolved until classified and fixed or explicitly documented as environment-only.

### Test profile policy
- Run tests under `development` or `production`; no dedicated test profile exists.
- Use inline `@Bean` methods or environment variable overrides in test classes instead of a dedicated test profile file.
- Add `@AutoConfigureTestDatabase(replace=NONE)` only when explicitly targeting a real external datasource.

## Safety Guards
- Never add an explicit test datasource configuration for test slices.
- Never diagnose `Pageable` constructor/instantiation failures in `@WebMvcTest` as controller logic defects before confirming Spring Data web resolver auto-configuration is active.

## Reference
- Use [samples/spring-boot-context-load-test.tpl](samples/spring-boot-context-load-test.tpl) for application-context smoke tests.
- Use [samples/spring-boot-unit-test.tpl](samples/spring-boot-unit-test.tpl) for isolated unit tests.
- Use [samples/spring-boot-webmvc-test.tpl](samples/spring-boot-webmvc-test.tpl) for MVC controller slice tests.
- Use [samples/spring-boot-integration-test.tpl](samples/spring-boot-integration-test.tpl) for full-context integration tests.
