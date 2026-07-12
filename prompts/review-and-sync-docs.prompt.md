---
description: "Analyzes code and configuration changes to synchronize Markdown documentation with current project behavior."
argument-hint: "Input: optional scope, folder path, or feature-area filter."
tools: [execute, read, agent, edit, search, web]
---

# Markdown Documentation Sync Engine

## 1. Scope & Analysis
1. Resolve the target scope from `{{$ARGUMENTS}}`.
2. **Fallback Scan:** If scope is omitted, inspect uncommitted workspace changes (`git status`, `git diff`) first, then evaluate recent commits.
3. Correlate code and configuration deltas with impacted Markdown targets.

## 2. Resolution Rules
- **Execution Target:** Update Markdown files only when active code or configuration changes alter their documented behavior or setup.
- **README Boundary:** Update `README.md` only when the mapped change affects onboarding, execution, or architecture statements.
- **Style Match:** Match existing doc formatting (headers, code blocks, lists) and voice (active, imperative).
- **Correction Protocol:** Repair stale instructions, outdated keys, deprecated paths, broken links, and obsolete examples.

## 3. Review Plan Layout
Present a read-only update plan before applying edits:
```
Synced Files:
- path/to/doc1.md

Structural Updates:
- <what changed and why>

Verification Points:
- <uncertainties requiring confirmation>
```

## 4. Safety Guards
- **Forbidden:** Do not invent features, parameters, properties, or runtime behavior absent from the codebase.
- **Uncertainty Gate:** If a documentation update cannot be verified with available code context, stop and ask focused questions before editing.
