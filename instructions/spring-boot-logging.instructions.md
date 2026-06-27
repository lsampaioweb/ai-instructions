---
description: "Logging rules: @Slf4j, i18n keys for all log messages, log level selection, and what must never be logged."
applyTo: "**/*.java"
---

# Logging Rules

## Scope: All Developer/Operator-Facing Text
The i18n principle in these rules applies to **operator/developer operational text**, not only log statements. This includes:
- Log messages (via `log.info()`, `log.debug()`, etc.)
- Exception messages thrown by services, utilities, and integration clients
- String constants containing human-readable text

All such text must be defined as i18n keys in `messages.properties`, never hardcoded. Exception messages and error text follow the same pattern as logs: define a message key constant, resolve it via `LogMessages` (for operational/startup exceptions) or `MessageSource` (for HTTP-facing domain exceptions), and never embed English text in constants.
For HTTP response error rendering and locale-aware user-facing messages, follow `spring-boot-exception.instructions.md` and `spring-boot-i18n.instructions.md`.

## Rules

- Use `@Slf4j` (Lombok) on every class that logs; never declare `private static final Logger` manually
- Never hardcode message text as string literals in log statements; define all log message templates in `messages.properties` and resolve them by key before passing to the logger
- Resolve log message keys via a project-level `LogMessages` utility; inject it via constructor
- Logs are always developer-facing and always in English — never resolve log messages with the request locale; see `## Templates` for the implementation
- Use `logMessages.get(LOG_CONSTANT, args...)` in log statements; never pass a key string literal directly (e.g. `log.debug(logMessages.get(LOG_USER_NOT_FOUND, id))`, not `log.debug("User {} not found", id)`)
- Declare i18n key constants as `private static final String` at the top of the class with descriptive names aligned to event intent (for example `LOG_USER_CREATED`)
- Add logs for important lifecycle events (startup, connect/disconnect, external calls, publish/consume)
- Prefer `DEBUG` for noisy flow details and `INFO` for business or lifecycle milestones
- Do not wrap ordinary `log.debug(...)` with `if (log.isDebugEnabled())`; use guards only for expensive arguments or hot loops/high-throughput paths

## Audit Scope: Identifying Hardcoded Text
When auditing compliance, check for hardcoded text violations in:
1. **Exception messages**: String literals in `throw new Exception("text")` or exception message constants
2. **String constants**: Any `private static final String` holding English text (should hold message keys instead)
3. **Validation errors**: Custom error messages not resolved from `messages.properties`
4. **Startup warnings/errors**: Any printed output or log statements with embedded text

Use `grep` or IDE search to find patterns: hardcoded strings longer than 2 words, constants ending in `_MESSAGE`, `_ERROR`, `_WARNING`, exception constructors with string literals.

## Log Levels

| Level   | When to use |
|---------|-------------|
| `ERROR` | Unrecoverable failure; always include the exception as the last argument |
| `WARN`  | Recoverable issue; unexpected but non-fatal state |
| `INFO`  | Service started, significant business event (order created, user registered) |
| `DEBUG` | Internal state during processing; disabled in production |
| `TRACE` | High-frequency or low-level detail; disabled in all non-local environments |

## What Not to Log

- Passwords, API keys, tokens, secrets, or any masked version of them
- Full request or response bodies that may contain PII
- Stack traces at `INFO` or `DEBUG` level; reserve those for `ERROR`
- Expensive debug message construction inside tight loops or high-throughput paths without a level guard: `if (log.isDebugEnabled())`

## Minimum Logging by Component

- Controller: log request handling only when it adds operational value
- Service: log business milestones and external call boundaries
- Listener/Consumer: log connect/disconnect and consume outcomes
- Integration client: log target operation, latency, and failures

## Logback Configuration
- Place `logback-spring.xml` under `src/main/resources/log/`.
- Add all profile-based appenders:
- `development` profile: console appender + async file appender at `DEBUG` level
- `production` and default profiles: async file appender only at `INFO` level

File rotation settings:
- `maxFileSize`: 10MB
- `totalSizeCap`: 1GB
- `maxHistory`: 7 (days to retain)

### Working Directory & Path Resolution
Relative paths in `logback-spring.xml` resolve from the JVM's working directory. To ensure consistent log placement across Maven and IDE launches:

1. **POM configuration**: Set `<workingDirectory>${project.basedir}</workingDirectory>` in `spring-boot-maven-plugin` (required; ensures Maven always uses the project folder, even when run from a parent folder)
2. **IDE configuration**: Create `.vscode/launch.json` (or IntelliJ Run Configuration) with `cwd` pointing to the project folder:
   - **VSCode**: `"cwd": "${workspaceFolder}/<project-folder>"`
3. **Logback configuration**: Use `<springProperty>` to make the log path configurable:
   ```xml
   <springProperty name="LOG_PATH" source="app.logging.path" defaultValue="logs" />
   ```
   Define the property in `application.yml`:
   ```yaml
   app:
     logging:
       path: logs
   ```
   This allows overriding via environment variables if needed, but provides a sensible default that resolves relative to the working directory.

## Templates

**LogMessages utility.** Same in every project — inject `MessageSource` via constructor.

```java
@Component
public class LogMessages {

  private final MessageSource messageSource;

  LogMessages(MessageSource messageSource) {
    this.messageSource = messageSource;
  }

  public String get(String key, Object... args) {
    return get(Locale.ENGLISH, key, args);
  }

  public String get(Locale locale, String key, Object... args) {
    return messageSource.getMessage(key, args, locale);
  }
}
```
