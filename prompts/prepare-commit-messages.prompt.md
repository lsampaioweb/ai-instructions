---
description: "Review uncommitted changes, draft logical commit messages, present for approval, then commit if approved."
argument-hint: "Optional scope, files, or folders to include."
tools: [vscode, execute, read, search]
---

Steps:
1. Inspect changes: Run `git status` and `git diff`.
2. Group logically: Split files into coherent commits by concern area.
3. Draft messages: Use Conventional Commits.
   - Subject: `type(scope): description`, imperative, with period, max 50 chars.
   - Body only when needed: explain *why*.
   - Add related issue/ticket when relevant.
   - If a commit does not fit Conventional Commits, flag it.
4. Present for review: Show each commit with file list and planned `git add` command.
5. Wait for approval: Do not run `git commit` before approval.
6. Execute: Run commits in sequence after approval.

Output format:
- Order commits by dependency/risk (foundational changes first).
- Commit N: subject
- Files: list
- Message: full commit message
