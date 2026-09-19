---
description: "Authoring contract for instruction files: structure, wording, duplication control, section ordering, and conflict resolution."
applyTo: "**/*.agent.md, **/*.agents.md, **/*.instructions.md, **/*.prompt.md, **/copilot-instructions.md, **/skills/**/SKILL.md, **/hooks/**/*.json, **/hooks/**/*.md"
---

## Rules

### File metadata and discoverability
- Keep frontmatter discoverable: `description` must clearly state when the file is used.
- Keep prompt metadata explicit: include `argument-hint` when the file requires input.
- Use the most specific `applyTo` pattern that matches the target files without over-matching.
- Remove vague routing language that does not improve file selection.

### Writing style and structure
- Use directive language: write mandatory rules with imperative verbs.
- Keep optional behavior explicit: mark optional rules with an explicit optional tag.
- Keep one rule per bullet; each bullet must express one enforceable behavior.
- Split compound bullets into separate rules.
- Keep each section purpose-specific: the title and the rule scope must match.
- Move off-topic content into a dedicated section instead of mixing it into the governing rules.
- Minimize filler wording that does not change execution.
- Prefer shorter phrasing when it preserves the same meaning.
- Preserve technical literals exactly as written: commands, code, paths, URLs, identifiers, config keys, and versions must not be altered unless they are incorrect.

### Duplication and conflict handling
- Search for an existing rule before adding a new preference; merge or reference it instead of duplicating it.
- Add a rule only when it changes a default decision and does not duplicate an existing rule.
- Keep one canonical statement for each cross-cutting policy; secondary files must defer to it instead of copying rules.
- Name the canonical owner for a shared policy in the file that owns that domain; other files must defer to that owner instead of restating the policy.
- Search existing templates before creating a template; reference the existing template when it already contains the required canonical content.
- Create a new template only when no existing template contains the required canonical content.
- Use `## Reference` only to link instruction files or templates required by the current file; do not use it to describe sample provenance.
- Resolve contradictions explicitly by rewriting or by defining precedence.
- State each constraint once in the strongest clear polarity; do not restate a Rules bullet as its negation in Safety Guards or in the same bullet.
- Do not append `; never …` (or equivalent) inside a Rules bullet when that prohibition is already covered by the Must form or by Safety Guards.

### Rule ordering and section layout
- Use this canonical section order for engine instruction files when applicable: `## Dependencies`, `## Naming Conventions`, `## Rules`, `## Approved Exception Handling`, `## Safety Guards`, `## Reference`.
- Omit `## Scope & Analysis` and `## Review Plan Layout` from engine instruction files.
- Use `## Dependencies` only for real Maven/starter requirements or essential cross-topic deferrals; do not list files already covered by `applyTo` or an architecture registry entry.
- Omit `## Safety Guards` when it is empty; if present, each bullet must forbid a behavior not already implied by Rules (asymmetric / high-cost prohibitions only: irreversible operations, security footguns, common agent failure modes, scope-creep bans).
- Keep `## Approved Exception Handling` only when temporary exceptions are a first-class protocol for a domain; put design alternatives in Rules.
- Order rules within each section to match the top-to-bottom structure of the governed file.
- Place rules for elements that appear earlier in the target file before rules for elements that appear later.
- Keep section titles and content aligned; do not mix governance rules with implementation examples unless the file is explicitly a template.
- Keep durable false-positive dismissals for code-vs-instruction reviews in `.github/instructions/review-suppressions.instructions.md`; prefer narrowing the cited instruction or domain Approved Exception Handling before adding a suppression row.
- Require every Active Suppressions row to include stable `SUP-NNN` ID, Path, Rule citation, Reason, Owner, Expiry (`YYYY-MM-DD`), and Status (`active`|`expired`).

### Agent files
- List only the tools the agent role actually requires.
- Omit all other tools from the `tools` list.
- Write `description` to include trigger phrases that support subagent discovery.
- Include a `## Constraints` section in every agent file.
- Grant the `agent` tool only to orchestrator agents.
- Keep non-orchestrator agents from including the `agent` tool.
- Use the singular `.agent.md` suffix for discoverable custom agents.
