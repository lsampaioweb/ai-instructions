---
name: spring-boot
description: "Create, modify, or review Spring Boot applications. Use when prompts ask to create, generate, implement, add, fix, review, audit, validate, verify, or reconcile a Spring Boot application. Route to implementation or review flow based on user intent and return traceable, scoped results."
argument-hint: "Intent + scope (example: 'create authentication feature in sample 11-restapi' or 'review sample 11-restapi for architecture and tests')"
---

# Spring Boot Unified Workflow

## Boundaries

1. Keep this skill focused on workflow, routing, scope control, and reporting.
2. Do not place component-specific implementation rules in this file.
3. Load technical rules from applicable instruction files only when the scoped artifacts require them.

## Intent Routing

1. Infer the user's primary intent from the full request and stated outcome.
2. Route to the create flow when the request asks for implementation, generation, modification, or repair.
3. Route to the review flow when the request asks for analysis, validation, audit, or compliance checking.
4. Ask one focused clarification question only when ambiguity changes scope, artifacts, or expected output.

## Shared Steps

1. Define exact scope, boundaries, and target artifacts.
2. Load architecture contract first: [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md).
3. Load only instruction files required for the scoped artifacts.
4. Keep all conclusions evidence-backed with file and line traceability.
5. Mark compliance as full or partial.
6. Report blockers explicitly when requirements cannot be completed.

## Create Flow

1. Implement the smallest correct change set for the requested outcome.
2. Avoid unrelated refactors and out-of-scope edits.
3. Add or update tests when behavior changes.
4. Run a bounded validation and remediation loop for created or modified artifacts.

## Create Validation Loop

1. After each implementation pass, run the narrowest available build, compile, lint, or typecheck validation for the touched scope.
2. Run the narrowest available tests for the touched scope when tests exist or behavior changed.
3. Review the created or modified artifacts against the loaded instruction files and the architecture contract.
4. If validation or compliance review fails and the issue is in scope, apply the smallest corrective edit and repeat the loop.
5. Stop the loop when validation passes and the result is compliant, or when no further in-scope corrective action is clear.
6. Stop after at most 5 iterations and report the remaining blockers, failed checks, and partial compliance state.

## Create Output

- Short implementation summary
- File-by-file change traceability
- Validation results and blockers
- Open risks or follow-up items

## Review Flow

1. Evaluate only applicable rules for the selected scope.
2. Produce findings first, ordered by severity.
3. Include concrete evidence for each finding.
4. Include missing tests and operational risk.
5. Include minimal remediation ordered by risk reduction.

## Review Output

- Findings first, ordered by severity
- Open questions or assumptions
- Minimal remediation plan
- Coverage limits and blockers

## Shared Output

- Short summary of result type and scope
- Instruction files used
- Apply the compliance reporting contract from [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md)
