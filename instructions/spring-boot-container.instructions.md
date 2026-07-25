---
description: "Podman and Compose container rules: Dockerfile structure, image naming, profile activation, volume mounts, healthcheck, and log directory ownership."
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
- Keep capability additions exceptional and justified inline for each service.
- Keep socket mounts read-only and justified by explicit runtime needs.
- Keep local container run flows documented per scenario (standalone app flow or shared infrastructure flow).
- Keep healthchecks explicit and service-appropriate (actuator endpoints for Spring apps, native probes for infrastructure services).
- Keep runtime configuration profile-aware and externalized.
- Keep container resources and mounted paths explicit.

## Review Plan Layout
- Report build-file changes and image behavior impact.
- Report compose security and runtime setting changes.
- Report healthcheck and startup profile decisions.
- Report operational risks and mitigation notes.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never run containers with unnecessary privileges by default.
- Never expose internal-only ports without explicit need and documentation.
- Never ship container defaults that bypass runtime safety controls.
