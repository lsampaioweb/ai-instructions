---
description: "Async processing and internal event rules: Spring Application Events for cross-feature communication and @Async for heavy I/O listeners."
applyTo: "**/*Event.java, **/*Listener.java, **/*Publisher.java"
---

# Async and Event Rules

## Application Events
- Use Spring Application Events (`ApplicationEventPublisher`) for cross-package communication to avoid circular service dependencies
- Event payloads must be immutable Java records

## Listeners
- Annotate listeners with `@EventListener`
- Use `@TransactionalEventListener` instead when the listener must run after the publishing transaction has committed (e.g. sending a notification after a record is persisted)
- Annotate listeners that perform heavy I/O with `@Async` to avoid blocking the publishing thread

## @Async Configuration
- Do not configure custom `ThreadPoolTaskExecutor` beans for `@Async`; virtual threads are enabled globally, so Spring Boot uses the default virtual thread executor
- Ensure `@EnableAsync` is present on a configuration class when any `@Async` listener exists

## When to Use @Async
- Use `@Async` for listeners that perform blocking I/O operations expected to exceed 100ms (e.g., external API calls, file I/O, messaging, or email sending)
- Do not use `@Async` for CPU-bound in-memory transformations or short non-blocking logic
- Prefer synchronous listeners for simple, fast operations where ordering and immediate visibility are more important than parallelism

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
  private final LogMessages logMessages;

  {Resource}CreatedListener(LogMessages logMessages) {
    this.logMessages = logMessages;
  }

  @Async
  @TransactionalEventListener
  public void on{Resource}Created({Resource}CreatedEvent event) {
    // heavy I/O: email, notification, external API call, etc.
    log.info(logMessages.get(LOG_{RESOURCE}_CREATED), event.{resource}Id());
  }
}
```
