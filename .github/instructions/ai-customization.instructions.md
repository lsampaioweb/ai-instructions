---
description: "Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance."
applyTo: "**/*.agent.md, **/hooks/**/*.json, **/hooks/**/*.md, **/*.instructions.md, **/*.prompt.md, **/skills/**/SKILL.md, **/copilot-instructions.md"
---

# AI Customization Style Contract

## Rules

- Keep frontmatter discoverable: `description` must state when to use the file.
- Keep prompt frontmatter explicit: `argument-hint` must state required input.
- Remove routing noise: avoid vague descriptors that do not improve file selection.
- Use directive language: write mandatory rules with imperative verbs.
- Keep optional behavior explicit: mark optional rules with an explicit optional tag.
- Use one rule per bullet: each bullet must express one enforceable behavior.
- Split compound bullets: break combined requirements into separate rules.
- Keep sections purpose-specific: section title and rule scope must match.
- Move off-topic rules: relocate unrelated content to a dedicated section.
- Minimize low-signal wording: remove filler that does not change execution.
- Shorten verbose statements: keep the same meaning with fewer words.
- Preserve technical literals: do not alter commands, code, paths, URLs, identifiers, config keys, or versions unless incorrect.
- Resolve duplication deliberately: keep one canonical statement and reference it from secondary files.
- Resolve contradictions explicitly: define precedence or rewrite to remove conflict.
- State each constraint once in the strongest clear polarity; do not restate a Rules bullet as its negation in Safety Guards or in the same bullet.
- Do not append `; never …` (or equivalent) inside a Rules bullet when that prohibition is already covered by the Must form or by Safety Guards.
- Prefer one canonical file for cross-cutting policy; secondary files use a one-line deferral and must not copy the rule.
- Before adding a preference: search for an existing rule covering the decision; merge or reference instead of appending. Add a rule only when it changes a default decision and does not duplicate an existing rule.

### Instruction File Rules

- Set `applyTo` to the most specific glob pattern that covers the target files without over-matching.
- Use this canonical section order for engine instruction files: `## Dependencies` (if applicable), `## Naming Conventions` (if applicable), `## Rules`, `## Approved Exception Handling` (if applicable), `## Safety Guards` (if applicable).
- Omit `## Scope & Analysis` and `## Review Plan Layout` from engine instruction files.
- Use `## Dependencies` only for real Maven/starter requirements or essential cross-topic deferrals; do not list files already activated by `applyTo` or architecture intent references.
- Omit `## Safety Guards` when empty; if present, each bullet must forbid a behavior not already implied by Rules (asymmetric / high-cost prohibitions only: irreversible ops, security footguns, common agent failure modes, scope-creep bans).
- Keep `## Approved Exception Handling` only when temporary exceptions are a first-class protocol for that domain; put design alternatives in Rules.
- Order rules within each section to match the top-to-bottom structure of the governed file.
- Place rules about elements that appear earlier in the target file before rules about elements that appear later.

### Agent File Rules

- List in `tools` only what the agent role requires.
- Omit all other tools from `tools`.
- Write `description` to include specific trigger phrases that enable subagent discovery.
- Include a `## Constraints` section in every agent file.
- Include a rule in every agent's `## Constraints` section that prohibits using pre-trained knowledge for any decision not covered by an instruction file.
- Grant the `agent` tool only to orchestrator agents.
- Ensure non-orchestrator agents do not include the `agent` tool.
