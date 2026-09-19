---
description: "Spring Boot root README documentation: verified setup, execution, endpoints, profiles, infrastructure, and safe local configuration."
applyTo: "README.md, **/README.md"
---

## Dependencies
- Follow `spring-boot-application.instructions.md`, `spring-boot-container.instructions.md`, and `spring-boot-test.instructions.md` for the behavior documented in a README.

## Naming Conventions
- Use the project or sample name as the top-level README heading.
- Use descriptive headings for setup, execution, endpoints, configuration, tests, and troubleshooting.

## Rules

### Structure
- Include at minimum these sections in this order: (1) project title with one-line description, (2) Overview, (3) Prerequisites, (4) Getting Started, (5) Configuration reference, (6) API reference (when the module exposes a public API), (7) Tests, (8) Troubleshooting, (9) Created by.
- Write the Overview as one paragraph that answers what the service does, who uses it, and states the top one or two architectural decisions a developer will immediately encounter; do not repeat the title in the Overview.
- Add an API reference section or link when the module exposes a public API.
- Document only the project or module this README belongs to; do not describe cross-project dependencies or upstream systems inline. Link to related project documentation instead when it provides shared infrastructure or feature details, keeping links relative and valid from the README location.
- End every README with a `## Created by` section containing `Luciano Sampaio`.

### Verified documentation
- Write only actionable content; omit prose that describes intent without providing executable or verifiable information.
- Verify every dependency version, command, profile, port, URL, endpoint, payload, and response claim against the runnable project artifacts.
- Verify database schema and seed behavior against both SQL scripts and active SQL initialization configuration; do not claim that a schema or seed script runs automatically unless active configuration proves it.
- Document only components, endpoints, health indicators, and test coverage that exist in the project.

### Setup and execution
- State each prerequisite with its required version, a verification command, and an install reference or link.
- Use shared infrastructure setup when the sample relies on it; do not document an unrelated standalone container as the canonical setup.
- Write run instructions that can be executed verbatim without manual substitution.
- After run instructions, list primary access URLs (API base URL, Swagger UI, Actuator health) so developers can immediately verify the running service.
- Document required environment variables in Getting Started: each variable's name, purpose, and an example value.
- Mark local credential values and localhost URLs as development-only examples; keep secrets out of README examples and never instruct users to commit `.env` files.
- Include separate development and production commands only when both are supported by the project configuration.
- Wrap all commands and code snippets in fenced code blocks with the appropriate language identifier.
- Document Docker Compose run commands when the module includes a `docker-compose.yml`.

### API and feature documentation
- Document only the routes and HTTP methods declared by the controllers.
- Keep request and response examples aligned with the actual API contract.
- Describe transaction and failure behavior according to the implemented service and exception flow.
- Document authentication and authorization behavior when applicable.
- Document profile-dependent features, such as Swagger UI, only for profiles where they are enabled.

### Configuration reference
- In the Configuration reference section, explain each setting's operational purpose and when a developer would need to change it.
- Each entry must state: file path, property key or setting name, and effective value or behavior; omit entries that contain only a file path with no actionable detail.
- Do not list configuration file contents as a key=value dump.
- When the module has multiple runtime profiles, document the intended use case for each profile.
- Include concise rationale for key architecture decisions; link to deeper technical documentation instead of duplicating long walkthroughs inline.

### Tests and troubleshooting
- Document the available test command and the actual test scope.
- Include a Troubleshooting section covering common startup failures: database or broker connection errors, port conflicts, and missing environment variables.

## Safety Guards
- Never publish production credentials, tokens, private URLs, or stack traces.
- Never present development-only security, health-detail, or logging settings as production guidance.
- Never document components or features that have not been implemented.
- Never document commands that contradict the project's instruction files or established architecture constraints.
- Never omit breaking behavioral changes from user-facing documentation.

## Reference
- Use [samples/spring-boot-readme.tpl](samples/spring-boot-readme.tpl) for README structure.
