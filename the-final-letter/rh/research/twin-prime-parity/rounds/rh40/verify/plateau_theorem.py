#!/usr/bin/env python3
"""
rh40 / plateau_theorem.py — exhaustive machine corroboration of the K1 proof.

Theorem A (rh40/K1_plateau_theorem.md).  For any finitely supported 0/1 word of
length N with support 0 <= a_0 < ... < a_m < N and span = a_m - a_0:

    for   max(span, a_m + 1) <= L <= N - 1 :
        p(L) = min(a_m + 1, N - L + 1) + [ L <= N - a_m - 1 ].

Corollary B:  p(L) = a_m + 2   for   max(span, a_m+1) <= L <= N - a_m - 1.
Corollary C:  p(L) = N - L + 1 for   L >= N - a_m - 1  (the decay law).

The proof is Lemma 1 (the max offset of a factor containing a_m is a_m - t, so
the window start is recoverable) plus Lemma 2 (bookkeeping of which windows
contain a_m and whether an all-zero window exists).  This script does not
re-prove it; it searches for a counterexample.

Run:  python3 rh40/verify/plateau_theorem.py
"""

from __future__ import annotations

import sys
from itertools import combinations
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent / "code"))

from digitword import gaps, p_offset, span  # noqa: E402

fails: list[str] = []


def check(label: str, cond: bool, detail: str = "") -> None:
    print(f"  [{'OK' if cond else 'FAIL':4s}] {label}" + (f"   {detail}" if detail else ""))
    if not cond:
        fails.append(label)


def theorem_a(ones, N, L: int) -> int:
    a_m = ones[-1]
    return min(a_m + 1, N - L + 1) + (1 if L <= N - a_m - 1 else 0)


# --------------------------------------------------------------------------- #
# 1. exhaustive small-case search
# --------------------------------------------------------------------------- #


def exhaustive(NMAX: int = 31, MMAX: int = 4) -> None:
    print("=" * 78)
    print(f"1.  Theorem A exhaustively: all supports, m+1 <= {MMAX}, N <= {NMAX}")
    print("=" * 78)
    nsup = ncase = nbad_a = nbad_b = nbad_c = 0
    first = None
    for N in range(3, NMAX + 1):
        for m in range(1, min(MMAX, N)):
            for ones in combinations(range(0, N), m):
                sp = span(ones)
                a_m = ones[-1]
                lo = max(sp, a_m + 1, 1)
                if lo > N - 1:
                    continue
                nsup += 1
                for L in range(lo, N):
                    ncase += 1
                    got = p_offset(ones, N, L)
                    if theorem_a(ones, N, L) != got:
                        nbad_a += 1
                        first = first or ("A", ones, N, L, theorem_a(ones, N, L), got)
                    # Corollary B, on its own range
                    if L <= N - a_m - 1 and got != a_m + 2:
                        nbad_b += 1
                    # Corollary C, on its own range
                    if L >= N - a_m - 1 and got != N - L + 1:
                        nbad_c += 1
    check("Theorem A: 0 counterexamples", nbad_a == 0,
          f"{nsup} supports, {ncase} (support,L) pairs, {nbad_a} failures")
    if first:
        print("      first failure:", first)
    check("Corollary B (p = a_m+2 on the plateau): 0 counterexamples", nbad_b == 0,
          f"{nbad_b}")
    check("Corollary C (decay p = N-L+1): 0 counterexamples", nbad_c == 0,
          f"{nbad_c}")


# --------------------------------------------------------------------------- #
# 2. the dialogue words at their published truncations
# --------------------------------------------------------------------------- #


DIALOGUE = [
    ("1/pi", (2, 13, 607), 1400),
    ("log2", (0, 4, 36, 6069), 13000),
    ("sqrt2-1", (1, 11, 251), 2000),
    ("(10,20,40,80)", (10, 20, 40, 80), 500),
    ("true e-2", (0, 3, 53), 2000),
]


def dialogue_words() -> None:
    print("\n" + "=" * 78)
    print("2.  Theorem A on the dialogue words, every L from the theorem's bound")
    print("=" * 78)
    for name, ones, N in DIALOGUE:
        sp, a_m = span(ones), ones[-1]
        lo = max(sp, a_m + 1)
        bad = [L for L in range(lo, N) if theorem_a(ones, N, L) != p_offset(ones, N, L)]
        check(f"{name}: Theorem A holds for all L in [{lo}, {N-1}]", not bad,
              f"{len(bad)} failures" + (f" first {bad[:3]}" if bad else ""))


# --------------------------------------------------------------------------- #
# 3. the plateau value and its exact end
# --------------------------------------------------------------------------- #


def plateau() -> None:
    print("\n" + "=" * 78)
    print("3.  max p = a_m + 2, and the plateau ends exactly at N - a_m - 1")
    print("=" * 78)
    for name, ones, N in DIALOGUE:
        a_m = ones[-1]
        # value, computed without a full sweep: p at the plateau right edge
        p_edge = p_offset(ones, N, N - a_m - 1)
        check(f"{name}: p(N - a_m - 1) = a_m + 2", p_edge == a_m + 2,
              f"p={p_edge}, a_m+2={a_m+2}")
        # and nothing exceeds it (sampled, to stay off the O(N^2) path)
        top = max(p_offset(ones, N, L) for L in range(1, N + 1))
        check(f"{name}: max_L p(L) = a_m + 2", top == a_m + 2,
              f"max={top}")
        # the plateau cannot extend past N - a_m - 1 (indicator flips)
        check(f"{name}: plateau ends at N - a_m - 1",
              p_offset(ones, N, N - a_m) == N - (N - a_m) + 1,
              f"p(N-a_m)={p_offset(ones, N, N-a_m)}")


# --------------------------------------------------------------------------- #
# 4. the decay law, proved by the same statement
# --------------------------------------------------------------------------- #


def decay() -> None:
    print("\n" + "=" * 78)
    print("4.  Corollary C: p(L) = N - L + 1 for L >= N - a_m - 1")
    print("=" * 78)
    for name, ones, N in DIALOGUE:
        a_m = ones[-1]
        Ls = list(range(N - a_m - 1, N))
        bad = [L for L in Ls if p_offset(ones, N, L) != N - L + 1]
        check(f"{name}: decay law on all {len(Ls)} values L in "
              f"[{N-a_m-1}, {N-1}]", not bad, f"{len(bad)} failures")


# --------------------------------------------------------------------------- #
# 5. the theorem is combinatorial, not arithmetic
# --------------------------------------------------------------------------- #


def combinatorial() -> None:
    print("\n" + "=" * 78)
    print("5.  The law is combinatorial: random supports, not just greedy words")
    print("=" * 78)
    import random
    rng = random.Random(20261003)
    n = 0
    bad = 0
    for _ in range(3000):
        N = rng.randint(5, 200)
        k = rng.randint(1, 5)
        ones = tuple(sorted(rng.sample(range(N), min(k, N))))
        sp, a_m = span(ones), ones[-1]
        lo = max(sp, a_m + 1, 1)
        if lo > N - 1:
            continue
        n += 1
        for L in (lo, (lo + N - 1) // 2, N - 2, N - 1):
            if lo <= L <= N - 1 and theorem_a(ones, N, L) != p_offset(ones, N, L):
                bad += 1
    check("random non-greedy supports obey Theorem A", bad == 0,
          f"{n} supports sampled, {bad} failures")


def main() -> None:
    exhaustive()
    dialogue_words()
    plateau()
    decay()
    combinatorial()
    print("\n" + "=" * 78)
    print("RESULT: " + ("THEOREM A CORROBORATED, NO COUNTEREXAMPLE" if not fails
                        else f"{len(fails)} FAILED"))
    for f in fails:
        print("  FAILED:", f)
    print("=" * 78)


if __name__ == "__main__":
    main()
