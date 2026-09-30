---
description: "Authoring and review contract for AI customization files, including agents, instructions, prompts, skills, hooks, and workspace guidance."
applyTo: "**/*.agent.md, **/*.agents.md, **/*.instructions.md, **/*.prompt.md, **/copilot-instructions.md, **/skills/**/SKILL.md, **/hooks/**/*.json"
---

# AI Customization Contract

## Dependencies

- Read the workspace's `copilot-instructions.md` before creating or changing an AI customization file.
- Read the applicable domain instruction files before editing a file that they govern.
- Treat a missing required instruction, reference, or template as a blocker. Do not silently bypass it or invent a substitute.

## Scope and ownership

- Keep workspace-wide behavior in `copilot-instructions.md`.
- Keep reusable authoring and review rules for AI customization files in this contract.
- Keep topic-specific implementation rules in the narrowest applicable instruction file.
- Keep one canonical owner for each shared policy. Reference that owner instead of duplicating the policy in other files.
- Limit each file to the behavior implied by its name, description, and routing pattern.

## Metadata and routing

- Give every customization file the metadata required by its file type.
- Write `description` so the file's purpose and trigger conditions are discoverable.
- Add `argument-hint` when a prompt requires user-provided input.
- Use the narrowest `applyTo` pattern that covers the intended files without accidental matches.
- Check routing patterns for overlap with existing files before adding or changing them.
- Preserve technical literals exactly, including paths, commands, URLs, identifiers, configuration keys, and versions, unless they are demonstrably incorrect.

## Authoring rules

- Use direct, imperative language for mandatory behavior.
- Mark optional behavior explicitly as optional.
- Keep one enforceable behavior per rule or bullet.
- Split compound rules when they contain independent decisions or conditions.
- Keep each section focused on one purpose, with a heading that matches its contents.
- Put rules in the order the governed workflow encounters them.
- Remove filler only when doing so preserves the rule's meaning and enforceability.
- Preserve existing behavior when improving wording unless the user explicitly approves a behavior change.
- Do not turn a style preference or optional rewrite into a defect, requirement, or safety rule.

## Duplication and conflict control

- Search for an existing rule before adding a new one.
- Add a rule only when it changes a default decision or closes a real gap.
- Do not restate the same policy as both a positive rule and its negative form.
- Resolve contradictions explicitly by rewriting the rule or defining precedence.
- When files disagree, identify the canonical owner and update references rather than silently choosing a winner.
- Search existing templates before creating a new template.
- Use references for required canonical content instead of copying large examples into multiple files.
- Keep review findings tied to concrete behavior, routing, enforceability, correctness, safety, duplication, contradiction, or material clarity.
- Do not report wording preferences, optional rewrites, or alternative styles as problems.

## Review and change safety

- Review the complete target file before proposing a change.
- Show proposed wording or behavior changes and wait for approval when the user requests review before editing.
- After an approved change, verify that the file's original meaning and governing behavior remain intact.
- Do not modify unrelated customization files or silently repair adjacent issues.
- Do not create, update, or delete a review ledger without explicit authorization.
- If a required dependency is missing, report the blocker and ask whether to create, restore, remove, or replace it. Do not add a workaround without approval.

## Agent-specific rules

- List only the tools the agent role actually requires.
- Include a `## Constraints` section in every custom agent file.
- Grant the `agent` tool only to orchestrator agents.
- Use the singular `.agent.md` suffix for discoverable custom agents.

## References

- Use the workspace `copilot-instructions.md` for universal interaction, safety, and workflow rules.
- Use the review prompt's ledger and convergence rules when auditing customization files across multiple runs.
