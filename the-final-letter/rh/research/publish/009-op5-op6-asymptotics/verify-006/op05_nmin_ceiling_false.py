#!/usr/bin/env python3
"""
OP-05, INDEX FORM -- the exact ceiling law is FALSE.

BACKGROUND
----------
`nminAsym p = p/ln 2 - 5/2` and the recorded "exact ceiling law" is

        nmin p = ceil(p/ln 2 - 5/2),                            (CEIL)

equivalently `0 < nmin p - (p/ln 2 - 5/2) < 1`, or `nmin p = ceil(y) - 1` with
`y = p/ln 2 - 3/2`.  (`nmin p` = least `N` with `Phi_p(N+1) >= 1`, where
`Phi_p(n) = sum_{k>=1} (1 + k/n)^(-p)`.)

At a threshold crossing one has, from the third-order expansion
`Phi_{un}(n) = (e^u-1)^(-1) + u*PhiS(u)/(2n) + D(u)/n^2 + O(n^-3)` with `u = p/n`,

        n_*(p) := (real crossing of n |-> Phi_p(n)) = y + F,
        F = -b/(n_* ln 2) + O(1/n^2),   b = 3(ln 2)^2 - (25/12) ln 2 < 0,

so `F ~ 2.6976e-3 / p > 0`.  Hence (for non-integer `y`)

        nmin p = ceil(n_*) - 1 = ceil(y) - 1   if and only if   1 - {y} > F.

(CEIL) therefore fails exactly when `1 - {y} < F`, i.e. when `2/ln 2` has an
*extraordinarily good* rational approximation `(2m+5)/p` with odd numerator:

        p*(M - p*beta) < 2*(-b)/ln 2,   beta = 2/ln 2,   M odd, M > p*beta.

Such `p` are continued-fraction denominators of `2/ln 2` with a large enough partial
quotient; they are sparse (the count up to `P` grows like `c*ln P`), which is why the
previous `p <= 50000` sweeps found no mismatch.

WHAT THIS SCRIPT DOES
---------------------
1. Positive control: (CEIL) at `p = 1000, 5000, 10000` (the values in handoff.md).
2. Continued-fraction search of `beta = 2/ln 2` for the smallest predicted failure.
3. Verification at 1150 decimal digits: `Phi_p(ceil(y)) < 1 < Phi_p(ceil(y)+1)` while
   `ceil(p/ln 2 - 5/2) = ceil(y) - 1`, so `nmin p = ceil(y) = ceil(p/ln 2 - 5/2) + 1`.

RESULT
------
The first counterexample found has 451 decimal digits; (CEIL) fails by exactly `+1`:

        nmin p = ceil(p/ln 2 - 5/2) + 1.

Consequently (CEIL) cannot be a theorem.  The strongest true uniform statement is

        nmin p in { ceil(p/ln 2 - 5/2), ceil(p/ln 2 - 5/2) + 1 }.

NOTE ON THE WINDOWS
-------------------
This also shows that *no* sharpening of `Phi_window_low`/`Phi_window_high` can rescue (CEIL):
a two-sided window whose slack in `w = p/n - ln 2` is `K/n^2` for a fixed `K` decides the
crossing only when `1 - {y} > K/(n ln 2)`, and the bad cases are precisely those where this
fails.  A sharpened window (slack `~ |b|/n^2`) would prove the *weaker* disjunction above.

Run:  python3 op05_nmin_ceiling_false.py
"""

from mpmath import mp, mpf, log, exp, log1p, ceil, floor


def phi(p: int, n: int, tol_digits: int) -> mpf:
    """Phi_p(n) = sum_{k>=1} (1+k/n)^(-p), summed to `tol_digits`."""
    s = mpf(0)
    k = 1
    tol = mpf(10) ** (-tol_digits)
    while True:
        t = exp(-mpf(p) * log1p(mpf(k) / n))
        s += t
        if t < tol:
            return s
        k += 1
        if k > 200000:
            raise RuntimeError("Phi did not converge")


def nmin(p: int, tol_digits: int) -> int:
    """Least N with Phi_p(N+1) >= 1 (the Lean `Op56.nmin`)."""
    n = int(mpf(p) / log(2)) - 20
    if n < 1:
        n = 1
    while phi(p, n + 1, tol_digits) < 1:
        n += 1
    return n


def positive_control() -> None:
    mp.dps = 60
    print("[1] positive control -- (CEIL) holds for the handoff.md values:")
    for p in (1000, 5000, 10000):
        nm = nmin(p, 50)
        c = int(ceil(mpf(p) / log(2) - mpf(5) / 2))
        print(f"    p={p:>6}  nmin={nm:>6}  ceil(p/ln2-5/2)={c:>6}  ok={nm == c}")
    print()


def find_candidate() -> tuple:
    """Smallest p with p*(M - p*beta) < 2*(-b)/ln 2, M odd, M > p*beta."""
    print("[2] continued-fraction search of beta = 2/ln 2:")
    mp.dps = 4000
    beta = 2 / log(2)
    b = 3 * log(2) ** 2 - (mpf(25) / 12) * log(2)
    thresh = 2 * (-b) / log(2)
    print(f"    failure threshold  Q*(M-Q*beta) < {mp.nstr(thresh, 8)}")
    p0, q0 = 0, 1
    p1, q1 = 1, 0
    x = beta
    best = None
    for step in range(3000):
        ai = int(floor(x))
        x = 1 / (x - ai)
        p0, p1 = p1, ai * p1 + p0
        q0, q1 = q1, ai * q1 + q0
        for t in range(1, ai + 1):
            P = p0 + t * p1
            Q = q0 + t * q1
            if Q == 0 or P % 2 == 0:
                continue
            e = Q * beta - P          # Q*beta - P
            if e < 0:                 # P lies above Q*beta: M = P
                val = -e * Q          # Q*(P - Q*beta)
                if val < thresh and (best is None or Q < best[0]):
                    best = (Q, P, val)
                    print(f"    step {step}: Q has {len(str(Q))} digits, "
                          f"Q*(M-Q*beta) = {mp.nstr(val, 8)}")
        if best is not None and step > 900:
            break
    if best is None:
        raise RuntimeError("no candidate found")
    print()
    return best


def verify(p: int) -> None:
    print(f"[3] verification at 1150 dps; p has {len(str(p))} digits:")
    print(f"    p = {p}")
    mp.dps = 1150
    L = log(2)
    y = mpf(p) / L - mpf(3) / 2
    M1 = int(ceil(y))
    A = mpf(p) / L - mpf(5) / 2
    cA = int(ceil(A))
    nm = nmin(p, 1100)
    print(f"    ceil(p/ln2 - 5/2) = ceil(y) - 1 = ...{str(cA)[-20:]}")
    print(f"    ceil(y)                          = ...{str(M1)[-20:]}")
    print(f"    nmin p (computed)                = ...{str(nm)[-20:]}")
    for d in (-1, 0, 1):
        v = phi(p, M1 + d, 1100) - 1
        print(f"    Phi_p(ceil(y){d:+d}) - 1 = {mp.nstr(v, 15)}")
    assert phi(p, M1 - 1, 1100) - 1 < 0, "Phi_p(ceil(y)-1) should be < 1"
    assert phi(p, M1, 1100) - 1 < 0, "expected Phi_p(ceil(y)) < 1 (the failure)"
    assert phi(p, M1 + 1, 1100) - 1 > 0, "Phi_p(ceil(y)+1) should be > 1"
    assert nm == M1, "expected nmin p = ceil(y)"
    assert cA == M1 - 1, "expected ceil(p/ln2-5/2) = ceil(y)-1"
    print(f"    => nmin p = ceil(p/ln2-5/2) + 1  --  (CEIL) FAILS")
    print()


def main() -> None:
    positive_control()
    best = find_candidate()
    verify(best[0])
    print("CONCLUSION")
    print("  (CEIL)  nmin p = ceil(p/ln 2 - 5/2)  is FALSE; here nmin p = ceil(...) + 1.")
    print("  The correct uniform statement is the disjunction")
    print("    nmin p in { ceil(p/ln 2 - 5/2), ceil(p/ln 2 - 5/2) + 1 }.")
    print("  Any two-sided window with fixed slack K/n^2 cannot prove (CEIL): the bad p are")
    print("  exactly those with 1 - frac(p/ln 2 - 3/2) < K/(n ln 2).")


if __name__ == "__main__":
    main()
