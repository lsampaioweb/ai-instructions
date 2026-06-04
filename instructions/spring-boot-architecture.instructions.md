---
description: "Feature-based packaging, dependency flow, visibility, domain object rules, interface conventions, and code style for all Java and Spring Boot files."
---

# Spring Boot Architecture Conventions

## Project Setup
- Use Maven. See [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md) for all POM rules.
- Target the latest stable Spring Boot and Java versions for new projects. For existing projects, detect the version from `pom.xml` and apply compatible rules without suggesting upgrades unless asked.

## Project Layout
Non-Java project files belong at the project root, never inside `src/`:

```text
project-root/
├── .dockerignore
├── .env
├── .gitignore
├── docker-compose.yml
├── Dockerfile
├── pom.xml
├── README.md
├── logs/
│   └── container/
│       └── .keep
├── ssl/
│   └── .keep
└── src/
    ├── main/
    │   ├── java/
    │   └── resources/
    │       ├── application.yml
    │       ├── application-development.yml
    │       ├── application-production.yml
    │       ├── i18n/
    │       │   ├── messages.properties
    │       │   └── messages_pt_BR.properties
    │       └── log/
    │           └── logback-spring.xml
    └── test/
        └── java/
```

## Code Style
- 2 spaces for indentation; never use tabs
- Use modern Java features where the project's Java version supports them: records, pattern matching, sealed classes, text blocks
- Add a blank line before every `return` statement unless the method body is a single expression
- Separate logically distinct blocks within a method body with a blank line (e.g. between validation, data retrieval, transformation, and return)
- Do not add a blank line after every single statement; use spacing to group related lines, not to isolate them

## Packaging
Organize code by feature or domain. Use packages like `user`, `product`, `order`, `config`, `integration`. Do not create generic root packages named `controller`, `service`, or `repository`.

Keep all classes for a feature together in one package. Example: `UserController`, `UserService`, `UserMapper`, `User`, `CreateUserRequest`, and `UserNotFoundException` all belong in `com.example.user`.

## Visibility
Use the narrowest visibility that works:
- `private` for helpers not used outside the class
- Package-private (no modifier) for classes and methods used only within the same feature package
- `public` only for types and methods that must be accessible from outside the package

## Interfaces
Define interfaces for services and any component that may have multiple implementations or needs to be mocked in tests. A dedicated interface is not required for one-off utilities or configuration classes that are never tested in isolation.

## Dependency Flow
One-way only: `controller → service → repository` or `service → integration client`. Skip-layer calls are not allowed.

Specific rules:
- `UserController` calls `UserService`; it does not call `UserMapper` or integration clients directly
- `UserService` calls `UserMapper`, repositories, and integration clients
- `UserMapper` has no knowledge of web concerns; it does not use `ResponseEntity` or any web-layer class
- Integration clients do not call controllers and do not depend on web-layer classes

## Dependency Injection
Use constructor injection for all Spring-managed dependencies. Never use `@Autowired` on fields.

## Domain Objects and API Boundaries
- Domain objects are plain Java records or classes with no persistence annotations
- Use Java records for immutable domain objects; use a class only when mutation is genuinely necessary
- Field names and types map to SQL result sets via MyBatis result maps defined in XML; no annotations are required on the domain class itself
- Never expose domain objects in controller responses or request parameters; pass DTOs across all API boundaries

## No ORM
Never use JPA, Hibernate, or any ORM framework. Do not annotate domain objects with `@Entity`, `@Table`, `@Column`, or any ORM annotation. Do not add ORM dependencies to the project. Use MyBatis or Spring JDBC Templates for all data access. See [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) for data access rules.

## Object Mapping
Use MapStruct for all object mapping between layers. See [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md) for mapper conventions.

## Exception Handling
Centralize all exception handling in a single `@RestControllerAdvice` class. See [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) for the full pattern.

## Logging
Use `@Slf4j` (Lombok) for all logging. See [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md) for level and content rules.

## i18n Text and Constants
- Never hardcode human-readable text (messages, labels, error descriptions) as string literals in Java code. All text must be defined in `messages.properties` and referenced by its i18n key. See [spring-boot-i18n.instructions.md](./spring-boot-i18n.instructions.md) for message file rules.
- Declare i18n key strings as `private static final String` constants at the top of the class; never pass key literals inline
- Name constants in `UPPER_SNAKE_CASE` that describes the message, not the key string value

Bad:
```java
log.debug(logMessages.get("log.user.find.all"));
```

Good:
```java
private static final String LOG_USER_FIND_ALL = "log.user.find.all";

log.debug(logMessages.get(LOG_USER_FIND_ALL));
```

## Scope Control
Only produce what was explicitly requested. Do not add tests, CI configuration, infrastructure code, documentation, comments, or boilerplate unless asked.
During implementation, generate only the minimum set of files and changes required for the user request. Do not add optional modules, endpoints, configs, or integrations unless explicitly requested or strictly required by an active instruction rule.

## Architectural Preservation
Do not introduce new layers, patterns, dependencies, abstractions, or frameworks unless explicitly requested. When changes are needed, work within the existing structure.
If a requested change cannot be correctly implemented within the existing structure without introducing new dependencies or patterns, explicitly state that limitation and describe the minimum structural change required before proceeding, rather than producing a broken or partial implementation.

## Execution Integrity
Never claim success for build, test, lint, or runtime validation unless a command was actually executed and completed successfully.
If any diagnostics still report errors, state that clearly and do not present the task as fully validated.

## Anti-Hallucination
Do not invent or assume API signatures, configuration keys, framework behavior, or codebase conventions not visible in the current context or official documentation. When uncertain, say so explicitly rather than proceeding with a guess.

## Formatting
After creating or editing a file, format it using the project's configured formatter or language tooling when available.
If no formatter is configured or accessible in the current environment, preserve the existing style and keep formatting changes limited to the touched code.
Never claim a file was formatted unless formatting actually ran successfully.

---

## Project Blueprint

### Required inputs before generating any file

Confirm all of the following before creating any file. If any item is missing or ambiguous, stop and ask — do not infer or auto-fill:

- **Project initialized?** — if not, initialize first; see [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md)
- **Domain object name** (e.g. `User`)
- **Base package** (e.g. `com.example`)
- **Fields** — each as `name: type [validations]`, e.g. `email: String [@NotBlank, @Email]`
- **Database?** — yes or no; drives repository, XML mapper, and schema SQL generation

### Generation order

Generate each file fully before moving to the next.

When planning a brand-new Spring Boot application, enumerate the mandatory shared infrastructure files from the "Shared infrastructure — create once per project" section explicitly in the plan. Do not collapse them into vague phrases such as "minimum config files" or "basic setup".

#### Shared infrastructure — create once per project, skip if already present

| File | Instruction |
|------|-------------|
| `.gitignore`, `.dockerignore` | Root-level boilerplate (create once, no instruction file) |
| `pom.xml` | [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md) |
| `application.yml`, `application-development.yml`, `application-production.yml` | [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) |
| `src/main/resources/log/logback-spring.xml`, `LogMessages.java` | [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md) |
| `AppException.java`, `ErrorResponse.java`, `AppControllerAdvice.java` | [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) |
| `ActuatorConfig.java` | [spring-boot-actuator.instructions.md](./spring-boot-actuator.instructions.md) |
| `LocaleConfig.java`, `messages.properties`, `messages_pt_BR.properties` | [spring-boot-i18n.instructions.md](./spring-boot-i18n.instructions.md) |
| `ssl/` folder with `.keep` | SSL certificates folder (create empty, populate later if needed) |
| `README.md` | [spring-boot-readme.instructions.md](./spring-boot-readme.instructions.md) |

#### Shared infrastructure — optional, include only when needed

| File | When | Instruction |
|------|------|-------------|
| `OpenApiConfig.java` | OpenAPI documentation needed | [spring-boot-openapi.instructions.md](./spring-boot-openapi.instructions.md) |
| `SwaggerConfig.java` | Swagger config not in `OpenApiConfig` | [spring-boot-openapi.instructions.md](./spring-boot-openapi.instructions.md) |
| `SecurityConfig.java` | Spring Security needed | [spring-boot-security.instructions.md](./spring-boot-security.instructions.md) |
| `HealthIndicator.java` | Custom health check needed | [spring-boot-actuator.instructions.md](./spring-boot-actuator.instructions.md) |
| `{Feature}ConfigurationProperties.java` | Grouped config block needed | [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) |

#### Feature files — create for every new domain object

| File | Instruction |
|------|-------------|
| `{Domain}.java` | [spring-boot-architecture.instructions.md](./spring-boot-architecture.instructions.md) |
| `Create{Domain}Request.java`, `Update{Domain}Request.java`, `{Domain}Response.java`, `{Domain}Mapper.java` | [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md) |
| `{Domain}NotFoundException.java` | [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) |
| `{Domain}Repository.java`, `src/main/resources/mapper/{Domain}Mapper.xml`, `src/main/resources/sql/schema.sql` *(all database only; append SQL, never overwrite)* | [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) |
| `{Domain}Repository.java` (interface) + `{Domain}RepositoryImpl.java` *(filesystem only; no database)* | [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) |
| `{Domain}Service.java`, `{Domain}ServiceImpl.java` | [spring-boot-service.instructions.md](./spring-boot-service.instructions.md) |
| `{Domain}Controller.java` | [spring-boot-controller.instructions.md](./spring-boot-controller.instructions.md) |
| `{Domain}ControllerTest.java`, `{Domain}ServiceTest.java` | [spring-boot-test.instructions.md](./spring-boot-test.instructions.md) |

#### Feature files — optional

| File | When | Instruction |
|------|------|-------------|
| `{Feature}Client.java`, `{Feature}ApiClient.java` | Integrating with external APIs | [spring-boot-http-client.instructions.md](./spring-boot-http-client.instructions.md) |
| `{Domain}Event.java`, `{Domain}Listener.java`, `{Domain}Publisher.java` | Async or event-driven feature | [spring-boot-async-events.instructions.md](./spring-boot-async-events.instructions.md) |
| `{Domain}ConfigurationProperties.java` | Domain-specific config group | [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) |
