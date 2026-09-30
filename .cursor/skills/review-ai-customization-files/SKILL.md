---
name: review-ai-customization-files
description: >-
  Audit AI customization files for substantive duplicates, conflicts, and
  enforceability issues, while tracking resolved findings across reviews. Use
  when reviewing agents, instructions, prompts, skills, or hooks, or when the
  user invokes /review-ai-customization-files. Requires a file, file list,
  folder, or glob; optional explicit review-ledger path for single-file scopes.
  Do NOT report wording preferences or optional style rewrites as findings.
---

# AI Customization Audit

## Arguments

- Required: file, file list, folder, or glob to audit.
- Optional for single-file scopes: explicit review-ledger path.

## 1. Scope and Analysis

1. Review only the user-provided scope. If it is missing, stop and request it.
2. Resolve the style contract in this order: workspace `.github/instructions/ai-customization.instructions.md`, then the applicable user-level contract supplied by the environment. If neither exists, stop and report the missing prerequisite.
3. Load and apply the resolved style contract.
4. Resolve the supplied scope to files. Require at least one readable target file; otherwise report the scope as invalid and return `BLOCKED`.
5. Identify active references among the files in scope.

## 2. Review State and Convergence

1. Load the review ledger before scanning when it exists.
2. For a single-file scope, use `<file>.review-ledger.md` as the default ledger path. An explicit ledger path takes precedence over the default path. Validate and use the selected path consistently for loading, reporting, creation approval, and updates. If it does not exist, report it as not initialized and do not silently fall back to another path. If an existing ledger is unreadable or does not contain the required fields, report `Review ledger: invalid` with the path and reason, return `BLOCKED`, and do not scan or modify the target file.
3. For a folder or glob, review each resolved file independently and use `<file>.review-ledger.md` beside each file as its deterministic ledger path. Do not require one shared folder ledger or an explicit ledger path.
4. If the resolved ledger does not exist, report `Review ledger: not initialized` and continue the current scan. Do not create an empty ledger.
5. Assign each new finding the next unused severity number in the applicable ledger or current report. Treat every new finding as `PROVISIONAL` until its ID and required fields are written to the ledger; only then mark its ID state `LEDGER`. Preserve provisional IDs when the ledger is approved and created unless they conflict with existing entries.
6. Assign each finding a stable fingerprint based on canonical file identity, category, and normalized substantive problem. Do not include line location in the fingerprint.
7. When a ledger exists, assign each new finding the next unused number for its severity in that ledger. Reuse the ledger ID when the same fingerprint appears again. Do not call a new finding immutable or `LEDGER` until the ledger update is complete. Sort findings for display independently of their IDs.
8. Without a ledger, do not infer `FIXED`, `ACCEPTED`, or `REJECTED` status from conversation history, diffs, or filenames. Treat the review as having no persisted finding history.
9. Mark findings as `OPEN`, `FIXED`, `ACCEPTED`, or `REJECTED`.
10. Do not report `FIXED`, `ACCEPTED`, or `REJECTED` findings again unless the relevant content snapshot, referenced instruction, or applicable scope has materially changed.
11. When a resolved finding materially changes, retain its fingerprint and ID, mark it `OPEN`, store the new snapshot, and append the transition to its resolution history.
12. A wording preference, optional rewrite, or alternative style is not a finding.
13. When no new or unresolved substantive findings remain, report `Findings: none` and return `READY`.
14. When no ledger exists, state that current findings are clean only for this scan; do not claim that previous findings were resolved. If the scan has no findings, leave the ledger uncreated.
15. Update the target files only after explicit user confirmation.
16. When the user approves target-file fixes, create or update each affected file's adjacent ledger in the same operation and record the approved findings as `FIXED`, unless the user explicitly excludes ledger changes.
17. Create or update the ledger only after explicit user confirmation when a finding is explicitly accepted or rejected without changing the target file. Do not create a ledger for a clean scan.
18. Store at least the finding ID, fingerprint, file path, category, status, content snapshot or revision, and resolution note in the ledger. A valid ledger must be readable and contain those fields for every finding.

## 3. Resolution Rules

- **Scanning Rigor:** Scan every file in scope.
- **Completion Gate:** Finish the full scan of every file, every applicable reference, and all six checklist dimensions before reporting findings, scores, or a verdict. Do not stop after the first finding unless a declared blocker requires `BLOCKED`.
- **Review checklist:** Inspect every file across six dimensions:
  1. Duplicate rules (intra-file and cross-file).
  2. Conflicting rules (direct and soft conflicts).
  3. Verbosity (filler and low-signal prose).
  4. Directives (ambiguous or non-enforceable phrasing).
  5. Frontmatter (routing patterns, discoverability).
  6. Token efficiency (density; reward high-signal literals; penalize descriptive bloat).
- **Scoring Protocol:** Score the five reporting categories in the table below, each starting at 2. Assign each finding to every category it materially affects and subtract one point per assigned confirmed unresolved finding, never below 0. A file with no confirmed unresolved findings receives 10 and PASS.
- **Finding Threshold:** Report only concrete issues that affect behavior, routing, enforceability, correctness, safety, duplication, contradiction, or material clarity.
- **No Style Churn:** Do not create findings merely to improve style, shorten clear prose, replace valid wording, or make a file sound more polished.
- **Ledger Check:** Compare every candidate finding with the review ledger before reporting it.
- **Clean State:** A file may receive a `PASS` when wording could still be improved but no substantive issue remains.
- **Score Evidence:** Do not lower a score without identifying a concrete, unresolved issue.
- **Scoring Category Mapping:** The six checklist dimensions feed five reporting categories:
  - Clarity = frontmatter + token efficiency (two checklist dimensions share one score column).
  - Enforceability = directives (one checklist dimension).
  - Consistency = cross-file alignment assessed while checking duplicates and conflicts (the cross-file portion of those checklist dimensions).
  - Brevity = verbosity (one checklist dimension).
  - Conflict-Free = duplicates + conflicts (two checklist dimensions share one score column).
- **Status Classification:** PASS (9–10) | WARN (7–8) | FAIL (0–6).

## 4. Safety Guards

- **Execution Boundary:** Apply changes only after explicit user confirmation.
- **Fix Application Rule:** If authorized, modify only approved items.
- **Ledger Boundary:** Treat ledger creation and updates as file changes requiring explicit confirmation.

## 5. Review Plan Format

Use this exact markdown schema:

### Scope
- Target: <file, folder, or glob>
- Mode: <read-only | apply-after-confirmation>
- Assumptions applied: <none | item1; item2>

### Result
- Summary: <files scanned and top outcome>

### Findings (Critical | High | Medium | Low)
- Keep heading shape exactly: `[ID] - [SEVERITY] - [TYPE]`.
- `ID` must be the ledger ID assigned as `<SeverityCode><Index>` using `C|H|M|L` and the next unused severity index. Mark it provisional when no ledger exists and immutable only after it is stored in the ledger.
- Sort findings for display by severity rank, then file path (asc), line (asc), and type (asc); display sorting must not change IDs.

#### [ID] - [SEVERITY] - [TYPE]
- Location: <file path>:<line>
- ID state: <PROVISIONAL | LEDGER>
- Status: <OPEN | FIXED | ACCEPTED | REJECTED>
- Fingerprint: <stable identifier>
- Why it matters: <technical impact>
- Minimal fix: <one minimal action>

### Evidence
- Review ledger: <path per file | none>
- Finding summary: <new; reopened; fixed; accepted; rejected; none>
- Scores:

  | File | Total | Clarity | Enforceability | Consistency | Brevity | Conflict-Free | Status |
  |---|---:|---:|---:|---:|---:|---:|---|
  | `<path>` | `<0-10>` | `<0-2>` | `<0-2>` | `<0-2>` | `<0-2>` | `<0-2>` | `PASS|WARN|FAIL` |

- Rationale: For each file, add one concise line with the factual reason for each dimension score.
- Quick wins: <none | item1; item2>

### Next Action
- <single minimal next step or `none`>

### Verdict
- READY | NEEDS FIXES | BLOCKED
