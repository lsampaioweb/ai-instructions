---
description: "Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references."
applyTo: "**/*Controller.java, **/*Routes.java, **/templates/**/*.html"
---

# Thymeleaf Rules

## Dependency

- Add `spring-boot-starter-thymeleaf` alongside `spring-boot-starter-web`; Spring Boot auto-configures the Thymeleaf view resolver with no additional configuration required

## Controller
- Scope boundary: applies to MVC/view handlers returning template names
- It does not apply to REST JSON API handlers
- Annotate Thymeleaf controllers with `@Controller`, not `@RestController`
- Return view name strings from handler methods; never return `ResponseEntity` or JSON from a Thymeleaf controller
- Declare the base path at class level with `@RequestMapping`; use only the path suffix on method annotations
- Inject `Model` as a method parameter when the handler needs to pass data to the template
- Add model attributes with `model.addAttribute("key", value)` before returning the view name
- On form GET handlers, always seed an empty domain object into the model so the template can bind against it
- On form POST handlers, accept the form-backing object via `@ModelAttribute("key")`; the key must match the one used in the template's `th:object`

## Template Files
- Store all templates under `src/main/resources/templates/`; group feature templates in sub-directories (e.g. `templates/ops/form.html`)
- Always declare the Thymeleaf XML namespace: `<html xmlns:th="http://www.thymeleaf.org" lang="en_US">`
- Reference static resources (CSS, JS, images) exclusively through Thymeleaf URL expressions (`@{/css/style.css}`, `@{/js/script.js}`) — never use plain relative paths; URL expressions are context-path-safe

## Static Resources
- Place CSS files under `src/main/resources/static/css/`
- Place JavaScript files under `src/main/resources/static/js/`
- Place images under `src/main/resources/static/img/`

## Thymeleaf Expressions
- `${variable}` — renders a model attribute
- `@{/path}` — generates a context-path-safe URL
- `#{key}` — resolves a message from `messages.properties` (i18n)
- `*{field}` — selection expression inside a `th:object` scope (form binding only)
- `th:each="item : ${list}"` — iterates a collection; the iteration variable name is arbitrary

## Form Binding
- Bind a form to a domain object with `th:object="${modelKey}"` on the `<form>` element
- Bind individual fields with `th:field="*{fieldName}"` on `<input>`, `<select>`, or `<textarea>` elements
- The form-backing object must be a mutable class (not a record); use Lombok `@Data` for brevity
- Use `method="POST"` on the form element; Spring MVC maps it to the `@PostMapping` handler

## Templates

**Read-only page controller.** Passes model attributes to the template. Replace `{feature}` and view names with actual values.

```java
@Slf4j
@Controller
@RequestMapping("/{feature}")
class {Feature}Controller {

  @GetMapping
  public String index() {
    return "{feature}/index";
  }

  @GetMapping("/list")
  public String list(Model model) {
    model.addAttribute("items", {feature}Service.findAll());

    return "{feature}/list";
  }
}
```

**Form controller.** GET seeds an empty object; POST receives the bound object. Replace `{Feature}`, `{feature}`, and the form-backing class name with actual values.

```java
@Slf4j
@Controller
@RequestMapping("/{feature}/form")
class {Feature}FormController {

  @GetMapping
  public String showForm(Model model) {
    model.addAttribute("{feature}", new {Feature}());

    return "{feature}/form";
  }

  @PostMapping
  public String submitForm(@ModelAttribute("{feature}") {Feature} {feature}, Model model) {
    model.addAttribute("result", {feature}Service.process({feature}));

    return "{feature}/result";
  }
}
```

**Form-backing domain object.** Must be mutable (use `@Data`, not a record). Replace fields with actual domain fields.

```java
@Data
class {Feature} {
  private String field1;
  private String field2;
}
```

**Template with model attribute and collection iteration** (`src/main/resources/templates/{feature}/list.html`).

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="en_US">
<head>
  <title>{Feature} List</title>
  <link rel="stylesheet" th:href="@{/css/style.css}">
</head>
<body>
  <h1 th:text="${title}">Title</h1>
  <ul>
    <li th:each="item : ${items}" th:text="${item.name}">item name</li>
  </ul>
</body>
</html>
```

**Form template with two-way binding** (`src/main/resources/templates/{feature}/form.html`).

```html
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org" lang="en_US">
<head>
  <title>{Feature} Form</title>
</head>
<body>
  <form method="POST" th:object="${{feature}}">
    <div>
      <label for="field1">Field 1</label>
      <input id="field1" type="text" th:field="*{field1}" />
    </div>
    <div>
      <label for="field2">Field 2</label>
      <input id="field2" type="text" th:field="*{field2}" />
    </div>
    <input type="submit" value="Submit" />
  </form>
</body>
</html>
```
