---
description: "Spring Boot error-code contract for deterministic machine-readable API error semantics and stable message-key mapping."
applyTo: "**/src/main/java/**/*ErrorCode.java, **/src/main/java/**/*Exception*.java, **/src/main/resources/i18n/messages*.properties"
---

# Spring Boot Error Code Contract
Use this file to enforce deterministic machine-readable error-code behavior.

## Ownership Boundary
1. Keep only error-code taxonomy, naming, and mapping rules in this file.
2. Do not define generic exception-handling flow rules in this file.
3. Apply [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) before this file.

## Read Order
1. Apply [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) first for AppException and GlobalExceptionHandler structure.
2. Apply this file second to supplement exception behavior with error-code taxonomy and messageKey-to-errorCode mapping.

## Canonical Artifacts
1. Keep all error-code definitions in src/main/java/<base-package>/<feature-or-common>/ErrorCode.java.
2. Keep ErrorCode as a single enum named ErrorCode.
3. Keep API error payload field named errorCode.

## Naming Rules
1. Keep machine-readable codes in UPPER_SNAKE_CASE.
2. Keep i18n message keys in lower.dot.case.
3. Keep one error code mapped to one semantic failure category.
4. Do not reuse one error code for unrelated failure semantics.

## Mapping Rules
1. Map AppException messageKey to ErrorCode in one centralized resolver in GlobalExceptionHandler.
2. Keep fallback mapping to ErrorCode.INTERNAL_ERROR for unmapped failures.
3. Keep transport-level failures mapped to stable transport error codes.
4. Do not generate error codes dynamically at runtime.

## Exception Integration
1. Keep GlobalExceptionHandler responsible for converting messageKey to errorCode.
2. Rely on [spring-boot-exception.instructions.md](./spring-boot-exception.instructions.md) for AppException shape and generic handler behavior.

## i18n Alignment
1. Keep every error.* message key used by exceptions present in all supported locale bundles.
2. Do not expose unresolved i18n keys in API error messages.
3. Keep message-key evolution backward-compatible for active API versions.

## Determinism and Stability
1. Keep existing published error codes immutable once released.
2. Introduce new codes for new error semantics instead of mutating existing meanings.
3. Keep error-code documentation synchronized with API behavior.

## Testing Requirements
1. Validate each mapped AppException resolves to the expected ErrorCode.
2. Validate unmapped exceptions resolve to ErrorCode.INTERNAL_ERROR.
3. Validate ErrorResponse always includes errorCode for handled API failures.
