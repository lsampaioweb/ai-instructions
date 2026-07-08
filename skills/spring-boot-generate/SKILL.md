---
name: spring-boot-generate
description: "Generate or implement Spring Boot features in agent mode with strict instruction-file compliance and minimal, testable changes. Use when prompts ask to scaffold, create, generate, implement, add, or fix Spring Boot code."
argument-hint: "What to build + boundaries (for example: 'generate User CRUD REST feature, no security changes')"
---

# Spring Boot Generate (Agent Mode)

## Instruction Loading Strategy

1. Load global architecture contract first:
   - ../../instructions/spring-boot-architecture.instructions.md
2. Use the architecture file as the source of truth to determine mandatory vs conditional components for the current request.
3. Load only the instruction files required by that decision and by the touched artifacts.

## Workflow

1. Understand request and set exact artifact boundaries.
2. Identify target files to create/update and map required instruction files.
3. If a required decision is ambiguous and changes generated artifacts, ask one focused clarification question before generating code.
4. Implement smallest correct change set; avoid unrelated refactors.
5. Do not add dependencies unless required by scope.
6. Add or update tests for behavior changes.
7. Run available validation (build/tests/lint); if it cannot run, report the exact blocker and attempted command.
8. Report traceability and compliance status, including instruction files used and requirement coverage.

## Compliance

- Do not skip mandatory architecture requirements silently; report any blocker explicitly before finalizing.
- If compliance is partial, mark the result as partial and list each unmet requirement with reason.
- Flag any conflict with an instruction file; do not bypass safety or mandatory architecture rules.

## Output

- Short implementation summary
- File-by-file change list
- Instruction files used
- Architecture compliance report (mandatory: applied/blocked/not applicable; conditional: included/excluded with reason)
- Validation results
- Open risks or follow-up items
