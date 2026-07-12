---
description: "Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance."
applyTo: "**/*.agent.md, **/hooks/**/*.json, **/hooks/**/*.md, **/*.instructions.md, **/*.prompt.md, **/skills/**/SKILL.md"
---

# AI Customization Style Contract

Use this contract to keep customization files consistent, enforceable, and easy to review.

## Priority Order

When rules conflict, apply this order:
1. Safety and security constraints
2. Explicit file-local constraints
3. Shared style contract constraints
4. General writing preferences

## Required Style Rules

1. Use directive language:
   - Prefer imperative statements ("Do X", "Do not Y").
   - Avoid soft language for mandatory behavior ("should", "might") unless intentionally optional.

2. One rule per bullet:
   - Each bullet must express one enforceable behavior.
   - Split combined rules into separate bullets.

3. Keep sections purpose-specific:
   - Section title must match the content purpose.
   - Move unrelated content to a dedicated section.

4. Minimize low-signal wording:
   - Remove filler that does not change execution.
   - Shorten long sentences when meaning can be preserved.

5. Preserve technical literals:
   - Do not alter commands, code snippets, paths, URLs, identifiers, config keys, or versions unless they are wrong.

6. Resolve cross-file duplication deliberately:
   - Keep one canonical statement when possible.
   - In secondary files, reference the canonical source instead of copy-pasting long text.

7. Resolve contradictions explicitly:
   - Conflicting instructions must include a clear precedence statement or be rewritten to remove conflict.

8. Keep frontmatter discoverable:
   - `description` must describe when to use the file.
   - `argument-hint` (for prompts) must describe required input.
   - Avoid vague descriptors that do not improve routing.

## Shared Terminology

Use these meanings across all customization files:
1. stable: does not change during runtime or within the same released version without explicit versioned migration.
2. deterministic: same input and state produce the same output and behavior.
3. explicit: represented in code, configuration, or documentation as a concrete literal, rule, or mapping.
4. aligned: code, configuration, tests, and docs reflect the same contract intent.

## Review Rubric (0-10)

Score each file using five dimensions:
1. Clarity (0-2)
2. Enforceability (0-2)
3. Consistency with related files (0-2)
4. Brevity without meaning loss (0-2)
5. Conflict-free behavior (0-2)

Interpretation:
- 9-10: Accept
- 7-8: Needs light edits
- 0-6: Needs rewrite

## Severity Mapping

Use this mapping during reviews:
- Critical: Safety risk, destructive ambiguity, or direct contradiction in mandatory behavior
- High: Strong conflict or missing enforceable constraints likely to cause wrong execution
- Medium: Duplication, weak wording, or structure drift that reduces reliability
- Low: Minor style inconsistency with low behavioral impact

## Non-Goals

Do not rewrite for personal taste only.
Do not expand text unless expansion adds enforceable clarity.
Do not reduce safety wording when brevity would reduce clarity.
