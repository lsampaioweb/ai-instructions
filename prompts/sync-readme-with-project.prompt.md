---
description: "Update the main README.md with important project changes from code, config, and docs."
argument-hint: "Optional scope (e.g., last 5 commits, backend only, include breaking changes)."
tools: [vscode, execute, read, agent, edit, search, web, browser, todo]
---

Requirements:
- Inspect the current README.md in the workspace root first.
- Inspect uncommitted changes and recent commits to identify important additions or behavior changes.
- Include only user/maintainer-impacting changes; skip internal-only refactors.
- Keep existing README structure and writing style unless there is a clear documentation gap.
- Add missing sections only when needed.
- Update outdated sections instead of duplicating content.
- Keep the text concise, factual, and actionable.

Verification:
- Commands and paths are accurate.
- New environment variables, flags, endpoints, and setup steps are documented.
- Removed or deprecated behavior is no longer documented as active.
- README content is consistent with the current codebase.

At the end, provide:
1. A short summary of what was updated.
1. A list of assumptions or uncertain points that need user confirmation, if any.
1. Suggested follow-up edits, if any.
