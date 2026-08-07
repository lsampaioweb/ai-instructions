---
name: review-and-sync-docs
description: >-
  Correlate code and configuration changes with Markdown docs, then sync stale
  documentation in a controlled, plan-first pass. Use when the user asks to
  review, update, or sync docs after code changes, or invokes
  /review-and-sync-docs. Optional input: a scope, folder path, or feature-area filter.
disable-model-invocation: true
---

# Review And Sync Docs

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Plan first: present the update plan and get approval before editing any file.

## Scope & analysis

- Resolve the target scope from the user-provided scope, folder, or feature-area filter.
- If no scope is given, inspect uncommitted changes first (`git status`, `git diff`), then recent commits.
- Correlate code and configuration deltas with the Markdown files they affect.
- Base every conclusion on files that exist in scope. Never guess at behavior.

## Resolution rules

- Update Markdown only when a code or configuration change alters documented behavior or setup.
- Update a `*.md` file only when the mapped change affects onboarding, execution, or architecture.
- Match the existing formatting, structure, and voice of each doc.
- Repair stale instructions, outdated config keys, deprecated paths, broken links, and obsolete examples.
- Do not restructure or rewrite sections that the change does not touch.

## Plan layout

Present this plan before applying edits:

```
Synced Files:
- path/to/doc1.md

Structural Updates:
- <what changes and why>

Verification Points:
- <uncertainties requiring confirmation>
```

End the plan with: `Proceed with these documentation updates? [yes/no]`

## Safety guards

- Read-only until the user approves the plan.
- Never invent features, parameters, properties, or runtime behavior absent from the codebase.
- If an update cannot be verified with available code context, stop and ask focused questions before editing.
- After approval, edit only the docs in the approved plan, leave everything else unchanged, and report the result.
