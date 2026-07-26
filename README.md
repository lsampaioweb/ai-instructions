<!-- filepath: README.md -->
# ai-instructions

Centralized VS Code Copilot instruction and prompt files for Spring Boot projects. These files are picked up automatically by GitHub Copilot in VS Code and drive consistent code generation, review, and tooling behaviour across all repositories that reference this configuration.

## Repository structure

```
agents/         — specialized .agent.md workflows used by orchestrator, architect, coder, and reviewers
hooks/          — reserved for post-generation hooks
instructions/   — .instructions.md files; auto-applied by Copilot based on applyTo patterns
prompts/        — .prompt.md files; invoked explicitly with /prompt-name
skills/         — reserved for SKILL.md files when on-demand domain knowledge is present
```

## Agent Catalog

- [spring-orchestrator.agent.md](agents/spring-orchestrator.agent.md): routes create and review work, applies loop controls, and normalizes final output.
- [spring-architect.agent.md](agents/spring-architect.agent.md): read-only architecture planning and implementation decomposition.
- [spring-coder.agent.md](agents/spring-coder.agent.md): write-capable implementation agent.
- [spring-meta-optimizer.agent.md](agents/spring-meta-optimizer.agent.md): post-pass optimization of AI customization rules; analyzes iteration friction and proposes generic framework-level guidance.
- [spring-review-qa.agent.md](agents/spring-review-qa.agent.md): QA-only reviewer.
- [spring-review-security.agent.md](agents/spring-review-security.agent.md): security-only reviewer.
- [spring-review-performance.agent.md](agents/spring-review-performance.agent.md): performance-only reviewer.
- [spring-review-i18n.agent.md](agents/spring-review-i18n.agent.md): i18n-only reviewer.
- [spring-review-database.agent.md](agents/spring-review-database.agent.md): database-only reviewer.

## Prompt files

Invoke with `/prompt-name` in the Copilot Chat input.

| File | Invoke with | Purpose |
|---|---|---|
| [add-content-to-file.prompt.md](prompts/add-content-to-file.prompt.md) | `/add-content-to-file` | Add, update, or deduplicate content in markdown or plain text files while preserving document structure and style |
| [clean-slate-workspace.prompt.md](prompts/clean-slate-workspace.prompt.md) | `/clean-slate-workspace` | Remove only this chat's created artifacts from the active workspace after explicit confirmation for a clean restart |
| [prepare-commit-messages.prompt.md](prompts/prepare-commit-messages.prompt.md) | `/prepare-commit-messages` | Review uncommitted changes, group atomic feature-scoped commits, present a plan for approval, and execute commits only after explicit confirmation |
| [review-ai-customization-files.prompt.md](prompts/review-ai-customization-files.prompt.md) | `/review-ai-customization-files` | Audit AI customization files for duplicates, conflicts, and enforceability using a strict scoring rubric |
| [review-and-sync-docs.prompt.md](prompts/review-and-sync-docs.prompt.md) | `/review-and-sync-docs` | Correlate workspace deltas with Markdown docs and sync stale documentation in a controlled pass |
| [review-code-against-instructions.prompt.md](prompts/review-code-against-instructions.prompt.md) | `/review-code-against-instructions` | Audit the target scope both ways: code against instructions and instructions against code, with minimal remediation actions |
| [review-other-ai-feedback.prompt.md](prompts/review-other-ai-feedback.prompt.md) | `/review-other-ai-feedback` | Critically review external AI feedback, identify gaps, and suggest concrete improvements |
| [root-cause-analysis.prompt.md](prompts/root-cause-analysis.prompt.md) | `/root-cause-analysis` | Analyze logs and exceptions to identify root cause and propose permanent architectural fixes |

## Instruction files

Instruction contracts live under [instructions/](instructions). They are auto-routed by each file's `applyTo` pattern.

Core governance:
- [ai-customization.instructions.md](instructions/ai-customization.instructions.md)
- [spring-boot-architecture.instructions.md](instructions/spring-boot-architecture.instructions.md)

Spring Boot component contracts:
- [spring-boot-actuator.instructions.md](instructions/spring-boot-actuator.instructions.md)
- [spring-boot-api-versioning.instructions.md](instructions/spring-boot-api-versioning.instructions.md)
- [spring-boot-async-events.instructions.md](instructions/spring-boot-async-events.instructions.md)
- [spring-boot-config.instructions.md](instructions/spring-boot-config.instructions.md)
- [spring-boot-container.instructions.md](instructions/spring-boot-container.instructions.md)
- [spring-boot-controller.instructions.md](instructions/spring-boot-controller.instructions.md)
- [spring-boot-database-schema.instructions.md](instructions/spring-boot-database-schema.instructions.md)
- [spring-boot-dto-mapper.instructions.md](instructions/spring-boot-dto-mapper.instructions.md)
- [spring-boot-enum.instructions.md](instructions/spring-boot-enum.instructions.md)
- [spring-boot-error-code.instructions.md](instructions/spring-boot-error-code.instructions.md)
- [spring-boot-exception.instructions.md](instructions/spring-boot-exception.instructions.md)
- [spring-boot-gitignore.instructions.md](instructions/spring-boot-gitignore.instructions.md)
- [spring-boot-http-client.instructions.md](instructions/spring-boot-http-client.instructions.md)
- [spring-boot-i18n.instructions.md](instructions/spring-boot-i18n.instructions.md)
- [spring-boot-java-style.instructions.md](instructions/spring-boot-java-style.instructions.md)
- [spring-boot-logback.instructions.md](instructions/spring-boot-logback.instructions.md)
- [spring-boot-logging.instructions.md](instructions/spring-boot-logging.instructions.md)
- [spring-boot-observability.instructions.md](instructions/spring-boot-observability.instructions.md)
- [spring-boot-openapi.instructions.md](instructions/spring-boot-openapi.instructions.md)
- [spring-boot-pagination.instructions.md](instructions/spring-boot-pagination.instructions.md)
- [spring-boot-pom.instructions.md](instructions/spring-boot-pom.instructions.md)
- [spring-boot-readme.instructions.md](instructions/spring-boot-readme.instructions.md)
- [spring-boot-referential-integrity.instructions.md](instructions/spring-boot-referential-integrity.instructions.md)
- [spring-boot-repository.instructions.md](instructions/spring-boot-repository.instructions.md)
- [spring-boot-security.instructions.md](instructions/spring-boot-security.instructions.md)
- [spring-boot-service.instructions.md](instructions/spring-boot-service.instructions.md)
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
