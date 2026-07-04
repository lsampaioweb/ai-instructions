---
name: spring-boot
description: "Generate, audit, or code review a Spring Boot application or feature following project conventions. Use when: creating a new app, adding or reviewing an endpoint, controller, service, repository, DTO, mapper, exception, or any other Spring Boot component. Also use for auditing, validating compliance, and reconciling code against instruction files."
argument-hint: "Name of the application or feature to scaffold or review (e.g. 'User', 'Product'), or scope to audit (e.g. 'audit crud-pages', 'review Product controller')"
---

# Spring Boot Feature Scaffolding and Code Review

## When to Use This Skill

**Scaffold/Generate scenarios:**
- Creating a new Spring Boot application
- Adding a new controller, service, repository, DTO, mapper, or exception class
- Scaffolding a complete feature (e.g., "scaffold User CRUD feature")

**Code review/validation scenarios:**
- Reviewing existing code against Spring Boot conventions
- Auditing a project or module against instruction files
- Validating compliance with mandatory components (e.g., i18n, logging, exception handling, etc.)
- Reconciling drift between instructions and code
- Checking for violations (e.g., hardcoded strings, missing annotations, incorrect patterns)

**Trigger keywords:** Use this skill when your prompt includes any of these words:
- `review` — "review the ProductController"
- `audit` — "audit the crud-pages project"
- `validate` / `validation` — "validate against all Spring Boot rules"
- `compliance` / `compliant` — "is the code compliant with instructions?"
- `reconcile` / `reconciliation` — "reconcile code against the instructions"
- `check` — "check for violations in the service layer"
- `verify` — "verify the i18n implementation"
- `scaffold` / `generate` — "generate a new UserService"

## How to Use

Read [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md) first for cross-cutting architecture constraints, scope control, and ambiguity/clarification protocol. For file-specific implementation rules, follow the dedicated `spring-boot-*.instructions.md` files referenced there.

Before planning or generating files, treat repository memory as a hint only. Verify any memory claim about existing modules, packages, files, or app structure against the current workspace before using it to drive decisions.
