---
description: "Use to discover workspace architecture and reconcile instruction files from codebase evidence: create, update, retain, or delete."
argument-hint: "Required: repository root path or target module directory. Optional: runtime preference, focus constraints, or file/glob scope."
---

# Workspace Architecture Discovery & Reconciliation Engine

## 1. Scope & Analysis
1. Scan the workspace hierarchy.
2. Categorize active files into **four universal software pillars**:
  - **Dependency & Tooling Manifests:** library, compiler, interpreter, and registry manifests.
  - **Environment & Configuration Stores:** variables, addresses, ports, registers, and profile flags.
  - **Entrypoints & Execution Anchors:** files that start or anchor execution.
  - **Source Trees & Encapsulation Boundaries:** directories and dominant file types that define program logic.
3. Isolate folder structures to identify packaging and modularization boundaries.
4. Evaluate active programming paradigms.
5. Include concise examples only when needed to disambiguate a detected pattern.
6. Inventory existing instruction files in scope.
7. Classify each existing instruction file as retain, update, or delete based on current evidence.
8. Identify missing required instruction files and classify them as create candidates.

## 2. Resolution Rules
- **Anti-Guesswork Rule:** Rely exclusively on physical codebase evidence.
- **No Assumption Rule:** Do not assume modern web-framework standards unless explicit configuration manifests are detected.
- **Component Extraction Matrix:** Classify discovered patterns into **six universal software primitives**:
  1. **Environmental State:** variables, addresses, configuration, and registers.
  2. **Boundary Encapsulation:** namespaces, directories, modules, headers, and wrappers.
  3. **State Mutation & Persistence:** modification, tracking, and storage.
  4. **Failure & Exception Processing:** unexpected-state handling.
  5. **Diagnostics & Telemetry:** execution-state exposure.
  6. **External Integration:** external system communication.
- **Taxonomy Blueprint Design:** Generate a custom-tailored instruction-file plan using the naming convention: `<detected-ecosystem>-<component>.instructions.md`.
- **Lifecycle Reconciliation Rule:** Mark each instruction file action explicitly as create, update, retain, or delete with evidence.
- **Baseline Naming Exception:** Keep `architecture.instructions.md` as the global mandatory baseline and do not prefix it with ecosystem.
- **Instruction Target Directory Rule:** Create and update instruction files only under `.github/instructions/`; do not place instruction files at repository root.
- **Scale-Driven Aggregation Rule:** Evaluate total workspace scale, architectural complexity, and polyglot boundaries before declaring output targets.
  - *Enterprise Scale (> 100 source units OR multi-ecosystem polyglot repositories):* Maintain a fully decoupled 1:1 mapping of primitives to files.
  - *Micro/Specialized Scale (< 100 source units OR single-domain pipelines/extensions):* Aggregate the 6 universal primitives into a maximum of 2 to 3 high-density conditional files to maximize token density and prevent governance bloat.
- **4-Tier Layout Transfer:** Every proposed instruction file must inherit the strict **4-Tier Engine Layout** (`Scope & Analysis`, `Resolution Rules`, `Review Plan Layout`, `Safety Guards`). Generic narrative rules are prohibited.

## 3. Review Plan Layout
Generate the discovery and reconciliation report card using this exact markdown schema:

### Tech Stack Detection Matrix
- **Primary Runtime/Language Detected:** <detected language and version>
- **Dependency/Build System:** <detected manifest type>
- **Target Environments Found:** <detected profiles or environment configs>
- **Active Structural Paradigm:** <detected packaging pattern>

### Architectural Component Analysis
Provide a markdown table mapping found codebase patterns to proposed instruction files:
| Codebase Pattern / File Signal | Architectural Component Category | Technical Impact / Risk if Unregulated | Proposed Instruction File Target |
| :--- | :--- | :--- | :--- |
| <evidence file or folder pattern> | <one of the 6 universal primitives> | <direct impact on model generation quality> | `.github/instructions/<ecosystem>-<name>.instructions.md` |

### Proposed Customization Suite Layout
List the exact file-tree reconciliation plan:
1. `[CREATE|UPDATE|RETAIN|DELETE] .github/instructions/architecture.instructions.md` (Mandatory baseline)
2. `[CREATE|UPDATE|RETAIN|DELETE] .github/instructions/<detected-ecosystem>-<component1>.instructions.md` (Conditional module)
3. `[CREATE|UPDATE|RETAIN|DELETE] .github/instructions/<detected-ecosystem>-<component2>.instructions.md` ...

### Brainstorming Alignment Questions
- Provide 3 to 5 hyper-specific architectural questions to align execution style choices.
- Keep each question decision-oriented and implementation-testable.

### Final Verdict
- **[READY]** — All components mapped and workspace is ready for reconciliation execution.
- **[NEEDS FIXES]** — Discovery incomplete; missing signals listed above.

## 4. Safety Guards
- **Execution Boundary:** Read-only discovery. Do not edit files or execute mutations until the report card is confirmed.
- **Post-Confirmation:** After the report card is confirmed, execute the reconciliation plan sequentially: apply create and update actions first under `.github/instructions/`, then apply delete actions. Apply the 4-Tier Engine Layout to every created or updated file.
- **Insufficient-Evidence Gate:** If evidence is insufficient for a proposed module, stop, mark it as not-applicable with reason, and do not generate that file.
- **No Web-Framework Presumption:** Do not force-fit database migrations, REST patterns, or API annotations if the detected stack is an embedded, script-based, or low-level environment.
