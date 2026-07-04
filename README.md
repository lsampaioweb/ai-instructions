<!-- filepath: README.md -->
# ai-instructions

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
| [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md) | `**/*ActuatorConfig*.java`, `**/*HealthIndicator.java`, `**/management/**/*.java`, `**/application*.yml`, `**/pom.xml` | Actuator and health check rules: dependency setup, endpoint exposure, security, probe-based liveness/readiness, and custom health indicators |
| [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md) | no `applyTo` pattern (loaded as cross-cutting guidance) | Cross-cutting architecture and boundary rules (packaging, dependency flow, API/domain boundaries, visibility, no-ORM, execution integrity), constructor injection conventions (including `@RequiredArgsConstructor` guidance), plus global scope/ambiguity protocol and pointers to specialized instruction files for implementation details |
| [spring-boot-async-events.instructions.md](instructions/spring-boot-async-events.instructions.md) | `**/*Event.java`, `**/*Listener.java`, `**/*Publisher.java` | Async processing and internal event rules: Spring Application Events for cross-feature communication and `@Async` for heavy I/O listeners |
| [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md) | `**/application*.yml`, `**/*ConfigurationProperties.java`, `**/*Configuration.java` | Configuration rules: mandatory profile files, `@ConfigurationProperties`, `@EnableConfigurationProperties` placement guidance, `@Value` policy, test-profile override guidance, secrets pointer, `@Bean` organization, and `@PostConstruct` fail-fast startup initialization patterns |
| [spring-boot-container.instructions.md](instructions/spring-boot-container.instructions.md) | `**/Dockerfile`, `**/Dockerfile-multi-stage`, `**/docker-compose.yml`, `**/.dockerignore` | Docker and Docker Compose rules: internal base image naming for Spring Boot apps, infrastructure service images, security hardening (separate for app and infrastructure), volume mounts, healthchecks, `.env.example` pattern, and log directory ownership |
| [spring-boot-controller.instructions.md](instructions/spring-boot-controller.instructions.md) | `**/*Controller.java`, `**/*Api.java` | REST controller rules: no business logic, `@Valid` inputs, DTO responses, API versioning, and HTTP status conventions |
| [spring-boot-dto-mapper.instructions.md](instructions/spring-boot-dto-mapper.instructions.md) | `**/*DTO.java`, `**/*Dto.java`, `**/*DtoMapper.java`, `**/*Mapper.java`, `**/*Request.java`, `**/*Response.java` | DTO and mapper rules: immutable records, validation placement, mapper boundary enforcement, Spring component mapper defaults, and optional MapStruct conventions |
| [spring-boot-exception.instructions.md](instructions/spring-boot-exception.instructions.md) | `**/*Exception.java`, `**/*ControllerAdvice.java`, `**/*ExceptionHandler.java`, `**/*ErrorResponse.java` | Exception handling rules: single `@RestControllerAdvice`, domain exception hierarchy (including `transient` args guidance for serializability), `ErrorResponse`/`ValidationError` DTO patterns, UTC timestamp handling, and environment-driven stacktrace exposure policy |
| [spring-boot-http-client.instructions.md](instructions/spring-boot-http-client.instructions.md) | `**/*Client.java`, `**/*ApiClient.java`, `**/*HttpClient.java` | HTTP client rules: `RestClient` setup, configuration, and usage patterns for calling external APIs |
| [spring-boot-i18n.instructions.md](instructions/spring-boot-i18n.instructions.md) | `**/i18n/**`, `**/messages*.properties`, `**/*LocaleConfig.java` | i18n rules: message file layout, English+pt_BR required, locale resolution via `Accept-Language` header only |
| [spring-boot-logging.instructions.md](instructions/spring-boot-logging.instructions.md) | `**/*.java` | Logging and operator-text rules: `@Slf4j`, i18n keys for logs and exception/operator-facing text, log level selection, and what must never be logged |
| [spring-boot-openapi.instructions.md](instructions/spring-boot-openapi.instructions.md) | `**/*OpenApiConfig*.java`, `**/*SwaggerConfig*.java`, `**/*Controller.java`, `**/*Api.java` | OpenAPI/Swagger rules: springdoc-openapi setup, version property management, required OpenAPI bean, controller annotation guidance (`@Tag`/`@Operation` baseline with early-tutorial exceptions), and profile-based UI toggle |
| [spring-boot-pom.instructions.md](instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Maven POM rules: `spring-boot-starter-parent`, required starter baseline, no hardcoded managed versions, dependency ordering, and BOM usage |
| [spring-boot-readme.instructions.md](instructions/spring-boot-readme.instructions.md) | `**/README.md` | README structure rules: recommended sections and no-filler-prose policy |
| [spring-boot-repository.instructions.md](instructions/spring-boot-repository.instructions.md) | `**/*Repository.java`, `**/*Mapper.java`, `**/mapper/**/*.xml`, `**/sql/**/*.xml` | Repository rules: persistence repositories and SQL/MyBatis mappers only, MyBatis and Spring JDBC Templates, SQL in XML files, schema initialization guidance, package-private repository method conventions, no ORM, and no business logic |
| [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java`, `**/security/**/*.java` | Security rules: Spring Security 6 Lambda DSL, deny-by-default, `@PreAuthorize` with read/write role baseline, CSRF/CORS policy, local SSL testing constraints, secrets, and error message hygiene |
| [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md) | `**/*Service.java`, `**/*ServiceImpl.java` | Service layer rules: business logic ownership, `@Transactional`, domain exceptions, and interface+impl pattern |
| [spring-boot-test.instructions.md](instructions/spring-boot-test.instructions.md) | `**/*Test.java`, `**/*IT.java`, `**/test/**/*.java` | Testing rules: slice vs full-context tests, `@MockitoBean` (Spring Boot 3.4+), naming conventions, AssertJ, and profile activation |
| [spring-boot-thymeleaf.instructions.md](instructions/spring-boot-thymeleaf.instructions.md) | `**/*PageController.java`, `**/*Routes.java`, `**/templates/**/*.html` | Thymeleaf rules: `@Controller` vs `@RestController`, view name returns, view-controller naming (`*PageController`/`*Routes`), model attributes, form binding with `th:object`/`th:field`, and static resource URL expressions |
| [spring-boot-websocket.instructions.md](instructions/spring-boot-websocket.instructions.md) | `**/*WebSocketConfiguration*.java`, `**/*SocketEndpoint.java`, `**/*SessionEventsListener.java`, `**/*ConnectionTracker.java`, `**/*StompMessage.java`, `**/*SocketMessage.java`, `**/*WebSocketMessage.java`, `**/static/js/*websocket*.js`, `**/static/js/*socket*.js` | WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience |

## Instruction format conventions

- `spring-boot-*.instructions.md` files follow a standardized structure: YAML frontmatter, one H1 title, and H2 rule sections
- Most instruction files end with `## Templates`; exceptions are `spring-boot-architecture.instructions.md` and `spring-boot-readme.instructions.md`
- Keep reusable code examples only in `## Templates`; avoid duplicating code blocks inside rule sections

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [explain-problem-find-solution.prompt.md](prompts/explain-problem-find-solution.prompt.md) | `/explain-problem-find-solution` | Explain the problem cause, verify the root cause, and provide a permanent fix — not a workaround |
| [prepare-commit-messages.prompt.md](prompts/prepare-commit-messages.prompt.md) | `/prepare-commit-messages` | Review uncommitted changes, group logical commits, present commit plan for approval, then commit if approved; keep output concise without redundant bodies or repeated file lists |
| [reconcile-code-instructions.prompt.md](prompts/reconcile-code-instructions.prompt.md) | `/reconcile-code-instructions` | Reconcile drift between project code and AI customization files in either direction with mandatory closure states (`fixed`, `accepted-intentional`, `deferred`), smallest-correct-diff preference, out-of-scope issue logging, and a drift ledger output |
| [review-ai-customizations.prompt.md](prompts/review-ai-customizations.prompt.md) | `/review-ai-customizations` | Review AI customization files with non-aggressive token optimization, one-file-at-a-time approval, cross-file drift checks, and meaning-preserving edits |
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
- Update [README.md](README.md) whenever an instruction, prompt, or skill is added, renamed, or meaningfully updated

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
