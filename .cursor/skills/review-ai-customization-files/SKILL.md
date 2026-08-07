---
name: review-ai-customization-files
description: >-
  Audit AI customization overlays for duplicates, conflicts, and enforceability;
  emit a structured scored report. Use when the user asks to review or audit
  customization files, or invokes /review-ai-customization-files.
  Requires user-provided file, list, folder, or glob.
disable-model-invocation: true
---

# Review AI Customization Files

- Obey `AGENTS.md` (project root or `cursor/AGENTS.md`).
- Read-only audit; edit only user-approved items after explicit approval; leave non-targeted text unchanged.

## Scope & analysis

1. Target only user-provided scope. If missing, stop and request inputs. Never invent scope.
2. Load style baseline (first match): repo `cursor/rules/ai-customization.mdc` → repo `vscode/instructions/ai-customization.instructions.md` → `~/.agents/instructions/ai-customization.instructions.md` → ask.
3. Establish active cross-file references across target directories.

## Resolution rules

- Scan 100% of files in scope. Do not sample.
- Inspect every file: duplicates, conflicts (incl. soft — precedence clash, or overlapping `applyTo`/`globs`/`paths` with contradictory verbs), verbosity, directives, frontmatter, token efficiency.
- **Scoring (0–10 per file):** Clarity = `round(avg(frontmatter, token_efficiency))`; Enforceability = directives; Consistency = dedicated 0–2 (≥2 files → cross-file vocab/routing 2/1/0; single file → internal agree 2/1/0); Brevity = verbosity; Conflict-Free = `round(avg(duplicates, conflicts))`. Total = column sum, round half-up. PASS 9–10 | WARN 7–8 | FAIL 0–6.

## Report layout

### Scope
- Files scanned, assumptions applied, cross-file comparison (N/A when <2 files)

### Findings
Critical → High → Medium → Low. One block per finding: severity + type, location + line, why it matters, minimal fix.

### Scorecard
Table: File | Total | Clarity | Enforceability | Consistency | Brevity | Conflict-Free | Status

### Quick Wins
Checkbox list of high-impact edits.

### Cross-File Comparison Matrix
Include only when ≥2 files in scope. Columns: Overlay Pair | Targeted Domain | Operational Friction | Strategic Recommendation

### Final Verdict
**READY** — all PASS/WARN, no Critical/High findings. **NEEDS FIXES** — structural barriers present.
