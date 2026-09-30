---
name: prepare-commit-messages
description: >-
  Cluster uncommitted changes into logical, feature-scoped Conventional Commits
  and execute them after approval. Use when the user asks to commit, prepare
  commit messages, split changes into commits, or invoke /prepare-commit-messages.
  Optional scope: path or feature-area filter; omit to cluster all uncommitted
  changes. Do NOT use for push, rebase, amend of published commits, or force operations.
---

# Logical Git Commits

## Arguments

- Optional path or feature-scope filter.
- Omit the filter to cluster all uncommitted changes.

## 1. Inspect the Changes

1. Inspect uncommitted changes (`git status`, `git diff`).
2. Cluster files into atomic commits.

## 2. Resolution Rules

- **Sort order:** Commit foundational changes (config, schemas, and dependencies) before feature layers.
- **Grouping Boundary:** Group files strictly by feature domain (e.g., `auth`, `payment`).
- **Documentation Gate:** If Markdown documentation exists for changed code but contains no corresponding updates, flag the affected docs and recommend running `review-and-sync-docs` before proceeding.
- **Commit Format:** Use only Conventional Commits in this format: `type(scope): description`.
- **Scope Rule:** Use a feature domain or infrastructure area.
- **Description:** Write it in the imperative present tense, keep it to 50 characters or fewer, and do not end it with a period.
- **Body Rule:** Document the *why* and the *impact* only.
- **Footer Rule:** Append `Closes #123` or tracking IDs if detected in branch or context.
- **Post-approval:** Run `git add` and `git commit` sequentially for each cluster.

## 3. Safety Guards

- **Execution boundary:** Apply changes only after the user confirms the commit plan.
- **Ask for Confirmation:** Output: `Proceed with executing this automated commit sequence? [yes/no]`
- **Exit Code Check:** Confirm the exit code is 0 after each git commit before staging the next cluster.
- **Scope Discipline:** Never use technical-layer identifiers for grouping or as the commit scope.
- **Body Discipline:** Never list modified files or duplicate diff data in the commit body.
- **Domain Boundary:** If files in a cluster span more than one feature domain, flag the cluster and stop.
- **Type Discipline:** Use a recognized Conventional Commit type; do not invent a repository-specific type without documenting it as an allowed type.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope
- Target: <workspace or filtered scope>
- Mode: <read-only | apply-after-confirmation>

### Result
- Summary: <number of commit clusters>
- Documentation gate: CLEAR | PENDING SYNC

### Sequence
- S1 | Header: `type(scope): description` | Files: <path1; path2>
- S<N> | Header: `type(scope): description` | Files: <path...>

### Evidence
- Commit body blueprint: `Why this change is needed and its impact.`
- Documentation gap details: <none | item1; item2>

### Next Action
- <single minimal next step or `Proceed with executing this automated commit sequence? [yes/no]`>

### Verdict
- READY | NEEDS FIXES | BLOCKED
