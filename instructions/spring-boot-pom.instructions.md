---
description: "Maven POM rules: spring-boot-starter-parent, no hardcoded managed versions, dependency ordering, and BOM usage."
applyTo: "**/pom.xml"
---

# Maven POM Rules

- Target the latest stable Spring Boot and Java versions for new projects. For existing projects, detect the version from `pom.xml` and apply compatible rules without suggesting upgrades unless asked.

## Project Coordinates
- `groupId`: use `io.github.lsampaioweb` as the default unless the user specifies a different groupId
- `artifactId`: project name in kebab-case (e.g. `proxmox-installer-endpoint`)
- `version`: start at `0.0.1-SNAPSHOT` for new projects
- `name`: human-readable title in title case (e.g. `Proxmox Installer Endpoint`)

## Project Initialization
- By default, initialize a new project using `mvn archetype:generate` directly in the final target path
- Do not create `pom.xml` manually from scratch and do not use Spring Initializr (requires internet access), unless the user explicitly requires a different initialization flow
- If a command auto-creates `.mvn`, remove the auto-generated `.mvn` folder before finalizing the step
- Before generating feature code, ensure the module contains at minimum: `pom.xml`, `src/main/java`, `src/main/resources`, `src/test/java`

## Parent and Versions
- Every Spring Boot project must declare `spring-boot-starter-parent` as the Maven parent; it provides managed dependency versions, plugin configuration, and sensible defaults
- Never rely on model memory for framework or Java versions; always read the current `pom.xml` and repository docs
- For existing projects, preserve both the Spring Boot parent version and `java.version` unless the user explicitly requests an upgrade
- For new projects, use the version the user requests; if no version is given, use the latest stable release available at project generation time
- Set the Java baseline via the `<java.version>` property; see `## Templates` for the snippet
- Do not hardcode versions for any dependency managed by `spring-boot-starter-parent` or a BOM already imported; when a version must be explicit (third-party libraries not managed by the parent), declare it in a `<properties>` block
- Declare BOM imports via `<dependencyManagement>` using `import` scope; never copy-paste version numbers from a BOM into individual `<dependency>` entries

## Upgrading
- Use the canonical upgrade workflow in `documentation/maven/upgrade.md` for parent pinning, Java property updates, and build verification
- `mvn release:update-versions` updates only the project/module `<version>`
- Use `versions:update-parent -DskipResolution=true` to pin the Spring Boot parent without resolving to a newer version

## Dependencies
- Include these starters in every project: `spring-boot-starter-web`, `spring-boot-starter-actuator`, and `spring-boot-starter-test`
- Include `spring-boot-starter-thymeleaf` only for MVC/server-rendered view projects
- Include `spring-boot-devtools` only when explicitly needed for local development
- Add starters rather than individual Spring Framework or Spring Boot jars
- Common ordering (alphabetically within groups): Spring starters → production libraries → optional/runtime → test-only
- Declare `spring-boot-devtools` with `<scope>runtime</scope>` and `<optional>true</optional>`; it must never be packaged in the production artifact
- Declare `spring-boot-starter-test` with `<scope>test</scope>`. Add `mockito-core` with `<scope>test</scope>` only when mocking beyond starter-test's built-in capabilities
- For newly added dependencies and related code, prefer non-deprecated APIs; if a class is deprecated and marked for removal, use the supported replacement
- **Document every dependency purpose**: add a brief XML comment above each `<dependency>` block explaining why it was added; see `## Templates` for an example

### Version Management for Third-Party Libraries
- When a third-party library is not managed by `spring-boot-starter-parent` (e.g., `springdoc-openapi`), do NOT hardcode the version in the `<dependency>` block
- Instead, declare a version property in the `<properties>` section and reference it with `${property.name}` syntax
- Example: for Springdoc compatibility with Spring Boot 4.x, add `<springdoc.version>3.0.1</springdoc.version>` to properties, then use `<version>${springdoc.version}</version>` in the dependency
- This approach centralizes version updates and reduces repetition across modules
- Treat this section as the canonical policy for third-party version-property management across instruction files

## Plugins
- Always configure `spring-boot-maven-plugin` with `<workingDirectory>${project.basedir}</workingDirectory>`; without this, the JVM working directory varies by launch method (IDE vs. `mvn spring-boot:run` from a parent folder), causing relative log paths and other file references to resolve inconsistently. This setting alone is not sufficient for IDE launch buttons (e.g., VSCode); IDEs must also be configured with a `.vscode/launch.json` that sets `cwd` to the project folder for consistency
- Keep plugin configuration minimal beyond the required working directory setting
- When using Java 23 or later, explicitly declare Lombok in `<annotationProcessorPaths>` inside `maven-compiler-plugin`; Java 23+ removed implicit annotation processor discovery, so without this `@Slf4j`, `@Data`, and all other Lombok annotations will fail to compile; see `## Templates` for the configuration

## Templates

**Java version property.** Set in `<properties>` inside `pom.xml`.

```xml
<properties>
  <java.version>25</java.version>
</properties>
```

**Dependency with comment.** Replace artifact IDs and comments with actual values.

```xml
<!-- Spring validation: @NotNull, @NotBlank, @Email, etc. for input validation -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-validation</artifactId>
</dependency>

<!-- JSON serialization: MapStruct requires Jackson for object mapping -->
<dependency>
  <groupId>com.fasterxml.jackson.core</groupId>
  <artifactId>jackson-databind</artifactId>
</dependency>
```

**maven-compiler-plugin with Lombok annotation processor.** Required for Java 23+.

```xml
<plugin>
  <groupId>org.apache.maven.plugins</groupId>
  <artifactId>maven-compiler-plugin</artifactId>
  <configuration>
    <annotationProcessorPaths>
      <path>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
      </path>
    </annotationProcessorPaths>
  </configuration>
</plugin>
```
