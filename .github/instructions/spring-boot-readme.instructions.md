---
description: "README structure rules for required sections, actionable content, fenced code blocks, and no-filler-prose policy."
applyTo: "README.md, **/README.md"
---

# README Engine

## Rules
- Include at minimum these sections in this order: (1) project title with one-line description, (2) Overview, (3) Prerequisites, (4) Getting Started, (5) Configuration reference.
- Write the Overview as one paragraph.
- Ensure the Overview answers what this service does.
- Ensure the Overview answers who uses this service.
- Ensure the Overview states the top one or two architectural decisions a developer will immediately encounter.
- Do not repeat the title in the Overview.
- Add an API reference section or link when the module exposes a public API.
- Document only the project or module this README belongs to.
- Do not describe cross-project dependencies or upstream systems inline.
- Write only actionable content.
- Omit prose that describes intent without providing executable or verifiable information.
- State each prerequisite with its required version.
- For each prerequisite, provide a verification command.
- For each prerequisite, provide an install reference or link.
- Write run instructions that can be executed verbatim without manual substitution.
- After run instructions, list primary access URLs (API base URL, Swagger UI, Actuator health) so developers can immediately verify the running service.
- Document required environment variables in Getting Started: each variable's name, purpose, and an example value.
- Wrap all commands and code snippets in fenced code blocks with the appropriate language identifier.
- Document Docker Compose run commands when the module includes a `docker-compose.yml`.
- Document endpoint contracts or link to the canonical API documentation.
- Document authentication and authorization behavior when applicable.
- In the Configuration reference section, explain each setting's operational purpose and when a developer would need to change it.
- When the module has multiple runtime profiles, document the intended use case for each profile.
- Include concise rationale for key architecture decisions.
- In the Configuration reference section, each entry must state: file path, property key or setting name, and effective value or behavior.
- Omit entries that contain only a file path with no actionable detail.
- Link to deeper technical documentation instead of duplicating long walkthroughs inline.
- Include a Troubleshooting section covering common startup failures: database or broker connection errors, port conflicts, and missing environment variables.

## Safety Guards
- Never document components or features that have not been implemented.
- Never document commands that contradict the project's instruction files or established architecture constraints.
- Never omit breaking behavioral changes from user-facing documentation.
- Never list configuration file contents as a key=value dump.
