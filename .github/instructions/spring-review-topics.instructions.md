---
description: "Review-topic registry for focused reviewer agents. Use when: routing instruction files by topic for QA, security, database, i18n, or performance review agents."
applyTo: "**/spring-review-*.agent.md, **/spring-orchestrator.agent.md, **/spring-verifier.agent.md"
---

# Spring Review Topics

## Rules

- Treat this file as the canonical mapping between review topics and instruction files.
- Keep each instruction file in exactly one topic.
- Resolve applicable instruction files for a review run as follows:
  1. Start from the instruction files mapped to the active topic.
  2. Keep a mapped instruction file only when its `applyTo` matches at least one path under review, or the ADR maps that instruction file to a reviewed file.
  3. If the filtered set is empty, return `STATUS: PASS` with an empty `ISSUES` section.
- Leave these instruction files intentionally unreviewed by topic reviewers: `.github/instructions/spring-boot-readme.instructions.md`, `.github/instructions/spring-review-topics.instructions.md`, `.github/instructions/ai-customization.instructions.md`.
- Topic `qa`: `.github/instructions/spring-boot-architecture.instructions.md`, `.github/instructions/spring-boot-java-style.instructions.md`, `.github/instructions/spring-boot-logging.instructions.md`, `.github/instructions/spring-boot-controller.instructions.md`, `.github/instructions/spring-boot-service.instructions.md`, `.github/instructions/spring-boot-test.instructions.md`, `.github/instructions/spring-boot-dto-mapper.instructions.md`, `.github/instructions/spring-boot-openapi.instructions.md`, `.github/instructions/spring-boot-pom.instructions.md`, `.github/instructions/spring-boot-application.instructions.md`, `.github/instructions/spring-boot-enum.instructions.md`, `.github/instructions/spring-boot-error-code.instructions.md`, `.github/instructions/spring-boot-api-versioning.instructions.md`, `.github/instructions/spring-boot-thymeleaf.instructions.md`, `.github/instructions/spring-boot-websocket.instructions.md`, `.github/instructions/spring-boot-container.instructions.md`, `.github/instructions/spring-boot-gitignore.instructions.md`.
- Topic `security`: `.github/instructions/spring-boot-security.instructions.md`, `.github/instructions/spring-boot-config.instructions.md`, `.github/instructions/spring-boot-actuator.instructions.md`, `.github/instructions/spring-boot-http-client.instructions.md`, `.github/instructions/spring-boot-exception.instructions.md`.
- Topic `database`: `.github/instructions/spring-boot-repository.instructions.md`, `.github/instructions/spring-boot-database-schema.instructions.md`, `.github/instructions/spring-boot-model.instructions.md`.
- Topic `i18n`: `.github/instructions/spring-boot-i18n.instructions.md`.
- Topic `performance`: `.github/instructions/spring-boot-pagination.instructions.md`, `.github/instructions/spring-boot-async-events.instructions.md`.
