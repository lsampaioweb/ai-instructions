---
name: add-content-to-file
description: >-
  Add, update, or deduplicate content in a markdown or plain-text file while
  preserving its structure and formatting. Use when the user asks to insert or
  merge content into a specific file, or invokes /add-content-to-file. Requires
  a user-provided target file and the content to add.
disable-model-invocation: true
---

# Add Content To File

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Require a target file and the content to add. If either is missing, stop and request it. Never invent scope.

## Scope & analysis

- Read the target file in full.
- Identify structure: headings, sections, list patterns, and style conventions.
- Locate the exact heading match for the requested content.
- Locate the exact content match.
- If no exact match exists, locate near matches by heading-keyword overlap.

## Resolution rules

- Use one insertion target only.
- Prefer an exact heading match.
- If no exact heading match exists, use the nearest section by heading-keyword overlap.
- If no suitable section exists, propose a new section.
- Preserve existing formatting exactly: spacing, indentation, capitalization.
- Never introduce unrelated formatting changes.
- If duplicate content exists, update the existing content instead of adding a second copy.
- If grammar can improve without changing meaning, apply the improvement.

## Safety guards

- Never change non-targeted sections.
- Never alter formatting outside the selected insertion target.

## Output

Report one status and its location:

```
✓ ADDED | UPDATED | SKIPPED
Location: [Section] (line X)
Duplicates: [none | item1; item2] | Improvements: [none | item1; item2]
```

- Use `none` when no duplicates or improvements exist; otherwise use a semicolon-separated list.
