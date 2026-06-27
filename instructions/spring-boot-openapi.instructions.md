---
description: "OpenAPI/Swagger rules: springdoc-openapi setup, OpenAPI bean, endpoint annotation, and profile-based UI toggle."
applyTo: "**/*OpenApiConfig*.java, **/*SwaggerConfig*.java, **/*Controller.java, **/*Api.java"
---

# OpenAPI Rules

## Dependency
- Include `springdoc-openapi-starter-webmvc-ui` in every project that exposes at least one REST JSON API endpoint; OpenAPI documentation is mandatory for REST APIs
- Never use springfox

## Version Management
- Springdoc is not managed by `spring-boot-starter-parent`, so it requires explicit version management
- For Spring Boot 4.x, use Springdoc 3.x; for Spring Boot 3.x, use Springdoc 2.x
- Declare the version in the `<properties>` section and reference it in the dependency using `${springdoc.version}`:

```xml
<properties>
  <springdoc.version>3.0.1</springdoc.version>
</properties>
```

Then in the dependency block:
```xml
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>${springdoc.version}</version>
</dependency>
```

- This centralizes version updates to one location and avoids hardcoding across multiple dependencies

## OpenAPI Bean (Required)
Define a single `OpenAPI` bean in a dedicated `@Configuration` class with project title, version, and description (contact is optional).

**Why only the bean?** Springdoc auto-generates the full OpenAPI specification from your controller code:
- All endpoints are discovered automatically
- Request/response schemas are inferred from method signatures
- Response codes are auto-detected from Spring's default HTTP conventions
- The Swagger UI is fully interactive—developers can expand endpoints, set values, and test them

**Without annotations**, the spec shows auto-generated summaries. **With annotations**, it shows custom descriptions. Both work; annotations are optional for tutorial/learning code.

## Endpoint Annotations (Optional, Advanced)
For production APIs, enhance the auto-generated spec with custom documentation:
- Annotate each controller method with `@Operation(summary = "...")` — one short sentence
- Annotate each possible response with `@ApiResponse(responseCode = "...", description = "...")`
- Annotate request body and path variable parameters with `@Parameter` only when needed

The controller template includes `@Tag` and `@Operation` as the production baseline. These annotations may be omitted in the earliest learning samples where brevity is the explicit goal; add them as the project matures or when a defined API contract is needed.

## Profile Visibility
- Disable Swagger UI in the production profile:

```yaml
springdoc:
  swagger-ui:
    enabled: false
```

- Enable it in the development profile; it does not need to be accessible in production or test environments
- Configure these profile toggles in `application-development.yml` and `application-production.yml` when profile files are in scope.

## Templates

**OpenAPI bean (required).** Replace project title, version, and description with actual values.

```java
@Configuration
public class OpenApiConfig {

  @Bean
  public OpenAPI customOpenAPI() {
    return new OpenAPI()
      .info(new Info()
        .title("{Project} API")
        .version("1.0.0")
        .description("REST API for {project resources}"));
  }
}
```

**Controller method annotations (optional, for enhanced documentation):**

```java
@Operation(summary = "Find a {resource} by id")
@ApiResponse(responseCode = "200", description = "{Resource} found")
@ApiResponse(responseCode = "404", description = "{Resource} not found")
@GetMapping("/{id}")
public ResponseEntity<{Resource}Response> findById(@PathVariable Long id) { ... }
```
