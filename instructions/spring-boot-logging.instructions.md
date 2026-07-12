---
description: "Spring Boot logging contract for secure, consistent, and operationally useful application log events in production-grade projects."
applyTo: "**/src/main/java/**/*.java, **/src/test/java/**/*.java"
---

# Spring Boot Logging Contract
Use this file to enforce application logging behavior.

## Abstraction and DI
1. Keep application and domain code dependent on a logging abstraction, not a vendor SDK.
2. Keep transport-specific logging (file, JSON, Datadog, Loki, or equivalent) behind adapter implementations.
3. Select logging adapter implementation through Spring configuration and dependency injection.
4. Keep a safe default adapter available when no external sink is enabled.
5. Do not import vendor-specific logging clients outside infrastructure adapter packages.

## Event Design
1. Log business state transitions, integration call outcomes, and failure events with operation context; do not log method-entry or loop-iteration noise.
2. Keep one primary success log per operation boundary where observability is needed.
3. Keep error logs actionable with operation context and outcome.

## Level Rules
1. Use DEBUG for diagnostic detail.
2. Use INFO for lifecycle and business-relevant state changes.
3. Use WARN for recoverable abnormal conditions.
4. Use ERROR for failed operations and unhandled exceptions.

## Message Rules
1. Use parameterized logging; do not build messages with string concatenation.
2. Keep message templates stable and concise.
3. Include stable identifiers for traceability.
4. Avoid duplicate logs for the same failure across adjacent layers.

## Security and Privacy
1. Never log secrets, credentials, tokens, private keys, or raw authorization headers.
2. Never log full sensitive payloads when redaction or summarization is required.
3. Sanitize external input before logging.
4. Keep stack traces at ERROR level only when they add remediation value.

## i18n and Consistency
1. When i18n logging infrastructure exists, use centralized message keys for log text.
2. Keep log message key naming consistent by feature and action.
3. Keep locale-dependent text deterministic for operational analysis.

## Performance and Reliability
1. Keep log volume bounded on hot paths.
2. Avoid expensive object serialization in INFO and higher-frequency logs.
3. Guard verbose logs with level checks when computation cost is non-trivial.
4. Keep remote log shipping non-blocking and resilient to transient sink failures.

## Testing and Review
1. Validate critical failure paths produce actionable logs.
2. Validate sensitive fields are not emitted in logs.
3. Treat missing contextual identifiers in critical logs as a review finding.
