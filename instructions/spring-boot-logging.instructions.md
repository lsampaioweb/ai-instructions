---
description: "Logging rules: @Slf4j, i18n keys for all log messages, log level selection, and what must never be logged."
applyTo: "**/*.java"
---

# Logging Rules

## Rules

- Use `@Slf4j` (Lombok) on every class that logs; never declare `private static final Logger` manually
- Never hardcode message text as string literals in log statements; define all log message templates in `messages.properties` and resolve them by key before passing to the logger
- Resolve log message keys via a project-level `LogMessages` utility; inject it via constructor; logs are always developer-facing and always in English — never resolve log messages with the request locale; see `## Templates` for the implementation
- Use `logMessages.get(LOG_CONSTANT, args...)` in log statements; never pass a key string literal directly (e.g. `log.debug(logMessages.get(LOG_USER_NOT_FOUND, id))`, not `log.debug("User {} not found", id)`)
- Declare i18n key constants as `private static final String` at the top of the class; see `spring-boot-architecture.instructions.md` for the constant naming rule

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
- Inside tight loops or high-throughput paths without a level guard: `if (log.isDebugEnabled())`

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
