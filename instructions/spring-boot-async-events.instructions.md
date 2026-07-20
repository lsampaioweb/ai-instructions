---
description: "Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics in production-grade projects."
applyTo: "**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*Rabbit*Configuration*.java, **/src/main/resources/application*.yml, **/pom.xml"
---

# Spring Boot Async-Events Engine

## Scope & Analysis
- Inspect event types, event publishers, and event listeners.
- Inspect thread-context handling around event publication.
- Inspect asynchronous execution boundaries and listener responsibilities.

## Resolution Rules
- Keep events immutable and self-contained.
- Keep publication logic isolated in dedicated publisher components.
- Keep listener responsibilities single-purpose and side-effect scoped.
- Keep thread-local data extracted before async handoff.
- Keep asynchronous listeners explicit for blocking workloads.
- Keep async enablement explicit at application configuration level.

## Review Plan Layout
- Report event contracts added or changed.
- Report publisher and listener flow changes.
- Report async execution decisions and rationale.
- Report ordering, retry, or delivery-risk assumptions.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never publish mutable event payloads across async boundaries.
- Never rely on thread-local context after async dispatch.
- Never introduce async processing for critical paths without failure strategy.
