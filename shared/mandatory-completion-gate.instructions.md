---
description: "Shared completion gate for generation and implementation workflows. Reference this file from skills and custom agents; do not duplicate checklist rules elsewhere."
---

# Mandatory Completion Gate

Apply this gate before finalizing implementation or generation for new projects and new project slices.

## Rules

- Do not report completion when any applicable mandatory component is missing.
- If one or more items fail, mark the result as `partial` and list blockers explicitly.

## Checklist

- Applicable mandatory and conditional components are derived from [spring-boot-architecture.instructions.md](../instructions/spring-boot-architecture.instructions.md) and consumed component instruction files only.
- Required artifacts for each applicable component exist and satisfy the owning instruction file requirements.
- Required dependency, plugin, and configuration requirements for each applicable component are present in touched build/config artifacts.
- Test coverage expectations for touched behavior follow the consumed testing instructions.
- Every blocker references the owning instruction file and specific unmet rule.
