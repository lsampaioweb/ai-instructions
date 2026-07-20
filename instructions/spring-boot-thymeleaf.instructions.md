---
description: "Thymeleaf rules: controller conventions, template layout, model attributes, form binding, and static resource references."
applyTo: "**/*PageController.java, **/*Routes.java, **/templates/**/*.html"
---

# Spring Boot Thymeleaf Engine

## Scope & Analysis
- Inspect page controllers and view-routing behavior.
- Inspect template structure, form bindings, and validation rendering.
- Inspect locale resolver and message resolution behavior.

## Resolution Rules
- Use MVC page controllers for template rendering routes.
- Keep templates organized by feature-oriented folder structure.
- Keep form binding and validation explicit at controller boundaries.
- Keep model attribute keys stable and intentional.
- Keep locale resolution explicit with supported locales.
- Keep message-key usage consistent in templates and logs.

## Review Plan Layout
- Report page routes added or changed.
- Report template and binding changes with validation impact.
- Report locale behavior and fallback decisions.
- Report unresolved i18n or template consistency gaps.
- Report applied rules, blocked rules, assumptions, and residual risks.

## Safety Guards
- Never mix REST payload endpoints into page controller flows.
- Never bypass validation feedback wiring in form workflows.
- Never hardcode user-facing text where message keys exist.
