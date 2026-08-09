---
name: review-code-against-instructions
description: >-
  Bidirectional audit of code against instruction/rule overlays and overlay
  coverage against the codebase. Use when the user asks to review code against
  instructions, check instruction coverage, or invokes
  /review-code-against-instructions. Optional: target path, module, file, or
  glob.
disable-model-invocation: true
---

# Review Code And Instruction Coverage

- Obey `AGENTS.md` (project root).
- Prefer architecture guidance from `.cursor/rules/spring-boot-architecture.mdc` when present.
- Read-only audit; edit only user-approved items after explicit approval.

## 1. Scope & Analysis

1. Resolve the target scope from the user-provided input. If missing, confirm a full-repo scan with the user before proceeding. Never invent a narrow scope.
2. Identify all applicable rules/overlays for the target scope.
3. Establish active cross-references between code files and overlay rules.

## 2. Resolution Rules

- **Bidirectional Audit:** Check code against rules/overlays; check rules/overlays against code.
- **Code Violations:** Flag places where the implementation does not follow the active rules.
- **Overlay Gaps:** Flag recurring code patterns, missing constraints, or missing governance that should be added.
- **Coverage Absence:** If no rules/overlays exist for the target scope, infer the minimum enforceable initial set from the code and propose it.
- **New File Placement:** Place proposed Cursor rules in `.cursor/rules/*.mdc` (not `.github/instructions/`).
- **Optional Source Evidence:** Also read `.github/instructions/*.instructions.md` as Copilot-source evidence when auditing.
- **Evidence Rule:** Base all conclusions on files that actually exist in scope. Do not guess.
- **Scanning Rigor:** Scan the full target scope. Do not sample.
- **Finding Format:** For each finding, state the problem briefly and give one minimal remediation action.
- **Classification:** Distinguish required violations, optional gaps, and ambiguous cases.
- **Coverage Gate:** Treat missing required overlay coverage as a problem.
- **Deduplication Rule:** Merge repeated observations that share the same root cause into one finding.
- **Compression Rule:** Do not list compliant files, retained overlays, or exhaustive inventories unless they are necessary to explain a finding.
- **Reference Precision:** Include line references when they are available without guesswork.

## 3. Safety Guards

- **Execution Boundary:** Read-only audit. Do not edit files until the user explicitly asks to apply changes.
- **Uncertainty Gate:** If context is insufficient to validate a finding, state uncertainty explicitly and stop.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope

- **Target:** <scope>
- **Audit mode:** <full workspace|targeted>
- **Rules applied:** <only the rules/overlays that materially affected findings>

### Required Violations

- **[id] - [High|Medium|Low]** <brief problem statement>
   - **Rule:** <rule/overlay name>
   - **Evidence:** <file path and line reference>
   - **Minimal remediation:** <one minimal action>

### Optional Gaps

- **[id] - [Low|Medium]** <brief problem statement>
   - **Rule:** <rule/overlay or coverage area>
   - **Evidence:** <file path and line reference>
   - **Minimal remediation:** <one minimal action>

### Ambiguous Cases

- **[id] - [Ambiguous]** <brief uncertainty statement>
   - **Evidence:** <file path and line reference>
   - **Next check:** <one minimal validation step>

### Overlay Coverage Gaps

- **<rule/overlay or coverage area>**
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
