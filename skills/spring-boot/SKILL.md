---
name: spring-boot
description: "Scaffold and generate Spring Boot features following project conventions. Use when: creating a new Spring Boot endpoint, controller, service, repository, domain object, DTO, request, response, exception class, MapStruct mapper, MyBatis mapper, XML mapper, i18n messages, or a complete feature from scratch. Covers packaging, layer structure, MyBatis, i18n, error handling, logging, and code style."
argument-hint: "Name of the feature or domain object to scaffold (e.g. 'User', 'Product')"
---

# Spring Boot Feature Scaffolding

## Before Generating

Read `spring-boot-architecture.instructions.md`. It governs every Java file generated below.
As each file is created, its specific instruction file loads automatically via `applyTo`.

## Generation Order

Generate each file fully before moving to the next.

### Shared infrastructure — create once per project, skip if already present

1. `pom.xml`
2. `application.yml`, `application-development.yml`, `application-production.yml`
3. `src/main/resources/log/logback-spring.xml`
4. `LogMessages.java` (utility for resolving i18n log message keys; injected by all classes that log)
5. `AppException.java` (abstract base class for all domain exceptions)
6. `ErrorResponse.java` (DTO returned by the controller advice)
7. `AppControllerAdvice.java` (single `@RestControllerAdvice` for the entire application)
8. `LocaleConfig.java` (registers the `LocaleResolver` bean)
9. `OpenApiConfig.java` *(optional — only when OpenAPI documentation is needed)*
10. `SwaggerConfig.java` *(optional — only if Swagger config is not in OpenApiConfig)*
11. `SecurityConfig.java` *(optional — only when Spring Security is needed)*
12. `src/main/resources/i18n/messages.properties`, `messages_pt_BR.properties`
13. `HealthIndicator.java` *(optional — for each custom health check; see actuator rules)*
14. `{Feature}ConfigurationProperties.java` *(optional — for each config group; see config rules)*
15. `README.md`

### Feature files — create for every new domain object

16. `{Domain}.java`
17. `Create{Domain}Request.java`, `Update{Domain}Request.java`, `{Domain}Response.java`
18. `{Domain}Mapper.java` (MapStruct)
19. `{Domain}NotFoundException.java`
20. `{Domain}Repository.java` *(only when database is yes)*
21. `src/main/resources/mapper/{Domain}Mapper.xml` *(only when database is yes)*
22. `src/main/resources/sql/schema.sql` *(only when database is yes; append, do not overwrite)*
23. `{Domain}Service.java`, `{Domain}ServiceImpl.java`
24. `{Domain}Controller.java`
25. `{Domain}ControllerTest.java`
26. `{Domain}ServiceTest.java`
27. `{Domain}Event.java`, `{Domain}Listener.java`, `{Domain}Publisher.java` *(optional — only for async/event-driven features)*
28. `{Domain}ConfigurationProperties.java` *(optional — for domain-specific config groups)*
29. Add i18n keys to `messages.properties` and `messages_pt_BR.properties`

## Pre-generation Gate

Before generating any file, confirm all of the following. If any item is missing or ambiguous, stop and ask — do not infer or auto-fill:

- **Domain object name** (e.g. `User`)
- **Base package** (e.g. `com.example`)
- **Fields** — each as `name: type [validations]`, e.g. `email: String [@NotBlank, @Email]`
- **Database?** — generate repository, XML mapper, and schema SQL only when yes
