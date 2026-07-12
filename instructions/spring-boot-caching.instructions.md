---
description: "Spring Boot caching contract for deterministic cache keys, safe invalidation, and bounded performance behavior in production-grade projects."
applyTo: "**/src/main/java/**/*Service*.java, **/src/main/java/**/*Configuration.java, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml"
---

# Spring Boot Caching Contract
Use this file to enforce deterministic caching and cache-backed read performance.

## Scope
1. Apply when cache abstractions, Redis data storage, or cache-like key-value reads are in scope.
2. Keep cache behavior explicit in service and configuration boundaries.

## Coordination Order
1. Apply [spring-boot-service.instructions.md](./spring-boot-service.instructions.md) first for generic service orchestration and transaction baseline rules.
2. Apply [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) first for generic YAML configuration baseline rules.
3. Apply this file for caching-specific key, invalidation, and backend constraints when caching is in scope.

## Key and Value Rules
1. Keep cache keys deterministic, stable, and domain-meaningful.
2. Forbid cache keys derived from non-deterministic values such as timestamps or random numbers.
3. Keep cached value serialization deterministic and version-safe.
4. Keep key namespaces explicit to avoid cross-feature key collisions.

## Read and Write Rules
1. Cache only deterministic read paths with clear cache hit semantics.
2. Keep write operations synchronized with cache invalidation or replacement semantics.
3. Forbid stale-cache behavior after successful create, update, or delete operations.
4. Keep cache miss behavior functionally equivalent to uncached reads.

## Backend and Configuration Rules
1. Keep cache backend host, port, and credentials externalized in application configuration.
2. Keep profile-aware cache configuration aligned across development and production.
3. Keep serialization strategy explicit in cache configuration classes.
4. Keep time-to-live and eviction policy explicit when expiration is required.

## Safety and Isolation Rules
1. Forbid caching sensitive secrets or credential material.
2. Keep cache access paths bounded by feature package boundaries.
3. Keep repository or adapter layers free of business-rule cache decisions.
4. Keep cache failures isolated from core business correctness when fallback reads are available.

## Test and Observability Rules
1. Keep tests covering cache hit, cache miss, and post-write invalidation behavior.
2. Keep tests validating deterministic key generation.
3. Keep operational visibility for cache connectivity and failure scenarios.
