---
name: spring-boot-generate
description: "Generate or implement Spring Boot features in agent mode with strict instruction-file compliance and minimal, testable changes. Use when prompts ask to scaffold, create, generate, implement, add, or fix Spring Boot code."
argument-hint: "What to build + boundaries (for example: 'generate User CRUD REST feature, no security changes')"
---

# Spring Boot Generate (Agent Mode)

## Purpose

Produce Spring Boot code changes that follow instruction files, with clear scope control and verification.

## When This Skill Should Be Used

- New feature scaffolding in an existing Spring Boot project
- New application bootstrap
- Incremental implementation (controller/service/repository/DTO/mapper/exception/config/test)
- Targeted bug fix that requires code changes

## Inputs Required

- Desired outcome (feature or bug fix)
- Scope boundaries (allowed packages/files and what must not change)
- Runtime model if ambiguous (REST API, MVC/Thymeleaf, event-driven)
- Data requirement if applicable (relational persistence required or not)

## Instruction Loading Strategy

1. Load global architecture contract first:
   - ../../instructions/spring-boot-architecture.instructions.md
2. Use the architecture file as the source of truth to determine mandatory vs conditional components for the current request.
3. Load only the instruction files required by that decision and by the touched artifacts.

## Compliance Enforcement

- Do not skip mandatory architecture requirements silently.
- If a mandatory requirement cannot be applied, report the blocker explicitly before finalizing.
- If a required decision is ambiguous and changes generated artifacts, ask one focused clarification question before generating code.
- If compliance is partial, mark the result as partial and list each unmet requirement with reason.

## Workflow

1. Understand request and set exact artifact boundaries.
2. Identify target files to create/update and map required instruction files.
3. Ask one focused clarification only if ambiguity changes architecture or generated artifacts.
4. Implement smallest correct change set; avoid unrelated refactors.
5. Add or update tests for behavior changes.
6. Run available validation (build/tests/lint).
7. If validation cannot run, report the exact blocker and attempted command.
8. Report traceability and compliance status, including instruction files used and requirement coverage.

## Subagent Usage

- Use `runSubagent` only when repository exploration is broad (multiple modules/files) or when initial direct searches do not converge.
- Prefer the `Explore` subagent for read-only discovery, then implement edits in the main agent flow.
- Do not invoke a subagent for straightforward single-feature edits where target files are already known.
- When used, provide explicit scope and required return format (for example: files, evidence lines, and unresolved ambiguities).

## Decision Rules

- Prefer reuse of existing project patterns before introducing new abstractions.
- Do not add dependencies unless required by scope.
- Keep layer boundaries strict: controller -> service -> repository/client.
- Never expose domain models in API contracts.
- If a requested change conflicts with an instruction, flag the conflict and do not bypass safety or mandatory architecture rules; request scope confirmation when needed.

## Completion Checklist

- Applicable instruction files were loaded and applied.
- Mandatory components from the architecture decision were applied or explicitly reported as blocked/not applicable.
- Conditional components were included or excluded with explicit rationale.
- Changes stay inside requested scope.
- Behavior-affecting changes include tests or explicit rationale when not possible.
- Validation status is explicit (executed or not executed).
- No invented assumptions about APIs or architecture.

## Output Contract

- Short implementation summary
- File-by-file change list
- Instruction files used
- Architecture compliance report (mandatory: applied/blocked/not applicable; conditional: included/excluded with reason)
- Validation results
- Open risks or follow-up items
