---
description: "Java coding style contract for readable method structure, blank-line discipline, and helper method extraction across all Spring Boot layers."
applyTo: "**/src/**/*.java"
---

# Spring Boot Java Style Engine

## Scope & Analysis
- Inspect method bodies for blank-line discipline before return statements.
- Inspect methods with multiple statements for helper extraction opportunities.
- Detect inline multi-step logic that reduces method readability.

## Resolution Rules
- Apply this style consistently across all java files in the project.
- Organize imports in order: static imports, then standard Java imports, then Spring/third-party imports, then project imports; never use wildcard imports.
- Keep constructor injection as the only dependency pattern.
- Use Java records for immutable DTOs (request and response types) and value objects that have no mutable state; prefer records over traditional classes for these types.
- Add one blank line before `return` in any method that contains at least one preceding statement; omit the blank line only when the method body is a single `return` line.
- Extract multi-statement logic, complex boolean conditions, and list or map constructions into named private helper methods; the calling method should read at a higher level of abstraction using those helpers.
- Name helper methods after their intent, not their implementation (e.g., `getSupportedLocales()`, not `buildLocaleList()`).
- Keep public and package-private methods short and intent-revealing; delegate detail to private helpers.
- Declare all private helper methods as `private`; never use package-private or public visibility for a method that is only called within the same class.
- Extract every repeated string literal (message keys, domain error identifiers, event labels, route fragments, query parameter names) and every string passed to any message-resolution call site (`ApiException`, `logMessages.get()`, or equivalent) into a named `private static final String` constant in the owning class; inline string literals at these call sites are forbidden in any Java class regardless of layer.

## Safety Guards
- Never add a blank line before `return` in single-statement methods; it creates visual noise without clarity benefit.
- Never extract logic into a helper that is called only once AND is trivially readable inline.
- Never name helper methods with generic prefixes like `build`, `compute`, or `process` when a domain-specific name is available.
- Never pass a string literal directly to `ApiException`, `logMessages.get()`, or any message-resolution call site; always route through a named `private static final String` constant.

## Review Plan Layout
- Report methods missing the blank line before `return`.
- Extract and report methods with inline multi-step logic.
- Report helper methods added and their owning parent method.

