---
description: "Spring application event publishing, event listeners, asynchronous event infrastructure, and broker-backed messaging."
applyTo: "**/*EventPublisher.java, **/*EventListener.java, **/*EventsListener.java, **/*ApplicationListener.java, **/*AuditListener.java, **/*PublishedEvent.java, **/src/main/java/**/*Event*.java, **/src/main/java/**/*Publisher*.java, **/src/main/java/**/*Consumer*.java, **/src/main/java/**/*AsyncConfiguration*.java"
---

## Dependencies
- Follow `spring-boot-java-style.instructions.md` for Java formatting, imports, visibility, injection, constants, and JavaDoc.
- Follow `spring-boot-model.instructions.md` for immutable event records when the event is a domain model type.
- Follow `spring-boot-i18n.instructions.md` when event listeners emit localized log messages.

## Naming Conventions
- Name an event publisher `{Feature}EventPublisher`.
- Name an immutable published event `{Feature}PublishedEvent`, using past-tense domain verbs (e.g., `UserCreatedEvent`, `OrderShippedEvent`).
- Do not use present-tense or generic event names such as `UserEvent` or `DataChangedEvent`.
- Name a listener after its side effect, such as `{Feature}AuditListener`.
- Name a framework lifecycle listener after the lifecycle events it observes, such as `WebSocketSessionEventsListener`.
- Name published-event handlers `on{Feature}Published(...)` and lifecycle-event handlers after the observed event, such as `onSessionConnected(...)`.

## Rules

### Event publication
- Inject `ApplicationEventPublisher` through the publisher constructor.
- Publish an immutable event record when a side effect must be decoupled from the originating operation.
- Include only the event data needed by listeners; do not publish mutable domain objects.
- Capture event timestamps in UTC when an event records when it occurred.
- Capture request locale as a language tag when an asynchronous listener needs locale context after the originating request ends.
- Keep locale, security, tracing, and other request-derived values copied into the event payload before async handoff when listeners require them.

### Event listeners
- Annotate event-listener components with `@Component`.
- Handle published events with `@EventListener` methods whose parameter declares the event type.
- Keep listener logic focused on its own side effect, such as audit logging or connection tracking.
- Resolve listener log messages through the project `LogMessages` component when logging is required.
- Design listener logic to be idempotent.

### Asynchronous infrastructure
- Update the owning application class with `@EnableAsync` when the application requires asynchronous event handling.
- Do not add `@Async` to an event listener unless its execution order, transaction boundary, and failure handling are explicitly defined.
- Place blocking workloads in dedicated listener classes with an explicit threadpool, error handling strategy, and failure propagation model defined in configuration.
- Always call `Thread.currentThread().interrupt()` after catching `InterruptedException` in a listener before returning or rethrowing.

### Broker-backed messaging
- Treat broker-managed listeners as explicit async boundaries when messaging infrastructure controls dispatch.
- Keep publisher and consumer failure strategies explicit.
- Configure a dead-letter queue (DLQ) for every broker-backed message queue that has business significance.
- Declare a `JacksonJsonMessageConverter` bean in the broker configuration class to enable JSON serialization for `RabbitTemplate` and `@RabbitListener` bindings.
- Declare all business-significance broker queues as durable.
- Use `DirectExchange` for routing-key-based delivery, `FanoutExchange` for broadcast to all bound queues, and `TopicExchange` for wildcard routing patterns.
- Serialize broker event payloads as JSON by default.
- Use typed deserialization targets at the consumer boundary; do not deserialize into raw `Object` or `Map`.

### Verification
- Add or update tests for event publishers and listeners when the event side effect has observable behavior.
- Test that an event carries all data required after the originating request has completed.

## Safety Guards
- Never treat broker-managed consumers as synchronous request handlers.
- Never allow failed broker messages to be silently dropped.

## Reference
- Use [samples/spring-boot-event-publisher.tpl](samples/spring-boot-event-publisher.tpl) for application event publishers.
- Use [samples/spring-boot-published-event.tpl](samples/spring-boot-published-event.tpl) for immutable published event records.
- Use [samples/spring-boot-event-listener.tpl](samples/spring-boot-event-listener.tpl) for event-listener components.
- Use [samples/spring-boot-async-application.tpl](samples/spring-boot-async-application.tpl) when enabling asynchronous execution.
