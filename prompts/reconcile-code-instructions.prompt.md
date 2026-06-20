---
description: "Reconcile drift between project code and AI customization files, in either direction."
argument-hint: "Mode + optional scope. Example: code-to-instructions samples/18-rabbitmq or instructions-to-code spring-boot-config.instructions.md"
tools: [vscode, execute, read, search, edit]
---

Supported modes:
1. `code-to-instructions`
1. `instructions-to-code`

Inputs:
1. Mode.
1. Optional scope: files, folders, or changed files only.

Mode behavior:
1. `code-to-instructions`: Review code changes first, identify what AI customization files failed to encode, then update relevant prompt, instruction, skill, or agent files.
1. `instructions-to-code`: Review AI customization files first, identify missing or non-compliant code, then update code to match instructions.

Workflow:
1. Inspect the requested scope first.
1. Identify the current source of truth based on the selected mode.
1. Find concrete drift, not stylistic preference.
1. Explain why the mismatch happened: missing rule, weak rule, conflicting rule, ignored rule, or code not aligned with an existing rule.
1. Preserve technical literals: code blocks, inline code, commands, paths, URLs, identifiers, annotation names, config keys, environment variables, versions, and dependency coordinates.
1. Derive changes from existing patterns, explicit user preferences, or repeated corrections; do not invent new project rules.
1. Avoid broad rewrites when a narrow correction is enough.

Edit policy:
1. For review-only requests: stop after analysis and proposed changes.
1. For approval-before-edit: stop after proposed changes and wait for "ok".
1. Otherwise: apply smallest justified edits in selected scope.
1. When both code and AI files need changes, change the true source of drift first, then align the other.

Guardrails:
1. Be direct when current instructions are weak, contradictory, or overly vague.
1. Do not compress safety-critical guidance if clarity would be reduced.
1. Keep changes consistent with existing repository conventions unless the user explicitly wants a convention change.
