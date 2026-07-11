---
description: "Update the main README.md with important project changes from code, config, and docs."
argument-hint: "Optional scope (e.g., last 10 commits, backend only, include breaking changes)."
tools: [vscode, execute, read, edit, search, web, browser, todo]
---

Requirements:
- Inspect the current README.md in the workspace root first.
- Inspect uncommitted changes and recent commits to identify important additions or behavior changes (default: last 10 commits when scope is omitted).
- Include only user/maintainer-impacting changes; skip internal refactors.
- Preserve existing README structure and writing style; add or update sections only when necessary.
- Update outdated sections instead of duplicating content.
- Keep the text concise, factual, and actionable.
- Use a todo list only when the request requires more than 3 distinct README updates.

Verification Checklist:
- Commands and paths are accurate.
- New environment variables, flags, endpoints, and setup steps are documented.
- Removed or deprecated behavior is no longer documented as active.
- README content is consistent with the current codebase.

At the end, provide:
1. A short summary of what was updated.
1. A list of assumptions or uncertain points that need user confirmation, if any.
1. Suggested follow-up edits, if any.
