---
description: "Reconcile drift between project code and AI customization files, in either direction."
argument-hint: "Mode + optional scope. Example: code-to-instructions samples/18-rabbitmq or instructions-to-code spring-boot-config.instructions.md"
tools: [vscode, execute, read, search, edit]
---

Reconcile drift between project code and AI customization files.

Supported modes:
1. `code-to-instructions`
1. `instructions-to-code`

Inputs:
1. Mode.
1. Optional scope: files, folders, or changed files only.
1. Optional focus: prompts, instructions, skills, agents, hooks, or specific code areas.
1. If mode is missing or invalid, stop and ask for a valid mode before analysis.
1. If scope is omitted, review the full relevant workspace for the selected mode.

Workflow:
1. Inspect the requested scope first.
1. Identify the current source of truth based on the selected mode.
1. Find concrete drift, not stylistic preference.
1. Explain why the mismatch happened: missing rule, weak rule, conflicting rule, ignored rule, or code not aligned with an existing rule.
1. Preserve technical literals: code blocks, inline code, commands, paths, URLs, identifiers, annotation names, config keys, environment variables, versions, and dependency coordinates.
1. Do not invent new project rules. Derive changes from existing patterns, explicit user preferences, or repeated corrections visible in the codebase.
1. Avoid broad rewrites when a narrow correction is enough.

Mode behavior:
1. `code-to-instructions`: review code changes first, identify what AI customization files failed to encode or emphasize, then update the relevant prompt, instruction, skill, or agent files. Example: repeated manual code pattern missing from instructions.
1. `instructions-to-code`: review relevant AI customization files first, identify missing or non-compliant code, then update code to match instructions. Example: instruction requires constructor injection, but code uses field injection.

Edit policy:
1. If the user asks for review only, stop after analysis and proposed changes.
1. If the user requests approval-before-edit, stop after proposed changes and wait for "ok".
1. Otherwise, apply the smallest justified edits in the selected scope.
1. When both code and AI files need changes, change the true source of drift first, then align the other side.

Output format:
1. Scope reviewed.
1. Mode used.
1. Findings.
1. Root cause of the drift.
1. Proposed changes.
1. Edits applied, if any.
1. Verification performed.
1. Remaining gaps or ambiguities.

Guardrails:
1. Be direct when current instructions are weak, contradictory, or overly vague.
1. Do not compress safety-critical guidance if clarity would be reduced.
1. Keep changes consistent with existing repository conventions unless the user explicitly wants a convention change.
