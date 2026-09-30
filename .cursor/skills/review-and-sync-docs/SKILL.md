---
name: review-and-sync-docs
description: >-
  Keep Markdown documentation aligned with current code and configuration
  behavior. Use when the user asks to sync docs, update README after code
  changes, fix stale documentation, or invoke /review-and-sync-docs. Optional
  scope: folder path or feature-area filter; omit to sync from uncommitted
  changes then recent commits. Do NOT invent undocumented features or edit docs
  without confirmation.
---

# Markdown Documentation Sync

## Arguments

- Optional scope, folder path, or feature-area filter.
- Omit the filter to sync from uncommitted changes, then recent commits.

## 1. Define the Scope

1. Resolve the target scope from the user-provided arguments when present.
2. **Fallback Scan:** If scope is omitted, inspect uncommitted workspace changes (`git status`, `git diff`) first, then evaluate commits made after the latest commit whose subject starts with `docs:`; if no such baseline exists, evaluate the latest 10 commits.
3. Correlate code and configuration deltas with impacted Markdown targets.

## 2. Resolution Rules

- **What to update:** Update `*.md` only when code or configuration changes alter documented onboarding, execution, or architecture behavior.
- **Match the existing style:** Follow the current formatting, heading style, and list conventions.
- **Content corrections:** Repair stale instructions, outdated keys, and deprecated paths.
- **Reference corrections:** Resolve broken links and replace obsolete examples.

## 3. Safety Guards

- **Execution Boundary:** Apply Markdown edits only after the read-only plan is presented and the user explicitly confirms.
- **Fabrication Guard:** Never invent features, parameters, properties, or runtime behavior absent from the codebase.
- **Uncertainty Gate:** If a documentation update cannot be verified with available code context, stop and ask focused questions before editing.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope
- Target: <scope>
- Mode: <read-only | apply-after-confirmation>

### Result
- Summary: <synced files and primary update outcome>

### Evidence
- Synced files: <none | path1; path2>
- Structural updates: <none | item1; item2>
- Verification points: <none | item1; item2>

### Next Action
- <single minimal next step or `none`>

### Verdict
- READY | NEEDS FIXES | BLOCKED
