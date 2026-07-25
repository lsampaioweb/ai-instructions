---
description: "Use when auditing code against instructions and instructions against code."
argument-hint: "Optional: target path, module, file, or glob to audit."
---

# Review Code And Instruction Coverage

Review the target scope in both directions.

Read `copilot-instructions.md` and `spring-boot-architecture.instructions.md`. You **MUST** obey all instructions in those files.

- Check code against the applicable instruction files and flag places where the implementation does not follow the active rules.
- Check the instruction files against the real codebase and flag recurring patterns, missing constraints, or missing governance that should be added.
- If no instruction files exist for the target scope, infer the needed instruction files from the code and propose the minimum enforceable initial set.
- When proposing new instruction files, place them in the default Copilot path: `.github/instructions/*`.
- Base all conclusions on files that actually exist in scope. Do not guess.
- Scan the full target scope. Do not sample.
- For each finding, explain the problem briefly and give one minimal remediation action.
- Distinguish between required violations, optional gaps, and ambiguous cases.
- Treat missing required instruction coverage as a problem.
- Keep the audit read-only unless the user explicitly asks to apply changes.

Default output:

1. Scope reviewed
2. Code violating instructions
- Group findings by category in this order, then sort by severity from High to Low inside each group.
- Required violations
- Optional gaps
- Ambiguous cases
3. Instructions missing code rules
4. Instruction files to create, update, retain, or delete
5. Final verdict: `READY` or `NEEDS FIXES`

For each finding include:
- File path and line reference when available
- Brief problem statement
- One minimal remediation action
