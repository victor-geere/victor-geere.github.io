#!/usr/bin/env python3
"""Ablation harness: how much .olean does each generated lemma family cost?

Reads a file emitted by panels.py, replaces the proofs of every theorem whose
name matches a given prefix pattern by `sorry`, and reports the .olean size.
Used to find the certificate-size bottleneck.  Not part of the build.
"""
import re
import subprocess
import sys

path = sys.argv[1]
keep = set(sys.argv[2:])          # families to keep proved; all others sorried

src = open(path).read().split("\n\n")
out = []
for block in src:
    m = re.search(r"^theorem ([A-Za-z0-9_]+)", block, re.M)
    if not m:
        out.append(block)
        continue
    name = m.group(1)
    fam = re.match(r"([a-z]+)", name).group(1)
    if keep and fam in keep:
        out.append(block)
        continue
    # keep the statement, drop the proof
    idx = block.find(":= by")
    if idx >= 0:
        block = block[:idx] + ":= by\n  sorry"
    out.append(block)

open(path, "w").write("\n\n".join(out))
print(f"ablated {path}: kept families {sorted(keep) if keep else 'none'}")
