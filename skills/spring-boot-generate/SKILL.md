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
2. Classify request type: new project, new project slice, or scoped edit in an existing project.
3. Identify target files to create/update and map required instruction files.
4. If a required decision is ambiguous and changes generated artifacts, ask one focused clarification question before generating code.
5. For new projects and new project slices, scaffold all applicable mandatory architecture components first as one coherent step.
6. Implement smallest correct change set; avoid unrelated refactors.
7. Add dependencies only when required by selected architecture components and touched artifacts.
8. Add or update tests for behavior changes.
9. Run mandatory completion gate checks before reporting done.
10. Run available validation (build/tests/lint); if it cannot run, report the exact blocker and attempted command.
11. Report traceability and compliance status, including instruction files used and requirement coverage.

## Mandatory Completion Gate

- Apply [mandatory-completion-gate.instructions.md](../../shared/mandatory-completion-gate.instructions.md).

## Compliance

- Do not skip mandatory architecture requirements silently; report any blocker explicitly before finalizing.
- If compliance is partial, mark the result as partial and list each unmet requirement with reason.
- Flag any conflict with an instruction file; do not bypass safety or mandatory architecture rules.
- Mandatory completion gate results must be included in every generation result.

## Output

- Short implementation summary
- File-by-file change list
- Instruction files used
- Architecture compliance report (mandatory: applied/blocked/not applicable; conditional: included/excluded with reason)
- Mandatory completion gate report (applied/blocked/not applicable per item)
- Validation results
- Open risks or follow-up items
