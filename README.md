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

- [spring-orchestrator.agent.md](.github/agents/spring-orchestrator.agent.md): routes create and review work, applies loop controls, and normalizes final output.
- [spring-architect.agent.md](.github/agents/spring-architect.agent.md): read-only architecture planning and implementation decomposition.
- [spring-coder.agent.md](.github/agents/spring-coder.agent.md): write-capable implementation agent.
- [spring-documenter.agent.md](.github/agents/spring-documenter.agent.md): documentation-only synchronization agent for post-pass Markdown updates.
- [spring-meta-optimizer.agent.md](.github/agents/spring-meta-optimizer.agent.md): post-pass optimization of AI customization rules; analyzes iteration friction and proposes generic framework-level guidance.
- [spring-review-qa.agent.md](.github/agents/spring-review-qa.agent.md): QA-only reviewer.
- [spring-review-security.agent.md](.github/agents/spring-review-security.agent.md): security-only reviewer.
- [spring-review-performance.agent.md](.github/agents/spring-review-performance.agent.md): performance-only reviewer.
- [spring-review-i18n.agent.md](.github/agents/spring-review-i18n.agent.md): i18n-only reviewer.
- [spring-review-database.agent.md](.github/agents/spring-review-database.agent.md): database-only reviewer.

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
| [copilot-instructions.md](.github/copilot-instructions.md) | `**` | Always-on behavioral baseline for directness, scope control, anti-hallucination, concise output, and tool discipline guardrails |
| [ai-customization.instructions.md](.github/instructions/ai-customization.instructions.md) | `**/*.agent.md, **/hooks/**/*.json, **/hooks/**/*.md, **/*.instructions.md, **/*.prompt.md, **/skills/**/SKILL.md` | Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance |
| [spring-boot-actuator.instructions.md](.github/instructions/spring-boot-actuator.instructions.md) | `**/*SecurityConfig.java, **/src/main/resources/application*.yml` | Actuator and observability rules for endpoint exposure, management port posture, health detail policy, metrics visibility, profile hardening, and security boundaries |
| [spring-boot-api-versioning.instructions.md](.github/instructions/spring-boot-api-versioning.instructions.md) | `**/*Api.java, **/*Request.java, **/*Response.java, **/*OpenApiConfig*.java, **/*Test.java` | API versioning rules for coexistence strategy, deprecation headers, and DTO evolution across versions |
| [spring-boot-architecture.instructions.md](.github/instructions/spring-boot-architecture.instructions.md) | `**/pom.xml, **/src/**` | Cross-cutting architecture baseline to apply before component-specific contracts |
| [spring-boot-async-events.instructions.md](.github/instructions/spring-boot-async-events.instructions.md) | `**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*Rabbit*Configuration*.java, **/src/main/resources/application*.yml, **/pom.xml` | Async and eventing rules for deterministic publication, consumer processing, and resilient delivery semantics |
| [spring-boot-config.instructions.md](.github/instructions/spring-boot-config.instructions.md) | `**/src/main/resources/application*.yml` | Configuration rules for externalized, profile-aware, and safe configuration management |
| [spring-boot-container.instructions.md](.github/instructions/spring-boot-container.instructions.md) | `**/Dockerfile, **/docker-compose.yml` | Docker and Compose rules for image structure, naming, profile activation, healthchecks, volume mounts, and log directory ownership |
| [spring-boot-controller.instructions.md](.github/instructions/spring-boot-controller.instructions.md) | `**/*Controller.java` | REST controller rules for mapping semantics, validation boundaries, and consistent responses |
| [spring-boot-database-schema.instructions.md](.github/instructions/spring-boot-database-schema.instructions.md) | `**/src/main/resources/sql/**/*.xml, **/src/main/resources/sql/**/*.sql` | Database schema rules for naming standards, sizing, constraints, and nullability defaults |
| [spring-boot-dto-mapper.instructions.md](.github/instructions/spring-boot-dto-mapper.instructions.md) | `**/*DtoMapper.java` | DTO mapping rules for deterministic model mapping and boundary-safe transformations |
| [spring-boot-enum.instructions.md](.github/instructions/spring-boot-enum.instructions.md) | `**/src/main/java/**/*Enum.java, **/src/main/java/**/security/Role.java, **/src/main/java/**/security/*Role.java` | Enum rules for deterministic closed-set domain values and security role mappings |
| [spring-boot-error-code.instructions.md](.github/instructions/spring-boot-error-code.instructions.md) | `**/src/main/java/**/*ErrorCode.java, **/src/main/java/**/*Exception*.java, **/src/main/resources/i18n/messages*.properties` | Error-code rules for machine-readable API failures and stable message-key mapping |
| [spring-boot-exception.instructions.md](.github/instructions/spring-boot-exception.instructions.md) | `**/*Exception*.java,**/*ExceptionHandler*.java,**/*Advice*.java` | Exception-handling rules for centralized mapping, stable error payloads, and controlled failure semantics |
| [spring-boot-gitignore.instructions.md](.github/instructions/spring-boot-gitignore.instructions.md) | `**/.gitignore` | .gitignore rules for excluding build output, IDE artifacts, OS files, secrets, and logs |
| [spring-boot-http-client.instructions.md](.github/instructions/spring-boot-http-client.instructions.md) | `**/src/main/java/**/*Http*Client*.java, **/src/main/java/**/*Http*Adapter*.java, **/src/main/java/**/config/**/*Http*Configuration*.java, **/src/main/java/**/config/**/*Http*Properties*.java, **/src/main/resources/application*.yml` | HTTP client rules for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries |
| [spring-boot-i18n.instructions.md](.github/instructions/spring-boot-i18n.instructions.md) | `**/*Service.java, **/*Controller.java, **/application*.yml, **/messages*.properties` | i18n rules for message-key governance, locale behavior, and translation-safe output |
| [spring-boot-java-style.instructions.md](.github/instructions/spring-boot-java-style.instructions.md) | `**/src/**/*.java` | Java style rules for readable method structure, spacing discipline, and helper extraction |
| [spring-boot-logback.instructions.md](.github/instructions/spring-boot-logback.instructions.md) | `**/src/main/resources/**/logback-spring.xml, **/pom.xml` | Logback rules for sink routing, structured output, and resilient transport configuration |
| [spring-boot-logging.instructions.md](.github/instructions/spring-boot-logging.instructions.md) | `**/src/main/java/**/*.java, **/src/test/java/**/*.java` | Logging rules for secure, consistent, and operationally useful log events |
| [spring-boot-observability.instructions.md](.github/instructions/spring-boot-observability.instructions.md) | `**/src/main/resources/application*.yml` | Redirect contract: observability governance is consolidated into spring-boot-actuator |
| [spring-boot-openapi.instructions.md](.github/instructions/spring-boot-openapi.instructions.md) | `**/OpenApiConfig.java,**/openapi/**/*.java, **/*Controller.java, **/*Api.java` | OpenAPI rules for metadata quality, endpoint discoverability, and stable specification output |
| [spring-boot-pagination.instructions.md](.github/instructions/spring-boot-pagination.instructions.md) | `**/*Controller.java,**/*Service.java,**/*ServiceImpl.java` | Pagination rules for pageable queries, deterministic ordering, and consistent paged response metadata |
| [spring-boot-pom.instructions.md](.github/instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Maven POM rules for dependency, plugin, and build-governance decisions |
| [spring-boot-readme.instructions.md](.github/instructions/spring-boot-readme.instructions.md) | `README.md, **/README.md, docs/**/*.md, documentation/**/*.md` | README and docs structure rules with no-filler prose policy |
| [spring-boot-referential-integrity.instructions.md](.github/instructions/spring-boot-referential-integrity.instructions.md) | `**/src/main/resources/sql/**/*.sql, **/src/main/resources/sql/**/*.xml` | Referential-integrity rules for foreign keys, delete/update semantics, and data consistency |
| [spring-boot-repository.instructions.md](.github/instructions/spring-boot-repository.instructions.md) | `**/*Repository.java,**/*RepositoryImpl.java,**/*SqlColumns.java,**/*SqlConfigurationProperties.java` | Repository rules for JDBC-first access, interface/implementation separation, and SQL safety |
| [spring-boot-security.instructions.md](.github/instructions/spring-boot-security.instructions.md) | `**/*SecurityConfig.java,**/*Service.java,**/*ServiceImpl.java,**/security/*Permissions.java,**/security/Role.java,**/security/*Role.java` | Security rules for authentication, authorization, service-level checks, and endpoint protection boundaries |
| [spring-boot-service.instructions.md](.github/instructions/spring-boot-service.instructions.md) | `**/*Service.java,**/*ServiceImpl.java` | Service-layer rules for business orchestration, transaction boundaries, and dependency-safe logic |
| [spring-boot-test.instructions.md](.github/instructions/spring-boot-test.instructions.md) | `**/src/test/java/**/*.java, **/*Test.java` | Testing rules for layer-focused suites, API contract assertions, and cross-cutting governance checks |
| [spring-boot-thymeleaf.instructions.md](.github/instructions/spring-boot-thymeleaf.instructions.md) | `**/*PageController.java, **/*Routes.java, **/templates/**/*.html` | Thymeleaf rules for controller conventions, template layout, model usage, form binding, and static resources |
| [spring-boot-websocket.instructions.md](.github/instructions/spring-boot-websocket.instructions.md) | `**/*Socket*.java, **/*Stomp*.java` | WebSocket/STOMP rules for endpoint topology, message flow contract, lifecycle handling, and client resilience |

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
