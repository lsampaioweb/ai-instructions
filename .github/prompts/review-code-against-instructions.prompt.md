---
description: "Use to audit code against active instruction files and identify governance gaps in both directions."
argument-hint: "Optional: target path, module, file, or glob to audit."
---

# Review Code And Instruction Coverage

## 1. Scope & Analysis
1. Resolve the target scope from `{{$ARGUMENTS}}`. If missing, audit the full workspace.
2. Identify all applicable instruction files for the target scope.
3. Establish active cross-references between code files and instruction rules.

## 2. Resolution Rules
- **Bidirectional Audit:** Check code against instruction files; check instruction files against code.
- **Code Violations:** Flag places where the implementation does not follow the active rules.
- **Instruction Gaps:** Flag recurring code patterns, missing constraints, or missing governance that should be added.
- **Coverage Absence:** If no instruction files exist for the target scope, infer the minimum enforceable initial set from the code and propose it.
- **New File Placement:** Place proposed instruction files in `.github/instructions/*`.
- **Evidence Rule:** Base all conclusions on files that actually exist in scope. Do not guess.
- **Scanning Rigor:** Scan the full target scope. Do not sample.
- **Finding Format:** For each finding, state the problem briefly and give one minimal remediation action.
- **Classification:** Distinguish required violations, optional gaps, and ambiguous cases.
- **Coverage Gate:** Treat missing required instruction coverage as a problem.

## 3. Safety Guards
- **Execution Boundary:** Read-only audit. Do not edit files until the user explicitly asks to apply changes.
- **Uncertainty Gate:** If context is insufficient to validate a finding, state uncertainty explicitly and stop.

## 4. Review Plan Layout

Default output:

1. Scope reviewed
2. Code violating instructions
   - Group by category; sort by severity High to Low within each group.
   - Required violations
   - Optional gaps
   - Ambiguous cases
3. Instructions missing code rules
4. Instruction files to create, update, retain, or delete
5. Final verdict: `READY` or `NEEDS FIXES`

For each finding include:
- File path and line reference when available
- Brief problem statement
- One minimal remediation action
