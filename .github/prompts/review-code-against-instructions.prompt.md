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
- Check code against all applicable instruction files.
- Check all applicable instruction files against the code.
- **Code Violations:** Flag places where the implementation does not follow the active rules.
- **Instruction Gaps:** Flag recurring code patterns, missing constraints, or missing governance that should be added.
- **Coverage Absence:** If no instruction files exist for the target scope, infer the minimum enforceable initial set from the code and propose it.
- **New File Placement:** Place proposed instruction files in `.github/instructions/*`.
- **Evidence Rule:** Base all conclusions on files that actually exist in scope.
- **Scanning Rigor:** Scan the full target scope.
- **Finding Format:** For each finding, state the problem briefly and include one minimal remediation action.
- **Coverage Gate:** Report missing required instruction coverage under Required Violations.
- **Deduplication Rule:** Merge repeated observations that share the same root cause into one finding.
- **Compression Rule:** Do not list compliant files, retained instruction files, or exhaustive instruction inventories unless they are necessary to explain a finding.
- **Reference Precision:** Include line references when they are available without guesswork.

## 3. Safety Guards
- **Execution Boundary:** Apply changes only after explicit user confirmation.
- **Uncertainty Gate:** If context is insufficient to validate a finding, state uncertainty explicitly and stop.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope
- **Target:** <scope>
- **Audit mode:** <full workspace|targeted>
- **Instructions applied:** <only the instruction files that materially affected findings>

### Required Violations
- **[id] - [High|Medium|Low]** <brief problem statement>
   - **Rule:** <instruction file or rule name>
   - **Evidence:** <file path and line reference>
   - **Minimal remediation:** <one minimal action>

### Optional Gaps
- **[id] - [Low|Medium]** <brief problem statement>
   - **Rule:** <instruction file or coverage area>
   - **Evidence:** <file path and line reference>
   - **Minimal remediation:** <one minimal action>

### Ambiguous Cases
- **[id] - [Ambiguous]** <brief uncertainty statement>
   - **Evidence:** <file path and line reference>
   - **Next check:** <one minimal validation step>

### Instruction Coverage Gaps
- **<instruction file or coverage area>**
   - **Missing rule:** <brief gap statement>
   - **Evidence:** <file path and line reference>
   - **Minimal remediation:** <one minimal action>

### File Actions
- **Update:** <path> - <brief reason>
- **Create:** <path> - <brief reason>
- **Delete:** <path> - <brief reason>

### Verdict
- **READY** or **NEEDS FIXES**
- **Reason:** <one-sentence rationale>
