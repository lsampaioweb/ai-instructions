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

EXT_MD = ".md"
EXT_JSON = ".json"
EXT_MDC = ".mdc"
MARKDOWN_JSON = (EXT_MD, EXT_JSON)
MDC_ONLY = (EXT_MDC,)

# Target modes with shared and framework-specific paths
# (source dir/file relative to SOURCE_ROOT, destination relative to cwd, extensions)
MODES = {
    "github": {
        "shared": [
            (".github/instructions/copilot-instructions.md", ".github/copilot-instructions.md", None),
            (".github/hooks", ".github/hooks", MARKDOWN_JSON),
            (".github/skills", ".github/skills", MARKDOWN_JSON),
        ],
        "framework_dirs": [
            (".github/instructions", ".github/instructions", MARKDOWN_JSON),
        ],
    },
    "cursor": {
        "shared": [
            (".cursor/AGENTS.md", "AGENTS.md", None),
        ],
        "framework_dirs": [
            (".cursor/rules", ".cursor/rules", MDC_ONLY),
            (".cursor/skills", ".cursor/skills", MARKDOWN_JSON),
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

LinkEntry = tuple[str, str, tuple[str, ...] | None]


def link(src: Path, dst: Path) -> None:
    dst.parent.mkdir(parents=True, exist_ok=True)
    if dst.exists() or dst.is_symlink():
        dst.unlink()
    os.link(src, dst)
    print(f"  {dst}")


def matches_any_framework_prefix(filename: str) -> bool:
    """Return True when the filename matches any known framework prefix."""
    for patterns in FRAMEWORK_PATTERNS.values():
        for pattern in patterns:
            if pattern in filename:
                return True
    return False


def matches_framework(filename: str, frameworks: list[str]) -> bool:
    """Check if filename matches any of the specified frameworks.

    Files with no known framework prefix are treated as shared/general and
    always included, even when a framework filter is active.
    """
    if not frameworks:
        return True  # No filter = all files
    if not matches_any_framework_prefix(filename):
        return True
    for framework in frameworks:
        if framework not in FRAMEWORK_PATTERNS:
            continue
        for pattern in FRAMEWORK_PATTERNS[framework]:
            if pattern in filename:
                return True
    return False


def print_available_targets() -> None:
    print(f"available targets: {', '.join(MODES.keys())}", file=sys.stderr)


def print_available_frameworks() -> None:
    print(
        f"available frameworks: {', '.join(sorted(FRAMEWORK_PATTERNS.keys()))}",
        file=sys.stderr,
    )


def parse_cli(argv: list[str]) -> tuple[str, list[str]] | int:
    if len(argv) < 2:
        print(
            "usage: setup-ai-links.py <target> [framework1] [framework2] ...",
            file=sys.stderr,
        )
        print_available_targets()
        print_available_frameworks()
        return 1

    target = argv[1]
    frameworks = argv[2:] if len(argv) > 2 else []

    if target not in MODES:
        print(f"error: unknown target '{target}'", file=sys.stderr)
        print_available_targets()
        return 1

    for framework in frameworks:
        if framework not in FRAMEWORK_PATTERNS:
            print(f"error: unknown framework '{framework}'", file=sys.stderr)
            print_available_frameworks()
            return 1

    return target, frameworks


def link_path(
    src: Path,
    dst: Path,
    exts: tuple[str, ...] | None,
    frameworks: list[str] | None = None,
) -> None:
    if src.is_file():
        if frameworks is None or matches_framework(src.name, frameworks):
            link(src, dst)
        return
    if not src.is_dir() or exts is None:
        return
    for path in sorted(src.rglob("*")):
        if not path.is_file() or path.suffix not in exts:
            continue
        if frameworks is not None and not matches_framework(path.name, frameworks):
            continue
        link(path, dst / path.relative_to(src))


def link_entries(
    entries: list[LinkEntry],
    cwd: Path,
    frameworks: list[str] | None = None,
) -> None:
    for rel_src, rel_dst, exts in entries:
        link_path(SOURCE_ROOT / rel_src, cwd / rel_dst, exts, frameworks)


def main() -> int:
    parsed = parse_cli(sys.argv)
    if isinstance(parsed, int):
        return parsed

    target, frameworks = parsed
    mode_config = MODES[target]
    cwd = Path.cwd()
    link_entries(mode_config["shared"], cwd)
    link_entries(mode_config["framework_dirs"], cwd, frameworks)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
