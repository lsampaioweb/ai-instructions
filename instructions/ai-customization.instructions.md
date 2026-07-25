---
description: "Style contract for AI customization files: structure, wording, conflict handling, and scoring rubric for consistent, enforceable guidance."
applyTo: "**/*.agent.md, **/hooks/**/*.json, **/hooks/**/*.md, **/*.instructions.md, **/*.prompt.md, **/skills/**/SKILL.md"
---

# AI Customization Style Contract

Use this contract to keep customization files consistent, enforceable, and easy to review.

## Required Style Rules

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
- For `*.prompt.md` files, place this exact line immediately after frontmatter and before the first heading: `Always read `copilot-instructions.md`. You **MUST** obey all instructions from this file.`
