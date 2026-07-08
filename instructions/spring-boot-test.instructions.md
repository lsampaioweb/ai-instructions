---
description: "Testing rules: slice vs full-context tests, @MockitoBean (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation."
applyTo: "**/*Test.java, **/*IT.java, **/test/**/*.java"
---

# Testing Rules

## Test Types
- Use `@WebMvcTest` for controller tests; it loads only the web layer without starting the full context
- Use `@SpringBootTest` only for integration tests that require the full application context; prefer slice tests otherwise
- Use `@MockitoBean` to override beans in slice tests; use `@Mock` / `@InjectMocks` in pure unit tests (`@MockitoBean` requires Spring Boot 3.4+)
- Use `@MockBean` only as a compatibility fallback for projects on Spring Boot < 3.4
- For MyBatis mapper tests, use `@MybatisTest` when `mybatis-spring-boot-starter-test` is present on the classpath
- For repositories using `JdbcClient` (and `NamedParameterJdbcTemplate` for batch operations), use `@JdbcTest`
- Never use `@DataJpaTest` (ORM-based repository testing is out of scope for this architecture)
- Never use `@DataJdbcTest` for `JdbcClient` / `NamedParameterJdbcTemplate` repositories; prefer `@JdbcTest` instead

## Naming
Name test methods using the pattern: `{method}_when{Condition}_should{Outcome}`

Example: `findById_whenUserNotFound_shouldReturn404`

Test type examples:
- Slice test (`@WebMvcTest`): `findById_whenUserNotFound_shouldReturn404`
- Integration test (`@SpringBootTest`): `create_whenValidRequest_shouldPersistAndReturn201`
- Unit test (pure JUnit/Mockito): `validateEmail_whenFormatInvalid_shouldThrowException`
- Repository test (`@JdbcTest` or `@MybatisTest`): `insert_whenNewUser_shouldGenerateId`

## Assertions and Fixtures
- Use AssertJ (`assertThat`) for all assertions; do not use raw JUnit `assertEquals`
- Use `@ActiveProfiles("test")` when tests need to isolate from production configuration
- Set up fixtures in `@BeforeEach`; keep each fixture minimal and scoped to the test class
- Do not share mutable state between tests; reset mocks in `@BeforeEach` when needed

## Focus
- Assert on response status, body, and headers; do not assert on internal implementation details
- Keep each test focused on a single behavior

