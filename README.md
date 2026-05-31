<!-- filepath: README.md -->
# ia-instructions

Centralized VS Code Copilot instruction and prompt files for Spring Boot projects. These files are picked up automatically by GitHub Copilot in VS Code and drive consistent code generation, review, and tooling behaviour across all repositories that reference this configuration.

## Repository structure

```
agents/         — reserved for custom agent definitions
hooks/          — reserved for post-generation hooks
instructions/   — .instructions.md files; auto-applied by Copilot based on applyTo patterns
prompts/        — .prompt.md files; invoked explicitly with /prompt-name
skills/         — SKILL.md files; domain knowledge loaded on demand
```

## Instruction files

| File | Applies to | Purpose |
|---|---|---|
| [copilot-instructions.md](instructions/copilot-instructions.md) | `**` | Always-on behavioral baseline: directness, scope control, anti-hallucination, concise output |
| [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md) | `**/*ActuatorConfig*.java`, `**/*HealthIndicator.java`, `**/management/**/*.java` | Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators |
| [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md) | `**/*.java`, `**/pom.xml`, `**/application*.yml` | Feature-based packaging, dependency flow, visibility, domain object rules, interface conventions, and code style |
| [spring-boot-async-events.instructions.md](instructions/spring-boot-async-events.instructions.md) | `**/*Event.java`, `**/*Listener.java`, `**/*Publisher.java` | Async processing and internal event rules: Spring Application Events for cross-feature communication and `@Async` for heavy I/O listeners |
| [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md) | `**/application*.yml`, `**/*ConfigurationProperties.java`, `**/*Configuration.java` | Configuration rules: mandatory profile files, `@ConfigurationProperties`, `@Value` policy, secrets pointer, and `@Bean` organization |
| [spring-boot-controller.instructions.md](instructions/spring-boot-controller.instructions.md) | `**/*Controller.java` | REST controller rules: no business logic, `@Valid` inputs, DTO responses, API versioning, and HTTP status conventions |
| [spring-boot-dto-mapper.instructions.md](instructions/spring-boot-dto-mapper.instructions.md) | `**/*DTO.java`, `**/*Dto.java`, `**/*Mapper.java`, `**/*Request.java`, `**/*Response.java` | DTO and MapStruct mapper rules: immutable records, validation placement, and `@Mapper` conventions |
| [spring-boot-exception.instructions.md](instructions/spring-boot-exception.instructions.md) | `**/*Exception.java`, `**/*ControllerAdvice.java`, `**/*ExceptionHandler.java`, `**/*ErrorResponse.java` | Exception handling rules: single `@RestControllerAdvice`, domain exception hierarchy, `ErrorResponse` DTO, and stacktrace policy |
| [spring-boot-http-client.instructions.md](instructions/spring-boot-http-client.instructions.md) | `**/*Client.java`, `**/*ApiClient.java`, `**/*HttpClient.java` | HTTP client rules: `RestClient` setup, configuration, and usage patterns for calling external APIs |
| [spring-boot-i18n.instructions.md](instructions/spring-boot-i18n.instructions.md) | `**/i18n/**`, `**/messages*.properties`, `**/*LocaleConfig.java` | i18n rules: message file layout, English+pt_BR required, locale resolution via `Accept-Language` header only |
| [spring-boot-logging.instructions.md](instructions/spring-boot-logging.instructions.md) | `**/*.java` | Logging rules: `@Slf4j`, i18n keys for all log messages, log level selection, and what must never be logged |
| [spring-boot-openapi.instructions.md](instructions/spring-boot-openapi.instructions.md) | `**/*OpenApiConfig*.java`, `**/*SwaggerConfig*.java`, `**/*Controller.java` | OpenAPI/Swagger rules: springdoc-openapi setup, OpenAPI bean, endpoint annotation, and profile-based UI toggle |
| [spring-boot-pom.instructions.md](instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Maven POM rules: `spring-boot-starter-parent`, no hardcoded managed versions, dependency ordering, and BOM usage |
| [spring-boot-readme.instructions.md](instructions/spring-boot-readme.instructions.md) | `**/README.md` | README structure rules: recommended sections and no-filler-prose policy |
| [spring-boot-repository.instructions.md](instructions/spring-boot-repository.instructions.md) | `**/*Repository.java`, `**/*Mapper.java`, `**/mapper/**/*.xml`, `**/sql/**/*.xml` | Repository rules: MyBatis and Spring JDBC Templates, SQL in XML files, no ORM, and no business logic |
| [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java`, `**/security/**/*.java` | Security rules: Spring Security 6 Lambda DSL, deny-by-default, `@PreAuthorize`, CSRF/CORS policy, secrets, and error message hygiene |
| [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md) | `**/*Service.java`, `**/*ServiceImpl.java` | Service layer rules: business logic ownership, `@Transactional`, domain exceptions, and interface+impl pattern |
| [spring-boot-test.instructions.md](instructions/spring-boot-test.instructions.md) | `**/*Test.java`, `**/*IT.java`, `**/test/**/*.java` | Testing rules: slice vs full-context tests, `@MockitoBean` (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation |

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [explain-problem-find-solution.prompt.md](prompts/explain-problem-find-solution.prompt.md) | `/explain-problem-find-solution` | Explain what is causing a problem, research the root cause, and provide the correct permanent fix — never a workaround |
| [spring-boot-crud.prompt.md](prompts/spring-boot-crud.prompt.md) | `/spring-boot-crud` | Generate a complete Spring Boot feature following all project conventions |
| [spring-boot-review.prompt.md](prompts/spring-boot-review.prompt.md) | `/spring-boot-review` | Code review for Spring Boot projects: verify all instruction file rules are followed |

## Skill files

Loaded automatically by Copilot when the prompt topic matches the skill description. Also invokable with `/skill-name` in Copilot Chat.

| Folder | Invoke with | Purpose |
|---|---|---|
| [skills/spring-boot/](skills/spring-boot/SKILL.md) | `/spring-boot` | Scaffold and generate Spring Boot features: controller, service, repository, domain, DTOs, exceptions, MyBatis XML, i18n entries, health indicators, async events, configuration properties, and OpenAPI/Swagger config |

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
