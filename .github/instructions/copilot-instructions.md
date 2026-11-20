---
description: "Workspace behavior baseline for safe execution, scope control, direct technical communication."
applyTo: "**"
---

## Available AI customization
- Consult the relevant instructions and skills available in the current session before proposing or making changes.
- Do not assume customization file locations or lookup precedence.
- Do not change editor customization settings or publish files into another customization set without explicit approval.

## Language and communication
- Use clear, direct technical English.
- Keep responses brief and focused on what is needed.
- Omit conversational filler, prefaces, and unnecessary summaries.

## Scope and change discipline
- Edit only files directly related to the active task.
- Flag adjacent out-of-scope issues without changing them silently.
- Do not run destructive commands such as `rm -rf`, `git push`, or database resets without explicit user confirmation.

## Critical evaluation
- Evaluate proposals critically and call out flawed assumptions directly.
- Prefer concrete fixes over vague suggestions.
- Stop and report blockers when progress stalls or the task becomes unclear.

## Execution safety
- Format modified source files with the editor tools instead of ad hoc manual formatting.
- Use command-line tools only when they are necessary for the task.
- Avoid broad or exploratory changes when a smaller, precise fix is sufficient.

## Default stack
Apply these choices when the corresponding capability is needed.
Do not introduce tools merely because they appear in this list.

- Use Packer to build reusable machine images and VM templates.
- Use Terraform to provision infrastructure and manage its lifecycle.
- Use Ansible to configure operating systems, install services, and manage their configuration.
- Use Java with Spring Boot for all application development.
- Do not propose another application language or framework unless explicitly requested.
- Use Podman for container builds and execution.
- Use Grafana for visualization, Prometheus for metrics, Loki for logs, Alloy for collection, and Tempo for traces.
- Consult the available topic instructions for implementation details.
- Request approval before departing from these defaults.
- Do not migrate existing implementations solely to enforce these defaults.

## Workflow macros
- Interpret the following prompt modifiers when present:
  - `#DMS`: The user wants to know if the proposed idea makes sense or not.
  - `#OTS`: The user is open to suggestions that would improve the proposed idea.
  - `#FIX`: The user wants identified non-destructive corrections to be applied immediately, but read the file(s) first to ensure the fix is safe.

## Clarification requests
- When a blocking question is required, provide explicit fixed choices.
- Mark exactly one fixed choice as recommended.
- Provide exactly one free-text answer path using the form's open-text / custom-answer
  field. Do not also add a fixed choice labeled `Other`, `Other (type your answer)`,
  or similar—that creates two free-text options.
- Keep clarification focused on the missing fact needed to proceed safely.
- Do not ask for approval of a spec, ADR, or override until the full text has already
  been shown in the same response.
