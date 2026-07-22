---
description: "Add, update, or deduplicate content in markdown or plain text files. Understands file structure; checks for duplicates; suggests improved wording; directly edits and reports changes."
argument-hint: "#file:path/to/file and the new content to add"
---

1. Read and understand the file's structure, sections, headings, lists, patterns, and style conventions.
2. Search the file for matching or similar content. If found, compare versions and report the location with improved wording suggestions.
3. Respect file hierarchy. Match existing formatting exactly (spacing, indentation, capitalization). Place in the most contextually relevant section; suggest new section if needed.
4. Edit directly. Apply the change. Preserve overall style and structure. No accidental formatting changes.
5. Report. State whether content was ADDED | UPDATED | SKIPPED. Show location (section, line). Report duplicates and any grammar improvements made.

---

**Output:**
```
✓ ADDED | UPDATED | SKIPPED
Location: [Section] (line X)
Duplicates: [none | note] | Improvements: [none | list]
```
