---
name: prepare-commit-messages
description: >-
  Cluster uncommitted changes into feature-scoped Conventional Commits, present
  a commit plan, and execute it only after explicit approval. Use when the user
  asks to prepare, organize, or plan commits, or invokes
  /prepare-commit-messages. Optional input: a path or feature-scope filter.
disable-model-invocation: true
---

# Prepare Commit Messages

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- If the user provides a path or feature-scope filter, limit analysis to that scope.

## Scope & analysis

- Inspect uncommitted changes with `git status` and `git diff`.
- Cluster files into atomic, reversible commits.
- Order commits so foundational changes (config, schemas, dependencies) precede feature layers.
- Group files strictly by feature domain (e.g. `auth`, `payment`); never group by technical layer.
- Documentation gate: if markdown documentation exists for changed code but lacks corresponding updates, flag the affected docs and recommend running `/review-and-sync-docs` before proceeding.

## Resolution rules

- Use Conventional Commits only: `type(scope): description`. Never invent custom types.
- Use a feature domain or infrastructure area as the scope; never a technical-layer identifier.
- Write the description in imperative present tense, max 50 characters, no trailing period.
- Write the body to document the *why* and the *impact* only; never list modified files or duplicate the diff.
- Append `Closes #123` or tracking IDs in the footer when detected in the branch name or context.
- Flag any cluster with mixed or unclear concerns for manual review.

## Commit plan layout

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
- **Details:** `none` when no documentation gaps are detected; otherwise list missing or unsynced documentation updates.

## Safety guards

- Read-only analysis: never execute state-changing Git commands (`git add`, `git commit`) before the plan is confirmed.
- End the plan with: `Proceed with executing this automated commit sequence? [yes/no]`
- Stop and wait for explicit user confirmation before executing any Git commands.
- After approval, run `git add` and `git commit` sequentially for each cluster; verify success at each step.
