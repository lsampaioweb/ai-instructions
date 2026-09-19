---
description: "Java coding style contract for imports, visibility, constants, annotations, methods, and helper extraction across all Java source files."
applyTo: "**/src/**/*.java"
---

## Rules

### Imports and package layout
- Keep the package declaration first, then a blank line, then imports.
- Order imports as: (1) static imports, (2) standard Java imports, (3) Spring and third-party imports, (4) project imports.
- Import each type explicitly; wildcard imports are forbidden.
- Keep a single blank line between import groups.
- Remove unused imports before finishing a class.
- Use exactly two spaces per indentation level in all files; no tabs.

### Visibility and dependency injection
- Declare every type member with the most restrictive visibility that satisfies its usage scope; default to `private`, expanding only when external access is required.
- Use constructor injection for every dependency; no field injection or setter injection.
- Validate required constructor parameters with `Objects.requireNonNull(...)` in non-record classes.
- Keep helpers and fields `private` unless a framework contract or explicit shared usage requires wider visibility.
- Prefer package-private types only when the type is intentionally scoped to the same package.
- Do not expose implementation details through public state or helper methods unless they are part of a real API contract.

### Annotation order and declaration style
- Order class-level annotations as: logging annotation(s) (e.g., `@Slf4j`) → framework/stereotype annotation(s) (e.g., `@Service`, `@Repository`, `@Component`) → Lombok generation annotation(s) → behavioral/validation annotation(s) (e.g., `@Transactional`, `@Validated`).
- Keep one blank line between the annotation block and the type declaration.
- Annotate every overriding method with `@Override`.
- Keep annotations directly attached to the declaration they annotate; do not separate them from the target.
- Do not use `@Data`, `@Builder`, `@AllArgsConstructor`, or `@NoArgsConstructor` on business classes unless a specific requirement explicitly justifies them.

### Constants and string extraction
- Extract repeated string literals—including message-resolution keys passed to `ApiException`, `logMessages.get()`, or equivalent, log keys, and literals reused across methods or test methods—into `private static final String` constants in `UPPER_SNAKE_CASE` in the owning class.
- Prefer domain-specific names such as `LOG_USER_UPDATING` and `ERROR_SORT_PROPERTY_INVALID` over generic names like `MESSAGE` or `VALUE`.
- Place constants near the top of the class, immediately after the logger declaration when present.
- Do not duplicate the same literal across multiple methods when it can be named once.

### Records and immutable carriers
- Use Java records only for simple immutable data carriers; they are not allowed for service, controller, repository, or business-logic classes.
- Keep `*Request`, `*Response`, `*Query`, and `*Model` types aligned with the component-specific rules when a dedicated instruction file applies.
- Allow Bean Validation on request-record components per `spring-boot-dto-mapper.instructions.md` and `@Validated` property records per `spring-boot-config.instructions.md`.
- Do not use records for types that require business behavior or persistence logic.

### Method structure and ordering
- Order methods as: constructors → public methods → package-private methods → private helpers.
- Name helpers by intent, not by generic verbs; prefer `parseSortOptions()`, `getSupportedLocales()`, and `getById(...)` over `build`, `compute`, `process`, or `handle`.
- Extract multi-statement logic, complex boolean conditions, and collection construction into named private helpers when the method becomes harder to read.
- Keep the caller at a higher abstraction level than the helper; do not create a helper just to look structured or when the logic is clearer inline.
- Keep public and package-private methods intent-revealing; declare same-class-only helpers `private`.

### JavaDoc discipline
- Document non-obvious public or protected constructors and methods with JavaDoc using only the `/** ... */` form.
- Place each method-level JavaDoc block immediately before the declaration, including before annotations.
- Start each JavaDoc summary with one concise sentence ending in a period.
- Keep JavaDoc summary-only when additional tags do not improve clarity.
- Add `@param`, `@return`, and `@throws` tags only when the intent or contract is not obvious from the names and summary.
- Do not add decorative JavaDoc to trivial methods that adds no contract value.

### Expressions and flow control
- Use `var` only when the inferred type is unambiguous.
- Use the ternary operator only for single-expression assignments.
- Prefer early returns and guard clauses; keep control flow direct and readable.
- Add one blank line before `return` only when the method body has preceding statements; omit it for a single `return` statement.
- Keep control flow readable; avoid clever one-liners that reduce clarity.
- Resolve IDE diagnostics for null-safety, deprecation, unused imports, and unchecked conversions before reporting a file complete.
- Do not introduce APIs marked deprecated for removal; select the supported replacement from the dependency version resolved by the module's Maven build.

### Class construction patterns
- Keep constructors thin and focused on dependency assignment and validation.
- Prefer explicit constructors for non-trivial initialization; do not create unnecessary abstraction layers for trivial logic.

## Reference
- Use [samples/spring-boot-java-style.tpl](samples/spring-boot-java-style.tpl) for the canonical Java class structure.
