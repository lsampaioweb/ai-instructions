---
description: "Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics in production-grade projects."
applyTo: "**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*Configuration*.java, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml"
---

# Spring Boot Async Events Contract
Use this file to enforce deterministic asynchronous event behavior.

## Scope
1. Apply to in-process event publication, message broker producers and consumers, and event-related runtime configuration.
2. Keep asynchronous orchestration feature-local and explicitly bounded.

## Event Contract Rules
1. Keep event payload schemas explicit, versioned, and backward-compatible during rollout windows.
2. Keep event identity explicit with deterministic event id and event timestamp fields.
3. Keep routing metadata explicit for exchange, topic, queue, or channel selection.
4. Keep event serialization format explicit and stable across producers and consumers.

## Producer Rules
1. Keep producer publish paths explicit for exchange and routing-key selection.
2. Keep producer failures mapped to deterministic application exceptions.
3. Keep publish operation logging bounded and correlated with event id.
4. Keep producer configuration externalized for exchange, queue, and routing settings.

## Consumer Rules
1. Keep consumer bindings explicit with queue names externalized in configuration.
2. Keep consumer processing idempotent for duplicate-delivery safety.
3. Keep consumer failure handling explicit for retry, dead-letter, or discard policy.
4. Keep interruption handling explicit and restore thread interruption state when interrupted.

## Delivery and Consistency Rules
1. Keep delivery guarantees explicit as at-most-once, at-least-once, or exactly-once-equivalent with idempotency.
2. Keep retry policies bounded by max attempts, backoff strategy, and terminal failure path.
3. Keep dead-letter destination and reprocessing policy explicit as terminal failure behavior.
4. Keep database state transitions and external publication consistency explicit through transactional or outbox strategy.

## Security and Safety Rules
1. Keep broker credentials and connection settings externalized in secret-backed configuration.
2. Forbid sensitive payload fields in event logs unless redacted by policy.
3. Keep allowed broker endpoints bounded by explicit configuration.
4. Keep deserialization types constrained to trusted event classes.

## Quality Gates
1. Forbid ad-hoc broker topology creation inside business services.
2. Forbid silent event publication failures.
3. Keep tests covering publish success, publish failure, consumer retry behavior, and poison-message terminal handling.
4. Keep profile-specific messaging behavior deterministic across development, test, and production.
