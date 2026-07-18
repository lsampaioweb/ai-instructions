---
name: spring-boot
description: "Create, modify, or review Spring Boot applications. Use when prompts ask to create, generate, implement, add, fix, review, audit, validate, verify, or reconcile a Spring Boot application. Route to implementation or review flow based on user intent and return traceable, scoped results."
argument-hint: "Intent + scope (example: 'create authentication feature in sample 11-restapi' or 'review sample 11-restapi for architecture and tests')"
---

# Spring Boot Unified Workflow

## Boundaries

- Keep this skill focused on workflow, routing, scope control, and reporting.
- Do not place component-specific implementation rules in this file.
- Load technical rules from applicable instruction files only when the scoped artifacts require them.

## Intent Routing

- Infer the user's primary intent from the full request and stated outcome.
- Route to the create flow when the request asks for implementation, generation, modification, or repair.
- Route to the review flow when the request asks for analysis, validation, audit, or compliance checking.
- Ask one focused clarification question only when ambiguity changes scope, artifacts, or expected output.

## Shared Steps

- Define exact scope, boundaries, and target artifacts.
- Load architecture contract first: [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md).
- Load only instruction files required for the scoped artifacts.
- Keep all conclusions evidence-backed with file and line traceability.
- Mark compliance as full or partial.
- Report blockers explicitly when requirements cannot be completed.

## Create Flow

- Implement the smallest correct change set for the requested outcome.
- Avoid unrelated refactors and out-of-scope edits.
- Add or update tests when behavior changes.
- Run a bounded validation and remediation loop for created or modified artifacts.

## Create Validation Loop

- After each implementation pass, run the narrowest available build, compile, lint, or typecheck validation for the touched scope.
- Run the narrowest available tests for the touched scope when tests exist or behavior changed.
- Review the created or modified artifacts against the loaded instruction files and the architecture contract.
- If validation or compliance review fails and the issue is in scope, apply the smallest corrective edit and repeat the loop.
- Stop the loop when validation passes and the result is compliant, or when no further in-scope corrective action is clear.
- Stop after at most 5 iterations and report the remaining blockers, failed checks, and partial compliance state.

## Create Output

- Short implementation summary
- File-by-file change traceability
- Validation results and blockers
- Open risks or follow-up items

## Review Flow

- Evaluate only applicable rules for the selected scope.
- Produce findings first, ordered by severity.
- Include concrete evidence for each finding.
- Include missing tests and operational risk.
- Include minimal remediation ordered by risk reduction.

## Review Output

- Findings first, ordered by severity
- Open questions or assumptions
- Minimal remediation plan
- Coverage limits and blockers

## Shared Output

- Short summary of result type and scope
- Instruction files used
- Apply the compliance reporting contract from [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md)
