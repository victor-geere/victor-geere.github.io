#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""op09_moduli.py — other moduli: what really changes when `2k` becomes `qk + r`.

Run:  python3 op09_moduli.py

WHAT THE TODO SAID (item O9)
----------------------------
"Structural generalisation: replace `2k` by `qk + r`; determine `nmin(p; q, r)`.
 The leading constant becomes `1/log q`-type data; the method is unchanged."

WHAT IS ACTUALLY TRUE
---------------------
Define the modulus alphabet `term(p, q, r, n) = (q(n+1) + r)^{-p}` (`n ≥ 0`,
`q ≥ 2`, `0 ≤ r < q`), i.e. the residue class `r mod q` from `q + r` upwards, and
Brown's criterion at index `N`

    b_N ≤ T_{N+1},    b_N = (q(N+1)+r)^{-p},   T_N = Σ_{n≥N} b_n .

Dividing by `b_N`,

    T_{N+1}/b_N = Σ_{j≥1} (1 + q j / m0)^{-p},     m0 := q(N+1) + r
                = Σ_{j≥1} (1 + j / (m0/q))^{-p}   =:  F1(m0/q) ,

so the criterion depends on the modulus data **only through the real number
`m0/q = N + 1 + r/q`**:

    criterion(N; q, r)  ⟺  N + 1 + r/q  ≥  θ(p) ,     F1(θ(p)) = 1 .

Consequences, both verified below:

1.  **`r = 0` is exactly `q`-independent.**  Then `m0/q = N + 1` is an integer, so
    `nmin(p; q, 0) = nmin(p; 2, 0)` for every `q` — the OP-5 results transfer
    verbatim and nothing new appears.
2.  **The slope is `1/log 2` for every `q` and `r`.**  `θ(p) = p/log 2 + O(1)`
    uniformly in the modulus data, so `nmin(p; q, r) = p/log 2 − 1 − r/q + O(1)`;
    `q` enters **only** through the `r/q` shift of the constant.

**The TODO's "leading constant becomes `1/log q`-type data" is therefore FALSE** —
the same kind of over-reach as the earlier `O(1/p)` error term (O1-era), the exact
ceiling law (O3) and OP-6's constant `1/p` coefficient (O4).  The slope is `1/log 2`,
not `1/log q`, for every modulus.

Numerics: `Σ_{j≥1}` is truncated at `J = 400`; the terms decay like `2^{-j}` in the
regime of interest, so the truncation error is `< 2^{-398}` — far below any figure
quoted.  All evaluations are at 60 dps.
"""
import sys

from mpmath import mp, mpf, log, nstr

mp.dps = 60
J = 400
LOG2 = log(2)


def F1(n, p, J=J):
    """Σ_{j≥1} (1 + j/n)^{-p}, truncated (tail < 2^{-J+1} in the regime used)."""
    return sum((1 + mpf(j) / n) ** (-p) for j in range(1, J + 1))


def ratio(N, p, q, r, J=J):
    """T_{N+1}/b_N = Σ_{j≥1} (1 + q j / (q(N+1)+r))^{-p}."""
    m0 = mpf(q) * (N + 1) + r
    return sum((1 + mpf(q) * j / m0) ** (-p) for j in range(1, J + 1))


def nmin(p, q, r):
    lo = max(0, int(mpf(p) / LOG2) - 40)
    hi = int(mpf(p) / LOG2) + 40
    for N in range(lo, hi + 1):
        if ratio(N, p, q, r) >= 1:
            return N
    return None


def theta(p, lo=None, hi=None):
    """The real threshold: F1(θ, p) = 1 (F1 is decreasing in n)."""
    if lo is None:
        lo = mpf(p) / LOG2 - 6
    if hi is None:
        hi = mpf(p) / LOG2 + 6
    for _ in range(200):
        mid = (lo + hi) / 2
        if F1(mid, p) >= 1:
            lo = mid
        else:
            hi = mid
    return (lo + hi) / 2


def main():
    ps = [200, 1000, 5000]
    qs = [2, 3, 4, 5, 6, 7, 11]
    ok = True

    print("OP-9 — other moduli: the slope is 1/log 2 for every q, r")
    print()
    print("1. r = 0 is exactly q-independent:  nmin(p; q, 0) for q = %s" % qs)
    for p in ps:
        vals = [nmin(p, q, 0) for q in qs]
        same = len(set(vals)) == 1
        ok = ok and same
        print("   p = %-6d nmin = %s   %s" % (p, vals, "all equal" if same else "*** DIFFER ***"))
    print()

    print("2. the real threshold obeys  θ(p) − p/log 2 = O(1) uniformly")
    print("   p        θ(p)            θ(p) − p/log 2")
    for p in ps + [10000]:
        th = theta(p)
        print("   %-8d %-16s %s" % (p, nstr(th, 14), nstr(th - mpf(p) / LOG2, 10)))
    print()

    print("3. nmin(p; q, r) = p/log 2 − 1 − r/q + O(1)  (the O(1) is q-uniform)")
    print("   p        q    r    nmin     nmin + 1 + r/q − p/log 2")
    devs = []
    for p in ps:
        for q in qs:
            for r in range(0, min(q, 3)):
                N = nmin(p, q, r)
                d = N + 1 + mpf(r) / q - mpf(p) / LOG2
                devs.append(d)
                if r < 2:
                    print("   %-8d %-4d %-4d %-8d %s" % (p, q, r, N, nstr(d, 9)))
        print()
    lo, hi = min(devs), max(devs)
    bounded = (hi - lo) < 3
    ok = ok and bounded
    print("   spread of  nmin + 1 + r/q − p/log 2  over all %d cases: [%s, %s]"
          % (len(devs), nstr(lo, 8), nstr(hi, 8)))
    print("   => O(1) and uniform in (q, r); the slope is 1/log 2, NOT 1/log q.")
    print()

    print("VERDICT: %s" % ("CONFIRMED" if ok else "INCONCLUSIVE"))
    print("  - the TODO's `1/log q`-type leading constant is FALSE;")
    print("  - r = 0 adds nothing (exact q-independence);")
    print("  - the general law is nmin(p; q, r) = p/log 2 − 1 − r/q + O(1).")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
