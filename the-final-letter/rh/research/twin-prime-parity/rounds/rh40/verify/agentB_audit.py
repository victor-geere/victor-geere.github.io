#!/usr/bin/env python3
"""AGENT B, round 1 — audit of rh40/code/digitword.py + part (c) N=20 table."""
from __future__ import annotations
import random
import sys
from itertools import combinations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))
from digitword import (  # noqa: E402
    SUPPORT_1_OVER_PI, factor_set, first_difference_check, gaps, p_bruteforce,
    p_offset, right_special_count, right_special_factors, slopes, span,
    word_from_ones,
)

print("### D1. p_offset (offset tuples) vs p_bruteforce (bit strings)")
bad = 0
tested = 0
for N in range(1, 13):
    for m in range(0, min(5, N) + 1):
        for ones in combinations(range(N), m):
            for L in range(1, N + 1):
                tested += 1
                if p_offset(ones, N, L) != p_bruteforce(word_from_ones(ones, N), L):
                    bad += 1
                    if bad < 5:
                        print("  MISMATCH", ones, N, L)
print(f"  exhaustive N<=12, 0..4 ones, all L: {tested} cases, mismatches={bad}")

# decay regime of the 1/pi word, every L
ones, N = SUPPORT_1_OVER_PI, 1400
w = word_from_ones(ones, N)
bad2 = [L for L in range(700, N + 1)
        if p_offset(ones, N, L) != p_bruteforce(w, L)]
print(f"  1/pi N=1400, L in [700,1400] ({N-699} values): mismatches={bad2}")
rng = random.Random(7)
bad3 = 0
for _ in range(400):
    N2 = rng.randint(20, 80)
    m2 = rng.randint(1, 5)
    ones2 = tuple(sorted(rng.sample(range(N2), m2)))
    w2 = word_from_ones(ones2, N2)
    for L in range(1, N2 + 1):
        if p_offset(ones2, N2, L) != p_bruteforce(w2, L):
            bad3 += 1
print(f"  400 random words N in [20,80], all L: mismatches={bad3}")

print("\n### D2. slopes against a hand-computed case")
ones, N = (0, 2), 6
print(f"  hand case ones={ones} N={N}: p = [2,2,4,3,2,1] by hand")
print(f"  p_offset values      = {[p_offset(ones, N, L) for L in range(1, N+1)]}")
print(f"  slopes()             = {slopes(ones, N)}")
print(f"  expected runs        = [(1, 1, 0), (2, 2, 2), (3, 5, -1)]")
print(f"  slopes() on 1/pi     = {slopes(SUPPORT_1_OVER_PI, 1400)}")
print("  (slopes() docstring claims (1,10,1),(11,592,2),(593,604,3) -- compare)")

print("\n### D3. right_special_factors vs an independent bit-string enumeration")
def rs_bruteforce(word, L):
    N = len(word)
    bitsL = {tuple(word[i:i + L]) for i in range(N - L + 1)}
    bitsL1 = {tuple(word[i:i + L + 1]) for i in range(N - L)}
    out = set()
    for f in bitsL:
        if f + (0,) in bitsL1 and f + (1,) in bitsL1:
            out.add(tuple(i for i, b in enumerate(f) if b))
    return out

bad4 = 0
tested4 = 0
for N in range(2, 13):
    for m in range(0, min(4, N) + 1):
        for ones in combinations(range(N), m):
            word = word_from_ones(ones, N)
            for L in range(1, N):
                tested4 += 1
                a = set(right_special_factors(word, L))
                b = rs_bruteforce(word, L)
                if a != b:
                    bad4 += 1
                    if bad4 < 5:
                        print("  MISMATCH", ones, L, sorted(a), sorted(b))
print(f"  exhaustive N<=12, 0..4 ones, all L: {tested4} cases, mismatches={bad4}")
w = word_from_ones(SUPPORT_1_OVER_PI, 1400)
bad5 = [L for L in range(1, 1400)
        if right_special_count(w, L) != len(rs_bruteforce(w, L))]
print(f"  1/pi N=1400, all L: mismatches={bad5}")

print("\n### D4. first_difference_check (code path, p_bruteforce + right_special_count)")
for nm, o, NN in [("1/pi", (2, 13, 607), 1400), ("sqrt2-1", (1, 11, 251), 2000),
                  ("geom", (10, 20, 40, 80), 500), ("e-2 true", (0, 3, 53), 2000)]:
    rows = first_difference_check(word_from_ones(o, NN))
    bad = [r for r in rows if not r[3]]
    print(f"  {nm}: L tested={len(rows)} agree={len(rows)-len(bad)} disagree={len(bad)};"
          f" first fail L={bad[0][0] if bad else None}")

print("\n### C. N=20 exhaustive table: what fixes the plateau value?")
Nn = 20
rows = []
for m in (1, 2, 3, 4):
    for o in combinations(range(Nn), m):
        vals = [p_offset(o, Nn, L) for L in range(1, Nn + 1)]
        rows.append((o, max(vals)))
print(f"  words: {len(rows)}")
hits_am2 = sum(1 for o, mx in rows if mx == o[-1] + 2)
print(f"  max p == a_m + 2 : {hits_am2}/{len(rows)}")
key_gap = {}
key_msp = {}
for o, mx in rows:
    key_gap.setdefault((tuple(gaps(o)), Nn), set()).add(mx)
    key_msp.setdefault((len(o), span(o), Nn), set()).add(mx)
print(f"  keys (gaps,N=20) with >1 max p: "
      f"{sum(1 for v in key_gap.values() if len(v) > 1)}/{len(key_gap)}")
print(f"  keys (m,span,N=20) with >1 max p: "
      f"{sum(1 for v in key_msp.values() if len(v) > 1)}/{len(key_msp)}")
for o, mx in rows:
    if o == (0,) or o == (10,) or o == (11,) or o == (19,):
        print(f"    support {o}: max p = {mx}, a_m+2 = {o[-1]+2}, gaps={gaps(o)}")
# failures of a_m+2: look for a pattern
fails = [(o, mx) for o, mx in rows if mx != o[-1] + 2]
print(f"  a_m+2 failures: {len(fails)}; examples:")
for o, mx in fails[:8]:
    print(f"    {o}: max={mx} a_m+2={o[-1]+2} N-a_m-1={Nn-o[-1]-1} "
          f"gaps={gaps(o)}")
cond = all(mx == o[-1] + 2 for o, mx in rows if Nn - o[-1] - 1 >= o[-1] + 2)
print(f"  does 'N-a_m-1 >= a_m+2  =>  max p = a_m+2' hold on the table? {cond}")
c2 = [ (o,mx) for o,mx in rows if Nn-o[-1]-1 >= o[-1]+2 and mx != o[-1]+2]
print(f"    counterexamples to that condition: {c2[:5]}")
c3 = [ (o,mx) for o,mx in rows if mx != o[-1]+2 and Nn-o[-1]-1 >= span(o)]
print(f"  failures with N-a_m-1 >= span: {c3[:6]}")

print("\n### dialogue-word plateau values vs a_m+2")
for nm, o, NN in [("1/pi", (2, 13, 607), 1400), ("log2", (0, 4, 36, 6069), 13000),
                  ("sqrt2-1", (1, 11, 251), 2000), ("geom", (10, 20, 40, 80), 500),
                  ("true e-2", (0, 3, 53), 2000)]:
    print(f"  {nm:9s} a_m+2={o[-1]+2:5d}  (HANDOFF/exact plateau values: "
          f"609, 6071, 253, 82, 55 respectively)")
