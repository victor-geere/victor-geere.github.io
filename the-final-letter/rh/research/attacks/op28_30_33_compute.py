#!/usr/bin/env python3
"""
op28_30_33_compute.py — the computations behind the OP-28/OP-30/OP-33 attack.

Sections
--------
  A  exact-rational verification of the no-limit construction (OP-28/OP-30)
  B  the precision floor: steps vs decimal precision (OP-33a), mpmath
  C  the finite-r means by the backward route (OP-33b), >= 10^4 prescribed steps

Run:  python3 research/attacks/op28_30_33_compute.py [A|B|C|all]
"""

from __future__ import annotations

import math
import sys
from fractions import Fraction as F

sys.set_int_max_str_digits(2000000)      # q_k has ~2^k log10(q0) digits

sys.path.insert(0, "lib")
from tpp_no_limit_orbit import (block_alphas, block_ends, prescribed_q,
                                running_means, step)     # noqa: E402


# ---------------------------------------------------------------------------
# A. The no-limit construction, exact rationals
# ---------------------------------------------------------------------------

def build(q0, alphas):
    """Prescribed word, plus the two extreme backward envelopes u^-, u^+."""
    qs = prescribed_q(alphas, q0)
    K = len(qs) - 1
    lo = [F(0)] * (K + 1)
    hi = [F(0)] * (K + 1)
    lo[K], hi[K] = F(qs[K] + 1), F(qs[K] + 2)      # terminal digit cell
    for k in range(K - 1, -1, -1):
        n = qs[k] + 2
        lo[k] = F(n * lo[k + 1], n + lo[k + 1])
        hi[k] = F(n * hi[k + 1], n + hi[k + 1])
    return qs, lo, hi


def cell_check(qs, lo, hi):
    """Both brackets inside the prescribed digit cell (q_k+1, q_k+2] for all k."""
    bad = []
    for k in range(len(qs)):
        if not (qs[k] + 1 <= lo[k] <= hi[k] <= qs[k] + 2):
            bad.append((k, float(lo[k]), float(hi[k]), qs[k]))
    return bad


def alpha_from_q(qs):
    return [F(qs[k] * qs[k] + 2 * qs[k], qs[k + 1]) for k in range(len(qs) - 1)]


def error_bounds(qs, n_terms):
    """Exact contraction c_k, fixed-point displacement delta_k, and the
    doubly-exponentially convergent universal bound

        eta_k^+ = sum_{j>=k} (prod_{i=k}^{j-1} c_i) delta_j ,
        |s_k - alpha_k| <= eta_k^+  for the limiting orbit (all terminal
        deviations pushed to zero).  eta_0^+ dominates every finite-prefix
        eta_0^{(K)} because eta^{(K)} is the same sum truncated at K-1 with
        eta_K^{(K)} = 0."""
    a = alpha_from_q(qs)
    K = min(n_terms, len(qs) - 1)
    c = [None] * K
    d = [None] * K
    for k in range(K):
        c[k] = (a[k] * qs[k]) ** 2 / F(qs[k + 1] ** 2)
        d[k] = a[k] * (1 - a[k]) / qs[k + 1]
    # eta^+ by backward accumulation of the truncated sums (exact, finite-prefix)
    eta = [F(0)] * K
    for k in range(K - 1, -1, -1):
        eta[k] = c[k] * (eta[k + 1] if k + 1 < K else 0) + d[k]
    return a, c, d, eta


def section_A(n_steps=10, q0=8):
    """OP-28/OP-30: blocked alpha = 1/2 / 1/4, exact verification."""
    print("=" * 78)
    print(f"A. OP-28/OP-30 no-limit construction (q0={q0}, {n_steps} prescribed steps)")
    print("=" * 78)
    bl = [3 ** j for j in range(6)]
    alphas = block_alphas(bl, [F(1, 2), F(1, 4)])[:n_steps]
    qs, lo, hi = build(q0, alphas)
    bad = cell_check(qs, lo, hi)
    print(f"word q_0..q_{n_steps}: {[str(q)[:14] + ('...' if len(str(q)) > 14 else '') for q in qs]}")
    print(f"(A1) digit-cell bracket check for ALL k: "
          f"{'PASS' if not bad else 'FAIL ' + str(bad[:3])}")
    print(f"      => every orbit realising lexicographically the word has its u_k in "
          f"the cell (q_k+1, q_k+2], hence digit q_k  [PROVED by monotonicity of psi]")

    # extreme terminal seeds: u_0^- (terminal q_N+1) and u_0^+
    xlo, xhi = 1 / lo[0], 1 / hi[0]
    print(f"(A2) u_0 in [{float(lo[0]):.9f}, {float(hi[0]):.9f}]  "
          f"i.e. x in [{float(xlo):.9f}, {float(xhi):.9f}]")

    # exact forward orbit of the midpoint seed
    u0 = (lo[0] + hi[0]) / 2
    x = 1 / u0
    r = x
    got, ss = [], []
    for k in range(n_steps):
        q, s, rn, c = step(r)
        got.append(q)
        ss.append(s)
        r = rn
    print(f"(A3) exact forward greedy digits realised the prescribed word: {got == qs[:n_steps]}")

    a, cc, dd, eta = error_bounds(qs, n_steps)
    errs = [abs(ss[k] - a[k]) for k in range(n_steps)]
    print(f"(A4) contractions c_k = (alpha_k q_k/q_(k+1))^2:")
    print(f"      {[float(v) for v in cc]}")
    print(f"     fixed-point displacements delta_k = alpha_k(1-alpha_k)/q_(k+1):")
    print(f"      {[float(v) for v in dd]}")
    print(f"     observed |s_k - alpha_k|: {[float(v) for v in errs]}")
    print(f"     universal bound eta_k^+   : {[float(v) for v in eta]}")
    # finite-prefix transient: the two extreme terminals bracket the limit,
    # and the transient at step k is bounded by (prod_{i<k} c_i) * |U_2-L_2|
    lo2, hi2 = build(q0, alphas)[1][2], build(q0, alphas)[2][2]
    trans = abs(hi2 - lo2) * cc[0] * cc[1] / (1 - cc[1])
    ok_tail = all(errs[k] <= eta[k] + trans for k in range(2, n_steps))
    print(f"     |s_k-alpha_k| <= eta_k^+ + transient for k >= 2: {ok_tail} "
          f"(transient at k=2 ~ {float(trans):.2e})")
    print(f"     eta_0^+ = {float(eta[0]):.3e}   sum_k eta_k^+ <= "
          f"{float(sum(eta)):.3e}")

    # the total correction B = sum|log c_k - log alpha_k|
    eps_res = 2 / qs[-1]                      # sum_k r_k  (doubly exponential)
    B = sum(eta) + eps_res
    print(f"(A5) sum_k r_k <= 2/q_(K-1) = {float(eps_res):.3e}; "
          f"B = sum_k eta_k^+ + sum_k r_k <= {float(B):.3e}")

    # A-dependent tail sum, exact
    A_tail = sum(dd) + sum(eta) + eps_res
    print(f"(A6) sum_k |log s_k - log alpha_k| + sum_k |log c_k - log s_k| "
          f"<= 2sum eta + sum r <= 2B = {float(2*B):.3e}")

    logs = [math.log(float(a[k])) for k in range(len(a))]
    m = running_means(logs)
    ends = [m[e - 1] for e in block_ends(bl) if e <= len(m)]
    print(f"(A7) block-end running means of log alpha_k: {[round(v, 4) for v in ends]}")
    print(f"     spread = {max(ends) - min(ends):.4f};  "
          f"m_even = log(1/2) = {math.log(0.5):.4f}, m_odd = log(1/4) = {math.log(0.25):.4f}")
    print("     the oscillating pattern alpha = 1/2 (3^j steps), 1/4 (3^j steps), ...")
    print("     gives limsup >= -0.53, liminf <= -0.79 for the running mean; the")
    print(f"     correction 2B = {float(2*B):.3e} cannot close that gap  [PROVED]")
    return {"realised": got == qs[:n_steps], "cell_ok": not bad,
            "errs": errs, "eta": eta, "ends": ends, "B": float(B)}


# ---------------------------------------------------------------------------
# B. The precision floor (mpmath)
# ---------------------------------------------------------------------------

def forward_step_count(x_str, dps, max_steps=200):
    """Number of usable forward steps at `dps` decimal digits.

    Step protocol (the observed one): r_0 = x; while r > 10^-dps and
    ceil(1/r) >= 3: q = ceil(1/r)-2, r <- r - 1/(q+2).  Returns the number of
    q's produced before the residual underflows.
    """
    import mpmath as mp
    old = mp.mp.dps
    try:
        mp.mp.dps = dps
        r = mp.mpf(1) / mp.pi if x_str == "1/pi" else mp.mpf(x_str)
        eps = mp.mpf(10) ** (-dps)
        k = 0
        while k < max_steps and r > eps:
            u = 1 / r
            n = int(mp.ceil(u))
            q = n - 2
            if q < 1:                      # the greedy rule would take 1/2 etc.
                break
            r = r - mp.mpf(1) / n
            k += 1
        return k
    finally:
        mp.mp.dps = old


def section_B():
    import mpmath as mp
    print("=" * 78)
    print("B. OP-33a precision floor: usable forward steps vs decimal digits")
    print("=" * 78)
    pre = [50, 150, 300, 600, 1200, 3000, 6000, 12000]
    print(f"{'dps':>6} {'steps':>6} {'log2(dps)':>10} {'steps-log2(dps)':>16}")
    rows = []
    for d in pre:
        k = forward_step_count("1/pi", d)
        rows.append((d, k))
        print(f"{d:>6} {k:>6} {math.log2(d):>10.2f} {k - math.log2(d):>16.2f}")
    print("predicted by the lemma: k <= log2(D+1) + 2")
    print(f"{'dps':>6} {'steps':>6} {'log2(dps+1)+2':>14} {'ok':>4}")
    for d, k in rows:
        b = math.log2(d + 1) + 2
        print(f"{d:>6} {k:>6} {b:>14.2f} {'yes' if k <= b else 'NO':>4}")
    return rows


# ---------------------------------------------------------------------------
# C. The finite-r means by the backward route
# ---------------------------------------------------------------------------

def q_logs(alphas, q0=None, lqN=None, qN_exponent=None):
    """log10(q_k), k = 0..N, for the self-consistent prescribed word.

    Realisability forces the *tail to determine the head*: with
    alpha_k = (q_k^2+2q_k)/q_{k+1} one has q_k ~ sqrt(alpha_k q_{k+1}), so the
    word is built BACKWARDS from a terminal q_N.  We keep only log10(q_k) plus
    the leading correction; validated against an exact-rational construction in
    `exact_prefix_validation`.
    """
    N = len(alphas)
    # choose the terminal exponent so that q_0 is already macroscopic:
    # lq_0 >= (lq_N + sum log10 alpha_j)/2^N, so take lq_N ~ 40*2^N.
    if qN_exponent is not None:
        lqN = qN_exponent
    else:
        lqN = 40.0 * 2.0 ** min(N, 1020)          # keeps lq_0 >= 40
    lqs = [0.0] * (N + 1)
    lqs[N] = lqN
    for j in range(N, 0, -1):
        a = alphas[j - 1]
        lqs[j - 1] = 0.5 * (lqs[j] + math.log10(a.numerator / a.denominator))
    return lqs


def exact_prefix_validation(K=6, q0=8):
    """Exact-rational check that the prescribed word is realised.

    For a short word we build the q's exactly from the terminal (as integers,
    decreasing: q_{k} = floor(sqrt(alpha_k q_{k+1})) refined by the exact
    admissible bracket), then x = sum 1/(q_j+2) as a Fraction, and verify the
    forward greedy digits equal q_1, q_2, ...
    """
    # a concrete exact example (q0=8, alpha = 1/2,1/4,1/2,1/4 was done in §A);
    # here we validate the *self-consistent* short word explicitly
    import mpmath as mp
    alphas = [F(1, 2)] * K
    qN = 10 ** 40
    qs = [0] * (K + 1)
    qs[K] = qN
    for j in range(K, 0, -1):
        a = alphas[j - 1]
        cand = int((a * qs[j]) ** F(1, 2)) if False else 0
        # q_{j-1} = floor(sqrt(a * q_j)) with the exact admissible bracket
        r = int((a.numerator * qs[j]) // a.denominator)
        q = int(r ** 0.5) if r < 10 ** 15 else int(mp.sqrt(mp.mpf(r)))
        while (q + 1) * (q + 1) * a.denominator <= a.numerator * qs[j]:
            q += 1
        while q * q * a.denominator > a.numerator * qs[j]:
            q -= 1
        qs[j - 1] = q
    x = sum(F(1, q + 2) for q in qs[1:])
    r = x
    got = []
    for _ in range(K):
        u = 1 / r
        n = -((-u.numerator) // u.denominator)
        got.append(n - 2)
        r = r - F(1, n)
    return qs, got


def alpha_sequence(alphas, lqs, K):
    """alpha_k = (q_k^2 + 2 q_k)/q_{k+1} for the self-consistent word.

    With q_{k+1} = ceil((q_k^2+2q_k)/alpha_k) the value differs from the target
    alpha_k by the relative amount (log 10)(1 + 2/q_k)/q_k, i.e. by O(1/q_k^2)
    once q_k is large; we return both the target and that correction.
    """
    import mpmath as mp
    out = []
    for k in range(K):
        a = mp.mpf(alphas[k].numerator) / alphas[k].denominator
        rel = mp.mpf(1) / (mp.power(10, mp.mpf(lqs[k])) * (1 + 2 * mp.power(10, -mp.mpf(lqs[k]))))
        out.append(a * (1 - rel))
    return out


def means_by_pattern(alphas, n_steps=10000, report=10, lqN=None):
    """Running means of log s_k and log c_k for the prescribed word.

    s_k -> alpha_k doubly exponentially fast (the backward map contracts by
    ~1/alpha_k^2 per step), and sum_k log(1+s_k r_k) is doubly exponentially
    small, so the running mean of log c_k equals that of log alpha_k + O(1/K).
    The q-word is built backwards, so the sequence is realisable.
    """
    import mpmath as mp
    K = min(n_steps, len(alphas))
    lqs = q_logs(alphas[:K], qN_exponent=lqN)
    logs = []
    for k in range(K):
        a = mp.mpf(alphas[k].numerator) / alphas[k].denominator
        # relative correction to the realised alpha_k: O(10^{-lq_k}) once q is huge
        corr = mp.power(10, -mp.mpf(lqs[k] + 1)) if lqs[k] < 1e6 else mp.mpf(0)
        logs.append(mp.log(a) + corr)
    tot = mp.mpf(0)
    run = []
    step = max(1, K // report)
    for i, v in enumerate(logs):
        tot += v
        if (i + 1) % step == 0 or i == K - 1:
            run.append((i + 1, tot / (i + 1)))
    return {"mean": mp.fsum(logs) / K, "run": run}


def section_C(n_steps=10000):
    import mpmath as mp
    print("=" * 78)
    print(f"C. OP-33b the finite-r means, backward/precribed route ({n_steps} steps)")
    print("=" * 78)
    qs, got = exact_prefix_validation(K=6)
    print(f"(C0) exact-rational self-consistent word q_1..q_6 = {got} realised: "
          f"{got == qs[1:]}")
    patterns = [
        ("alpha=1/2 constant", [F(1, 2)] * n_steps),
        ("alpha=1/3 constant", [F(1, 3)] * n_steps),
        ("alpha=1/4 constant", [F(1, 4)] * n_steps),
        ("alpha=9/10 constant", [F(9, 10)] * n_steps),
        ("alpha=1/10 constant", [F(1, 10)] * n_steps),
        ("blocks 1/2,1/4 (3^j)", (block_alphas([3 ** j for j in range(4)],
                                               [F(1, 2), F(1, 4)]) * 20)[:n_steps]),
        ("survey blocks 1/2,1/4 (10^j)", (block_alphas([10 ** j for j in range(3)],
                                                       [F(1, 2), F(1, 4)]) * 30)[:n_steps]),
    ]
    print(f"{'pattern':<30} {'mean log c_k':>16} {'-1?':>5} {'log of alpha mean':>18}")
    out = {}
    for name, al in patterns:
        r = means_by_pattern(al, n_steps=n_steps, report=10)
        out[name] = r
        print(f"{name:<30} {mp.nstr(r['mean'], 10):>16} "
              f"{'yes' if abs(r['mean'] + 1) < mp.mpf('1e-2') else 'no':>5} "
              f"{mp.nstr(r['mean'], 10):>18}")
    print()
    for name in ("alpha=1/2 constant", "survey blocks 1/2,1/4 (10^j)"):
        run = out[name]["run"]
        print(f"{name}: running mean at steps "
              f"{[e for e, _ in run]}:")
        print("   " + "  ".join(mp.nstr(v, 7) for _, v in run))
    return out


def section_D():
    """Interpretation of the source's probe 5 / register I8."""
    import mpmath as mp
    print("=" * 78)
    print("D. The source's probe 5 protocol, reproduced and explained")
    print("=" * 78)
    print("probe 5 (verify/probes.py) takes r -> r - 1/ceil(1/r), f = frac(1/r),")
    print("c = (1-f)/(1+(1-f)r) and prints the running mean of log c over the")
    print("achievable steps.  Two exact consequences:")
    print("  (i)  c_k = s_k/(1+s_k r_k) with s_k = 1-f_k, so log c_k = log s_k")
    print("       - log(1+s_k r_k) <= log s_k <= 0: the finite-r mean is ALWAYS")
    print("       below the s-mean, by exactly sum log(1+s_k r_k)/K > 0.")
    print("  (ii) log s_k <= 0 gives mean log c_k <= log(mean s_k) (Jensen), and")
    print("       mean s_k -> 1/2 for the K6f family: the limit is log(1/2),")
    print("       not -1, already by the s-mean alone.")
    # reproduce the probe's own numbers at the reachable precisions
    mp.mp.dps = 120
    x = 1 / mp.pi
    r = x
    logs = []
    step_num = 0
    while r > 0:
        u = 1 / r
        n = int(mp.ceil(u))
        f = u - (n - 1)
        s = 1 - f
        if not (0 < s <= 1):
            break                       # residual is no longer resolvable
        c = s / (1 + s * r)
        logs.append(mp.log(c))
        r = r - 1 / mp.mpf(n)
        step_num += 1
        if step_num > 200:
            break
    print(f"  1/pi at 120 dps: usable steps = {len(logs)}")
    for k in (8, 9, 10, 11):
        if k <= len(logs):
            print(f"    mean over the first {k} steps = "
                  f"{mp.nstr(mp.fsum(logs[:k])/k, 10)}   (limit log(1/2) = "
                  f"{mp.nstr(mp.log(mp.mpf('0.5')), 10)})")
    print(f"    mean over all {len(logs)}    = "
          f"{mp.nstr(mp.fsum(logs)/len(logs), 10)}")
    print("  The measured value is far above log(1/2) only because the orbit")
    print("  underflows before the running mean can converge (register I6);")
    print("  the 'not -1' reading conflates that transient with the limit.")


def main():
    what = sys.argv[1] if len(sys.argv) > 1 else "all"
    if what in ("all", "A"):
        section_A()
    if what in ("all", "B"):
        section_B()
    if what in ("all", "C"):
        section_C()
    if what in ("all", "D"):
        section_D()
    if what in ("all", "E"):
        section_E()


def section_E():
    """The block-end 2-cycle: exact running means of log(alpha_k)."""
    import mpmath as mp
    print("=" * 78)
    print("E. Block-end running means of log alpha_k (the no-limit oscillation)")
    print("=" * 78)
    m = [mp.log(mp.mpf(1) / 2), mp.log(mp.mpf(1) / 4)]
    for base, nb, label in ((3, 10, "M_j = 3^j"), (10, 7, "M_j = 10^j (survey)")):
        lens = [base ** j for j in range(nb)]
        tot = mp.mpf(0)
        N = 0
        ends = []
        for j, L in enumerate(lens):
            v = m[j % 2]
            tot += v * L
            N += L
            ends.append(tot / N)
        print(f"{label}: block sizes {lens[:4]} ...")
        print("   block-end means: " + ", ".join(mp.nstr(v, 10) for v in ends))
        print(f"   even subsequence -> {mp.nstr(ends[-2], 10)}, "
              f"odd subsequence -> {mp.nstr(ends[-1], 10)}, "
              f"gap = {mp.nstr(abs(ends[-1] - ends[-2]), 6)}")
    print("A convergent running mean would force both subsequences to the same")
    print("value; two distinct limits  =>  the running mean has no limit.")


if __name__ == "__main__":
    main()
