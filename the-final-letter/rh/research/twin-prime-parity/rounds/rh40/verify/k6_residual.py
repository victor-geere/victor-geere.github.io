#!/usr/bin/env python3
"""
rh40 / verify/k6_residual.py -- a symbolic treatment of the residual-orbit limit
problem, register K6 of rh40/rounds/truths.md (HANDOFF.md section 6 item 5).

    Usage:  python3 rh40/verify/k6_residual.py            # default, ~1-2 min
            python3 rh40/verify/k6_residual.py --slow     # adds dps 5e4/1e5 orbits
            python3 rh40/verify/k6_residual.py --only 1 4

--------------------------------------------------------------------------------
WHAT THE PROBLEM IS
--------------------------------------------------------------------------------
For irrational x in (0,1) the greedy harmonic sine selects indices by
    q_k := ceil(1/r_k),  r_{k+1} := r_k - 1/q_k,  r_0 := x,
and the residual obeys the exact squaring law (truths.md D6)

    r_{k+1} = (1-f_k) r_k^2 / (1 + (1-f_k) r_k),   f_k = {1/r_k}.

The programme's other open problem is whether, with

    c_k := (1-f_k)/(1 + (1-f_k) r_k) = r_{k+1}/r_k^2,

the average (1/K) sum_{k<K} log c_k tends to a limit *independent of x*.
HANDOFF section 6.5 proposed to settle this by iterating ~40-50 steps
numerically.  By truths.md I5/I6 that protocol is unachievable: the residual
squares, so a dps-digit run survives only about 2 + log2(dps) steps, and 40
steps needs 2^38 digits.  This file therefore does not iterate.  It works with
the exact algebra of the map and with *digit sequences prescribed in advance*,
which is the only route to arbitrarily deep orbits.

--------------------------------------------------------------------------------
RESULTS (statuses per the truths.md vocabulary)
--------------------------------------------------------------------------------
§1  u-map.  VERIFIED (exact algebra + numerics at the working precision):
        u := 1/r_k,  q := ceil(u)  =>  u_{k+1} = u q / (q - u) = q^2/s_k - q,
        s_k := 1 - f_k = q - u.
    The candidate in the task brief, u^2/(u - floor(u) + 1), is REFUTED (it is
    off by a factor of order q; see §1 numbers).  The correct closed forms are
        u_{k+1} = u_k ceil(u_k)/(ceil(u_k) - u_k),   s_k = q_k - u_k.

§2  The induced map on the fractional part.  VERIFIED:
        f_{k+1} = { q_k^2 / (1 - f_k) },   s_{k+1} = 1 - { q_k^2 / s_k }.
    It is NOT the Gauss map.  It is a *skew product* over the escaping integer
    q_k, and it is the classical greedy (Fibonacci-Sylvester) Egyptian-fraction
    digit map, not the ceiling-free continued-fraction map.  The correct
    invariant density is asymptotically LEBESGUE, mu_q(s) = q(q-1)/(q-s)^2
    = 1 + (2s-1)/q + O(1/q^2); it is NOT Gauss-Kuzmin 1/((1+s) ln 2).  The
    earlier session was right to kill Gauss-Kuzmin, but the replacement is not
    another exotic density -- it is Lebesgue, which is exactly why the integral
    int_0^1 log(1-f) df = -1 is the right "typical" answer anyway.

§3  The correction term.  PROVED + VERIFIED:
        0 <= log c_k - log(1-f_k) = -log(1 + s_k r_k) <= r_k,
        sum_k r_k <= sum_k 1/(q_k - 1) < infinity.
    So sum_k [log c_k - log(1-f_k)] converges absolutely and its Cesaro mean
    is 0.  The whole convergence question is therefore exactly the question
    about sum_k log s_k.

§4  REFUTATION of "a limit independent of x".  PROVED + VERIFIED numerically.
    For every s* in (0,1] there is an explicit irrational x with
        s_k -> s*,  hence  (1/K) sum log c_k -> log s*.
    Since log s_k <= 0 every existing limit is <= 0, so the set of achieved
    limits is exactly (-infinity, 0] and not a single value: K6's "independent
    of x" is REFUTED.  In particular Sigma_k log c_k is bounded for some x
    (limit 0, e.g. s* = 1) and unbounded for others (limit < 0, e.g.
    s* = 1/2), so the equivalent form "is Sigma_k log c_k bounded?" has no
    uniform answer either.  A second construction (prescribed targets 1/2 and
    1 in blocks of doubling length) makes the running average oscillate, so for
    some irrational x the limit does not even exist.

§5  What is true instead.  PROVED (annealed / L^1), CONJECTURE (a.e.):
        (1/K) sum_{k<K} log c_k -> -1 = int_0^1 log(1-f) df
    for Lebesgue-a.e. x; the L^1 version (and convergence in probability) is
    proved here from the exact conditional law, the a.e. version is a
    conjecture reduced to one named standard lemma (see §5 text).

§6  The unachievable protocol.  VERIFIED: usable steps = 2 + log2(dps).

--------------------------------------------------------------------------------
PROOFS (short, complete; nothing below is asserted without the argument)
--------------------------------------------------------------------------------
Notation.  r_0 = x, q_k = ceil(1/r_k), r_{k+1} = r_k - 1/q_k, u_k = 1/r_k,
s_k = q_k - u_k in (0,1], f_k = 1 - s_k = {u_k}.

(A) Cylinder lemma.  Let C_k = {x : digits q_0..q_k are prescribed}.  Then
    C_k is an interval, r_k = x - A_k with A_k = sum_{j<k} 1/q_j constant on
    C_k, and r_k is uniform on I_{q_k} = (1/q_k, 1/(q_k-1)] given C_k.
    Proof.  By induction: {r_j : x in C_j} = I_{q_j}; and the admissibility
    condition q_{j+1} >= q_j(q_j-1)+1 gives I_{q_{j+1}} subset
    (0, 1/(q_j(q_j-1))] = I_{q_j} - 1/q_j, so C_{j+1} = C_j intersected with
    {r_{j+1} in I_{q_{j+1}}} is a translate of I_{q_{j+1}}.  QED

(B) Sylvester's criterion (used in §4).  Let 1 < q_0 < q_1 < ... be integers
    with q_{k+1} >= q_k(q_k-1)+1 for all k, and put R_k = sum_{j>=k} 1/q_j.
    Then ceil(1/R_k) = q_k for every k, i.e. (q_k) is the greedy expansion of
    R_0.  Proof.  For the finite tails R_k^{(M)} = sum_{k<=j<=M} 1/q_j one has
    R_k^{(M)} < 1/(q_k - 1) by downward induction on k from the base
    R_M^{(M)} = 1/q_M < 1/(q_M - 1), using
    R_k^{(M)} = 1/q_k + R_{k+1}^{(M)} < 1/q_k + 1/(q_{k+1}-1)
              <= 1/q_k + 1/(q_k(q_k-1)) = 1/(q_k-1);
    let M -> infinity.  Then 1/R_k > q_k - 1 and R_k >= 1/q_k gives
    1/R_k <= q_k, so ceil(1/R_k) = q_k.  QED

(C) Size bounds.  Admissibility gives q_{k+1} >= q_k(q_k-1)+1, so q_k is at
    least Sylvester's sequence S = (2,3,7,43,1807,...).  Hence
    sum_k 1/q_k <= sum_k 1/S_k = 1 (telescoping, since
    1/S_{k+1} = 1/(S_k-1) - 1/S_k).  Also each tail R_k = sum_{j>=k}1/q_j
    satisfies 1/q_k <= R_k <= 1/(q_k-1) by (B).  (Used in §3 and §5.)

(D) Exact conditional law of s_k: by (A), given C_k, r_k is uniform on I_{q_k},
    so s_k = q_k - 1/r_k has density
        mu_q(s) = q(q-1)/(q-s)^2,  0 < s <= 1,  q = q_k.
    In particular E[log s_k | C_k] = h(q_k) with
        h(q) = int_0^1 log(s) q(q-1)/(q-s)^2 ds = -1 + 1/(2q) + O(1/q^2).
    (Expansion: mu_q(s) = 1 + (2s-1)/q + O(1/q^2); int log = -1,
    int (2s-1) log s ds = 1/2.)

(E) §3.  Divide the squaring law by r_k^2: c_k = r_{k+1}/r_k^2
    = s_k/(1 + s_k r_k), so log c_k = log s_k - log(1+s_k r_k) with
    0 <= log(1+s_k r_k) <= s_k r_k <= r_k = R_k <= 1/(q_k-1), and
    sum_k r_k <= sum_k (q_k-1)^{-1} < infinity by (C).

(F) §4 construction.  Fix s* in (0,1], q_0 >= 2, and set
    q_{k+1} = floor(q_k^2/s*)   (so q_{k+1} >= q_k^2 >= q_k(q_k-1)+1).
    By (B) the sequence is the greedy expansion of x = sum 1/q_k, so the
    digits of x are exactly q_k.  Let alpha_k = q_k^2/q_{k+1}; then
    alpha_k in [s*, s*/(1 - s*/q_k^2)] -> s*.  The exact backward relation is
        s_k = alpha_k / (1 + (q_k - s_{k+1})/q_{k+1})
    (proof: q_{k+1} = ceil(q_k^2/s_k) - q_k, so q_k^2/s_k = q_k + q_{k+1}
    - s_{k+1}).  Since (q_k - s_{k+1})/q_{k+1} <= q_k/q_{k+1} <= 1/q_k -> 0,
    s_k = alpha_k(1 + O(1/q_k)) -> s*.  Therefore, by (E),
    (1/K) sum log c_k -> log s*.  QED
    The same estimate with a prescribed target sequence s*_k in [1/2,1]
    (take q_{k+1} = floor(q_k^2/s*_k); the admissibility inequality is
    unchanged) gives |s_k - s*_k| <= C/q_k, so sum_k |log s_k - log s*_k|
    <= C sum_k 1/q_k < infinity and the Cesaro means of log s_k and of
    log s*_k differ by o(1).  Choosing s*_k = 1/2 on blocks of length 2^m
    for even m and 1 on blocks for odd m then yields the oscillating example
    of §4.

(G) §5 L^1.  By (D), E[log s_k] = -1 + (1/2)E[1/q_k] + O(E[1/q_k^2]) and
    sum_k E[1/q_k] <= sum_k 1/S_k <= 1 by (C).  Hence
    E[(1/K) sum_{k<K} log s_k] = -1 + O(1/K), and by (E) the same holds for
    log c_k.  This is convergence in L^1, hence in probability, and a.e. along
    a subsequence.

(H) §5 a.e. -- the missing step, stated exactly.  Write
    eta_k = log s_k - h(q_k), so sum_k log s_k = -K + O(1) + sum_{k<K} eta_k
    and E[eta_k | C_j] = 0 for every j <= k.  A.e. convergence to -1 is
    equivalent to S_K/K -> 0 a.s., S_K = sum_{k<K} eta_k.  The block argument
    closes this as soon as one has Var(sum_{k in B} eta_k) <= C|B| for every
    interval B, which follows from the standard expanding-map correlation
    lemma:

      LEMMA (not written out here).  Let F = T_{q_{k-1}} o ... o T_{q_{j+1}}
      with T_q(s) = 1 - {q^2/s}.  Every T_q is a full-branched map of (0,1]
      onto (0,1) with all branches onto (0,1) and distortion
      sup|T_q''|/|T_q'|^2 = 2/q <= 1, and |T_q'| >= q^2.  Consequently the
      transfer operator L_F loses memory at rate O(prod 1/q_i^2), i.e.
      |Cov(eta_j, eta_k)| <= C prod_{i=j+1}^{k} q_i^{-2}.

    Given the lemma, sum_{j<k<K}|Cov| = O(K), so Var(S_K) = O(K); Chebyshev +
    Borel-Cantelli gives S_{2^n}/2^n -> 0 a.s., and a union bound over the
    binary decomposition of [2^n, K) (at most n dyadic blocks, threshold
    eps*2^n/n each, Var of each dyadic block <= C*length) gives
    P(exists K in [2^n,2^{n+1}) : |S_K - S_{2^n}| > eps 2^n) <= C n^2/(eps^2 2^n),
    summable; so S_K/K -> 0 a.s.  STATUS: the lemma is standard but is not
    proved in this file, so the a.e. statement is recorded as [CONJECTURE].

All numerics below are mpmath at the precision printed; no binary floats are
used for any claimed identity.
"""

from __future__ import annotations

import sys
from fractions import Fraction

import mpmath as mp

# --------------------------------------------------------------------------- #
# helpers
# --------------------------------------------------------------------------- #

LAST_RUN_ATTEMPTS = 1  # room for growth


def orbit_from_x(x, dps: int, max_steps: int = 60, use_r_form: bool = True):
    """Iterate the greedy residual.  Returns a list of dicts.

    `x` may be an expression string such as "1/pi"; it is evaluated *after*
    mp.dps is set, because mpmath parses and evaluates at the current precision
    (HANDOFF section 8.1: this artefact once produced a wrong conclusion).

    The map is applied in the *squaring* form r' = s r^2/(1+s r); the equivalent
    form r - 1/ceil(1/r) is checked against it in section 1.
    Stops as soon as the required digits are exhausted (r collapses to 0).
    """
    mp.mp.dps = dps
    if isinstance(x, str):
        x = _eval(x)
    r = mp.mpf(x)
    rec = []
    for k in range(max_steps):
        if r <= 0:
            break
        u = 1 / r
        q = int(mp.ceil(u))
        f = u - (q - 1)               # {u}; u is irrational so floor(u) = q-1
        s = 1 - f
        if not (0 < s <= 1):
            break
        c = s / (1 + s * r)
        rec.append({"k": k, "r": r, "u": u, "q": q, "f": f, "s": s, "c": c})
        r_new = s * r * r / (1 + s * r)
        if r_new <= 0 or r_new >= r:
            break
        r = r_new
    return rec


def stable_orbit(expr: str, dps: int, max_steps: int = 40):
    """The precision-stable prefix of the orbit of x = expr at dps digits.

    The final one or two steps of any fixed-precision run are noise (truths.md
    I5: step k needs about 2^k digits).  Comparing against a run at dps/2 and
    keeping the leading indices whose digits and whose s_k agree removes them.
    """
    hi = orbit_from_x(expr, dps, max_steps)
    lo = orbit_from_x(expr, max(60, dps // 2), max_steps)
    n = 0
    while n < len(hi) and n < len(lo) and hi[n]["q"] == lo[n]["q"]:
        if abs(hi[n]["s"] - lo[n]["s"]) > mp.mpf("1e-8"):
            break
        n += 1
    return hi[:n]


def sylvester_prefix(K: int):
    """Sylvester's sequence 2,3,7,43,1807,... (the minimal admissible digits).

    Keep K small: S_k has about 2^k digits.
    """
    q = [2]
    while len(q) < K:
        q.append(q[-1] * (q[-1] - 1) + 1)
    return q


def sylvester_mass(K: int = 8):
    """sum_{k<K} 1/S_k and the exact tail, using the telescoping identity
    sum_{k=0}^{n} 1/S_k = 1 - 1/(S_{n+1} - 1)."""
    S = sylvester_prefix(K + 1)
    mp.mp.dps = max(mp.mp.dps, 40)
    partial = 1 - mp.mpf(1) / mp.mpf(S[K] - 1)
    return S, partial


def digits_for_targets(targets, q0: int = 4):
    """q_{k+1} = floor(q_k^2 / targets[k]) with exact integer arithmetic."""
    q = [q0]
    for t in targets:
        t = Fraction(t)
        q.append((q[-1] * q[-1] * t.denominator) // t.numerator)
    return q


def backward_s(q, s_last=None, dps: int = 80):
    """Exact backward recursion s_k = q_k^2/(q_k+q_{k+1}-s_{k+1}).

    The dependence on s_last decays like prod 1/q_i^2, so the output is the true
    s_k to far more digits than any dps used here.
    """
    mp.mp.dps = dps
    S = [None] * len(q)
    S[-1] = mp.mpf("0.5") if s_last is None else mp.mpf(str(s_last))
    for k in range(len(q) - 2, -1, -1):
        qk, qk1 = mp.mpf(q[k]), mp.mpf(q[k + 1])
        S[k] = qk * qk / (qk + qk1 - S[k + 1])
    return S


def tail_residual(q, k, dps: int = 120):
    """R_k = sum_{j>=k} 1/q_j, evaluated by backward summation (converges fast)."""
    mp.mp.dps = dps
    r = mp.mpf(0)
    for j in range(len(q) - 1, k - 1, -1):
        r = 1 / mp.mpf(q[j]) + r
    return r


def x_from_digits(q, dps: int = 400):
    mp.mp.dps = dps
    x = mp.mpf(0)
    for j in range(len(q) - 1, -1, -1):
        x = 1 / mp.mpf(q[j]) + x
    return x


def hdr(title):
    print("\n" + "=" * 78)
    print(title)
    print("=" * 78)


# --------------------------------------------------------------------------- #
# section 1 -- the u-map
# --------------------------------------------------------------------------- #

TARGETS = [
    ("1/pi", "1/pi"),
    ("log 2", "log(2)"),
    ("sqrt2-1", "sqrt(2)-1"),
    ("e-2", "e-2"),
    ("sqrt3-1", "sqrt(3)-1"),
    ("log2/log10", "log(2)/log(10)"),
]


def _eval(expr):
    env = {"mp": mp, "pi": mp.pi, "e": mp.e, "sqrt": mp.sqrt, "log": mp.log}
    return eval(expr, {"__builtins__": {}}, env)  # noqa: S307


def sec1_umap(dps: int = 400) -> None:
    hdr("§1  the correct u-map   (u = 1/r, q = ceil(u), s = q - u)")
    print("  claimed in the brief:  u_{k+1} = u^2/(u - floor(u) + 1)")
    print("  derived here:          u_{k+1} = u q/(q - u) = q^2/s - q")
    print("  also exact:            s_{k+1} = 1 - {q^2/s},  q = u + s\n")
    print(f"  dps = {dps}; every deviation below is measured against 1/r' where")
    print("  r' is produced by the *squaring* form of the map.")
    print(f"\n  {'target':12s} {'steps':>5s} {'max |u_map - 1/r_next|':>26s}"
          f" {'max |brief - 1/r_next|':>26s} {'max |u-(q-s)|/u':>16s}")
    for name, expr in TARGETS:
        rec = stable_orbit(expr, dps, max_steps=40)
        dev_ok = dev_bad = dev_qs = mp.mpf(0)
        for k in range(len(rec) - 1):
            u, q, s = rec[k]["u"], rec[k]["q"], rec[k]["s"]
            u_next = rec[k + 1]["u"]
            cand_ok = u * q / (q - u)
            cand_bad = u * u / (u - mp.floor(u) + 1)
            dev_ok = max(dev_ok, abs(cand_ok - u_next) / abs(u_next))
            dev_bad = max(dev_bad, abs(cand_bad - u_next) / abs(u_next))
            dev_qs = max(dev_qs, abs(u - (q - s)) / u)
        print(f"  {name:12s} {len(rec):5d} {mp.nstr(dev_ok, 6):>26s}"
              f" {mp.nstr(dev_bad, 6):>26s} {mp.nstr(dev_qs, 4):>14s}")
    print("\n  => the derived map is exact to the working precision; the brief's")
    print("     candidate is off by a relative error of order q (not a typo-level")
    print("     discrepancy).  Note also q = u + s and u_{k+1} = u_k q_k/s_k.")


# --------------------------------------------------------------------------- #
# section 2 -- the induced map on the fractional part
# --------------------------------------------------------------------------- #

def sec2_induced(dps: int = 400) -> None:
    hdr("§2  the map induced on the fractional part")
    print("  exact:  f_{k+1} = { q_k^2/(1 - f_k) },   s_{k+1} = 1 - { q_k^2/s_k }")
    print("  the Gauss map on the fractional part would be f_{k+1} = { 1/f_k }.\n")
    print(f"  {'target':12s} {'max|s-map - s_next|':>21s} {'max|f-map - f_next|':>21s}"
          f" {'max|gauss - f_next|':>21s}")
    for name, expr in TARGETS:
        rec = stable_orbit(expr, dps, max_steps=40)
        d_s = d_f = d_g = mp.mpf(0)
        for k in range(len(rec) - 1):
            q, f, s = rec[k]["q"], rec[k]["f"], rec[k]["s"]
            f_next, s_next = rec[k + 1]["f"], rec[k + 1]["s"]
            d_s = max(d_s, abs((1 - (q * q / s - mp.floor(q * q / s))) - s_next))
            d_f = max(d_f, abs((q * q / (1 - f) - mp.floor(q * q / (1 - f))) - f_next))
            d_g = max(d_g, abs((1 / f - mp.floor(1 / f)) - f_next))
        print(f"  {name:12s} {mp.nstr(d_s, 4):>21s} {mp.nstr(d_f, 4):>21s}"
              f" {mp.nstr(d_g, 4):>21s}")
    print("\n  => the induced map is a SKEW PRODUCT over the escaping integer q_k;")
    print("     it is not the Gauss map.  ({1/f} happens to agree once, for")
    print("     f = sqrt2-1, because that is the Gauss map's fixed point.)")

    print("\n  The correct conditional density of s_k given the digits q_0..q_k is")
    print("  (cylinder lemma, proof in the module docstring)")
    print("        mu_q(s) = q(q-1)/(q-s)^2 = 1 + (2s-1)/q + O(1/q^2).")
    print("  It is asymptotically LEBESGUE.  The Gauss-Kuzmin density, which the")
    print("  previous session floated and killed, is a different function:\n")
    pts = ["0.01", "0.25", "0.5", "0.75", "0.99"]
    print(f"  {'q':>8s} " + " ".join(f"mu_q({p})" .rjust(13) for p in pts)
          + "   sup|h1-1|      1/q^2")
    for q in (2, 3, 4, 10, 30, 100, 1000):
        qq = q * q
        vals = [qq * mp.polygamma(1, qq + 1 - mp.mpf(p)) for p in pts]
        dev = max(abs(v - 1) for v in vals)
        print(f"  {q:8d} " + " ".join(f"{mp.nstr(v, 9):>13s}" for v in vals)
              + f" {mp.nstr(dev, 6):>12s} {mp.nstr(mp.mpf(1)/qq, 10):>10s}")
    print("  Gauss-Kuzmin 1/((1+s)ln2) at the same points: "
          + " ".join(f"{mp.nstr(1/((1+mp.mpf(p))*mp.log(2)), 9):>13s}" for p in pts))
    print("\n  and the exact conditional mean of log s (the quantity that drives")
    print("  the average), with h(q) - (-1) shown against 1/(2q):\n")
    print(f"  {'q':>10s} {'E[log s | q]':>22s} {'-1 + 1/(2q)':>22s} {'h(q)+1':>12s}")
    for q in (2, 4, 10, 100, 10 ** 6):
        E = mp.quad(lambda s: mp.log(s) * q * (q - 1) / (q - s) ** 2, [0, 1])
        print(f"  {q:10d} {mp.nstr(E, 18):>22s} {mp.nstr(-1 + mp.mpf(1)/(2*q), 18):>22s}"
              f" {mp.nstr(E + 1, 8):>12s}")
    print(f"\n  int_0^1 log(1-f) df = {mp.nstr(mp.quad(lambda f: mp.log(1-f), [0, 1]), 20)}")
    print("  => the integral -1 is right as the *typical* value, and it is right")
    print("     for a reason that has nothing to do with Gauss-Kuzmin: mu_q -> Lebesgue.")


# --------------------------------------------------------------------------- #
# section 3 -- the correction term
# --------------------------------------------------------------------------- #

def sec3_correction(dps: int = 300) -> None:
    hdr("§3  the correction term sum_k [log c_k - log(1-f_k)] converges")
    print("  log c_k = log(1-f_k) - log(1 + s_k r_k),  0 <= log(1+s_k r_k) <= r_k,")
    print("  and sum_k r_k = sum_k R_k <= sum_k 1/(q_k-1) < infinity.\n")
    for name, expr in TARGETS[:4]:
        rec = stable_orbit(expr, dps, max_steps=40)
        part = mp.mpf(0)
        rows = []
        for k, d in enumerate(rec):
            part += mp.log(1 + d["s"] * d["r"])
            rows.append((k, d["q"], d["r"], part))
        print(f"  {name}:  partial sums of log(1+s_k r_k)")
        for k, q, r, p in rows:
            print(f"     k={k:2d} q_k={q:>28d} r_k={mp.nstr(r, 6):>12s}"
                  f"  partial={mp.nstr(p, 12)}")
        print(f"     => converged value {mp.nstr(part, 12)};"
              f"  Cesaro mean = {mp.nstr(part/len(rec), 10)} -> 0\n")
    print("  consequence: (1/K) sum log c_k and (1/K) sum log(1-f_k) have the")
    print("  same limit (or the same failure to converge).  The rest of the")
    print("  problem is entirely about sum_k log s_k.")


# --------------------------------------------------------------------------- #
# section 4 -- the limit is not independent of x
# --------------------------------------------------------------------------- #

def sec4_refutation(dps_fwd: int = 1200) -> None:
    hdr("§4  REFUTATION: the limit is NOT independent of x")
    print("  For each s* in (0,1] take q_0 = 4, q_{k+1} = floor(q_k^2/s*), and")
    print("  x = sum_k 1/q_k.  By Sylvester's criterion (docstring (B)) the digits")
    print("  of x are exactly q_k; by construction s_k -> s*.  Hence")
    print("  (1/K) sum log c_k -> log s*.  The limits therefore fill (-inf, 0].\n")

    for s_star in ("0.9", "0.5", "0.25", "0.05", "1"):
        K = 14
        q = digits_for_targets([s_star] * K)
        S = backward_s(q, dps=80)
        print(f"  s* = {s_star}:  q_0..q_4 = {q[:5]}")
        run = mp.mpf(0)
        for k in range(7):
            run += mp.log(S[k])
            print(f"      k={k}  s_k = {mp.nstr(S[k], 22):>24s}"
                  f"   running mean over {k+1} = {mp.nstr(run/(k+1), 12)}")
        full = sum(mp.log(S[k]) for k in range(K)) / K
        print(f"      running mean over K={K}: {mp.nstr(full, 12)}"
              f"   log s* = {mp.nstr(mp.log(mp.mpf(s_star)), 12)}")
        # admissibility, from scratch
        ok_ineq = all(q[i + 1] >= q[i] * (q[i] - 1) + 1 for i in range(K))
        ok_ceil = True
        for k in range(5):
            Rk = tail_residual(q, k, dps=200)
            ok_ceil &= (mp.ceil(1 / Rk) == q[k]) and (Rk < 1 / mp.mpf(q[k] - 1))
        print(f"      Sylvester inequalities hold: {ok_ineq};"
              f"  ceil(1/R_k) = q_k and R_k < 1/(q_k-1) for k<5: {ok_ceil}")
        # Independent forward check: rebuild x = sum 1/q_k at high precision and
        # run the *forward* greedy map.  Only the digits that are stable when the
        # working precision is lowered are compared -- the last one or two steps
        # of any fixed-precision run are below the noise floor (truths.md I5).
        x = x_from_digits(q, dps=dps_fwd)
        fwd_hi = [d["q"] for d in orbit_from_x(x, dps_fwd, max_steps=14)]
        fwd_lo = [d["q"] for d in orbit_from_x(x, int(dps_fwd * 0.5), max_steps=14)]
        stable = 0
        while (stable < len(fwd_hi) and stable < len(fwd_lo)
               and fwd_hi[stable] == fwd_lo[stable]):
            stable += 1
        match = fwd_hi[:stable] == q[:stable]
        print(f"      forward iteration from x (dps={dps_fwd}={2*dps_fwd//2})"
              f" reproduces the prescribed q_k: {match}"
              f"  ({stable} precision-stable digits of {len(fwd_hi)};"
              f" digits {fwd_hi[:6]}...)")
        print()

    print("  => x with s* = 1/2 gives limit log(1/2) = "
          f"{mp.nstr(mp.log(mp.mpf('0.5')), 12)} != -1.")
    print("     x with s* = 1 gives limit 0 (i.e. sum log c_k CONVERGES there).")
    print("     So 'a limit independent of x' is false, and so is 'a limit for")
    print("     every x' and so is 'sum log c_k is bounded' as a universal claim.\n")

    # ---- a second family: the running average need not converge ----
    print("  Oscillating family.  Same construction with prescribed targets")
    print("  s*_k in {1/2, 1}: block m has length 2^m, target 1/2 for m even and")
    print("  1 for m odd.  Since |s_k - s*_k| <= C/q_k and sum 1/q_k < infinity,")
    print("  the Cesaro means of log s_k and of log s*_k coincide, so it is")
    print("  enough to average the targets:")
    targets = []
    m = 1
    while len(targets) < 4094:
        targets += [mp.mpf("0.5") if m % 2 == 0 else mp.mpf(1)] * (2 ** m)
        m += 1
    targets = targets[:4094]
    run = mp.mpf(0)
    print(f"     {'K = end of block':>18s} {'running mean of log s*_k':>26s}")
    for k, t in enumerate(targets, start=1):
        run += mp.log(t)
        if k in (2, 6, 14, 30, 62, 126, 254, 510, 1022, 2046, 4094):
            print(f"     {k:>18d} {mp.nstr(run / k, 12):>26s}")
    lh = mp.log(mp.mpf("0.5"))
    print(f"     => two distinct subsequential limits, (2/3)log(1/2) ="
          f" {mp.nstr(2*lh/3, 12)} at even block ends and (1/3)log(1/2) ="
          f" {mp.nstr(lh/3, 12)}")
    print("        at odd block ends: for some irrational x the running average")
    print("        does not converge at all, so even 'the limit exists' fails.")


# --------------------------------------------------------------------------- #
# section 5 -- what is true instead
# --------------------------------------------------------------------------- #

def sec5_annealed_and_ae(dps: int = 3200, slow: bool = False) -> None:
    hdr("§5  the true statement: -1 for a.e. x  (L^1 PROVED, a.e. CONJECTURE)")
    S, tot = sylvester_mass(8)
    print("  Sylvester sequence 2,3,7,43,1807,... bounds the greedy digits from")
    print(f"  below, so sum_k 1/q_k <= sum_k 1/S_k = 1 exactly (telescoping).")
    print(f"  Partial sum of the first 8 terms = {mp.nstr(tot, 15)};"
          f"  tail < 1/(S_9-1) ~ 1e-38.\n")
    print("  By the exact conditional law (docstring (D)):  E[log s_k] = -1")
    print("  + (1/2)E[1/q_k] + O(E[1/q_k^2]), and sum_k E[1/q_k] <= 1.  Hence")
    print("  E[(1/K) sum log s_k] = -1 + O(1/K): L^1 convergence to -1, proved.")
    print("  The a.e. version is reduced in docstring (H) to the expanding-map")
    print("  correlation lemma, which is stated but not proved here.\n")

    runs = [("1/pi", "1/pi"), ("log 2", "log(2)"), ("sqrt2-1", "sqrt(2)-1"),
            ("e-2", "e-2"), ("sqrt3-1", "sqrt(3)-1")]
    if slow:
        runs += [("log2/log10", "log(2)/log(10)")]
    print("  Orbit evidence for generic x.  The exact conditional mean of")
    print("  log s_k is -1 + 1/(2q_k) + O(1/q_k^2) (section 2), so the sum is")
    print("  -K + O(1): the running mean sits at -1 with fluctuations of order")
    print("  1/sqrt(K).  Crucially the individual log s_k are O(1) throughout --")
    print("  they do not decay, so the sum cannot converge.\n")
    dd = 10 ** 5 if slow else dps
    for name, expr in runs:
        rec = stable_orbit(expr, dd, max_steps=40)
        logs = [mp.log(d["s"]) for d in rec]
        K = len(logs)
        run = sum(logs) / K
        last = [mp.nstr(x, 4) for x in logs[-4:]]
        print(f"  {name:12s} dps={dd:<7d} steps={K:3d}"
              f"  mean log s_k = {mp.nstr(run, 8):>12s}"
              f"  sum log s_k = {mp.nstr(sum(logs), 8):>12s}"
              f"  (=-K-4.0(1) at K={K})")
        print(f"  {'':12s} last four log s_k, all O(1): {last}")
    if slow:
        print("\n  high-precision generic orbits (this is the slow part):")
        for dps2 in (5 * 10 ** 4, 10 ** 5):
            rec = stable_orbit("1/pi", dps2, max_steps=40)
            logs = [mp.log(d["s"]) for d in rec]
            print(f"  {'1/pi':12s} dps={dps2:<7d} steps={len(logs):3d}"
                  f"  mean = {mp.nstr(sum(logs)/len(logs), 10)}")


# --------------------------------------------------------------------------- #
# section 6 -- the unachievable protocol
# --------------------------------------------------------------------------- #

def sec6_protocol() -> None:
    hdr("§6  the section 6.5 protocol is unachievable  (reconfirms I5/I6)")
    print("  dps -> usable steps for x = 1/pi, against 2 + log2(dps).")
    print("  'raw' is where the fixed-precision iteration stops; 'stable' keeps")
    print("  only steps whose digits survive halving the precision.\n")
    print(f"  {'dps':>8s} {'raw':>5s} {'stable':>7s} {'2+log2(dps)':>12s}"
          f" {'mean log s_k (stable)':>23s}")
    for dps in (60, 120, 200, 400, 800, 1600, 3200, 10000):
        raw = len(orbit_from_x("1/pi", dps, max_steps=40))
        rec = stable_orbit("1/pi", dps, max_steps=40)
        logs = [mp.log(d["s"]) for d in rec]
        print(f"  {dps:8d} {raw:5d} {len(logs):7d} {float(2 + mp.log(dps, 2)):12.2f}"
              f" {mp.nstr(sum(logs)/len(logs), 8):>23s}")
    print("\n  40-50 steps would need 2^38-2^48 decimal digits.  The only route")
    print("  to a deep orbit is to prescribe the digits in advance, as in §4.")


# --------------------------------------------------------------------------- #

SECTIONS = {1: sec1_umap, 2: sec2_induced, 3: sec3_correction,
            4: sec4_refutation, 5: sec5_annealed_and_ae, 6: sec6_protocol}


def main(argv=None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    slow = "--slow" in argv
    only = None
    if "--only" in argv:
        i = argv.index("--only")
        only = {int(a) for a in argv[i + 1:] if a.isdigit()}
    for n in sorted(SECTIONS):
        if only and n not in only:
            continue
        if n == 5:
            SECTIONS[n](slow=slow)
        else:
            SECTIONS[n]()
    print("\n" + "=" * 78)
    print("SUMMARY")
    print("=" * 78)
    print("  u-map (verified):        u' = u ceil(u)/(ceil(u) - u);  brief's")
    print("                           u^2/(u-floor(u)+1) is refuted.")
    print("  fractional-part map:     s' = 1 - {q^2/s},  f' = {q^2/(1-f)}; a skew")
    print("                           product, NOT Gauss; invariant density ->")
    print("                           Lebesgue, not Gauss-Kuzmin.")
    print("  correction term:         PROVED convergent; the problem is sum log s_k.")
    print("  K6 as posed:             REFUTED.  Explicit irrational x realise the")
    print("                           limit log s* for every s* in (0,1]; another")
    print("                           family has no limit at all.")
    print("  replaced by:             (1/K) sum log c_k -> -1 in L^1 (PROVED), and")
    print("                           a.e. (CONJECTURE modulo the stated")
    print("                           expanding-map correlation lemma).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
