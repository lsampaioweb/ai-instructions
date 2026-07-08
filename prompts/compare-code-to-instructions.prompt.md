---
description: "Reconcile drift between AI customization files and project code, in either direction."
argument-hint: "Mode + optional scope. Example: instructions-to-code samples/18-rabbitmq or code-to-instructions samples/18-rabbitmq"
tools: [vscode, execute, read, search, edit]
---

Supported modes:
1. `instructions-to-code`: use AI customization files as source of truth and align code to them.
1. `code-to-instructions`: use code as source of truth and align AI customization files to it.

Inputs:
1. Optional mode: when omitted, default to `instructions-to-code`.
1. Optional scope: one or more files, folders, or changed-files-only selectors; define deterministic boundaries for the run.

Workflow:

### Pre-Scan Phase (Mandatory)
1. **List all applicable mandatory components** from `spring-boot-architecture.instructions.md` for the scoped project type.
1. **Validate component presence**: verify required files for each mandatory component and record missing files as findings (one per missing file).

### Drift Analysis Phase
Source of truth control:
1. Inspect the requested scope first.
1. Identify the current source of truth based on the selected mode.
1. Freeze that source of truth for the full run; do not switch source of truth mid-run.

Validation and classification:
1. Validate each material drift against authoritative references first (official framework docs, standards, or widely accepted community guidance).
1. If authoritative references are unavailable in local context, record this explicitly in `Verification` with the risk impact.
1. Decide using `X/Y/Z` logic: keep instruction (`X`), keep code (`Y`), or adopt a third solution (`Z`) when both are suboptimal.
1. If `Z` is selected, update the true source first, then align the other side.
1. Find concrete drift, not stylistic preference.
1. Explain why the mismatch happened: missing rule, weak rule, conflicting rule, ignored rule, or code not aligned with an existing rule.
1. Classify each finding as one of: true contradiction, intentional divergence, or wording ambiguity.
1. Preserve technical literals: code blocks, inline code, commands, paths, URLs, identifiers, annotation names, config keys, environment variables, versions, and dependency coordinates.

Change policy:
1. Derive changes from existing patterns, explicit user preferences, or repeated corrections; do not invent new project rules.
1. Prefer the smallest correct diff that resolves the identified drift; avoid broad rewrites when a narrow correction is enough.
1. Do not silently fix adjacent out-of-scope issues; record them as separate findings.

Edit policy:
1. For review-only requests: stop after analysis and proposed changes.
1. For approval-before-edit: stop after proposed changes and wait for "ok".
1. Otherwise: apply smallest justified edits in selected scope.
1. When both code and AI files need changes, change the true source of drift first, then align the other.

Required output format:
1. `Findings` list (only concrete drift in scope; include missing mandatory files, missing annotations, hardcoded strings).
1. `Drift ledger` table with columns: `id`, `type`, `source-of-truth`, `recommended-solution`, `action`, `status`, `owner`, `evidence`.
1. `Verification` section must explicitly list:
   - All mandatory components checked and their presence/absence status
   - Pattern audits executed (hardcoded strings, missing @Slf4j, etc.) with results
   - Any checks explicitly NOT executed, with reason and risk note

Closure policy (mandatory for every run):
1. Every finding must end in exactly one terminal state:
   1. `fixed` (implemented and verified)
   1. `accepted-intentional` (kept by explicit decision with reason)
   1. `deferred` (not fixed now; include owner and next action)
1. Never finish with open findings that have no terminal state.
1. If the request is review-only, still output terminal states as proposed statuses and identify which items require explicit user decision.
1. If a finding already has a prior accepted-intentional or deferred decision in repository context, reuse that status instead of rediscovering it as a new unresolved drift.

Guardrails:
1. Be direct when current instructions are weak, contradictory, or overly vague.
1. Do not compress safety-critical guidance if clarity would be reduced.
1. Keep changes consistent with existing repository conventions unless the user explicitly wants a convention change.
1. **Exhaustive audit requirement**: Do NOT stop after finding one drift. Always complete the Pre-Scan Phase first to identify ALL mandatory component violations before proceeding to drift analysis.
1. **Mandatory vs optional**: Distinguish between violations of mandatory components (always report) and code-style inconsistencies (only report if within scope).
1. **Never assume presence**: If an instruction specifies a file/folder should exist, verify it actually does. Do not assume it exists just because the main file exists.
