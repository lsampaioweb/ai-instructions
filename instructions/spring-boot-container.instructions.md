---
description: "Docker and Docker Compose rules: Dockerfile structure, image naming, profile activation, volume mounts, healthcheck, and log directory ownership."
applyTo: "**/Dockerfile, **/Dockerfile-multi-stage, **/docker-compose.yml, **/.dockerignore"
---

# Container Rules

## Base Images
Use the internal hardened images from `docker.io/lsampaioweb/`. Never use public images (`eclipse-temurin`, `amazoncorretto`, etc.) directly.

| Purpose | Image |
|---------|-------|
| Single-stage runtime | `docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-{date}` |
| Multi-stage builder | `docker.io/lsampaioweb/java-build:{jdk}-maven-alpine.{alpine}-{date}` |

Tag format: `{jdk}-alpine.{alpine}-{date}` (e.g. `25-alpine.3.23-2026.05`). Always pin a specific date tag in the active `FROM` line; keep commented-out alternatives (`-latest`, `-alpine-latest`) below it for easy switching during development.

## Dockerfile (single-stage)
- Use `--chown=${APP_USER_NAME}:${APP_GROUP_NAME}` on `COPY` — the base image already defines these build args; never hardcode a UID/GID
- Declare `ENV JAVA_TOOL_OPTIONS=""` so the variable can be overridden at runtime without modifying the image
- Declare `EXPOSE 8080 9443` for web applications
- Use `ENTRYPOINT ["java", "-jar", "app.jar"]` — not `CMD`; allows passing extra JVM flags at runtime
- Do not bake a Spring profile into the image; inject it at runtime via `SPRING_PROFILES_ACTIVE`

```dockerfile
FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-{date} AS image
# FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-latest AS image
# FROM docker.io/lsampaioweb/java-web:{jdk}-alpine-latest AS image
# FROM docker.io/lsampaioweb/java-web:latest AS image

COPY --chown=${APP_USER_NAME}:${APP_GROUP_NAME} ./target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS=""

EXPOSE 8080 9443

ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Dockerfile-multi-stage
Use a multi-stage build to avoid shipping build tools into the production image. The builder stage compiles the JAR; the runtime stage copies only the artifact.

- Mount the Maven local repository as a build cache (`--mount=type=cache,target=/root/.m2`) to avoid re-downloading dependencies on every build
- Use `--chown` and `${APP_HOME}` (defined in the base image) when copying from the builder stage

```dockerfile
FROM docker.io/lsampaioweb/java-build:{jdk}-maven-alpine.{alpine}-{date} AS builder
# FROM docker.io/lsampaioweb/java-build:{jdk}-maven-alpine.{alpine}-latest AS builder
# FROM docker.io/lsampaioweb/java-build:latest AS builder

COPY . .

RUN --mount=type=cache,target=/root/.m2 \
    mvn clean

RUN --mount=type=cache,target=/root/.m2 \
    mvn package

FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-{date} AS runtime
# FROM docker.io/lsampaioweb/java-web:{jdk}-alpine.{alpine}-latest AS runtime
# FROM docker.io/lsampaioweb/java-web:latest AS runtime

COPY --from=builder --chown=${APP_USER_NAME}:${APP_GROUP_NAME} ${APP_HOME}/target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS=""

EXPOSE 8080 9443

ENTRYPOINT ["java", "-jar", "app.jar"]
```

## Profile and Port Strategy
- `application-development.yml`: `server.port: ${SERVER_PORT:8080}`
- `application-production.yml`: `server.port: ${SERVER_PORT:9443}` with full SSL configuration
- Use `${SERVER_PORT:8080}` syntax (colon, no dash) for Spring property placeholders with defaults
- Never hardcode a port in the image or `ENTRYPOINT`; resolve it entirely from the active profile and env vars

## Log Directory Ownership
The container runs as the `app` user with **UID 1654**. When using rootless Podman, use `podman unshare` to apply correct host-side ownership — do not use `sudo chown` with a bare UID.

```bash
# Map the logs and ssl directories to the container's app user (UID/GID 1654).
podman unshare chown -R :1654 ./logs/container/
podman unshare chown -R :1654 ./ssl/

# Grant group read/write/traverse on logs; read/traverse on ssl.
chmod -R g+rwX,g+s ./logs/container/
chmod -R g+rX ./ssl/
```

## docker-compose.yml
- Declare the network as `external: true`; create it once with `podman network create {app}-network` before first run
- Apply runtime security hardening on every service: `read_only: true`, `cap_drop: ["ALL"]`, `security_opt: no-new-privileges:true`
- Add a `tmpfs` mount for `/tmp` with `noexec,nosuid` to allow the JVM to write temporary files in a read-only container filesystem
- Mount logs to `./logs/container` (subdirectory, not `./logs` directly) and ssl read-only
- Use `logging.driver: k8s-file` for structured log capture
- Pass `JAVA_TOOL_OPTIONS` to set JVM heap bounds at runtime; do not hardcode memory settings in the image
- Set `SPRING_PROFILES_ACTIVE` directly (no shell default needed when using Compose); comment out the alternative profile
- Healthcheck endpoint is `/actuator/health/ping` — not `/actuator/health`

```yaml
---
networks:
  {app}-network:
    external: true

services:
  {app}:
    image: "docker.io/{registry}/{app}:{version}"
    container_name: "{app}"
    restart: "unless-stopped"
    read_only: true
    cap_drop:
      - "ALL"
    security_opt:
      - "no-new-privileges:true"
    tmpfs:
      - "/tmp:rw,noexec,nosuid,size=64m"
    ports:
      - "8080:8080"
      # - "9443:9443"
    volumes:
      - "./logs/container:/opt/app/logs"
      - "./ssl/:/opt/app/ssl/:ro"
    networks:
      - "{app}-network"
    logging:
      driver: "k8s-file"
    environment:
      - "SPRING_PROFILES_ACTIVE=development"
      # - "SPRING_PROFILES_ACTIVE=production"
      # - "SERVER_PORT=9443"
      - "JAVA_TOOL_OPTIONS=-Xms512m -Xmx1024m"
    healthcheck:
      # HTTP (development)
      test: ["CMD-SHELL", "wget -q -O- http://localhost:8080/actuator/health/ping || exit 1"]
      # HTTPS self-signed cert (production, bypass cert check)
      # test: ["CMD-SHELL", "wget --no-check-certificate -q -O- https://localhost:9443/actuator/health/ping || exit 1"]
      start_period: "2s"
      interval: "10s"
      timeout: "2s"
      retries: 2
```

## Build and Run Commands

Build the JAR, then build the image:

```bash
mvn clean package -DskipTests
podman build --tag=docker.io/{registry}/{app}:{version} .
```

Multi-stage build (no local Maven required):

```bash
podman build \
  --tag=docker.io/{registry}/{app}:{version} \
  --network=host \
  --http-proxy=false \
  --isolation chroot \
  --pull=missing \
  -f Dockerfile-multi-stage .
```

Run with Podman Compose:

```bash
# Create the external network (once per host)
podman network create {app}-network

# Start (background)
podman compose up -d

# View logs
podman compose logs -f {app}

# Interactive shell
podman exec -it {app} sh

# Stop and remove containers
podman compose down
```

## Required Project Files
Every containerized project must include these files at the root:

| File | Purpose |
|------|---------|
| `Dockerfile` | Single-stage image build |
| `Dockerfile-multi-stage` | Multi-stage image build (no local Maven required) |
| `docker-compose.yml` | Service orchestration |
| `.dockerignore` | Excludes non-essential files from build context |
| `.env` | Local env var overrides (never commit secrets; commit with placeholder comments only) |
| `logs/container/.keep` | Placeholder so the log subdirectory is tracked by git |
| `ssl/.keep` | Placeholder so the `ssl/` directory is tracked by git |
