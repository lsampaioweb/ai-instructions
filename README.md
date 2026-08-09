# ai-instructions

Centralized GitHub Copilot and Cursor customization assets for Spring Boot projects. This repository packages reusable instruction files, prompts, agents, rules, and skills that can be hardlinked into consumer repositories.

## Repository structure

```
.github/        — GitHub Copilot assets: instructions, prompts, agents, hooks, and reserved skills directory
.cursor/        — Cursor assets: AGENTS.md, path-scoped rules, and executable skills
scripts/        — helper utilities for linking these assets into consumer repositories
```

## Prerequisites

- Linux or macOS with hardlink support
- Python 3 available as `python3`
- A consumer repository where `.github/` and/or `.cursor/` overlays should be installed

## Getting started

Run the linker from the target repository root. The script creates hardlinks to the shared assets and can be re-run safely.

```bash
export AI_INSTRUCTIONS_REPO=/absolute/path/to/ai-instructions
cd /absolute/path/to/consumer-project
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" github
```

To install the Cursor overlays into the same consumer repository:

```bash
export AI_INSTRUCTIONS_REPO=/absolute/path/to/ai-instructions
cd /absolute/path/to/consumer-project
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" cursor
```

## Configuration reference

- `github` mode links [copilot-instructions.md](.github/copilot-instructions.md), [.github/agents](.github/agents), [.github/hooks](.github/hooks), [.github/instructions](.github/instructions), [.github/prompts](.github/prompts), and the reserved [.github/skills](.github/skills) tree into the consumer repository.
- `cursor` mode links [AGENTS.md](.cursor/AGENTS.md), [.cursor/rules](.cursor/rules), and [.cursor/skills](.cursor/skills) into the consumer repository.
- Existing destination files are replaced before relinking; source files in this repository are never modified.

## Agent Catalog

- [spring-orchestrator.agent.md](.github/agents/spring-orchestrator.agent.md): main entry point for the governed development pipeline. Orchestrates architect, coder, reviewers, documenter, and meta-optimizer in a loop. Use when: implementing a new feature, creating or modifying files, running the full development cycle.
- [spring-architect.agent.md](.github/agents/spring-architect.agent.md): plans what to build by reading instruction files and writes ADR files. Use when: starting a new feature, re-evaluating a plan after reviewer failures.
- [spring-coder.agent.md](.github/agents/spring-coder.agent.md): implements files defined in an ADR plan by following instruction files. Use when: creating or fixing files as directed by the architect's plan.
- [spring-verifier.agent.md](.github/agents/spring-verifier.agent.md): verification gate agent. Runs dependency preflight, build, test, environment classification, and IDE diagnostics. Use when: validating a plan before implementation or validating created or modified files after implementation.
- [spring-documenter.agent.md](.github/agents/spring-documenter.agent.md): documentation agent. Creates or updates README.md based only on files produced by the current pipeline run. Use when: all reviewers have passed and the pipeline is complete.
- [spring-meta-optimizer.agent.md](.github/agents/spring-meta-optimizer.agent.md): pipeline optimizer. Analyzes all agent outputs from a pipeline run to identify root causes and suggest improvements to agents or instruction files. Use when: after any pipeline completion or iteration cap exceeded.
- [spring-review-qa.agent.md](.github/agents/spring-review-qa.agent.md): QA topic reviewer.
- [spring-review-security.agent.md](.github/agents/spring-review-security.agent.md): security topic reviewer.
- [spring-review-performance.agent.md](.github/agents/spring-review-performance.agent.md): performance topic reviewer.
- [spring-review-i18n.agent.md](.github/agents/spring-review-i18n.agent.md): i18n topic reviewer.
- [spring-review-database.agent.md](.github/agents/spring-review-database.agent.md): database topic reviewer.

## Cursor overlays

- [AGENTS.md](.cursor/AGENTS.md): always-on Cursor project behavior baseline.
- [.cursor/rules](.cursor/rules): path-scoped Cursor rules derived from the Spring Boot and AI customization contracts.
- [.cursor/skills](.cursor/skills): explicit Cursor workflows for documentation sync, reviews, commit planning, cleanup, and Spring-role orchestration.

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [add-content-to-file.prompt.md](.github/prompts/add-content-to-file.prompt.md) | `/add-content-to-file` | Add, update, or deduplicate content in markdown or plain text files while preserving document structure and style |
| [clean-slate-workspace.prompt.md](.github/prompts/clean-slate-workspace.prompt.md) | `/clean-slate-workspace` | Remove only this chat's created artifacts from the active workspace after explicit confirmation for a clean restart |
| [prepare-commit-messages.prompt.md](.github/prompts/prepare-commit-messages.prompt.md) | `/prepare-commit-messages` | Review uncommitted changes, group atomic feature-scoped commits, present a plan for approval, and execute commits only after explicit confirmation |
| [review-ai-customization-files.prompt.md](.github/prompts/review-ai-customization-files.prompt.md) | `/review-ai-customization-files` | Audit AI customization files for duplicates, conflicts, and enforceability using a strict scoring rubric |
| [review-and-sync-docs.prompt.md](.github/prompts/review-and-sync-docs.prompt.md) | `/review-and-sync-docs` | Correlate workspace deltas with Markdown docs and sync stale documentation in a controlled pass |
| [review-code-against-instructions.prompt.md](.github/prompts/review-code-against-instructions.prompt.md) | `/review-code-against-instructions` | Audit the target scope both ways: code against instructions and instructions against code, with minimal remediation actions |
| [review-other-ai-feedback.prompt.md](.github/prompts/review-other-ai-feedback.prompt.md) | `/review-other-ai-feedback` | Critically review external AI feedback, identify gaps, and suggest concrete improvements |
| [root-cause-analysis.prompt.md](.github/prompts/root-cause-analysis.prompt.md) | `/root-cause-analysis` | Analyze logs and exceptions to identify root cause and propose permanent architectural fixes |

## Instruction files

Instruction contracts live under [.github/instructions](.github/instructions). They are auto-routed by each file's `applyTo` pattern.

| File | Applies to | Purpose |
|---|---|---|
| [copilot-instructions.md](.github/copilot-instructions.md) | `**` | Always-on behavioral baseline for directness, scope control, anti-hallucination, and strict refusal protocols across all workspace tasks. |
| [ai-customization.instructions.md](.github/instructions/ai-customization.instructions.md) | `**/*.agent.md, **/hooks/**/*.json, **/hooks/**/*.md, **/*.instructions.md, **/*.prompt.md, **/skills/**/SKILL.md, **/copilot-instructions.md` | Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance. |
| [spring-boot-actuator.instructions.md](.github/instructions/spring-boot-actuator.instructions.md) | `**/src/main/resources/application*.yml, **/src/test/java/**/*.java` | Spring Boot actuator and observability contract: endpoint exposure, health probes, metrics, tracing, sampling, and sensitive-data boundaries. |
| [spring-boot-api-versioning.instructions.md](.github/instructions/spring-boot-api-versioning.instructions.md) | `**/*Controller.java` | API versioning rules: coexistence strategy, deprecation headers, and DTO evolution across versions. |
| [spring-boot-application.instructions.md](.github/instructions/spring-boot-application.instructions.md) | `**/*Application.java` | Spring Boot main application entry-point contract for bootstrap class placement, annotation discipline, and startup configuration safety. |
| [spring-boot-architecture.instructions.md](.github/instructions/spring-boot-architecture.instructions.md) | `**/pom.xml, **/src/**` | Global architecture baseline for Spring Boot generation and review. Apply before component-specific instruction files. |
| [spring-boot-async-events.instructions.md](.github/instructions/spring-boot-async-events.instructions.md) | `**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*AsyncConfiguration*.java` | Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics. |
| [spring-boot-config.instructions.md](.github/instructions/spring-boot-config.instructions.md) | `**/src/main/resources/application*.yml, **/*ConfigurationProperties.java` | Spring Boot configuration contract for externalized, profile-aware, and safe configuration management. |
| [spring-boot-container.instructions.md](.github/instructions/spring-boot-container.instructions.md) | `**/Dockerfile, **/docker-compose.yml, **/docker-compose.yaml, **/compose.yml` | Compose and Dockerfile container rules: image structure, naming, profile activation, volume mounts, healthcheck, and log directory ownership. |
| [spring-boot-controller.instructions.md](.github/instructions/spring-boot-controller.instructions.md) | `**/*Controller.java` | Spring Boot controller contract for request mapping, HTTP semantics, validation boundaries, and response consistency. |
| [spring-boot-database-schema.instructions.md](.github/instructions/spring-boot-database-schema.instructions.md) | `**/src/main/resources/sql/**/*.xml, **/src/main/resources/sql/**/*.sql` | Database schema and referential-integrity contract: types, naming, constraints, FK actions, and SQL artifact layout. |
| [spring-boot-dto-mapper.instructions.md](.github/instructions/spring-boot-dto-mapper.instructions.md) | `**/*Request.java, **/*Response.java, **/*DtoMapper.java` | Spring Boot DTO-mapper contract for deterministic model mapping and boundary-safe transformations. |
| [spring-boot-enum.instructions.md](.github/instructions/spring-boot-enum.instructions.md) | `**/src/main/java/**/*Enum.java` | Spring Boot enum contract for deterministic closed-set domain values in API, domain, and persistence boundaries. |
| [spring-boot-error-code.instructions.md](.github/instructions/spring-boot-error-code.instructions.md) | `**/src/main/java/**/*ErrorCode.java` | Spring Boot error-code contract for deterministic machine-readable API error semantics and stable message-key mapping. |
| [spring-boot-exception.instructions.md](.github/instructions/spring-boot-exception.instructions.md) | `**/*Exception*.java, **/*ExceptionHandler*.java, **/*Advice*.java` | Spring Boot exception-handling contract for centralized response mapping, stable error payloads, and controlled failure semantics. |
| [spring-boot-gitignore.instructions.md](.github/instructions/spring-boot-gitignore.instructions.md) | `**/.gitignore` | Spring Boot .gitignore contract for safe, complete exclusion of build output, IDE artifacts, OS files, secrets, and logs. |
| [spring-boot-http-client.instructions.md](.github/instructions/spring-boot-http-client.instructions.md) | `**/src/main/java/**/*HttpClient*.java, **/src/main/java/**/*HttpAdapter*.java, **/src/main/java/**/*HttpConfiguration*.java, **/src/main/java/**/*HttpProperties*.java` | Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries. |
| [spring-boot-i18n.instructions.md](.github/instructions/spring-boot-i18n.instructions.md) | `**/messages*.properties, **/application*.yml, **/*Messages.java, **/*LogMessages.java, **/i18n/**/*.java` | Spring Boot i18n contract for message-key governance, locale behavior, and translation-safe output. |
| [spring-boot-java-style.instructions.md](.github/instructions/spring-boot-java-style.instructions.md) | `**/src/**/*.java` | Java coding style contract for import ordering, visibility discipline, string constants, blank-line rules, and helper extraction across all Java source files. |
| [spring-boot-logging.instructions.md](.github/instructions/spring-boot-logging.instructions.md) | `**/*Controller.java, **/*Service.java, **/*ServiceImpl.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Filter.java, **/*Interceptor.java, **/*Advice.java, **/src/main/resources/**/logback-spring.xml` | Spring Boot logging contract for application log events, Logback appenders, rotation, and profile-level log routing. |
| [spring-boot-model.instructions.md](.github/instructions/spring-boot-model.instructions.md) | `**/*Model.java` | Spring Boot domain model contract for JDBC-first internal model types, boundary isolation, and persistence-free field declarations. |
| [spring-boot-openapi.instructions.md](.github/instructions/spring-boot-openapi.instructions.md) | `**/OpenApiConfig.java, **/openapi/**/*.java, **/src/main/resources/application*.yml, **/*Controller.java` | Spring Boot OpenAPI contract for documented API metadata, discoverable endpoints, and stable specification output. |
| [spring-boot-pagination.instructions.md](.github/instructions/spring-boot-pagination.instructions.md) | `**/*Controller.java, **/*Pagination*.java, **/src/main/resources/application*.yml` | Spring Boot pagination contract for pageable queries, deterministic ordering, and consistent paged response metadata. |
| [spring-boot-pom.instructions.md](.github/instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Spring Boot Maven contract for dependency, plugin, and build-governance decisions. |
| [spring-boot-readme.instructions.md](.github/instructions/spring-boot-readme.instructions.md) | `README.md, **/README.md` | README structure rules for required sections, actionable content, fenced code blocks, and no-filler-prose policy. |
| [spring-boot-repository.instructions.md](.github/instructions/spring-boot-repository.instructions.md) | `**/*Repository.java, **/*RepositoryImpl.java, **/*SqlConfigurationProperties.java, **/*SqlColumns.java` | Spring Boot repository contract for JDBC-first data access, interface-implementation separation, and SQL safety. |
| [spring-boot-security.instructions.md](.github/instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java, **/security/**/*.java` | Spring Boot security contract for authentication, authorization, service-level checks, and endpoint protection boundaries. |
| [spring-boot-service.instructions.md](.github/instructions/spring-boot-service.instructions.md) | `**/*Service.java, **/*ServiceImpl.java` | Spring Boot service contract for business orchestration, transaction boundaries, and dependency-safe application logic. |
| [spring-boot-test.instructions.md](.github/instructions/spring-boot-test.instructions.md) | `**/src/test/java/**/*.java` | Spring Boot testing contract for layer-focused tests, API-contract assertions, and cross-cutting governance checks. |
| [spring-boot-thymeleaf.instructions.md](.github/instructions/spring-boot-thymeleaf.instructions.md) | `**/*PageController.java, **/*Routes.java, **/templates/**/*.html` | Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references. |
| [spring-boot-websocket.instructions.md](.github/instructions/spring-boot-websocket.instructions.md) | `**/*Socket*.java, **/*Stomp*.java` | WebSocket/STOMP rules: endpoint topology, message flow contract, lifecycle handling, and client resilience. |
| [spring-review-topics.instructions.md](.github/instructions/spring-review-topics.instructions.md) | `**/spring-review-*.agent.md, **/spring-orchestrator.agent.md, **/spring-verifier.agent.md` | Review-topic registry for focused reviewer agents. Use when: routing instruction files by topic for QA, security, database, i18n, or performance review agents. |

To inspect current routing patterns directly:

```bash
rg -n "^applyTo:" .github/instructions/*.instructions.md
```

## Governance Notes

- Proactive loading is mandatory: read each activated component instruction file before generation or review; do not rely only on `applyTo` auto-loading.
- Optional components follow intent-first activation: ask when intent is ambiguous, then apply silent defaults only when user intent remains silent.

## Instruction format conventions

- `spring-boot-*.instructions.md` files follow a standardized structure: YAML frontmatter, one H1 title, and deterministic H2 rule sections
- Keep one rule per bullet and keep sections enforceable and purpose-specific
- All `.instructions.md`, `.prompt.md`, `.agent.md`, and `SKILL.md` files must follow the style contract defined in [ai-customization.instructions.md](.github/instructions/ai-customization.instructions.md)

## Contributing

- Keep each instruction file focused on one concern and define `applyTo` as narrowly as possible
- For Spring Boot instruction files, follow the standardized deterministic structure already used in this repository
- Update [README.md](README.md) whenever an instruction, prompt, or skill is added, renamed, or meaningfully updated

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
