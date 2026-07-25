---
description: "Use to remove only this chat's created artifacts from the active workspace for a clean restart."
argument-hint: "Optional scope notes or exclusions"
---

# Clean Slate Workspace Engine

Always read `copilot-instructions.md`. You **MUST** obey all instructions from this file.

## 1. Scope & Analysis
- Inspect current conversation artifacts in the active workspace.
- List all files, plans, repo memory, session memory, and temporary artifacts created in this chat.
- Determine ownership for each artifact.

## 2. Resolution Rules
- Do not delete anything until inspection is complete and targets are listed.
- Ask for explicit confirmation before deletion.
- Delete only artifacts created in this chat.
- Treat ambiguous ownership as user-authored.
- Do not delete or modify user-authored files.
- Do not touch persistent user-level memories or reusable customizations unless they were created for this workspace in this chat.
- Remove empty directories left by deletions.
- Verify workspace cleanliness after deletion.
- If no session-created artifacts exist, state that explicitly and stop.

## 3. Review Plan Layout
- Report what was deleted.
- Report what was intentionally preserved.
- Report uncertainties or leftovers requiring manual review.

## 4. Safety Guards
- Read-only until explicit confirmation to delete.
- Do not mutate non-targeted artifacts.
