---
description: "Durable false-positive and approved-dismissal registry for code-vs-instruction reviews. Consumed by review-code-against-instructions."
applyTo: "**/.github/prompts/review-code-against-instructions.prompt.md, **/.github/instructions/review-suppressions.instructions.md"
---

# Review Suppressions Registry

## Rules
- Treat each Active Suppressions row with Status `active` and a future Expiry as a hard do-not-report match for `review-code-against-instructions`.
- Match suppressions by Path (exact file or glob) plus Rule (instruction file and bullet quote/anchor).
- Prefer narrowing the cited instruction or adding domain `## Approved Exception Handling` before adding a suppression row.
- Require ID, Path, Rule, Reason, Owner, Expiry (`YYYY-MM-DD`), and Status on every Active Suppressions row.
- Use Status values `active` or `expired` only.
- Expire rows on Expiry: set Status to `expired` and do not honor them.
- Keep IDs stable as `SUP-NNN` (zero-padded), never reuse an ID for a different dismissal.
- Record the user-confirmed reason; do not invent dismissals during a review.

## Active Suppressions

| ID | Path | Rule | Reason | Owner | Expiry | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| — | — | — | No active suppressions yet. Add a row after an explicit user dismissal. | — | — | — |

## Safety Guards
- Never invent suppressions during a review without explicit user confirmation.
- Never honor a row whose Expiry is in the past or whose Status is not `active`.
- Never use this registry alone to silence Critical security findings; require an Approved Exception in the owning domain instruction file.
- Never broaden a Path or Rule match beyond the user’s confirmed dismissal scope.
