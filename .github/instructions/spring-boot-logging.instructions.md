---
description: "Spring Boot logback-spring.xml logging configuration with console and file appenders, log-level policy, and MDC correlation."
applyTo: "**/logback-spring.xml, **/*Controller.java, **/*Service.java, **/*ServiceImpl.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Filter.java, **/*Interceptor.java, **/*Advice.java"
---

## Dependencies
- Follow `spring-boot-i18n.instructions.md` for the `*LogMessages` component contract used to resolve log message strings.
- Follow `spring-boot-java-style.instructions.md` for class-level formatting, imports, and visibility.

## Rules

### Logging behavior
- Use `@Slf4j` for logger declaration in every class that emits log events.
- Use `*LogMessages` components to resolve all log message strings through i18n keys; pass the resolved string as the sole argument to `log.LEVEL()`.
- Use `{}` placeholders only for raw log statements not routed through a `*LogMessages` component.
- Add the request correlation identifier to MDC under the key `traceId` before processing begins; clear it from MDC after request processing completes.
- Include correlation identifiers when available in log statements.
- Use DEBUG level for development-time diagnostic events that have no operational value in production.
- In controller classes, log only warning and error conditions.
- In service classes, log business state transitions (create, update, delete) at INFO level with stable resource identifiers.
- In repository classes, log degraded execution paths (for example, SQL feature fallback) at WARN level.
- Log unexpected exceptions at ERROR level; log known domain failures that map to 4xx responses at WARN level.
- Keep exception logs single-source.
- Use structured log fields when the active logging sink supports structured ingestion.

### File location and naming
- Place the file at `src/main/resources/log/logback-spring.xml`.
- Reference it from application.yml as `logging.config: "classpath:log/logback-spring.xml"`.

### Required structure
- Define the Spring properties `spring.application.name` (into context variable `APPLICATION_NAME`) and `logging.file.path` (into context variable `LOG_DIR` with `defaultValue="./logs"`).
- Define three appenders: Console, RollingFile, and File (AsyncAppender wrapper).

### Console appender
- Use colored output for readability: black timestamp, highlighted level, blue thread, yellow logger.
- Use this pattern: `%black(%d{ISO8601}) %highlight(%-5level) [%blue(%t)] %yellow(%logger{60}): %msg%n%throwable`.
- Write to stdout only for development and debug visibility.

### RollingFile and async appenders
- Use `RollingFileAppender` with `SizeAndTimeBasedRollingPolicy` and encoder pattern `%d{ISO8601} %-5level [%t] %logger{60}: %msg%n%throwable`.
- Use the file naming pattern `${LOG_DIR}/${APPLICATION_NAME}.log`.
- Use archived files in `${LOG_DIR}/archived/${APPLICATION_NAME}-%d{yyyy-MM-dd}.%i.gz` for gzip rotation.
- Keep the rolling policy values configurable through application.yml `logging.file.*` properties.
- Set rotation limits: `maxFileSize=10MB`, `maxHistory=7`, `totalSizeCap=1GB`; declare all rotation limits explicitly in the rolling policy.
- Wrap the rolling file appender in an `AsyncAppender` named `File` to avoid blocking.
- Declare elements in this order within the async appender: `queueSize`, `discardingThreshold`, `appender-ref`.
- Set `queueSize=512` and `discardingThreshold=0` on the async appender.

### Configurable rolling policy properties
- Set `logging.file.max-size` to the rotation threshold, for example `10MB`.
- Set `logging.file.max-history` to the number of days to keep archived logs, for example `7`.
- Set `logging.file.total-size-cap` to the total disk-space cap for all logs, for example `1GB`.

### Spring profiles
- Route the `debug` profile to Console and File appenders with root level `DEBUG`.
- Route the `development` profile to Console and File appenders with root level `INFO`.
- Route the `default | production` profiles to the File appender only with root level `INFO`, with no console output.
- Use structured encoders when the log aggregation sink requires structured ingestion.

## Safety Guards
- Never emit high-volume logs inside tight loops.
- Never log credentials, tokens, or personal data.
- Never route sensitive data to unprotected appenders.
- Never disable error logging for application failures.

## Reference
- Use [samples/spring-boot-logging.tpl](samples/spring-boot-logging.tpl) for `logback-spring.xml`.
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for the related `logging.file.*` properties.
