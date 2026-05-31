---
description: "Generate a complete Spring Boot feature following all project conventions."
---

Generate a complete Spring Boot feature.

Follow all active instruction files. Generate each file fully before proceeding to the next. Do not summarize or abbreviate any file.
Default to minimal scope: create only files strictly needed for the requested feature and confirmed constraints.

Generate the following files in order, adhering to all conventions:

## Instruction Files
`spring-boot-*.instructions.md`

Before generating any code, confirm all of the following. Ask for every missing item before proceeding:
- **Project already initialized?** — if not, run `mvn archetype:generate` per `spring-boot-pom.instructions.md` before any other file
- **Domain object name** (e.g. `User`)
- **Base package** (e.g. `com.example`)
- **Fields** — list each field as `name: type [validations]`, e.g. `email: String [@NotBlank, @Email]`, `age: Integer [@Min(0)]`
- **Database?** — yes or no; only generate repository, XML mapper, and schema SQL files when the answer is yes

Strict gate:
- If any required confirmation item is missing or ambiguous, STOP and ask clarifying questions.
- Do not infer, auto-fill, or assume missing values.
- Do not create todos, plans, or files until all required confirmation items are explicit.
- `README.md` — create if absent, otherwise update relevant sections; follow `spring-boot-readme.instructions.md`
