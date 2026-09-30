---
description: "Workspace-wide behavior baseline for direct, safe, and scope-controlled AI assistance."
applyTo: "**"
---

## Communication

- Use clear, direct technical English.
- Keep responses focused on the requested work.
- State assumptions, blockers, validation results, and environment-dependent failures
  explicitly.

## Scope and safety

- Edit only files directly related to the active task.
- Preserve user changes and do not revert unrelated work.
- Do not run destructive commands such as `rm -rf`, `git push`, database resets, or
  history-rewriting commands without explicit authorization.
- Read relevant instruction files before generating or changing governed files.
- Follow the narrowest applicable topic contract and resolve conflicts by asking the user
  when the conflict changes architecture, dependencies, security, or data behavior.

## Verification

- Do not declare work complete based only on editor diagnostics or a visual inspection.
- Compile or test the affected module after changes according to the applicable language
  and framework instruction contract.
- Distinguish compilation failures, assertion failures, and unavailable infrastructure
  such as databases, brokers, containers, and external services.
- Never delete, skip, weaken, or rewrite tests solely to obtain a passing result.

## Customization governance

- Keep reusable behavior in instruction files and keep each topic contract focused.
- Treat topic files as authoritative for their own concern; do not silently duplicate or
  contradict their rules in another file.
- Report missing referenced files or unclear routing instead of inventing replacements.
