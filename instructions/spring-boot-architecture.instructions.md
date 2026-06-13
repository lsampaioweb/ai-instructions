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
│   └── .keep
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
- **Never trust user input.** Treat all data crossing API boundaries or originating from external sources (files, network, user input) as untrusted. Validate format, length, and content explicitly; reject or sanitize by default.
- All Java identifiers (classes, methods, fields, constants) must follow standard Java naming conventions: `camelCase` for variables and methods, `UPPER_SNAKE_CASE` for constants, `PascalCase` for class and interface names. Do not use underscores, hyphens, or other separators in Java identifiers; map external formats (e.g., JSON snake_case) via framework annotations (Jackson `@JsonProperty` or `@JsonNaming`) instead.
- Import order: `java.*` → `jakarta.*` → third-party (`org.*`, `com.*`) → project-internal; separate each group with a blank line; never use wildcard imports
- Stack annotations one per line; never place two annotations on the same line; apply class-level annotations before method-level and field-level annotations
- 2 spaces for indentation; never use tabs
- Use modern Java features where the project's Java version supports them: records, pattern matching, sealed classes, text blocks
- Keep method and constructor signatures on one line when reasonably readable; wrap parameters only when line length exceeds 160 characters or readability clearly improves
- Add a blank line before every `return` statement unless the method body is a single expression
- Separate logically distinct blocks within a method body with a blank line (e.g. between validation, data retrieval, transformation, and return)
- Do not add a blank line after every single statement; use spacing to group related lines, not to isolate them
- In constructors and methods, keep assignment order consistent with field declaration order and parameter order whenever possible

## Member and Method Ordering
- Order members to reflect the logical flow a reader would follow; never let IDE auto-sort or alphabetical ordering decide placement
- Static constants (`private static final`) — i18n key constants first, then other constants
- Instance fields — in the order they are used; dependencies injected via constructor come first
- Constructor(s)
- Public API methods — in the order a caller would logically invoke them (e.g. the main operation before its supporting overloads)
- Package-private or protected methods — same flow principle
- Private helper methods — in the order they are called from the methods above, not alphabetically

## Packaging
- Organize code by feature or domain; use packages like `user`, `product`, `order`, `config`, `integration`
- Never create generic root packages named `controller`, `service`, or `repository`
- Keep all classes for a feature in one package (e.g. `UserController`, `UserService`, `UserMapper`, `User`, `CreateUserRequest`, and `UserNotFoundException` all belong in `com.example.user`)

## Visibility **(Required)**
Use the narrowest visibility that works:
- `private` for helpers not used outside the class
- Package-private (no modifier) for classes and methods used only within the same feature package
- `public` only for types and methods that must be accessible from outside the package

## Interfaces **(Required)**
- Define interfaces for services and any component that may have multiple implementations or needs to be mocked in tests
- A dedicated interface is not required for one-off utilities or configuration classes that are never tested in isolation

## Dependency Flow **(Required)**
- Enforce one-way dependency: `controller → service → repository` or `service → integration client`; skip-layer calls are not allowed
- Controllers call only services; services call mappers, repositories, and integration clients; mappers have no web-layer knowledge
- The controller receives DTOs only (never domain objects); the service calls `mapper.toResponse(domain)` before returning to the controller
- When an entity is not found, the service throws the domain-specific exception (e.g. `UserNotFoundException`); never throw a generic `RuntimeException` or Spring exception directly

## Dependency Injection **(Required)**
- Use constructor injection for all Spring-managed dependencies; never use `@Autowired` on fields

## Domain Objects and API Boundaries
- Domain objects are plain Java records or classes with no persistence annotations
- Use Java records for immutable domain objects; use a class only when mutation is genuinely necessary
- Field names and types map to SQL result sets via MyBatis result maps defined in XML; no annotations are required on the domain class itself
- Never expose domain objects in controller responses or request parameters; pass DTOs across all API boundaries

## No ORM
- Never use JPA, Hibernate, or any ORM framework; never annotate domain objects with `@Entity`, `@Table`, or `@Column`
- Never add ORM dependencies to the project; use MyBatis or Spring JDBC Templates for all data access
- See [spring-boot-repository.instructions.md](./spring-boot-repository.instructions.md) for data access rules

## Object Mapping
- Use MapStruct for all object mapping between layers; see [spring-boot-dto-mapper.instructions.md](./spring-boot-dto-mapper.instructions.md) for mapper conventions

## Exception Handling
- Centralize all exception handling in a single `@RestControllerAdvice` class; see [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) for the full pattern

## Logging
- Use `@Slf4j` (Lombok) for all logging; see [spring-boot-logging.instructions.md](./spring-boot-logging.instructions.md) for level and content rules

## i18n Text and Constants
- Never hardcode human-readable text (messages, labels, error descriptions) as string literals; define all text in `messages.properties` and reference by key; see [spring-boot-i18n.instructions.md](./spring-boot-i18n.instructions.md) for message file rules
- Declare i18n key strings as `private static final String` constants at the top of the class; never pass key literals inline (e.g. `logMessages.get(LOG_USER_FIND_ALL)`, not `logMessages.get("log.user.find.all")`)
- Name constants in `UPPER_SNAKE_CASE` that describes the message, not the key string value

## Architectural Preservation
- Do not introduce new layers, patterns, dependencies, abstractions, or frameworks unless explicitly requested; work within the existing structure
- If a requested change cannot be correctly implemented within the existing structure, explicitly state that limitation and describe the minimum structural change required before proceeding

## Execution Integrity
- Never claim success for build, test, lint, or runtime validation unless a command was actually executed and completed successfully
- If any diagnostics still report errors, state that clearly and do not present the task as fully validated

## Anti-Hallucination
- Never invent or assume API signatures, configuration keys, framework behavior, or codebase conventions not visible in the current context or official documentation; when uncertain, say so explicitly

## Convention Conflicts
When a user requirement or external protocol constraint conflicts with a style convention, resolve as follows:
1. State the conflict explicitly: "Your requirement contradicts convention X"
2. State the default convention: "Convention X applies by default"
3. Ask one targeted clarifying question before proceeding

The user requirement always wins; never silently override it.

## Formatting
- After creating or editing a file, format it using the project's configured formatter or language tooling when available
- If no formatter is configured, preserve the existing style and limit formatting changes to touched code
- Never claim a file was formatted unless formatting actually ran successfully
- Ensure every edited file ends with one newline character

## Comments
- Prefer clear names over comments
- Add comments for intent, trade-offs, invariants, and non-obvious behavior
- Do not comment obvious assignments or control flow
- Add short Javadoc to public methods only when behavior is not obvious

---

## Project Blueprint

### Scope Control
- Only generate files for the specific feature or change requested; never add optional infrastructure, endpoints, or configuration blocks unless explicitly requested
- When starting a new project, initialize mandatory shared infrastructure first; when adding a feature, skip already-present infrastructure files
- When editing existing projects, apply only sections relevant to touched files; do not over-apply or add extra files

### Required inputs before generating any file

Stop and ask before creating any file if any of the following is missing or ambiguous:

- **Project initialized?** — if not, initialize first; see [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md)
- **Domain object name** (e.g. `User`)
- **Base package** (e.g. `com.example`)
- **Fields** — each as `name: type [validations]`, e.g. `email: String [@NotBlank, @Email]`
- **Database?** — yes or no; drives repository, XML mapper, and schema SQL generation

### Generation order
- Generate each file fully before moving to the next
- List all files to be created explicitly before starting; never use vague placeholders—name each file by its actual path

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
| `OpenApiConfig.java` | [spring-boot-openapi.instructions.md](./spring-boot-openapi.instructions.md) |

#### Shared infrastructure — optional, include only when needed

| File | When | Instruction |
|------|------|-------------|
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
