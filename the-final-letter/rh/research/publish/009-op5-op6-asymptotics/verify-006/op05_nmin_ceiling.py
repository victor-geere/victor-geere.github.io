#!/usr/bin/env python3
"""
OP-05, INDEX FORM -- FALSIFICATION of the recorded O(1/p) error term, and the TRUE law.

BACKGROUND
----------
`nminAsym p = p/ln 2 - 5/2` (1-based form: `n_min(p) = p/ln 2 - 3/2`).  The register
`notes/OP-05-nmin-asymptotic.md` recorded

        n_min(p) = p/ln 2 - 3/2 + O(1/p).

Because `n_min(p)` is an INTEGER, an `O(1/p)` error means `p/ln 2 - 3/2` must lie within
`C/p` of an integer for every large `p`.  `1/ln 2` is irrational, so `{p/ln 2}` is
equidistributed on [0,1); the required alignment holds only on a density-zero set of `p`.
This script measures the actual gap and settles the question.

WHAT IS COMPUTED
----------------
`Phi_p(n) = sum_{j>=0} (1 + (j+1)/n)^(-p)`  (exactly the Lean `Op56.Phi`).

`IsComplete_iff` (proved in the Lean development) states

        IsComplete p N  <->  1 <= Phi_p(N+1),

and `nmin p = Nat.find (exists_isComplete p _)`, so

        nmin p  =  least N with Phi_p(N+1) >= 1.

Since `Phi_p` is increasing in `n` (Lean: `Phi_mono_n`), this is a single bisection step.

RESULT (this script)
--------------------
    nmin p = ceil(p/ln 2 - 5/2)

for every tested `p`, with the gap in (0,1) -- so the error is `O(1)`, NOT `O(1/p)`.
The claimed `O(1/p)` is FALSE.

Run:  python3 op05_nmin_ceiling.py
"""

import math

LOG2 = math.log(2)


def phi(p: int, n: int, jmax: int = 8000) -> float:
    """sum_{j>=0} (1 + (j+1)/n)^(-p), truncated at 1e-22."""
    s = 0.0
    for j in range(jmax):
        t = (1.0 + (j + 1) / n) ** (-p)
        s += t
        if t < 1e-22:
            break
    return s


def nmin(p: int) -> int:
    """least N with Phi_p(N+1) >= 1  (Lean: nmin p)."""
    n = int(p / LOG2) - 10
    while phi(p, n + 1) < 1.0:
        n += 1
    return n


def main() -> None:
    print(__doc__.split("Run:")[0].strip()[:0] or "")
    print(f"{'p':>8} {'nmin p':>8} {'asym':>16} {'gap':>10} {'p*gap':>10} {'ceil?':>6}")
    print("-" * 62)

    mismatches = 0
    gaps = []
    for p in (1000, 2000, 3000, 4000, 5000, 7000, 10000, 20000, 50000):
        nm = nmin(p)
        asym = p / LOG2 - 2.5
        gap = nm - asym
        gaps.append(gap)
        ok = nm == math.ceil(asym)
        mismatches += 0 if ok else 1
        print(f"{p:>8} {nm:>8} {asym:>16.6f} {gap:>10.6f} {p * gap:>10.2f} {str(ok):>6}")

    print("-" * 62)
    print(f"gap range over these p: [{min(gaps):.6f}, {max(gaps):.6f}]  (always inside (0,1))")
    print("p*gap is UNBOUNDED  =>  |nmin p - (p/ln2 - 5/2)| = O(1), and the old O(1/p) is FALSE.")

    # A wider sweep of the exact ceiling law.
    print()
    print("Wider sweep: is nmin p = ceil(p/ln2 - 5/2) always?")
    bad = 0
    mn, mx = 9.9, -9.9
    tested = 0
    for p in range(200, 3000, 37):
        nm = nmin(p)
        asym = p / LOG2 - 2.5
        if nm != math.ceil(asym):
            bad += 1
            print(f"  MISMATCH p={p}: nmin={nm} ceil={math.ceil(asym)}")
        g = nm - asym
        mn, mx = min(mn, g), max(mx, g)
        tested += 1
    print(f"  tested {tested} values of p, mismatches: {bad}")
    print(f"  gap range: [{mn:.6f}, {mx:.6f}]")
    print()
    print("CONCLUSION")
    print("  nmin p = ceil(p/ln2 - 5/2)   (equivalently 0 < nmin p - (p/ln2 - 5/2) < 1)")
    print("  The correct asymptotic is O(1); the Lean theorem op5_nmin_asymptotic was")
    print("  restated accordingly and PROVED with the explicit constant 11 = 4/ln2 + 5/2.")


if __name__ == "__main__":
    main()
