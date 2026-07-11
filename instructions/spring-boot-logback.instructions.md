---
description: "Logback configuration rules: file location, profile-based appenders, rotation, and working-directory path resolution."
applyTo: "**/src/main/resources/log/logback-spring.xml, **/src/main/resources/logback-spring.xml, **/pom.xml, **/.vscode/launch.json"
---

# Logback Configuration Rules

For backend portability, structured JSON field contracts, and MDC correlation requirements, follow `spring-boot-observability.instructions.md`.

## Scope
- Applies to Logback output, rotation, and working-directory path resolution for Spring Boot applications

## Logback Configuration
- Place `logback-spring.xml` under `src/main/resources/log/`.
- Add all profile-based appenders.
- `development` profile: use console appender + async file appender at `INFO` level.
- `production` and default profiles: use async file appender only at `INFO` level.
- Set `maxFileSize` to `10MB`.
- Set `totalSizeCap` to `1GB`.
- Set `maxHistory` to `7` days.

## Working Directory & Path Resolution
Relative paths in `logback-spring.xml` resolve from the JVM working directory. Ensure consistent log placement across Maven and IDE launches:

1. **POM configuration**: Set `<workingDirectory>${project.basedir}</workingDirectory>` in `spring-boot-maven-plugin` (required; ensures Maven always uses the project folder, even when run from a parent folder)
2. **IDE configuration**: Create `.vscode/launch.json` (or IntelliJ Run Configuration) with `cwd` pointing to the project folder:
   - **VSCode**: `"cwd": "${workspaceFolder}/<project-folder>"`
3. **Logback configuration**: Use `<springProperty>` at the root of `<configuration>` (outside any `<springProfile>`) to declare configurable properties sourced from Spring's environment. See `snippets/logback/logback-spring.xml` for the required placement.
   - Reference these properties in appender definitions declared once at the root level
   - Use Spring Boot's standard `logging.file.path` property (configurable via `LOGGING_FILE_PATH`); do not introduce a custom `app.*` key for log directory resolution
   - Keep appender definitions outside `<springProfile>`
   - Use `<springProfile>` only to conditionally switch the `<root level>` block

