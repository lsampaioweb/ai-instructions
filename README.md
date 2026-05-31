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
| [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md) | `**/*ActuatorConfig*.java`, `**/*HealthIndicator.java` | Actuator and health check rules: dependency setup, endpoint exposure, security, and custom health indicators |
| [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md) | `**/*.java` | Feature-based packaging, dependency flow, visibility, domain object rules, interface conventions, and code style |
| [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md) | `**/application*.yml`, `**/*ConfigurationProperties.java` | Configuration rules: mandatory profile files, `@ConfigurationProperties`, `@Value` policy, secrets, and `@Bean` organization |
| [spring-boot-controller.instructions.md](instructions/spring-boot-controller.instructions.md) | `**/*Controller.java` | REST controller rules: no business logic, `@Valid` inputs, DTO responses, API versioning, and HTTP status conventions |
| [spring-boot-dto-mapper.instructions.md](instructions/spring-boot-dto-mapper.instructions.md) | `**/*Mapper.java`, `**/*Request.java`, `**/*Response.java` | DTO and MapStruct mapper rules: immutable records, validation placement, `@Mapper` conventions, and raw passthrough exception |
| [spring-boot-exception.instructions.md](instructions/spring-boot-exception.instructions.md) | `**/*Exception.java`, `**/*ControllerAdvice.java` | Exception handling rules: single `@RestControllerAdvice`, domain exception hierarchy, `ErrorResponse` DTO, and stacktrace policy |
| [spring-boot-http-client.instructions.md](instructions/spring-boot-http-client.instructions.md) | `**/*Client.java`, `**/*ApiClient.java` | HTTP client rules: `RestClient` setup, configuration, and usage patterns for calling external APIs |
| [spring-boot-i18n.instructions.md](instructions/spring-boot-i18n.instructions.md) | `**/messages*.properties`, `**/*LocaleConfig.java` | i18n rules: message file layout, English + pt_BR required, UTF-8 encoding, locale resolution via `Accept-Language` header only |
| [spring-boot-logging.instructions.md](instructions/spring-boot-logging.instructions.md) | `**/*.java` | Logging rules: `@Slf4j`, i18n keys for all log messages, log level selection, and what must never be logged |
| [spring-boot-openapi.instructions.md](instructions/spring-boot-openapi.instructions.md) | `**/*OpenApiConfig*.java`, `**/*Controller.java` | OpenAPI/Swagger rules: springdoc-openapi setup, OpenAPI bean, endpoint annotation, and profile-based UI toggle |
| [spring-boot-pom.instructions.md](instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Maven POM rules: `spring-boot-starter-parent`, no hardcoded managed versions, dependency ordering, and BOM usage |
| [spring-boot-readme.instructions.md](instructions/spring-boot-readme.instructions.md) | `**/README.md` | README structure rules: recommended sections and no-filler-prose policy |
| [spring-boot-repository.instructions.md](instructions/spring-boot-repository.instructions.md) | `**/*Repository.java`, `**/mapper/**/*.xml` | Repository rules: MyBatis and Spring JDBC Templates, SQL in XML files, no ORM, and no business logic |
| [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java`, `**/security/**/*.java` | Security rules: Spring Security 6 Lambda DSL, deny-by-default, `@PreAuthorize`, CSRF/CORS policy, secrets, and error message hygiene |
| [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md) | `**/*Service.java`, `**/*ServiceImpl.java` | Service layer rules: business logic ownership, `@Transactional`, domain exceptions, and interface + impl pattern |
| [spring-boot-test.instructions.md](instructions/spring-boot-test.instructions.md) | `**/*Test.java`, `**/*IT.java`, `**/test/**/*.java` | Testing rules: slice vs full-context tests, `@MockitoBean` (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation |
| [spring-boot.instructions.md](instructions/spring-boot.instructions.md) | `**/*.java`, `**/pom.xml`, `**/application*.yml` | Cross-cutting Spring Boot rules: DI, API boundaries, mapping, exception handling, logging, and project layout |

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [explain-problem-find-solution.prompt.md](prompts/explain-problem-find-solution.prompt.md) | `/explain-problem-find-solution` | Explain what is causing a problem, research the root cause, and provide the correct permanent fix — never a workaround |
| [spring-boot-crud.prompt.md](prompts/spring-boot-crud.prompt.md) | `/spring-boot-crud` | Generate a complete Spring Boot feature following all project conventions |
| [spring-boot-review.prompt.md](prompts/spring-boot-review.prompt.md) | `/spring-boot-review` | Code review for Spring Boot projects: verify all instruction file rules are followed |

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
