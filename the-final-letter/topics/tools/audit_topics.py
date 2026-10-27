#!/usr/bin/env python3
"""Structural audit of the topic folders. Does not judge mathematics."""
from __future__ import annotations
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "README.md", "index.html",
    "python/__init__.py", "python/programme.py",
    "tests/test_programme.py",
    "lean/Topic.lean", "lean/README.md", "lean/check.sh",
]

def main() -> int:
    bad = []
    for topic in sorted(
        p for p in ROOT.iterdir()
        if p.is_dir() and p.name not in {"tools"} and not p.name.startswith(".")
    ):
        missing = [f for f in REQUIRED if not (topic / f).exists()]
        dirty = []
        for lean in sorted((topic / "lean").glob("*.lean")):
            text = lean.read_text(encoding="utf-8")
            # Strip block and line comments before looking for forbidden commands.
            text = re.sub(r"/-.*?-/", "", text, flags=re.S)
            text = re.sub(r"--[^\n]*", "", text)
            for token in ("sorry", "axiom", "admit"):
                if re.search(r"\b" + token + r"\b", text):
                    dirty.append(f"{lean.name}:{token}")
        if missing or dirty:
            bad.append((topic.name, missing, dirty))
    if not bad:
        folders = [
            p for p in ROOT.iterdir()
            if p.is_dir() and p.name != "tools" and not p.name.startswith(".")
        ]
        print(f"OK: {len(folders)} topic folders pass the structural audit")
        return 0
    for name, missing, dirty in bad:
        print(f"{name}: missing={missing} forbidden={dirty}")
    return 1

if __name__ == "__main__":
    sys.exit(main())
