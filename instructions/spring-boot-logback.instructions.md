---
description: "Spring Boot Logback contract for sink routing, structured output, and resilient transport configuration in production-grade projects."
applyTo: "**/src/main/resources/logback-spring.xml, **/src/main/resources/log/logback-spring.xml"
---

# Spring Boot Logback Contract
Use this file to enforce log transport and formatting configuration.

## Sink Routing and Portability
1. Keep sink selection externalized by profile and configuration.
2. Keep default file logging available as safe fallback.
3. Keep sink changes (text, JSON, Datadog, Loki, or equivalent) in Logback/config only.
4. Keep sink-specific endpoints, credentials, and appender wiring in Logback or environment-backed configuration only.

## Appenders and Encoders
1. Use explicit appender names for console, file, and remote sinks.
2. Use structured encoders when log consumers require machine parsing.
3. Keep plain text encoder support when human-readable local debugging is required.
4. Keep pattern and field definitions deterministic across environments.

## Async and Reliability
1. Wrap remote or high-latency appenders with async buffering.
2. Configure queue size and discard strategy explicitly.
3. Keep backpressure behavior explicit to avoid hidden application stalls.
4. Do not block request-processing threads on remote sink unavailability.

## Profile Strategy
1. Keep development profile with console visibility and developer-friendly detail.
2. Keep production profile focused on durable sinks and minimal console noise.
3. Keep root level and appender mapping explicit per profile.

## Security and Data Protection
1. Mask or exclude sensitive fields at encoder/layout level.
2. Keep stacktrace and exception rendering policy aligned with security requirements.
3. Avoid logging transport credentials in configuration or status logs.

## Performance and Retention
1. Keep rolling policy explicit for file sinks.
2. Bound retention by age and total size.
3. Keep log format and payload size efficient for high-throughput paths.

## Operational Verification
1. Validate startup with each supported sink profile.
2. Validate fallback behavior when remote sink is unreachable.
3. Validate structured output schema when JSON logging is enabled.
