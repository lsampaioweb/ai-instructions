---
name: review-code-against-instructions
description: >-
  Audit code against active instruction files, flag violations, and identify
  missing coverage. Use when the user asks to check code against instructions,
  validate compliance, find instruction gaps, or invoke
  /review-code-against-instructions. Optional scope: path, module, file, or
  glob; omit to audit the full workspace. Do NOT invent stricter rules than the
  active instruction text supports.
---

# Code Instruction Audit

## Arguments

- Optional target path, module, file, or glob.
- Omit the filter to audit the full workspace.

## 1. Define the Scope

1. Load all instruction files applicable to the target scope from both:
	- the workspace directory `.github/instructions/`
	- the configured user-level directory `~/.agents/instructions/`
2. Check each instruction file's `applyTo` pattern against the target files.
3. Treat both locations as active instruction sources. Do not ignore an applicable user-level instruction because it is outside the workspace.
4. If applicable instructions conflict, report the conflict and identify both sources. Stop rather than choosing a winner silently.
5. Resolve the target scope from the user-provided arguments when present. If missing, audit the full workspace.
6. Enumerate all code files in scope, sorted by path ascending.
7. Read each code file and check it against all applicable instructions.
8. If scope exceeds available context, process files in path order until context is exhausted, then set Verdict to CONTINUE and record the next unprocessed path.

### Project decision records

1. Load project ADRs or equivalent decision records from the target workspace,
	typically under `docs/adr/`, when they exist.
2. Treat an ADR as an approved, project-specific exception only when all of the
	following are true:
	- its status is `Accepted` or equivalent;
	- it explicitly names the behavior, endpoint, component, or rule being
		decided;
	- the observed code is within the ADR's stated scope;
	- the ADR does not merely describe the current implementation.
3. An explicit accepted ADR may override a reusable instruction only for the
	narrowly described decision. Do not generalize the exception to unrelated
	code or rules.
4. Continue validating every non-exempt instruction and every compensating
	control described by the ADR.
5. Cite the ADR when suppressing a finding. If the ADR is ambiguous, obsolete,
	superseded, or broader than the observed decision, report the uncertainty
	and stop instead of silently accepting the exception.
6. Do not treat README text, comments, deployment assumptions, or undocumented
	conventions as equivalent to an accepted ADR.

## 2. Resolution Rules

### Violations

- Flag every place where code does not follow an explicit active instruction
	rule, unless a scoped accepted ADR explicitly overrides that rule.
- When an accepted ADR applies, do not report the overridden behavior as a
	violation. Record the ADR as the justification and continue checking the
	remaining rules and compensating controls.
- Cite the exact instruction rule broken and include a file:line reference.
- Severity: Critical = security, data loss, or secret exposure. High = explicit rule break. Medium = non-security rule gap. Low = naming or style rule gap.
- Merge findings that share the same root cause into one entry.
- Do not infer stricter rules than the active instruction text explicitly supports.

### Missing Coverage

- Identify recurring code patterns that no active instruction governs.
- Propose one new instruction rule per uncovered pattern.
- Identify the appropriate owner for each proposed rule:
	- `.github/instructions/` for project-specific rules.
	- `~/.agents/instructions/` for reusable cross-project rules.

### Approved exceptions

- Record each instruction rule intentionally overridden by an accepted ADR.
- Include the ADR path, decision section, affected behavior, and remaining
  controls that were still validated.
- Do not treat an approved exception as a missing instruction unless the same
  decision is intended to apply across projects.

### Reporting

- State each problem briefly with one minimal fix.
- Base all conclusions on files that actually exist in scope.

## 3. Safety Guards

- **Execution Boundary:** Present all findings first. Apply fixes only after the user explicitly confirms which findings to act on.
- **Uncertainty Gate:** If context is insufficient to validate a finding, state the uncertainty explicitly and stop.

## 4. Review Plan Layout

Use this exact markdown schema:

### Scope
- Target: <scope>
- Mode: <read-only | apply-after-confirmation>
- Instructions applied: <files that materially affected findings, including their source location>

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
- <`none` | confirmed fixes to apply | Reply `Continue` to process remaining files (or re-run this skill with `<Continue from path>` as the argument in a new session)>

### Verdict
- READY | NEEDS FIXES | CONTINUE
