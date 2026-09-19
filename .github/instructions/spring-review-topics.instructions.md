---
description: "Review-topic registry for focused reviewer agents. Use when: routing instruction files by topic, and applying the shared reviewer procedure and output format for QA, security, database, i18n, or performance review agents."
applyTo: "**/spring-review-*.agent.md, **/spring-orchestrator.agent.md, **/spring-verifier.agent.md"
---

## Rules

- Treat this file as the canonical mapping between review topics and instruction files.
- Keep each instruction file in exactly one topic, unless explicitly listed as unreviewed by topic reviewers.
- Resolve applicable instruction files for a review run as follows:
  1. Start from the instruction files mapped to the active topic.
  2. Keep a mapped instruction file only when its `applyTo` matches at least one path under review, or the ADR maps that instruction file to a reviewed file.
  3. If the filtered set is empty, return `STATUS: PASS` with an empty `ISSUES` section.
- Leave these instruction files intentionally unreviewed by topic reviewers: `.github/instructions/spring-boot-readme.instructions.md`, `.github/instructions/spring-review-topics.instructions.md`, `.github/instructions/ai-customization.instructions.md`, `.github/instructions/review-suppressions.instructions.md`, `.github/instructions/spring-boot-architecture-defaults.instructions.md` (covered by the Verifier's manifest checks, not topic review).
- Topic `qa`: `.github/instructions/spring-boot-architecture.instructions.md`, `.github/instructions/spring-boot-java-style.instructions.md`, `.github/instructions/spring-boot-logging.instructions.md`, `.github/instructions/spring-boot-controller.instructions.md`, `.github/instructions/spring-boot-service.instructions.md`, `.github/instructions/spring-boot-test.instructions.md`, `.github/instructions/spring-boot-dto-mapper.instructions.md`, `.github/instructions/spring-boot-model.instructions.md`, `.github/instructions/spring-boot-openapi.instructions.md`, `.github/instructions/spring-boot-pom.instructions.md`, `.github/instructions/spring-boot-application.instructions.md`, `.github/instructions/spring-boot-enum.instructions.md`, `.github/instructions/spring-boot-error-code.instructions.md`, `.github/instructions/spring-boot-api-versioning.instructions.md`, `.github/instructions/spring-boot-thymeleaf.instructions.md`, `.github/instructions/spring-boot-websocket.instructions.md`, `.github/instructions/spring-boot-container.instructions.md`, `.github/instructions/spring-boot-gitignore.instructions.md`.
- Topic `security`: `.github/instructions/spring-boot-security.instructions.md`, `.github/instructions/spring-boot-config.instructions.md`, `.github/instructions/spring-boot-actuator.instructions.md`, `.github/instructions/spring-boot-http-client.instructions.md`, `.github/instructions/spring-boot-exception.instructions.md`.
- Topic `database`: `.github/instructions/spring-boot-repository.instructions.md`, `.github/instructions/spring-boot-database-schema.instructions.md`.
- Topic `i18n`: `.github/instructions/spring-boot-i18n.instructions.md`.
- Topic `performance`: `.github/instructions/spring-boot-pagination.instructions.md`, `.github/instructions/spring-boot-async-events.instructions.md`.

### Reviewer procedure
- Read the ADR file provided and the list of files under review provided by the orchestrator before resolving applicable instruction files.
- Collect the instruction files mapped to the active topic, then keep only the ones that apply under the scope-resolution rules above.
- If the filtered set is empty, respond `STATUS: PASS` with an empty `ISSUES` section.
- Read the applicable instruction files and check reviewed files only against their explicit Safety Guards and Rules.
- Report only violations of rules explicitly written in the applicable mapped instruction files; cite the instruction file and rule for every issue raised.
- Report every violation using the Shared Violation Format below, then respond using the Shared Output Format below.
- Do not run build, test, dependency, or environment checks.
- Do not evaluate code against any standard, convention, or best practice that is not explicitly stated in an applicable mapped instruction file.
- Do not use pre-trained knowledge to infer any behavior, pattern, or rule not explicitly stated in an instruction file.
- Do not invent violations unsupported by the approved ADR, manifest, applicable instruction, or executable evidence.
- Do not modify application, instruction, or agent files.

### Shared Violation Format

```text
Status: FAIL
Id: <TOPIC-PREFIX>-[number]
Severity: blocker|high|medium|low
File: [workspace-relative path]
Line: [line number when available]
Evidence: [observed code, dependency, command output, or missing artifact]
Requirement: [ADR or manifest requirement]
Instruction: [governing instruction file and rule]
Repair scope: [smallest required correction]
```

### Shared Output Format

Respond using exactly this format:

```
STATUS: PASS | FAIL
ISSUES:
- <one violation block per finding, using the Shared Violation Format above>
```

If `STATUS: PASS`, the `ISSUES` section must be empty.

## Safety Guards
- Never use a topic map entry to expand a review beyond the changed files.
