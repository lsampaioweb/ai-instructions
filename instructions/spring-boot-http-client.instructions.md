---
description: "Spring Boot HTTP client contract for deterministic outbound calls, bounded resilience behavior, and secure integration boundaries in production-grade projects."
applyTo: "**/src/main/java/**/*Http*Client*.java, **/src/main/java/**/*Http*Adapter*.java, **/src/main/java/**/*Configuration*.java, **/src/main/java/**/config/**/*.java, **/src/main/java/**/*Service.java, **/src/main/java/**/*ServiceImpl.java, **/src/main/java/**/service/**/*.java, **/src/test/java/**/*Test.java, **/src/test/java/**/*Tests.java, **/src/main/resources/application*.yml, **/pom.xml"
---

# Spring Boot HTTP Client Contract
Use this file to enforce deterministic outbound HTTP integration behavior.

## Scope
1. Apply to outbound client configuration, service adapters, and external API property bindings.
2. Keep outbound integration isolated from transport controllers and persistence adapters.
3. Apply service-level rules from this file only when service code performs outbound HTTP integration.
4. Apply quality-gate test expectations in this file to tests covering outbound HTTP integration behavior.

## Coordination Order
1. Apply [spring-boot-service.instructions.md](./spring-boot-service.instructions.md) first for generic service orchestration and transaction baseline rules.
2. Apply [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) first for generic YAML configuration baseline rules.
3. Apply [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md) first for generic dependency and plugin baseline rules.
4. Apply this file for outbound HTTP integration constraints when HTTP client behavior is in scope.

## Client Selection Rules
1. Use RestClient as the default imperative outbound client for non-reactive applications.
2. Use WebClient for reactive, streaming, or non-blocking integration flows.
3. Use HTTP Service interface clients for strongly typed external API contracts when interface-based clients are in scope.
4. Restrict RestTemplate usage to pre-existing legacy integrations with an explicit migration plan to RestClient or WebClient.

## Configuration Rules
1. Keep external endpoint URLs externalized in configuration properties.
2. Keep RestClient or WebClient builders defined in configuration classes.
3. Keep client base URL construction deterministic from validated properties.
4. Keep connect and read timeout strategy explicit for production profiles.
5. Keep auto-configured client builders as the default entry point for outbound client construction.

## Request and Response Rules
1. Keep URI templates explicit and parameterized.
2. Keep outbound DTO mapping in dedicated mapper or adapter methods, not inline in business orchestration methods.
3. Keep pagination and sorting query parameter mapping explicit when upstream supports paging.
4. Keep null or empty upstream payload handling deterministic and documented.

## Error and Resilience Rules
1. Keep upstream 4xx and 5xx handling mapped to deterministic application exceptions.
2. Keep retry behavior explicit, bounded, and idempotency-aware.
3. Keep fallback behavior explicit and domain-safe when enabled.
4. Keep outbound call latency and failure logs aligned with logging and error-code contracts.
5. Keep status-handler behavior explicit for client-wide and per-call error semantics.
6. Log caught outbound failure exceptions at WARN for recoverable flows and ERROR for terminal operation failures.

## Security Rules
1. Keep outbound credentials and tokens externalized in secret-backed properties.
2. Forbid logging outbound authorization headers, tokens, or sensitive payload fields.
3. Keep TLS and certificate validation enabled for production endpoints.
4. Keep allowed outbound hosts bounded by explicit configuration.

## Quality Gates
1. Forbid hardcoded production endpoint URLs in service classes.
2. Forbid ad-hoc client creation inside business methods.
3. Keep tests covering success, timeout, upstream error, and malformed response paths.
4. Keep profile-specific behavior deterministic across development, test, and production.
5. Forbid introducing new RestTemplate integrations when RestClient or WebClient fits the use case.
