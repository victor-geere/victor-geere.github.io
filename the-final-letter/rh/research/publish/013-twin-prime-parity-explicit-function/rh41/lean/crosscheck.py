#!/usr/bin/env python3
"""
rh41/lean/crosscheck.py — independent check of the *statements* formalised in
the Lean files against the Python ground truth (`rh41/rigorous_check.py`).

The Lean proofs are checked by the Lean kernel; what this script checks is that
the Lean statements say what `TRUTHS.md` means, by re-evaluating the same
formulas with the reference implementation `p_ref` / `allzero_ref` /
`allzero_gap` over all small objects.

Run:  python3 rh41/lean/crosscheck.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import sys
from itertools import combinations
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
RH41 = HERE.parent
sys.path.insert(0, str(RH41.parent))

from rh41.rigorous_check import allzero_gap, allzero_ref, p_ref  # noqa: E402

FAILS: list[str] = []
NCASES = 0


def check(label: str, ok: bool, detail: str = "") -> None:
    print(f"  {'PASS' if ok else 'FAIL'}  {label}" + (f"   [{detail}]" if detail else ""))
    if not ok:
        FAILS.append(label)


def theorem1_formula(ones, N: int, L: int) -> int:
    """The right-hand side of `DigitWord.complexity_main`."""
    am = ones[-1]
    return min(am + 1, N - L + 1) + (1 if L <= N - am - 1 else 0)


def theorem5_hypotheses_lean(ones, N: int, L: int) -> bool:
    """The hypotheses of `DigitWord.complexity_c1` (gaps as a pairwise bound)."""
    if not 1 <= L <= N:
        return False
    if any(L > b - a for a, b in combinations(ones, 2)):
        return False
    return L <= ones[0] and L <= N - ones[0] - 1


def window_count_formula(am: int, N: int, L: int) -> int:
    """The right-hand side of `WindowCount.card_windows_containing` (in Z)."""
    return max(0, min(am, N - L) - max(0, am - L + 1) + 1)


def check_theorem1(Nmax: int = 25, mmax: int = 4) -> None:
    global NCASES
    bad = cases = 0
    for N in range(2, Nmax + 1):
        for m in range(1, min(mmax, N) + 1):
            for ones in combinations(range(N), m):
                a0, am = ones[0], ones[-1]
                for L in range(max(am - a0, am + 1, 1), N + 1):
                    cases += 1
                    if p_ref(ones, N, L) != theorem1_formula(ones, N, L):
                        bad += 1
    NCASES += cases
    check("DigitWord.complexity_main (Theorem 1) matches p_ref", bad == 0,
          f"{cases} (word, N, L) cases, {bad} violations")


def check_theorem5(Nmax: int = 25, mmax: int = 4) -> None:
    global NCASES
    bad = cases = 0
    for N in range(2, Nmax + 1):
        for m in range(1, min(mmax, N) + 1):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    if theorem5_hypotheses_lean(ones, N, L):
                        cases += 1
                        if p_ref(ones, N, L) != L + 1:
                            bad += 1
    NCASES += cases
    check("DigitWord.complexity_c1 (Theorem 5) matches p_ref", bad == 0,
          f"{cases} cases, {bad} violations")


def check_allzero(Nmax: int = 20, mmax: int = 5) -> None:
    global NCASES
    bad = cases = 0
    for N in range(2, Nmax + 1):
        for m in range(1, min(mmax, N) + 1):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    cases += 1
                    if allzero_ref(ones, N, L) != allzero_gap(ones, N, L):
                        bad += 1
    NCASES += cases
    check("AllZero.allZero_iff_hasLargeGap (claim A2) matches the reference",
          bad == 0, f"{cases} cases, {bad} violations")


def check_window_count(Nmax: int = 30) -> None:
    global NCASES
    bad = cases = 0
    for N in range(1, Nmax + 1):
        for L in range(1, N + 1):
            for am in range(0, N + 3):
                cases += 1
                brute = sum(1 for t in range(N - L + 1) if t <= am <= t + L - 1)
                if brute != window_count_formula(am, N, L):
                    bad += 1
    NCASES += cases
    check("WindowCount.card_windows_containing matches the brute-force count",
          bad == 0, f"{cases} cases, {bad} violations")


def check_onset() -> None:
    global NCASES
    from rh41.rigorous_check import onset

    NCASES += 2
    o1, o2 = onset((0, 2), 6), onset((1, 3), 6)
    check("Theorem 6 counterexample: onsets are 3 for {0,2} and 2 for {1,3} "
          "(TRUTHS.md prints them interchanged)", (o1, o2) == (3, 2),
          f"onset({(0,2)},6)={o1}, onset({(1,3)},6)={o2}")


def check_termination_census(cap: int = 5_000_000) -> None:
    """`Harmonic.terminates_rat` plus `TRUTHS.md` §3's census.

    All 277 reduced `p/q`, `q <= 30`, terminate; exactly 275 do so within
    `n <= 5*10^6`, the two exceptions being `4/25` and `27/29` (which is what
    `TRUTHS.md` §3 records).  The cap keeps the script fast; the *termination*
    itself is the Lean theorem, this is the census only.
    """
    global NCASES
    reached, total, deep = 0, 0, []
    for q in range(2, 31):
        for p in range(1, q):
            if gcd(p, q) != 1:
                continue
            total += 1
            # exact integer arithmetic on p/q
            num, den, step = p, q, 0
            while num > 0 and step < cap:
                # num/den >= 1/(step+2)  <=>  num*(step+2) >= den
                if num * (step + 2) >= den:
                    num, den = num * (step + 2) - den, den * (step + 2)
                step += 1
            if num == 0:
                reached += 1
            else:
                deep.append((p, q))
    NCASES += total
    check("Harmonic.terminates_rat census: 275 of the 277 reduced p/q with "
          "q <= 30 halt within the cap, the exceptions being 4/25 and 27/29",
          (total, reached, sorted(deep)) == (277, 275, [(4, 25), (27, 29)]),
          f"{reached} of {total} within the cap; beyond it: {sorted(deep)}")


def main() -> int:
    print("=" * 78)
    print("rh41/lean crosscheck — Lean statement shapes vs the Python reference")
    print("=" * 78)
    check_theorem1()
    check_theorem5()
    check_allzero()
    check_window_count()
    check_onset()
    check_termination_census()
    print("-" * 78)
    if FAILS:
        print(f"{len(FAILS)} FAILED ({NCASES} cases examined)")
        for f in FAILS:
            print("  FAILED:", f)
        return 1
    print(f"all checks pass ({NCASES} cases examined)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
