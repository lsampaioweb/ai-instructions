---
description: "Use to add, update, or deduplicate content in markdown or plain text files."
argument-hint: "#file:path/to/file and the new content to add"
---

# Add Content To File Engine

Always read `copilot-instructions.md`. You **MUST** obey all instructions from this file.

## 1. Scope & Analysis
- Read the target file.
- Identify structure: headings, sections, list patterns, and style conventions.
- Find exact heading matches for the requested content.
- Find exact content matches.
- If no exact match exists, find near matches by heading-keyword overlap.

## 2. Resolution Rules
- Use one insertion target only.
- Prefer exact heading match.
- If no exact heading match exists, use the nearest section by heading-keyword overlap.
- If no suitable section exists, propose a new section.
- Preserve existing formatting exactly: spacing, indentation, capitalization.
- Do not introduce unrelated formatting changes.
- If duplicate content exists, update the existing content instead of adding a second copy.
- If grammar can be improved without changing meaning, apply the improvement.

## 3. Review Plan Layout
- Report one status: `ADDED`, `UPDATED`, or `SKIPPED`.
- Report location by section and line.
- Report duplicate handling.
- Report wording improvements.
- Use `none` when no duplicates or improvements exist.
- Otherwise use a semicolon-separated list.

## 4. Safety Guards
- Do not change non-targeted sections.
- Do not alter formatting outside the selected insertion target.

---

**Output:**
```
✓ ADDED | UPDATED | SKIPPED
Location: [Section] (line X)
Duplicates: [none | item1; item2] | Improvements: [none | item1; item2]
```
