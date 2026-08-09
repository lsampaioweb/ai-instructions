---
name: prepare-commit-messages
description: >-
  Cluster uncommitted changes into feature-scoped Conventional Commits, present
  a commit plan, and execute it only after explicit approval. Use when the user
  asks to prepare, organize, or plan commits, or invokes
  /prepare-commit-messages. Optional input: a path or feature-scope filter.
disable-model-invocation: true
---

# Logical Git Commit Engine

- Obey `AGENTS.md` (project root).
- If the user provides a path or feature-scope filter, limit analysis to that scope.

## 1. Scope & Analysis

- Inspect uncommitted changes (`git status`, `git diff`).
- Cluster files into atomic, reversible commits.
- **Sort Order:** Foundational changes (config, schemas, deps) must be committed before feature layers.
- **Grouping Boundary:** Group files strictly by **feature domain** (e.g., `auth`, `payment`).
- **Documentation Gate:** If Markdown documentation exists for changed code but contains no corresponding updates, flag the affected docs and recommend running `/review-and-sync-docs` before proceeding.

## 2. Resolution Rules

- **Commit Format:** Use Conventional Commits only: `type(scope): description`.
- **Scope Rule:** Use a feature domain or infrastructure area.
- **Description Rule:** Imperative, present tense, max 50 characters, no trailing period.
- **Body Rule:** Document the *why* and the *impact* only.
- **Footer Rule:** Append `Closes #123` or tracking IDs if detected in branch or context.

## 3. Safety Guards

- **Execution Boundary:** Read-only analysis. Do not execute any Git commands until the commit plan is confirmed.
- **Ask for Confirmation:** Output: `Proceed with executing this automated commit sequence? [yes/no]`
- **Post-approval:** Run `git add` and `git commit` sequentially for each cluster.
- Verify success after each commit before proceeding to the next cluster.
- Never group files by technical layer; group strictly by feature domain.
- Never use technical-layer identifiers as the commit scope.
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
