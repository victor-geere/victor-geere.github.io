"""Reusable status-drift checker for the `theorems/` harvest.

Compares the primary status vocabulary term in each index row against the
`**Status:**` line of the theorem file the row links to.

Usage:  python3 lib/statuscheck.py theorems/INDEX.md theorems/tpp/INDEX.md
"""
from __future__ import annotations

import os
import re
import sys

TERMS = ["PROVED + VERIFIED", "PROOF-SKETCH + VERIFIED", "SETTLED", "PROOF-SKETCH",
         "PROVED", "VERIFIED", "CHECKED", "CITED", "CONJECTURED", "REFUTED", "OPEN"]

ROW = re.compile(r"^\|\s*\[")
LINK = re.compile(r"\]\(([^)]+)\)")


def primary(cell: str) -> str:
    """The vocabulary term occurring earliest in `cell` (compound terms included)."""
    best, at = "?", len(cell) + 1
    for t in TERMS:
        i = cell.find(t)
        if i != -1 and i < at:
            best, at = t, i
    return best


def file_status(path: str) -> str:
    try:
        for line in open(path, encoding="utf-8", errors="replace"):
            if line.startswith("**Status:**"):
                return primary(line)
    except OSError:
        return "MISSING"
    return "NOSTATUS"


def check(index: str):
    d = os.path.dirname(index)
    mism = []
    n = 0
    for line in open(index, encoding="utf-8", errors="replace"):
        if not ROW.match(line):
            continue
        cells = line.split("|")
        if len(cells) < 4:
            continue
        m = LINK.search(cells[1])
        if not m:
            continue
        tgt = m.group(1)
        if tgt.startswith("http") or not tgt.endswith(".md"):
            continue
        p = os.path.normpath(os.path.join(d, tgt))
        if not os.path.exists(p):
            continue
        n += 1
        a = primary(cells[3])
        b = file_status(p)
        if a != b:
            mism.append((tgt, a, b))
    print(f"== {index}: {n} rows checked, {len(mism)} status mismatches")
    for tgt, a, b in mism:
        print(f"   INDEX={a:22s} FILE={b:22s} {tgt}")
    return mism


if __name__ == "__main__":
    for idx in sys.argv[1:]:
        check(idx)
