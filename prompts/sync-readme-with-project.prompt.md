---
description: "Update the main README.md with important project changes from code, config, and docs."
argument-hint: "Optional scope, for example: only last 5 commits, only backend changes, or include breaking changes section"
tools: [vscode, execute, read, agent, edit, search, web, browser, todo]
---

Update the main README.md in the workspace root so it reflects the current project state.

Requirements:
- Inspect the current README.md first.
- Inspect uncommitted changes and recent commits to identify important additions or behavior changes.
- Include only meaningful changes for users and maintainers, not internal refactors with no external impact.
- Keep existing README structure and writing style unless there is a clear documentation gap.
- Add missing sections only when needed.
- If an existing section is outdated, update it instead of duplicating content.
- Keep the text concise, factual, and actionable.

Verification checklist before finishing:
- Commands and paths are accurate.
- New environment variables, flags, endpoints, and setup steps are documented.
- Removed or deprecated behavior is no longer documented as active.
- README content is consistent with the current codebase.

At the end, provide:
1. A short summary of what was updated.
2. A list of assumptions or uncertain points that need user confirmation.
3. Suggested follow-up edits, if any.
