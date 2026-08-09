---
description: "Spring Boot async-events contract for deterministic event publication, consumer processing, and resilient delivery semantics."
applyTo: "**/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*Listener*.java, **/src/main/java/**/*AsyncConfiguration*.java"
---

# Spring Boot Async Events

## Naming Conventions
- Name event classes using past-tense domain verbs with the `*Event` suffix (e.g., `UserCreatedEvent`, `OrderShippedEvent`).
- Do not use present-tense or generic event names such as `UserEvent` or `DataChangedEvent`.

## Rules
- Keep events immutable and self-contained.
- Keep publication logic isolated in dedicated publisher components.
- Keep listener responsibilities single-purpose and side-effect scoped.
- Keep thread-local or request-derived data extracted before async handoff when it is needed after dispatch.
- Keep locale, security, tracing, and request-derived values copied into the event payload before async handoff when listeners require them.
- Keep async enablement explicit at application configuration level when Spring application events or method-level async execution are used.
- Keep asynchronous execution boundaries explicit in the transport or framework model.
- Treat broker-managed listeners as explicit async boundaries when messaging infrastructure controls dispatch.
- Design listener logic to be idempotent.
- Place blocking workloads in dedicated listener classes with an explicit threadpool, error handling strategy, and failure propagation model defined in configuration.
- Keep publisher and consumer failure strategies explicit.
- Configure a dead-letter queue (DLQ) for every broker-backed message queue that has business significance.
- Declare a `JacksonJsonMessageConverter` bean in the broker configuration class to enable JSON serialization for `RabbitTemplate` and `@RabbitListener` bindings.
- Declare all business-significance broker queues as durable.
- Use `DirectExchange` for routing-key-based delivery, `FanoutExchange` for broadcast to all bound queues, and `TopicExchange` for wildcard routing patterns.
- Serialize broker event payloads as JSON by default.
- Use typed deserialization targets at the consumer boundary.
- Always call `Thread.currentThread().interrupt()` after catching `InterruptedException` in a listener before returning or rethrowing.

## Safety Guards
- Never treat broker-managed consumers as synchronous request handlers.
- Never allow failed broker messages to be silently dropped.
- Never deserialize broker messages into raw `Object` or `Map`.
