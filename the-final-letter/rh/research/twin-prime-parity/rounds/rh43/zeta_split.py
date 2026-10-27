#!/usr/bin/env python3
"""
rh43/zeta_split.py — the partial sums of the zeta Dirichlet series at Re(S) = 0,
and whether they can be split into equal positive and equal negative parts.

THE QUESTION (rh43).  For a complex input `S` with `Re(S) = 0`, i.e. `S = i t`,
take a *finite partial sum* of the zeta Dirichlet series

    S_N(t) = sum_{n=1}^{N} n^{-it} = sum_{n=1}^{N} exp(-i t log n)  in C ,

split every term into its **positive real part** and its **negative real part**,

    P_N(t) = sum_{n : cos(t log n) > 0} cos(t log n)      (>= 0)   "the positive parts"
    M_N(t) = sum_{n : cos(t log n) < 0} cos(t log n)      (<= 0)   "the negative parts"

and ask whether the two can be made equal: `P_N(t) = |M_N(t)|`.  Equivalently
`Re S_N(t) = 0`, and the positive total is then *two equal positive numbers*
`P/2 + P/2` while the negative total is *two equal negative numbers* `M/2 + M/2`.
(A term with `cos(t log n) = 0` contributes neither a positive nor a negative real
part and is counted in neither set; for real `t` that never happens, since
`log n > 0` for every `n`.)

THE ANSWER.  Yes — for every `N >= 2` there is a height `t` at which the split is
balanced.  The balance condition is exactly `Re S_N(t) = 0`:

  * `N = 2` is balanced *exactly* at `t = pi/log 2`, where the two terms are `+1`
    and `-1`; the zero is tangential (no sign change), which is why a scan for a
    sign change misses it.
  * `N = 3` has the explicit witness `t = 5/2`: `Re S_3(0) = 3 > 0` while
    `Re S_3(5/2) = 1 + cos((5/2)log2) + cos((5/2)log3) < 0`, and the intermediate
    value theorem gives a root.  This is PROVED in `lean/Rh43/Balance.lean`
    (certified value `Re S_3(5/2) = -0.084335758…`).
  * `N = 4` likewise has the explicit witness `t = 12/5` (proved by the same route,
    `Re S_4(12/5) = -0.950677206…`), and certified roots are tabulated below for
    `N = 3, 4, …, 50`.

`N = 1` is the only degenerate case: `Re S_1 ≡ 1`, one positive part and no negative
part.

What is *not* possible is balance of the whole complex partial sum in general:
`N = 2` vanishes exactly at `t = (2k+1) pi/log 2`, while `N = 3` provably never
vanishes (`lean/Rh43/Balance.lean`, `zetaPartial_three_ne_zero`); `N >= 4` is open.
The balance asked in the question is the split of the *real parts*, and that one is
attained for every `N >= 2`.

The *infinite* series is not summable in the ordinary sense at `Re(S) = 0` (check
§6): `|S_N(t)|` grows **linearly**, `|S_N(t)| ~ N/sqrt(1+t^2)`, so the question is
only well posed for a finite partial sum.

Everything here is recomputed from the definition; no other script of this
workspace is imported.  The sign certificates come from `ivmath.py` (`Num`:
value + guaranteed error, built at 400 dps, with pi from Machin, `log n` from
`2 atanh((n-1)/(n+1))` over the prime factors and `cos`/`sin` from Taylor series with
explicit remainder bounds); `mpmath` at >= 60 dps is used only for reporting.

Run:  python3 rh43/zeta_split.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import sys
from fractions import Fraction
from functools import lru_cache
from pathlib import Path

import mpmath as mp

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import ivmath as iv  # noqa: E402

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
# 0.  The object
# =========================================================================== #

def as_mpf(x):
    """Convert a Fraction (or anything mpmath accepts) to an mpf exactly enough."""
    if isinstance(x, Fraction):
        return mp.mpf(x.numerator) / mp.mpf(x.denominator)
    return mp.mpf(x)



def zeta_partial(N: int, t) -> "mp.mpc":
    """S_N(t) = sum_{n=1..N} n^{-it}, at working precision."""
    t = as_mpf(t)
    return mp.fsum([mp.e ** (-1j * t * iv.log_mpf(n)) for n in range(1, N + 1)])


def real_part(N: int, t):
    """Re S_N(t) = 1 + sum_{n=2..N} cos(t log n)."""
    t = as_mpf(t)
    return 1 + mp.fsum([mp.cos(t * iv.log_mpf(n)) for n in range(2, N + 1)])


def imag_part(N: int, t):
    """Im S_N(t) = -sum_{n=2..N} sin(t log n)."""
    t = as_mpf(t)
    return -mp.fsum([mp.sin(t * iv.log_mpf(n)) for n in range(2, N + 1)])


def split_parts(N: int, t):
    """(positive indices, negative indices, P_N(t), M_N(t)) at working precision."""
    t = as_mpf(t)
    P = mp.mpf(0)
    M = mp.mpf(0)
    pos, neg = [], []
    for n in range(1, N + 1):
        c = mp.cos(t * iv.log_mpf(n))
        if c > 0:
            P += c
            pos.append(n)
        elif c < 0:
            M += c
            neg.append(n)
    return pos, neg, P, M


# =========================================================================== #
# 1.  Certified sign certificates (see `ivmath.py`).
#
#     `ivmath.Num` carries a rigorous enclosure [v - e, v + e]: pi from Machin,
#     log n = 2 atanh((n-1)/(n+1)) over the prime factors, cos/sin from Taylor series
#     with explicit remainder bounds.  Every sign decision below is therefore a proof.
# =========================================================================== #


def real_part_num(N: int, t: Fraction):
    """The rigorous enclosure of Re S_N(t) = 1 + sum_{n=2..N} cos(t log n)."""
    acc = iv.Num(1)
    tv = iv.rat(t)
    for n in range(2, N + 1):
        acc = acc + iv.cos_num(tv * iv.log_n(n))
    return acc


def sign_certificate(N: int, t: Fraction):
    """(lo, hi, sign) with real lo <= Re S_N(t) <= hi (mpf) and sign in {-1,0,+1}."""
    r = real_part_num(N, t)
    return r.lo, r.hi, r.sign()


def certified_root(N: int, a: Fraction, b: Fraction, iters: int = 45):
    """Certified bisection for a root of Re S_N in [a, b]; needs a sign change."""
    sa = sign_certificate(N, a)[2]
    sb = sign_certificate(N, b)[2]
    if sa == 0 or sb == 0 or sa == sb:
        return None
    for _ in range(iters):
        m = (a + b) / 2
        sm = sign_certificate(N, m)[2]
        if sm == 0:
            break
        if sm == sa:
            a = m
        else:
            b = m
    return a, b


# =========================================================================== #
# 2.  The accounting: split, balance, and the two readings
# =========================================================================== #


def claim_accounting() -> None:
    print("\n== 1.  The split and the balance condition ==")
    for P, M in [(Fraction(1, 3), Fraction(-1, 3)), (Fraction(7, 5), Fraction(-7, 5)),
                 (Fraction(2), Fraction(-3)), (Fraction(0), Fraction(0))]:
        total = P + M
        ok = (P == -M) == (total == 0)
        ok = ok and (P / 2 + P / 2 + M / 2 + M / 2) == total
        check(f"P={P}, M={M}:  P = -M  <=>  P+M = 0  <=>  (P/2 + P/2) + (M/2 + M/2), equal in pairs",
              ok)
    for (N, t) in [(3, Fraction(1)), (10, Fraction(2)), (50, Fraction(5, 2))]:
        pos, neg, P, M = split_parts(N, t)
        rp = real_part(N, t)
        check(f"N={N}, t={t} (S = i*{t}): Re S = P + M with P >= 0 >= M",
              abs(P + M - rp) < mp.mpf('1e-50') and P >= 0 and M <= 0,
              f"P={mp.nstr(P,12)}  M={mp.nstr(M,12)}  Re S={mp.nstr(rp,12)}")
        rest = [n for n in range(1, N + 1) if n not in pos and n not in neg]
        check(f"N={N}, t={t} (S = i*{t}): positive/negative index sets disjoint, rest has cos = 0",
              set(pos).isdisjoint(set(neg)) and
              all(abs(mp.cos(as_mpf(t) * iv.log_mpf(n))) < mp.mpf('1e-50') for n in rest))
    for (N, t) in [(3, Fraction(5, 2)), (4, Fraction(12, 5)), (12, Fraction(1))]:
        _, _, P, M = split_parts(N, t)
        rp = real_part(N, t)
        check(f"N={N}, t={t} (S = i*{t}): balance (P+|M|=0) <=> Re S_N(t) = 0",
              (abs(P + M) < mp.mpf('1e-30')) == (abs(rp) < mp.mpf('1e-30')))


# =========================================================================== #
# 3.  The small cases N = 1, 2
# =========================================================================== #


def claim_small_N() -> None:
    print("\n== 2.  N = 1 and N = 2 ==")
    check("N=1: Re S_1(t) = 1 for every t (no negative part, never balanced)",
          all(abs(real_part(1, t) - 1) < mp.mpf('1e-40') for t in [0, 1, 5, 100]))
    t0 = mp.pi / mp.log(2)
    check("N=2: Re S_2(pi/log2) = 1 + cos(pi) = 0 exactly",
          abs(real_part(2, t0)) < mp.mpf('1e-40'),
          f"S = i*(pi/log2), t0 = {mp.nstr(t0,20)}")
    pos, neg, P, M = split_parts(2, t0)
    check("N=2 at t = pi/log2: positive set {1}, negative set {2}, P = 1, M = -1 (balanced)",
          pos == [1] and neg == [2] and abs(P - 1) < mp.mpf('1e-30') and abs(M + 1) < mp.mpf('1e-30'),
          f"P={mp.nstr(P,12)}  M={mp.nstr(M,12)}")
    check("N=2: Re S_2(t) > 0 strictly for 0 <= t < pi/log2 (tangential zero)",
          all(real_part(2, t) > 0 for t in [0, mp.mpf('0.5'), 1, 2, 3, 4]))
    check("N=2 is therefore BALANCED at t = pi/log2 (both parts non-degenerate)",
          pos == [1] and neg == [2])


# =========================================================================== #
# 4.  The explicit witness N = 3 (and the Lean witnesses)
# =========================================================================== #


def claim_witness_N3() -> None:
    print("\n== 3.  The explicit witness: N = 3 ==")
    f = lambda t: 1 + mp.cos(t * mp.log(2)) + mp.cos(t * mp.log(3))
    t_root = mp.findroot(f, mp.mpf('2.4266520516296892'))
    check("N=3: root of 1 + cos(t log2) + cos(t log3)",
          abs(f(t_root)) < mp.mpf('1e-50'), f"t = {mp.nstr(t_root,30)}")
    a, b = Fraction(242, 100), Fraction(243, 100)
    sa = sign_certificate(3, a)
    sb = sign_certificate(3, b)
    check("N=3: certified sign change on [2.42, 2.43] (exact Fraction enclosure)",
          sa[2] == 1 and sb[2] == -1,
          f"Re S_3(2.42) in [{float(sa[0]):.3e}, {float(sa[1]):.3e}],  "
          f"Re S_3(2.43) in [{float(sb[0]):.3e}, {float(sb[1]):.3e}]")
    root = certified_root(3, a, b, iters=45)
    check("N=3: certified root bracket", root is not None,
          f"[{float(root[0]):.15f}, {float(root[1]):.15f}]  width {float(root[1]-root[0]):.2e}"
          if root else "none")
    s0 = sign_certificate(3, Fraction(0))
    s52 = sign_certificate(3, Fraction(5, 2))
    check("N=3: Re S_3(0) = 3 > 0 (certified)", s0[2] == 1,
          f"[{float(s0[0]):.6f}, {float(s0[1]):.6f}]")
    check("N=3: Re S_3(5/2) < 0 (certified rational witness; this is the Lean proof's input)",
          s52[2] == -1, f"Re S_3(5/2) in [{float(s52[0]):.12f}, {float(s52[1]):.12f}]")
    check("N=3: IVT then gives a root in (0, 5/2)", s0[2] == 1 and s52[2] == -1)
    pos, neg, P, M = split_parts(3, t_root)
    check("N=3 at the root: P = |M| (balanced split), positive set {1}, negative set {2,3}",
          abs(P + M) < mp.mpf('1e-40') and pos == [1] and neg == [2, 3],
          f"P={mp.nstr(P,15)}  M={mp.nstr(M,15)}")
    check("N=3 at the root: P/2 + P/2 = P and M/2 + M/2 = M (two equal positive, two equal negative)",
          abs(P / 2 + P / 2 - P) < mp.mpf('1e-40') and abs(M / 2 + M / 2 - M) < mp.mpf('1e-40'))
    s125 = sign_certificate(4, Fraction(12, 5))
    check("N=4: Re S_4(12/5) < 0 (second Lean witness)", s125[2] == -1,
          f"Re S_4(12/5) in [{float(s125[0]):.12f}, {float(s125[1]):.12f}]")
    check("N=4: Re S_4(0) = 4 > 0, so IVT gives a root in (0, 12/5)",
          sign_certificate(4, Fraction(0))[2] == 1)


# =========================================================================== #
# 5.  A certified root for every tested N >= 3
# =========================================================================== #


def scan_bracket(N: int, tmax=mp.mpf(20), step=mp.mpf('0.004')):
    prev = None
    pt = None
    t = step
    while t < tmax:
        cur = real_part(N, t)
        if prev is not None and (prev > 0) != (cur > 0):
            return (Fraction(float(pt)).limit_denominator(10 ** 6),
                    Fraction(float(t)).limit_denominator(10 ** 6))
        prev, pt = cur, t
        t += step
    return None


def claim_roots_all_N() -> None:
    print("\n== 4.  A balanced partial sum exists for every N = 3, ..., 50 ==")
    print("      Re S_N(0) = N > 0; for each N a sign change is bracketed with exact")
    print("      enclosures and then bisected (the general existence is Theorem 3 of")
    print("      truths.md; the certificates below are for the listed N).")
    bad = []
    for N in list(range(3, 21)) + [25, 30, 40, 50]:
        br = scan_bracket(N)
        if br is None:
            bad.append(N)
            continue
        cert = certified_root(N, br[0], br[1], iters=60)
        if cert is None:
            bad.append(N)
            continue
        lo, hi = cert
        check(f"N={N:2d}: certified root bracket", True,
              f"[{float(lo):.15f}, {float(hi):.15f}]  width {float(hi-lo):.2e}")
    check("a certified root bracket was found for every N in 3..20, 25, 30, 40, 50",
          not bad, f"missing: {bad}" if bad else "all present")


# =========================================================================== #
# 6.  The four-part split
# =========================================================================== #


def best_half(terms):
    """Exact subset-sum on rational `terms = [(value, index)]`: the subset with the
    largest total not exceeding `total/2`.  Exhaustive (these sets have <= 7 terms)."""
    from itertools import combinations
    total = sum(v for v, _ in terms)
    target = total / 2
    best = (Fraction(0), [])
    for r in range(1, len(terms) + 1):
        for combo in combinations(terms, r):
            sv = sum(v for v, _ in combo)
            if sv <= target and sv > best[0]:
                best = (sv, [i for _, i in combo])
    return best[0], best[1], target, total


def claim_four_part_split() -> None:
    print("\n== 5.  Two equal positive parts and two equal negative parts, concretely ==")
    f = lambda t: 1 + mp.cos(t * mp.log(2)) + mp.cos(t * mp.log(3))
    t_root = mp.findroot(f, mp.mpf('2.4266520516296892'))
    pos, neg, P, M = split_parts(3, t_root)
    check("N=3 at the root: positive {1}, negative {2,3}; P/2 = |M|/2 = 0.5 (balance)",
          pos == [1] and neg == [2, 3] and abs(P / 2 - abs(M) / 2) < mp.mpf('1e-40'),
          f"P = {mp.nstr(P,12)}, M = {mp.nstr(M,12)}")
    check("N=3: the balance gives two equal positive and two equal negative NUMBERS "
          "(P/2, P/2, M/2, M/2); the positive side has a single term, so no "
          "TWO-SUBSET split of the terms exists",
          len(pos) == 1)
    # N = 6: the terms themselves, and whether they split two-and-two.
    N = 6
    br = scan_bracket(N)
    t6 = mp.findroot(lambda t: real_part(N, t), mp.mpf(float((br[0] + br[1]) / 2)))
    pos, neg, P, M = split_parts(N, t6)
    check("N=6 at its root: P = |M| (the split is balanced)", abs(P + M) < mp.mpf('1e-30'),
          f"P={mp.nstr(P,12)}  M={mp.nstr(M,12)}  positive {pos}  negative {neg}")
    mp.mp.dps = 80
    pterms = [(Fraction(mp.nstr(mp.cos(t6 * iv.log_mpf(n)), 70)).limit_denominator(10**45), n)
              for n in pos]
    nterms = [(Fraction(mp.nstr(-mp.cos(t6 * iv.log_mpf(n)), 70)).limit_denominator(10**45), n)
              for n in neg]
    mp.mp.dps = 60
    pacc, pch, ptgt, ptot = best_half(pterms)
    nacc, nch, ntgt, ntot = best_half(nterms)
    check("N=6: the positive terms do NOT split into two equal halves "
          "(the exact subset-sum misses P/2 by a rigorous margin)",
          Fraction(1, 10**6) < ptgt - pacc < Fraction(1, 1),
          f"best subset {pch} = {float(pacc):.15f} vs P/2 = {float(ptgt):.15f} "
          f"(defect {float(ptgt-pacc):.15f})")
    check("N=6: likewise the negative terms do not split into two equal halves",
          Fraction(1, 10**6) < ntgt - nacc < Fraction(1, 1),
          f"best subset {nch} magnitude {float(nacc):.15f} vs |M|/2 = {float(ntgt):.15f} "
          f"(defect {float(ntgt-nacc):.15f})")
    # the defect is exactly the term cos(t log 1) = 1 on the positive side here
    check("N=6: the positive defect is caused by the first term cos(t log 1) = 1 "
          "(larger than the rest of the positive side)",
          pterms[0][0] == 1 and pterms[0][0] > ptot - pterms[0][0])


# =========================================================================== #
# 7.  No exact complex vanishing, and no ordinary summability
# =========================================================================== #


def claim_complex_zero_and_divergence() -> None:
    print("\n== 6.  The complex partial sum: N = 2 vanishes, N = 3 does not; divergence ==")
    # N = 2 vanishes exactly at t = (2k+1) pi / log 2
    t0 = mp.pi / mp.log(2)
    check("N=2: zeta_partial(2, pi/log2) = 1 + exp(-i pi) = 0 (exact vanishing)",
          abs(zeta_partial(2, t0)) < mp.mpf('1e-45'),
          f"|S_2| = {mp.nstr(abs(zeta_partial(2,t0)),6)}")
    # N = 3 has no exact zero (proved in Lean); report certified-style grid minima.
    for N in [3, 4, 5, 6]:
        best = (mp.inf, None)
        t = mp.mpf('0.01')
        while t < 15:
            v = abs(zeta_partial(N, t))
            if v < best[0]:
                best = (v, t)
            t += mp.mpf('0.01')
        check(f"N={N}: no complex zero on the coarse grid (min |S_N| > 0; not a lower bound)",
              best[0] > mp.mpf('1e-6'),
              f"min |S_N| = {mp.nstr(best[0],6)} at t = {mp.nstr(best[1],6)}")
    # linear divergence: |S_N| ~ N/sqrt(1+t^2)
    for t in ['1', '14.134725141734693']:
        tt = mp.mpf(t)
        vals = [(10 ** k, abs(zeta_partial(10 ** k, tt))) for k in [2, 3, 4]]
        expo = mp.log(vals[-1][1] / vals[0][1]) / mp.log(vals[-1][0] / vals[0][0])
        pred = 1 / mp.sqrt(1 + tt * tt)
        ratio = vals[-1][1] / vals[-1][0]
        check(f"t={t}: |S_N| grows LINEARLY in N (log-log exponent ~ 1); ratio |S_N|/N bounded, "
              f"limit 1/sqrt(1+t^2) = {mp.nstr(pred,6)}",
              expo > mp.mpf('0.85') and ratio < pred + mp.mpf('0.6') and vals[-1][1] > 3 * vals[0][1],
              f"|S_1e2|={mp.nstr(vals[0][1],6)}  |S_1e4|={mp.nstr(vals[-1][1],6)}  exponent={mp.nstr(expo,4)}  "
              f"|S_1e4|/1e4={mp.nstr(ratio,6)} (the O(1/N) Euler term still inflates the deficit)")


# =========================================================================== #
# main
# =========================================================================== #


def main() -> int:
    print("rh43/zeta_split.py — partial sums of zeta at Re(S) = 0: the equal-split question")
    print("convention throughout:  S = i*t  with t real, so Im(S) = t;  the log prints "
          "t as 't=...'")
    print(f"mpmath {mp.__version__}, working precision {mp.mp.dps} dps (certificates: exact Fraction intervals)")
    claim_accounting()
    claim_small_N()
    claim_witness_N3()
    claim_roots_all_N()
    claim_four_part_split()
    claim_complex_zero_and_divergence()
    print(f"\n{'='*70}\n{NPASS} checks pass, {len(FAILS)} fail")
    for f in FAILS:
        print(f"  FAILED: {f}")
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
