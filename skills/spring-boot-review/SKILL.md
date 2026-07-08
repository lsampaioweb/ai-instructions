---
name: spring-boot-review
description: "Audit or review Spring Boot code in plan mode against instruction files, producing findings-first reports with severity, evidence, and remediation steps. Use when prompts ask to review, audit, validate, verify, reconcile, or check compliance."
argument-hint: "What to review + scope (for example: 'audit sample 11-restapi service and controller layers')"
---

# Spring Boot Review (Plan Mode)

## Instruction Loading Strategy

1. Load global architecture contract first:
   - ../../instructions/spring-boot-architecture.instructions.md
2. Use the architecture file as the source of truth to determine mandatory vs conditional components for the current request.
3. Load only instruction files relevant to that decision and to the reviewed artifacts.

## Workflow

1. Map scope to artifact categories and required instruction files.
2. If a required decision is ambiguous and changes review conclusions, ask one focused clarification question before finalizing.
3. Evaluate each artifact against applicable rules; record only evidence-backed findings.
4. Prioritize findings by severity and impact.
5. Identify missing tests and operational risk.
6. Provide minimal remediation plan ordered by risk reduction.
7. Report traceability and compliance status, including instruction files used and requirement coverage.

## Quality Gates

Apply the severity model defined in [spring-boot-review-protocol.md](../../agents/spring-boot-review-protocol.md).

- Every finding includes concrete evidence (file + line).
- Every finding maps to a specific instruction rule.
- No speculative issues without evidence.
- If compliance is partial, mark the result as partial and list each unmet requirement with reason.

## Output

- Findings first (severity-ordered)
- Open questions/assumptions
- Minimal remediation plan
- Instruction files used
- Architecture compliance report (mandatory: compliant/non-compliant/not applicable; conditional: included/excluded with reason)
- Brief summary of coverage and limits

For formal audits via the orchestrator, apply the exact output format defined in [spring-boot-review-protocol.md](../../agents/spring-boot-review-protocol.md).
