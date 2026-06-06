---
description: "Review uncommitted changes, prepare well-structured commit messages following project conventions, present them for approval, then execute git commit commands if approved."
argument-hint: "Optional: specific files or folders to include in the review, or commit scope (e.g., 'only documentation', 'all changes')"
tools: [vscode, execute, read, search]
---

Review all uncommitted changes and prepare commit messages.

Steps:
1. **Inspect changes**: Run `git status` and `git diff` to understand what files changed and why.
2. **Group logically**: Organize all changed files (respecting .gitignore) into logical commits based on **context and concern** — group by feature, domain, or reason for change. Multiple commits may be needed even for a single feature if changes span unrelated areas.
3. **Draft messages**: For each commit group, write a clear message following Conventional Commits format:
   - Subject line: `type(scope): description` (50 chars max, imperative mood, no period)
     - Use `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`, `style:`, or other types as appropriate
   - Blank line
   - Body (if needed): explain *why* the change, not *what* changed
   - Reference any related issues or tickets if applicable
   - Note: If the commit truly doesn't fit Conventional Commits, signal that and I'll treat it as unrelated
4. **Present for review**: Show me the proposed commit messages with the files they include.
5. **Wait for approval**: Do not run `git commit` until you confirm the messages are correct. Any affirmative signal (e.g., "ok", "yes", "do it", "approved", "looks good") means proceed.
6. **Execute on approval**: Once approved, run the `git commit` commands in sequence.

Format each proposed commit clearly, for example:
```
Commit 1: fix(auth): incorrect token expiry validation in login flow
Files: src/auth/login.ts, tests/auth.test.ts
Message:
  fix(auth): incorrect token expiry validation in login flow

  The validation was checking the wrong timestamp field,
  causing valid tokens to be rejected after 5 minutes.
  Fixes #123.
```

Stop after step 4 and wait for my confirmation before executing commits.
