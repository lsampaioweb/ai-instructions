---
description: "Testing rules: slice vs full-context tests, @MockitoBean (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation."
applyTo: "**/*Test.java, **/*IT.java, **/test/**/*.java"
---

# Testing Rules

For cache behavior testing scope and deterministic TTL test setup, follow `spring-boot-caching.instructions.md`.
For version-coexistence regression tests (`v1`, `v2`) and deprecation-window coverage, follow `spring-boot-api-versioning.instructions.md`.

## Spring Boot Version Compatibility

Apply only the section matching the target project's Spring Boot version. Do not mix Spring Boot 3.x and 4.x test guidance in the same module.

### Spring Boot 4.x (verified on 4.1.0)

Spring Boot 4.x reorganized test slice infrastructure. Several annotations moved or were removed:

**`@WebMvcTest`**
- Moved to a separate module: add `spring-boot-starter-webmvc-test` (test scope) to `pom.xml`
- New import: `org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest`
- Use `@AutoConfigureMockMvc` (`org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc`) to get `MockMvc` injected
- `ObjectMapper` is NOT auto-configured in the `@WebMvcTest` limited context; instantiate directly: `ObjectMapper objectMapper = new ObjectMapper()`
- Spring Security's `SecurityFilterChain` is NOT auto-applied to MockMvc; 401/403 tests cannot be verified with `@WebMvcTest` alone — use `@SpringBootTest(webEnvironment = RANDOM_PORT)` with `TestRestTemplate` for security integration tests

**`@JdbcTest`**
- Removed from Spring Boot 4.x
- Replacement: `@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)` + `@ActiveProfiles("test")` + `@Transactional`
- `@Transactional` on the test class rolls back each test automatically, providing isolation without manual `DELETE` cleanup

**`@AutoConfigureTestDatabase`**
- Removed from Spring Boot 4.x
- Configure the test datasource directly in `application-test.yml`; H2 with `MODE=PostgreSQL` works for PostgreSQL-dialect schemas

**`@MockBean`**
- Deprecated in Spring Boot 4.x
- Use `@MockitoBean` exclusively (available since Spring Boot 3.4+)

### Spring Boot 3.x

**`@WebMvcTest`**
- Import: `org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest`
- Spring Security is auto-applied when `spring-boot-starter-security` is on the classpath
- `ObjectMapper` is auto-configured and can be `@Autowired`

**`@JdbcTest`**
- Import: `org.springframework.boot.test.autoconfigure.jdbc.JdbcTest`
- Combine with `@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)` when using a configured embedded datasource

---

## Test Types

### Controller tests (`@WebMvcTest`)
- Spring Boot 3.x: `@WebMvcTest(XxxController.class)` — loads only the web layer
- Spring Boot 4.x: `@WebMvcTest(XxxController.class)` + `@AutoConfigureMockMvc` from the `spring-boot-starter-webmvc-test` module
- Use `@MockitoBean` to stub all service dependencies
- Use `@WithMockUser(roles = "ROLE_NAME")` for tests that require an authenticated principal
- Do NOT test 401/403 in `@WebMvcTest` on Spring Boot 4.x — security filters are not applied

### Repository tests
- Spring Boot 3.x: `@JdbcTest` + `@AutoConfigureTestDatabase(replace = NONE)` + `@Import` for the repository class
- Spring Boot 4.x: `@SpringBootTest(webEnvironment = NONE)` + `@ActiveProfiles("test")` + `@Transactional`
- Configure an in-memory H2 datasource in `src/test/resources/application-test.yml` with `MODE=PostgreSQL` to support PostgreSQL-specific SQL syntax

### Service unit tests
- `@ExtendWith(MockitoExtension.class)` — no Spring context, pure Mockito
- `@Mock` for dependencies; `@InjectMocks` for the class under test
- Use BDDMockito (`given`/`willReturn`/`willThrow`) for stubbing

### Smoke test
- `@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.NONE)` + `@ActiveProfiles("test")`
- Assert at least one key bean is non-null: `assertThat(applicationContext).isNotNull()`
- Never use `@ActiveProfiles("development")` in tests — it requires a live external service

## Naming
Name test methods using the pattern: `{method}_when{Condition}_should{Outcome}`

Example: `findById_whenUserNotFound_shouldReturn404`

Test type examples:
- Slice test (`@WebMvcTest`): `findById_whenUserNotFound_shouldReturn404`
- Integration test (`@SpringBootTest`): `create_whenValidRequest_shouldPersistAndReturn201`
- Unit test (pure JUnit/Mockito): `validateEmail_whenFormatInvalid_shouldThrowException`
- Repository test: `insert_whenNewUser_shouldGenerateId`

## Assertions and Fixtures
- Use AssertJ (`assertThat`) for all assertions; do not use raw JUnit `assertEquals`
- Use `@ActiveProfiles("test")` when tests need to isolate from production configuration
- Set up fixtures in `@BeforeEach`; keep each fixture minimal and scoped to the test class
- Do not share mutable state between tests; reset mocks in `@BeforeEach` when needed

## Focus
- Assert on response status, body, and headers; do not assert on internal implementation details
- Keep each test focused on a single behavior

