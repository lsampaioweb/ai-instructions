---
description: "Review and improve AI customization files for clarity and token efficiency without changing meaning."
argument-hint: "Optional scope, folder, or file list."
tools: [vscode, read, search, edit, execute]
---

Review selected AI customization files (prompts, skills, instructions, agents, hooks) using these rules:

1. Read all target files first for style and consistency context.
2. Process files one by one in alphabetical order.
3. Do not edit any file before approval.
4. Reduce token waste without changing meaning.
5. Use non-aggressive edits: optimize tokens, but do not over-compress or rewrite style unnecessarily.
6. Remove filler, redundancy, and duplicated meaning.
7. Prefer concise bullet points over long prose when appropriate.
8. Preserve explicit user preferences, even when they differ from common conventions.
9. Label optional polish as optional.
10. After each file review, stop and wait for "ok" before moving to the next file.
11. After reviewing all files, run a cross-file drift check: verify that rules shared across multiple files (e.g., constructor injection, deny-by-default, no hardcoded secrets) are still consistent. Report any rule that exists in one file but is weakened, or contradicted in another.
12. During token optimization, never alter technical literals: code blocks, inline code, commands, file paths, URLs, identifiers, annotation names, config keys, environment variable names, versions, and dependency coordinates.
13. For security, secrets handling, destructive operations, or irreversible actions, prioritize full clarity over terseness; do not compress wording if compression could reduce safety.

For each file, output:
1. Findings: filler, redundancy, or correctness issues.
2. Proposed changes: minimal edits, same meaning.
3. Optional improvements: only if high value.
4. Decision checkpoint: wait for approval before editing.
5. If approved, apply edits and show patch summary.
