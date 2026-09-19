---
description: "Use to add, update, or deduplicate content in markdown or plain text files."
argument-hint: "Required: #file:path/to/file and the new content to add"
---

# Add Content To File Engine

## 1. Scope & Analysis
1. Read the target file.
2. Identify structure: headings, sections, list patterns, and style conventions.
3. Find exact heading matches for the requested content.
4. Find exact content matches.
5. If no exact match exists, find near matches by heading-keyword overlap.

## 2. Resolution Rules
- Use one insertion target only.
- Prefer exact heading match.
- If no exact heading match exists, use the nearest section by heading-keyword overlap.
- If no suitable section exists, propose a new section.
- Place new content at the logically correct position within the target section.
- Append at the end of the section only when the new content belongs last.
- Preserve existing formatting exactly: spacing, indentation, capitalization.
- Do not introduce unrelated formatting changes.
- If duplicate content exists, update the existing content instead of adding a second copy.
- Correct only clear grammar errors (e.g., subject-verb agreement, missing articles).

## 3. Safety Guards
- **Execution Boundary:** Apply the file edit only after the plan is presented and the user explicitly confirms.
- **No Rephrasing:** Never rephrase sentences.
- **Grammar Scope:** Limit grammar corrections to those described in the Resolution Rules.

## 4. Review Plan Layout
Use this exact markdown schema:

### Scope
- Target: <file path>
- Mode: <read-only | apply-after-confirmation>

### Result
- Summary: <ADDED | UPDATED | SKIPPED>

### Evidence
- <file path>:<line> - <location and what changed>
- Duplicates: <none | item1; item2>
- Improvements: <none | item1; item2>

### Next Action
- <single minimal next step or `none`>

### Verdict
- READY | NEEDS FIXES | BLOCKED
