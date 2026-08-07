---
description: "Compose and Dockerfile container rules: image structure, naming, profile activation, volume mounts, healthcheck, and log directory ownership."
applyTo: "**/Dockerfile, **/docker-compose.yml"
---

# Spring Boot Container Engine

## Scope & Analysis
- Inspect image build files, compose orchestration, and runtime profile config.
- Inspect container security controls and filesystem restrictions.
- Inspect healthcheck, ports, and environment variable behavior.

## Resolution Rules
- Keep container images pinned to explicit tags.
- Keep build and runtime stages separated when multi-stage is used.
- Keep compose services hardened with minimal privileges by default.
- Run the Spring Boot application as a non-root user inside the container; define a dedicated `appuser` with a non-zero UID.
- Keep capability additions exceptional and justified inline for each service.
- Keep socket mounts read-only and justified by explicit runtime needs.
- Keep local container run flows documented per scenario (standalone app flow or shared infrastructure flow).
- Keep healthchecks explicit and service-appropriate (actuator endpoints for Spring apps, native probes for infrastructure services).
- Set healthcheck with `interval=30s`, `timeout=5s`, `retries=3`, and `start_period=60s` as defaults unless operational requirements differ.
- Keep runtime configuration profile-aware and externalized.
- Activate the Spring profile via the `SPRING_PROFILES_ACTIVE` environment variable; never bake profile selection into the Dockerfile layer.
- Configure JVM memory limits via the `JAVA_OPTS` environment variable; never hardcode heap or memory flags in the `CMD` or `ENTRYPOINT` instruction.
- Keep container resources and mounted paths explicit.
- Expose port `8080` in Dockerfile by default unless the application explicitly configures a different server port.

## Safety Guards
- Never run containers with unnecessary privileges by default.
- Never expose internal-only ports without explicit need and documentation.
- Never ship container defaults that bypass runtime safety controls.

## Review Plan Layout
- Report build-file changes and image behavior impact.
- Report compose security and runtime setting changes.
- Report healthcheck and startup profile decisions.
- Report operational risks and mitigation notes.

