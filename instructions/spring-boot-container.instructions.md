---
description: "Podman and Compose container rules: Dockerfile structure, image naming, profile activation, volume mounts, healthcheck, and log directory ownership."
applyTo: "**/Dockerfile, **/Dockerfile-multi-stage, **/docker-compose.yml, **/.dockerignore"
---

# Container Rules

## Base Images
For Spring Boot Dockerfiles, use internal hardened images from `docker.io/lsampaioweb/`. Never use public Java runtime images (`eclipse-temurin`, `amazoncorretto`, etc.) directly.

For infrastructure services orchestrated only via `docker-compose.yml` (e.g., PostgreSQL, RabbitMQ, Redis, Vault, Traefik), official upstream service images are allowed.

| Purpose | Image |
|---------|-------|
| Single-stage runtime | `docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-{date}` |
| Multi-stage builder | `docker.io/lsampaioweb/java-build:{jdk}-maven-alpine.{alpine}-{date}` |

Tag format: `{jdk}-alpine.{alpine}-{date}` (e.g. `25-alpine.3.23-2026.05`). Always pin a specific date tag in the active `FROM` line; keep commented-out alternatives (`-latest`, `-alpine-latest`) below it for reference.

## Dockerfile (single-stage)
- Use `--chown=${APP_USER_NAME}:${APP_GROUP_NAME}` on `COPY` — the base image already defines these build args; never hardcode a UID/GID
- Declare `ENV JAVA_TOOL_OPTIONS=""` so the variable can be overridden at runtime without modifying the image
- Declare `EXPOSE 8080 9443` for web applications
- Use `ENTRYPOINT ["java", "-jar", "app.jar"]` — not `CMD`; allows passing extra JVM flags at runtime
- Do not bake a Spring profile into the image; inject it at runtime via `SPRING_PROFILES_ACTIVE`

## Dockerfile-multi-stage
- Use a multi-stage build to avoid shipping build tools into the production image; the builder stage compiles the JAR, the runtime stage copies only the artifact
- Mount the Maven local repository as a build cache (`--mount=type=cache,target=/root/.m2`) to avoid re-downloading dependencies on every build
- Use `--chown` and `${APP_HOME}` (defined in the base image) when copying from the builder stage

## Profile and Port Strategy
- Keep profile defaults aligned with configuration templates: `application-development.yml` uses `server.port: 8080` and `application-production.yml` uses `server.port: 9443` with SSL
- For runtime port override, use Spring placeholder syntax in profile files (e.g., `${SERVER_PORT:8080}` and `${SERVER_PORT:9443}`)
- Provide `SERVER_PORT` via environment variables when runtime override is required
- For canonical port override policy, follow `spring-boot-config.instructions.md` (`## Rules`)
- Never bake ports into `ENTRYPOINT`

## Log Directory Ownership
- The container runs as the `app` user with UID 1654; when using rootless Podman, use `podman unshare` to apply correct host-side ownership — never `sudo chown` with a bare UID
- Use the ownership and permission setup commands defined in this file

## docker-compose.yml
- Declare the network as `external: true`; create it once with `podman network create {app}-network` before first run
- Apply runtime security hardening on every service: `cap_drop: ["ALL"]`, `security_opt: no-new-privileges:true`

Spring Boot application service containers:
- Add `read_only: true`
- Add a `tmpfs` mount for `/tmp` with `noexec,nosuid` to allow the JVM to write temporary files in a read-only container filesystem
- Mount logs to `./logs/container` (subdirectory, not `./logs` directly) and mount the SSL directory read-only
- Use `logging.driver: k8s-file` for structured log capture
- Pass `JAVA_TOOL_OPTIONS` to set JVM heap bounds at runtime; do not hardcode memory settings in the image
- Set `SPRING_PROFILES_ACTIVE` directly (no shell default needed when using Compose); comment out the alternative profile
- Healthcheck endpoint must use Spring Boot probe groups: liveness (`/actuator/health/liveness`) for restart decisions and readiness (`/actuator/health/readiness`) for traffic routing when applicable; avoid custom `ping` groups by default

Infrastructure service containers (datastores, brokers, proxies, secret stores):
- `read_only`, `tmpfs`, `logging.driver: k8s-file`, `JAVA_TOOL_OPTIONS`, and `SPRING_PROFILES_ACTIVE` are optional and service-dependent
- Healthchecks must use service-native checks/endpoints (e.g., `pg_isready`, `rabbitmq-diagnostics`, `redis-cli ping`, Vault sys health, Traefik ping)

## Build and Run Commands
Use the commands below to build images and run services.
- Build JAR with `mvn clean package -DskipTests`, then image with `podman build`
- For multi-stage builds, use `podman build --network=host -f Dockerfile-multi-stage` (no local Maven required)
- Manage services with `podman compose`; create the external network once per host before first run
- See the templates section for copy-ready commands

## Required Project Files

Every containerized Spring Boot application project must include these files at the root:

| File | Purpose |
|------|---------|
| `Dockerfile` | Single-stage image build |
| `Dockerfile-multi-stage` | Multi-stage image build (no local Maven required) |
| `docker-compose.yml` | Service orchestration |
| `.dockerignore` | Excludes non-essential files from build context |
| `.env.example` | Committed template showing all required environment variables with defaults and documentation; developers copy to `.env` locally |
| `.env` | Local env var overrides (never commit; add to `.gitignore`; contains actual secrets and local values) |
| `.gitignore` | Must exclude `.env` to prevent committing local secrets |
| `logs/container/.keep` | Placeholder so the log subdirectory is tracked by git |
| `ssl/.keep` | Placeholder so the `ssl/` directory is tracked by git |

### .env and .env.example Pattern
For any project using environment variables:
1. Create `.env.example` at the project root (committed) with all required `VAR_NAME=default` entries, plus brief comments explaining each variable's purpose and when it has no default (e.g., secrets, tokens)
2. Create `.env` locally (never committed; in `.gitignore`) by copying `.env.example` and filling in actual values
3. Developers read `.env.example` to understand what configuration is needed; they never see `.env` from the repo
4. This pattern avoids committing secrets while ensuring new developers know what environment variables are required

Infrastructure-only compose projects may be compose-first and do not require `Dockerfile`/`Dockerfile-multi-stage` when no application image is built in-project.

