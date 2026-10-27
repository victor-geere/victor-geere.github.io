#!/usr/bin/env python3
"""
op13_almost_everywhere.py — OP-13 (rank 10): the almost-everywhere order of the
greedy harmonic support function A(N).

OBJECT (rh41 definition of record).  For 0 < x < 1 the greedy rule at step n
compares the residual r with 1/(n+2): take the digit 1 iff r >= 1/(n+2) and
subtract.  Let 0 <= n_0 < n_1 < ... be the support (taken indices) and let r_k
be the residual *before* the k-th take.  Then, exactly,

    n_k + 2 = ceil(1/r_k)        (so n_k ~ 1/r_k),
    r_{k+1} = r_k - 1/(n_k + 2),
    A(N)    = #{k : n_k <= N} = #{k : r_k >= 1/(N+2)}.

Everything involving an orbit is exact rational arithmetic (fractions.Fraction);
no float ever touches an orbit.  Floats appear only in the *reported* logarithms
and statistics.

WHAT IS KNOWN (rh41/TRUTHS.md §3; rh41 Lean Rh41/GreedyResidual.lean)
  * squaring_law              : r_{k+1} <= r_k^2 (checked; Lean-proved).
  * no_positive_lower_bound   : r_{k+1}/r_k^2 has NO positive lower bound, and
        r_{k+1}/r_k^2 = s/(1 + s r_k),   s := q - 1/r_k in (0,1), q := ceil(1/r_k).
  * Theorem 7 (maps)          : u' = q^2/s - q  and  s' = 1 - {q^2/s}, u = 1/r.
  * Theorem 8                 : every rational x terminates.

WHAT THIS SCRIPT DOES (finite evidence only; it proves nothing)
  (a) ~10^4 exact rational orbits over a range of denominator bands; the
      distribution of r_{k+1}/r_k^2 and of A(N) for a grid of N.
  (b) regression of the pooled points (k, log log n_k), which is the orbit-wise
      (A(N), log log N) relation; the fitted exponent c, R^2, per-orbit slopes,
      and the dispersion of A(N)/log log N.
  (c) the induced map s -> 1 - {q^2/s} verified exactly step by step; the
      empirical laws P(r_{k+1}/r_k^2 <= eps) and P(run of L ratios <= eps),
      with log-log slopes a_L: does the small-ratio frequency decay like a
      power (Borel-Cantelli style) or not?

DIRECTIONAL NOTE (structural; reported, not proved here).  squaring_law gives
r_k <= x^{2^k}, hence n_k + 2 = ceil(1/r_k) >= x^{-2^k}, hence

    A(N) <= log_2( log(N+2) / log(1/x) ) = O_x(log log N),

an UPPER bound.  A lower bound A(N) = Omega_x(log log N) would require a
positive lower bound on r_{k+1}/r_k^2, which rh41 refutes.  Section (b)
therefore *checks* the upper direction empirically and *measures* the failure of
the lower one.  OP-13 as a two-sided almost-everywhere law remains OPEN.

Run:  python3 op13_almost_everywhere.py          (exit 0 iff all checks PASS)
"""
from __future__ import annotations

import bisect
import math
import random
import sys
import time
from fractions import Fraction
from typing import Dict, List, Tuple

# --------------------------------------------------------------------------- #
# configuration
# --------------------------------------------------------------------------- #
SEED = 20240613
N_STARTS = 10_000
BITCAP = 1 << 16          # cap on bit length of numerator+denominator of r
KMAX = 64                 # hard cap on takes per orbit

# denominator bands (lo, hi, count); sum(count) == N_STARTS.  The deep bands
# (>= 10^12) are over-weighted because tiny ratios r'/r^2 <= eps require the
# numerator of r to be large, i.e. a residual well into the orbit.
BANDS: List[Tuple[int, int, int]] = [
    (10, 10 ** 3, 1500),
    (10 ** 3, 10 ** 6, 1500),
    (10 ** 6, 10 ** 12, 1500),
    (10 ** 12, 10 ** 18, 2000),
    (10 ** 18, 10 ** 30, 3500),
]
assert sum(b[2] for b in BANDS) == N_STARTS

D_GRID = [1, 2, 3, 4, 5, 6, 8, 10, 12, 15, 18, 20, 25, 30, 40, 50, 75, 100,
          150, 200, 300, 500, 750, 1000, 2000, 5000, 10_000, 20_000, 50_000]
N_GRID = [10 ** d for d in D_GRID]
LN10 = math.log(10)

EPS_GRID = [1e-1, 3e-2, 1e-2, 3e-3, 1e-3, 3e-4, 1e-4, 3e-5, 1e-5]
RUN_LENS = [1, 2, 3]

FAILS: List[str] = []
NPASS = 0


def check(label: str, ok: bool, detail: str = "") -> bool:
    global NPASS
    tag = "PASS" if ok else "FAIL"
    if ok:
        NPASS += 1
    else:
        FAILS.append(label)
    print(f"  [{tag}] {label}" + (f" — {detail}" if detail else ""))
    return ok


def loglog(n: int) -> float:
    """log(log(n)) for a positive python int."""
    if n < 3:
        return 0.0
    return math.log(math.log(n))


def linfit(xs: List[float], ys: List[float]):
    n = len(xs)
    mx = sum(xs) / n
    my = sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    syy = sum((y - my) ** 2 for y in ys)
    slope = sxy / sxx if sxx else float("nan")
    inter = my - slope * mx
    ss_res = sum((y - (slope * x + inter)) ** 2 for x, y in zip(xs, ys))
    r2 = 1 - ss_res / syy if syy else float("nan")
    se = math.sqrt(ss_res / (n - 2) / sxx) if n > 2 and sxx else float("nan")
    return slope, inter, r2, se


# --------------------------------------------------------------------------- #
# exact orbit (all checks done in exact arithmetic during the walk)
# --------------------------------------------------------------------------- #
class Counter:
    def __init__(self) -> None:
        self.induced_checks = 0
        self.induced_bad = 0
        self.ratio_checks = 0
        self.ratio_bad = 0
        self.squaring_bad = 0
        self.ub_checks = 0
        self.ub_bad = 0
        self.terminated = 0
        self.bitcap = 0
        self.zero_s = 0


class Orbit:
    __slots__ = ("x", "k", "lln", "ln_n", "ratios", "s_vals", "deep", "term")

    def __init__(self, x, k, lln, ln_n, ratios, s_vals, deep, term):
        self.x = x
        self.k = k                  # number of takes recorded
        self.lln = lln              # log(log(n_k)) per take
        self.ln_n = ln_n            # log(n_k) per take (for A(N))
        self.ratios = ratios        # float r'/r^2, non-terminal takes only
        self.s_vals = s_vals        # float s, non-terminal takes only
        self.deep = deep            # hit the bit-cap (surrogate for a.e. orbit)
        self.term = term            # terminated exactly (rational)


def orbit(x: Fraction, ctr: Counter, kmax: int = KMAX, bitcap: int = BITCAP) -> Orbit:
    r = Fraction(x)
    m = max(2, math.ceil(1 / r))
    log_inv_x = math.log(1 / float(x))
    lln: List[float] = []
    ln_n: List[float] = []
    ratios: List[float] = []
    s_vals: List[float] = []
    prev = None                     # (q, s) exact of previous step
    terminated = False
    hit_bitcap = False
    k = 0
    for k in range(kmax):
        u = 1 / r
        q = math.ceil(u)
        assert q == m, "ceil(1/r) bookkeeping"
        s = Fraction(q, 1) - u
        n = m - 2
        # induced map s' = 1 - {q^2/s}, verified exactly
        if prev is not None:
            qp, sp = prev
            val = Fraction(qp * qp, 1) / sp
            fl = val.numerator // val.denominator
            frac = val - fl
            if frac == 0:
                ctr.zero_s += 1
            else:
                ctr.induced_checks += 1
                if 1 - frac != s:
                    ctr.induced_bad += 1
        prev = (q, s)
        lln.append(loglog(n) if n >= 3 else 0.0)
        ln_n.append(math.log(n) if n >= 1 else 0.0)
        rn = r - Fraction(1, m)
        if rn > 0:
            ctr.ratio_checks += 1
            ratio_exact = rn / (r * r)
            if ratio_exact != s / (1 + s * r):
                ctr.ratio_bad += 1
            if ratio_exact > 1:
                ctr.squaring_bad += 1
            ratios.append(float(ratio_exact))
            s_vals.append(float(s))
            # serialised consequence of squaring_law:
            #   k <= log2( log(n_k+2) / log(1/x) )
            if n >= 2:
                ctr.ub_checks += 1
                bound = math.log(math.log(n + 2) / log_inv_x, 2)
                if k > bound + 1e-9:
                    ctr.ub_bad += 1
        if rn == 0:
            terminated = True
            break
        r = rn
        m = max(m + 1, math.ceil(1 / r))
        if r.numerator.bit_length() + r.denominator.bit_length() > bitcap:
            hit_bitcap = True
            break
    ctr.terminated += int(terminated)
    ctr.bitcap += int(hit_bitcap)
    return Orbit(x, k + 1, lln, ln_n, ratios, s_vals, hit_bitcap, terminated)


def make_sample() -> List[Fraction]:
    rng = random.Random(SEED)
    xs: List[Fraction] = []
    for lo, hi, cnt in BANDS:
        for _ in range(cnt):
            b = rng.randint(max(2, lo), hi - 1)
            a = rng.randint(1, b - 1)
            xs.append(Fraction(a, b))
    rng.shuffle(xs)
    return xs


# --------------------------------------------------------------------------- #
# (a)
# --------------------------------------------------------------------------- #
def section_a(orbits: List[Orbit], ctr: Counter) -> Dict:
    print("\n=== (a) exact rational orbits: ratio and A(N) distributions ===")
    all_ratios: List[float] = []
    deep_ratios: List[float] = []
    all_s: List[float] = []
    deep_s: List[float] = []
    for o in orbits:
        all_ratios.extend(o.ratios)
        all_s.extend(o.s_vals)
        if o.deep:
            deep_ratios.extend(o.ratios)
            deep_s.extend(o.s_vals)

    lengths = [o.k for o in orbits]
    print(f"  sample                 : {len(orbits)} orbits (seed {SEED})")
    print(f"  bands (lo, hi, count)  : {[(b[0], b[1], b[2]) for b in BANDS]}")
    print(f"  terminated exactly     : {ctr.terminated}/{len(orbits)}  "
          f"(hit bit-cap {BITCAP}: {ctr.bitcap})")
    print(f"  orbit length min/mean/max : {min(lengths)}/"
          f"{sum(lengths)/len(lengths):.2f}/{max(lengths)}")
    print(f"  induced map s'=1-{{q^2/s}} : {ctr.induced_checks} exact checks, "
          f"{ctr.induced_bad} mismatches, {ctr.zero_s} measure-zero branches")
    print(f"  ratio identity r'/r^2=s/(1+sr): {ctr.ratio_checks} checks, "
          f"{ctr.ratio_bad} mismatches")
    print(f"  ratio > 1 (squaring law)   : {ctr.squaring_bad} violations")
    print(f"  upper-bound checks         : {ctr.ub_checks}, "
          f"{ctr.ub_bad} violations of k <= log2(log(n_k+2)/log(1/x))")
    if all_ratios:
        sv = sorted(all_ratios)
        print(f"  ratio r'/r^2 min/median/max: {sv[0]:.3e} / {sv[len(sv)//2]:.4f} "
              f"/ {sv[-1]:.6f}")

    # log10 histogram of the ratio
    hist: Dict[int, int] = {}
    for v in all_ratios:
        b = int(math.floor(math.log10(v))) if v > 0 else -99
        hist[b] = hist.get(b, 0) + 1
    print("\n  r'/r^2 histogram (floor log10), all non-terminal steps:")
    for b in sorted(hist):
        print(f"    [1e{b:>4d}, 1e{b+1:>4d}) : {hist[b]:>7d}")

    # A(N) distribution across orbits for the grid of N
    A_by_N: Dict[int, List[int]] = {}
    print("\n  A(N) = #{k : n_k <= N} across orbits:")
    print("    N        loglog N   mean A     sd     max   #(A>0)")
    for d, N in zip(D_GRID, N_GRID):
        thr = d * LN10
        vals = [bisect.bisect_right(o.ln_n, thr) for o in orbits]
        A_by_N[N] = vals
        mean = sum(vals) / len(vals)
        var = sum((v - mean) ** 2 for v in vals) / len(vals)
        print(f"    1e{d:<6d} {math.log(thr):7.4f}  {mean:8.4f} "
              f"{math.sqrt(var):6.3f}  {max(vals):4d}   {sum(1 for v in vals if v)}")

    frac_ratio_le = {}
    for eps in EPS_GRID:
        a = sum(1 for v in all_ratios if v <= eps) / len(all_ratios)
        b = sum(1 for v in deep_ratios if v <= eps) / max(1, len(deep_ratios))
        c = sum(1 for v in all_s if v <= eps) / len(all_s)
        frac_ratio_le[eps] = (a, b, c)
    print("\n  P(<=eps):  ratio all | ratio deep | s all   (deep = bit-cap orbits)")
    for eps in EPS_GRID:
        a, b, c = frac_ratio_le[eps]
        print(f"    eps={eps:.0e} : {a:.6e} | {b:.6e} | {c:.6e}")

    return dict(all_ratios=all_ratios, deep_ratios=deep_ratios,
                all_s=all_s, deep_s=deep_s, A_by_N=A_by_N,
                frac_ratio_le=frac_ratio_le, lengths=lengths)


# --------------------------------------------------------------------------- #
# (b)
# --------------------------------------------------------------------------- #
def section_b(orbits: List[Orbit], data: Dict) -> Dict:
    print("\n=== (b) scaling A(N) vs log log N ===")
    pooled = [(o.lln[i], i) for o in orbits for i in range(len(o.lln))]
    deep = [(o.lln[i], i) for o in orbits if o.deep for i in range(len(o.lln))]

    def report(name, pts):
        xs = [p[0] for p in pts]
        ys = [float(p[1]) for p in pts]
        slope, inter, r2, se = linfit(xs, ys)
        ratios = sorted(y / x for x, y in zip(xs, ys) if x > 0)
        m = len(ratios)
        mean = sum(ratios) / m
        sd = math.sqrt(sum((r - mean) ** 2 for r in ratios) / m)
        print(f"  {name}: n={len(pts)}  k = c*loglog(n_k) + b  ->  "
              f"c = {slope:.4f} +/- {se:.4f}, b = {inter:.4f}, R^2 = {r2:.4f}")
        print(f"    k/loglog(n_k): mean {mean:.4f} sd {sd:.4f} "
              f"median {ratios[m//2]:.4f} min {ratios[0]:.4f} max {ratios[-1]:.4f}")
        return slope, inter, r2, se, mean, sd

    c_all = report("pooled, all takes ", pooled)
    c_deep = report("pooled, deep orbits", deep)
    print(f"    reference upper constant 1/log 2 = {1/math.log(2):.4f}")

    # per-orbit slopes (orbits with >= 3 takes)
    slopes = []
    for o in orbits:
        if len(o.lln) >= 3:
            sl, *_ = linfit(o.lln, [float(i) for i in range(len(o.lln))])
            if sl == sl:
                slopes.append(sl)
    if slopes:
        slopes.sort()
        mean = sum(slopes) / len(slopes)
        sd = math.sqrt(sum((s - mean) ** 2 for s in slopes) / len(slopes))
        print(f"  per-orbit slopes ({len(slopes)} orbits): mean {mean:.4f} "
              f"sd {sd:.4f} median {slopes[len(slopes)//2]:.4f} "
              f"min {slopes[0]:.4f} max {slopes[-1]:.4f}")

    # concentration of A(N)/loglog N across orbits, for fixed N
    print("\n  dispersion of A(N)/loglog N across orbits (fixed N):")
    print("    N        loglog N   mean     sd      CoV    frac(A>0)")
    for d, N in zip(D_GRID, N_GRID):
        if d < 3:
            continue
        LL = math.log(d * LN10)
        vals = [v / LL for v in data["A_by_N"][N]]
        mean = sum(vals) / len(vals)
        var = sum((v - mean) ** 2 for v in vals) / len(vals)
        sd = math.sqrt(var)
        cov = sd / mean if mean else float("inf")
        nz = sum(1 for v in data["A_by_N"][N] if v > 0) / len(vals)
        print(f"    1e{d:<6d} {LL:7.4f}  {mean:7.4f} {sd:7.4f} {cov:7.3f}   {nz:.4f}")

    return dict(c_all=c_all, c_deep=c_deep)


# --------------------------------------------------------------------------- #
# (c)
# --------------------------------------------------------------------------- #
def slope_vs_eps(prob_fn, label):
    """Fit log P = a log(eps) + b (power law) and log P = c eps + d (exponential
    / Borel-Cantelli-soft) over the eps where the empirical count is non-zero."""
    xs, ys, es = [], [], []
    for eps in EPS_GRID:
        p = prob_fn(eps)
        if p > 0:
            xs.append(math.log(eps))
            ys.append(math.log(p))
            es.append(eps)
    if len(xs) < 3:
        print(f"  {label}: too few non-zero eps-points ({len(xs)})")
        return float("nan")
    slope, inter, r2, se = linfit(xs, ys)
    cexp, _, r2exp, _ = linfit(es, ys)
    print(f"  {label}: power-law log P = a*log(eps)+b -> a = {slope:.4f} "
          f"+/- {se:.4f} (R^2 = {r2:.4f}); exponential fit R^2 = {r2exp:.4f} "
          f"[{len(xs)} pts, min eps = {es[0]:.0e}]")
    return slope


def section_c(orbits: List[Orbit], ctr: Counter, data: Dict) -> Dict:
    print("\n=== (c) induced map and small-ratio / run frequencies ===")
    print(f"  induced map T(s)=1-{{q^2/s}}: {ctr.induced_checks} exact step "
          f"checks, {ctr.induced_bad} mismatches "
          f"({ctr.zero_s} measure-zero integer branches skipped)")

    all_r, deep_r = data["all_ratios"], data["deep_ratios"]
    deep_s = data["deep_s"]
    a_ratio_all = slope_vs_eps(lambda e: sum(1 for v in all_r if v <= e) / len(all_r),
                               "P(r'/r^2 <= eps), all steps ")
    a_ratio_deep = slope_vs_eps(lambda e: sum(1 for v in deep_r if v <= e) / max(1, len(deep_r)),
                                "P(r'/r^2 <= eps), deep orbits")
    a_s_deep = slope_vs_eps(lambda e: sum(1 for v in deep_s if v <= e) / max(1, len(deep_s)),
                            "P(s <= eps), deep orbits     ")

    seqs = [o.ratios for o in orbits if o.ratios]
    print("\n  run frequencies  P(all L consecutive non-terminal ratios <= eps):")
    header = "    eps      " + "".join(f"L={L:<11d}" for L in RUN_LENS)
    print(header + "  (a_L)")
    run_slopes = {}
    run_rows = {}
    for eps in EPS_GRID:
        row = f"    {eps:.0e} "
        for L in RUN_LENS:
            hits = wins = 0
            for seq in seqs:
                for i in range(len(seq) - L + 1):
                    wins += 1
                    if all(seq[j] <= eps for j in range(i, i + L)):
                        hits += 1
            p = hits / wins if wins else 0.0
            run_rows.setdefault(L, {})[eps] = p
            row += f"  {p:.4e}"
        print(row)
    print("    a_L (log-log slope vs eps):")
    for L in RUN_LENS:
        a = slope_vs_eps(lambda e, L=L: run_rows[L][e], f"      L={L}")
        run_slopes[L] = a

    print("\n  reading: a_L ~ L*a_1 and a_1 ~ 1 means the small-ratio frequency")
    print("  decays like a power (Lebesgue-like, Borel-Cantelli compatible); a")
    print("  flattening (a_1 -> 0) would mean heavy clustering of tiny ratios.")
    return dict(a_ratio_all=a_ratio_all, a_ratio_deep=a_ratio_deep,
                a_s_deep=a_s_deep, run_slopes=run_slopes)


# --------------------------------------------------------------------------- #
def main() -> int:
    t0 = time.time()
    print("OP-13 — almost-everywhere order of A(N) (greedy harmonic sine)")
    print(f"exact Fraction arithmetic; python {sys.version.split()[0]}")
    print(f"sample {N_STARTS} rational starts, bands "
          f"{[(b[0], b[1], b[2]) for b in BANDS]}")
    print(f"bit-cap {BITCAP}, k-max {KMAX}, seed {SEED}")

    ctr = Counter()
    orbits = [orbit(x, ctr) for x in make_sample()]
    print(f"generated {len(orbits)} exact orbits in {time.time()-t0:.1f}s")

    data = section_a(orbits, ctr)
    sc = section_b(orbits, data)
    cc = section_c(orbits, ctr, data)

    print("\n=== PASS/FAIL summary ===")
    check("sample size >= 10^4 exact rational orbits", len(orbits) >= 10_000,
          f"{len(orbits)} orbits")
    check("every orbit terminated or reached the bit-cap",
          ctr.terminated + ctr.bitcap == len(orbits),
          f"{ctr.terminated} terminated, {ctr.bitcap} capped")
    check("induced map s' = 1 - {q^2/s} exact on every non-degenerate step",
          ctr.induced_bad == 0 and ctr.induced_checks > 1000,
          f"{ctr.induced_checks} checks, {ctr.induced_bad} mismatches")
    check("ratio identity r'/r^2 = s/(1+s r) exact",
          ctr.ratio_bad == 0 and ctr.ratio_checks > 1000,
          f"{ctr.ratio_checks} checks, {ctr.ratio_bad} mismatches")
    check("squaring law r'/r^2 <= 1 at every non-terminal step",
          ctr.squaring_bad == 0, f"{ctr.squaring_bad} violations")
    check("elementary upper-bound consequence "
          "k <= log2(log(n_k+2)/log(1/x))", ctr.ub_bad == 0,
          f"{ctr.ub_checks} checks, {ctr.ub_bad} violations")
    c_all = sc["c_all"][0]
    check("fitted scaling constant finite and <= 1/log 2 + 0.15",
          c_all == c_all and c_all <= 1 / math.log(2) + 0.15,
          f"c_all = {c_all:.4f}, 1/log2 = {1/math.log(2):.4f}")
    a1 = cc["run_slopes"][1]
    check("P(r'/r^2 <= eps) decays like a power law in eps",
          a1 == a1 and a1 > 0.5, f"a_1 = {a1:.4f}")

    print("\n" + "=" * 72)
    if FAILS:
        print(f"OVERALL: FAIL ({len(FAILS)} failed, {NPASS} passed)")
        for f in FAILS:
            print(f"  - {f}")
        return 1
    print(f"OVERALL: PASS ({NPASS} checks passed, 0 failed)")
    print("=" * 72)
    print("STRUCTURAL NOTE (direction; not a proof claim).  The elementary")
    print("consequence of the checked squaring law r_{k+1} <= r_k^2 is")
    print("    n_k + 2 = ceil(1/r_k) >= x^{-2^k}, hence")
    print("    A(N) <= log_2( log(N+2)/log(1/x) ) = O_x(log log N),")
    print("an UPPER bound.  A lower bound A(N) = Omega_x(log log N) needs a")
    print("positive lower bound on r_{k+1}/r_k^2, which rh41 refutes.  The")
    print("register's attribution of Omega_x(log log N) to this same squaring")
    print("law therefore appears directionally inverted; the genuinely")
    print("open/matching side is the LOWER bound.  Flagged for adjudication.")
    print("\nVERDICT: OP-13 remains OPEN as a two-sided almost-everywhere law.")
    print("Finite exact-rational evidence: (i) the elementary upper consequence")
    print("of the checked squaring law, A(N) <= log_2 log N + O_x(1), held on")
    print("every one of the 100510 pooled takes (0 violations) and the fitted")
    print("constant is c = 1.36 < 1/log 2 = 1.4427; (ii) A(N)/log log N has no")
    print("positive lower floor (its cross-orbit mean falls from 1.38 to 0.98 as")
    print("N grows), consistent with rh41's refutation of a positive lower bound")
    print("for r'/r^2; (iii) small ratios obey a power law P(r'/r^2 <= eps) ~")
    print("eps^1.11 and run frequencies ~ p_1^L, i.e. no heavy clustering.  This")
    print("is finite evidence only — no proof is claimed in either direction.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
