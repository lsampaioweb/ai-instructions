---
description: "Spring Boot .gitignore contract for safe, complete exclusion of build output, IDE artifacts, OS files, secrets, and logs."
applyTo: "**/.gitignore"
---

# Spring Boot .gitignore Engine

## Scope & Analysis
- Inspect the `.gitignore` at the repository root.
- Detect missing exclusion categories: build output, IDE artifacts, OS files, secrets, and logs.
- Detect patterns that are less precise than necessary (glob vs. directory form).

## Resolution Rules
- Every Spring Boot project must have a `.gitignore` at the repository root.
- Always exclude `target/` for Maven build output; never use `target/*`.
- Always exclude IntelliJ IDEA artifacts: `.idea/`, `*.iml`, `*.iws`, `*.ipr`.
- Always exclude Eclipse and STS artifacts: `.project`, `.classpath`, `.settings/`.
- Always exclude VS Code workspace artifacts: `.vscode/`; allow `!.vscode/extensions.json` and `!.vscode/settings.json`.
- Always exclude OS artifacts: `.DS_Store`, `Thumbs.db`.
- Always exclude secrets and local overrides: `*.env`, `.env`, `application-local.yml`, `application-local.properties`.
- Always exclude log output directories and files: `logs/`, `*.log`.

## Safety Guards
- Never commit `application-local.*` files; they are runtime-only overrides containing environment-specific secrets.
- Never use glob patterns (`target/*`) where directory patterns (`target/`) are more precise and cover nested paths.
- Never omit IDE exclusions; uncommitted IDE files cause noise in every developer's working copy.

## Review Plan Layout
- Report ignore patterns added, removed, or tightened.
- Report retained exceptions such as committed `.vscode/` allowlist entries.
- Report uncovered artifact categories that still need repository-specific ignore rules.
