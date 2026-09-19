---
description: "Global architecture baseline for Spring Boot generation and review. Apply before component-specific instruction files."
applyTo: "**/pom.xml, **/src/**"
---

## Dependencies

- Treat this section as the component instruction registry for Spring Boot application work.
- Apply `.github/instructions/spring-boot-architecture-defaults.instructions.md` as the project overlay after this shared baseline.
- Read each linked instruction file when planning or reviewing application components:
  - `.github/instructions/spring-boot-application.instructions.md` — Spring Boot main application entry-point contract for bootstrap class placement, annotation discipline, and startup configuration safety (`**/*Application.java`)
  - `.github/instructions/spring-boot-config.instructions.md` — Spring Boot configuration contract for `application.yml` structure, profile overrides, immutable property records, and safe externalized configuration (`**/src/main/resources/application*.yml, **/*ConfigurationProperties.java, **/*Properties.java`)
  - `.github/instructions/spring-boot-actuator.instructions.md` — Spring Boot Actuator dependency, endpoint exposure, health details, security, container probes, and tracing (`**/application*.yml, **/*Actuator*.java, **/*Actuator*Test.java`)
  - `.github/instructions/spring-boot-api-versioning.instructions.md` — URI path versioning for Spring REST API routes, coexistence strategy, deprecation headers, and DTO evolution (`**/*Controller.java, **/*Api.java, **/*ControllerTest.java, **/*Api*Test.java`)
  - `.github/instructions/spring-boot-async-events.instructions.md` — Spring application event publishing, event listeners, and asynchronous/broker-backed event infrastructure (`**/*EventPublisher.java, **/*EventListener.java, **/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java`)
  - `.github/instructions/spring-boot-container.instructions.md` — Container images and Docker Compose services for Spring Boot applications and supporting infrastructure (`**/Dockerfile, **/Dockerfile-*, **/docker-compose*.yml, **/compose*.yml, **/.dockerignore`)
  - `.github/instructions/spring-boot-controller.instructions.md` — Spring MVC and REST HTTP controllers: routes, request binding, validation, responses, views, and API documentation (`**/*Controller.java, **/*Api.java, **/*PageRoutes.java`)
  - `.github/instructions/spring-boot-database-schema.instructions.md` — PostgreSQL database schema and seed SQL scripts: types, naming, constraints, FK actions, and idempotent DDL (`**/src/main/resources/**/*.sql, **/src/main/resources/sql/**/*.xml`)
  - `.github/instructions/spring-boot-dto-mapper.instructions.md` — Spring DTO mappers for explicit request, response, query, and message transformations using MapStruct (`**/src/main/java/**/*Mapper.java, **/src/main/java/**/*DtoMapper.java, **/*Request.java, **/*Response.java, **/*Query.java, **/*Message.java`)
  - `.github/instructions/spring-boot-enum.instructions.md` — Spring Boot enum contract for deterministic closed-set domain values in API, domain, and persistence boundaries (`**/src/main/java/**/*Enum.java`)
  - `.github/instructions/spring-boot-error-code.instructions.md` — Stable API error codes, localized error message keys, and error-code response mapping (`**/*Exception.java, **/GlobalExceptionHandler.java, **/ErrorResponse.java, **/src/main/java/**/*ErrorCode.java`)
  - `.github/instructions/spring-boot-exception.instructions.md` — Spring exception hierarchy, translation, localized API errors, validation, and trace exposure (`**/*Exception*.java, **/*ExceptionHandler*.java, **/GlobalExceptionHandler.java, **/ErrorResponse.java, **/ValidationError.java`)
  - `.github/instructions/spring-boot-gitignore.instructions.md` — Git ignore rules for Spring Boot Maven applications, IDE metadata, generated logs, certificate files, and local secret files (`**/.gitignore`)
  - `.github/instructions/spring-boot-http-client.instructions.md` — Spring RestClient/WebClient configuration, outbound HTTP calls, response mapping, error handling, and integration tests (`**/*HttpClient*.java, **/*RestClient*.java, **/*ExternalApi*.java, **/http_client/**/*Service*.java`)
  - `.github/instructions/spring-boot-i18n.instructions.md` — Spring internationalization message bundles, locale resolution, namespace governance, and localized log/user-facing messages (`**/messages*.properties, **/LogMessages.java, **/*LocaleResolver.java, **/application*.yml`)
  - `.github/instructions/spring-boot-java-style.instructions.md` — Java coding style contract for imports, visibility, constants, annotations, methods, and helper extraction across all Java source files (`**/src/**/*.java`)
  - `.github/instructions/spring-boot-logging.instructions.md` — Spring Boot logback-spring.xml logging configuration, log-level policy, and MDC correlation (`**/logback-spring.xml, **/*Controller.java, **/*Service.java, **/*Repository.java, **/*Filter.java`)
  - `.github/instructions/spring-boot-model.instructions.md` — Spring Boot domain model contract for JDBC-first internal model types, boundary isolation, and persistence-free field declarations (`**/*Model.java`)
  - `.github/instructions/spring-boot-openapi.instructions.md` — Springdoc OpenAPI configuration, API metadata, localized documentation, stable spec paths, and OpenAPI availability tests (`**/OpenApiConfig.java, **/*OpenApi*Test.java, **/openapi/**/*.java`)
  - `.github/instructions/spring-boot-pagination.instructions.md` — Spring HATEOAS pagination and sorting for REST endpoints, services, repositories, and HTTP-client proxies (`**/*PageQuery.java, **/*Pagination*.java, **/*Controller.java, **/*Service.java, **/*Repository.java`)
  - `.github/instructions/spring-boot-pom.instructions.md` — Spring Boot Maven pom.xml: parent, properties, dependencies, and build plugins (`**/pom.xml`)
  - `.github/instructions/spring-boot-readme.instructions.md` — Spring Boot root README documentation: verified setup, execution, endpoints, profiles, infrastructure, and safe local configuration (`README.md, **/README.md`)
  - `.github/instructions/spring-boot-repository.instructions.md` — Spring repository adapters for JDBC-first database access, interface-implementation separation, Redis repositories, and SQL safety (`**/*Repository.java, **/*RepositoryImpl.java, **/*SqlConfigurationProperties.java, **/*SqlColumns.java`)
  - `.github/instructions/spring-boot-security.instructions.md` — Spring Security filter chains, route authorization, authentication defaults, CSRF decisions, and security tests (`**/*SecurityConfig.java, **/*SecurityConfiguration.java, **/security/**/*.java`)
  - `.github/instructions/spring-boot-service.instructions.md` — Spring service contracts and implementations: business orchestration, transactions, persistence, mapping, and domain errors (`**/*Service.java, **/*ServiceImpl.java`)
  - `.github/instructions/spring-boot-test.instructions.md` — Spring Boot test scope selection, isolation, Spring Boot 4.x import paths, deterministic fixtures, and contract-focused assertions (`**/src/test/java/**/*.java, **/src/test/resources/**`)
  - `.github/instructions/spring-boot-thymeleaf.instructions.md` — Spring MVC Thymeleaf pages, templates, forms, static resources, folder conventions, and partial AJAX updates (`**/*PageController.java, **/*PageRoutes.java, **/templates/**/*.html`)
  - `.github/instructions/spring-boot-websocket.instructions.md` — Spring WebSocket STOMP server and SockJS browser client configuration, messaging, connection tracking, and event handling (`**/WebSocket*.java, **/*SocketEndpoint.java, **/*Socket*.java, **/*Stomp*.java`)

## Rules

### Clarification gates
- When the user asks for defaults, apply governed defaults from activated instruction files without re-asking; before blocking questions, suppress any question already answered by an activated rule or default.

### Packaging
- Use feature-first packages as the default.
- Do not use layer packages such as `controller`, `service`, `repository`, or `exception`.
- Place every new production class under its owning feature root package; block generation when a class is proposed outside a feature root without explicit approval.
- Use `br.com.<organization>.<module-name>` as the root Java package; derive the module segment from `artifactId`.
- Name feature sub-packages with the bounded-context term.
- Do not repeat the module segment as the immediate child package (invalid: `com.org.module.module`).
- When the feature name matches the module segment, choose a distinct bounded-context name and document it.
- Keep feature-scoped `*Impl`, feature-scoped `@Component`/`@Configuration`/`@ConfigurationProperties`, and internal mappers package-private.
- Keep feature-internal controllers and domain models package-private unless a component-specific instruction file requires public visibility.
- Expose only public interfaces, DTOs (`*Request`, `*Response`, other DTO types), and explicit cross-feature contracts from a feature package.

### Shared types
- Place types with no single feature owner (e.g., `Pagination`, `ApiResponse`, `SortOrder`) in `shared`, organized by concept, not by technical layer (no `shared/service`, `shared/repository`).
- Treat a type as `shared` only when two or more distinct features depend on it.
- Keep feature-specific exception classes, error codes, and feature-scoped exception handlers in the owning feature package.
- Place module-global `@RestControllerAdvice` / `@ControllerAdvice` and shared error-envelope DTOs in `shared` (not under `shared.exception`); place other exception-related types in `shared` only when two or more features share the same semantic contract and that dependency is recorded in the plan.

### Precedence and deferrals
- Component-specific instruction files override this baseline only for their scoped target files.

### Completion
- Every modified Spring artifact must satisfy activated instruction files for its scope and intent.
- Each modified area needs at least one objective verification (build, test, lint, or deterministic static check) with a pass result.
- Mark every temporary exception with an inline code comment stating: the exception condition, its expiration criterion, and the instruction file rule being waived.
- State what passed, what failed, and what remains blocked when reporting completion; do not describe partial completion as done.

## Safety Guards
- Never use JPA, Jakarta Persistence, Hibernate, or any ORM framework in any application layer.
- Never generate datasource, database driver, or connection pool configuration without an active persistence-specific instruction file.

## Governed Spring Boot delivery
- Use the Spring Boot Orchestrator pipeline (Architect → Verifier → Coder → Reviewers → Documenter → Meta-Optimizer) for new features or non-trivial changes to `pom.xml` or `src/**`.
- Apply `.github/instructions/spring-boot-architecture.instructions.md` and `.github/instructions/spring-boot-architecture-defaults.instructions.md` before any component-specific instruction file.
- Require an approved ADR under `docs/adr/` with a complete `## Constraint Manifest` before implementation begins.
- Never let an agent silently waive a mandatory rule; surface the conflict and ask the user.
