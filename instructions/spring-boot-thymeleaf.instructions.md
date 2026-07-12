---
description: "Spring Boot Thymeleaf contract for deterministic server-rendered UI behavior, template safety, and maintainable view composition in production-grade projects."
applyTo: "**/src/main/java/**/*PageController.java, **/src/main/java/**/*Page*Controller.java, **/src/main/resources/templates/**/*.html, **/src/main/resources/static/**/*.js, **/src/main/resources/application*.yml, **/src/main/resources/application*.yaml, **/pom.xml"
---

# Spring Boot Thymeleaf Contract
Use this file to enforce deterministic Thymeleaf MVC and template behavior.

## Scope
1. Apply to server-rendered page controllers, Thymeleaf templates, and related static assets.
2. Keep page rendering responsibilities separate from API and persistence boundaries.
3. Exclude REST API controllers from this file scope.

## Controller and Model Rules
1. Keep page controllers limited to view orchestration and model assembly.
2. Keep business logic delegated to feature services.
3. Keep model attribute names explicit and stable per template contract.
4. Keep redirects explicit for successful post operations when full-page refresh is required.

## Form and Validation Rules
1. Keep form objects bound with explicit model attributes.
2. Keep validation errors handled deterministically with BindingResult in the same request cycle.
3. Keep invalid form submissions returning the original view with populated model state.
4. Keep field-level error rendering explicit with Thymeleaf field error expressions.

## Template Composition Rules
1. Keep template paths and fragment names explicit and stable.
2. Keep fragment responses explicit when returning partial HTML for AJAX flows.
3. Keep list-empty and list-populated states explicitly rendered.
4. Keep message and i18n key usage aligned with the i18n contract.

## Security and Output Safety Rules
1. Keep user-provided content rendered through escaped output expressions.
2. Forbid inline script construction with untrusted data in templates.
3. Keep state-changing form and AJAX operations aligned with active security and CSRF policy.
4. Keep template resource references deterministic through Thymeleaf URL expressions.

## Quality Gates
1. Forbid repository and SQL operations directly in controllers or templates.
2. Forbid duplicated business-rule decisions across template and controller layers.
3. Keep tests covering full-page render, validation failure render, and success redirect or fragment response behavior.
4. Keep profile-specific UI behavior deterministic across development, test, and production.
