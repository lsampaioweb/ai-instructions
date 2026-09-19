---
description: "Container images and Docker Compose services for Spring Boot applications and supporting infrastructure."
applyTo: "**/Dockerfile, **/Dockerfile-*, **/docker-compose*.yml, **/compose*.yml, **/.dockerignore"
---

## Dependencies
- Follow `spring-boot-application.instructions.md` and `spring-boot-actuator.instructions.md` when container health checks or environment variables must match application settings.

## Naming Conventions
- Name a multi-stage image definition `Dockerfile-multi-stage`.
- Name Compose definitions `docker-compose.yml` unless the project requires a distinct Compose file.

## Rules

### Dockerfiles
- Use an official Eclipse Temurin JRE image as the base runtime image, pinned to an explicit version tag.
- Copy only the application artifact into a runtime-only image.
- Set artifact ownership during the copy when the base image provides a non-root application user.
- Define a dedicated `appuser` with a non-zero UID for the application user; run the Spring Boot application as this non-root user.
- Use the JSON-array form of `ENTRYPOINT` to run the Spring Boot JAR.
- Expose port `8080` in the Dockerfile by default unless the application explicitly configures a different server port.
- Keep JVM tuning externally configurable through the `JAVA_TOOL_OPTIONS` environment variable.
- Activate the Spring profile via the `SPRING_PROFILES_ACTIVE` environment variable at runtime.

### Multi-stage Dockerfiles
- Use separate build and runtime stages when the image builds the application artifact.
- Use a builder image with the project's required JDK and build tool.
- Copy the packaged JAR from the builder stage into the runtime image.
- Use a Maven dependency-cache mount for BuildKit-enabled Maven builds.
- Apply the same runtime image and entrypoint rules as a single-stage Dockerfile.

### Docker Compose services
- Pin each service image to an explicit version or controlled release tag.
- Set `restart: "unless-stopped"` as the default container restart policy.
- Add a health check that uses a command available in the image; keep healthchecks explicit and service-appropriate (actuator endpoints for Spring apps, native probes for infrastructure services).
- Set healthcheck with `interval=30s`, `timeout=5s`, `retries=3`, and `start_period=60s` as defaults unless operational requirements differ.
- Attach services to an explicitly declared network.
- Use environment-variable substitution for deployment-specific configuration.
- Persist stateful service data through a named volume or bind mount.
- Mount secrets and certificates read-only.
- Publish only ports that require host access.
- Set `read_only: true` on all compose services; declare `tmpfs` mounts for writable runtime directories such as `/tmp` with `noexec,nosuid` options.
- Set `cap_drop: ["ALL"]` and `security_opt: ["no-new-privileges:true"]` on every compose service by default; add only capabilities required by that service, documented inline.
- Set explicit CPU and memory resource limits (`cpus`, `mem_limit`, `mem_reservation`) on every compose service.
- Declare a network as external only when it is provisioned independently for cross-Compose connectivity.
- Add Traefik labels only to services routed by Traefik.
- Restrict development-only settings, insecure dashboards, and default credentials to explicitly local development services.
- Document the standalone app flow and the shared infrastructure flow as separate run scenarios.

### Container health and application configuration
- Make the health-check scheme, port, and path match the active application listener.
- Use the configured Actuator health or probe endpoint for Spring Boot application health checks.
- Pass the active Spring profile and JVM options through environment variables when the deployment needs to vary them.
- Mount the application's log directory when file logging must persist outside the container.
- Keep runtime configuration profile-aware and externalized.

### Docker ignore files
- Exclude files that are not required by the selected image build strategy.
- Exclude local secrets, certificates, logs, IDE metadata, VCS metadata, test reports, and unneeded generated output.
- Retain `target/*.jar` when a single-stage Dockerfile copies a prebuilt JAR.
- Exclude `target/` for multi-stage builds unless a required artifact is intentionally retained.

## Safety Guards
- Never expose internal-only ports without explicit need and documentation.
- Never disable the non-root user or capability drops without explicit justification.
- Never hardcode heap or memory flags in the `CMD` or `ENTRYPOINT` instruction.
- Never use `JAVA_OPTS` instead of `JAVA_TOOL_OPTIONS` for JVM tuning.
- Never bake profile selection into the Dockerfile layer.

## Reference
- Use [samples/spring-boot-dockerfile.tpl](samples/spring-boot-dockerfile.tpl) for a runtime Dockerfile.
- Use [samples/spring-boot-dockerfile-multi-stage.tpl](samples/spring-boot-dockerfile-multi-stage.tpl) for a multi-stage Dockerfile.
- Use [samples/spring-boot-docker-compose.tpl](samples/spring-boot-docker-compose.tpl) for Docker Compose services.
- Use [samples/spring-boot-dockerignore.tpl](samples/spring-boot-dockerignore.tpl) for Docker ignore rules.
- Use [samples/spring-boot-application.tpl](samples/spring-boot-application.tpl) for the related application configuration.
