---
description: "Async processing and internal event rules: Spring Application Events for cross-feature communication and @Async for heavy I/O listeners."
applyTo: "**/*Event.java, **/*Listener.java, **/*Publisher.java"
---

# Async and Event Rules

## Application Events
- Use Spring Application Events (`ApplicationEventPublisher`) to communicate between distinct feature packages
- Never inject a Service from one feature package directly into a Service from a different feature package if it creates a circular dependency; use an event instead
- Event payloads must be immutable Java records

## Listeners
- Annotate listeners with `@EventListener`
- Use `@TransactionalEventListener` instead when the listener must run after the publishing transaction has committed (e.g. sending a notification after a record is persisted)
- Annotate listeners that perform heavy I/O with `@Async` to avoid blocking the publishing thread

## @Async Configuration
- Since virtual threads are enabled globally via `spring.threads.virtual.enabled: true`, do not configure custom `ThreadPoolTaskExecutor` beans for `@Async`; let Spring Boot use the default virtual thread executor
- Ensure `@EnableAsync` is present on a configuration class when any `@Async` listener exists

## Templates

**Event record.** Replace `{Resource}` with the domain concept. Keep the record immutable — no setters, no mutable fields.

```java
public record {Resource}CreatedEvent(Long {resource}Id, String name) {}
```

**Event publisher.** Publish from the service layer after a successful state change.

```java
@Slf4j
@Service
class {Resource}ServiceImpl implements {Resource}Service {

  private final ApplicationEventPublisher eventPublisher;

  @Override
  @Transactional
  public {Resource}Response create(Create{Resource}Request request) {
    // ... save entity ...
    eventPublisher.publishEvent(new {Resource}CreatedEvent(entity.getId(), entity.getName()));

    return {resource}Mapper.toResponse(entity);
  }
}
```

**Async transactional listener.** Use `@Async` for heavy I/O. Use `@TransactionalEventListener` when the listener must run only after the publishing transaction commits.

```java
@Slf4j
@Component
class {Resource}CreatedListener {

  private static final String LOG_{RESOURCE}_CREATED = "{resource}.created.log";

  @Async
  @TransactionalEventListener
  public void on{Resource}Created({Resource}CreatedEvent event) {
    // heavy I/O: email, notification, external API call, etc.
    log.info(LogMessages.get(LOG_{RESOURCE}_CREATED), event.{resource}Id());
  }
}
```
