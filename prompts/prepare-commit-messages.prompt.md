---
description: "Cluster uncommitted changes into feature-scoped Conventional Commits and execute only after approval."
argument-hint: "Optional: path or feature-scope filter."
---

# Logical Git Commit Engine

## 1. Scope & Analysis
1. Inspect uncommitted changes (`git status`, `git diff`).
2. Cluster files into atomic, reversible commits.
3. **Sort Order:** Foundational changes (config, schemas, deps) must be committed before feature layers.
4. **Grouping Boundary:** Group files strictly by **feature domain** (e.g., `auth`, `payment`). Grouping by technical layer is strictly prohibited.
5. **Documentation Gate:** If Markdown documentation exists for changed code but contains no corresponding updates, flag the affected docs and recommend running `review-and-sync-docs` before proceeding.

## 2. Resolution Rules
- **Commit Format:** Use Conventional Commits only: `type(scope): description`. Do not invent custom types.
- **Scope Rule:** Use a feature domain or infrastructure area. Do not use technical-layer identifiers.
- **Description Rule:** Imperative, present tense, max 50 characters, no trailing period.
- **Body Rule:** Document the *why* only. Do not list files or repeat diff content.
- **Footer Rule:** Append `Closes #123` or tracking IDs if detected in branch or context.
- **Safety Gate:** If a cluster contains mixed/unclear concerns, flag it for manual review.

## 3. Review Plan Layout
Present the proposed sequence as a read-only plan:
```
Commit N: <type(scope): description>

Files:
- path/to/file1
- path/to/file2

Message:
type(scope): description

Extended body if present.
```

## 4. Safety Guards
- **Execution Boundary:** Read-only analysis. Do not execute any Git commands until the commit plan is confirmed.
- **Fix Application Rule:** If authorized, apply only the approved commit clusters. Non-targeted changes remain uncommitted.
- **Ask for Confirmation:** Ask if the user wants to proceed with the proposed commit plan.
- **Confirmation Gate:** Stop and wait for explicit user confirmation before executing any Git commands.
- **Post-approval:** Run `git add` and `git commit` sequentially for each cluster. Verify success at each step.
