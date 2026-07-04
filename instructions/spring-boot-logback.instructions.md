---
description: "Logback configuration rules: file location, profile-based appenders, rotation, and working-directory path resolution."
applyTo: "**/src/main/resources/log/logback-spring.xml, **/src/main/resources/logback-spring.xml, **/pom.xml, **/.vscode/launch.json"
---

# Logback Configuration Rules

## Logback Configuration
- Place `logback-spring.xml` under `src/main/resources/log/`.
- Add all profile-based appenders:
- `development` profile: console appender + async file appender at `INFO` level
- `production` and default profiles: async file appender only at `INFO` level

File rotation settings:
- `maxFileSize`: 10MB
- `totalSizeCap`: 1GB
- `maxHistory`: 7 (days to retain)

## Working Directory & Path Resolution
Relative paths in `logback-spring.xml` resolve from the JVM's working directory. To ensure consistent log placement across Maven and IDE launches:

1. **POM configuration**: Set `<workingDirectory>${project.basedir}</workingDirectory>` in `spring-boot-maven-plugin` (required; ensures Maven always uses the project folder, even when run from a parent folder)
2. **IDE configuration**: Create `.vscode/launch.json` (or IntelliJ Run Configuration) with `cwd` pointing to the project folder:
   - **VSCode**: `"cwd": "${workspaceFolder}/<project-folder>"`
3. **Logback configuration**: Use `<springProperty>` at the root of `<configuration>` (outside any `<springProfile>`) to declare configurable properties sourced from Spring's environment:
   ```xml
   <springProperty scope="context" source="spring.application.name" name="APPLICATION_NAME" />
   <springProperty scope="context" source="logging.file.path" name="LOG_DIR" defaultValue="./logs" />
   ```
   Reference the properties in appender definitions using `${APPLICATION_NAME}` and `${LOG_DIR}`. No custom `app.*` key is needed; Spring Boot's standard `logging.file.path` property is sufficient and is configurable via the `LOGGING_FILE_PATH` environment variable.
   Appender definitions must also be declared at root level, outside `<springProfile>`. Use `<springProfile>` **only** to switch the `<root level>` block.
