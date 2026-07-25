---
description: "Cluster uncommitted changes into feature-scoped Conventional Commits and execute only after approval."
argument-hint: "Optional: path or feature-scope filter."
---

# Logical Git Commit Engine

Always read `copilot-instructions.md`. You **MUST** obey all instructions from this file.

## 1. Scope & Analysis
- Inspect uncommitted changes (`git status`, `git diff`).
- Cluster files into atomic, reversible commits.
- **Sort Order:** Foundational changes (config, schemas, deps) must be committed before feature layers.
- **Grouping Boundary:** Group files strictly by **feature domain** (e.g., `auth`, `payment`). Grouping by technical layer is strictly prohibited.
- **Documentation Gate:** If Markdown documentation exists for changed code but contains no corresponding updates, flag the affected docs and recommend running `review-and-sync-docs` before proceeding.

## 2. Resolution Rules
- **Commit Format:** Use Conventional Commits only: `type(scope): description`. Do not invent custom types.
- **Scope Rule:** Use a feature domain or infrastructure area. Do not use technical-layer identifiers.
- **Description Rule:** Imperative, present tense, max 50 characters, no trailing period.
- **Body Rule:** Document the *why* and the *impact* only. Do not list modified files or duplicate the diff data.
- **Footer Rule:** Append `Closes #123` or tracking IDs if detected in branch or context.
- **Safety Gate:** If a cluster contains mixed/unclear concerns, flag it for manual review.

## 3. Review Plan Layout
Output this plan layout:

### Proposed Commit Sequence Plan

---

### Commit [N]: `type(scope): description`

- **Target Files to Stage:**
  - `path/to/file1`
  - `path/to/file2`
- **Execution Message Blueprint:**
  ```gitcommit
  type(scope): description

  Why this change is needed and its impact.
  ```

---

### Documentation Gate Verification

- **Status:** [CLEAR | PENDING SYNC]
- **Details:** <State "none" if no documentation gaps are detected; otherwise list missing or unsynced documentation updates>

## 4. Safety Guards

- **Execution Boundary:** Read-only analysis. Do not execute any Git commands until the commit plan is confirmed.
- **Ask for Confirmation:** Output: `Proceed with executing this automated commit sequence? [yes/no]`
- **Confirmation Gate:** Stop and wait for explicit user confirmation before executing any Git commands.
- **Post-approval:** Run `git add` and `git commit` sequentially for each cluster. Verify success at each step.
