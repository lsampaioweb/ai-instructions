#!/usr/bin/env python3
"""Hardlink shared AI customization files into the current project.

Usage:
  scripts/setup-ai-links.py cursor
  scripts/setup-ai-links.py github

Re-running is safe: stale links are overwritten; sources are never modified.
"""

import os
import sys
from pathlib import Path

SOURCE_ROOT = Path(__file__).resolve().parent.parent

# (source dir/file relative to SOURCE_ROOT, destination relative to cwd, extensions)
MODES = {
    "github": [
        (".github/copilot-instructions.md", ".github/copilot-instructions.md", None),
        (".github/agents", ".github/agents", (".md", ".json")),
        (".github/hooks", ".github/hooks", (".md", ".json")),
        (".github/instructions", ".github/instructions", (".md", ".json")),
        (".github/prompts", ".github/prompts", (".md", ".json")),
        (".github/skills", ".github/skills", (".md", ".json")),
    ],
    "cursor": [
        (".cursor/AGENTS.md", "AGENTS.md", None),
        (".cursor/rules", ".cursor/rules", (".mdc",)),
        (".cursor/skills", ".cursor/skills", (".md", ".json")),
    ],
}


def link(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists() or dst.is_symlink():
        dst.unlink()
    os.link(src, dst)
    print(f"  {dst}")


def main() -> int:
    if len(sys.argv) != 2 or sys.argv[1] not in MODES:
        print("usage: setup-ai-links.py {cursor|github}", file=sys.stderr)
        return 1

    target = Path.cwd()
    for rel_src, rel_dst, exts in MODES[sys.argv[1]]:
        src = SOURCE_ROOT / rel_src
        dst = target / rel_dst
        if src.is_file():
            link(src, dst)
        elif src.is_dir():
            for f in sorted(src.rglob("*")):
                if f.is_file() and f.suffix in exts:
                    link(f, dst / f.relative_to(src))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
