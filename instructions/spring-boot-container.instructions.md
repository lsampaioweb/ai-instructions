---
description: "Spring Boot container contract for deterministic image builds, secure runtime defaults, and operable container orchestration behavior in production-grade projects."
applyTo: "**/Dockerfile, **/Dockerfile-*, **/docker-compose.yml, **/compose.yml, **/compose.yaml, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml, **/README.md"
---

# Spring Boot Container Contract
Use this file to enforce deterministic container build and runtime behavior.

## Scope
1. Apply to container image build files, compose manifests, and container-related runtime configuration.
2. Keep containerization decisions aligned with explicit deployment and operability requirements.

## Coordination Order
1. Apply [spring-boot-config.instructions.md](./spring-boot-config.instructions.md) first for generic application*.yml and application*.yaml baseline rules.
2. Apply [spring-boot-pom.instructions.md](./spring-boot-pom.instructions.md) first for generic pom.xml baseline rules.
3. Apply [spring-boot-readme.instructions.md](./spring-boot-readme.instructions.md) first for generic README baseline rules.
4. Apply this file for container-specific constraints when containerization is in scope.

## Image Build Strategy Rules
1. Keep container image strategy explicit as Dockerfile-based or Cloud Native Buildpacks.
2. Keep image builds reproducible with pinned base image references or controlled digest policy.
3. Keep multi-stage builds explicit when Dockerfiles compile and package artifacts.
4. Keep executable archive layering enabled when optimized layered images are required.

## Dockerfile Rules
1. Keep runtime image minimal and separate from builder image stages.
2. Keep container process entrypoint explicit and deterministic.
3. Keep container runtime user non-root unless an explicit exception is documented.
4. Keep environment-driven JVM and application options explicit and override-friendly.
5. Keep only required ports exposed and aligned with configured server ports.

## Runtime Security Rules
1. Keep container filesystem hardening explicit for read-only root filesystem, tmpfs, and no-new-privileges policy when platform supports it.
2. Keep Linux capabilities minimized and explicitly declared.
3. Keep secrets mounted or injected from runtime secret stores, never baked into images.
4. Keep TLS certificate and key paths externalized and mounted read-only when used.

## Compose and Service Orchestration Rules
1. Keep service names deterministic by feature purpose.
2. Keep network names deterministic by feature purpose.
3. Keep container names deterministic by feature purpose.
4. Keep healthcheck probes explicit and aligned with actuator liveness or readiness endpoints.
5. Keep restart policy explicit and appropriate for target environment.
6. Keep environment variable contracts explicit with production-safe defaults.
7. Keep host volume mounts explicit and restricted to operationally required paths.

## Spring Boot Integration Rules
1. Keep Spring Boot Docker Compose development support profile-scoped and disabled for production deployments.
2. Keep compose lifecycle behavior explicit when using spring.docker.compose lifecycle properties.
3. Keep service connection assumptions aligned with supported container image names or explicit service-connection labels.
4. Keep readiness timeout and compose file location overrides explicit when non-default behavior is required.

## Quality Gates
1. Forbid embedding credentials, tokens, or private keys in Dockerfiles, compose files, or image layers.
2. Forbid mutable latest-only image tags in production release manifests without controlled pinning strategy.
3. Keep tests covering container startup, healthcheck readiness, and runtime profile wiring.
4. Keep README runbook aligned with container build, run, and troubleshooting commands.
