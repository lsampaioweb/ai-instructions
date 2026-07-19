---
description: "Run a bi-directional compliance audit: code against instruction contracts, and instruction coverage against active code conventions."
argument-hint: "Optional: feature package path, directory glob, or specific module to audit."
---

# Review Code Against Instructions

## 1. Scope & Analysis
1. Resolve audit boundaries from {{$ARGUMENTS}}.
2. If {{$ARGUMENTS}} is empty, scan the active feature package directory only.
3. Map in-scope artifacts to owning contracts by matching file paths against `applyTo` glob patterns in each instruction file.

## 2. Resolution Rules
- **Forward Audit Matrix:** Map every in-scope code artifact to its owning instruction contract; flag violations.
- **Scanning Rigor:** Scan all in-scope source artifacts; do not sample.
- **Reverse Audit Matrix:** Map every active instruction rule to code; flag recurring patterns, dependencies, and properties absent from matching contracts.
- **Remediation Output:** For each drift in either direction, output one minimal imperative remediation action.
- **Applicability-First Classification:** Classify findings by component applicability before assigning severity.
- **Required + Missing:** If a required component is absent from the project, report it as a problem.
- **Required + Incorrect:** If a required component is implemented incorrectly, report it as a problem.
- **Optional + Missing:** Do not report a missing optional component as a violation.
- **Optional + Drift Evidence:** If partial evidence suggests accidental omission, mark it as a possible mistake.
- **Optional + Implemented:** Validate against its matching contract and report violations normally.
- **Ambiguous Applicability:** Mark as possible mistake and request explicit confirmation.
- **Severity Gate:** Apply Critical | High only to required-component violations; Medium | Low to possible mistakes and governance gaps.

## 3. Review Plan Layout
Generate the report using this exact markdown schema:

### Scope
- **Target Subsystem Scan:** <path/glob audited>
- **Active Instruction Baselines Loaded:** <list of instruction files used>

### Forward Drift Findings (Codebases Violating Instructions)
Grouped by severity: Critical | High | Medium | Low. Separate each distinct finding with a clear horizontal rule divider (---).

---
#### [SEVERITY: VALUE] | Finding Target: <file-path>
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <contract rule or codebase signal>
- **Exact Code Location:** Line <number> in `<file-path>`
- **Violated Contract:** `<instruction-file-name>` -> Section: <section>
- **Failure Mechanism:**
  > <technical explanation of the architectural drift>
- **Remediation Fix:**
  Incorporate this exact structural resolution or removal path:
  [Insert imperative rewrite instruction or code snippet block here]
---

### Reverse Drift Findings (Instructions Omitting Code Conventions)
Grouped by severity: High | Medium | Low. Separate each distinct finding with a clear horizontal rule divider (---).

---
#### [SEVERITY: VALUE] | Missing Contract Rule Target: <instruction-file-name>
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <codebase pattern or architecture gap>
- **Codebase Evidence Pattern:** Found pattern in `<file-path>`
- **Governance Gap:**
  > <why omitting this rule causes future generation drift or automation mistakes>
- **Proposed Instruction Patch:**
  - Add to section `<section>`: `[IMPERATIVE DIRECTIVE]`
---

### Final Verdict
- **[READY]** — Both matrices have zero Critical and zero High findings.
- **[NEEDS FIXES]** — One or more Critical or High findings present.

## 4. Safety Guards
- **Execution Boundary:** Read-only audit. Do not edit files, run refactors, or delete artifacts until the full report is confirmed.
- **Mutation Boundary:** If authorized, modify only approved remediation items; re-run a focused validation pass after each change.
- **Instruction File Boundary:** Reverse Drift proposals targeting `.instructions.md` or `.prompt.md` files must be validated through `review-ai-customization-files` before applying.
