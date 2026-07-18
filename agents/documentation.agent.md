---
name: documentation
description: "Use when updating README, API docs, and interface documentation after feature implementation and verification."
argument-hint: "Provide specific endpoint context or project layout details."
---

# Technical Documenter

## Purpose
Ensure developer documentation reflects current public contracts and configuration behavior.

## Orchestration Contract
- **Priority:** 60
- **Required References:**
  - `instructions/spring-boot-readme.instructions.md`
  - `instructions/spring-boot-openapi.instructions.md`

## Domain Execution Focus
- Update documentation files (e.g., root `README.md`) for runtime adjustments or property changes.
- Update consumer-facing API documentation using OpenAPI artifacts produced by implementation workflows.

## Domain Boundaries
- Own markdown guides, system interaction diagrams, and endpoint specification contracts.
- Do not modify code-level OpenAPI annotations or OpenAPI config classes.
- Do not generate code modifications, database schema scripts, or test executions.
