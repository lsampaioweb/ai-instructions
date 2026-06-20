---
name: spring-boot
description: "Generate or code review a Spring Boot application or feature following project conventions. Use when: creating a new app, adding or reviewing an endpoint, controller, service, repository, DTO, mapper, exception, or any other Spring Boot component."
argument-hint: "Name of the application or feature to scaffold or review (e.g. 'User', 'Product')"
---

# Spring Boot Feature Scaffolding and Code Review

Read [spring-boot-architecture.instructions.md](../../instructions/spring-boot-architecture.instructions.md) first for cross-cutting architecture constraints, scope control, and ambiguity/clarification protocol. For file-specific implementation rules, follow the dedicated `spring-boot-*.instructions.md` files referenced there.

Before planning or generating files, treat repository memory as a hint only. Verify any memory claim about existing modules, packages, files, or app structure against the current workspace before using it to drive decisions.
