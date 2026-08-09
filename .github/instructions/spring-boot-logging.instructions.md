---
description: "Spring Boot logging contract for application log events, Logback appenders, rotation, and profile-level log routing."
applyTo: "**/*Controller.java, **/*Service.java, **/*ServiceImpl.java, **/*Repository.java, **/*RepositoryImpl.java, **/*Filter.java, **/*Interceptor.java, **/*Advice.java, **/src/main/resources/**/logback-spring.xml"
---

# Spring Boot Logging Engine

## Rules
- Use `@Slf4j` for logger declaration in every class that emits log events.
- Use `*LogMessages` components to resolve all log message strings through i18n keys.
- When a `*LogMessages` component resolves the message, pass the resolved string as the sole argument to `log.LEVEL()`.
- Add the request correlation identifier to MDC under the key `traceId` before processing begins.
- Clear `traceId` from MDC after request processing completes.
- Include correlation identifiers when available in log statements.
- Use DEBUG level for development-time diagnostic events that have no operational value in production.
- In controller classes, log only warning and error conditions.
- In service classes, log business state transitions (create, update, delete) at INFO level with stable resource identifiers.
- In repository classes, log degraded execution paths (for example, SQL feature fallback) at WARN level.
- Log unexpected exceptions at ERROR level.
- Log known domain failures that map to 4xx responses at WARN level.
- Keep exception logs single-source.
- Use `{}` placeholders only for raw log statements not routed through a `*LogMessages` component.
- Use structured log fields when the active logging sink supports structured ingestion.
- Place `logback-spring.xml` under `src/main/resources/log/` to align with the `classpath:log/logback-spring.xml` reference declared in `application.yml`.
- Source application name from `spring.application.name` into context variable `APPLICATION_NAME`.
- Source log directory from `logging.file.path` into context variable `LOG_DIR` with `defaultValue="./logs"`.
- Configure a `Console` appender with encoder pattern: `%black(%d{ISO8601}) %highlight(%-5level) [%blue(%t)] %yellow(%logger{60}): %msg%n%throwable`
- Configure a `RollingFile` appender with encoder pattern: `%d{ISO8601} %-5level [%t] %logger{60}: %msg%n%throwable`
- Set the active log file path in the `RollingFile` appender: `<file>${LOG_DIR}/${APPLICATION_NAME}.log</file>`.
- Set `SizeAndTimeBasedRollingPolicy` on the `RollingFile` appender with archived file pattern: `${LOG_DIR}/archived/${APPLICATION_NAME}-%d{yyyy-MM-dd}.%i.gz`
- Set rotation limits: `maxFileSize=10MB`, `maxHistory=7`, `totalSizeCap=1GB`.
- Declare all rotation limits explicitly in the rolling policy.
- Route the `RollingFile` appender through an async appender named `File`.
- Declare elements in this order within the async appender: `queueSize`, `discardingThreshold`, `appender-ref`.
- Set `queueSize=512` and `discardingThreshold=0` on the async appender.
- Route the `debug` profile to Console and File appenders with root level `DEBUG`.
- Route the `development` profile to Console and File appenders with root level `INFO`.
- Route the `default | production` profiles to the File appender only with root level `INFO`.
- Use structured encoders when the log aggregation sink requires structured ingestion.

## Safety Guards
- Never emit high-volume logs inside tight loops.
- Never log credentials, tokens, or personal data.
- Never route sensitive data to unprotected appenders.
- Never disable error logging for application failures.
