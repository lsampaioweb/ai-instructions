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
| [copilot-instructions.md](instructions/copilot-instructions.md) | `**` | Always-on behavioral baseline: directness, scope control, anti-hallucination, concise output, and tool discipline guardrails |
| [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md) | `**/*ActuatorConfig*.java`, `**/*HealthIndicator.java`, `**/management/**/*.java` | Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators |
| [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md) | `**` (all files) | Feature-based packaging, dependency flow, visibility, domain object rules, interface conventions, code style, and project blueprint generation order |
| [spring-boot-async-events.instructions.md](instructions/spring-boot-async-events.instructions.md) | `**/*Event.java`, `**/*Listener.java`, `**/*Publisher.java` | Async processing and internal event rules: Spring Application Events for cross-feature communication and `@Async` for heavy I/O listeners |
| [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md) | `**/application*.yml`, `**/*ConfigurationProperties.java`, `**/*Configuration.java` | Configuration rules: mandatory profile files, `@ConfigurationProperties`, `@Value` policy, secrets pointer, and `@Bean` organization |
| [spring-boot-container.instructions.md](instructions/spring-boot-container.instructions.md) | `**/Dockerfile`, `**/Dockerfile-multi-stage`, `**/docker-compose.yml`, `**/.dockerignore` | Docker and Podman Compose rules: internal base image naming, single-stage and multi-stage Dockerfiles, security hardening, volume mounts, healthcheck, and log directory ownership |
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
| [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java`, `**/security/**/*.java` | Security rules: Spring Security 6 Lambda DSL, deny-by-default, `@PreAuthorize` with read/write role baseline, CSRF/CORS policy, secrets, and error message hygiene |
| [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md) | `**/*Service.java`, `**/*ServiceImpl.java` | Service layer rules: business logic ownership, `@Transactional`, domain exceptions, and interface+impl pattern |
| [spring-boot-test.instructions.md](instructions/spring-boot-test.instructions.md) | `**/*Test.java`, `**/*IT.java`, `**/test/**/*.java` | Testing rules: slice vs full-context tests, `@MockitoBean` (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation |
| [spring-boot-thymeleaf.instructions.md](instructions/spring-boot-thymeleaf.instructions.md) | `**/*Controller.java`, `**/templates/**/*.html` | Thymeleaf rules: `@Controller` vs `@RestController`, view name returns, model attributes, form binding with `th:object`/`th:field`, and static resource URL expressions |

## Instruction format conventions

- `spring-boot-*.instructions.md` files follow a standardized structure: YAML frontmatter, one H1 title, and H2 rule sections
- Most instruction files end with `## Templates`; exceptions are `spring-boot-architecture.instructions.md` and `spring-boot-readme.instructions.md`
- Keep reusable code examples only in `## Templates`; avoid duplicating code blocks inside rule sections

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [explain-problem-find-solution.prompt.md](prompts/explain-problem-find-solution.prompt.md) | `/explain-problem-find-solution` | Explain what is causing a problem, research the root cause, and provide the correct permanent fix — never a workaround |
| [review-other-ai-feedback.prompt.md](prompts/review-other-ai-feedback.prompt.md) | `/review-other-ai-feedback` | Critically review external AI feedback, identify gaps, and suggest concrete improvements |
| [sync-readme-with-project.prompt.md](prompts/sync-readme-with-project.prompt.md) | `/sync-readme-with-project` | Update the main README.md with meaningful project changes from code, config, and docs |

## Skill files

Loaded automatically by Copilot when the prompt topic matches the skill description. Also invokable with `/skill-name` in Copilot Chat.

| Folder | Invoke with | Purpose |
|---|---|---|
| [skills/spring-boot/](skills/spring-boot/SKILL.md) | `/spring-boot` | Generate or code review a Spring Boot app or feature: controller, service, repository, DTO, mapper, exception, and any other Spring Boot component |

## Contributing

- Keep each instruction file focused on one concern and define `applyTo` as narrowly as possible
- For Spring Boot instruction files, follow the standardized structure already used in this repository
- Keep examples reusable and place them in `## Templates` when that section exists; avoid duplicate code blocks across sections
- Update [README.md](README.md) whenever a new instruction, prompt, or skill is added or renamed

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
