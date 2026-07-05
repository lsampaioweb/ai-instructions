---
description: "Score AI customization files with a strict style rubric and report enforceable fixes for duplicates, conflicts, and low-signal wording."
argument-hint: "Required: file, file list, folder, or glob to review."
---

Review only the user-provided scope.
If scope is missing, ask for scope and stop.

Before reviewing files, load and apply the style contract from:
- [ai-customization.instructions.md](../instructions/ai-customization.instructions.md)

Required behavior:
1. Evaluate every file in scope; do not sample.
2. Report all findings with severity and exact location.
3. Prefer minimal fixes that preserve meaning.
4. Do not edit files unless the user explicitly asks to apply fixes.

Checks per file:
1. Duplicate rules (intra-file and cross-file)
2. Conflicting rules (direct and soft conflicts)
3. Filler and low-signal verbosity
4. Ambiguous or non-enforceable directives
5. Frontmatter and section discoverability
6. Token efficiency and context density (remove redundant prose; keep enforceable guidance and required technical literals)

Scoring:
1. Score each file from 0 to 10 using the rubric in the style contract.
2. Provide per-dimension scores and a short justification.
3. Treat Brevity as the token-efficiency dimension: reward dense, high-signal instructions and penalize avoidable context bloat.
4. Provide overall status:
   - PASS: 9-10
   - WARN: 7-8
   - FAIL: 0-6

Output format (use exactly these sections):

## Scope
- Files reviewed
- Assumptions

## Findings (ordered by severity)
For each finding include:
- Severity: Critical | High | Medium | Low
- Type: Duplicate | Conflict | Verbosity | Ambiguity | Structure
- Location: file path + line reference
- Why it matters
- Minimal fix

## Scorecard
For each file include:
- Total score (0-10)
- Clarity (0-2)
- Enforceability (0-2)
- Consistency (0-2)
- Brevity (0-2, includes token efficiency)
- Conflict-free (0-2)
- Status: PASS | WARN | FAIL

## Quick Wins
- 3 to 7 edits with highest impact and lowest risk.

## Final Verdict
- READY if all files are PASS or WARN with no High/Critical issues.
- NEEDS FIXES otherwise.

If asked to apply fixes, change only approved items and keep non-targeted text unchanged.
