---
name: clean-slate-workspace
description: >-
  Remove only this chat's created artifacts from the active workspace for a
  clean restart. Use when the user asks to clean the slate, remove session
  artifacts, or invokes /clean-slate-workspace. Optional: scope notes or
  exclusions.
disable-model-invocation: true
---

# Clean Slate Workspace

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Read-only until the user explicitly confirms deletion.
- Optional: honor user-provided scope notes or exclusions.

## Scope & analysis

1. Inspect conversation artifacts in the active workspace.
2. List all files, plans, repo memory, session memory, and temporary artifacts created in this chat.
3. Determine ownership for each artifact.
4. If no session-created artifacts exist, state that explicitly and stop.

## Resolution rules

- Never delete until inspection is complete and targets are listed.
- Ask for explicit confirmation before deletion.
- Delete only artifacts created in this chat.
- Treat ambiguous ownership as user-authored.
- Never delete or modify user-authored files.
- Never touch persistent user-level memories or reusable customizations unless they were created for this workspace in this chat.
- Remove empty directories left by deletions.
- Verify workspace cleanliness after deletion.

## Output

After the confirmed cleanup (or a no-op stop), report:

- **Deleted:** paths removed
- **Preserved:** paths intentionally kept
- **Uncertainties:** leftovers needing manual review (or `none`)
