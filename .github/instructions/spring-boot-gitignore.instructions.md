---
description: "Git ignore rules for Spring Boot Maven applications, IDE metadata, generated logs, certificate files, and local secret files."
applyTo: "**/.gitignore"
---

## Rules

### Spring Boot Maven applications
- Every Spring Boot project must have a `.gitignore` at the repository root.
- Ignore Maven build output with `target/`.
- Preserve source directories named `target` with `!**/src/main/**/target/` and `!**/src/test/**/target/`.
- Ignore Maven release-plugin artifacts: `release.properties` and `pom.xml.releaseBackup`.

### IDE metadata
- Ignore Spring Tool Suite / Eclipse metadata: `.apt_generated`, `.classpath`, `.factorypath`, `.project`, `.settings/`, and `.sts4-cache`.
- Ignore IntelliJ IDEA artifacts: `.idea/`, `*.iml`, `*.iws`, `*.ipr`.
- Ignore workspace-specific VS Code settings with `.vscode/`; allow `.vscode/extensions.json` and `.vscode/settings.json` as tracked exceptions using `!` negation patterns.

### OS artifacts
- Exclude OS artifacts: `.DS_Store`, `Thumbs.db`.

### Generated and sensitive files
- Ignore generated logs with `*.log` and `*.gz`; ignore log output directories with `logs/`.
- Ignore JVM crash log files: `hs_err_pid*`.
- Ignore certificate and key material with `*.p12`, `*.crt`, `*.key`, and `*.pfx`.
- Add `.env`, `*.env`, `application-local.yml`, and `application-local.properties` for local secret or configuration overrides.

### File organization
- Group exclusion rules by category with a `#` comment header above each group.
- Keep the Maven output rules first.
- Group IDE rules under headings such as `### STS ###` and `### VS Code ###`.
- Place local secret rules last under `### Environment ###` when they apply.

## Safety Guards
- Never use glob patterns (`target/*`) where directory patterns (`target/`) are more precise and cover nested paths.
- Never exclude the `.mvn/` directory when it contains the Maven wrapper; the wrapper is intentionally tracked.

## Reference
- Use [samples/spring-boot-gitignore.tpl](samples/spring-boot-gitignore.tpl) for the canonical `.gitignore` structure.
