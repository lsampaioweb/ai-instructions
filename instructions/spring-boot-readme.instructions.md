---
description: "README structure rules: recommended sections and no-filler-prose policy for Spring Boot project documentation."
applyTo: "**/README.md"
---

# Spring Boot README Guidelines

## Recommended Sections

Include the sections that are relevant; omit sections that do not apply to the topic. Suggested order:

1. **Overview** — what the feature/integration does and its role in Spring Boot development
1. **Prerequisites** — required tools, Java version, and environment setup
1. **Running locally** — steps to start the sample or test the feature
1. **Environment variables** (if applicable) — table of required and optional variables with descriptions
1. **API summary** (if applicable) — endpoints, HTTP method, brief description, and required auth

## Rules

- No filler prose, marketing language, or section padding
- Document every required environment variable when the Environment variables section is present
- The API summary is a quick reference; it is not a replacement for full API documentation

## Documentation Standards
- Use `1.` for all numbered lists (let Markdown auto-increment)
- Sort lists, tables, and enumerations alphabetically only when order is not semantic (e.g., references, variable tables)
- Prefer one command per code block with a description above it
- Group multiple shell commands in one code block only when they form a single setup workflow (for example environment exports followed by one run command)
