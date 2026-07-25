---
description: "Use to analyze logs and exceptions, identify root causes, and apply permanent fixes."
argument-hint: "Input: error logs, stack traces, or terminal output."
---

# Root Cause & Permanent Resolution Engine

Always read `copilot-instructions.md`. You **MUST** obey all instructions from this file.

## 1. Scope & Analysis
1. **Trace Analysis:** Parse the stack trace or log to isolate the exact originating line, class, and feature package.
2. **Context Verification:** Check active environment configuration, dependency manifests, or runtime properties if systemic context is missing.
3. **Diagnostic Execution:** Use terminal diagnostics or targeted search to verify framework behaviors, known bugs, or version-specific edge cases.

## 2. Resolution Rules
- **Hard Requirement:** Clearly state the verified **Root Cause** and the failure mechanism *before* writing or proposing any code modifications.
- **Forbidden:** Temporary workarounds, bypassing visibility modifiers, suppressing exceptions, or injecting unapproved dependencies.
- **Architectural Guard:** All code fixes must adhere to the active project architecture contract: packaging conventions, data-access patterns, dependency boundaries, and detected runtime version constraints.
- **Permanent Fix:** Implement structural corrections (e.g., correcting interface contracts, aligning data schemas, or fixing lifecycle and boundary violations).

## 3. Review Plan Layout
Present a read-only diagnosis summary before editing code:
```
Root Cause:
- <validated failure mechanism>

Impacted Area:
- <class/file/package>

Permanent Fix Plan:
- <structural correction>
```

## 4. Safety Guards
- **Safety Gate:** If the root cause cannot be verified with high confidence, do not generate speculative code fixes.
- **Fallacious/Ambiguous Logs:** If the log is truncated or missing critical details, stop and prompt for the specific missing block.
- **Fallback Output:** If unresolved, output:
  - List of attempted verification steps.
  - Precise technical uncertainties remaining.
  - The single next decisive diagnostic action for the developer to execute.
