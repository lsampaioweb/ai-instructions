---
description: "Run a bi-directional compliance audit: code against instruction contracts, and instruction coverage against active code conventions."
argument-hint: "Optional: feature package path, directory glob, or specific module to audit."
tools: [execute, read, agent, edit, search, web]
---

# Review Code Against Instructions

## 1. Scope and Analysis
1. Resolve audit boundaries from {{$ARGUMENTS}}.
2. If {{$ARGUMENTS}} is empty, scan the active feature package directory only.
3. Load all workspace instruction contracts matching `*.instructions.md`.
4. Map in-scope artifacts (`.java`, `.xml`, `.yml`, `.yaml`, `.sql`, `pom.xml`, `README.md`) to owning contracts using `applyTo` patterns.

## 2. Resolution Rules
- Build a Forward Audit Matrix from code to rules.
- Scan all in-scope source artifacts; do not sample.
- Build a Reverse Audit Matrix from rules to code.
- Detect recurring code conventions, dependencies, properties, and utility patterns that are not represented in matching instruction contracts.
- For each drift found in either direction, output one minimal imperative remediation action.
- Classify findings by component applicability first.
- If a component is required by active contracts and missing in the project, report it as a problem.
- If a component is required and implemented incorrectly, report it as a problem.
- If a component is optional and missing, do not report it as a violation.
- If a component is optional and partial evidence suggests accidental omission or drift, mark it as a possible mistake.
- If a component is optional and implemented, validate it against its matching contract and report violations normally.
- If applicability is ambiguous, mark as possible mistake and request explicit confirmation.
- Use severity levels only after applicability is decided: Critical | High for required-component violations; Medium | Low for possible mistakes and governance gaps.

## 3. Review Plan Layout
Generate the report using this exact markdown schema:

```markdown
## Scope
- **Target Subsystem Scan:** <path/glob audited>
- **Active Instruction Baselines Loaded:** <list of instruction files used>

## Forward Drift Findings (Codebases Violating Instructions)
Ordered by severity: Critical | High | Medium | Low.
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <contract rule, code signal, or ambiguity reason>
- **Location:** <file-path> + line number reference
- **Violated Contract:** <instruction-file-name> + section reference
- **Failure Mechanism:** <technical explanation>
- **Remediation Fix:** <exact code rewrite snippet or deletion instruction>

## Reverse Drift Findings (Instructions Omitting Code Conventions)
Ordered by severity: High | Medium | Low.
- **Applicable Component Type:** <Required | Optional | Ambiguous>
- **Applicability Evidence:** <contract rule, code signal, or ambiguity reason>
- **Target Contract to Update:** <instruction-file-name>
- **Codebase Evidence Pattern:** <snippet or file pattern>
- **Governance Gap:** <why omission causes future generation drift>
- **Proposed Instruction Patch:** <imperative markdown line to add>

## Final Verdict
- Output **[SYSTEM COMPLIANT]** when both matrices have zero Critical and zero High findings.
- Output **[GOVERNANCE REFACTOR SHIELD REQUIRED]** when any Critical or High finding exists.
```

## 4. Safety Guards
- Execution Phase Gating: Phase A is mandatory and read-only; produce the full report before any mutation.
- Mutation Boundary Constraints: Phase B is optional and edit-enabled only after explicit user approval.
- In Phase B, modify only approved remediation items.
- In Phase B, keep edits minimal and scoped to the approved files and lines.
- In Phase B, re-run a focused validation pass and report remaining drift.
- Operate as a read-only diagnostics pass.
- Do not edit files, run refactors, or delete artifacts during Phase A.
- Do not execute non-approved global mutations during Phase B.
- Keep output direct, technical, and execution-focused.
- Omit filler and apologetic commentary.
