---
description: "Logging rules: @Slf4j, i18n keys for all log messages, log level selection, and what must never be logged."
applyTo: "**/*.java"
---

# Logging Rules

For logback configuration guidance, see `spring-boot-logback.instructions.md`.
For MDC key contracts and HTTP correlation propagation, see `spring-boot-observability.instructions.md`.

## Scope: All Operator-Facing Text
- Apply this i18n rule to operator-facing logs, operational exception messages, and human-readable string constants
- Define all such text as i18n keys in `messages.properties`; never hardcode English text
For HTTP response error rendering and locale-aware user-facing messages, see `spring-boot-exception.instructions.md` and `spring-boot-i18n.instructions.md`.

## Rules

- Add `@Slf4j` (Lombok) to a class when it contains at least one `log.*` call; never declare `private static final Logger` manually
- Never hardcode message text as string literals in log statements; define all log message templates in `messages.properties` and resolve them by key before passing to the logger
- Resolve log message keys via a project-level `LogMessages` utility; inject it via constructor
- Logs are always developer-facing and always in English — never resolve log messages with the request locale; locale-aware rendering applies only to HTTP responses
- Use `logMessages.get(LOG_CONSTANT, args...)` in log statements; never pass a key string literal directly (e.g. `log.debug(logMessages.get(LOG_USER_NOT_FOUND, id))`, not `log.debug("User {} not found", id)`)
- Declare i18n key constants as `private static final String` at class top with descriptive names aligned to event intent (e.g., `LOG_USER_CREATED`)
- Add logs for important lifecycle events (startup, connect/disconnect, external calls, publish/consume)
- Use `DEBUG` for noisy flow details and `INFO` for business or lifecycle milestones
- Do not wrap ordinary `log.debug(...)` with `if (log.isDebugEnabled())`; use guards only for expensive arguments or hot loops/high-throughput paths

## Compliance Check: Identifying Hardcoded Text
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

## Logging Layers: Where to Log

**Logging belongs ONLY in the service layer for business operations.** Controllers and repositories do not log business events.

### By Component

**Controller (REST Handlers)**
- Log HTTP-level concerns only: unexpected 5xx errors (at `ERROR`), redirect decisions (at `DEBUG`)
- **Never log** state transitions (create/update/delete), business events, or operation results — these belong in the service layer
- Keep successful request flow logging at `DEBUG` or omit if not needed for HTTP diagnostics
- No @Slf4j; no LogMessages injection

**Service Layer**
- Log ALL state transitions: create/update/delete operations at `INFO` with i18n message keys
- Log external integration calls: start, latency, outcome (success/failure) at `INFO`
- Log payload details only at `DEBUG` level when needed for diagnosis
- Use @Slf4j and LogMessages for all logging
- This is the ONLY layer where business operation logging happens

**Repository / Data Access**
- Do not log business events or state transitions in repositories; keep those logs in the service layer
- Log only technical persistence diagnostics when needed (query intent, row count, retry/failure context)
- Keep repository logs low-noise: prefer `DEBUG`; use `INFO` only for lifecycle-level operational events explicitly required by the feature
- If a repository emits logs, use @Slf4j with i18n keys resolved through LogMessages

**Listener/Consumer/Integration Client**
- Log lifecycle: connect/disconnect events
- Log operation outcomes: success/failure at `INFO`
- Log latency for external calls at `INFO`
- Use @Slf4j and LogMessages

