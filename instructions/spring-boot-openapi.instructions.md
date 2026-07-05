---
description: "OpenAPI/Swagger rules: springdoc-openapi setup, OpenAPI bean, endpoint annotation, and profile-based UI toggle."
applyTo: "**/*OpenApiConfig*.java, **/*SwaggerConfig*.java, **/*Controller.java, **/*Api.java"
---

# OpenAPI Rules

## Scope
- Applies to REST API OpenAPI documentation generation and Swagger UI visibility by profile

## Dependency
- Include `springdoc-openapi-starter-webmvc-ui` in every project that exposes at least one REST JSON API endpoint; OpenAPI documentation is mandatory for REST APIs
- Never use springfox

## Version Management
- Springdoc is not managed by `spring-boot-starter-parent`, so it requires explicit version management
- For Spring Boot 4.x, use Springdoc 3.x; for Spring Boot 3.x, use Springdoc 2.x
- Follow the canonical third-party version-property policy in `spring-boot-pom.instructions.md` (`## Version Management for Third-Party Libraries`) instead of redefining it here

## OpenAPI Bean (Required)
- Define a single `OpenAPI` bean in a dedicated `@Configuration` class with project title, version, and description (contact is optional)
- Rely on Springdoc auto-generation for endpoint discovery, schema inference, and default response code mapping
- Without endpoint annotations, generated summaries are auto-derived
- With endpoint annotations, summaries and response descriptions are explicit

## Endpoint Annotations (Optional, Advanced)
- For production APIs or explicit API-contract scopes, annotate each endpoint with `@Operation` and relevant `@ApiResponse` entries
- Add `@Parameter` only when parameter description or constraints are not clear from the method signature
- In earliest tutorial/learning samples where brevity is the explicit goal, endpoint annotations may be omitted

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
