---
description: "Use when auditing code against instruction contracts and instruction coverage against active code conventions."
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
- **Required Components:** If a required component is missing or implemented incorrectly, report it as a problem.
- **Optional Components:** Missing is not a violation. If partial evidence suggests accidental omission, mark it as a possible mistake. If implemented, validate against the matching contract and report violations normally.
- **Ambiguous Applicability:** Mark as a possible mistake and request explicit confirmation.
- **Severity Gate:** Apply Critical | High only to required-component violations; Medium | Low to possible mistakes and governance gaps.

## 3. Review Plan Layout
Generate the report using this exact markdown schema:

### Scope
- **Target Subsystem Scan:** <path/glob audited>
- **Active Instruction Baselines Loaded:** <list of instruction files used>

### Forward Drift Findings (Codebases Violating Instructions)
Ordered by severity: Critical | High | Medium | Low.
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <contract rule, code signal, or ambiguity reason>
- **Location:** <file-path> + line number reference
- **Violated Contract:** <instruction-file-name> + section reference
- **Failure Mechanism:** <technical explanation>
- **Remediation Fix:** <exact code rewrite snippet or deletion instruction>

### Reverse Drift Findings (Instructions Omitting Code Conventions)
Ordered by severity: High | Medium | Low.
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <contract rule, code signal, or ambiguity reason>
- **Target Contract to Update:** <instruction-file-name>
- **Codebase Evidence Pattern:** <snippet or file pattern>
- **Governance Gap:** <why omission causes future generation drift>
- **Proposed Instruction Patch:** <imperative markdown line to add>

### Final Verdict
- **[READY]** — Both matrices have zero Critical and zero High findings.
- **[NEEDS FIXES]** — One or more Critical or High findings present.

## 4. Safety Guards
- **Execution Boundary:** Read-only audit. Do not edit, refactor, or delete artifacts until the full report is confirmed.
- **Mutation Boundary:** If authorized, modify only approved remediation items; re-run a focused validation pass after each change.
- **Instruction File Boundary:** Reverse Drift proposals targeting `.instructions.md` or `.prompt.md` files must be validated through `review-ai-customization-files` before applying.
- **Output Discipline:** Keep output direct, technical, and execution-focused. Omit preambles and apologies.
