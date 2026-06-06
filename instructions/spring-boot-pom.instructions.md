---
description: "Maven POM rules: spring-boot-starter-parent, no hardcoded managed versions, dependency ordering, and BOM usage."
applyTo: "**/pom.xml"
---

# Maven POM Rules

## Project Coordinates
- `groupId`: use `io.github.lsampaioweb` as the default unless the user specifies a different groupId
- `artifactId`: project name in kebab-case (e.g. `proxmox-installer-endpoint`)
- `version`: start at `0.0.1-SNAPSHOT` for new projects
- `name`: human-readable title in title case (e.g. `Proxmox Installer Endpoint`)

## Java Version
- For new projects, use the latest LTS release; for existing projects, detect and preserve the current version from `pom.xml` unless explicitly requested to upgrade
- Set via the `<java.version>` property managed by `spring-boot-starter-parent`; see `## Templates` for the snippet

## Project Initialization
- Always initialize a new project using `mvn archetype:generate` directly in the final target path
- never create `pom.xml` manually from scratch and never use Spring Initializr (requires internet access)
- If a command auto-creates `.mvn`, remove the auto-generated `.mvn` folder before finalizing the step
- Before generating feature code, ensure the module contains at minimum: `pom.xml`, `src/main/java`, `src/main/resources`, `src/test/java`

## Parent
- Every Spring Boot project must declare `spring-boot-starter-parent` as the Maven parent; it provides managed dependency versions, plugin configuration, and sensible defaults

## Versions
- Do not hardcode versions for any dependency managed by `spring-boot-starter-parent` or a BOM already imported
- Declare versions in a `<properties>` block when a version must be explicit (third-party libraries not managed by the parent)
- Declare BOM imports via `<dependencyManagement>` using `import` scope; never copy-paste version numbers from a BOM into individual `<dependency>` entries

## Dependencies
- Add starters rather than individual Spring Framework or Spring Boot jars
- Common ordering (alphabetically within groups): Spring starters → production libraries → optional/runtime → test-only
- Declare `spring-boot-devtools` with `<scope>runtime</scope>` and `<optional>true</optional>`; it must never be packaged in the production artifact
- Declare `spring-boot-starter-test` with `<scope>test</scope>`. Add `mockito-core` with `<scope>test</scope>` only when mocking beyond starter-test's built-in capabilities
- **Document every dependency purpose**: add a brief XML comment above each `<dependency>` block explaining why it was added; see `## Templates` for an example

## Plugins
- **CRITICAL**: Always configure `spring-boot-maven-plugin` with `<workingDirectory>${project.basedir}</workingDirectory>`; without this, the JVM working directory varies depending on the launch method (IDE vs. `mvn spring-boot:run` from a parent folder), causing relative log paths and other file references to resolve inconsistently. This setting alone is not sufficient for IDE launch buttons (e.g., VSCode); IDEs must also be configured with a `.vscode/launch.json` that sets `cwd` to the project folder for consistency
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
