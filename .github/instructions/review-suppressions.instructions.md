---
description: "Durable false-positive and approved-dismissal registry for code-vs-instruction reviews. Consumed by review-code-against-instructions."
applyTo: "**/.github/prompts/review-code-against-instructions.prompt.md, **/.github/instructions/review-suppressions.instructions.md"
---

## Rules
- Treat this file as the durable registry of approved review-finding suppressions.
- Add a row only after the user explicitly approves dismissing a specific finding as a false positive or an accepted exception.
- Require every Active Suppressions row to include a stable `SUP-NNN` ID, Path, Rule citation, Reason, Owner, Expiry (`YYYY-MM-DD`), and Status (`active`|`expired`).
- Prefer narrowing the cited instruction or its domain `## Approved Exception Handling` section before adding a new suppression row.
- Mark a row `expired` once its Expiry date passes; do not delete expired rows without user confirmation.

## Active Suppressions

| ID | Path | Rule | Reason | Owner | Expiry | Status |
|----|------|------|--------|-------|--------|--------|
| _none yet_ | | | | | | |
