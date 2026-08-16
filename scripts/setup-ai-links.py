#!/usr/bin/env python3
"""Hardlink shared AI customization files into the current project.

Usage:
  scripts/setup-ai-links.py github                      # All frameworks
  scripts/setup-ai-links.py github spring-boot          # Only spring-boot framework
  scripts/setup-ai-links.py github ansible              # Only ansible framework
  scripts/setup-ai-links.py github spring-boot ansible  # Multiple frameworks
  scripts/setup-ai-links.py cursor                      # All frameworks
  scripts/setup-ai-links.py cursor spring-boot          # Only spring-boot framework

Framework options: ansible, spring-boot, and others as added to FRAMEWORK_PATTERNS.
Re-running is safe: stale links are overwritten; sources are never modified.
"""

import os
import sys
from pathlib import Path

SOURCE_ROOT = Path(__file__).resolve().parent.parent

# Target modes with shared and framework-specific paths
# (source dir/file relative to SOURCE_ROOT, destination relative to cwd, extensions)
MODES = {
    "github": {
        "shared": [
            (".github/copilot-instructions.md", ".github/copilot-instructions.md", None),
            (".github/hooks", ".github/hooks", (".md", ".json")),
            (".github/prompts", ".github/prompts", (".md", ".json")),
        ],
        "framework_dirs": [
            (".github/agents", ".github/agents", (".md", ".json")),
            (".github/instructions", ".github/instructions", (".md", ".json")),
        ],
    },
    "cursor": {
        "shared": [
            (".cursor/AGENTS.md", "AGENTS.md", None),
            (".cursor/rules", ".cursor/rules", (".mdc",)),
        ],
        "framework_dirs": [
            (".cursor/skills", ".cursor/skills", (".md", ".json")),
        ],
    },
}

# Framework detection patterns (filename prefixes)
# Add new frameworks by extending this dict with their prefix patterns
FRAMEWORK_PATTERNS = {
    "ansible": ["ansible-", "ansible_"],
    "spring-boot": ["spring-boot-", "spring-"],
    "python": ["python-"],
    "typescript": ["typescript-", "ts-"],
    "go": ["go-"],
}


def link(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists() or dst.is_symlink():
        dst.unlink()
    os.link(src, dst)
    print(f"  {dst}")


def matches_framework(filename: str, frameworks: list[str]) -> bool:
    """Check if filename matches any of the specified frameworks."""
    if not frameworks:
        return True  # No filter = all files
    for framework in frameworks:
        if framework not in FRAMEWORK_PATTERNS:
            continue
        for pattern in FRAMEWORK_PATTERNS[framework]:
            if pattern in filename:
                return True
    return False


def main() -> int:
    if len(sys.argv) < 2:
        print(
            "usage: setup-ai-links.py <target> [framework1] [framework2] ...",
            file=sys.stderr,
        )
        print(f"available targets: {', '.join(MODES.keys())}", file=sys.stderr)
        print(
            f"available frameworks: {', '.join(sorted(FRAMEWORK_PATTERNS.keys()))}",
            file=sys.stderr,
        )
        return 1

    target = sys.argv[1]
    frameworks = sys.argv[2:] if len(sys.argv) > 2 else []

    if target not in MODES:
        print(f"error: unknown target '{target}'", file=sys.stderr)
        print(f"available targets: {', '.join(MODES.keys())}", file=sys.stderr)
        return 1

    # Validate frameworks
    for framework in frameworks:
        if framework not in FRAMEWORK_PATTERNS:
            print(f"error: unknown framework '{framework}'", file=sys.stderr)
            print(
                f"available frameworks: {', '.join(sorted(FRAMEWORK_PATTERNS.keys()))}",
                file=sys.stderr,
            )
            return 1

    cwd = Path.cwd()
    mode_config = MODES[target]

    # Link shared files (always included)
    for rel_src, rel_dst, exts in mode_config["shared"]:
        src = SOURCE_ROOT / rel_src
        dst = cwd / rel_dst
        if src.is_file():
            link(src, dst)
        elif src.is_dir():
            for f in sorted(src.rglob("*")):
                if f.is_file() and f.suffix in exts:
                    link(f, dst / f.relative_to(src))

    # Link framework-specific files
    for rel_src, rel_dst, exts in mode_config["framework_dirs"]:
        src = SOURCE_ROOT / rel_src
        dst = cwd / rel_dst
        if src.is_file():
            if matches_framework(src.name, frameworks):
                link(src, dst)
        elif src.is_dir():
            for f in sorted(src.rglob("*")):
                if f.is_file() and f.suffix in exts:
                    if matches_framework(f.name, frameworks):
                        link(f, dst / f.relative_to(src))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
