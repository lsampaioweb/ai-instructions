---
description: "Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics in production-grade projects."
applyTo: "**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*Rabbit*Configuration*.java, **/src/main/resources/application*.yml, **/pom.xml"
---

# Spring Boot Async-Events Engine

## Scope & Analysis
- Inspect event types, event publishers, and event listeners.
- Inspect thread-context handling around event publication.
- Inspect asynchronous execution boundaries and listener responsibilities.

## Dependencies
- For application-level @EventListener async dispatch, use Spring's built-in ApplicationEventPublisher (no additional dependency required).
- For message-broker-based async events (RabbitMQ, Kafka), add `spring-boot-starter-amqp` (RabbitMQ) or `spring-kafka` dependency in pom.xml.
- For RabbitMQ configuration, also add `spring-boot-starter-amqp` and configure connection details in application.yml.

## Naming Conventions
- Name event classes using past-tense domain verbs with the `*Event` suffix (e.g., `UserCreatedEvent`, `OrderShippedEvent`); never use present-tense or generic names like `UserEvent` or `DataChangedEvent`.

## Resolution Rules
- Keep events immutable and self-contained.
- Keep publication logic isolated in dedicated publisher components.
- Keep listener responsibilities single-purpose and side-effect scoped.
- Keep thread-local or request-derived data extracted before async handoff when it is needed after dispatch.
- Keep locale, security, tracing, and request-derived values copied into the event payload before async handoff when listeners require them.
- Keep async enablement explicit at application configuration level when Spring application events or method-level async execution are used.
- Keep asynchronous execution boundaries explicit in the transport or framework model.
- Treat broker-managed listeners as explicit async boundaries when messaging infrastructure controls dispatch.
- Design listener logic to be idempotent; assume any event may be delivered more than once due to broker retry semantics.
- Place blocking workloads in dedicated listener classes with an explicit threadpool, error handling strategy, and failure propagation model defined in configuration.
- Keep publisher and consumer failure strategies explicit for non-trivial async flows.
- Configure a dead-letter queue (DLQ) for every broker-backed message queue that has business significance; never allow failed messages to be silently dropped.
- Serialize broker event payloads as JSON by default; use typed deserialization targets at the consumer boundary; never deserialize broker messages into raw `Object` or `Map`.

## Safety Guards
- Never publish mutable event payloads across async boundaries.
- Never rely on thread-local context after async dispatch.
- Never treat broker-managed consumers as synchronous request handlers.
- Never introduce blocking listener work without an explicit async boundary and failure strategy.
- Never introduce async processing for critical paths without failure strategy.

## Review Plan Layout
- Report event contracts added or changed.
- Report publisher and listener flow changes.
- Report async execution decisions and rationale.
- Report transport or framework boundaries used for asynchronous execution.
- Report listener failure strategy, including retry, dead-lettering, propagation, or documented log-only handling.
- Report ordering, retry, or delivery-risk assumptions.

