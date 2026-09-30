---
name: root-cause-analysis
description: >-
  Analyze logs and exceptions, identify root causes, and apply permanent fixes.
  Use when the user pastes stack traces or error logs, asks why something failed,
  wants a permanent fix rather than a workaround, or invokes
  /root-cause-analysis. Requires error logs, stack traces, or terminal output.
  Do NOT invent speculative fixes when the cause is unverified.
---

# Root Cause and Permanent Fixes

## Arguments

- Required: error logs, stack traces, or terminal output.

## 1. Trace the Failure

1. **Trace analysis:** Parse the stack trace or log to isolate the originating line, class, and feature package.
2. **Context verification:** Check the active environment configuration, dependency manifests, or runtime properties when systemic context is missing.
3. **Diagnostics:** Run targeted checks, such as terminal commands or file searches, to verify framework behavior, documented defects, or version-specific edge cases.

## 2. Resolution Rules

- State the verified Root Cause and failure mechanism before writing or proposing any code modifications.
- Do not apply temporary workarounds.
- Do not bypass visibility modifiers.
- Do not suppress exceptions.
- Do not inject unapproved dependencies.
- Code fixes must adhere to packaging conventions and data-access patterns defined by the active project architecture.
- Code fixes must respect dependency boundaries and detected runtime version constraints.
- Correct broken interface contracts when they cause the failure.
- Align data schemas when schema mismatch causes the failure.
- Fix lifecycle and boundary violations when they cause the failure.

## 3. Safety Guards

- **Execution boundary:** Apply code fixes only after presenting the plan and receiving the user's explicit confirmation.
- **Safety Gate:** Never generate speculative code fixes when the root cause cannot be verified with high confidence.
- **Truncated/Ambiguous Logs:** If the log is truncated or missing critical details, stop and prompt for the specific missing block.
- **Fallback Output:** If unresolved, output:
  - List of attempted verification steps.
  - Precise technical uncertainties remaining.
  - The single next decisive diagnostic action for the developer to execute.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope
- Target: <error logs, stack traces, or terminal output>
- Mode: <read-only | apply-after-confirmation>

### Result
- Summary: <validated root cause and failure mechanism>

### Evidence
- Root cause evidence: <file path>:<line> | <log anchor>
- Impacted area: <class/file/package>
- Permanent fix plan: <structural correction>

### Unresolved Fallback (if unresolved)
- Attempted verification steps: <item1; item2>
- Remaining technical uncertainties: <item1; item2>
- Next decisive diagnostic action: <one action>

### Next Action
- <single minimal next step or `none`>

### Verdict
- READY | NEEDS FIXES | BLOCKED
