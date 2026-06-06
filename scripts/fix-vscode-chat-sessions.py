#!/usr/bin/env python3
"""Repair malformed VS Code chat session JSONL files.

A session is considered malformed when the first JSONL entry does not have kind == 0.
Default mode is dry-run. Use --apply to make changes.

How to use:
  # Safe scan only.
  python3 scripts/fix-vscode-chat-sessions.py

  # Apply fixes with backups.
  python3 scripts/fix-vscode-chat-sessions.py --apply

  # Apply only one workspace hash.
  python3 scripts/fix-vscode-chat-sessions.py --apply --workspace <workspace_hash>

  # Apply fixes for a specific VS Code data root.
  python3 scripts/fix-vscode-chat-sessions.py --apply --root ~/.config/Code
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import sys
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Iterable


@dataclass
class Counters:
    files_scanned: int = 0
    malformed_found: int = 0
    repaired: int = 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Repair malformed VS Code chat session files (JSONL)."
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Apply repairs. Default is dry-run.",
    )
    parser.add_argument(
        "--root",
        action="append",
        default=[],
        help="VS Code data root (repeatable), for example ~/.config/Code",
    )
    parser.add_argument(
        "--workspace",
        default="",
        help="Only process one workspaceStorage hash.",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        help="Print healthy files too.",
    )
    return parser.parse_args()


def default_roots() -> list[Path]:
    home = Path.home()
    candidates = [
        home / ".config" / "Code",
        home / ".config" / "Code - Insiders",
        home / ".config" / "Code - OSS",
        home / ".vscode-oss",
    ]
    return [root for root in candidates if (root / "User" / "workspaceStorage").is_dir()]


def resolve_roots(explicit_roots: list[str]) -> list[Path]:
    if explicit_roots:
        roots: list[Path] = []
        for raw in explicit_roots:
            root = Path(raw).expanduser().resolve()
            roots.append(root)
        return roots
    return default_roots()


def iter_chat_files(root: Path, workspace_hash: str) -> Iterable[tuple[str, Path, Path]]:
    ws_base = root / "User" / "workspaceStorage"
    if not ws_base.is_dir():
        return

    for ws_dir in ws_base.iterdir():
        if not ws_dir.is_dir():
            continue
        ws_hash = ws_dir.name
        if workspace_hash and ws_hash != workspace_hash:
            continue

        chat_dir = ws_dir / "chatSessions"
        if not chat_dir.is_dir():
            continue

        for jsonl_file in sorted(chat_dir.glob("*.jsonl")):
            yield ws_hash, ws_base, jsonl_file


def read_first_entry(path: Path) -> dict | None:
    try:
        with path.open("r", encoding="utf-8", errors="replace") as handle:
            first_line = handle.readline().strip()
    except OSError:
        return None

    if not first_line:
        return None

    try:
        value = json.loads(first_line)
    except json.JSONDecodeError:
        return None

    if not isinstance(value, dict):
        return None
    return value


def is_malformed(path: Path) -> bool:
    first = read_first_entry(path)
    if first is None:
        return True
    return first.get("kind") != 0


def extract_title(path: Path) -> str:
    try:
        with path.open("r", encoding="utf-8", errors="replace") as handle:
            for idx, line in enumerate(handle):
                if idx > 400:
                    break
                text = line.strip()
                if not text:
                    continue
                try:
                    item = json.loads(text)
                except json.JSONDecodeError:
                    continue
                if (
                    isinstance(item, dict)
                    and item.get("kind") == 1
                    and item.get("k") == ["customTitle"]
                    and isinstance(item.get("v"), str)
                    and item["v"].strip()
                ):
                    return item["v"].strip()
    except OSError:
        pass
    return "(no custom title)"


def build_header(session_id: str, creation_ms: int) -> dict:
    return {
        "kind": 0,
        "v": {
            "version": 3,
            "creationDate": creation_ms,
            "initialLocation": "panel",
            "responderUsername": "GitHub Copilot",
            "sessionId": session_id,
            "hasPendingEdits": False,
            "requests": [],
            "pendingRequests": [],
            "inputState": {
                "attachments": [],
                "mode": {"id": "agent", "kind": "agent"},
                "inputText": "",
                "selections": [
                    {
                        "startLineNumber": 1,
                        "startColumn": 1,
                        "endLineNumber": 1,
                        "endColumn": 1,
                        "selectionStartLineNumber": 1,
                        "selectionStartColumn": 1,
                        "positionLineNumber": 1,
                        "positionColumn": 1,
                    }
                ],
                "permissionLevel": "default",
                "contrib": {"chatDynamicVariableModel": []},
            },
        },
    }


def backup_file(ws_base: Path, source_file: Path, backup_root: Path) -> None:
    relative = source_file.relative_to(ws_base)
    destination = backup_root / relative
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source_file, destination)


def repair_file(path: Path) -> bool:
    session_id = path.stem
    creation_ms = int(path.stat().st_mtime * 1000)
    header = build_header(session_id, creation_ms)

    original = path.read_text(encoding="utf-8", errors="replace")
    tmp_path = path.with_name(f"{path.name}.tmp")

    with tmp_path.open("w", encoding="utf-8") as handle:
        handle.write(json.dumps(header, separators=(",", ":")))
        handle.write("\n")
        handle.write(original)

    os.replace(tmp_path, path)
    return not is_malformed(path)


def run_for_root(root: Path, apply: bool, workspace_hash: str, verbose: bool, counters: Counters) -> None:
    ws_base = root / "User" / "workspaceStorage"
    if not ws_base.is_dir():
        print(f"Skipping root without workspaceStorage: {root}")
        return

    print(f"\nRoot: {root}")

    backup_root: Path | None = None
    if apply:
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        backup_root = root / "User" / "chatSessions-auto-backups-py" / stamp
        backup_root.mkdir(parents=True, exist_ok=True)
        print(f"Backup dir: {backup_root}")

    for ws_hash, ws_base_local, path in iter_chat_files(root, workspace_hash):
        counters.files_scanned += 1

        malformed = is_malformed(path)
        if not malformed:
            if verbose:
                print(f"healthy  {ws_hash} {path.name}")
            continue

        counters.malformed_found += 1
        title = extract_title(path)
        print(f"broken   {ws_hash} {path.name} | {title}")

        if not apply:
            continue

        assert backup_root is not None
        backup_file(ws_base_local, path, backup_root)

        if repair_file(path):
            counters.repaired += 1
            print(f"fixed    {ws_hash} {path.name}")
        else:
            raise RuntimeError(f"Repair verification failed for {path}")


def main() -> int:
    args = parse_args()
    roots = resolve_roots(args.root)

    if not roots:
        print("No VS Code data roots found.")
        return 0

    counters = Counters()

    try:
        for root in roots:
            run_for_root(
                root=root,
                apply=args.apply,
                workspace_hash=args.workspace,
                verbose=args.verbose,
                counters=counters,
            )
    except Exception as exc:  # pragma: no cover - CLI safeguard
        print(f"ERROR: {exc}", file=sys.stderr)
        return 1

    print("\nSummary")
    print(f"files scanned:    {counters.files_scanned}")
    print(f"malformed found:  {counters.malformed_found}")
    if args.apply:
        print(f"repaired:        {counters.repaired}")
    else:
        print("repaired:        0 (dry-run)")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
