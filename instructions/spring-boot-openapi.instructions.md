---
description: "OpenAPI/Swagger rules: springdoc-openapi setup, OpenAPI bean, endpoint annotation, and profile-based UI toggle."
applyTo: "**/*OpenApiConfig*.java, **/*SwaggerConfig*.java, **/*Controller.java, **/*Api.java"
---

# OpenAPI Rules

## Dependency
- Include `springdoc-openapi-starter-webmvc-ui` in every project that exposes at least one HTTP endpoint; OpenAPI documentation is mandatory
- Never use springfox

## OpenAPI Bean
Define a single `OpenAPI` bean in a dedicated `@Configuration` class with project title, version, description, and contact information.

## Endpoint Annotations
- Annotate each controller method with `@Operation(summary = "...")` — one short sentence
- Annotate each possible response with `@ApiResponse(responseCode = "...", description = "...")`
- Annotate request body and path variable parameters with `@Parameter` only when needed; do not duplicate information already expressed by the method signature, HTTP method, or return type

## Profile Visibility
- Disable Swagger UI in the production profile:

```yaml
springdoc:
  swagger-ui:
    enabled: false
```

- Enable it in the development profile; it does not need to be accessible in production or test environments

## Templates

**OpenAPI bean.** Replace project title, version, description, team name, email, and URL with actual values.

```java
@Configuration
class OpenApiConfig {

  @Bean
  OpenAPI openAPI() {
    return new OpenAPI()
      .info(new Info()
        .title("{Project} API")
        .version("1.0.0")
        .description("REST API for managing {project resources}")
        .contact(new Contact()
          .name("{Team Name}")
          .email("{team@example.com}")
          .url("https://{team-url}")));
  }
}
```

**Controller method annotations.** Add `@Operation` and `@ApiResponse` to every handler method. Replace `{resource}` and status descriptions with actual values.

```java
@Operation(summary = "Find a {resource} by id")
@ApiResponse(responseCode = "200", description = "{Resource} found")
@ApiResponse(responseCode = "404", description = "{Resource} not found")
@GetMapping("/{id}")
public ResponseEntity<{Resource}Response> findById(@PathVariable Long id) { ... }
```
