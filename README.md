# ai-instructions

Centralized GitHub Copilot and Cursor customization assets for Spring Boot projects. This repository packages reusable instruction files, prompts, and skills that can be hardlinked into consumer repositories.

## Repository structure

```
.github/        — GitHub Copilot assets: instructions, prompts, hooks, skills, and agents
.cursor/        — Cursor assets: AGENTS.md, path-scoped rules (.mdc), and skills
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

# Link all frameworks
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" github

# Link only Spring Boot assets
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" github spring-boot

# Link only Ansible assets
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" github ansible

# Link multiple frameworks
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" github spring-boot ansible
```

To install the Cursor overlays into the same consumer repository:

```bash
export AI_INSTRUCTIONS_REPO=/absolute/path/to/ai-instructions
cd /absolute/path/to/consumer-project
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" cursor
"$AI_INSTRUCTIONS_REPO/scripts/setup-ai-links.py" cursor spring-boot
```

Optional: expose this repository’s Cursor skills globally (all workspaces) by
symlinking `~/.cursor/skills` to this checkout’s [.cursor/skills](.cursor/skills).
Keep [.cursor/rules](.cursor/rules) and [AGENTS.md](.cursor/AGENTS.md) per-project via
`setup-ai-links.py`; do not symlink `~/.cursor/rules` or replace all of
`~/.cursor`. If you already have a real `~/.cursor/skills` directory, back it up
before replacing it with the symlink. This repository does not ship Cursor hooks
under `.cursor/hooks` or `.cursor/hooks.json` (Copilot hooks live under
[.github/hooks](.github/hooks) only).

## Configuration reference

- `github` mode links [.github/instructions/copilot-instructions.md](.github/instructions/copilot-instructions.md) into the consumer as `.github/copilot-instructions.md`, plus [.github/hooks](.github/hooks) and [.github/skills](.github/skills). When no framework is specified, all instruction files under [.github/instructions](.github/instructions) are linked. With framework filters, matching framework-prefixed instruction files and unprefixed shared files are linked. Agents and prompts are not linked by this script.
- `cursor` mode always links [AGENTS.md](.cursor/AGENTS.md). Path-scoped rules under [.cursor/rules](.cursor/rules) and skills under [.cursor/skills](.cursor/skills) are framework-filtered: unprefixed files always link; framework-prefixed files link only when that framework is selected. Copilot `*.instructions.md` contracts map to Cursor `.mdc` rules (`applyTo` → `globs`); the workspace baseline maps to `AGENTS.md`, not an always-on rule.
- Frameworks with instruction files today: `ansible`, `spring-boot`. The linker also accepts reserved prefixes `python`, `typescript`, and `go` (no files yet).
- Existing destination files are replaced before relinking; source files in this repository are never modified.
- The linker does not delete leftover files. If a consumer still has old `.cursor/rules` from a previous overlay, remove that directory before re-linking.

## Agent Catalog

Spring Boot custom agents live under [.github/agents](.github/agents). They are
not linked by `setup-ai-links.py`; copy or wire them separately when a consumer
needs the workgroup. Cursor behavior still uses [AGENTS.md](.cursor/AGENTS.md)
plus skills; there is no separate Cursor agent catalog in this repository.

| Agent | Responsibility |
|---|---|
| [spring-boot-orchestrator](.github/agents/spring-boot-orchestrator.agent.md) | Owns the user conversation, classifies the mode, and delegates Architect, Coder, and Reviewer. Does not write code. |
| [spring-boot-architect](.github/agents/spring-boot-architect.agent.md) | Turns the request into one ADR, records user Instruction overrides, and classifies findings |
| [spring-boot-coder](.github/agents/spring-boot-coder.agent.md) | Implements the approved ADR under the instruction contracts |
| [spring-boot-reviewer](.github/agents/spring-boot-reviewer.agent.md) | Sole read-only review of instruction compliance, security, tests, and docs |
| [spring-boot-agent-improver](.github/agents/spring-boot-agent-improver.agent.md) | Optional after a failed or two-pass run. Proposes governance fixes. Never a finalize gate. |

## Cursor overlays

- [AGENTS.md](.cursor/AGENTS.md): always-on behavior baseline, plus a short
  Spring Boot stack card that applies only to Spring Boot work.
- [.cursor/rules](.cursor/rules): path-scoped `.mdc` contracts (Cursor counterparts
  of `.github/instructions/*.instructions.md`).
- [.cursor/skills](.cursor/skills): focused workflows.

| Skill | Invoke | Purpose |
|---|---|---|
| [grill-me](.cursor/skills/grill-me/SKILL.md) | `/grill-me` | Interview-first requirements discovery for non-trivial build requests, unless a project agent or instruction contract already owns that interview |
| [handoff](.cursor/skills/handoff/SKILL.md) | `/handoff` | Create a structured handoff for continuing work in another session |
| [humanizer](.cursor/skills/humanizer/SKILL.md) | `/humanizer` | Revise writing to sound more natural and less formulaic |
| [prepare-commit-messages](.cursor/skills/prepare-commit-messages/SKILL.md) | `/prepare-commit-messages` | Cluster uncommitted changes into feature-scoped Conventional Commits after approval |
| [review-ai-customization-files](.cursor/skills/review-ai-customization-files/SKILL.md) | `/review-ai-customization-files` | Audit AI customization files for duplicates, conflicts, and enforceability |
| [review-and-sync-docs](.cursor/skills/review-and-sync-docs/SKILL.md) | `/review-and-sync-docs` | Correlate workspace deltas with Markdown docs and sync stale documentation |
| [review-code-against-instructions](.cursor/skills/review-code-against-instructions/SKILL.md) | `/review-code-against-instructions` | Audit code against active instructions and flag missing coverage |
| [review-other-ai-feedback](.cursor/skills/review-other-ai-feedback/SKILL.md) | `/review-other-ai-feedback` | Critically review external AI feedback and decide adopt/adapt/reject |
| [root-cause-analysis](.cursor/skills/root-cause-analysis/SKILL.md) | `/root-cause-analysis` | Analyze logs/exceptions for root cause and propose permanent fixes |

## Cursor rules

Path-scoped Cursor rules live under [.cursor/rules](.cursor/rules). They are the Cursor counterparts of Copilot instruction contracts: same enforceable content, with `applyTo` mapped to `globs` and `alwaysApply: false`. The always-on baseline stays in [AGENTS.md](.cursor/AGENTS.md) (counterpart of `copilot-instructions.md`), not as an always-on `.mdc` rule.

| File | Applies to (globs) | Purpose |
|---|---|---|
| [ai-customization.mdc](.cursor/rules/ai-customization.mdc) | `**/*.agent.md`, `**/*.agents.md`, `**/*.instructions.md`, `**/*.prompt.md`, `**/copilot-instructions.md`, `**/skills/**/SKILL.md`, `**/hooks/**/*.json`, `**/*.mdc`, `**/AGENTS.md`, `**/agents.md`, `**/.cursor/rules/**/*.mdc`, `**/.cursor/AGENTS.md`, `**/.cursor/skills/**/SKILL.md` | Authoring and review contract for AI customization files, including agents, instructions, prompts, skills, hooks, and workspace guidance. |
| [ansible-architecture.mdc](.cursor/rules/ansible-architecture.mdc) | `**/ansible/**`, `**/ansible.cfg`, `**/.ansible-lint` | Global architecture baseline for Ansible automation repositories with project layout, playbook sequencing, and idempotency conventions. |
| [ansible-config.mdc](.cursor/rules/ansible-config.mdc) | `**/ansible.cfg` | ansible.cfg governance contract for runtime defaults, connection behavior, and safe automation settings. |
| [ansible-playbook-style.mdc](.cursor/rules/ansible-playbook-style.mdc) | `**/ansible/**/*.yml`, `**/ansible/**/*.yaml` | Playbook and task style contract for Ansible YAML files, including task naming, condition placement, and task-level import/include policy. |
| [ansible-role.mdc](.cursor/rules/ansible-role.mdc) | `**/ansible/roles/**` | Role governance contract for Ansible roles, including directory ownership, task composition, and variable boundaries. |
| [ansible-template.mdc](.cursor/rules/ansible-template.mdc) | `**/ansible/**/templates/**/*.j2` | Jinja2 template contract for Ansible role templates: variable safety, block formatting, and rendered-output hygiene. |
| [spring-boot-actuator.mdc](.cursor/rules/spring-boot-actuator.mdc) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/pom.xml`, `**/*Actuator*.java`, `**/*Security*Config*.java` | Spring Boot Actuator contract for endpoint exposure, health details, probes, and management hardening. |
| [spring-boot-architecture.mdc](.cursor/rules/spring-boot-architecture.mdc) | `**/src/**/*.java` | Spring Boot Java architecture contract for feature packaging, service boundaries, repositories, DTOs, mappers, and controller dependencies. |
| [spring-boot-async.mdc](.cursor/rules/spring-boot-async.mdc) | `**/*Application.java`, `**/*Worker.java`, `**/*AuditListener.java`, `**/job/AsyncJob*.java` | Spring Boot @Async contract for enabling async execution, worker methods, and request/response job APIs. |
| [spring-boot-cloud-config.mdc](.cursor/rules/spring-boot-cloud-config.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*ConfigServer*.java`, `**/cloud/config/**/*.java` | Spring Cloud Config contract for Config Server Git backends, clients, credentials, and Config Data import. |
| [spring-boot-config.mdc](.cursor/rules/spring-boot-config.mdc) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/pom.xml` | Spring Boot application configuration contract for YAML settings, environment profiles, and DevTools. |
| [spring-boot-container.mdc](.cursor/rules/spring-boot-container.mdc) | `**/Dockerfile`, `**/Dockerfile-*`, `**/docker-compose.yml`, `**/docker-compose*.yml`, `**/compose.yml`, `**/compose*.yml`, `**/.dockerignore`, `**/.env.example` | Container and Compose contract for build strategy, runtime hardening, profiles, networks, resources, and container operations. |
| [spring-boot-controller.mdc](.cursor/rules/spring-boot-controller.mdc) | `**/*RestController.java`, `**/*OpenApi*.java`, `**/openapi/**/*.java` | Spring Boot REST controller contract for URL design, HTTP verbs, status codes, pagination, and OpenAPI annotations. |
| [spring-boot-events.mdc](.cursor/rules/spring-boot-events.mdc) | `**/*EventPublisher.java`, `**/*PublishedEvent.java`, `**/*AuditListener.java`, `**/*EventsListener.java` | Spring Application Events contract for in-process event records, publishers, and @EventListener handlers. |
| [spring-boot-exception.mdc](.cursor/rules/spring-boot-exception.mdc) | `**/src/**/*.java` | Spring Boot validation and exception-handling contract for REST error envelopes, AppException, Bean Validation, and MVC form errors. |
| [spring-boot-gitignore.mdc](.cursor/rules/spring-boot-gitignore.mdc) | `**/.gitignore` | Spring Boot .gitignore contract for build output, IDE files, logs, secrets, and certificate material. |
| [spring-boot-http-client.mdc](.cursor/rules/spring-boot-http-client.mdc) | `**/src/**/*.java`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml` | Spring Boot outbound HTTP contract for RestClient beans, timeouts, and repository-side remote calls. |
| [spring-boot-i18n.mdc](.cursor/rules/spring-boot-i18n.mdc) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/src/main/resources/i18n/**`, `**/src/**/*.java` | Spring Boot i18n contract for message bundles, locale resolution, MessageSource usage, and key-parity tests. |
| [spring-boot-java-style.mdc](.cursor/rules/spring-boot-java-style.mdc) | `**/src/**/*.java` | Java coding style contract for imports, visibility, annotations, constants, records, method structure, JavaDoc, and mandatory verification after edits. |
| [spring-boot-jdbc.mdc](.cursor/rules/spring-boot-jdbc.mdc) | `**/*Repository*.java`, `**/db/**/*.java`, `**/sql/**`, `**/application*.yml`, `**/application*.yaml`, `**/pom.xml` | Spring Boot JDBC contract for JdbcClient, externalized SQL, transactions, generated keys, and DBA-owned DDL. |
| [spring-boot-k6.mdc](.cursor/rules/spring-boot-k6.mdc) | `**/src/test/k6/**/*.js` | Spring Boot k6 load-testing contract for optional HTTP scripts, env-based targets, checks, and generated reports. |
| [spring-boot-logging.mdc](.cursor/rules/spring-boot-logging.mdc) | `**/src/main/resources/**/logback-spring.xml`, `**/src/main/resources/**/application*.yml`, `**/src/main/resources/**/application*.yaml`, `**/src/main/resources/**/application*.properties`, `**/src/**/*.java` | Spring Boot logging contract for Logback configuration, i18n-backed log messages, and logger usage. |
| [spring-boot-lombok.mdc](.cursor/rules/spring-boot-lombok.mdc) | `**/pom.xml`, `**/src/**/*.java` | Spring Boot Lombok contract for Maven setup, allowed annotations, and when to prefer Java records. |
| [spring-boot-mapstruct.mdc](.cursor/rules/spring-boot-mapstruct.mdc) | `**/pom.xml`, `**/*Mapper.java` | Spring Boot MapStruct contract for Maven processor setup, @Mapper configuration, and generated mapping methods. |
| [spring-boot-pom.mdc](.cursor/rules/spring-boot-pom.mdc) | `**/pom.xml` | Spring Boot Maven pom.xml contract for dependency, plugin, and coordinate governance. |
| [spring-boot-project.mdc](.cursor/rules/spring-boot-project.mdc) | `**/pom.xml`, `**/src/**`, `**/README.md`, `**/.gitignore` | Always-on Spring Boot project contract: stack non-negotiables, topic-file index, new-app scaffold, and pre-done self-check. |
| [spring-boot-rabbitmq.mdc](.cursor/rules/spring-boot-rabbitmq.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Rabbit*.java`, `**/rabbitmq/**/*.java`, `**/MessageProducer.java`, `**/MessageConsumer.java` | Spring Boot RabbitMQ / AMQP contract for starter, broker credentials, exchange topology, producers, listeners, and JSON conversion. |
| [spring-boot-readme.mdc](.cursor/rules/spring-boot-readme.mdc) | `README.md`, `**/README.md` | Spring Boot README contract for required sections, actionable run/test docs, and no-filler project documentation. |
| [spring-boot-redis.mdc](.cursor/rules/spring-boot-redis.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Redis*.java`, `**/redis/**/*.java`, `**/CacheConfiguration.java` | Spring Boot Redis contract for connection settings, RedisTemplate datastore access, Spring Cache with Redis, and Redis Pub/Sub. |
| [spring-boot-security.mdc](.cursor/rules/spring-boot-security.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Security*.java`, `**/security/**/*.java` | Spring Boot Security contract for HTTP Basic APIs, deny-by-default filter chains, credentials, and method authorization. |
| [spring-boot-test.mdc](.cursor/rules/spring-boot-test.mdc) | `**/src/test/java/**/*.java`, `**/pom.xml` | Spring Boot testing contract for context-load tests, WebMvc slices, service unit tests, and verification boundaries. |
| [spring-boot-thymeleaf.mdc](.cursor/rules/spring-boot-thymeleaf.mdc) | `**/pom.xml`, `**/*PageController.java`, `**/src/main/resources/templates/**/*.html`, `**/src/main/resources/static/**` | Spring Boot Thymeleaf contract for page controllers, templates, form binding, fragments, and static assets. |
| [spring-boot-tls.mdc](.cursor/rules/spring-boot-tls.mdc) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Ssl*.java`, `**/*Tls*.java`, `**/*Https*.java`, `**/Dockerfile`, `**/docker-compose*.yml` | Spring Boot HTTPS and TLS contract for embedded TLS, certificate material, keystores, and transport-security boundaries. |
| [spring-boot-tracing.mdc](.cursor/rules/spring-boot-tracing.mdc) | `**/*Tracing*.java`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/logback*.xml` | Spring Boot Micrometer Tracing and OpenTelemetry OTLP contract for application tracing. |
| [spring-boot-traefik.mdc](.cursor/rules/spring-boot-traefik.mdc) | `**/docker-compose.yml`, `**/docker-compose*.yml`, `**/compose.yml`, `**/compose*.yml` | Traefik ingress contract for app Compose labels, shared network, Host routing, and Traefik-only exposure. |
| [spring-boot-vault.mdc](.cursor/rules/spring-boot-vault.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Vault*.java`, `**/vault/**/*.java` | Spring Cloud Vault client integration contract for dependencies, Config Data, KV secrets, runtime reads, and tests. |
| [spring-boot-virtual-threads.mdc](.cursor/rules/spring-boot-virtual-threads.mdc) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Config*.java`, `**/*Configuration*.java` | Spring Boot virtual-threads contract for enabling Loom on servlet apps and avoiding custom executors. |
| [spring-boot-websocket.mdc](.cursor/rules/spring-boot-websocket.mdc) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Socket*.java`, `**/*WebSocket*.java`, `**/websocket/**/*.java` | Spring Boot WebSocket/STOMP contract for endpoints, destinations, CORS origins, session tracking, and socket controllers. |

To inspect current Cursor routing patterns:

```bash
rg -n "^globs:" .cursor/rules/*.mdc
```

## Prompt files

Prompt files under [.github/prompts](.github/prompts) are kept in this repository
for Copilot Chat (`/prompt-name`). They are not linked by `setup-ai-links.py`.
Keep prompts for thin, manual-only workflows; multi-step reusable procedures live
under Skills.

| File | Invoke with | Purpose |
|---|---|---|
| [add-content-to-file.prompt.md](.github/prompts/add-content-to-file.prompt.md) | `/add-content-to-file` | Add, update, or deduplicate content in markdown or plain text files while preserving document structure and style |
| [clean-slate-workspace.prompt.md](.github/prompts/clean-slate-workspace.prompt.md) | `/clean-slate-workspace` | Remove only this chat's created artifacts from the active workspace after explicit confirmation for a clean restart |

## Skills

Skills are reusable, on-demand workflows. Invoke them with `/skill-name` or let
the agent discover them when the skill description matches the request.
Copilot skills live under [.github/skills](.github/skills); Cursor skills live
under [.cursor/skills](.cursor/skills). Bodies are shared.

| Skill | Invoke | Purpose |
|---|---|---|
| [grill-me](.github/skills/grill-me/SKILL.md) | `/grill-me` | Interview-first requirements discovery for non-trivial build requests, unless a project agent or instruction contract already owns that interview |
| [handoff](.github/skills/handoff/SKILL.md) | `/handoff` | Create a structured handoff for continuing work in another session |
| [humanizer](.github/skills/humanizer/SKILL.md) | `/humanizer` | Rewrite prose to sound natural, specific, and appropriate to its intended voice |
| [prepare-commit-messages](.github/skills/prepare-commit-messages/SKILL.md) | `/prepare-commit-messages` | Cluster uncommitted changes into feature-scoped Conventional Commits after approval |
| [review-ai-customization-files](.github/skills/review-ai-customization-files/SKILL.md) | `/review-ai-customization-files` | Audit AI customization files for duplicates, conflicts, and enforceability |
| [review-and-sync-docs](.github/skills/review-and-sync-docs/SKILL.md) | `/review-and-sync-docs` | Correlate workspace deltas with Markdown docs and sync stale documentation |
| [review-code-against-instructions](.github/skills/review-code-against-instructions/SKILL.md) | `/review-code-against-instructions` | Audit code against active instructions and flag missing coverage |
| [review-other-ai-feedback](.github/skills/review-other-ai-feedback/SKILL.md) | `/review-other-ai-feedback` | Critically review external AI feedback and decide adopt/adapt/reject |
| [root-cause-analysis](.github/skills/root-cause-analysis/SKILL.md) | `/root-cause-analysis` | Analyze logs/exceptions for root cause and propose permanent fixes |

## Instruction files

Instruction contracts live under [.github/instructions](.github/instructions). They are auto-routed by each file's `applyTo` pattern.

| File | Applies to | Purpose |
|---|---|---|
| [copilot-instructions.md](.github/instructions/copilot-instructions.md) | `**` | Always-on behavioral baseline for directness, scope control, workflow macros (`#DMS`, `#OTS`, `#FIX`), and safe execution across workspace tasks. The linker installs this file at `.github/copilot-instructions.md` in a consumer repository. |
| [ai-customization.instructions.md](.github/instructions/ai-customization.instructions.md) | `**/*.agent.md, **/*.agents.md, **/*.instructions.md, **/*.prompt.md, **/copilot-instructions.md, **/skills/**/SKILL.md, **/hooks/**/*.json` | Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance. |
| [ansible-architecture.instructions.md](.github/instructions/ansible-architecture.instructions.md) | `**/ansible/**, **/ansible.cfg, **/.ansible-lint` | Ansible architecture baseline for project layout, playbook sequencing, and idempotency conventions. |
| [ansible-config.instructions.md](.github/instructions/ansible-config.instructions.md) | `**/ansible.cfg` | ansible.cfg governance contract for runtime defaults, connection behavior, and safe automation settings. |
| [ansible-playbook-style.instructions.md](.github/instructions/ansible-playbook-style.instructions.md) | `**/ansible/**/*.yml, **/ansible/**/*.yaml` | Playbook and task style contract for task naming, condition placement, and include/import policy. |
| [ansible-role.instructions.md](.github/instructions/ansible-role.instructions.md) | `**/ansible/roles/**` | Role governance contract for Ansible roles, including directory ownership, task composition, and variable boundaries. |
| [ansible-template.instructions.md](.github/instructions/ansible-template.instructions.md) | `**/ansible/**/templates/**/*.j2` | Jinja2 template contract for Ansible role templates: variable safety, block formatting, and rendered-output hygiene. |
| [spring-boot-actuator.instructions.md](.github/instructions/spring-boot-actuator.instructions.md) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/pom.xml`, `**/*Actuator*.java`, `**/*Security*Config*.java` | Actuator exposure (`health,info,metrics`), health details by profile, probes, and management access boundary. |
| [spring-boot-architecture.instructions.md](.github/instructions/spring-boot-architecture.instructions.md) | `**/src/**/*.java` | Feature packaging, service/repository boundaries, `<Feature>Mapper` naming, and JDBC-not-JPA baseline. |
| [spring-boot-async.instructions.md](.github/instructions/spring-boot-async.instructions.md) | `**/*Application.java`, `**/*Worker.java`, `**/*AuditListener.java`, `**/job/AsyncJob*.java` | `@EnableAsync`, `@Async` workers, and accept-and-poll job APIs. |
| [spring-boot-cloud-config.instructions.md](.github/instructions/spring-boot-cloud-config.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*ConfigServer*.java`, `**/cloud/config/**/*.java` | Spring Cloud Config contract for Config Server Git backends, clients, credentials, and Config Data import. |
| [spring-boot-config.instructions.md](.github/instructions/spring-boot-config.instructions.md) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/pom.xml` | YAML config, `development`/`production` profiles, secrets, and DevTools. |
| [spring-boot-container.instructions.md](.github/instructions/spring-boot-container.instructions.md) | `**/Dockerfile`, `**/Dockerfile-*`, `**/docker-compose.yml`, `**/docker-compose*.yml`, `**/compose.yml`, `**/compose*.yml`, `**/.dockerignore`, `**/.env.example` | Generic container image builds, runtime hardening, Compose profiles, networks, resources, healthchecks, and logging boundaries. |
| [spring-boot-controller.instructions.md](.github/instructions/spring-boot-controller.instructions.md) | `**/*RestController.java`, `**/*OpenApi*.java`, `**/openapi/**/*.java` | REST URL design, HTTP status/`Location`, `Pageable`, and OpenAPI annotations. |
| [spring-boot-events.instructions.md](.github/instructions/spring-boot-events.instructions.md) | `**/*EventPublisher.java`, `**/*PublishedEvent.java`, `**/*AuditListener.java`, `**/*EventsListener.java` | In-process Spring application events, publishers, and `@EventListener` handlers. |
| [spring-boot-exception.instructions.md](.github/instructions/spring-boot-exception.instructions.md) | `**/src/**/*.java` | `AppException`, one `@RestControllerAdvice`, JSON error envelope, and Bean Validation. |
| [spring-boot-gitignore.instructions.md](.github/instructions/spring-boot-gitignore.instructions.md) | `**/.gitignore` | Build, IDE, logs, `.env`, TLS material, and OS junk ignores for real apps. |
| [spring-boot-http-client.instructions.md](.github/instructions/spring-boot-http-client.instructions.md) | `**/src/**/*.java`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml` | Named `RestClient` beans, timeouts, and repository-side outbound calls. |
| [spring-boot-i18n.instructions.md](.github/instructions/spring-boot-i18n.instructions.md) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/src/main/resources/i18n/**`, `**/src/**/*.java` | Message bundles, locale resolution, and key-parity tests. |
| [spring-boot-java-style.instructions.md](.github/instructions/spring-boot-java-style.instructions.md) | `**/src/**/*.java` | Imports, visibility, annotation order, constants, records, JavaDoc, and compile/test verification. |
| [spring-boot-jdbc.instructions.md](.github/instructions/spring-boot-jdbc.instructions.md) | `**/*Repository*.java`, `**/db/**/*.java`, `**/sql/**`, `**/application*.yml`, `**/application*.yaml`, `**/pom.xml` | `JdbcClient`, externalized SQL, transactions, `RETURNING`, and DBA-owned DDL. |
| [spring-boot-k6.instructions.md](.github/instructions/spring-boot-k6.instructions.md) | `**/src/test/k6/**/*.js` | Optional k6 HTTP load scripts, env-based targets, checks, and gitignored reports. |
| [spring-boot-logging.instructions.md](.github/instructions/spring-boot-logging.instructions.md) | `**/src/main/resources/**/logback-spring.xml`, `**/src/main/resources/**/application*.yml`, `**/src/main/resources/**/application*.yaml`, `**/src/main/resources/**/application*.properties`, `**/src/**/*.java` | Spring Boot logging contract for Logback configuration, i18n-backed log messages, and logger usage. |
| [spring-boot-lombok.instructions.md](.github/instructions/spring-boot-lombok.instructions.md) | `**/pom.xml`, `**/src/**/*.java` | Lombok Maven setup, allowed annotations, and records over `@Data`. |
| [spring-boot-mapstruct.instructions.md](.github/instructions/spring-boot-mapstruct.instructions.md) | `**/pom.xml`, `**/*Mapper.java` | MapStruct Maven processor setup, `@Mapper` configuration, and generated mapping methods. |
| [spring-boot-pom.instructions.md](.github/instructions/spring-boot-pom.instructions.md) | `**/pom.xml` | Coordinates, dependency comments/order, and JDBC-not-JPA dependency defaults. |
| [spring-boot-project.instructions.md](.github/instructions/spring-boot-project.instructions.md) | `**/pom.xml, **/src/**, **/README.md, **/.gitignore` | Spring Boot entry point: non-negotiables, topic index, new-app scaffold, and self-check. |
| [spring-boot-rabbitmq.instructions.md](.github/instructions/spring-boot-rabbitmq.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Rabbit*.java`, `**/rabbitmq/**/*.java`, `**/MessageProducer.java`, `**/MessageConsumer.java` | Spring AMQP starter, broker credentials, topology beans, producers, listeners, and JSON conversion. |
| [spring-boot-readme.instructions.md](.github/instructions/spring-boot-readme.instructions.md) | `README.md`, `**/README.md` | Required README sections, run/test commands, env docs, and no-filler project docs. |
| [spring-boot-redis.instructions.md](.github/instructions/spring-boot-redis.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Redis*.java`, `**/redis/**/*.java`, `**/CacheConfiguration.java` | Redis connection, `RedisTemplate` datastore access, Spring Cache with Redis, and Redis Pub/Sub. |
| [spring-boot-security.instructions.md](.github/instructions/spring-boot-security.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Security*.java`, `**/security/**/*.java` | HTTP Basic, deny-by-default filter chains, env-driven in-memory credentials, and method authorization. |
| [spring-boot-test.instructions.md](.github/instructions/spring-boot-test.instructions.md) | `**/src/test/java/**/*.java`, `**/pom.xml` | Context-load baseline, `@WebMvcTest` + service mocks, service unit tests, and env-dependent reporting. |
| [spring-boot-thymeleaf.instructions.md](.github/instructions/spring-boot-thymeleaf.instructions.md) | `**/pom.xml`, `**/*PageController.java`, `**/src/main/resources/templates/**/*.html`, `**/src/main/resources/static/**` | `<Feature>PageController`, templates/static layout, forms, `#{…}` UI copy, and fragments. |
| [spring-boot-tls.instructions.md](.github/instructions/spring-boot-tls.instructions.md) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Ssl*.java`, `**/*Tls*.java`, `**/*Https*.java`, `**/Dockerfile`, `**/docker-compose*.yml` | Embedded TLS, certificate material, keystores, and transport-security boundaries. |
| [spring-boot-traefik.instructions.md](.github/instructions/spring-boot-traefik.instructions.md) | `**/docker-compose.yml`, `**/docker-compose*.yml`, `**/compose.yml`, `**/compose*.yml` | Traefik ingress labels, shared network, Host routing, and Traefik-only exposure. |
| [spring-boot-tracing.instructions.md](.github/instructions/spring-boot-tracing.instructions.md) | `**/*Tracing*.java`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/logback*.xml` | Spring Boot Micrometer Tracing and OpenTelemetry OTLP contract for application tracing. |
| [spring-boot-vault.instructions.md](.github/instructions/spring-boot-vault.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Vault*.java`, `**/vault/**/*.java` | Spring Cloud Vault dependencies, Config Data, KV secrets, optional native runtime reads, and isolated tests. |
| [spring-boot-virtual-threads.instructions.md](.github/instructions/spring-boot-virtual-threads.instructions.md) | `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Config*.java`, `**/*Configuration*.java` | `spring.threads.virtual.enabled`, blocking servlet stack, and no custom Loom executors. |
| [spring-boot-websocket.instructions.md](.github/instructions/spring-boot-websocket.instructions.md) | `**/pom.xml`, `**/src/main/resources/application*.yml`, `**/src/main/resources/application*.yaml`, `**/*Socket*.java`, `**/*WebSocket*.java`, `**/websocket/**/*.java` | STOMP/SockJS endpoint, destinations, fail-closed origins, and `<Feature>SocketController`. |

To inspect current routing patterns directly:

```bash
rg -n "^applyTo:" .github/instructions/*.instructions.md
```

## How Spring Boot instructions and rules load

- Copilot: [spring-boot-project.instructions.md](.github/instructions/spring-boot-project.instructions.md) applies to `pom.xml`, `src`, `README.md`, and `.gitignore`. On an empty repository, read it first, then the topic files it names, before creating files.
- Copilot: other `spring-boot-*.instructions.md` files route by `applyTo`. On an empty repository those globs may not match yet, so the project file tells the agent which topic files to read before creating files.
- Cursor: [spring-boot-project.mdc](.cursor/rules/spring-boot-project.mdc) is the empty-repo entry point; topic rules under [.cursor/rules](.cursor/rules) attach by `globs`. [AGENTS.md](.cursor/AGENTS.md) carries the always-on baseline and a short Spring Boot stack card.

## Instruction and rule format conventions

- `spring-boot-*.instructions.md` and `spring-boot-*.mdc` files follow a standardized structure: YAML frontmatter, one H1 title, and deterministic H2 rule sections
- Copilot instructions use `description` + `applyTo`; Cursor rules use `description` + `globs` + `alwaysApply: false`
- Keep one rule per bullet and keep sections enforceable and purpose-specific
- Customization files follow the style contracts in [ai-customization.instructions.md](.github/instructions/ai-customization.instructions.md) and [ai-customization.mdc](.cursor/rules/ai-customization.mdc)

## Contributing

- Keep each instruction or rule focused on one concern and define `applyTo` / `globs` as narrowly as possible
- When changing a shared contract, update both the Copilot instruction and the Cursor rule counterpart
- For Spring Boot contracts, follow the standardized deterministic structure already used in this repository
- Update [README.md](README.md) whenever an instruction, rule, prompt, or skill is added, renamed, or meaningfully updated

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
