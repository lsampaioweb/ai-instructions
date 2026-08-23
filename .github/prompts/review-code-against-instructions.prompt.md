---
description: "Use to audit code against active instruction files, flag violations, and surface missing coverage."
argument-hint: "Optional: target path, module, file, or glob; omit to audit the full workspace."
---

# Code Instruction Compliance Audit

## 1. Scope & Analysis
1. Load all instruction files from `.github/instructions/` applicable to the target scope.
2. Resolve the target scope from `{{$ARGUMENTS}}`. If missing, audit the full workspace.
3. Enumerate all code files in scope, sorted by path ascending.
4. Read each code file and check it against all applicable instructions.
5. If scope exceeds available context, process files in path order until context is exhausted, then set Verdict to CONTINUE and record the next unprocessed path.

## 2. Resolution Rules

### Violations
- Flag every place where code does not follow an explicit active instruction rule.
- Cite the exact instruction rule broken and include a file:line reference.
- Severity: Critical = security, data loss, or secret exposure. High = explicit rule break. Medium = non-security rule gap. Low = naming or style rule gap.
- Merge findings that share the same root cause into one entry.
- Do not infer stricter rules than the active instruction text explicitly supports.

### Missing Coverage
- Identify recurring code patterns that no active instruction governs.
- Propose one new instruction rule per uncovered pattern.
- Place proposed instruction files in `.github/instructions/`.

### Reporting
- State each problem briefly with one minimal fix.
- Base all conclusions on files that actually exist in scope.

## 3. Safety Guards
- **Execution Boundary:** Present all findings first. Apply fixes only after the user explicitly confirms which findings to act on.
- **Uncertainty Gate:** If context is insufficient to validate a finding, state the uncertainty explicitly and stop.

## 4. Output Schema
Use this exact markdown schema:

### Scope
- Target: <scope>
- Mode: <read-only | apply-after-confirmation>
- Instructions applied: <files that materially affected findings>

### Coverage
- Reviewed: <path1; path2; ... | all>
- Remaining: <path1; path2; ... | none>
- Continue from: <first remaining path | none>

### Result
- Summary: <top compliance outcome>

### Violations

#### [ID] - [SEVERITY] - [DESCRIPTION]
- File: <file path>:<line>
- Rule: <instruction-file>#<exact rule text>
- Fix: <one minimal action>

### Missing Coverage
- <none | item1; item2>

### Next Action
- <`none` | confirmed fixes to apply | Reply `Continue` to process remaining files (or re-run this prompt with `<Continue from path>` as the argument in a new session)>

### Verdict
- READY | NEEDS FIXES | CONTINUE
