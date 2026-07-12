---
description: "Spring Boot referential-integrity contract for deterministic foreign-key relationships, delete/update semantics, and data consistency in production-grade relational systems."
applyTo: "**/src/main/resources/db/migration/*.sql, **/src/main/resources/sql/**/*.sql, **/src/main/resources/mapper/**/*.xml"
---

# Spring Boot Referential Integrity Contract
Use this file to enforce deterministic relational consistency semantics.

## Scope
1. Apply to SQL schema, migration scripts, and related mapper SQL contracts.
2. Keep relationship rules aligned with feature-level domain invariants.

## Relationship Definition Rules
1. Keep foreign keys explicit for mandatory parent-child relationships.
2. Keep foreign key constraints named with stable fk_* identifiers.
3. Keep mandatory relations represented with NOT NULL foreign key columns.
4. Keep uniqueness constraints explicit where one-to-one relationships are required.

## Delete and Update Semantics Rules
1. Keep ON DELETE behavior explicit for every foreign key.
2. Keep ON UPDATE behavior explicit when key mutation can occur.
3. Keep restrictive delete semantics as default unless domain policy requires cascade behavior.
4. Forbid implicit orphan creation through nullable relation columns for mandatory links.

## Consistency Rules
1. Keep parent deletion and child retention policy deterministic and documented.
2. Keep insert and update ordering consistent with referential constraints.
3. Keep seed data ordering valid with respect to foreign key dependencies.
4. Keep repository and mapper write paths aligned with declared foreign key rules.

## Integrity Verification Rules
1. Keep schema scripts failing fast on referential constraint violations.
2. Keep tests covering valid parent-child writes and invalid orphan writes.
3. Keep tests covering delete behavior for constrained relations.
4. Keep migration changes preserving existing referential integrity guarantees.

## Quality Gates
1. Forbid foreign key columns without matching foreign key constraints.
2. Forbid destructive schema changes that temporarily break required relations in production paths.
3. Keep relation semantics independent from JPA entity assumptions.
