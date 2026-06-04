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
Always use the latest GA release of Java. Set it via the `<java.version>` property managed by `spring-boot-starter-parent`:

```xml
<properties>
  <java.version>25</java.version>
</properties>
```

## Project Initialization
Initialize new Spring Boot modules directly with the final target structure and files; avoid scaffolding throwaway boilerplate that will be immediately replaced.
Do not run Maven Wrapper generation and do not commit a `.mvn` folder.
If a command auto-creates `.mvn`, remove the auto-generated `.mvn` folder before finalizing the step.
Before generating feature code, ensure the module contains at minimum: `pom.xml`, `src/main/java`, `src/main/resources`, `src/test/java`.

## Parent
Every Spring Boot project must declare `spring-boot-starter-parent` as the Maven parent. This gives you managed dependency versions, plugin configuration, and sensible defaults.

## Versions
- Do not hardcode versions for any dependency managed by `spring-boot-starter-parent` or a BOM already imported
- Declare versions in a `<properties>` block when a version must be explicit (third-party libraries not managed by the parent)
- Declare BOM imports via `<dependencyManagement>` using `import` scope; never copy-paste version numbers from a BOM into individual `<dependency>` entries

## Dependencies
- Add starters rather than individual Spring Framework or Spring Boot jars
- Common ordering (alphabetically within groups): Spring starters → production libraries → optional/runtime → test-only
- Declare `spring-boot-devtools` with `<scope>runtime</scope>` and `<optional>true</optional>`; it must never be packaged in the production artifact
- Declare `spring-boot-starter-test` and `mockito-core` with `<scope>test</scope>`

## Plugins
- **CRITICAL**: Always configure `spring-boot-maven-plugin` with `<workingDirectory>${project.basedir}</workingDirectory>`; without this, the JVM working directory varies depending on the launch method (IDE vs. `mvn spring-boot:run` from a parent folder), causing relative log paths and other file references to resolve inconsistently. This setting alone is not sufficient for IDE launch buttons (e.g., VSCode); IDEs must also be configured with a `.vscode/launch.json` that sets `cwd` to the project folder for consistency
- Keep plugin configuration minimal beyond the required working directory setting
- When using Java 23 or later, explicitly declare Lombok in `<annotationProcessorPaths>` inside `maven-compiler-plugin`; Java 23+ removed implicit annotation processor discovery, so without this `@Slf4j`, `@Data`, and all other Lombok annotations will fail to compile:

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
