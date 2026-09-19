---
description: "Spring Boot architecture defaults, decision precedence, and machine-checkable constraints for the Architect, Coder, and QA agents."
applyTo: "**/pom.xml, **/src/**/*.java, **/src/main/resources/application*.yml, **/src/main/resources/**/*.sql, **/Dockerfile, **/docker-compose*.yml, **/README.md"
---

## Rules

### Decision precedence
- Treat system and platform constraints as highest priority.
- Treat explicit requirements in the current user request as higher priority than defaults.
- Treat user-approved ADR decisions as binding implementation requirements.
- Treat repository instructions as higher priority than shared user instructions when they explicitly conflict.
- Resolve overlapping repository instructions by applying the most specific file pattern first; when patterns are equally specific, apply the more specialized filename rule first and surface any remaining conflict.
- Treat shared user instructions as higher priority than documented project defaults.
- Treat documented defaults as recommendations only when the user or an approved ADR has not decided the topic.

### Default decisions
- Default persistence to PostgreSQL when the user requires durable storage but does not name a datastore.
- Default the persistence access style to the repository and JDBC patterns defined by the repository instruction files.
- Default user-facing text to i18n message keys and locale bundles instead of hardcoded strings.
- Default a web application to expose REST endpoints and server-rendered Thymeleaf pages only when both interfaces serve the stated user workflow.
- Default API collection endpoints to pagination when the result can grow beyond a bounded small list.
- Default API paths to URI versioning when the project exposes a public or independently consumed API.
- Default tests to the narrowest useful unit, slice, integration, or context test scope defined by the test instructions.
- Default containerization, OpenAPI, WebSocket support, external HTTP clients, messaging, and Actuator exposure to disabled unless the request, an applicable instruction, or an approved ADR requires them.
- Default authentication and authorization to an explicit Architect decision; do not silently add login flows to applications that do not need protected behavior.

### Constraint manifest
- Make every mandatory technology choice explicit in the approved ADR under `## Constraint Manifest`.
- List required technologies, forbidden technologies, required files, forbidden scope, validation commands, and acceptance checks in the manifest.
- Require the Coder to validate forbidden dependencies, imports, annotations, configuration keys, and generated sources before reporting completion.
- Require QA to report each manifest violation with an identifier, file, line, evidence, and governing rule.

### Instruction samples
- Treat a sample template as a canonical implementation anchor only when it is complete for its stated purpose and consistent with the governing instruction.
- Treat placeholders and illustrative type names in templates as replacement points, not literal application requirements.
- Do not copy a sample dependency, endpoint, profile, security rule, or integration unless the approved ADR requires that behavior.

### Completion verification
- After the first substantive edit, run the narrowest affected Maven compile or test command before making additional implementation changes.
- Before reporting completion, run the affected module's Maven test command and inspect IDE diagnostics for every modified source file.
- Treat compile, test, deprecation, null-safety, unused-import, and project-model diagnostics as separate verification signals; a passing Maven test does not clear IDE diagnostics.
- When a module depends on external infrastructure, verify both deterministic tests without that infrastructure and a documented live-infrastructure path when the environment permits it.

## Safety Guards
- Block implementation when a mandatory rule and an explicit user request conflict until the user approves a documented exception or changes the request.
- Do not infer authentication, authorization, containers, external integrations, or persistence from a sample alone.

## Reference
- Use the applicable `spring-boot-*.instructions.md` files as the detailed contracts for each governed file type.
