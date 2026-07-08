---
description: "Shared review result protocol for reviewer agents and orchestrator synthesis outputs."
argument-hint: "Use this schema when returning findings for any review scope."
applyTo: "agents/spring-boot-review-*.agent.md"
---

# Review Protocol

## Required Principles

- MUST use the output format in this file exactly; do not add, remove, or reorder sections.
- MUST include policy traceability for every finding.
- MUST mark uncertain evidence explicitly rather than omitting or guessing.
- NEVER invent rules not traceable to a consumed instruction file.

## Severity Levels

Use only these values:

- Critical
- High
- Medium
- Low

## Specialist Behavior Contract

Apply these rules in every specialist review agent.

### Scope Boundaries

- Perform analysis only.
- Do not write or modify source code.
- Do not orchestrate other agents.
- Apply only rules defined in consumed instruction files.

### Inputs

- Scope to review: changed files, folder path, or diff summary.
- Optional depth: quick or thorough.
- Optional focus constraints from the orchestrator.

### Review Procedure

1. Normalize the received scope and enumerate reviewable artifacts.
2. Read `pom.xml` to detect Java and Spring Boot versions; apply version-specific rules from consumed instruction files accordingly.
3. Load and apply the consumed instruction files relevant to the review domain.
4. Produce findings with clear evidence and policy traceability.
5. Classify each finding with severity and compliance status.
6. Return results in `## Specialist Output Format` and stop.

### Output Requirements

- Format every response exactly as `## Specialist Output Format` below.
- Include policy traceability for every finding.
- Keep statements deterministic and auditable.
- If evidence is insufficient, mark uncertainty explicitly.

### Handoff Rule

- After producing the protocol-compliant result, hand off control immediately to spring-boot-review-orchestrator.

## Specialist Output Format

Every specialist response must contain these sections in this exact order.

1. Review Summary
- scope reviewed
- review depth
- artifacts analyzed
- environment context: detected Java version, Spring Boot version (read from pom.xml; mark as unknown if not found)

2. Findings
- List findings grouped by severity in this order: Critical, High, Medium, Low.
- For each finding include:
  - finding id
  - domain
  - severity
  - location reference
  - risk statement
  - evidence
  - policy traceability
  - remediation direction

3. Compliance Status
- overall status: compliant, non-compliant, or not-applicable
- rule coverage notes

4. Review Limits
- assumptions
- missing evidence
- unresolved ambiguity

5. Handoff
- explicit handoff statement to spring-boot-review-orchestrator

## Deduplication Rules

Apply when consolidating specialist findings in the orchestrator.

- Merge all specialist findings into one canonical set.
- De-duplicate overlapping findings using specialist Priority metadata.
- Resolve overlap by selecting the lower Priority number as the canonical owner.
- If overlap includes a security finding with severity Critical or High, the Security domain owns the canonical finding.
- If Priority values are equal, keep one canonical finding; retain all contributing domains in traceability.
- If overlap is partial, merge only shared evidence; keep distinct risk statements as separate findings.

## Orchestrator Output Format

The orchestrator response must contain these sections in this exact order.

1. Review Summary
- scope reviewed
- domains reviewed
- finding counts by severity

2. Consolidated Findings
- List findings grouped by severity in this order: Critical, High, Medium, Low.
- For each finding include:
  - canonical finding id
  - owning domain
  - contributing domains
  - severity
  - location reference
  - risk statement
  - evidence
  - policy traceability
  - remediation direction

3. Cross-Domain Insights
- shared root causes
- dependency ordering between fixes
- concentration hotspots

4. Compliance Matrix
- Architecture
- Quality
- Testing
- Performance
- Security

5. Remediation Priority
- ordered fix sequence with dependency notes

6. Review Limits
- incomplete domains
- missing evidence
- uncertain conclusions

7. Final Decision
- ready
- needs-fixes
- review-incomplete

## Consolidation Rules

- Use `## Deduplication Rules` as the canonical consolidation policy.

## Field Constraints

- Use stable identifiers for findings.
- Keep terminology consistent across sections.
- Use the same location reference style throughout one report.
- Do not omit required sections.
