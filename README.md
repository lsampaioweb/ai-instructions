<!-- filepath: README.md -->
# ai-instructions

Centralized VS Code Copilot instruction and prompt files for Spring Boot projects. These files are picked up automatically by GitHub Copilot in VS Code and drive consistent code generation, review, and tooling behaviour across all repositories that reference this configuration.

## Repository structure

```
agents/         — .agent.md files for specialized agent workflows
hooks/          — reserved for post-generation hooks
instructions/   — .instructions.md files; auto-applied by Copilot based on applyTo patterns
prompts/        — .prompt.md files; invoked explicitly with /prompt-name
skills/         — SKILL.md files; domain knowledge loaded on demand
```

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [prepare-commit-messages.prompt.md](prompts/prepare-commit-messages.prompt.md) | `/prepare-commit-messages` | Review uncommitted changes, group logical commits, present commit plan for approval, then commit if approved; keep output concise without redundant bodies or repeated file lists |
| [project-bootstrap.prompt.md](prompts/project-bootstrap.prompt.md) | `/project-bootstrap` | Discover workspace architecture from repository evidence and reconcile instruction files with explicit create, update, retain, or delete actions |
| [review-ai-customization-files.prompt.md](prompts/review-ai-customization-files.prompt.md) | `/review-ai-customization-files` | Score AI customization files with a strict style rubric and report enforceable fixes for duplicates, conflicts, and low-signal wording |
| [review-and-sync-docs.prompt.md](prompts/review-and-sync-docs.prompt.md) | `/review-and-sync-docs` | Correlate workspace deltas with Markdown docs and sync stale documentation in a controlled pass |
| [review-code-against-instructions.prompt.md](prompts/review-code-against-instructions.prompt.md) | `/review-code-against-instructions` | Run bi-directional compliance audit between code artifacts and instruction contracts |
| [review-other-ai-feedback.prompt.md](prompts/review-other-ai-feedback.prompt.md) | `/review-other-ai-feedback` | Critically review external AI feedback, identify gaps, and suggest concrete improvements |
| [root-cause-analysis.prompt.md](prompts/root-cause-analysis.prompt.md) | `/root-cause-analysis` | Analyze logs and exceptions to identify root cause and propose permanent architectural fixes |

## Agent files

Agent workflows are tracked under [agents/](agents/).

| File | Invoke with | Purpose |
|---|---|---|
| [agents/architect.agent.md](agents/architect.agent.md) | `@architect` | Define and clarify feature architecture requirements before implementation and produce the feature ADR |
| [agents/coder.agent.md](agents/coder.agent.md) | `@coder` | Implement feature Java code after ADR approval or a canonical bug-fix scope note |
| [agents/db-schema.agent.md](agents/db-schema.agent.md) | `@db-schema` | Create or update schema migrations and MyBatis mapper artifacts for a feature |
| [agents/documentation.agent.md](agents/documentation.agent.md) | `@documentation` | Update README, API docs, and interface documentation after implementation and verification |
| [agents/i18n.agent.md](agents/i18n.agent.md) | `@i18n` | Add or reconcile localized message keys and locale bundle consistency for a feature |
| [agents/orchestrator.agent.md](agents/orchestrator.agent.md) | `@orchestrator` | Route feature work across specialized agents from ADR creation through verification and documentation closure |
| [agents/performance.agent.md](agents/performance.agent.md) | `@performance` | Validate latency, memory, and throughput risks against ADR requirements |
| [agents/qa.agent.md](agents/qa.agent.md) | `@qa` | Validate structural compliance, code quality gates, and ADR alignment after implementation |
| [agents/security.agent.md](agents/security.agent.md) | `@security` | Audit new feature code for injection, access-control, and sensitive-data exposure risks |

## Skill files

Loaded automatically by Copilot when the prompt topic matches the skill description. Also invokable with `/skill-name` in Copilot Chat.

| Folder | Invoke with | Purpose |
|---|---|---|
| [skills/spring-boot/](skills/spring-boot/SKILL.md) | `/spring-boot` | Unified Spring Boot workflow that routes requests to creation or review flow based on intent, with scoped traceability and compliance reporting |

## Instruction files

Instruction contracts live under [instructions/](instructions). They are auto-routed by each file's `applyTo` pattern.

Core governance:
- [ai-customization.instructions.md](instructions/ai-customization.instructions.md)
- [copilot-instructions.md](instructions/copilot-instructions.md)
- [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md)

Spring Boot component contracts:
- [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md)
- [spring-boot-api-versioning.instructions.md](instructions/spring-boot-api-versioning.instructions.md)
- [spring-boot-async-events.instructions.md](instructions/spring-boot-async-events.instructions.md)
- [spring-boot-caching.instructions.md](instructions/spring-boot-caching.instructions.md)
- [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md)
- [spring-boot-container.instructions.md](instructions/spring-boot-container.instructions.md)
- [spring-boot-controller.instructions.md](instructions/spring-boot-controller.instructions.md)
- [spring-boot-database-schema.instructions.md](instructions/spring-boot-database-schema.instructions.md)
- [spring-boot-dto-mapper.instructions.md](instructions/spring-boot-dto-mapper.instructions.md)
- [spring-boot-enum.instructions.md](instructions/spring-boot-enum.instructions.md)
- [spring-boot-error-code.instructions.md](instructions/spring-boot-error-code.instructions.md)
- [spring-boot-exception.instructions.md](instructions/spring-boot-exception.instructions.md)
- [spring-boot-http-client.instructions.md](instructions/spring-boot-http-client.instructions.md)
- [spring-boot-i18n.instructions.md](instructions/spring-boot-i18n.instructions.md)
- [spring-boot-logback.instructions.md](instructions/spring-boot-logback.instructions.md)
- [spring-boot-logging.instructions.md](instructions/spring-boot-logging.instructions.md)
- [spring-boot-migrations.instructions.md](instructions/spring-boot-migrations.instructions.md)
- [spring-boot-observability.instructions.md](instructions/spring-boot-observability.instructions.md)
- [spring-boot-openapi.instructions.md](instructions/spring-boot-openapi.instructions.md)
- [spring-boot-pagination.instructions.md](instructions/spring-boot-pagination.instructions.md)
- [spring-boot-pom.instructions.md](instructions/spring-boot-pom.instructions.md)
- [spring-boot-readme.instructions.md](instructions/spring-boot-readme.instructions.md)
- [spring-boot-referential-integrity.instructions.md](instructions/spring-boot-referential-integrity.instructions.md)
- [spring-boot-repository.instructions.md](instructions/spring-boot-repository.instructions.md)
- [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md)
- [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md)
- [spring-boot-soft-delete.instructions.md](instructions/spring-boot-soft-delete.instructions.md)
- [spring-boot-test.instructions.md](instructions/spring-boot-test.instructions.md)
- [spring-boot-thymeleaf.instructions.md](instructions/spring-boot-thymeleaf.instructions.md)
- [spring-boot-websocket.instructions.md](instructions/spring-boot-websocket.instructions.md)

To inspect current routing patterns directly:

```bash
rg -n "^applyTo:" instructions/*.instructions.md
```

## Governance Notes

- Proactive loading is mandatory: read each activated component instruction file before generation or review; do not rely only on `applyTo` auto-loading.
- Optional components follow intent-first activation: ask when intent is ambiguous, then apply silent defaults only when user intent remains silent.
- Prompt macros are available through [instructions/copilot-instructions.md](instructions/copilot-instructions.md): `#DMS`, `#ALT`, `#OTS`, `#FAST`.
- Reviewer initialization is centralized in [agents/orchestrator.agent.md](agents/orchestrator.agent.md) under `Shared Reviewer Agent Baseline`; reviewer agents inherit that baseline.

## Instruction format conventions

- `spring-boot-*.instructions.md` files follow a standardized structure: YAML frontmatter, one H1 title, and deterministic H2 rule sections
- Keep one rule per bullet and keep sections enforceable and purpose-specific
- All `.instructions.md`, `.prompt.md`, `.agent.md`, and `SKILL.md` files must follow the style contract defined in [ai-customization.instructions.md](instructions/ai-customization.instructions.md)

## Contributing

- Keep each instruction file focused on one concern and define `applyTo` as narrowly as possible
- For Spring Boot instruction files, follow the standardized deterministic structure already used in this repository
- Update [README.md](README.md) whenever an instruction, prompt, or skill is added, renamed, or meaningfully updated

## License

See [LICENSE](LICENSE) for details.

#
### Created by:
1. Luciano Sampaio.
