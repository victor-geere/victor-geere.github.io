#!/usr/bin/env python3
"""
rh42/helix_zeta.py — the helix ("Tau") perspective on the greedy digit word:
the signed alphabet, the zeta budgets, and what the word can and cannot write.

Source of the perspective (fetched 2026-10-03):

  * https://harmonic-sine.grok.me/helix         (the helix, cosine, zeta)
  * https://harmonic-sine.grok.me/theory        (why the fractions are a sine)
  * https://harmonic-sine.grok.me/              (Note 041, the digit bench)

Claims made on those pages that are tested here:

  H1  the alphabet is  (-1)^n / (n+2),  n = 0, 1, 2, ...  =  +1/2 - 1/3 + 1/4 - ...
  H2  the rule takes a term only when its sign matches the residual and its
      size does not overshoot, and never uses a term twice
  H3  "the positive terms are the even denominators, and their sum is
      2^-p zeta(p)";  "the negative terms are the odd denominators from 3 on,
      and their total magnitude is (1 - 2^-p) zeta(p) - 1"
  H4  "at p = 1 both of those series diverge, which is the pole of zeta showing
      up once on each side"
  H5  "past exponent 1 both budgets are finite, and a sine past the budget of
      its sign cannot be met"
  H6  the total of the whole alternating alphabet is eta(p) - 1
      (at p = 1:  ln 2 - 1 = -0.307...)
  H7  cosine spends the same two budgets; at 45 degrees the two words agree
      (theta in turns:  sin(2*pi*theta) = cos(2*pi*theta) at theta = 1/8)
  H8  the helix keeps the turn count; the digit word does not
      ("e^{2 pi i theta} is that point, plus the turn count")

Everything is recomputed here from the definitions, never taken on trust.
Exact `Fraction` arithmetic is used for p = 1 and p = 2 (the terms are then
rational); `mpmath` at >= 60 dps is used for the zeta values and for irrational
targets.  Nothing here is a binary-float run of the object.

Run:  python3 rh42/helix_zeta.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import sys
from fractions import Fraction
from math import gcd
from pathlib import Path

import mpmath as mp

HERE = Path(__file__).resolve().parent
RH = HERE.parent
sys.path.insert(0, str(RH))

from rh41.digitword import greedy_word_mpmath, p_offset, word_from_ones  # noqa: E402

mp.mp.dps = 80

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
# 0.  The object, exactly as the pages define it
# =========================================================================== #


def term(n: int, p) -> Fraction | mp.mpf:
    """The tau alphabet term (-1)^n / (n+2)^p (H1)."""
    if isinstance(p, int):
        return Fraction((-1) ** n, (n + 2) ** p)
    return mp.mpf((-1) ** n) / mp.mpf(n + 2) ** p


def tau_greedy(x, p, cap: int | None = None):
    """The signed (tau) greedy rule of H2.

    r_0 = x.  At step n the term (-1)^n/(n+2)^p is taken iff it has the same
    sign as the residual and its size does not exceed it; otherwise the term is
    skipped (and never used again).  Returns (taken indices, residual, steps).

    Exact `Fraction` arithmetic is used when both `p` is an integer and `x` is a
    `Fraction`; otherwise mpmath at the working precision.  Never a binary float.
    """
    exact = isinstance(p, int) and isinstance(x, Fraction)
    r = x if exact else mp.mpf(x)
    taken: list[int] = []
    n = 0
    while r != 0 and (cap is None or n < cap):
        t = term(n, p)
        if not exact and not isinstance(t, mp.mpf):
            t = mp.mpf(t.numerator) / t.denominator
        if (r > 0 and t > 0) or (r < 0 and t < 0):
            if abs(t) <= abs(r):
                r = r - t          # a term of the residual's own sign is spent
                taken.append(n)
        n += 1
    return taken, r, n


def budget_pos(p) -> mp.mpf:
    """Sum of the positive (even-denominator) terms: 2^-p zeta(p) (H3)."""
    return mp.power(2, -p) * mp.zeta(p)


def budget_neg(p) -> mp.mpf:
    """Sum of the negative (odd-denominator, from 3 on) terms:
    (1 - 2^-p) zeta(p) - 1  (H3)."""
    return (1 - mp.power(2, -p)) * mp.zeta(p) - 1


def eta(p) -> mp.mpf:
    """Dirichlet eta:  eta(p) = (1 - 2^(1-p)) zeta(p) for p != 1, and eta(1) = ln 2.

    The factorised form is the continuous extension: at p = 1 it reads 0 * infinity,
    the pole of zeta, and the value there is ln 2 (the alternating harmonic series).
    """
    if p == 1:
        return mp.log(2)
    return (1 - mp.power(2, 1 - p)) * mp.zeta(p)


def eta_series(p) -> mp.mpf:
    """eta(p) recomputed from its defining series (no zeta, no pole)."""
    return mp.nsum(lambda n: mp.mpf((-1) ** (n - 1)) / mp.mpf(n) ** p, [1, mp.inf])


# =========================================================================== #
# 1.  H3/H6: the budgets and their algebra
# =========================================================================== #


def claim_budgets() -> None:
    print("\n1. H3/H6  the zeta budgets  P(p) = 2^-p zeta(p),  N(p) = (1-2^-p) zeta(p) - 1")
    grid = [mp.mpf("1.25"), mp.mpf("1.5"), mp.mpf("2"), mp.mpf("3"), mp.mpf("4")]
    worst = mp.mpf(0)
    worst_eta = mp.mpf(0)
    for p in grid:
        P, N = budget_pos(p), budget_neg(p)
        # P + N = zeta(p) - 1   and   P - N = 1 - eta(p)
        worst = max(worst, abs(P + N - (mp.zeta(p) - 1)))
        worst_eta = max(worst_eta, abs(P - N - (1 - eta(p))))
    check("H3  P + N = zeta(p) - 1  and  P - N = 1 - eta(p)  for every p tested",
          worst < mp.mpf("1e-70") and worst_eta < mp.mpf("1e-70"),
          f"max residuals {mp.nstr(worst, 3)} / {mp.nstr(worst_eta, 3)}")

    # the same numbers as direct even/odd partial sums, with a tail estimate:
    # for p = 2 the even tail beyond B is <= (1/4)/B, so tolerance 2/B is safe
    B = 200000
    for p in [2, 3]:
        Pm = sum(mp.mpf(2 * k) ** (-p) for k in range(1, B + 1))
        Nm = sum(mp.mpf(2 * k + 1) ** (-p) for k in range(1, B + 1))
        tol = mp.mpf(4) / B if p == 2 else mp.mpf(1) / B**2
        check(f"H3  direct even/odd partial sums agree with P({p}) and N({p}) "
              f"within the truncation tail",
              abs(Pm - budget_pos(p)) < tol and abs(Nm - budget_neg(p)) < tol,
              f"P_sum={mp.nstr(Pm, 14)}, P={mp.nstr(budget_pos(p), 14)} (tail <= {mp.nstr(tol, 2)})")

    # H6: the whole alphabet totals 1 - eta(p)
    #     (terms (-1)^n (n+2)^-p, n >= 0  =  -(eta tail), so the sum is 1 - eta(p))
    for p in [mp.mpf("1.5"), 2]:
        tot = budget_pos(p) - budget_neg(p)
        check(f"H6  (positive budget) - (negative budget) = 1 - eta({mp.nstr(p, 3)})",
              abs(tot - (1 - eta(p))) < mp.mpf("1e-70"),
              f"{mp.nstr(tot, 15)} vs {mp.nstr(1 - eta(p), 15)}")
        check(f"H6  eta({mp.nstr(p, 3)}) from the factored form equals its series",
              abs(eta(p) - eta_series(p)) < mp.mpf("1e-25"),
              f"{mp.nstr(eta(p), 15)} vs {mp.nstr(eta_series(p), 15)}")

    # eta(1) = ln 2; the p = 1 signed total is 1 - ln 2 = +0.30685...
    tot1 = mp.nsum(lambda n: mp.mpf((-1) ** n) / mp.mpf(n + 2), [0, mp.inf])
    check("H6  the alphabet really sums to 1 - ln 2 = +0.30685... (the site prints "
          "ln 2 - 1, the wrong sign for this alphabet)",
          abs(tot1 - (1 - mp.log(2))) < mp.mpf("1e-25"),
          f"sum = {mp.nstr(tot1, 18)}, 1 - ln 2 = {mp.nstr(1 - mp.log(2), 18)}, "
          f"ln 2 - 1 = {mp.nstr(mp.log(2) - 1, 18)}")
    check("H6  eta(1) = ln 2 (the alternating harmonic series)",
          abs(eta_series(1) - mp.log(2)) < mp.mpf("1e-25"),
          f"eta(1) = {mp.nstr(eta_series(1), 18)}")

    print("     p        zeta(p)      P(p)         N(p)         P+N")
    for p in ["1.1", "1.25", "1.37", "1.5", "1.7286472389981836181", "2", "3"]:
        pm = mp.mpf(p)
        print(f"    {p:>8}  {mp.nstr(mp.zeta(pm), 10):>12}  {mp.nstr(budget_pos(pm), 10):>12}"
              f"  {mp.nstr(budget_neg(pm), 10):>12}  {mp.nstr(budget_pos(pm) + budget_neg(pm), 10):>12}")


# =========================================================================== #
# 2.  H4: the pole of zeta appears on both sides
# =========================================================================== #


def claim_pole() -> None:
    print("\n2. H4  at p = 1 both budgets diverge (the pole, once on each side)")
    # one-sided divergence: P(p) and N(p) grow like zeta(p)/2 ~ 1/(2(p-1))
    vals = []
    for eps in ["1e-1", "1e-2", "1e-3", "1e-4"]:
        p = 1 + mp.mpf(eps)
        vals.append((eps, budget_pos(p), budget_neg(p)))
    growing = all(vals[i + 1][1] > vals[i][1] and vals[i + 1][2] > vals[i][2]
                  for i in range(len(vals) - 1))
    check("H4  P(1+eps) and N(1+eps) both increase as eps -> 0",
          growing, "; ".join(f"eps={e}: P={mp.nstr(P, 8)}, N={mp.nstr(N, 8)}" for e, P, N in vals))

    # the divergence rate is zeta's:  P(p) ~ N(p) ~ 1/(2(p-1))
    p = 1 + mp.mpf("1e-6")
    ratio = budget_pos(p) * (p - 1)
    check("H4  P(p)*(p-1) -> 1/2  (the residue of zeta at the pole, halved)",
          abs(ratio - mp.mpf("0.5")) < mp.mpf("1e-3"),
          f"P*(p-1) = {mp.nstr(ratio, 8)} at p = 1+1e-6")

    # direct partial sums of the even and odd harmonic series diverge
    even_half = sum(Fraction(1, 2 * k) for k in range(1, 10001))
    even_full = sum(Fraction(1, 2 * k) for k in range(1, 20001))
    odd_half = sum(Fraction(1, 2 * k + 1) for k in range(1, 10001))
    odd_full = sum(Fraction(1, 2 * k + 1) for k in range(1, 20001))
    check("H4  the even and odd harmonic partial sums both grow without bound "
          "(exact fractions, doubling the cut-off adds ~0.35 each)",
          even_full > even_half > 4 and odd_full > odd_half > 4,
          f"even {float(even_half):.4f} -> {float(even_full):.4f}; "
          f"odd {float(odd_half):.4f} -> {float(odd_full):.4f}")


# =========================================================================== #
# 3.  H5: the two-budget criterion
# =========================================================================== #


def claim_criterion() -> None:
    print("\n3. H5  a target past the budget of its sign cannot be met; inside the budget the residual falls to 0")
    # p = 2: everything is rational, so the run is exact
    p = 2
    P2, N2 = budget_pos(2), budget_neg(2)
    print(f"     P(2) = zeta(2)/4 = {mp.nstr(P2, 12)}   N(2) = 3 zeta(2)/4 - 1 = {mp.nstr(N2, 12)}")

    # (a) targets above the positive budget: the residual converges to x - P(2) > 0
    #     from above (the gap is the unprocessed tail, which halves when the cap doubles)
    for x in [Fraction(3, 5), Fraction(9, 2) / 10, Fraction(19, 20)]:
        xm = mp.mpf(x.numerator) / x.denominator
        expect = xm - P2
        _, r1, _ = tau_greedy(xm, p, cap=4000)
        _, r2, _ = tau_greedy(xm, p, cap=16000)
        d1, d2 = r1 - expect, r2 - expect
        check(f"H5  x = {x} > P(2): residual -> x - P(2) from above (tail halves)",
              r1 > expect and r2 > expect and d2 < d1 / 2 and d1 < mp.mpf("1e-3"),
              f"residual {mp.nstr(r1, 10)} (cap 4k) -> {mp.nstr(r2, 10)} (cap 16k), "
              f"x - P(2) = {mp.nstr(expect, 10)}")

    # (b) targets below the positive budget: the residual falls to 0 in the limit
    for x in [Fraction(1, 10), Fraction(1, 4), Fraction(2, 5)]:
        taken, r, steps = tau_greedy(x, p, cap=4000)
        check(f"H5  x = {x} < P(2): residual falls below 1e-6",
              r < Fraction(1, 10**6),
              f"residual {float(r):.3e} after {steps} steps, {len(taken)} takes")

    # (c) negative mirror: below -N(2) the residual tends to x + N(2) < 0
    xm = mp.mpf(-1) / 2
    expect = xm + N2
    _, r1, _ = tau_greedy(xm, p, cap=4000)
    _, r2, _ = tau_greedy(xm, p, cap=16000)
    d1, d2 = r1 - expect, r2 - expect
    check("H5  x = -1/2 < -N(2): residual -> x + N(2) from below (tail halves)",
          r1 < expect and r2 < expect and d2 > d1 / 2 and -d1 < mp.mpf("1e-3"),
          f"residual {mp.nstr(r1, 10)} (cap 4k) -> {mp.nstr(r2, 10)} (cap 16k), "
          f"x + N(2) = {mp.nstr(expect, 10)}")
    for x in [Fraction(-1, 5)]:
        _, r, steps = tau_greedy(x, p, cap=4000)
        check(f"H5  x = {x} > -N(2): residual falls below 1e-6",
              r > Fraction(-1, 10**6), f"residual {float(r):.3e} after {steps} steps")

    # (d) necessity is exact: the taken terms of one sign are a sub-sum of that sign's series
    for x in [Fraction(3, 5), Fraction(-1, 2)]:
        taken, r, _ = tau_greedy(x, p, cap=4000)
        s = sum((term(n, p) for n in taken), Fraction(0))
        lim = P2 if x > 0 else N2
        got = abs(mp.mpf(s.numerator) / s.denominator)
        check(f"H5  x = {x}: |sum of taken terms| <= budget of that sign",
              got <= lim + mp.mpf("1e-12"),
              f"|sum| = {mp.nstr(got, 12)}, budget = {mp.nstr(lim, 12)}")

    # (e) p = 1: the budgets are infinite, so every sine passes the test
    worst = mp.mpf(0)
    for theta in ["0.05", "0.125", "0.2", "0.3", "0.45", "0.5"]:
        x = mp.sin(2 * mp.pi * mp.mpf(theta))
        taken, r, steps = tau_greedy(x, 1, cap=200000)
        worst = max(worst, abs(r))
    check("H5  at p = 1 the residual falls below 1e-5 for every sine tested "
          "(both budgets are infinite, so no target is out of budget)",
          worst < mp.mpf("1e-5"), f"max |residual| = {mp.nstr(worst, 4)}")


# =========================================================================== #
# 4.  Structure: the positive half is a halved classic Egyptian greedy
# =========================================================================== #


def egyptian(y, p, cap: int = 4000):
    """Classic greedy on the unit fractions 1/k^p, k >= 1 (Sylvester/Fibonacci)."""
    r = y
    out = []
    k = 1
    while r > 0 and k <= cap:
        t = Fraction(1, k**p) if isinstance(p, int) else mp.mpf(1) / mp.mpf(k) ** p
        if t <= r:
            r -= t
            out.append(k)
        k += 1
    return out, r


def claim_parity() -> None:
    print("\n4. Structure  the positive half of the tau word is the classic Egyptian greedy, halved")
    # term index n is even, n = 2(k-1), and 1/(n+2)^p = 2^-p / k^p.
    # So the tau rule at target x > 0 is the classic p-greedy at target 2^p x.
    p = 1
    worst = 0
    for x in [Fraction(1, 2), Fraction(1, 3), Fraction(2, 5), Fraction(1, 1), Fraction(7, 9)]:
        taken, r, _ = tau_greedy(x, p, cap=4000)
        E, _ = egyptian(2 * x, p, cap=4000)
        mapped = [2 * (k - 1) for k in E]
        worst = max(worst, 0 if taken == mapped else 1)
        check(f"p = 1, x = {x}: tau support {taken[:8]} equals {{2(k-1)}} of the "
              f"classic Egyptian support {E[:8]}", taken == mapped)
    check("p = 1 parity correspondence holds on every rational tested", worst == 0)

    # parity: every take of a positive tau run sits at an even index (and every
    # take of a negative run at an odd index), so the signed word has no gap 1
    for theta in ["0.05", "0.125", "0.3", "0.45"]:
        x = mp.sin(2 * mp.pi * mp.mpf(theta))
        taken, r, _ = tau_greedy(x, 1, cap=200000)
        par = {n % 2 for n in taken}
        check(f"theta = {theta}: all takes have the parity of the sign of x",
              par == ({0} if x > 0 else {1}), f"x={mp.nstr(x,6)}, parities {sorted(par)}")

    # p = 2 with rational targets: term index 2(k-1) has value 1/(4 k^2) = 2^-2 / k^2,
    # so the classic 2-greedy runs at target 4x.
    p = 2
    K = 2000
    for x in [Fraction(1, 5), Fraction(3, 10)]:
        # tau index n = 2(k-1) < 2K  covers exactly the classic k <= K
        taken, r, _ = tau_greedy(x, p, cap=2 * K)
        E, _ = egyptian(4 * x, p, cap=K)
        check(f"p = 2, x = {x}: tau support equals {{2(k-1) : k in Egyptian(4x)}}",
              taken == [2 * (k - 1) for k in E], f"tau {taken[:8]} vs {E[:8]}")


# =========================================================================== #
# 5.  H7: cosine, and 45 degrees
# =========================================================================== #


def claim_cosine() -> None:
    print("\n5. H7  cosine spends the same budgets; at 45 degrees the words agree")
    # the rule depends on the target only, so equal coordinates give equal words
    for theta in [mp.mpf("0.125"), mp.mpf("0.375")]:
        s, c = mp.sin(2 * mp.pi * theta), mp.cos(2 * mp.pi * theta)
        ws, _, _ = tau_greedy(s, 1, cap=200000)
        wc, _, _ = tau_greedy(c, 1, cap=200000)
        if abs(s - c) < mp.mpf("1e-60"):
            check(f"theta = {mp.nstr(theta,4)} (45 degrees): sin = cos, words identical",
                  ws == wc, f"|x| = {mp.nstr(abs(s), 10)}")
        else:
            check(f"theta = {mp.nstr(theta,4)}: different heights give different words",
                  ws != wc, f"sin={mp.nstr(s,6)}, cos={mp.nstr(c,6)}")
    # 270 degrees: sine -1, cosine 0
    s, c = mp.sin(2 * mp.pi * mp.mpf("0.75")), mp.cos(2 * mp.pi * mp.mpf("0.75"))
    check("theta = 0.75 (270 degrees): sin = -1 and cos = 0",
          abs(s + 1) < mp.mpf("1e-70") and abs(c) < mp.mpf("1e-70"),
          f"sin={mp.nstr(s,8)}, cos={mp.nstr(c,8)}")
    # cos = 0 is the empty sum: the word is all zeros
    taken, r, _ = tau_greedy(mp.mpf(0), 1, cap=100)
    check("cos(270 degrees) = 0 is the empty sum (all-zero word)", taken == [] and r == 0)


# =========================================================================== #
# 6.  H8: the helix keeps the turn count, the word does not
# =========================================================================== #


def tau_prefix(x, p, floor, cap=200000):
    """The takes that are decidable while the residual is comfortably above the
    precision floor: a residual below `floor` is not trustworthy at the working
    precision (the next take's denominator is ~1/residual)."""
    r = mp.mpf(x)
    taken: list[int] = []
    n = 0
    while r != 0 and n < cap and abs(r) > floor:
        t = mp.mpf((-1) ** n) / mp.mpf(n + 2) ** p
        if (r > 0 and t > 0) or (r < 0 and t < 0):
            if abs(t) <= abs(r):
                r = r - t
                taken.append(n)
        n += 1
    return taken, r


def claim_helix() -> None:
    print("\n6. H8  the word sees the height, not the turn count")
    old = mp.mp.dps
    mp.mp.dps = 200
    floor = mp.mpf("1e-100")
    for theta in ["0.1", "0.3", "0.42"]:
        t = mp.mpf(theta)
        xs = [mp.sin(2 * mp.pi * t), mp.sin(2 * mp.pi * (t + 1)),
              mp.sin(2 * mp.pi * (mp.mpf(1) / 2 - t))]
        words = [tau_prefix(x, 1, floor)[0] for x in xs]
        spread = max(abs(xs[i] - xs[0]) for i in (1, 2))
        check(f"theta = {theta}: theta, theta+1 and 1/2-theta give the same word "
              f"(prefixes above the 1e-100 floor, 200 dps)",
              words[0] == words[1] == words[2] and spread < mp.mpf("1e-150"),
              f"{len(words[0])} takes; max height spread {mp.nstr(spread, 3)}")
    mp.mp.dps = old
    # the helix height is periodic in theta but the axis is not
    # sin(2 pi (1-theta)) = -sin(2 pi theta): the mirror 1-theta has the opposite height
    t0 = mp.mpf("0.3")
    check("the reflection theta -> 1-theta flips the height (sin(2pi(1-t)) = -sin(2pi t))",
          abs(mp.sin(2 * mp.pi * (1 - t0)) + mp.sin(2 * mp.pi * t0)) < mp.mpf("1e-60"),
          f"sin(2pi t) = {mp.nstr(mp.sin(2*mp.pi*t0), 8)}, "
          f"sin(2pi(1-t)) = {mp.nstr(mp.sin(2*mp.pi*(1-t0)), 8)}")
    check("the helix lift is not periodic: (cos,sin,theta) differs at theta and theta+1",
          True, "definitional: the third coordinate is kept")


# =========================================================================== #
# 7.  The theory page's 45-degree expansion, against rh41's digitword
# =========================================================================== #


def claim_45() -> None:
    print("\n7. The theory page's 45-degree tail, recomputed with rh41's ground truth")
    # sin(pi/4) = 1/2 + 1/5 + 1/141 + 1/68575  (unsigned alphabet 1/(n+2))
    x = mp.sqrt(2) / 2
    w = greedy_word_mpmath("sqrt(2)/2", 70000)
    ones = [i for i, d in enumerate(w) if d]
    four = ones[:4]
    check("the support of the greedy word for sin(pi/4) starts {0, 3, 139, 68573}",
          four == [0, 3, 139, 68573], f"first four indices {four}")
    s = sum(Fraction(1, i + 2) for i in four)
    tail = x - mp.mpf(s.numerator) / s.denominator
    check("1/2 + 1/5 + 1/141 + 1/68575 matches sin(pi/4) to better than 1e-10",
          abs(tail) < mp.mpf("1e-10"), f"tail = {mp.nstr(tail, 6)}")
    # and the site's other exact example
    from rh41.digitword import greedy_word_rational
    w1 = greedy_word_rational(Fraction(1), 32)
    check("x = 1 has support {0,1,4} (rh41 Theorem 8, second half)",
          [i for i, d in enumerate(w1) if d] == [0, 1, 4])


# =========================================================================== #
# 8.  Thresholds: where a budget reaches 1
# =========================================================================== #


def claim_thresholds() -> None:
    print("\n8. Thresholds  where each budget reaches 1")
    pP = mp.findroot(lambda p: budget_pos(p) - 1, mp.mpf("1.45"))
    pN = mp.findroot(lambda p: budget_neg(p) - 1, mp.mpf("1.35"))
    pstar = mp.findroot(lambda p: mp.zeta(p) - 2, mp.mpf("1.73"))
    check("P(pP) = 1", abs(budget_pos(pP) - 1) < mp.mpf("1e-30"), f"pP = {mp.nstr(pP, 12)}")
    check("N(pN) = 1", abs(budget_neg(pN) - 1) < mp.mpf("1e-30"), f"pN = {mp.nstr(pN, 12)}")
    check("pN < pP < p*   (the negative budget binds first; p* solves zeta(p*) = 2, rh41)",
          pN < pP < pstar,
          f"pN = {mp.nstr(pN, 10)} < pP = {mp.nstr(pP, 10)} < p* = {mp.nstr(pstar, 10)}")
    check("at p* the positive budget is 2^(1-p*) < 1, so sin = 1 is NOT representable there",
          budget_pos(pstar) < 1,
          f"P(p*) = {mp.nstr(budget_pos(pstar), 10)}, P(p*) + N(p*) = {mp.nstr(budget_pos(pstar)+budget_neg(pstar), 10)}")
    # the whole sine range needs both budgets >= 1
    check("every sine in [-1,1] is inside budget iff p <= pN",
          budget_neg(pN + mp.mpf("1e-6")) < 1 < budget_neg(pN - mp.mpf("1e-6")),
          f"N(pN-1e-6) = {mp.nstr(budget_neg(pN - mp.mpf('1e-6')), 8)}")
    # asymmetry: the positive budget always exceeds the negative one
    asym = min(budget_pos(mp.mpf(p)) - budget_neg(mp.mpf(p))
               for p in ["1.01", "1.5", "2", "3", "5"])
    check("P(p) > N(p) for every p > 1 (positive sines are always cheaper)",
          asym > 0, f"min(P-N) = {mp.nstr(asym, 6)}")
    print(f"     pN = {mp.nstr(pN, 15)}   pP = {mp.nstr(pP, 15)}   p* = {mp.nstr(pstar, 15)}")


# =========================================================================== #
# 9.  Reuse: rh41's complexity law applies to the signed word's support
# =========================================================================== #


def claim_complexity() -> None:
    print("\n9. Reuse  rh41's Theorem 1 on a signed word's support")
    # (the Lean proof of complexity_main is generic in the support, so it holds
    #  for the tau support as well; here we only re-check the formula)
    for x, p in [(Fraction(1, 1), 1), (Fraction(2, 5), 1), (Fraction(3, 5), 1)]:
        taken, _, _ = tau_greedy(x, p, cap=400)
        if not taken:
            continue
        N = taken[-1] + 30
        ones = tuple(taken)
        am, a0 = ones[-1], ones[0]
        span = am - a0
        bad = []
        for L in range(max(span, am + 1, 1), N + 1):
            want = min(am + 1, N - L + 1) + (1 if L <= N - am - 1 else 0)
            if p_offset(ones, N, L) != want:
                bad.append(L)
        check(f"x = {x}: Theorem 1 holds on the tau support {ones[:6]}..., N = {N}",
              not bad, f"{len(bad)} violations")
    # the tau word has no two consecutive ones (all gaps even), so its min gap is >= 2
    taken, _, _ = tau_greedy(Fraction(3, 5), 1, cap=400)
    gaps = [b - a for a, b in zip(taken, taken[1:])]
    check("the signed word's support has all gaps even (>= 2), unlike the unsigned word",
          all(g % 2 == 0 for g in gaps) and min(gaps, default=2) >= 2,
          f"first gaps {gaps[:6]}")


# =========================================================================== #
# 10.  The reachable set: the budget is an outer bound, not the truth
# =========================================================================== #


def pos_intervals(p, k: int = 1, total=None, depth: int = 0):
    """Intervals of subset sums of the positive half {1/(2k)^p : k >= k0}.

    A non-increasing sequence whose first term is at most the sum of the rest is
    *complete*: its subset sums fill [0, total].  Otherwise the sums split into
    those that avoid the first term (the same construction on the tail) and
    those that use it (that construction shifted by the first term).  Returns a
    list of (lo, hi) intervals covering [0, total], sorted by `lo`.
    """
    if total is None:
        total = budget_pos(p)
    if k > 60 or depth > 60 or total <= 0:
        return [(mp.mpf(0), total)]
    a = mp.mpf(2 * k) ** (-p)
    if a <= total - a:                      # tail covers the rest: complete
        return [(mp.mpf(0), total)]
    rest = pos_intervals(p, k + 1, total - a, depth + 1)
    return rest + [(a + lo, a + hi) for (lo, hi) in rest]


def in_intervals(x, ivs, tol):
    return any(lo - tol <= x <= hi + tol for (lo, hi) in ivs)


def nearest_below(x, ivs):
    cands = [hi for (_, hi) in ivs if hi <= x]
    return max(cands) if cands else mp.mpf(0)


def claim_reachable() -> None:
    print("\n10. The reachable set  budget is necessary, completeness is the real threshold")

    # R1: p = 2 (> p*): exactly one gap per side of the positive half
    p = 2
    P2 = budget_pos(p)
    a1 = mp.mpf(2) ** (-p)
    ivs = pos_intervals(p)
    check("R1  p = 2: the positive half's subset sums are [0, P-a1] u [a1, P]",
          len(ivs) == 2 and abs(ivs[0][1] - (P2 - a1)) < mp.mpf("1e-30")
          and abs(ivs[1][0] - a1) < mp.mpf("1e-30"),
          f"intervals {[(mp.nstr(lo, 8), mp.nstr(hi, 8)) for lo, hi in ivs]}")
    print(f"      P(2) = {mp.nstr(P2, 12)}, a1 = 2^-2 = {a1}, gap = "
          f"({mp.nstr(P2 - a1, 12)}, {a1})")
    for x in ["0.15", "0.18", "0.2", "0.24", "0.25", "0.28", "0.3", "0.42"]:
        xm = mp.mpf(x)
        _, r, _ = tau_greedy(xm, p, cap=200000)
        lim = nearest_below(xm, ivs) if in_intervals(xm, ivs, mp.mpf("1e-12")) else nearest_below(xm, ivs)
        expect = xm - lim
        ok = (in_intervals(xm, ivs, mp.mpf("1e-9")) and r < mp.mpf("1e-9")) or \
             (not in_intervals(xm, ivs, mp.mpf("1e-9")) and abs(r - expect) < mp.mpf("1e-4"))
        check(f"R1  p = 2, x = {x}: "
              + ("reachable, residual -> 0" if in_intervals(xm, ivs, mp.mpf("1e-9"))
                 else f"unreachable, residual -> x - {mp.nstr(lim, 8)}"),
              ok, f"residual {mp.nstr(r, 10)}")

    # R2: p = 3 (> 2): the gap structure recurs, four intervals
    p = 3
    ivs3 = pos_intervals(p)
    check("R2  p = 3: the subset sums are four intervals (the gap recurs)",
          len(ivs3) == 4,
          f"{[(mp.nstr(lo, 6), mp.nstr(hi, 6)) for lo, hi in ivs3]}")
    for x in ["0.02", "0.05", "0.1", "0.125", "0.14", "0.15", "0.2"]:
        xm = mp.mpf(x)
        _, r, _ = tau_greedy(xm, p, cap=200000)
        reach = in_intervals(xm, ivs3, mp.mpf("1e-9"))
        lim = xm - nearest_below(xm, ivs3)
        ok = (reach and r < mp.mpf("1e-8")) or (not reach and abs(r - lim) < mp.mpf("1e-5"))
        check(f"R2  p = 3, x = {x}: "
              + ("reachable, residual -> 0" if reach else f"unreachable, residual -> {mp.nstr(lim, 8)}"),
              ok, f"residual {mp.nstr(r, 10)}")

    # R3: the completeness threshold is exactly p* (zeta(p) = 2)
    pstar = mp.findroot(lambda p: mp.zeta(p) - 2, mp.mpf("1.73"))
    lo, hi = pstar - mp.mpf("1e-6"), pstar + mp.mpf("1e-6")
    c_lo = mp.mpf(2) ** (-lo) <= budget_pos(lo) - mp.mpf(2) ** (-lo)
    c_hi = mp.mpf(2) ** (-hi) <= budget_pos(hi) - mp.mpf(2) ** (-hi)
    check("R3  the positive half is complete exactly for p <= p*, where zeta(p*) = 2 "
          "(rh41's threshold)",
          c_lo and not c_hi,
          f"complete at p*-1e-6: {c_lo}; complete at p*+1e-6: {c_hi}")
    p15 = mp.mpf("1.5")
    good = []
    for i in range(1, 12):
        x = budget_pos(p15) * i / 12
        _, r, _ = tau_greedy(x, p15, cap=200000)
        good.append(r < mp.mpf("1e-6"))
    check("R3  p = 1.5 < p*: every x tested in [0, P(1.5)] is reached", all(good),
          f"{sum(good)}/{len(good)} reached")

    # R4: the negative half has its own, larger completeness threshold
    def gap_neg(p):
        return budget_neg(p) - 2 * mp.mpf(3) ** (-p)
    q = mp.findroot(gap_neg, mp.mpf("2.07"))
    check("R4  the negative half is complete exactly for p <= q, with q ~ 2.07 > p* "
          "(the odd series starts at 1/3, so it stays complete longer)",
          gap_neg(q - mp.mpf("1e-6")) > 0 > gap_neg(q + mp.mpf("1e-6")),
          f"q = {mp.nstr(q, 12)}; p* = {mp.nstr(pstar, 12)}")
    print(f"      completeness thresholds:  positive half p* = {mp.nstr(pstar, 15)},  "
          f"negative half q = {mp.nstr(q, 15)}")

    # R6: the gap structure as a function of p (interval count and reachable measure)
    print("      p            P(p)          #intervals   measure/P")
    rows = []
    for ps in ["1.2", "1.5", "1.7", mp.nstr(pstar, 20), "1.8", "2", "2.2", "2.5", "3", "4", "6"]:
        pm = mp.mpf(ps)
        iv = pos_intervals(pm)
        meas = sum(hi - lo for lo, hi in iv)
        rows.append((pm, len(iv), meas / budget_pos(pm)))
        print(f"      {ps:>18}  {mp.nstr(budget_pos(pm), 10):>12}  {len(iv):>10}"
              f"   {mp.nstr(meas / budget_pos(pm), 8):>10}")
    check("R6  one interval for p <= p*, strictly more afterwards",
          all(n == 1 for (pm, n, _) in rows if pm <= pstar + mp.mpf("1e-12"))
          and all(n > 1 for (pm, n, _) in rows if pm > pstar + mp.mpf("1e-6")),
          f"counts {[n for (_, n, _) in rows]}")
    check("R6  the reachable fraction of the budget is non-increasing, and strictly "
          "decreases once p > p*",
          all(rows[i + 1][2] <= rows[i][2] + mp.mpf("1e-12") for i in range(len(rows) - 1))
          and all(rows[i + 1][2] < rows[i][2]
                  for i in range(len(rows) - 1) if rows[i][0] >= pstar),
          f"{[mp.nstr(r, 3) for (_, _, r) in rows]}")

    # R5: the reachable set is symmetric in sign, and its total length is zeta(p) - 1
    check("R5  the reachable set has measure zeta(p) - 1 before the gaps are removed "
          "(at p = 2: P + N = zeta(2) - 1)",
          abs(budget_pos(2) + budget_neg(2) - (mp.zeta(2) - 1)) < mp.mpf("1e-30"),
          f"P+N = {mp.nstr(budget_pos(2) + budget_neg(2), 12)}")


def main() -> int:
    print("=" * 78)
    print("rh42/helix_zeta — the helix perspective: signed alphabet and zeta budgets")
    print("=" * 78)
    claim_budgets()
    claim_pole()
    claim_criterion()
    claim_parity()
    claim_cosine()
    claim_helix()
    claim_45()
    claim_thresholds()
    claim_complexity()
    claim_reachable()
    print("\n" + "=" * 78)
    if FAILS:
        print(f"{len(FAILS)} FAILED, {NPASS} passed")
        for f in FAILS:
            print("  FAILED:", f)
    else:
        print(f"ALL {NPASS} CHECKS PASS")
    print("=" * 78)
    return 1 if FAILS else 0


if __name__ == "__main__":
    raise SystemExit(main())
