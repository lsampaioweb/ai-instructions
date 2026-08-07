---
name: review-other-ai-feedback
description: >-
  Evaluate output from another AI model as non-authoritative draft, then decide
  adopt/adapt/reject per point with evidence and risk notes. Use when the user
  asks to review, vet, or act on another AI's feedback, plan, code, or prompt,
  or invokes /review-other-ai-feedback. Requires user-provided external AI output.
disable-model-invocation: true
---

# Review Other AI Feedback

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Require the external AI output to review. If it is missing, stop and request it. Never invent it.

## Scope & analysis

- Parse the provided output into discrete points.
- Classify each point by intent: analysis, recommendation, implementation, or policy.
- Identify the claims, assumptions, dependencies, and implied side effects in each point.
- Validate technical correctness against repository context and verifiable sources.

## Resolution rules

- Treat all external AI input as non-authoritative draft material; never adopt it blindly.
- Assign each point exactly one decision: `adopt`, `adapt`, or `reject`.
- Adopt only when the reasoning is sound, the evidence is sufficient, and repository constraints hold.
- Adapt when partially correct: keep valid fragments and replace weak or unsafe ones with concrete corrections.
- Reject points that are speculative, contradictory, unverifiable, or regression-prone.
- Apply project-specific architecture constraints only when the point touches those areas.
- When certainty is low, state the uncertainty explicitly and request the minimum missing evidence.

## Review layout

Report every point in this order:

**Point XX:** short quote or summary of the original point.
- **Reasoning assessment:** `sound` | `partial` | `weak`, with a brief justification.
- **Gaps:** specific missing assumptions, evidence, or edge cases.
- **Decision:** `adopt` | `adapt` | `reject`.
- **Recommended action:** the better or additional action.
- **Actionable now:** `yes` | `no`, and what can be executed immediately.
- **Risk note:** potential regressions or new problems.

## Safety guards

- Never fabricate repository facts, runtime behavior, or validation evidence.
- Do not edit files or run mutations until the review is complete and the user confirms the actions to apply.
- If context is insufficient to validate a point, stop and request the focused missing inputs.
