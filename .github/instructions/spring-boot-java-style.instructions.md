---
description: "Java coding style contract for import ordering, visibility discipline, string constants, blank-line rules, and helper extraction across all Java source files."
applyTo: "**/src/**/*.java"
---

# Java Style Engine

## Rules
- Organize imports in this order: (1) static imports, (2) standard Java imports, (3) Spring and third-party imports, (4) project imports.
- Import each type explicitly (no wildcard imports).
- Order class-level annotations in this sequence: logging (e.g., `@Slf4j`) → stereotype (e.g., `@Service`, `@Repository`, `@Component`) → behavioral (e.g., `@Transactional`, `@Validated`).
- Use Java records for immutable value types only when no component-specific instruction file applies; `*Model`, `*Request`, and `*Response` follow their component engines.
- Declare every type member (field, method, constructor, nested type) with the most restrictive visibility that satisfies its usage scope; default to `private` and expand only when external access is required.
- Extract repeated string literals—including message-resolution keys passed to `ApiException`, `logMessages.get()`, or equivalent, and literals reused across test methods—into named `private static final String` constants in `UPPER_SNAKE_CASE` in the owning class.
- Use constructor injection as the only dependency injection pattern.
- Validate required constructor parameters with `Objects.requireNonNull` in non-record classes.
- Order methods within a class in this sequence: constructors → public methods → package-private methods → private helpers.
- Document constructors and methods in all Java source files with traditional JavaDoc comments using only the `/** ... */` form.
- Place each method-level JavaDoc comment immediately before the declaration, including before method annotations.
- Start each method-level JavaDoc main description with one concise summary sentence ending with a period.
- Keep method-level JavaDoc to a summary-only block when additional tags do not improve contract clarity.
- Add `@param` tags only when parameter intent is not obvious from names and summary text.
- Add `@return` tags only when return semantics are not obvious from names and summary text.
- Add `@throws` tags only when exception behavior requires explicit contract clarification.
- Annotate every method that overrides a superclass or interface method with `@Override`.
- Add one blank line before `return` in any method body that contains at least one preceding statement.
- Omit the blank line before `return` when the method body is a single `return` statement.
- Use `var` only when the inferred type is unambiguous from the right-hand side of the assignment.
- Use the ternary operator only for single-expression assignments.
- Extract multi-statement logic, complex boolean conditions, and collection constructions into named private helpers; keep callers at a higher abstraction and name helpers by intent (e.g., `getSupportedLocales()`, not `buildLocaleList()`; avoid generic prefixes such as `build`, `compute`, or `process` when a domain-specific name is available).
- Keep public and package-private methods intent-revealing; declare same-class-only helpers `private`.

## Safety Guards
- Never nest ternary expressions.
- Never extract logic into a helper that is called only once and is trivially readable inline.
