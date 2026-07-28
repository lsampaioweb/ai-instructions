---
description: "Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references."
applyTo: "**/*PageController.java, **/*Routes.java, **/templates/**/*.html"
---

# Spring Boot Thymeleaf Engine

## Scope & Analysis
- Inspect page controllers and view-routing behavior.
- Inspect template structure, form bindings, and validation rendering.
- Inspect locale resolver and message resolution behavior.

## Dependencies
- To use Server-side Thymeleaf templating, add `spring-boot-starter-thymeleaf` dependency in pom.xml.
- For locale resolution and i18n support in templates, no additional dependency is required (Spring's LocaleResolver and i18n infrastructure is built-in).

## Resolution Rules
- Use MVC page controllers for template rendering routes.
- Keep templates organized by feature-oriented folder structure.
- Keep form binding and validation explicit at controller boundaries.
- Keep model attribute keys stable and intentional.
- Keep locale resolution behavior explicit when deviating from framework defaults; if default locale handling is retained, keep supported locales and fallback behavior documented.
- Keep message-key usage consistent in templates and logs.

## Safety Guards
- Never expose JSON REST payload endpoints from page controllers; fragment rendering and page-workflow AJAX endpoints are allowed when they serve the same template flow.
- Never bypass validation feedback wiring in form workflows.
- Never hardcode user-facing text where message keys exist.

## Review Plan Layout
- Report page routes added or changed.
- Report template and binding changes with validation impact.
- Report locale behavior and fallback decisions.
- Report unresolved i18n or template consistency gaps.

