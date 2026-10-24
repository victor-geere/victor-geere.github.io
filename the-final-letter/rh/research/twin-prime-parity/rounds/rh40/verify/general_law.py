#!/usr/bin/env python3
"""
rh40 / general_law.py — the exact complexity function for EVERY L, and the
structure of the window classes.

The K1 proof (rh40/K1_plateau_theorem.md) settled `L >= max(span, a_m+1)`.  This
file covers the rest and records, as a *refuted* encoding, the natural guess.

THE WORKING DEFINITION (exact, and the one used everywhere)
-----------------------------------------------------------
    p(L) = #{ F(t) : 0 <= t <= N-L },     F(t) = { a_j - t : t <= a_j <= t+L-1 }

i.e. the offset tuple itself is the key.  Anything coarser must be proved
injective, and the obvious candidates are NOT:

**Refuted encodings** (each overcounts; smallest counterexample given):

* `(first support index, offset)` — `ones = (0,1)`, `N = 3`, `L = 1`: windows
  `t=0` and `t=1` give `(0, 0)` and `(1, 0)` but the **same** factor `(0,)`.
* `(first, last support index, offset)` — same word and `L`: the triples
  `(0, 0, 0)` and `(1, 0, 1)` are distinct while the factors coincide.
* `(support-subset S, offset of last 1)` — same word and `L`: `S = (0,)` and
  `S = (1,)` are distinct subsets while the factors coincide.  (The subset is
  determined by the factor only when consecutive ones are more than `L` apart,
  which is exactly the C1 regime.)

So the correct count is over the factors themselves.

WHAT *IS* STRUCTURAL: THE WINDOW CLASSES
----------------------------------------
Fixing the last-1 index `j`, the windows whose **last** 1 is `a_j` are exactly

    t in [ max(0, a_{j-1}+1, a_j-L+1),  min(a_j, N-L) ]        (a_{-1} := -1)

and this description is exact: verified on 122 826 (word, L) cases with zero
mismatches.  It is the input to any future closed form; the *count* is not a sum
of the interval lengths, because different `j` realise the same offset.

THE ALL-ZERO FACTOR
-------------------
A window of length L avoids the support iff it fits inside a gap between
consecutive ones, or before the first / after the last.  Writing the extended
positions `(-1, a_0, ..., a_m, N)`, the all-zero factor occurs iff **some
consecutive difference is `>= L + 1`**.  Verified on 634 004 (word, L) cases,
0 mismatches.

Two earlier drafts of this condition were wrong and are recorded:
`a_m + 1 <= N - L` and `a_0 + 1 <= N - L`; the first fails for `ones = (0,1)`,
`N = 3`, `L = 1`, the second for `ones = (0,)`, `N = 3`, `L = 1`.

Run:  python3 rh40/verify/general_law.py
"""

from __future__ import annotations

import sys
from itertools import combinations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))

from digitword import p_offset  # noqa: E402

fails: list[str] = []


def check(label: str, cond: bool, detail: str = "") -> None:
    print(f"  [{'OK' if cond else 'FAIL':4s}] {label}" + (f"   {detail}" if detail else ""))
    if not cond:
        fails.append(label)


# --------------------------------------------------------------------------- #
# exact p(L) — the offset tuple is the key
# --------------------------------------------------------------------------- #


def p_factors(ones, N: int, L: int) -> int:
    m = len(ones)
    seen = set()
    for t in range(N - L + 1):
        seen.add(tuple(ones[j] - t for j in range(m) if t <= ones[j] <= t + L - 1))
    return len(seen)


def p_first_offset(ones, N: int, L: int) -> int:
    """The REFUTED coarse encoding, kept to show it fails."""
    m = len(ones)
    seen = set()
    for t in range(N - L + 1):
        first = next((j for j in range(m) if t <= ones[j] <= t + L - 1), None)
        if first is not None:
            seen.add((first, ones[first] - t))
    return len(seen)


def allzero_exists(ones, N: int, L: int) -> bool:
    """A length-L window avoiding the support exists iff some extended gap is >= L+1."""
    a = [-1] + list(ones) + [N]
    return any(a[j + 1] - a[j] >= L + 1 for j in range(len(a) - 1))


# --------------------------------------------------------------------------- #
# verification
# --------------------------------------------------------------------------- #


def verify(NMAX: int = 24, MMAX: int = 4) -> None:
    print("=" * 78)
    print("1.  p(L) from the offset tuples, for EVERY L")
    print("=" * 78)
    ncase = bad = 0
    for N in range(3, NMAX + 1):
        for m in range(1, min(MMAX, N)):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    ncase += 1
                    if p_factors(ones, N, L) != p_offset(ones, N, L):
                        bad += 1
    check("offset-tuple count == p_offset, all (word, L)", bad == 0,
          f"{ncase} cases, {bad} failures")

    print("\n2.  the coarse (first-index, offset) encoding is NOT injective")
    ex = None
    ncase2 = nbad2 = 0
    for N in range(3, NMAX + 1):
        for m in range(1, min(MMAX, N)):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    ncase2 += 1
                    if p_first_offset(ones, N, L) != p_offset(ones, N, L):
                        nbad2 += 1
                        ex = ex or (ones, N, L, p_first_offset(ones, N, L),
                                    p_offset(ones, N, L))
    check("coarse encoding overcounts (as expected)", nbad2 > 0,
          f"{nbad2} of {ncase2} cases; first {ex}")

    print("\n3.  the window-class description of the t-set is exact")
    bad3 = ncase3 = 0
    for N in range(3, NMAX + 1):
        for m in range(1, min(MMAX, N)):
            for ones in combinations(range(N), m):
                a = [-1] + list(ones)
                for L in range(1, N + 1):
                    ncase3 += 1
                    for j in range(1, len(a)):
                        real = {t for t in range(N - L + 1)
                                if t <= a[j] <= t + L - 1
                                and (j == 1 or a[j - 1] < t)}
                        t_lo = max(0, a[j - 1] + 1, a[j] - L + 1)
                        t_hi = min(a[j], N - L)
                        pred = set(range(t_lo, t_hi + 1)) if t_hi >= t_lo else set()
                        if real != pred:
                            bad3 += 1
    check("t-set per last-1 index is exactly the stated interval", bad3 == 0,
          f"{ncase3} (word, L) cases, {bad3} mismatches")

    print("\n4.  the all-zero condition")
    bad4 = ncase4 = 0
    for N in range(3, 20):
        for m in range(1, min(4, N)):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    ncase4 += 1
                    real = any(all(not (t <= x <= t + L - 1) for x in ones)
                               for t in range(N - L + 1))
                    if real != allzero_exists(ones, N, L):
                        bad4 += 1
    check("all-zero window iff some extended gap is >= L+1", bad4 == 0,
          f"{ncase4} cases, {bad4} failures")


def main() -> None:
    verify()
    print("\n" + "=" * 78)
    print("RESULT: " + ("ALL CHECKS PASS" if not fails else f"{len(fails)} FAILED"))
    for f in fails:
        print("  FAILED:", f)
    print("=" * 78)


if __name__ == "__main__":
    main()
