---
name: spring-boot-review
description: "Audit or review Spring Boot code in plan mode against instruction files, producing findings-first reports with severity, evidence, and remediation steps. Use when prompts ask to review, audit, validate, verify, reconcile, or check compliance."
argument-hint: "What to review + scope (for example: 'audit sample 11-restapi service and controller layers')"
---

# Spring Boot Review (Plan Mode)

## Purpose

Provide a compliance and quality review of Spring Boot code using instruction files, without mixing in unrelated implementation work.

## When This Skill Should Be Used

- Compliance audits against instruction files
- Code reviews before merge
- Gap analysis between current code and target architecture
- Regression-risk analysis after refactors

## Inputs Required

- Review scope (module/package/files)
- Review depth (quick scan or thorough audit)
- Constraints (read-only review or include fix plan)

## Instruction Loading Strategy

1. Load architecture baseline first:
   - ../../instructions/spring-boot-architecture.instructions.md
2. Use the architecture file as the source of truth to determine mandatory vs conditional components for the current scope.
3. Load only instruction files relevant to that decision and to the reviewed artifacts.

## Compliance Enforcement

- Do not skip mandatory architecture requirements silently.
- If a mandatory requirement cannot be verified or is violated, report it explicitly before finalizing.
- If a required decision is ambiguous and changes review conclusions, ask one focused clarification question before finalizing.
- If compliance is partial, mark the result as partial and list each unmet requirement with reason.

## Workflow

1. Map scope to artifact categories and required instruction files.
2. Evaluate each artifact against applicable rules.
3. Record only evidence-backed findings.
4. Prioritize findings by severity and impact.
5. Identify missing tests and operational risk.
6. Provide minimal remediation plan (ordered by risk reduction).
7. Report traceability and compliance status, including instruction files used and requirement coverage.

## Subagent Usage

- Use `runSubagent` only for wide-scope read-only audits where manual search chaining would be noisy or slow.
- Prefer the `Explore` subagent to gather candidate evidence, then verify findings directly before reporting.
- Do not invoke a subagent when scope is small and evidence can be collected deterministically with direct search/read tools.
- When used, request output as severity-ready evidence (file path, line reference, rule mapping, and confidence).

## Severity Model

- Critical: security/data-loss/major production outage risk
- High: architectural violations or high regression risk
- Medium: maintainability/compliance gaps that should be fixed
- Low: style/documentation/readability issues

## Quality Gates

- Every finding includes concrete evidence (file + line).
- Every finding maps to a specific instruction rule.
- No speculative issues without evidence.
- Distinguish confirmed defects from assumptions/open questions.

## Completion Checklist

- Applicable instruction files were loaded and applied.
- Mandatory components from the architecture decision were verified as compliant or explicitly reported as non-compliant/not applicable.
- Conditional components were verified as included/excluded with explicit rationale.
- Findings are ordered by severity.
- Missing tests and residual risks are explicit.
- If no issues found, explicitly state "no findings" and note any review limits.

## Output Contract

- Findings first (severity-ordered)
- Open questions/assumptions
- Minimal remediation plan
- Instruction files used
- Architecture compliance report (mandatory: compliant/non-compliant/not applicable; conditional: included/excluded with reason)
- Brief summary of coverage and limits
