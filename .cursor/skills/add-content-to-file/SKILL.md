---
name: add-content-to-file
description: >-
  Add, update, or deduplicate content in a markdown or plain-text file while
  preserving its structure and formatting. Use when the user asks to insert or
  merge content into a specific file, or invokes /add-content-to-file. Requires
  a user-provided target file and the content to add.
disable-model-invocation: true
---

# Add Content To File Engine

- Obey `AGENTS.md` (project root).
- Require a target file and the content to add. If either is missing, stop and request it. Never invent scope.

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
- Place new content at the logically correct position within the target section; append at the end only when the new content belongs last.
- Preserve existing formatting exactly: spacing, indentation, capitalization.
- Do not introduce unrelated formatting changes.
- If duplicate content exists, update the existing content instead of adding a second copy.
- Correct only clear grammar errors (e.g., subject-verb agreement, missing articles).

## 3. Safety Guards

- Do not change non-targeted sections.
- Never rephrase sentences.

## 4. Review Plan Layout

- Report one status: `ADDED`, `UPDATED`, or `SKIPPED`.
- Report location by section and line.
- Report duplicate handling.
- Report wording improvements.
- Use `none` when no duplicates or improvements exist.
- Otherwise use a semicolon-separated list.

**Output:**
```
✓ ADDED | UPDATED | SKIPPED
Location: [Section] (line X)
Duplicates: [none | item1; item2] | Improvements: [none | item1; item2]
```
