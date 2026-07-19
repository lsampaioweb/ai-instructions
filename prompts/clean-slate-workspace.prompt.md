---
description: "Remove only the current chat's created artifacts from the active workspace so a new session can start clean"
argument-hint: "Optional scope notes or exclusions"
---

Reset the current workspace to a clean slate for a new chat session.

Requirements:
- Inspect the current conversation history and list all files, plans, repo memory, session memory, and temporary artifacts created by you in this chat for the active workspace.
- Do not delete any artifact until the inspection step is complete and all targets are listed.
- Delete only artifacts that you created.
- Do not delete or modify user-authored files. Treat ambiguous ownership as user-authored.
- Do not touch persistent user-level memories or reusable customizations unless they were created specifically for this workspace in the current chat.
- Remove empty directories left behind by those deletions.
- Verify the workspace is clean afterward.

Return a concise report with:
- What you deleted.
- What you intentionally preserved.
- Any uncertainty or leftovers that need manual review.
- If no session-created artifacts exist, state that explicitly and stop.
