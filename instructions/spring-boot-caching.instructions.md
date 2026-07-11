---
description: "Caching rules: cache annotations, naming, TTL policy, invalidation strategy, and dependency setup."
applyTo: "**/*Service.java, **/*ServiceImpl.java, **/*Configuration.java, **/application*.yml, **/pom.xml, **/*Test.java, **/*IT.java, **/test/**/*.java"
---

# Caching Rules

## Scope
- Use this file as the canonical source for Spring Cache usage in service-layer read/write flows.

## Dependency and Enablement
- Add `spring-boot-starter-cache` when caching is in scope.
- Use Caffeine as the default in-process cache backend.
- Use Redis cache backend only when distributed cache behavior is explicitly required.
- Enable caching with `@EnableCaching` in a dedicated configuration class.

## Annotation Usage
- Use `@Cacheable` on read-heavy service methods (`findAll`, `findById`) when data is stable enough for cache reuse.
- Use `@CacheEvict` on write methods (`create`, `update`, `delete`, `restore`) to invalidate affected cache entries.
- Use `@CachePut` only when immediate cache refresh after write is required.
- Do not place cache annotations on controllers or repositories.

## Cache Naming and Keys
- Use explicit cache names grouped by domain (for example: `countries`, `states`, `cities`).
- Keep key strategy deterministic and documented (`#id`, composite keys, or fixed keys for collection caches).
- Avoid implicit key generation when method signatures may evolve frequently.

## TTL and Capacity Policy
- Define cache TTL in configuration, not in hardcoded Java constants.
- Set conservative TTL defaults for reference data and tune with observed update frequency.
- Define maximum cache size for each named cache to avoid unbounded memory growth.

## Invalidation Policy
- Evict both item and collection caches when write operations change list or lookup results.
- Keep invalidation rules symmetrical across create, update, delete, and restore operations.
- Prefer explicit multi-key eviction over global `allEntries = true` unless full-cache invalidation is required.

## Observability and Safety
- Monitor cache hit/miss metrics through Actuator metrics.
- Keep cache data free of secrets and security-sensitive payloads.
- Document any eventual-consistency window introduced by cache TTL.

## Testing
- Add tests that verify cache population on reads and invalidation on writes.
- Use test profile settings to keep TTL predictable and tests deterministic.
- Ensure cache-related tests do not depend on production cache infrastructure.
