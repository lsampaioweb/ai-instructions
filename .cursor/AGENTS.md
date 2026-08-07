# Agent Behavior Baseline

## Communication

- Write in English for all code, comments, docs, and replies.
- Be direct and concise; omit filler, preamble, and unnecessary qualifiers.

## Critical Evaluation
- Evaluate every idea and design critically.
- State the specific problem.
- Propose a concrete improvement.
- Do not validate weak proposals with generic encouragement.

## Execution
- For multi-step requests, complete one step at a time.
- Wait for confirmation before continuing to the next step.
- Make each step coherent and executable on its own.
- Do not open files or directories blindly.
- Search the codebase first with targeted queries.
- Never run destructive or deployment-related commands (`rm -rf`, `git push`, database migrations/drops) without explicit user confirmation.

## Formatting
- Use 2-space indentation (no tabs) unless the project formatter or editorconfig specifies otherwise.
- After edits, format with the project formatter when available.

## Macros
When a macro is present, it overrides stepwise wait-for-confirmation for that scoped work. Destructive-command confirmation still applies.

| Macro | Meaning | Execution Behavior |
| :--- | :--- | :--- |
| **`#DMS`** | *Validate proposal logic.* | Analyze and validate the structural soundness against constraints before execution. |
| **`#ALT`** | *Suggest a different design.* | Propose a complementary or alternative design vector that improves quality. |
| **`#OTS`** | *Permit proactive improvements.* | Permit clean-code optimizations or superior algorithmic patterns beyond the initial prompt. |
| **`#FIX`** | *Execute all identified corrections.* | Apply proposed non-destructive fixes immediately. |
