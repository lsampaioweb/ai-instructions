---
description: "Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references."
applyTo: "**/*PageController.java, **/*Routes.java, **/templates/**/*.html"
---

# Spring Boot Thymeleaf

## Naming Conventions
- Name page controller classes with the `*PageController` suffix (e.g., `TaskPageController`, `UserPageController`).
- Name route constant holder classes with the `*Routes` suffix (e.g., `TaskRoutes`, `UserRoutes`).

## Rules
- Use MVC page controllers for template rendering routes.
- Keep templates organized by feature-oriented folder structure.
- Name template files in kebab-case and place them under `templates/<feature>/` matching the controller feature package (e.g., `templates/user/list.html`, `templates/user/detail.html`).
- Place reusable layout fragments under `templates/fragments/`.
- Place layout templates under `templates/layouts/`.
- Define a custom `templates/error.html` for application error fallback.
- Place CSS in `static/css/`, JavaScript in `static/js/`, and images in `static/images/`.
- Reference static resources using Thymeleaf's `@{/css/...}` link expressions.
- Keep form binding and validation explicit at controller boundaries.
- Return `void` with `@ResponseStatus` on write-only AJAX operations that produce no response body.
- Accept JSON fragment responses from `@Controller` page controllers for HTMX/AJAX page-workflow responses.
- Use `@RequestParam` for single-field form bindings.
- Use `@ModelAttribute` command objects for multi-field forms that require Bean Validation.
- Annotate a method with `@ModelAttribute` to pre-populate the command object before the form page renders.
- Use `th:errors` to display field-level validation errors adjacent to each form input.
- Keep model attribute keys stable and intentional.
- Declare a `LocaleResolver` bean in the configuration class whenever locale resolution deviates from Spring MVC's `AcceptHeaderLocaleResolver` default.
- Document supported locale codes and the fallback locale in a code comment at the `LocaleResolver` bean declaration when one is present.
- Permit fragment rendering and page-workflow AJAX endpoints from page controllers when they serve the same template flow.

## Safety Guards
- Never expose versioned `/api/v*` REST endpoints from page controllers.
- Never bypass validation feedback wiring in form workflows.
