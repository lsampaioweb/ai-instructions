---
description: "Spring MVC Thymeleaf pages, templates, forms, static resources, folder conventions, and partial AJAX updates."
applyTo: "**/src/main/java/**/*PageController.java, **/src/main/java/**/*PageRoutes.java, **/src/main/resources/templates/**/*.html, **/src/main/resources/static/css/**/*.css, **/src/main/resources/static/js/**/*.js, **/*Routes.java"
---

## Dependencies
- Follow the Java style contract in `spring-boot-java-style.instructions.md` for page controller formatting, imports, visibility, injection, constants, and JavaDoc.

## Naming Conventions
- Name controllers that render pages with the `*PageController` suffix (e.g., `TaskPageController`, `UserPageController`).
- Name route constant holder classes with the `*Routes` suffix (e.g., `TaskRoutes`, `UserRoutes`).
- Name a template after the page or feature it renders; place feature templates in a matching subdirectory when the feature has more than one view.
- Name template files in kebab-case under `templates/<feature>/` matching the controller feature package (e.g., `templates/user/list.html`, `templates/user/detail.html`).

## Rules

### Page controllers
- Use `@Controller` for server-rendered page routes.
- Populate the `Model` with every attribute required by the returned template.
- Return the template view name without the `.html` extension.
- Keep page rendering, form submission, and partial-update routes within the controller that owns the feature.
- Declare a `LocaleResolver` bean in the configuration class whenever locale resolution deviates from Spring MVC's `AcceptHeaderLocaleResolver` default, and document supported locale codes and the fallback locale in a code comment at that bean declaration.

### Templates and folder layout
- Place Thymeleaf templates under `src/main/resources/templates`.
- Place reusable layout fragments under `templates/fragments/` and page layout templates under `templates/layouts/`.
- Define a custom `templates/error.html` for application error fallback.
- Declare the Thymeleaf namespace with `xmlns:th="http://www.thymeleaf.org"`.
- Render server-provided text with `th:text` and collections with `th:each`.
- Bind model-backed forms with `th:object` and fields with `th:field`.
- Resolve CSS, JavaScript, links, and form actions through Thymeleaf URL expressions (`@{...}`).

### Form validation
- When a form uses Bean Validation, bind it with `@Valid` and follow `spring-boot-controller.instructions.md` for `BindingResult` placement.
- Use `@RequestParam` for single-field form bindings; use `@ModelAttribute` command objects for multi-field forms that require Bean Validation.
- Annotate a method with `@ModelAttribute` to pre-populate the command object before the form page renders.
- When validation fails, return the same template and repopulate every model attribute it requires.
- Render field-level validation feedback with `#fields.hasErrors(...)` and `th:errors`.

### Static resources
- Place CSS files under `static/css/`, JavaScript files under `static/js/`, and images under `static/images/`.
- Reference static resources from templates using `th:href` and `th:src`.

### Partial AJAX and HTMX updates
- When a route returns a partial template, declare a named `th:fragment` for the returned markup; populate every model attribute required by the fragment before returning it, and return it as `template :: fragment`.
- Check the `fetch` response before applying returned HTML or changing the DOM.
- Return `void` with `@ResponseStatus` on write-only AJAX operations that produce no response body.
- Accept JSON fragment responses from `@Controller` page controllers for HTMX/AJAX page-workflow responses; permit fragment rendering and page-workflow AJAX endpoints from page controllers when they serve the same template flow.

## Safety Guards
- Never expose versioned `/api/v*` REST endpoints from page controllers.

## Reference
- Use [samples/spring-boot-page-controller.tpl](samples/spring-boot-page-controller.tpl) for page controller structure.
- Use [samples/spring-boot-thymeleaf-template.tpl](samples/spring-boot-thymeleaf-template.tpl) for Thymeleaf templates.
