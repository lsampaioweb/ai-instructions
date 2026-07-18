---
description: "Use when auditing AI customization files for duplicates, conflicts, and low-signal wording with a strict style rubric."
argument-hint: "Required: file, file list, folder, or glob to audit."
---

# AI Customization Audit Engine

## 1. Scope & Analysis
1. Target only user-provided scope. If missing, stop and request inputs.
2. Load and parse the applicable style baseline for the current scope.
3. Establish active cross-file references across target directories.

## 2. Resolution Rules
- **Scanning Rigor:** Scan 100% of files in scope. Sampling is prohibited.
- **Audit Checklist:** Inspect every file along six dimensions:
  1. Duplicate rules (intra-file and cross-file).
  2. Conflicting rules (direct and soft conflicts).
  3. Verbosity (filler and low-signal prose).
  4. Directives (ambiguous or non-enforceable phrasing).
  5. Frontmatter (routing patterns, discoverability).
  6. Token efficiency (density; reward high-signal literals; penalize descriptive bloat).
- **Scoring Protocol:** Score each file 0–10 using the baseline rubric. Assign 0–2 per dimension with factual justification. Map the checklist to the scorecard as follows: Clarity = frontmatter + token efficiency, Enforceability = directives, Consistency = cross-file alignment, Brevity = verbosity, Conflict-Free = duplicates + conflicts.
- **Status Classification:** PASS (9–10) | WARN (7–8) | FAIL (0–6).

## 3. Review Plan Layout
Generate audit findings using this exact markdown schema:

### Scope
- Files scanned: <list>
- Assumptions applied: <list>

### Findings (Ordered by Severity: Critical | High | Medium | Low)
Per finding:
- Severity: [Critical | High | Medium | Low]
- Type: [Duplicate | Conflict | Verbosity | Ambiguity | Structure]
- Location: <file path> + line
- Why it matters: <technical impact>
- Minimal fix: <action>

### Scorecard
Table: File | Total (0–10) | Clarity | Enforceability | Consistency | Brevity | Status.

### Quick Wins
3–7 edits. Highest impact, lowest risk.

### Cross-File Comparison Matrix
Pair analysis: Overlay | Domain | Friction | Recommendation.

### Final Verdict
- **[READY]** — All files PASS/WARN, no Critical/High findings.
- **[NEEDS FIXES]** — Structural barriers present.

## 4. Safety Guards
- **Execution Boundary:** Read-only audit. Do not edit files or execute mutations until explicit user confirmation.
- **Fix Application Rule:** If authorized, modify only approved items. Non-targeted text remains unchanged.
- **Output Discipline:** Keep output direct, technical, and execution-focused. Omit preambles and apologies.
