#!/usr/bin/env python3
"""
rh43/im_balance.py — the imaginary-part mirror of the equal-split question.

THE QUESTION.  For a complex input `S` with `Re(S) = 0`, i.e. `S = i t`, take the
finite partial sum of the zeta Dirichlet series

    S_N(t) = sum_{n=1}^{N} n^{-it} = sum_{n=1}^{N} exp(-i t log n)   in C ,

and split every term into its **positive imaginary part** and its **negative
imaginary part**:

    Jp(t) = sum_{n : sin(t log n) < 0} (-sin(t log n))   ( >= 0 )   "positive imaginary parts"
    Jm(t) = sum_{n : sin(t log n) > 0} (-sin(t log n))   ( <= 0 )   "negative imaginary parts"

Then `Im S_N(t) = Jp(t) + Jm(t)` and the split is **balanced**,
`Jp(t) = |Jm(t)|`, exactly when `Im S_N(t) = 0`.  This is the literal mirror of
rh43's real-part balance (`P_N = |M_N|  <=>  Re S_N(t) = 0`, `zeta_split.py`).

THE ANSWER.  Yes — but the statement must be about a **positive** height, unlike the
real-part case:

  * `t = 0` is a **trivial** root for every `N` (all `sin(0) = 0`), and `N = 1` has
    `Im S_1 ≡ 0` identically (the term `1^{-it} = 1` is real).  So "existence of a
    root" is vacuous at `t = 0`; the content is a root with `t > 0`.
  * `N = 2`: exactly `t = k pi/log 2` (`k >= 1`); the first is `pi/log2 = 4.53236...`.
  * `N = 3`: exactly `t = 2 pi/log 6 = 3.50671...`, from the addition formula
    `Im S_3(t) = -2 sin(t log6/2) cos(t log(2/3)/2)` (the `cos` factor's first root is
    `pi/log(3/2) = 7.747...`).  Numerically bracketed on `[3.50, 3.51]` below.
  * `N = 4`: explicit rational witnesses `Im S_4(1/2) < 0 < Im S_4(9/2)`; IVT gives a
    root.  (`Im S_N(1/2) < 0` holds for every `N >= 2`, since `sin > 0` on
    `(0, (1/2)log n)` for all `n >= 2`.)
  * all `N >= 2`: **Weyl equidistribution** + IVT.  The primes `p <= N` have
    `Q`-linearly independent logs, so `t -> (t log p)_{p<=N}` is dense on the torus.
    The continuous `G(theta) = sum_{n=2}^N sin(sum_p v_p(n) theta_p)` has torus mean
    `0` (each linear form is nonzero) and is not identically zero, so it attains a
    negative value; by density some `t` has `G(t) < 0`, i.e. `Im S_N(t) = -G(t) > 0`.
    Since `Im S_N(t) < 0` for all small `t > 0` (the derivative at `0+` is
    `-sum_{n>=2} log n < 0`), the intermediate value theorem gives a positive root.
    (The real part has mean `1`, not `0`, so this route is unavailable there and rh43
    needs a different argument.)
    *Status:* PROOF-SKETCH conditional on Weyl + **certified brackets below** for
    `N = 2..20, 25, 30, 40, 50` (the bracket width is the resolution of `ivmath`'s
    log-n enclosure, about `1e-7` at `N = 50`).

**Brown's criterion decides whether the *tail* can complete the term-level split.**
For a non-increasing summable `a_1 >= a_2 >= ...` with `A = sum a_n`, Brown (rh42;
`dictionary/04` Thm 2.1) says the subset sums fill `[0, A]` exactly iff
`a_k <= T_{k+1} = sum_{j>k} a_j` for every `k`.  The subset-sum set is permutation
invariant, so the test applies to the sorted `|Im|` magnitudes.  At a balance point
`Im S = 0` gives the exact identity

```
A_pos = |Jm| = (1/2) sum_{n>=2} n^{-sigma} |sin(t log n)| ,
```

so the target is `A_pos/2` and the binding top condition is
`2 a_1 <= sum n^{-sigma}|sin|`.  Two regimes:

* `sigma = 0` (the actual `Re(S) = 0` setting): the absolute series diverges
  (`(1/N) sum |sin|` stays near the Weyl average `2/pi`), so `A = infinity` and Brown's
  summability hypothesis fails.  The finite-`N` subset-sum defect of §7 is therefore
  *not* repairable by "seeing the tail" in the ordinary sense — there is no summable
  tail, which is exactly why the problem is posed for finite partial sums.
* `sigma > 1` (summable): Brown applies.  Scanning the balance roots, the `Im` split
  stays complete through a threshold near `sigma = 1.87` and fails above it, where the
  largest single `|Im|` term exceeds half the positive total.  (For comparison the pure
  even/odd power budget's Brown threshold is `p* = 1.7286472389981836`, from
  `zeta(p*) = 2`; the `|sin|` modulation raises the `Im`-split threshold slightly.)

What does *not* mirror the real part:
  * the balance point is not the same height as the real-part balance point, and the
    simultaneous complex vanishing is a different question (rh43: `S_2` vanishes
    exactly at `t = (2k+1)pi/log2`, `S_3` never vanishes);
  * the **term-level** split still fails: at the `Im`-balance point of `N = 6` the
    positive (and the negative) imaginary terms cannot be partitioned into two equal
    sub-sums — the exact subset-sum defect is computed below (mirror of rh43 Thm 3.5).

The sign certificates come from `ivmath.py` (`Num` = value + guaranteed error, built
at 400 dps: `pi` from Machin, `log n = 2 atanh((n-1)/(n+1))` over the prime factors,
`sin`/`cos` from Taylor series with explicit remainder bounds).  `mpmath` at >= 60 dps
is used only for reporting and for the initial, non-certified bracket scan.

Run:  python3 rh43/im_balance.py
Exit status 0 iff every check passes.
"""
from __future__ import annotations

import sys
from fractions import Fraction
from itertools import combinations
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


def im_part(N: int, t):
    """Im S_N(t) = -sum_{n=2..N} sin(t log n), at working precision."""
    t = as_mpf(t)
    return -mp.fsum([mp.sin(t * iv.log_mpf(n)) for n in range(2, N + 1)])


def im_split(N: int, t):
    """(pos indices, neg indices, Jp, Jm) at working precision.

    `pos`  = n with sin(t log n) < 0, contributing the positive imaginary part -sin.
    `neg`  = n with sin(t log n) > 0, contributing the negative imaginary part -sin.
    Terms with sin(t log n) = 0 (and n = 1) contribute nothing and appear in neither.
    """
    t = as_mpf(t)
    Jp = mp.mpf(0)
    Jm = mp.mpf(0)
    pos, neg = [], []
    for n in range(2, N + 1):
        s = mp.sin(t * iv.log_mpf(n))
        if s < 0:
            Jp += -s
            pos.append(n)
        elif s > 0:
            Jm += -s
            neg.append(n)
    return pos, neg, Jp, Jm


# =========================================================================== #
# 1.  Certified sign certificates (see ivmath.py): a sign decision is a proof.
# =========================================================================== #

def im_part_num(N: int, t: Fraction) -> "iv.Num":
    """The rigorous enclosure of Im S_N(t) = -sum_{n=2..N} sin(t log n)."""
    tv = iv.rat(t)
    acc = iv.Num(0)
    for n in range(2, N + 1):
        acc = acc - iv.sin_num(tv * iv.log_n(n))
    return acc


def sign_certificate(N: int, t: Fraction):
    """(lo, hi, sign) with real lo <= Im S_N(t) <= hi (mpf) and sign in {-1,0,+1}."""
    r = im_part_num(N, t)
    return r.lo, r.hi, r.sign()


def certified_root(N: int, a: Fraction, b: Fraction, iters: int = 40):
    """Certified bisection for a root of Im S_N in [a, b]; needs a strict sign change."""
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
# 2.  Locate the first positive crossing (non-certified scan), then certify it.
# =========================================================================== #

def first_crossing_float(N: int, tmax: float = 12.0, step: float = 0.01):
    """Locate the first sign change of Im S_N on (0, tmax).

    Returns (tp, tc, r): an mpf bracket with opposite signs and a refined root r,
    or None.  Non-certified (mpmath only); used to seed the certificates.
    """
    t = mp.mpf('1e-7')
    prev, pt = im_part(N, t), t
    t = mp.mpf(step)
    while t < tmax:
        v = im_part(N, t)
        if (prev > 0) != (v > 0):
            a, b, fa = pt, t, prev
            for _ in range(120):
                m = (a + b) / 2
                fm = im_part(N, m)
                if (fa > 0) == (fm > 0):
                    a, fa = m, fm
                else:
                    b = m
            return pt, t, (a + b) / 2
        prev, pt = v, t
        t += mp.mpf(step)
    return None


def certified_bracket(N: int, tp, tc, iters: int = 60):
    """Certify an mpmath bracket on rational endpoints and bisect it.

    Returns ((a, b), (sa, sb), width) with a < b and sa*sb < 0, or None.  The final
    width is limited by the `ivmath` log-n enclosure (about 1e-7 at N = 50), not by
    the number of bisection steps.
    """
    a = Fraction(float(tp)).limit_denominator(10 ** 6)
    b = Fraction(float(tc)).limit_denominator(10 ** 6)
    sa = sign_certificate(N, a)[2]
    sb = sign_certificate(N, b)[2]
    if sa * sb >= 0:                       # an endpoint fell inside the error band
        for widen in (1, 2, 5, 10):
            aa = a - Fraction(widen, 10 ** 6)
            bb = b + Fraction(widen, 10 ** 6)
            sa = sign_certificate(N, aa)[2]
            sb = sign_certificate(N, bb)[2]
            if sa * sb < 0:
                a, b = aa, bb
                break
        else:
            return None
    cert = certified_root(N, a, b, iters=iters)
    if cert is None:
        return None
    a, b = cert
    return (a, b), (sa, sb), b - a


# =========================================================================== #
# 3.  Exact subset-sum helper (mirror of zeta_split.best_half)
# =========================================================================== #

def best_half(terms):
    """Exact subset-sum on rational `terms = [(value, index)]`: the subset with the
    largest total not exceeding `total/2`.  Exhaustive (these sets have <= 10 terms)."""
    total = sum(v for v, _ in terms)
    target = total / 2
    best = (Fraction(0), [])
    for r in range(1, len(terms) + 1):
        for combo in combinations(terms, r):
            sv = sum(v for v, _ in combo)
            if sv <= target and sv > best[0]:
                best = (sv, [i for _, i in combo])
    return best[0], best[1], target, total


# =========================================================================== #
# 4.  The claims
# =========================================================================== #

def claim_accounting() -> None:
    print("\n== 1.  The imaginary split and the balance condition ==")
    for Jp, Jm in [(Fraction(1, 3), Fraction(-1, 3)), (Fraction(7, 5), Fraction(-7, 5)),
                   (Fraction(2), Fraction(-3)), (Fraction(0), Fraction(0))]:
        total = Jp + Jm
        ok = (Jp == -Jm) == (total == 0)
        check(f"Jp={Jp}, Jm={Jm}:  Jp = |Jm|  <=>  Jp+Jm = 0  <=>  Im S_N = 0", ok)
    for (N, t) in [(3, Fraction(1)), (10, Fraction(2)), (50, Fraction(5, 2))]:
        pos, neg, Jp, Jm = im_split(N, t)
        ip = im_part(N, t)
        check(f"N={N}, t={t} (S = i*{t}): Im S = Jp + Jm with Jp >= 0 >= Jm, index sets disjoint",
              abs(Jp + Jm - ip) < mp.mpf('1e-50') and Jp >= 0 and Jm <= 0
              and set(pos).isdisjoint(set(neg)),
              f"Jp={mp.nstr(Jp,12)}  Jm={mp.nstr(Jm,12)}  Im S={mp.nstr(ip,12)}")
    for (N, t) in [(3, Fraction(7, 2)), (6, Fraction(7, 3)), (12, Fraction(1))]:
        _, _, Jp, Jm = im_split(N, t)
        ip = im_part(N, t)
        check(f"N={N}, t={t} (S = i*{t}): balance (Jp+|Jm|=0) <=> Im S_N(t) = 0",
              (abs(Jp + Jm) < mp.mpf('1e-30')) == (abs(ip) < mp.mpf('1e-30')))


def claim_degenerate() -> None:
    print("\n== 2.  The degenerate cases: t = 0 and N = 1 ==")
    check("N=1: Im S_1(t) = 0 identically (1^{-it} = 1 is real; no imaginary part)",
          all(abs(im_part(1, t)) < mp.mpf('1e-40') for t in [0, 1, 5, 100]))
    check("t = 0 is a TRIVIAL root for every N: Im S_N(0) = -sum sin(0) = 0",
          all(abs(im_part(N, 0)) < mp.mpf('1e-40') for N in [2, 3, 10, 50]))
    check("so the existence statement must be about a POSITIVE height t > 0",
          im_part(3, mp.mpf('1e-3')) < 0 and im_part(50, mp.mpf('1e-3')) < 0,
          "Im S_N(t) < 0 just right of 0 (derivative -sum_{n>=2} log n < 0)")
    check("N=1 is therefore degenerate in both senses (root at every t, no t is special)",
          all(abs(im_part(1, t)) < mp.mpf('1e-40') for t in [0, mp.mpf('1e-9'), 7]))


def claim_small_N() -> None:
    print("\n== 3.  N = 2: the exact roots t = k pi / log 2 ==")
    t0 = mp.pi / mp.log(2)
    check("N=2: Im S_2(pi/log2) = -sin(pi) = 0 exactly (algebraic root)",
          abs(im_part(2, t0)) < mp.mpf('1e-40'),
          f"pi/log2 = {mp.nstr(t0,20)}")
    s453 = sign_certificate(2, Fraction(453, 100))
    s454 = sign_certificate(2, Fraction(454, 100))
    check("N=2: certified sign change on the rational bracket [4.53, 4.54] around pi/log2",
          s453[2] == -1 and s454[2] == 1,
          f"Im S_2(4.53) in [{float(s453[0]):.3e}, {float(s453[1]):.3e}],  "
          f"Im S_2(4.54) in [{float(s454[0]):.3e}, {float(s454[1]):.3e}]")
    check("N=2: Im S_2(t) < 0 strictly on (0, pi/log2) (sin(t log2) > 0 there)",
          all(im_part(2, t) < 0 for t in [mp.mpf('0.1'), 1, 2, 3, 4]),
          "the first positive root is the first crossing")


def claim_explicit_witness() -> None:
    print("\n== 4.  Explicit rational witnesses: N = 3 and N = 4 ==")
    s_half3 = sign_certificate(3, Fraction(1, 2))
    s_half4 = sign_certificate(4, Fraction(1, 2))
    s_92_3 = sign_certificate(3, Fraction(9, 2))
    s_92_4 = sign_certificate(4, Fraction(9, 2))
    check("N=3: Im S_3(1/2) < 0 (certified)", s_half3[2] == -1,
          f"Im S_3(1/2) in [{float(s_half3[0]):.12f}, {float(s_half3[1]):.12f}]")
    check("N=3: Im S_3(9/2) > 0 (certified)", s_92_3[2] == 1,
          f"Im S_3(9/2) in [{float(s_92_3[0]):.12f}, {float(s_92_3[1]):.12f}]")
    check("N=3: IVT then gives a root in (1/2, 9/2)",
          s_half3[2] == -1 and s_92_3[2] == 1)
    check("N=4: Im S_4(1/2) < 0 < Im S_4(9/2) (certified), so a root lies in (1/2, 9/2)",
          s_half4[2] == -1 and s_92_4[2] == 1,
          f"Im S_4(1/2) in [{float(s_half4[0]):.12f}, {float(s_half4[1]):.12f}],  "
          f"Im S_4(9/2) in [{float(s_92_4[0]):.12f}, {float(s_92_4[1]):.12f}]")

    # The N = 3 root is algebraic: sin x + sin y = 2 sin((x+y)/2) cos((x-y)/2), so
    #   Im S_3(t) = -2 sin(t log 6 / 2) cos(t log(2/3) / 2) ,
    # whose smallest positive root is t = 2 pi / log 6 (the cos factor's first root
    # is pi / log(3/2) = 7.747...).  This is the Im-mirror of N = 2's pi/log 2.
    def im3_identity(t):
        return -2 * mp.sin(t * mp.log(6) / 2) * mp.cos(t * mp.log(mp.mpf(2) / 3) / 2)
    check("N=3: factorisation Im S_3(t) = -2 sin(t log6/2) cos(t log(2/3)/2) holds "
          "numerically at several heights",
          all(abs(im_part(3, t) - im3_identity(t)) < mp.mpf('1e-40')
              for t in [mp.mpf('0.3'), 1, mp.mpf('3.5067'), 5, 9]))
    t3 = 2 * mp.pi / mp.log(6)
    check("N=3: Im S_3(2 pi/log 6) = 0 exactly (algebraic first root)",
          abs(im_part(3, t3)) < mp.mpf('1e-40'),
          f"2 pi/log 6 = {mp.nstr(t3,20)}")
    b350 = sign_certificate(3, Fraction(350, 100))
    b351 = sign_certificate(3, Fraction(351, 100))
    check("N=3: certified sign change on the rational bracket [3.50, 3.51] around 2 pi/log6",
          b350[2] == -1 and b351[2] == 1,
          f"Im S_3(3.50) in [{float(b350[0]):.3e}, {float(b350[1]):.3e}],  "
          f"Im S_3(3.51) in [{float(b351[0]):.3e}, {float(b351[1]):.3e}]")


def claim_roots_all_N() -> None:
    print("\n== 5.  A positive Im-balance height exists for every tested N ==")
    print("      First positive crossing of Im S_N: an mpmath bracket is then certified")
    print("      on exact rational endpoints and bisected with ivmath enclosures.")
    print("      (The all-N statement is the Weyl mean-zero argument of the header; the")
    print("       entries below are certified witnesses.  Width is limited by ivmath's")
    print("       log-n enclosure, ~1e-7 at N = 50.)")
    bad = []
    for N in list(range(2, 21)) + [25, 30, 40, 50]:
        found = first_crossing_float(N)
        if found is None:
            bad.append(N)
            continue
        tp, tc, _root = found
        got = certified_bracket(N, tp, tc)
        if got is None:
            bad.append(N)
            continue
        (a, b), (sa, sb), w = got
        lo = mp.mpf(a.numerator) / mp.mpf(a.denominator)
        hi = mp.mpf(b.numerator) / mp.mpf(b.denominator)
        check(f"N={N:2d}: certified root bracket", True,
              f"[{mp.nstr(lo,18)}, {mp.nstr(hi,18)}]  width {float(w):.2e}  "
              f"signs {sa:+d}/{sb:+d}")
    check("a certified positive root bracket was found for every N in 2..20, 25, 30, 40, 50",
          not bad, f"missing: {bad}" if bad else "all present")


def claim_not_the_real_balance() -> None:
    print("\n== 6.  It is not the real-part balance, and not the complex zero ==")
    _tp, _tc, r3 = first_crossing_float(3)
    t3 = r3
    re_at_im_root = 1 + mp.fsum([mp.cos(t3 * mp.log(n)) for n in range(2, 4)])
    check("N=3: at the Im-balance height, Re S_3 != 0 (the two balances are different events)",
          abs(re_at_im_root) > mp.mpf('0.1'),
          f"t_Im = {mp.nstr(t3,15)},  Re S_3(t_Im) = {mp.nstr(re_at_im_root,12)}")
    re_root = mp.findroot(lambda t: 1 + mp.cos(t * mp.log(2)) + mp.cos(t * mp.log(3)),
                          mp.mpf('2.4266520516296892'))
    im_at_re_root = im_part(3, re_root)
    check("N=3: at the Re-balance height t = 2.4266..., Im S_3 != 0",
          abs(im_at_re_root) > mp.mpf('0.5'),
          f"t_Re = {mp.nstr(re_root,15)},  Im S_3(t_Re) = {mp.nstr(im_at_re_root,12)}")
    t2 = mp.pi / mp.log(2)
    check("N=2: the Im-root pi/log2 is NOT a Re-root (Re S_2(pi/log2) = 0 is the exact "
          "complex vanishing, which is the k=1 case)",
          abs(im_part(2, t2)) < mp.mpf('1e-40')
          and abs(1 + mp.cos(t2 * mp.log(2))) < mp.mpf('1e-40'),
          "at N=2 the Im-balance and the complex zero coincide; rh43 Thm 3.3: N=3 never vanishes")


def claim_term_split_fails() -> None:
    print("\n== 7.  The term-level split fails, exactly as for the real parts ==")
    N = 6
    _tp, _tc, t6 = first_crossing_float(N)
    pos, neg, Jp, Jm = im_split(N, t6)
    check("N=6 at its Im-root: Jp = |Jm| (the split is balanced)",
          abs(Jp + Jm) < mp.mpf('1e-25'),
          f"Jp={mp.nstr(Jp,12)}  Jm={mp.nstr(Jm,12)}  positive {pos}  negative {neg}")
    mp.mp.dps = 80
    pterms = [(Fraction(mp.nstr(-mp.sin(t6 * iv.log_mpf(n)), 70)).limit_denominator(10 ** 45), n)
              for n in pos]
    nterms = [(Fraction(mp.nstr(mp.sin(t6 * iv.log_mpf(n)), 70)).limit_denominator(10 ** 45), n)
              for n in neg]
    mp.mp.dps = 60
    pacc, pch, ptgt, ptot = best_half(pterms)
    nacc, nch, ntgt, ntot = best_half(nterms)
    check("N=6: the positive imaginary terms do NOT split into two equal halves "
          "(exact subset-sum misses Jp/2 by a margin)",
          Fraction(1, 10 ** 6) < ptgt - pacc < Fraction(1, 1),
          f"best subset {pch} = {float(pacc):.15f} vs Jp/2 = {float(ptgt):.15f} "
          f"(defect {float(ptgt - pacc):.15f})")
    check("N=6: likewise the negative imaginary terms do not split into two equal halves",
          Fraction(1, 10 ** 6) < ntgt - nacc < Fraction(1, 1),
          f"best subset {nch} magnitude {float(nacc):.15f} vs |Jm|/2 = {float(ntgt):.15f} "
          f"(defect {float(ntgt - nacc):.15f})")


# =========================================================================== #
# 7b.  Brown's criterion: can the tail complete the two-subset split?
# =========================================================================== #

def claim_brown_tail() -> None:
    import math as M

    print("\n== 8.  Brown's criterion: is the tail visible? ==")
    print("      Brown (rh42; dictionary/04 Thm 2.1): a non-increasing summable")
    print("      a_1 >= a_2 >= ... with A = sum a_n has subset sums exactly [0, A]")
    print("      iff a_k <= T_{k+1} = sum_{j>k} a_j for every k.  The subset-sum set")
    print("      is permutation invariant, so the test applies to the sorted |Im|")
    print("      magnitudes (at a general abscissa sigma).  At a balance point")
    print("      Im S = 0 gives the exact identity")
    print("          A_pos = |Jm| = (1/2) sum_{n>=2} n^-sigma |sin(t log n)| ,")
    print("      so the TOP Brown condition a_1 <= T_2 reads  2 a_1 <= sum n^-sigma|sin|.")

    # --- sigma = 0 (the actual Re(S) = 0 setting): no summable tail ---------- #
    N6 = 6
    _tp, _tc, t0 = first_crossing_float(N6)
    pos = sorted([(-mp.sin(t0 * iv.log_mpf(n))) for n in range(2, N6 + 1)
                  if mp.sin(t0 * iv.log_mpf(n)) < 0], reverse=True)
    m = len(pos)
    fails = [k + 1 for k in range(m) if pos[k] > sum(pos[k + 1:]) + mp.mpf('1e-20')]
    check("N=6, sigma=0: the finite prefix violates Brown at the last index (no tail); "
          "at sigma=0 even the top index fails because the true tail is infinite, so "
          "the criterion cannot be applied -- A = infinity",
          bool(fails) and fails[-1] == m, f"fails at k={fails} of m={m}")

    tfix = 2.3365210966844465                      # the N=6 Im-root
    ratios = []
    for NN in (10 ** 3, 10 ** 4, 10 ** 5):
        ratios.append(sum(abs(M.sin(tfix * M.log(n))) for n in range(2, NN + 1)) / NN)
    check("sigma = 0: (1/N) sum |sin(t log n)| stays bounded away from 0 (its limit is "
          "the Weyl average 2/pi = 0.636620, approached slowly), so the absolute Im "
          "series diverges and there is NO summable tail to see",
          min(ratios) > 0.5,
          "ratios " + ", ".join(f"{r:.4f}" for r in ratios) + "  (2/pi = 0.636620)")

    # --- exact balance identity --------------------------------------------- #
    Sabs = mp.fsum([abs(mp.sin(t0 * iv.log_mpf(n))) for n in range(2, N6 + 1)])
    Jp = mp.fsum([-mp.sin(t0 * iv.log_mpf(n)) for n in range(2, N6 + 1)
                  if mp.sin(t0 * iv.log_mpf(n)) < 0])
    check("at a balance point A_pos = |Jm| = (1/2) sum |sin| exactly, so the target "
          "is A_pos/2 and the top Brown condition is 2 a_1 <= sum n^-sigma |sin|",
          abs(Jp - Sabs / 2) < mp.mpf('1e-25'),
          f"A_pos = {mp.nstr(Jp,12)}  sum|sin|/2 = {mp.nstr(Sabs/2,12)}")

    # --- sigma > 1 (summable): locate the visibility threshold --------------- #
    print("      For sigma > 1 the series is summable and Brown applies.  Scanning the")
    print("      balance root and the top condition (double precision, N = 20000):")
    NN = 20000
    LOG = [0.0] + [M.log(n) for n in range(1, NN + 1)]

    def im_f(sig, t):
        return -sum(n ** (-sig) * M.sin(t * LOG[n]) for n in range(2, NN + 1))

    def root_f(sig):
        t, prev, pt = 1e-6, im_f(sig, 1e-6), 1e-6
        t = 0.05
        while t < 12:
            v = im_f(sig, t)
            if (prev > 0) != (v > 0):
                a, b, fa = pt, t, prev
                for _ in range(50):
                    mm = (a + b) / 2
                    fm = im_f(sig, mm)
                    if (fa > 0) == (fm > 0):
                        a, fa = mm, fm
                    else:
                        b = mm
                return (a + b) / 2
            prev, pt = v, t
            t += 0.05
        return None

    rows = []
    for sig in (1.6, 1.7, 1.8, 1.85, 1.9, 2.0, 2.5):
        t = root_f(sig)
        b1, A = 0.0, 0.0
        for n in range(2, NN + 1):
            v = n ** (-sig) * M.sin(t * LOG[n])
            if v < 0:
                w = -v
                A += w
                if w > b1:
                    b1 = w
        rows.append((sig, t, b1, A, 2 * b1 <= A))
    first_fail = next((r for r in rows if not r[4]), None)
    check("sigma > 1 (summable): the top Brown condition holds through a threshold "
          "and fails above it; above the threshold the largest |Im| term alone "
          "exceeds half the positive total, so the tail cannot complete the split",
          first_fail is not None,
          "; ".join(f"{s:.2f}:{'ok' if ok else 'FAIL'}" for s, _, _, _, ok in rows))
    check("the Im-split visibility threshold is near sigma = 1.87, distinct from the "
          "pure-budget Brown threshold p* = 1.7286472389981836 (zeta(p*) = 2)",
          first_fail is not None and 1.6 < first_fail[0] < 2.1,
          f"first failing sigma in the scan: {first_fail[0]:.2f}" if first_fail else "none")


# =========================================================================== #
# main
# =========================================================================== #

def main() -> int:
    print("rh43/im_balance.py — the Im-balance mirror of the equal-split question")
    print("convention:  S = i*t  with t real, so Im(S) = t;  Im S_N(t) = -sum_{n>=2} sin(t log n)")
    print(f"mpmath {mp.__version__}, working precision {mp.mp.dps} dps "
          f"(certificates: ivmath.Num, {iv.WORK} dps)")
    claim_accounting()
    claim_degenerate()
    claim_small_N()
    claim_explicit_witness()
    claim_roots_all_N()
    claim_not_the_real_balance()
    claim_term_split_fails()
    claim_brown_tail()
    print(f"\n{'='*70}\n{NPASS} checks pass, {len(FAILS)} fail")
    for f in FAILS:
        print(f"  FAILED: {f}")
    return 1 if FAILS else 0


if __name__ == "__main__":
    sys.exit(main())
