---
description: "Async processing and internal event rules: Spring Application Events for cross-package communication and @Async for heavy I/O listeners."
applyTo: "**/*Event.java, **/*Listener.java, **/*Publisher.java"
---

# Async and Event Rules

## Application Events
- Use Spring Application Events (`ApplicationEventPublisher`) for cross-package communication to avoid circular service dependencies
- Event payloads must be immutable Java records
- Publish events from dedicated `*Publisher` components; do not publish directly from repositories
- If an async listener requires the user's locale, identity, or security context (e.g., for i18n emails or audit logging), the publisher must extract these values from `LocaleContextHolder`/`SecurityContextHolder` and pass them explicitly inside the immutable event record payload; never access `ThreadLocal` context directly inside an `@Async` listener

## Listeners
- Annotate listeners with `@EventListener`
- Use `@TransactionalEventListener` instead when the listener must run after the publishing transaction has committed (e.g. sending a notification after a record is persisted)
- Annotate listeners that perform heavy I/O with `@Async` to avoid blocking the publishing thread
- Keep fast in-memory listeners synchronous when strict ordering or immediate visibility is required

## @Async Configuration
- Do not configure custom `ThreadPoolTaskExecutor` beans for `@Async`; virtual threads are enabled globally, so Spring Boot uses the default virtual thread executor
- Ensure `@EnableAsync` is present on a configuration class when any `@Async` listener exists
- Verify virtual thread execution by checking startup logs or thread names that include `VirtualThread`

## When to Use @Async
- Use `@Async` for listeners that perform blocking I/O operations expected to exceed 100ms (e.g., external API calls, file I/O, messaging, or email sending)
- Use measured latency from local profiling, integration tests, or staging to justify `@Async`; do not guess thresholds
- Do not use `@Async` for CPU-bound in-memory transformations or short non-blocking logic
- Use synchronous listeners for simple, fast operations where ordering and immediate visibility are more important than parallelism

## Templates

```java
public record UserCreatedEvent(Long userId, String localeTag, String role) {
}
```

```java
@Component
class UserEventPublisher {

	private final ApplicationEventPublisher eventPublisher;

	UserEventPublisher(ApplicationEventPublisher eventPublisher) {
		this.eventPublisher = eventPublisher;
	}

	void publishUserCreated(Long userId) {
		String localeTag = LocaleContextHolder.getLocale().toLanguageTag();
		eventPublisher.publishEvent(new UserCreatedEvent(userId, localeTag, "ROLE_USER"));
	}
}
```

```java
@Component
class UserCreatedListener {

	@EventListener
	@Async
	void onUserCreated(UserCreatedEvent event) {
		// Use event.localeTag() instead of LocaleContextHolder inside async listeners.
	}
}
```

```java
@Component
class UserCreatedAfterCommitListener {

	@TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
	void onUserCreatedAfterCommit(UserCreatedEvent event) {
		// Execute only after transaction commit.
	}
}
```

