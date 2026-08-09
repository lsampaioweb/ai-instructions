---
description: "Use to review external AI output as non-authoritative input and decide safe adopt/adapt/reject actions."
argument-hint: "Required: raw output from another AI model: feedback, plan, code, or prompt text."
---

# Cross-AI Output Evaluator Engine

## 1. Scope & Analysis
1. Parse the provided external AI output into discrete points.
2. Classify each point by intent (analysis, recommendation, implementation, or policy).
3. Identify claims, assumptions, dependencies, and implied side effects in each point.
4. Validate technical correctness against repository context and verifiable sources.

## 2. Resolution Rules
- Treat all external AI input as non-authoritative draft material.
- **Decision Gate:** For each point, choose exactly one: `adopt`, `adapt`, or `reject`.
- **Adopt Rule:** Adopt only when reasoning is sound and evidence is sufficient.
- **Repository Constraint Guard:** Reject an adopt decision if the point violates active repository constraints.
- **Adapt Rule (keep):** If partially correct, keep valid fragments.
- **Adapt Rule (replace):** Replace weak or unsafe fragments with concrete corrections.
- **Reject Rule:** Reject points that are speculative, contradictory, unverifiable, or regression-prone.
- **Conditional Architecture Check:** Apply project-specific architecture constraints only when the point directly modifies package structure, data-access patterns, or dependency boundaries.
- **Evidence Rule (state):** When certainty is low, state the uncertainty explicitly.
- **Evidence Rule (request):** Request the minimum missing evidence needed to validate the point.

## 3. Safety Guards
- Do not fabricate repository facts, runtime behavior, or validation evidence.
- **Execution Boundary:** Apply edits or mutations only after the full review output is complete and the user explicitly confirms which actions to apply.
- **Uncertainty Gate:** See `review-code-against-instructions.prompt.md` Safety Guards.

## 4. Review Plan Layout
Use this exact order for every point:
**Point XX**: short quote or summary of the original point.
- **Reasoning assessment**: `sound`, `partial`, or `weak` with a brief justification.
- **Gaps**: specific missing assumptions, evidence, or edge cases.
- **Decision**: `adopt`, `adapt`, or `reject`.
- **Recommended action**: better or additional action.
- **Actionable now**: `yes` or `no`, and what can be executed immediately.
- **Risk note**: potential regressions or new problems.
