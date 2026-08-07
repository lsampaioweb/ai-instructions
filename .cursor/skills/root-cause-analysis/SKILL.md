---
name: root-cause-analysis
description: >-
  Diagnose the verified root cause of an error from logs or stack traces, then
  plan a permanent structural fix — never a workaround. Use when the user asks to
  debug, find the root cause of, or permanently fix a failure, or invokes
  /root-cause-analysis. Requires user-provided logs, stack traces, or terminal output.
disable-model-invocation: true
---

# Root Cause Analysis

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Require logs, a stack trace, or terminal output. If missing, stop and request it. Never invent it.
- Read-only until the diagnosis is presented and the user approves the fix.

## Scope & analysis

- Parse the stack trace or log to isolate the originating line, class, and feature package.
- Verify active environment config, dependency manifests, or runtime properties when systemic context is missing.
- Use targeted search or terminal diagnostics to confirm framework behavior, known bugs, or version-specific edge cases.

## Resolution rules

- State the verified root cause and failure mechanism before writing or proposing any code change.
- Never apply temporary workarounds, bypass visibility modifiers, suppress exceptions, or inject unapproved dependencies.
- Make every fix adhere to the active project architecture contract from `AGENTS.md` and any applicable project rules: packaging conventions, data-access patterns, dependency boundaries, and runtime version constraints.
- Implement structural corrections (e.g. fix interface contracts, align data schemas, or repair lifecycle and boundary violations).

## Diagnosis layout

Present this diagnosis before editing code:

```
Root Cause:
- <validated failure mechanism>

Impacted Area:
- <class/file/package>

Permanent Fix Plan:
- <structural correction>
```

End with: `Proceed with this fix? [yes/no]`

## Safety guards

- If the root cause cannot be verified with high confidence, do not generate speculative fixes.
- If the log is truncated or missing critical detail, stop and request the specific missing block.
- If unresolved, output: attempted verification steps, the precise remaining uncertainties, and the single next decisive diagnostic action for the developer.
