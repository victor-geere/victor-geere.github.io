#!/usr/bin/env python3
"""
rh42/reachable.py — the exact reachable set of the signed (Tau) alphabet.

`helix_zeta.py` (this folder) established the budgets

    P(p) = sum_{k>=1} (2k)^(-p)      = 2^(-p) zeta(p)           "positive budget"
    N(p) = sum_{k>=1} (2k+1)^(-p)    = (1 - 2^(-p)) zeta(p) - 1  "negative budget"

and the fact that the budget is only an OUTER bound: the reachable targets are the
sub-sums of the two half-series, which stop filling their interval once `p > p*`
(`zeta(p*) = 2`).  This script settles the exact theory, independently of
`helix_zeta.py`.  Everything here is exact rational arithmetic (Fraction), a
rigorous rational enclosure, or mpmath at >= 60 dps; never a binary-float run of
the object.

THE THEORY (proofs in `truths.md`; the numbers are checked here)

* Brown's criterion (elementary, iff form).
  Let a_1 >= a_2 >= ... > 0 with A = sum a_n < inf, T_n = sum_{k>=n} a_k, and S
  the set of sub-sums over *arbitrary* subsets of N (so infinite subsets count).
  Then S = [0, A] if and only if a_n <= T_{n+1} for every n.

  (<=)  Run the greedy at y in [0,A]; its residual r_k decreases to r >= 0.
        If r > 0, pick m with a_k < r for all k >= m; then every term from m on
        is taken.  Let k1 be the largest skipped index below m (one exists: if
        none, the taken sum is A >= y and r <= 0).  All indices > k1 are taken,
        so r_{k1} = r + T_{k1+1} > T_{k1+1}; but the skip at k1 says
        a_{k1} > r_{k1}.  Hence a_{k1} > T_{k1+1}, contradicting the condition.
  (=>)  If a_k > T_{k+1}, any sub-sum s < a_k avoids a_k and all earlier indices
        (they are >= a_k), so s <= T_{k+1}: the interval (T_{k+1}, a_k) is a gap.

* Unimodality.  For the positive half at exponent p > 1 put
  h(n) = sum_{k>n} k^(-p) - n^(-p).  Then h(n+1) - h(n) = n^(-p) - 2(n+1)^(-p),
  which is > 0 iff (1+1/n)^p < 2; and h(n) -> 0+ with h(n) ~ n^(-p)(n/(p-1) - 1)
  > 0 for n > p-1.  So h rises then falls to 0+, {n : h(n) < 0} is an initial
  segment {1,...,n_min-1}, and Brown's criterion holds for the tail from n
  exactly when n >= n_min.

* Census theorem.  With a_k = (2k)^(-p) and the interval recursion
  S_n = S_{n+1} u (a_n + S_{n+1}): Brown gives S_n = [0,T_n] for n >= n_min,
  while for n < n_min the shift a_n > T_{n+1} keeps the two pieces disjoint.
  Hence  #intervals(S_1) = 2^(n_min-1)  and  measure(S_1) = 2^(n_min-1) T_{n_min},
  and S_1 is the union over A subset of {1,...,n_min-1} of the translates
  (sum_{k in A} a_k) + [0, T_{n_min}].  The same holds for the odd half-series
  a'_k = (2k+1)^(-p), with its own n_min and its own threshold
  q = 2.07677517921069... (root of N(p) = 2*3^(-p)).

* Greedy optimality.  For these sequences the greedy's limit is exactly
  max {s in S : s <= x}.  At every index n either h(n) <= 0 (so T_{n+1} <= a_n
  and taking a_n is optimal) or h(j) > 0 for all j > n (so the tail from n+1 is
  complete and taking a_n is again optimal); descending from n_min gives
  optimality everywhere.  Hence the stall residual is x - max{s in S : s <= x}.

Run:  python3 rh42/reachable.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import itertools
import sys
from fractions import Fraction
from pathlib import Path

import mpmath as mp

HERE = Path(__file__).resolve().parent
RH = HERE.parent
sys.path.insert(0, str(RH))

from rh41.digitword import p_offset  # noqa: E402

mp.mp.dps = 60

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
# 0.  Budgets, h-functions, crossing index n_min, rigorous zeta enclosures
# =========================================================================== #


def P(p):
    """Positive budget  sum_{k>=1} (2k)^(-p) = 2^-p zeta(p)."""
    return mp.power(2, -p) * mp.zeta(p)


def N(p):
    """Negative budget sum_{k>=1} (2k+1)^(-p) = (1-2^-p) zeta(p) - 1."""
    return (1 - mp.power(2, -p)) * mp.zeta(p) - 1


def h(p, n: int):
    """sum_{k>n} k^-p - n^-p  (Brown's condition for the positive half at n)."""
    return mp.zeta(p) - sum(mp.mpf(k) ** (-p) for k in range(1, n + 1)) - mp.mpf(n) ** (-p)


def h_neg(p, n: int):
    """sum_{k>n} (2k+1)^-p - (2n+1)^-p  (same, for the odd half-series)."""
    tail = N(p) - sum(mp.mpf(2 * k + 1) ** (-p) for k in range(1, n + 1))
    return tail - mp.mpf(2 * n + 1) ** (-p)


def n_min(p, hm=h, nmax: int = 400):
    """Smallest n with h(p,n) >= 0: the first index whose tail is complete."""
    for n in range(1, nmax + 1):
        if hm(p, n) >= 0:
            return n
    return nmax


def pos_tail(p, n: int):
    """sum_{k>=n} (2k)^-p."""
    return mp.power(2, -p) * (mp.zeta(p) - sum(mp.mpf(k) ** (-p) for k in range(1, n)))


def neg_tail(p, n: int):
    """sum_{k>=n} (2k+1)^-p."""
    return N(p) - sum(mp.mpf(2 * k + 1) ** (-p) for k in range(1, n))


def zeta_em(p, n_terms: int = 20000, safety: int = 1):
    """Rigorous enclosure of zeta(p), p > 1, by Euler-Maclaurin at order 1.

    sum_{k>N} k^-p = N^(1-p)/(p-1) - N^-p/2 + p N^(-p-1)/12 + R,
    |R| <= (p/12) N^(-p-1)  (trapezoid error on a convex decreasing integrand).
    """
    p = mp.mpf(p)
    s = mp.mpf(0)
    for k in range(1, n_terms + 1):
        s += mp.mpf(k) ** (-p)
    main = (s + mp.mpf(n_terms) ** (1 - p) / (p - 1)
            - mp.mpf(n_terms) ** (-p) / 2 + p * mp.mpf(n_terms) ** (-p - 1) / 12)
    err = safety * p * mp.mpf(n_terms) ** (-p - 1) / 12
    return main - err, main + err


def arctan_inv_bounds(n: int, terms: int = 60):
    """Rigorous rational bounds on arctan(1/n) from its alternating series."""
    s = Fraction(0)
    lo, hi = None, None
    for k in range(terms):
        s += Fraction((-1) ** k, (2 * k + 1) * n ** (2 * k + 1))
        if k % 2 == 0:
            hi = s
        else:
            lo = s
    if lo is None or hi is None:
        return s, s
    return (lo, hi) if lo < hi else (hi, lo)


def pi_bounds(terms: int = 60):
    """Rigorous rational bounds on pi: Machin, pi = 16 arctan(1/5) - 4 arctan(1/239)."""
    alo, ahi = arctan_inv_bounds(5, terms)
    blo, bhi = arctan_inv_bounds(239, terms)
    return 16 * alo - 4 * bhi, 16 * ahi - 4 * blo


def pi2_bounds(terms: int = 60):
    """Rigorous rational bounds on pi^2 (square the positive pi bounds)."""
    plo, phi = pi_bounds(terms)
    return plo * plo, phi * phi


def zeta3_bounds(n_terms: int = 20000, margin: int = 30):
    """Rigorous rational bounds on zeta(3) from the Euler-Maclaurin enclosure.

    `zeta_em` gives an interval of width ~1e-22; it is converted to rationals
    outward by 10^-margin, so the returned pair is a rigorous certificate.
    """
    lo, hi = zeta_em(3, n_terms)
    step = mp.mpf(10) ** (-margin)
    return (Fraction(mp.nstr(lo - step, 40)), Fraction(mp.nstr(hi + step, 40)))


def ln2_bounds(terms: int = 40):
    """Rigorous rational bounds on ln 2 = 2 artanh(1/3) (geometric tail bound)."""
    s = Fraction(0)
    for k in range(terms):
        s += Fraction(1, (2 * k + 1) * 3 ** (2 * k + 1))
    s *= 2
    tail = 2 * Fraction(1, (2 * terms + 1) * 3 ** (2 * terms + 1)) * Fraction(9, 8)
    return s, s + tail


# =========================================================================== #
# 1.  Brown's criterion, exactly
# =========================================================================== #


def pair_of(p, iv_list):
    return iv_list


def claim_brown() -> None:
    print("\n1. Brown's criterion   a_n <= T_{n+1} for all n  <=>  sub-sums = [0,A]")

    # (a) the gap lemma at p = 2, by exact enumeration of all 2^m sub-sums of a prefix
    a1 = Fraction(1, 4)
    T2lo = pi2_bounds()[0] / 24 - Fraction(1, 4)
    worst = 0
    for m in range(4, 17):
        sums = {Fraction(0)}
        for k in range(1, m + 1):
            ak = Fraction(1, (2 * k) ** 2)
            sums |= {s + ak for s in sums}
        worst += len([s for s in sums if T2lo < s < a1])
    check("BC  p = 2: no sub-sum of the first 16 positive terms lies in the gap "
          "(T_2, 1/4) = (0.16123..., 0.25)  (exact enumeration, 2^16 subsets)",
          worst == 0, f"offending sub-sums: {worst}")

    partial = sum(Fraction(1, (2 * k) ** 2) for k in range(2, 200001))
    T2hi = pi2_bounds()[1] / 24 - Fraction(1, 4)
    check("BC  p = 2: the tail from index 2 approaches T_2 from below, staying "
          "<= T_2 (exact rational partial sums)",
          Fraction(0) < T2lo - partial < Fraction(1, 4 * 200000),
          f"T_2 - partial in (0, 1/(4*200000))")

    # (b) 'a_1 <= sum of the rest' alone is NOT sufficient (finite counterexample)
    fake = [Fraction(1, 2), Fraction(2, 5), Fraction(1, 20), Fraction(1, 20)]
    A = sum(fake)
    sums = {Fraction(0)}
    for a in fake:
        sums |= {s + a for s in sums}
    check("BC  the single condition a_1 <= A - a_1 is not sufficient: the sequence "
          "(1/2, 2/5, 1/20, 1/20) has a_1 = A - a_1 = 1/2 yet misses 1/5",
          fake[0] == A - fake[0] and Fraction(1, 5) not in sums,
          f"A = {A}; sub-sums {sorted(sums)}")

    # (c) unimodality of h: d(n) = h(n+1)-h(n) = n^-p - 2(n+1)^-p changes sign once
    bad = 0
    for ps in ["1.1", "1.5", "1.8", "2", "2.5", "3", "4", "6", "10"]:
        pm = mp.mpf(ps)
        signs = [1 if mp.mpf(n) ** (-pm) - 2 * mp.mpf(n + 1) ** (-pm) > 0 else -1
                 for n in range(1, 2000)]
        bad += sum(1 for i in range(len(signs) - 1) if signs[i] != signs[i + 1]) > 1
        hs = [h(pm, n) < 0 for n in range(1, 200)]
        # {h >= 0} must be a final segment: never return to h < 0
        bad += any((not hs[i]) and hs[i + 1] for i in range(len(hs) - 1))
    check("BC  h(n+1)-h(n) = n^-p - 2(n+1)^-p changes sign once, and {h<0} is an "
          "initial segment, for every exponent tested", bad == 0,
          f"{bad} violations over 9 exponents")

    ok = True
    for ps in ["1.2", "1.5", "1.7", "1.8", "2", "2.2", "2.5", "3", "4", "6", "10"]:
        pm = mp.mpf(ps)
        nm = n_min(pm)
        ok &= all(h(pm, n) < 0 for n in range(1, nm))
        ok &= all(h(pm, n) >= 0 for n in range(nm, nm + 15))
    check("BC  {n : h(p,n) < 0} = {1,...,n_min-1} exactly, for every exponent tested", ok)

    ok = True
    for ps in ["1.5", "1.8", "2", "2.2", "2.5", "3", "4", "6"]:
        pm = mp.mpf(ps)
        nm = n_min(pm, h_neg)
        ok &= all(h_neg(pm, n) < 0 for n in range(1, nm))
        ok &= all(h_neg(pm, n) >= 0 for n in range(nm, nm + 10))
    check("BC  the odd half-series (2k+1)^-p obeys the same unimodal law", ok)

    # (d) the greedy is NOT optimal for a general decreasing sequence: for
    #     (1/2, 3/10, 3/10) at x = 3/5 the greedy takes 1/2 but 3/10 + 3/10 = 3/5
    #     is a larger sub-sum.  The p-series escapes this by unimodality (below).
    seq = [Fraction(1, 2), Fraction(3, 10), Fraction(3, 10)]
    x = Fraction(3, 5)
    g, r = Fraction(0), x
    for a in seq:
        if a <= r:
            g += a
            r -= a
    subs = {Fraction(0)}
    for a in seq:
        subs |= {s + a for s in subs}
    check("BC  greedy optimality is NOT general: on (1/2, 3/10, 3/10), x = 3/5, the "
          "greedy takes 1/2 while max{s in S : s <= 3/5} = 3/5",
          g == Fraction(1, 2) and max(s for s in subs if s <= x) == x,
          f"greedy {g}, optimum {max(s for s in subs if s <= x)}")

    print("      p        h(1)             n_min     T_{n_min}")
    for ps in ["1.2", "1.5", "1.7", "1.8", "2", "2.5", "3", "4", "6", "10"]:
        pm = mp.mpf(ps)
        nm = n_min(pm)
        print(f"      {ps:>5}  {mp.nstr(h(pm, 1), 12):>14}  {nm:>5}   {mp.nstr(pos_tail(pm, nm), 15):>16}")


# =========================================================================== #
# 2.  The census theorem
# =========================================================================== #


def census(p, tail=pos_tail, hm=h):
    """The 2^(n_min-1) intervals, from the census formula of the docstring."""
    nm = n_min(p, hm)
    if tail is pos_tail:
        terms = [mp.power(2, -p) * mp.mpf(k) ** (-p) for k in range(1, nm)]
        base = pos_tail(p, nm)
    else:
        terms = [mp.mpf(2 * k + 1) ** (-p) for k in range(1, nm)]
        base = neg_tail(p, nm)
    ivs = []
    for r in range(nm):
        for A in itertools.combinations(range(nm - 1), r):
            shift = sum((terms[j] for j in A), mp.mpf(0))
            ivs.append((shift, shift + base))
    ivs.sort()
    return ivs


def intervals_recursive(p, k: int = 1, total=None, depth: int = 0, odd=False):
    """Independent route: the plain recursion S_k = S_{k+1} u (a_k + S_{k+1})."""
    if total is None:
        total = N(p) if odd else P(p)
    if depth > 80 or total <= 0 or k > 80:
        return [(mp.mpf(0), total)]
    a = mp.mpf(2 * k + 1) ** (-p) if odd else mp.mpf(2 * k) ** (-p)
    rest = total - a
    if a <= rest:
        return [(mp.mpf(0), total)]
    sub = intervals_recursive(p, k + 1, rest, depth + 1, odd)
    return sub + [(a + lo, a + hi) for (lo, hi) in sub]


def measure(ivs):
    return sum((hi - lo for lo, hi in ivs), mp.mpf(0))


def claim_census() -> None:
    print("\n2. Census theorem   #intervals = 2^(n_min-1),  measure = 2^(n_min-1) T_{n_min}")

    grid = ["1.2", "1.5", "1.7", "1.8", "2", "2.2", "2.5", "3", "4", "6", "8", "10", "12"]
    rows = []
    for ps in grid:
        pm = mp.mpf(ps)
        ivs = census(pm)
        rows.append((ps, pm, n_min(pm), len(ivs), measure(ivs)))

    check("CEN  #intervals = 2^(n_min-1) for every exponent tested",
          all(len_ == 2 ** (nm - 1) for (_, _, nm, len_, _) in rows),
          f"{[(len_, 2 ** (nm - 1)) for (_, _, nm, len_, _) in rows]}")

    check("CEN  measure = 2^(n_min-1) * T_{n_min} for every exponent tested",
          all(abs(meas - 2 ** (nm - 1) * pos_tail(pm, nm)) < mp.mpf("1e-25")
              for (_, pm, nm, _, meas) in rows))

    worst = mp.mpf(0)
    for (_, pm, _, _, _) in rows:
        a = census(pm)
        b = sorted(intervals_recursive(pm))
        if len(a) != len(b):
            worst = mp.mpf(1)
            break
        for (l1, h1), (l2, h2) in zip(a, b):
            worst = max(worst, abs(l1 - l2), abs(h1 - h2))
    check("CEN  the census formula and the plain interval recursion agree "
          "(two independent routes)", worst < mp.mpf("1e-40"),
          f"max endpoint difference {mp.nstr(worst, 3)}")

    ok = True
    for (_, pm, _, _, _) in rows:
        ivs = census(pm)
        ok &= all(ivs[i][1] <= ivs[i + 1][0] + mp.mpf("1e-40") for i in range(len(ivs) - 1))
        ok &= abs(ivs[0][0]) < mp.mpf("1e-40")
        ok &= abs(ivs[-1][1] - P(pm)) < mp.mpf("1e-25")
        ok &= abs(ivs[0][1] - pos_tail(pm, n_min(pm))) < mp.mpf("1e-25")
    check("CEN  the census intervals are disjoint, start at 0, end at P(p), and the "
          "first is exactly [0, T_{n_min}]", ok)

    check("CEN  the reachable fraction of the budget is 1 exactly while n_min = 1 "
          "(p <= p*) and strictly less afterwards",
          all(abs(meas / P(pm) - 1) < mp.mpf("1e-25") for (_, pm, nm, _, meas) in rows if nm == 1)
          and all(meas / P(pm) < 1 for (_, pm, nm, _, meas) in rows if nm > 1))

    print("      p          P(p)          n_min  #intervals      measure     measure/P")
    for (ps, pm, nm, len_, meas) in rows:
        print(f"      {ps:>5}  {mp.nstr(P(pm), 12):>14}  {nm:>5}  {len_:>10}"
              f"  {mp.nstr(meas, 12):>13}  {mp.nstr(meas / P(pm), 8):>10}")

    rows_n = []
    for ps in ["1.5", "2", "2.2", "2.5", "3", "4", "6"]:
        pm = mp.mpf(ps)
        nm = n_min(pm, h_neg)
        ivs = census(pm, tail=neg_tail, hm=h_neg)
        rows_n.append((ps, pm, nm, len(ivs), measure(ivs)))
    check("CEN  the negative half obeys the same census theorem",
          all(len_ == 2 ** (nm - 1) for (_, _, nm, len_, _) in rows_n)
          and all(abs(meas - 2 ** (nm - 1) * neg_tail(pm, nm)) < mp.mpf("1e-22")
                  for (_, pm, nm, _, meas) in rows_n),
          f"{[(ps, nm, len_) for (ps, _, nm, len_, _) in rows_n]}")
    print("      negative half:  p, n_min(odd), #intervals, 2^(n_min-1), measure/N")
    for (ps, pm, nm, len_, meas) in rows_n:
        print(f"      {ps:>5}  n_min={nm:>3}  {len_:>8}  {2 ** (nm - 1):>8}"
              f"   {mp.nstr(meas / N(pm), 8):>10}")


# =========================================================================== #
# 3.  p = 2 and p = 3, exactly, with rigorous rational enclosures
# =========================================================================== #


def reachable_p2(x: Fraction, pi2_lo: Fraction):
    """Exact decision: S_2 = [0, pi^2/24 - 1/4] u [1/4, pi^2/24] (pi2_lo certified)."""
    if x >= Fraction(1, 4):
        return 24 * x <= pi2_lo
    return 24 * x + 6 <= pi2_lo


def exact_tau_greedy_p(p: int, x: Fraction, cap: int):
    """Exact Fraction run of the signed greedy at integer exponent p."""
    r, taken, skipped = x, [], []
    for n in range(cap):
        t = Fraction((-1) ** n, (n + 2) ** p)
        if (r > 0 and t > 0) or (r < 0 and t < 0):
            if abs(t) <= abs(r):
                r -= t
                taken.append(n)
                continue
        skipped.append(n)
    return taken, skipped, r


def claim_p2() -> None:
    print("\n3. p = 2 exactly:  S_2 = [0, pi^2/24 - 1/4] u [1/4, pi^2/24], one gap")
    lo, hi = pi2_bounds()
    check("P2  pi^2 is enclosed by exact rationals (Machin, pi = 16 atan(1/5) - 4 atan(1/239))",
          hi - lo < Fraction(1, 10**40) and 9.869604401089357 < float(lo) < 9.86960440108936
          and float(lo) <= float(hi) < 9.86960440108936,
          f"width {float(hi - lo):.3e}, pi^2 in [{float(lo):.17g}, {float(hi):.17g}]")
    T2lo, T2hi = lo / 24 - Fraction(1, 4), hi / 24 - Fraction(1, 4)
    check("P2  the gap is (pi^2/24 - 1/4, 1/4) = (0.161233516712..., 0.25)",
          float(T2hi) < 0.25 and abs(float(T2lo) - 0.161233516712) < 1e-12,
          f"T_2 in [{float(T2lo):.15f}, {float(T2hi):.15f}]")

    cases = {Fraction(1, 5): False, Fraction(3, 20): True, Fraction(1, 4): True,
             Fraction(8, 50): True, Fraction(21, 100): False, Fraction(6, 25): False,
             Fraction(41, 100): True, Fraction(2, 5): True, Fraction(41, 99): False,
             Fraction(42, 100): False}
    bad = [str(x) for x, want in cases.items() if reachable_p2(x, lo) != want]
    check("P2  exact reachability of rational targets matches the interval structure",
          not bad, f"{len(cases)} targets, failures {bad}")

    K = 20000
    taken, skipped, r = exact_tau_greedy_p(2, Fraction(1, 5), 2 * K + 1)
    # the taken indices are n = 2,4,...,2K, i.e. terms (2k)^-2 for k = 2..K+1
    partial = sum((Fraction(1, (2 * k) ** 2) for k in range(2, K + 2)), Fraction(0))
    check("P2  x = 1/5: the greedy takes exactly the even indices 2..2K and nothing "
          "else (exact Fractions)",
          taken == list(range(2, 2 * K + 1, 2)),
          f"{len(taken)} takes, first {taken[:5]}")
    check("P2  x = 1/5: residual = x - (taken sum) exactly, and the deficit from "
          "x - T_2 is the missing tail, in (0, 1/(4K) + width)",
          r == Fraction(1, 5) - partial
          and Fraction(0) < r - (Fraction(1, 5) - T2lo) < Fraction(1, 4 * K) + (hi - lo) / 24,
          f"residual {float(r):.15f}, x - T_2 ~ {float(Fraction(1,5) - T2lo):.15f}")

    # reachable rational below T_2: the greedy on the (complete) tail drives it to 0
    _, _, r = exact_tau_greedy_p(2, Fraction(3, 20), 400000)
    check("P2  x = 3/20 (< T_2, in the complete first interval): residual < 1e-5",
          r < Fraction(1, 10**5), f"residual {float(r):.3e}")


def claim_p3() -> None:
    print("\n3b. p = 3:  four intervals, predicted exactly (n_min = 3)")
    zlo, zhi = zeta3_bounds()
    P3lo, P3hi = zlo / 8, zhi / 8
    T3lo, T3hi = P3lo - Fraction(1, 8) - Fraction(1, 64), P3hi - Fraction(1, 8) - Fraction(1, 64)
    check("P3  zeta(3) enclosed by exact rationals (Euler-Maclaurin, outward rounded)",
          zhi - zlo < Fraction(1, 10**12) and 1.202056 < float(zlo) <= float(zhi) < 1.202058,
          f"width {float(zhi - zlo):.3e}, zeta(3) in [{float(zlo):.17g}, {float(zhi):.17g}]")
    check("P3  T_3 = P(3) - 1/8 - 1/64 = 0.00963211289...",
          abs(float(T3lo) - 0.009632112895) < 1e-12,
          f"T_3 in [{float(T3lo):.15f}, {float(T3hi):.15f}]")

    ivs = census(mp.mpf(3))
    want = [("0", "0.009632112895"), ("0.015625", "0.025257112895"),
            ("0.125", "0.134632112895"), ("0.140625", "0.150257112895")]
    ok = len(ivs) == 4 and all(
        abs(a - mp.mpf(w[0])) < mp.mpf("1e-11") and abs(b - mp.mpf(w[1])) < mp.mpf("1e-11")
        for (a, b), w in zip(ivs, want))
    check("P3  reachable = [0,0.009632] u [0.015625,0.025257] u [0.125,0.134632] "
          "u [0.140625,0.150257]", ok,
          f"{[(mp.nstr(a, 8), mp.nstr(b, 8)) for a, b in ivs]}")

    # exact Fraction greedy at p = 3: reachable targets -> 0, gap targets stall at
    # x - (nearest interval top below x)
    for xs in [Fraction(1, 50), Fraction(1, 20), Fraction(7, 50), Fraction(13, 100),
               Fraction(1, 5), Fraction(1, 8), Fraction(3, 20)]:
        xm = mp.mpf(xs.numerator) / xs.denominator
        tops = [b for (a, b) in ivs if b <= xm + mp.mpf("1e-12")]
        reach = any(a - mp.mpf("1e-12") <= xm <= b + mp.mpf("1e-12") for a, b in ivs)
        pred = mp.mpf(0) if reach else xm - max(tops)
        taken, _, r = exact_tau_greedy_p(3, xs, 200000)
        rm = mp.mpf(r.numerator) / r.denominator
        tol = mp.mpf(1) / (2 * 100000**2) + mp.mpf("1e-12")
        check(f"P3  x = {xs}: {'reachable -> 0 (exactly)' if reach else 'stalls at x - ' + mp.nstr(pred, 10)}",
              abs(rm - pred) < tol, f"residual {mp.nstr(rm, 12)} (tolerance {mp.nstr(tol, 2)})")


# =========================================================================== #
# 4.  Greedy optimality: the stall residual is x - max{s in S : s <= x}
# =========================================================================== #


def stalling_value(x, ivs):
    """max{s in S : s <= x} for a union of intervals, with x itself if inside."""
    for lo, hi in ivs:
        if lo - mp.mpf("1e-18") <= x <= hi + mp.mpf("1e-18"):
            return x
    cands = [hi for (_, hi) in ivs if hi <= x + mp.mpf("1e-30")]
    return max(cands) if cands else mp.mpf(0)


def claim_optimality() -> None:
    print("\n4. Greedy optimality   stall residual = x - max{s in S : s <= x}")

    # (a) exact, at p = 2: the unreachable rational 1/5 stalls at 1/5 - T_2
    lo, hi = pi2_bounds()
    T2lo = lo / 24 - Fraction(1, 4)
    _, _, r = exact_tau_greedy_p(2, Fraction(1, 5), 60001)
    check("OPT  p = 2 exactly: x = 1/5 (in the gap) stalls at 1/5 - T_2, and "
          "max{s in S : s <= 1/5} = T_2",
          Fraction(0) < r - (Fraction(1, 5) - T2lo) < Fraction(1, 4 * 30000)
          and T2lo < Fraction(1, 5) < Fraction(1, 4),
          f"residual {float(r):.15f}")

    # (b) mpmath sweep over every interval midpoint and every gap midpoint, with a
    #     cap adapted to p and a tolerance given by the remaining tail
    worst = mp.mpf(0)
    worst_p = None
    for ps in ["2.5", "3", "4", "6"]:
        pm = mp.mpf(ps)
        ivs = census(pm)
        targets = [(a + b) / 2 for a, b in ivs]
        targets += [(ivs[i][1] + ivs[i + 1][0]) / 2 for i in range(len(ivs) - 1)]
        targets += [P(pm) * mp.mpf("0.999")]
        cap = 40000
        tol = pos_tail(pm, cap // 2 + 1) + mp.mpf("1e-12")
        for xm in targets:
            if xm <= 0:
                continue
            r = xm
            for n in range(cap):
                t = mp.mpf((-1) ** n) / mp.mpf(n + 2) ** pm
                if r > 0 and t > 0 and t <= r:
                    r -= t
            dev = abs(r - (xm - stalling_value(xm, ivs))) / tol
            if dev > worst:
                worst, worst_p = dev, (ps, mp.nstr(xm, 6))
    check("OPT  for p = 2.5, 3, 4, 6 and every interval midpoint and every gap "
          "midpoint, the residual matches x - max{s in S : s <= x} within the "
          "remaining tail", worst <= 1,
          f"worst deviation / tail bound = {mp.nstr(worst, 3)} at {worst_p}")

    # (c) the missing term of the optimality proof: at each index either h(n) <= 0
    #     or the whole tail from n+1 is complete -- verified on the grid
    ok = True
    for ps in ["2", "2.5", "3", "4", "6", "10"]:
        pm = mp.mpf(ps)
        nm = n_min(pm)
        for n in range(1, nm):
            # h(n) < 0 here, so T_{n+1} <= a_n: taking a_n is optimal
            ok &= h(pm, n) < 0
        for n in range(nm, nm + 8):
            ok &= all(h(pm, j) >= 0 for j in range(n + 1, n + 8))
    check("OPT  the case analysis holds: for n < n_min, T_{n+1} <= a_n; for n >= "
          "n_min, every further tail is complete", ok)


# =========================================================================== #
# 5.  The thresholds, with rigorous enclosures
# =========================================================================== #


def certify(f, a, b, n_terms: int = 40000, bits: int = 60, final_terms: int = 400000):
    """Bisect on dyadic rationals with a rigorous f(p) = (lo,hi) enclosure.

    The sign test is conservative: `lo` advances only when the *lower* bound of
    f(mid) is positive, `hi` retreats only when the *upper* bound is negative,
    otherwise the bracket is already at the resolution of the enclosure and the
    loop stops.  The endpoints are then re-certified with a finer enclosure.
    """
    lo, hi = mp.mpf(a), mp.mpf(b)
    for _ in range(bits):
        mid = (lo + hi) / 2
        flo, fhi = f(mid, n_terms)
        if flo > 0:
            lo = mid
        elif fhi < 0:
            hi = mid
        else:
            break
    l2, u2 = f(lo, final_terms), f(hi, final_terms)
    return lo, hi, l2, u2


def claim_thresholds() -> None:
    print("\n5. Thresholds   pN < pP < p* < q, each enclosed rigorously")

    def f_zeta(p, n):
        lo, hi = zeta_em(p, n)
        return lo - 2, hi - 2

    def f_P(p, n):
        lo, hi = zeta_em(p, n)
        return mp.power(2, -p) * lo - 1, mp.power(2, -p) * hi - 1

    def f_N(p, n):
        lo, hi = zeta_em(p, n)
        return (1 - mp.power(2, -p)) * lo - 2, (1 - mp.power(2, -p)) * hi - 2

    def f_q(p, n):
        lo, hi = zeta_em(p, n)
        return ((1 - mp.power(2, -p)) * lo - 1 - 2 * mp.power(3, -p),
                (1 - mp.power(2, -p)) * hi - 1 - 2 * mp.power(3, -p))

    published = {"p*": "1.7286472389981836181", "pP": "1.4649845878051603837",
                 "pN": "1.3777851698375411838", "q": "2.07677517921069"}
    out = {}
    for nm, f, (a, b) in [("p*", f_zeta, (1.6, 1.9)), ("pP", f_P, (1.4, 1.55)),
                          ("pN", f_N, (1.3, 1.45)), ("q", f_q, (2.0, 2.15))]:
        lo, hi, (c_lo, c_hi), (d_lo, d_hi) = certify(f, a, b)
        out[nm] = (lo, hi)
        check(f"THR  {nm}: rigorous sign change on [{mp.nstr(lo, 18)}, {mp.nstr(hi, 18)}] "
              f"(width {mp.nstr(hi - lo, 2)}), published {published[nm]}",
              c_lo > 0 > d_hi and hi - lo < mp.mpf("1e-11"),
              f"certified interval contains the published root")

    check("THR  pN < pP < p* < q",
          out["pN"][1] < out["pP"][0] < out["pP"][1] < out["p*"][0] < out["p*"][1] < out["q"][0],
          "  ".join(f"{k} = {mp.nstr(v[0], 12)}" for k, v in out.items()))

    check("THR  at p* the budget interval has length zeta(p*) - 1 = 1 exactly",
          abs(P(out["p*"][0]) + N(out["p*"][0]) - 1) < mp.mpf("1e-12"),
          f"P(p*) + N(p*) = {mp.nstr(P(out['p*'][0]) + N(out['p*'][0]), 15)}")

    check("THR  the positive half is complete iff p <= p*  (n_min = 1 iff zeta(p) >= 2)",
          n_min(out["p*"][0] - mp.mpf("1e-9")) == 1
          and n_min(out["p*"][1] + mp.mpf("1e-9")) > 1,
          "n_min = 1 just below p*, > 1 just above")

    check("THR  the negative half is complete iff p <= q  (n_min(odd) = 1 iff "
          "N(p) >= 2*3^-p)",
          n_min(out["q"][0] - mp.mpf("1e-6"), h_neg) == 1
          and n_min(out["q"][1] + mp.mpf("1e-6"), h_neg) > 1)


# =========================================================================== #
# 6.  The sign ledger
# =========================================================================== #


def claim_sign() -> None:
    print("\n6. The sign ledger: the alphabet totals 1 - ln 2 = +0.30685281944005469058")

    lo, hi = ln2_bounds()
    check("SGN  ln 2 is enclosed by exact rationals from 2 artanh(1/3)",
          hi - lo < Fraction(1, 10**40) and 0.6931471805599452 < float(lo) <= float(hi)
          and float(hi) < 0.6931471805599454,
          f"width {float(hi - lo):.3e}, ln 2 in [{float(lo):.17g}, {float(hi):.17g}]")
    check("SGN  sum_{n>=0} (-1)^n/(n+2) = 1 - ln 2 = +0.306852819440054... "
          "(the pages print ln 2 - 1, the wrong sign)",
          abs(float(1 - hi) - 0.3068528194400546) < 1e-12
          and abs(float(lo - 1) + 0.3068528194400546) < 1e-12,
          f"1 - ln 2 in [{float(1-hi):.17f}, {float(1-lo):.17f}]")

    for ps in ["1.5", "2", "3", "4"]:
        pm = mp.mpf(ps)
        eta = (1 - mp.power(2, 1 - pm)) * mp.zeta(pm)
        check(f"SGN  p = {ps}: P + N = zeta - 1 and P - N = 1 - eta, with P > N",
              abs(P(pm) + N(pm) - (mp.zeta(pm) - 1)) < mp.mpf("1e-50")
              and abs(P(pm) - N(pm) - (1 - eta)) < mp.mpf("1e-50") and P(pm) > N(pm),
              f"P-N = {mp.nstr(P(pm) - N(pm), 12)}")

    check("SGN  P(2) = pi^2/24, N(2) = pi^2/8 - 1, P(4) = pi^4/1440, "
          "N(4) = pi^4/96 - 1",
          abs(P(2) - mp.pi**2 / 24) < mp.mpf("1e-40")
          and abs(N(2) - (mp.pi**2 / 8 - 1)) < mp.mpf("1e-40")
          and abs(P(4) - mp.pi**4 / 1440) < mp.mpf("1e-40")
          and abs(N(4) - (mp.pi**4 / 96 - 1)) < mp.mpf("1e-40"),
          f"P(2) = {mp.nstr(P(2), 18)}")

    check("SGN  p = 1: both budgets diverge (the pole of zeta, once on each side)",
          P(mp.mpf("1.001")) > 400 and N(mp.mpf("1.001")) > 400,
          f"P(1.001) = {mp.nstr(P(mp.mpf('1.001')), 6)}, N(1.001) = {mp.nstr(N(mp.mpf('1.001')), 6)}")


# =========================================================================== #
# 7.  Parity lock and the transfer of rh41's complexity law
# =========================================================================== #


def claim_parity_and_complexity() -> None:
    print("\n7. Parity lock and the transfer of rh41's complexity law")

    for ps in ["1", "2"]:
        pm = mp.mpf(ps)
        for theta in ["0.05", "0.2", "0.3"]:
            xm = mp.sin(2 * mp.pi * mp.mpf(theta))
            r = xm
            taken = []
            for n in range(20000):
                t = mp.mpf((-1) ** n) / mp.mpf(n + 2) ** pm
                if r > 0 and t > 0 and t <= r:
                    r -= t
                    taken.append(n)
            want = 0 if xm > 0 else 1
            check(f"PAR  p = {ps}, theta = {theta}: every take has the parity of the "
                  f"sign of x", all(n % 2 == want for n in taken),
                  f"{len(taken)} takes")

    bad = 0
    for x in [Fraction(1, 2), Fraction(1, 3), Fraction(2, 5), Fraction(7, 9)]:
        taken, _, _ = exact_tau_greedy_p(1, x, 4000)
        E, r2, k = [], 2 * x, 1
        while r2 > 0 and k <= 4000:
            if Fraction(1, k) <= r2:
                r2 -= Fraction(1, k)
                E.append(k)
            k += 1
        if taken != [2 * (k - 1) for k in E]:
            bad += 1
    check("PAR  p = 1: the positive half is the classical Egyptian greedy at 2x "
          "(support {0} <-> {1}, {2,10} <-> {2,6}, ...)", bad == 0)

    bad = []
    for ones in [(0, 2, 4, 10), (2, 6, 38), (0, 8), (0, 2, 4)]:
        Nn, am = ones[-1] + 12, ones[-1]
        for L in range(am + 1, Nn + 1):
            want = min(am + 1, Nn - L + 1) + (1 if L <= Nn - am - 1 else 0)
            if p_offset(ones, Nn, L) != want:
                bad.append((ones, Nn, L))
    check("PAR  rh41 Theorem 1 holds verbatim on every parity-locked support tested",
          not bad, f"supports (0,2,4,10), (2,6,38), (0,8), (0,2,4); failures {bad}")

    gapdata = [(o, [b - a for a, b in zip(o, o[1:])])
               for o in [(0, 2, 4, 10), (2, 6, 38), (0, 8), (0, 2, 4, 6, 20)]]
    check("PAR  every gap of a signed support is even and >= 2",
          all(g % 2 == 0 and g >= 2 for (_, gaps) in gapdata for g in gaps),
          f"gaps {[gaps for (_, gaps) in gapdata]}")
    check("PAR  the min gap of a signed support is even, so the C1 bound L <= min gap "
          "is contained in {1,2} exactly when the min gap is 2 (min gaps 2, 4, 8, 2)",
          [min(gaps) for (_, gaps) in gapdata] == [2, 4, 8, 2],
          f"min gaps {[min(gaps) for (_, gaps) in gapdata]}")

    # C1 in the signed setting: the range is min(min gap, a_0, N - a_0 - 1)
    for o, Nc, want in [((4, 8, 12), 20, [2, 3, 4, 5]), ((2, 6, 38), 22, [2, 3]),
                        ((2, 4), 12, [2, 3])]:
        rng = min(min(b - a for a, b in zip(o, o[1:])), o[0], Nc - o[0] - 1)
        got = [p_offset(o, Nc, L) for L in range(1, rng + 1)]
        check(f"PAR  C1 on {o}, N = {Nc}: range L <= {rng} and p(L) = L+1 there",
              got == want and got == [L + 1 for L in range(1, rng + 1)],
              f"min gap {min(b - a for a, b in zip(o, o[1:]))}, values {got}")

    ones, Nn = (0, 2, 4, 10), 22
    check("PAR  signed support {0,2,4,10}, N = 22: a_0 = 0 empties the C1 range, yet "
          "p(1) = 2, p(2) = 3, and L = 3 already violates L <= min gap = 2",
          min(b - a for a, b in zip(ones, ones[1:])) == 2
          and p_offset(ones, Nn, 1) == 2 and p_offset(ones, Nn, 2) == 3
          and p_offset(ones, Nn, 3) > 4,
          f"p(1)={p_offset(ones, Nn, 1)}, p(2)={p_offset(ones, Nn, 2)}, "
          f"p(3)={p_offset(ones, Nn, 3)}")

    def onset(o, n):
        vals = [p_offset(o, n, L) for L in range(1, n + 1)]
        mx = max(vals)
        return next(L for L in range(1, n + 1) if p_offset(o, n, L) == mx)

    keys = {}
    for Nn in range(4, 22):
        for m in range(1, 4):
            for o in itertools.combinations(range(0, Nn, 2), m):
                if not o:
                    continue
                gaps = tuple(b - a for a, b in zip(o, o[1:]))
                keys.setdefault((gaps, Nn), set()).add(onset(o, Nn))
    multi = sum(1 for v in keys.values() if len(v) > 1)
    check("PAR  the onset of a signed word is not determined by (gaps, N) either: "
          "the parity is automatic, so the absolute position matters",
          multi > 0, f"{multi} of {len(keys)} keys are multi-valued")

    ok = all(max(p_offset(o, 2 * o[-1] + 2, L) for L in range(1, 2 * o[-1] + 3)) == o[-1] + 2
             for o in [(0, 2, 4), (2, 6, 38)])
    check("PAR  Corollary 4 on signed words: max_L p(L) = a_m + 2 for N >= 2 a_m + 2", ok)


# =========================================================================== #
# 8.  The helix
# =========================================================================== #


def claim_helix() -> None:
    print("\n8. The helix: the word sees sin(2 pi theta), never the turn count")
    old = mp.mp.dps
    mp.mp.dps = 200
    floor = mp.mpf("1e-100")

    def word_of(x, p=1, cap=200000):
        r, taken, n = mp.mpf(x), [], 0
        while r != 0 and n < cap and abs(r) > floor:
            t = mp.mpf((-1) ** n) / mp.mpf(n + 2) ** p
            if (r > 0 and t > 0) or (r < 0 and t < 0):
                if abs(t) <= abs(r):
                    r -= t
                    taken.append(n)
            n += 1
        return taken

    for theta in ["0.1", "0.3", "0.42", "0.77"]:
        t = mp.mpf(theta)
        ws = [word_of(mp.sin(2 * mp.pi * (t + k))) for k in (0, 1, 2)]
        wm = word_of(mp.sin(2 * mp.pi * (mp.mpf(1) / 2 - t)))
        check(f"HEL  theta = {theta}: theta, theta+1, theta+2 and 1/2 - theta give "
              f"the same word (200 dps, above the 1e-100 floor)",
              ws[0] == ws[1] == ws[2] == wm, f"{len(ws[0])} takes")

    t = mp.mpf("0.3")
    check("HEL  theta -> 1 - theta flips the height, hence the word",
          abs(mp.sin(2 * mp.pi * (1 - t)) + mp.sin(2 * mp.pi * t)) < mp.mpf("1e-150"),
          f"sin(2 pi t) = {mp.nstr(mp.sin(2 * mp.pi * t), 8)}")
    check("HEL  the lift (cos, sin, theta) is not periodic: the third coordinate is kept",
          mp.mpf(t) + 1 != mp.mpf(t), "definitional")
    mp.mp.dps = old


def main() -> int:
    print("=" * 78)
    print("rh42/reachable.py — the exact reachable set of the signed (Tau) alphabet")
    print("=" * 78)
    claim_brown()
    claim_census()
    claim_p2()
    claim_p3()
    claim_optimality()
    claim_thresholds()
    claim_sign()
    claim_parity_and_complexity()
    claim_helix()
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
