---
name: clean-slate-workspace
description: >-
  Remove only artifacts created in the current chat so the workspace can restart
  cleanly. Use when the user asks for a clean slate, cleanup of chat-created
  files, or invokes /clean-slate-workspace. Optional: scope notes or exclusions.
disable-model-invocation: true
---

# Clean Slate Workspace Engine

- Obey `AGENTS.md` (project root).
- Never delete user-authored files or ambiguous-ownership artifacts without treating them as user-authored.

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
- If no session-created artifacts exist, state that explicitly and stop without performing any deletions.

## 3. Review Plan Layout

- Report what was deleted.
- Report what was intentionally preserved.
- Report uncertainties or leftovers requiring manual review.
