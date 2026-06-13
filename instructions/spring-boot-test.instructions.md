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
- For repositories using `NamedParameterJdbcTemplate`, use `@JdbcTest`
- Never use `@DataJpaTest` (ORM-based repository testing is out of scope for this architecture)
- Never use `@DataJdbcTest` for `NamedParameterJdbcTemplate` repositories; prefer `@JdbcTest` instead

## Naming
Name test methods using the pattern: `{method}_when{Condition}_should{Outcome}`

Example: `findById_whenUserNotFound_shouldReturn404`

## Assertions and Fixtures
- Use AssertJ (`assertThat`) for all assertions; do not use raw JUnit `assertEquals`
- Use `@ActiveProfiles("test")` when tests need to isolate from production configuration
- Set up fixtures in `@BeforeEach`; keep each fixture minimal and scoped to the test class
- Do not share mutable state between tests; reset mocks in `@BeforeEach` when needed

## Focus
- Assert on response status, body, and headers; do not assert on internal implementation details
- Keep each test focused on a single behavior

## Templates

`@WebMvcTest` controller test skeleton. Replace `{Resource}`, `{resource}`, `{resources}`, and field names with actual project values.

```java
@WebMvcTest({Resource}Controller.class)
@ActiveProfiles("test")
class {Resource}ControllerTest {

  @Autowired
  private MockMvc mockMvc;

  @MockitoBean
  private {Resource}Service {resource}Service;

  private {Resource}Response sample{Resource};

  @BeforeEach
  void setUp() {
    sample{Resource} = new {Resource}Response(1L, "Sample Name", "Sample Description");
  }

  @Test
  void findById_when{Resource}Exists_shouldReturn200() throws Exception {
    given({resource}Service.findById(1L)).willReturn(sample{Resource});

    mockMvc.perform(get("/api/v1/{resources}/1"))
      .andExpect(status().isOk())
      .andExpect(jsonPath("$.id").value(1L))
      .andExpect(jsonPath("$.name").value("Sample Name"));
  }

  @Test
  void findById_when{Resource}NotFound_shouldReturn404() throws Exception {
    given({resource}Service.findById(99L)).willThrow(new {Resource}NotFoundException(99L));

    mockMvc.perform(get("/api/v1/{resources}/99"))
      .andExpect(status().isNotFound());
  }

  @Test
  void create_whenValidRequest_shouldReturn201() throws Exception {
    given({resource}Service.create(any())).willReturn(sample{Resource});

    mockMvc.perform(post("/api/v1/{resources}/")
        .contentType(MediaType.APPLICATION_JSON)
        .content("{\"name\":\"Sample Name\",\"description\":\"Sample Description\"}"))
      .andExpect(status().isCreated());
  }

  @Test
  void create_whenInvalidRequest_shouldReturn400() throws Exception {
    mockMvc.perform(post("/api/v1/{resources}/")
        .contentType(MediaType.APPLICATION_JSON)
        .content("{}"))
      .andExpect(status().isBadRequest());
  }
}
```
