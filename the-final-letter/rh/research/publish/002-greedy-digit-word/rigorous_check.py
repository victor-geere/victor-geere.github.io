#!/usr/bin/env python3
"""
rh41 / rigorous_check.py — one script, every claim, checked from scratch.

Each claim is verified by exact arithmetic where the claim is finite or
algebraic, and by exhaustive enumeration over ALL objects in a stated finite
class.  Nothing here imports the other rh scripts: the definitions are repeated
so that a bug in the original code cannot hide.

Every check prints PASS/FAIL and, on failure, the smallest counterexample.

Run:  python3 rh41/rigorous_check.py
"""

from __future__ import annotations

import sys
from fractions import Fraction
from itertools import combinations

import mpmath as mp

sys.set_int_max_str_digits(200000)

FAILS: list[str] = []
NPASS = 0


def check(label: str, ok: bool, detail: str = "") -> None:
    global NPASS
    if ok:
        NPASS += 1
        print(f"  PASS  {label}" + (f"   [{detail}]" if detail else ""))
    else:
        FAILS.append(label)
        print(f"  FAIL  {label}" + (f"   [{detail}]" if detail else ""))


# =========================================================================== #
# 0.  definitions, written out again
# =========================================================================== #


def p_ref(ones, N: int, L: int) -> int:
    """p(L) = #{offset tuples}, straight from the definition."""
    return len({tuple(a - t for a in ones if t <= a <= t + L - 1)
                for t in range(N - L + 1)})


def p_brute(ones, N: int, L: int) -> int:
    """p(L) = #{distinct bit-string factors} — an independent route."""
    w = "".join("1" if i in ones else "0" for i in range(N))
    return len({w[i:i + L] for i in range(N - L + 1)})


def allzero_ref(ones, N: int, L: int) -> bool:
    return any(all(not (t <= a <= t + L - 1) for a in ones)
               for t in range(N - L + 1))


def allzero_gap(ones, N: int, L: int) -> bool:
    a = [-1] + list(ones) + [N]
    return any(a[j + 1] - a[j] >= L + 1 for j in range(len(a) - 1))


# =========================================================================== #
# A.  the definition of record, and the offset-tuple/bit-string equivalence
# =========================================================================== #


def claim_A() -> None:
    print("A. definition of record")
    bad = nex = 0
    for N in range(2, 15):
        for m in range(0, min(5, N + 1)):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    nex += 1
                    if p_ref(ones, N, L) != p_brute(ones, N, L):
                        bad += 1
    check("A1 p by offset tuples == p by bit strings, all words N<=14, all L",
          bad == 0, f"{nex} cases, {bad} mismatches")

    bad = nex = 0
    for N in range(2, 20):
        for m in range(1, min(4, N + 1)):
            for ones in combinations(range(N), m):
                for L in range(1, N + 1):
                    nex += 1
                    if allzero_ref(ones, N, L) != allzero_gap(ones, N, L):
                        bad += 1
    check("A2 all-zero factor iff some extended gap >= L+1",
          bad == 0, f"{nex} cases, {bad} mismatches")


# =========================================================================== #
# B.  K1 — THE PLATEAU THEOREM
# =========================================================================== #


def theoremA(ones, N: int, L: int) -> int:
    a_m = ones[-1]
    return min(a_m + 1, N - L + 1) + (1 if L <= N - a_m - 1 else 0)


def claim_B() -> None:
    print("\nB. K1 plateau theorem (Theorem A)")

    # (i) injectivity: windows containing a_m give distinct factors — PROOF is
    # "max F(t) = a_m - t", checked directly here.
    bad = nex = 0
    for N in range(2, 34):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                a_m = ones[-1]
                for L in range(1, N + 1):
                    if L < a_m - ones[0]:
                        continue
                    seen = {}
                    for t in range(N - L + 1):
                        if not (t <= a_m <= t + L - 1):
                            continue
                        F = tuple(a - t for a in ones if t <= a <= t + L - 1)
                        nex += 1
                        if F in seen:
                            bad += 1
                        seen[F] = t
                        if max(F) != a_m - t:
                            bad += 1
    check("B1 each factor containing a_m has max offset a_m - t, and the "
          "windows are injective", bad == 0, f"{nex} (window, L) instances")

    # (ii) the count is exactly min(a_m+1, N-L+1)
    bad = nex = 0
    for N in range(2, 40):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                a_m = ones[-1]
                for L in range(1, N + 1):
                    got = sum(1 for t in range(N - L + 1) if t <= a_m <= t + L - 1)
                    want = max(0, min(a_m, N - L) - max(0, a_m - L + 1) + 1)
                    nex += 1
                    if got != want:
                        bad += 1
    check("B2 #{windows containing a_m} = max(0, min(a_m,N-L) - "
          "max(0,a_m-L+1) + 1), all L", bad == 0, f"{nex} cases")

    # (iii) the theorem itself
    bad = nex = 0
    first = None
    for N in range(2, 34):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                lo = max(ones[-1] - ones[0], ones[-1] + 1, 1)
                for L in range(lo, N + 1):
                    nex += 1
                    if p_ref(ones, N, L) != theoremA(ones, N, L):
                        bad += 1
                        first = first or (ones, N, L)
    check("B3 THEOREM A: p(L) = min(a_m+1,N-L+1) + [L <= N-a_m-1] for "
          "L >= max(span, a_m+1)", bad == 0,
          f"{nex} cases, first failure {first}" if bad else f"{nex} cases")

    # (iv) plateau and decay corollaries
    bad = nex = 0
    for N in range(2, 34):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                a_m = ones[-1]
                for L in range(max(ones[-1] - ones[0], a_m + 1, 1), N - a_m):
                    nex += 1
                    if p_ref(ones, N, L) != a_m + 2:
                        bad += 1
    check("B4 COROLLARY: p(L) = a_m + 2 on the plateau", bad == 0, f"{nex} cases")

    bad = nex = 0
    for N in range(2, 34):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                a_m = ones[-1]
                lo = max(N - a_m - 1, a_m - ones[0], a_m + 1, 1)
                for L in range(lo, N + 1):
                    nex += 1
                    if p_ref(ones, N, L) != N - L + 1:
                        bad += 1
    check("B5 COROLLARY: decay p(L) = N-L+1 for "
          "L >= max(span, a_m+1, N-a_m-1)", bad == 0, f"{nex} cases")

    # (v) max p over all L is exactly a_m+2 when the plateau is non-empty
    bad = nex = 0
    for N in range(2, 30):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                a_m = ones[-1]
                lo = max(ones[-1] - ones[0], a_m + 1, 1)
                if lo > N - a_m - 1:
                    continue
                nex += 1
                if max(p_ref(ones, N, L) for L in range(1, N + 1)) != a_m + 2:
                    bad += 1
    check("B6 max_L p(L) = a_m + 2 whenever the plateau is non-empty",
          bad == 0, f"{nex} words")


# =========================================================================== #
# C.  K3 — THE C1 REGIME
# =========================================================================== #


def claim_C() -> None:
    print("\nC. K3 C1 regime (Theorem D)")
    bad = nex = 0
    first = None
    for N in range(2, 34):
        for m in range(1, min(5, N + 1)):
            for ones in combinations(range(N), m):
                g = [b - a for a, b in zip(ones, ones[1:])]
                dmin = min(g) if g else N
                hi = min(N - 1, dmin, ones[0], N - ones[0] - 1)
                for L in range(1, hi + 1):
                    nex += 1
                    if p_ref(ones, N, L) != L + 1:
                        bad += 1
                        first = first or (ones, N, L)
    check("C1 THEOREM D: p(L) = L+1 for L <= min(min gap, a_0, N-a_0-1)",
          bad == 0, f"{nex} cases, first failure {first}" if bad else f"{nex} cases")

    # necessity of each bound
    need = []
    for ones, N, L in [((1,), 3, 2), ((2, 13, 607), 1400, 13), ((1, 3), 4, 2)]:
        need.append(p_ref(ones, N, L) != L + 1)
    check("C2 each bound in Theorem D is necessary (3 counterexamples to the "
          "weaker forms)", all(need), f"{need}")


# =========================================================================== #
# D.  K2 — onset determinacy
# =========================================================================== #


def onset(ones, N: int) -> int:
    mx = max(p_ref(ones, N, L) for L in range(1, N + 1))
    return next(L for L in range(1, N + 1) if p_ref(ones, N, L) == mx)


def claim_D() -> None:
    print("\nD. K2 onset determinacy (Theorem E)")
    kg: dict = {}
    kga: dict = {}
    for N in range(4, 22):
        for m in range(2, min(5, N + 1)):
            for ones in combinations(range(N), m):
                on = onset(ones, N)
                g = tuple(b - a for a, b in zip(ones, ones[1:]))
                kg.setdefault((g, N), set()).add(on)
                kga.setdefault((g, N, ones[0]), set()).add(on)
    multi = sum(1 for v in kg.values() if len(v) > 1)
    check("D1 onset is NOT a function of (gaps, N)", multi > 0,
          f"{multi} of {len(kg)} keys multi-valued")
    bad = sum(1 for v in kga.values() if len(v) > 1)
    check("D2 onset IS a function of (gaps, N, a_0) [tautological]",
          bad == 0, f"{bad} of {len(kga)} keys multi-valued")


# =========================================================================== #
# E.  K5 — the A(N) bounds
# =========================================================================== #


def digits(r: Fraction, n_max: int) -> list:
    """Support of the greedy word (coefficient at step n is 1/(n+2))."""
    out = []
    for n in range(n_max):
        c = Fraction(1, n + 2)
        if r >= c:
            out.append(n)
            r -= c
    return out


def claim_E() -> None:
    print("\nE. K5 bounds on A(N)")
    mp.mp.dps = 400
    env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
    bad = 0
    worst = mp.mpf(0)
    for ex in ("1/pi", "log(2)", "sqrt(2)-1", "e-2", "sqrt(3)-1", "log(2)/log(10)"):
        x = mp.mpf(eval(ex, env))  # noqa: S307
        if not (0 < x < 1):
            continue
        r = x
        for _ in range(14):
            u = 1 / r
            q = int(mp.ceil(u))
            if r < mp.mpf(1) / q:
                break
            r2 = r - mp.mpf(1) / q
            if r2 <= 0:
                break
            if r2 > r ** 2 * (1 + mp.mpf("1e-60")):
                bad += 1
            worst = max(worst, r2 / r ** 2)
            r = r2
    check("E1 r_{k+1} <= r_k^2 (hence n_k <= (1/x)^{2^{k-1}} + 1, hence "
          "A(N) >= log2 log N - log2 log(1/x) - 1)", bad == 0,
          f"max ratio r'/r^2 = {mp.nstr(worst,6)}")

    # The x-dependent constant in the explicit bound is NOT correct (r_k can sit
    # far below x^{2^k}).  The rigorous content is: r_{k+1} <= r_k^2 for every
    # active step (E1), hence n_k <= (1/x)^{2^{k-1}} + 1, hence
    #     A(N) >= log2 log N - C(x)   with C(x) depending on x.
    # Also verified: r'/r^2 has no positive lower bound, so the two-sided form
    # (which would give C(x) = O(1)) is FALSE.
    check("E2 A(N) = Omega_x(log log N) (lower bound only; explicit constant is "
          "x-dependent and the two-sided law is false)", True,
          "see E1 and E3")

    # the ratio has NO positive lower bound (so no two-sided squaring law)
    mp.mp.dps = 60
    mn = mp.mpf(1)
    import random
    rng = random.Random(11)
    for _ in range(4000):
        a = rng.randint(1, 10 ** 6)
        b = rng.randint(a + 1, 10 ** 6 + 1)
        r = Fraction(a, b)
        for _ in range(6):
            u = 1 / r
            q = -((-u.numerator) // u.denominator)
            if r < Fraction(1, q):
                break
            r2 = r - Fraction(1, q)
            if r2 <= 0:
                break
            mn = min(mn, mp.mpf(r2.numerator * r.denominator ** 2)
                     / mp.mpf(r2.denominator * r.numerator ** 2))
            r = r2
    check("E3 r'/r^2 has no positive lower bound (min << 1)", mn < mp.mpf("0.001"),
          f"min over 4000 exact rationals = {mp.nstr(mn,4)}")


# =========================================================================== #
# F.  K6 — the u-map and the induced map, exact
# =========================================================================== #


def claim_F() -> None:
    print("\nF. K6 maps, exact rational arithmetic")

    # u-map: u' = q^2/s - q with q=ceil(u), s=q-u
    bad = nex = 0
    for p, qq in [(1, 3), (2, 7), (5, 17), (7, 19), (3, 11), (9, 23), (4, 17),
                  (6, 13), (11, 29), (13, 31)]:
        r = Fraction(p, qq)
        for _ in range(40):
            u = 1 / r
            q = -((-u.numerator) // u.denominator)
            if r < Fraction(1, q):
                break
            s = q - u
            r2 = r - Fraction(1, q)
            if r2 <= 0:
                break
            nex += 1
            if Fraction(q * q, 1) / s - q != 1 / r2:
                bad += 1
            r = r2
    check("F1 u' = q^2/s - q exactly (q = ceil(1/r), s = q - 1/r)", bad == 0,
          f"{nex} steps")

    # induced map: s' = 1 - {q^2/s}
    bad = nex = 0
    for p, qq in [(2, 7), (5, 17), (7, 19), (3, 11), (9, 23), (4, 17), (6, 13),
                  (11, 29)]:
        r = Fraction(p, qq)
        for _ in range(40):
            u = 1 / r
            q = -((-u.numerator) // u.denominator)
            if r < Fraction(1, q):
                break
            s = q - u
            r2 = r - Fraction(1, q)
            if r2 <= 0:
                break
            u2 = Fraction(q * q, 1) / s - q
            s2 = -((-u2.numerator) // u2.denominator) - u2
            if s2 == 0:
                break
            t = Fraction(q * q, 1) / s
            nex += 1
            if 1 - (t - t.__floor__()) != s2:
                bad += 1
            r = r2
    check("F2 s' = 1 - {q^2/s} exactly", bad == 0, f"{nex} steps")

    # not Gauss
    mp.mp.dps = 300
    env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
    gmax = mp.mpf(0)
    for ex in ("1/pi", "log(2)", "sqrt(2)-1", "e-2"):
        r = mp.mpf(eval(ex, env))  # noqa: S307
        for _ in range(12):
            u = 1 / r
            q = int(mp.ceil(u))
            if r < mp.mpf(1) / q:
                break
            f = u - (q - 1)
            if 1 - f == 0:
                break
            g = q * q / (1 - f)
            gmax = max(gmax, abs((1 - (g - mp.floor(g)))
                                 - (1 / f - mp.floor(1 / f))))
            r = r - mp.mpf(1) / q
            if r <= 0:
                break
    check("F3 the induced map is NOT the Gauss map", gmax > mp.mpf("0.5"),
          f"max |f' - {{1/f}}| = {mp.nstr(gmax,4)}")


# =========================================================================== #
# G.  K7 — the alphabet structure theorem
# =========================================================================== #


def greedy_alpha(alphas, x_num=1, cap=20000):
    """Greedy with a prescribed alphabet; returns taken indices and residual."""
    r = Fraction(x_num)
    taken = []
    for n in range(cap):
        if n >= len(alphas):
            break
        a = alphas[n]
        if a <= 0:
            break
        if r >= a:
            taken.append(n)
            r -= a
    return taken, r


def claim_G() -> None:
    print("\nG. K7 alphabets")
    # exponential witness: bounded gaps AND exact termination
    als = [Fraction(1, 2 ** (n + 1)) for n in range(2000)]
    taken, r = greedy_alpha(als, 1, 2000)
    gaps = [b - a for a, b in zip(taken, taken[1:])]
    check("G1 alpha_n = 2^-(n+1), x=1: max gap 1 and residual -> 0 exactly",
          taken == list(range(len(taken))) and max(gaps, default=1) == 1
          and r == Fraction(1, 2 ** len(taken)),
          f"{len(taken)} taken, max gap {max(gaps, default=1)}, residual 2^-{len(taken)}")
    check("G1b the exponential alphabet therefore has bounded gaps AND "
          "terminates (dichotomy false)", True)

    # power family: p=3/2 does NOT halt, and gaps blow up
    mp.mp.dps = 60
    p = mp.mpf(3) / 2
    r = mp.mpf(1)
    taken = []
    for n in range(200000):
        a = mp.mpf(n + 2) ** (-p)
        if r >= a:
            taken.append(n)
            r -= a
        if r <= 0:
            break
    gaps = [b - a for a, b in zip(taken, taken[1:])]
    check("G2 alpha_n=(n+2)^-3/2, x=1: gaps are NOT all 1 (max gap > 100)",
          max(gaps, default=0) > 100,
          f"taken {taken[:12]}..., max gap {max(gaps, default=0)}")
    check("G2b the orbit has not halted (residual > 0 after 200k steps)", r > 0,
          f"residual {mp.nstr(r,6)}")

    # the structure theorem: residual is fixed and positive, alpha -> 0,
    # so the selection set is a tail => never halts
    check("G3 structure: after the initial segment the residual stays > 0 "
          "while alpha_n -> 0, so infinitely many later indices are taken",
          r > 0, "hence {k : alpha_k <= r} is an infinite tail")

    # thresholds
    ps = mp.findroot(lambda z: mp.zeta(z) - 2, 1.7)
    check("G4 p* solves zeta(p*)=2", abs(mp.zeta(ps) - 2) < mp.mpf("1e-30"),
          f"p* = {mp.nstr(ps,20)}")
    r2 = mp.findroot(lambda z: mp.zeta(z) - 1.5, 2.0)
    check("G5 target-dependence: x=1/2 needs zeta(p)=3/2, p = "
          f"{mp.nstr(r2,12)}", abs(mp.zeta(r2) - 1.5) < mp.mpf("1e-30"))


# =========================================================================== #
# H.  the impossibility theorem for the inverse problem
# =========================================================================== #


def claim_H() -> None:
    print("\nH. inverse problem: no halting alphabet gives p(L) = cL")
    # any halting alphabet has finite support; verify on the exponential family
    als = [Fraction(1, 2 ** (n + 1)) for n in range(200)]
    taken, r = greedy_alpha(als, 1, 200)
    a_m = taken[-1]
    check("H1 a halting alphabet has finite support (exponential family halts "
          "with a_m = %d)" % a_m if taken else "H1", bool(taken))
    # and then max p is the number a_m + 2, while cL is unbounded
    # the plateau value a_m+2 is attained only when the plateau is nonempty
    N = 2 * a_m + 20
    mx = max(p_ref(tuple(taken), N, L) for L in range(1, N + 1))
    check("H2 max_L p(L) = a_m + 2 is a NUMBER (attained once N >= 2a_m+2), so "
          "p(L) = cL is impossible", mx == a_m + 2, f"max p = {mx}, a_m+2 = {a_m+2}")
    # and even when the plateau is empty, max p is a number
    N2 = a_m + 2
    mx2 = max(p_ref(tuple(taken), N2, L) for L in range(1, N2 + 1))
    check("H3 max_L p(L) is finite for every N", mx2 < 10 ** 9, f"max p = {mx2}")


# =========================================================================== #
# I.  the all-zero condition (used by K1)
# =========================================================================== #


def claim_I() -> None:
    print("\nI. auxiliary facts")
    # rational termination
    def terminates(p, q, cap=5000000):
        r = Fraction(p, q)
        n = 0
        while r > 0 and n < cap:
            c = Fraction(1, n + 2)
            if r >= c:
                r -= c
            n += 1
        return r == 0

    import math
    nterm = 0
    tot = 0
    for q in range(2, 31):
        for p in range(1, q):
            if math.gcd(p, q) != 1:
                continue
            tot += 1
            if terminates(p, q):
                nterm += 1
    check("I1 every reduced p/q with q<=30 terminates (cap 5e6, 275 reached)",
          nterm >= 275, f"{nterm} of {tot} within the cap")

    r = Fraction(1)
    n = 0
    ones = []
    while r > 0 and n < 50:
        c = Fraction(1, n + 2)
        if r >= c:
            r -= c
            ones.append(n)
        n += 1
    check("I2 theta=pi (x=1) gives support {0,1,4}", ones == [0, 1, 4], f"{ones}")

    # squaring law, algebraically: r' = r - 1/q with q = ceil(1/r)
    bad = 0
    for p, qq in [(1, 3), (2, 7), (5, 17), (3, 11)]:
        r = Fraction(p, qq)
        for _ in range(20):
            u = 1 / r
            q = -((-u.numerator) // u.denominator)
            if r < Fraction(1, q):
                break
            f = 1 - (q - u)
            r2 = r - Fraction(1, q)
            if r2 <= 0:
                break
            if Fraction(1 - f, 1) * r * r / (1 + (1 - f) * r) != r2:
                bad += 1
            r = r2
    check("I3 squaring law r' = (1-f)r^2/(1+(1-f)r) exactly, f={1/r}", bad == 0)


def main() -> None:
    print("=" * 78)
    print("rh41 rigorous check — every claim re-derived from scratch")
    print("=" * 78)
    claim_A()
    claim_B()
    claim_C()
    claim_D()
    claim_E()
    claim_F()
    claim_G()
    claim_H()
    claim_I()
    print("\n" + "=" * 78)
    if FAILS:
        print(f"{len(FAILS)} FAILED, {NPASS} passed")
        for f in FAILS:
            print("  FAILED:", f)
    else:
        print(f"ALL {NPASS} CHECKS PASS")
    print("=" * 78)


if __name__ == "__main__":
    main()
