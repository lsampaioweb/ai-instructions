---
description: "Observability rules: pluggable log appenders, structured logging fields, and MDC correlation propagation."
applyTo: "**/src/main/resources/log/logback-spring.xml, **/src/main/resources/logback-spring.xml, **/*Filter.java, **/*Interceptor.java, **/*Configuration.java, **/application*.yml, **/pom.xml"
---

# Observability Rules

## Scope
- Use this file as the canonical source for log backend portability, structured logging, and MDC correlation propagation.
- Keep Java log message wording and log levels in `spring-boot-logging.instructions.md`.
- Keep base Logback placement and rotation rules in `spring-boot-logback.instructions.md`.

## Appender Portability
- Define appenders once and switch by profile or configuration properties.
- Use stable appender aliases (`CONSOLE_TEXT`, `FILE_JSON`, `LOKI_JSON`, `DATADOG_JSON`) so backend switches do not change logger usage.
- Reference only appender aliases from `<root>` and package-level logger blocks.
- Do not require service or controller code changes when changing log destination backends.

## Structured Logging
- Use JSON logging in production and default profiles.
- Include these fields in structured output: `timestamp`, `level`, `logger`, `thread`, `message`, `correlationId`, `userId`, `service`, `environment`.
- Keep field names stable across appenders so downstream queries do not break during backend swaps.
- If `logstash-logback-encoder` is used, define the dependency in `pom.xml` and keep the version source aligned with `spring-boot-pom.instructions.md`.

## Correlation and MDC
- Use `X-Correlation-ID` as the inbound and outbound HTTP header name.
- Use MDC keys `correlationId` and `userId`.
- Generate a correlation ID when the request header is absent.
- Put MDC values at request start and clear them in a `finally` block.
- Return `X-Correlation-ID` in the HTTP response headers for every handled request.
- Never place secrets or tokens in MDC fields.

## HTTP Propagation Component
- Implement correlation propagation in a `OncePerRequestFilter` for REST applications.
- Keep the filter stateless and thread-safe.
- Apply the filter before request handling so all downstream logs include MDC context.

## Backend Swap Procedure
- Change only appender definitions and backend destination properties when moving between file, Loki, Datadog, or other sinks.
- Keep application logging calls unchanged during backend swaps.
- Verify that required structured fields and MDC keys remain present after each swap.
