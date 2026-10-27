"""Reusable markdown relative-link repair for the rh workspace.

The `theorems/` harvest was generated with links written *relative to the
workspace root* (SPEC: "relative link from theorems/") and then emitted
verbatim inside per-theorem files at `theorems/<sub>/`, i.e. one `../` too
few.  `theorems/INDEX.md` and the `theorems/.index/*.md` shards use a second
variant (links relative to a depth-2 file, and theorem links by basename).

This module repairs them by trying, in order:

1. the target as written (never touch a link that already resolves);
2. workspace-root-relative (`../X` -> `<ws>/X`);
3. theorems-root-relative (`<th>/X`);
4. unique basename match under `theorems/`;
5. unique basename match under the workspace;
6. explicit override table (for genuinely ambiguous basenames).

Usage:
    python3 lib/linkfix.py --dry-run
    python3 lib/linkfix.py
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from collections import defaultdict

WS = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
TH = os.path.join(WS, "theorems")

# Basenames that occur more than once in the tree; resolved by content/explicit
# convention (verified against the harvesting prefix).
OVERRIDES = {
    "qa.md": "research/various/qa.md",
    "HANDOFF.md": "research/various/HANDOFF.md",
}

LINK = re.compile(r"\]\(([^)\s]+)\)")
FENCE = re.compile(r"^\s*(```|~~~)")


def external(t: str) -> bool:
    return t.startswith(("http://", "https://", "mailto:", "#", "//"))


def split_anchor(t: str):
    if "#" in t:
        a, b = t.split("#", 1)
        return a, "#" + b
    return t, ""


def basename_index(root: str, skip_parts=("theorems",)):
    idx = defaultdict(list)
    for dp, _d, fs in os.walk(root):
        if any(p in dp.split(os.sep) for p in skip_parts):
            continue
        for f in fs:
            idx[f].append(os.path.join(dp, f))
    return idx


def resolve(f: str, target: str, ws_idx, th_idx):
    """Return an absolute path the link should point at, or None."""
    tgt = split_anchor(target)[0]
    if external(tgt) or not tgt:
        return None
    d = os.path.dirname(f)
    if os.path.exists(os.path.normpath(os.path.join(d, tgt))):
        return None  # already fine
    base = tgt
    while base.startswith("../"):
        base = base[3:]
    base = base.lstrip("./")
    if not base:
        return None
    p = os.path.normpath(os.path.join(WS, base))
    if os.path.exists(p):
        return p
    p = os.path.normpath(os.path.join(TH, base))
    if os.path.exists(p):
        return p
    name = os.path.basename(base)
    # Round-local names the harvest recorded without a directory: recover the
    # round from the theorem file's own `tpp-rhNN-` prefix.
    m = re.search(r"tpp-(rh\d+|round\d+)", os.path.basename(f))
    if m and "/" not in base:
        r = m.group(1)
        for cand in (
            os.path.join(WS, "research/twin-prime-parity/rounds", r, base),
            os.path.join(WS, "research/twin-prime-parity/rounds", r, "rounds", base),
            os.path.join(WS, "research/twin-prime-parity", r, base),
        ):
            if os.path.exists(cand):
                return cand
    if base.startswith("rounds/"):
        p = os.path.join(WS, "research/twin-prime-parity", base)
        if os.path.exists(p):
            return p
    if name == "README.md" and "tpp-" in os.path.basename(f):
        p = os.path.join(WS, "research/twin-prime-parity/README.md")
        if os.path.exists(p):
            return p
    if name in OVERRIDES:
        return os.path.join(WS, OVERRIDES[name])
    cand = th_idx.get(name, [])          # theorem-file basenames, unique-match only
    if len(cand) == 1:
        return cand[0]
    cand = ws_idx.get(name, [])          # workspace basenames outside theorems/
    if len(cand) == 1:
        return cand[0]
    return None


def process_file(path: str, ws_idx, th_idx, dry: bool):
    lines = open(path, encoding="utf-8").read().split("\n")
    out = []
    infence = False
    n_fixed = 0
    unresolved = []
    for line in lines:
        if FENCE.match(line):
            infence = not infence
            out.append(line)
            continue
        if infence or "](" not in line:
            out.append(line)
            continue

        def repl(m):
            nonlocal n_fixed
            target = m.group(1)
            if external(target):
                return m.group(0)
            tgt, anchor = split_anchor(target)
            dest = resolve(path, target, ws_idx, th_idx)
            if dest is None:
                if tgt and not os.path.exists(os.path.normpath(os.path.join(os.path.dirname(path), tgt))):
                    unresolved.append(target)
                return m.group(0)
            rel = os.path.relpath(dest, os.path.dirname(path))
            n_fixed += 1
            return "](" + rel + anchor + ")"

        out.append(LINK.sub(repl, line))
    new = "\n".join(out)
    if n_fixed and not dry:
        open(path, "w", encoding="utf-8").write(new)
    return n_fixed, unresolved


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--root", default=TH)
    a = ap.parse_args()
    ws_idx = basename_index(WS, skip_parts=("theorems", ".git"))
    th_idx = basename_index(a.root, skip_parts=())
    total = 0
    unres = defaultdict(int)
    for dp, _d, fs in os.walk(a.root):
        for f in sorted(fs):
            if not f.endswith(".md"):
                continue
            p = os.path.join(dp, f)
            n, u = process_file(p, ws_idx, th_idx, a.dry_run)
            if n:
                total += n
                print(f"  {n:5d}  {os.path.relpath(p, WS)}")
            for x in u:
                unres[x] += 1
    print(f"{'would fix' if a.dry_run else 'fixed'}: {total}")
    if unres:
        print("unresolved:")
        for k, v in sorted(unres.items(), key=lambda kv: -kv[1])[:40]:
            print(f"   {v:5d}  {k}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
