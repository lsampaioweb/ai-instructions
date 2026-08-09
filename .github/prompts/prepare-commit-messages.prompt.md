---
description: "Use to cluster uncommitted changes into logical, feature-scoped Conventional Commits and execute after approval."
argument-hint: "Optional: path or feature-scope filter."
---

# Logical Git Commit Engine

## 1. Scope & Analysis
- Inspect uncommitted changes (`git status`, `git diff`).
- Cluster files into atomic commits.
- **Sort Order:** Foundational changes (config, schemas, deps) must be committed before feature layers.
- **Grouping Boundary:** Group files strictly by **feature domain** (e.g., `auth`, `payment`).
- **Documentation Gate:** If Markdown documentation exists for changed code but contains no corresponding updates, flag the affected docs and recommend running `review-and-sync-docs` before proceeding.

## 2. Resolution Rules
- **Commit Format:** Use Conventional Commits only: `type(scope): description`.
- **Scope Rule:** Use a feature domain or infrastructure area.
- **Description Rule:** Imperative present tense; max 50 characters; no trailing period.
- **Body Rule:** Document the *why* and the *impact* only.
- **Footer Rule:** Append `Closes #123` or tracking IDs if detected in branch or context.
- **Post-approval:** Run `git add` and `git commit` sequentially for each cluster.

## 3. Safety Guards

- **Execution Boundary:** Apply changes only after the commit plan is confirmed.
- **Ask for Confirmation:** Output: `Proceed with executing this automated commit sequence? [yes/no]`
- Confirm the exit code is 0 after each git commit before staging the next cluster.
- Never use technical-layer identifiers for grouping or as the commit scope.
- Never list modified files or duplicate diff data in the commit body.
- If files in a cluster span more than one feature domain, flag the cluster and stop.
- Never use commit types not defined by the Conventional Commits specification.

## 4. Review Plan Layout
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
