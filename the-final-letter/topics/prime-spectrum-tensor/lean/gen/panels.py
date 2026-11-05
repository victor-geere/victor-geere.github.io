#!/usr/bin/env python3
"""Emit the R2 density certificate for one value of c.

The output is a Lean file proving

    IntersectionForm.density (1/20) c ∈ Set.Icc LO HI

with LO, HI explicit rationals, by composing the lemmas already proved in
`prime-spectrum-tensor/lean`:

    panel_certificate_decay   (per panel)   -- PanelCertificate/PanelDecay
  → panel_glue                              -- PanelDecay
  → panel_step (cumulative, one lemma per panel, linear in P)
  → density_tail_le                         -- DensityTail

Per panel the script emits

  * an Ω enclosure at the midpoint, from `IntersectionForm.omega_mem_scaled`
    (`norm_num` on the rational bracket; the log argument is scaled by
    `4^j` so only ~45 series terms are needed even at `t = 60`);
  * a node value `w(m) = (1/400)·exp(−m²/400)·cos(c·m)` as a rational centre
    plus an absolute error, bracketed by `Real.exp_bound` and `CosBound`;
  * the panel certificate plus the node-bracket glue.

The panels are assembled by the cumulative lemmas `cum0, cum1, …`: `cum p`
encloses `∫_0^{e_{p+1}}` with the exact rational partial sums, and is obtained
from `cum (p-1)` and `hp p` by `PanelDecay.panel_step`.  This is linear in the
number of panels and avoids both a `P`-way `interval_cases` and the
superlinear `norm_num` evaluation of a deep `PanelChain` literal.

Usage
-----
    python3 panels.py --c 0 --out DensityC0.lean
    python3 panels.py --c 1/5 --h0 1/125 --h1 1/25 --out DensityC1.lean

Notes
-----
* All arithmetic is exact (Python `Fraction`); every number in the Lean file
  is recomputed exactly, and only `mpmath` reference values (for choosing the
  outward-rounded Ω bracket) are inexact.
* The exp bound uses a four-step squaring chain `x → x² → x⁴ → x⁸ → x¹⁶` so
  that every `norm_num` sees small integers.
"""

import argparse
import math
from fractions import Fraction as F

try:
    import mpmath as mp
    mp.mp.dps = 50
except ImportError:                                    # pragma: no cover
    mp = None

SIGMA = F(1, 20)
SIGMA2 = SIGMA * SIGMA          # 1/400
T_END = F(60)
OMEGA_N = 4                     # shift in the digamma expansion
OMEGA_M = 45                    # log series terms (scaled argument in [1,4))
OMEGA_SLACK = F(1, 10000)       # extra width of the emitted Ω bracket
EXP_TERMS = 10
COS_TERMS = 12
DEC = 24                        # decimals of the squaring/doubling chains
DEC_LOG = 12                    # decimals of the Taylor partial sums
REM_EXP = F(1, 10 ** 9)         # bound on the exp Taylor remainder
REM_COS = F(1, 10 ** 8)         # bound on the cos Taylor remainder
DEC_OUT = 15                    # decimals of the *emitted* brackets


# --------------------------------------------------------------------------
# formatting
# --------------------------------------------------------------------------

def rl(q):
    """A Lean real literal, parenthesised."""
    return f"(({q.numerator})/({q.denominator}) : ℝ)"


def ql(q):
    """A Lean rational literal, parenthesised."""
    return f"(({q.numerator})/({q.denominator}) : ℚ)"


def floor_at(q, d):
    s = 10 ** d
    return F(math.floor(q * s), s)


def ceil_at(q, d):
    s = 10 ** d
    return F(math.ceil(q * s), s)


def omega_ref(t):
    if mp is None:
        raise RuntimeError("mpmath is required for the Ω reference values")
    tf = mp.mpf(t.numerator) / mp.mpf(t.denominator)
    return mp.re(mp.digamma(mp.mpf(1) / 4 + 1j * tf / 2)) - mp.log(mp.pi)


# --------------------------------------------------------------------------
# exp(−y), y ∈ [0, 9], via (exp(−y/16))^16
# --------------------------------------------------------------------------

def exp_data(y):
    z = -F(y, 16)
    n = EXP_TERMS
    S = sum(F(z) ** k / F(math.factorial(k)) for k in range(n))
    Slo = floor_at(S - REM_EXP, DEC_LOG)
    Shi = ceil_at(S + REM_EXP, DEC_LOG)
    chain = [(Slo, Shi)]
    for _ in range(4):
        lo, hi = chain[-1]
        chain.append((floor_at(lo * lo, DEC), ceil_at(hi * hi, DEC)))
    final = (floor_at(chain[-1][0], DEC_OUT), ceil_at(chain[-1][1], DEC_OUT))
    return z, Slo, Shi, REM_EXP, chain, final


def exp_lemma(name, y, out):
    z, Slo, Shi, eps, chain, final = exp_data(y)
    lo16, hi16 = final
    zs = rl(z)
    out.append(f"/-- `exp(-({y}))`, via `(exp(-{y}/16))^16`. -/")
    out.append(f"theorem exp_{name}_mem :")
    out.append(f"    Real.exp (-{rl(y)}) ∈ Set.Icc {rl(lo16)} {rl(hi16)} := by")
    out.append(f"  have hz : |{zs}| ≤ 1 := by norm_num")
    out.append(f"  have hb := Real.exp_bound (x := {zs}) hz (n := {EXP_TERMS}) (by norm_num)")
    out.append(f"  have heps0 : |{zs}| ^ {EXP_TERMS} * "
               f"((↑(Nat.succ {EXP_TERMS}) : ℝ) / ((Nat.factorial {EXP_TERMS} : ℝ) * (↑{EXP_TERMS}))) "
               f"≤ (1 : ℝ) / (10 ^ 9 : ℝ) := by")
    out.append(f"    norm_num [Nat.factorial]")
    out.append(f"  have he : Real.exp {zs} ∈ Set.Icc {rl(chain[0][0])} {rl(chain[0][1])} := by")
    out.append(f"    have h1 : {rl(Slo)} ≤ "
               f"(∑ k ∈ Finset.range {EXP_TERMS}, {zs} ^ k / (k.factorial : ℝ)) - (1:ℝ)/(10^9:ℝ) := by")
    out.append(f"      norm_num [Finset.sum_range_succ, Nat.factorial]")
    out.append(f"    have h2 : (∑ k ∈ Finset.range {EXP_TERMS}, {zs} ^ k / (k.factorial : ℝ)) "
               f"+ (1:ℝ)/(10^9:ℝ) ≤ {rl(Shi)} := by")
    out.append(f"      norm_num [Finset.sum_range_succ, Nat.factorial]")
    out.append(f"    have hb' := hb")
    out.append(f"    rw [abs_le] at hb'")
    out.append(f"    constructor <;> linarith [hb'.1, hb'.2, heps0]")
    out.append(f"  have hmul : Real.exp (-{rl(y)}) = Real.exp {zs} ^ 16 := by")
    out.append(f"    rw [show (-{rl(y)}) = (16:ℝ) * {zs} by norm_num]")
    out.append(f"    rw [show (16:ℝ) * {zs} = ((16:ℕ):ℝ) * {zs} by norm_num]")
    out.append(f"    rw [Real.exp_nat_mul]")
    out.append(f"  rw [hmul]")
    out.append(f"  have hpow : Real.exp {zs} ^ 16 = "
               f"((((Real.exp {zs}) ^ 2) ^ 2) ^ 2) ^ 2 := by ring")
    out.append(f"  rw [hpow]")
    prev = "he"
    cur = f"Real.exp {zs}"
    for k in range(4):
        lo, hi = chain[k]
        nlo, nhi = chain[k + 1]
        nxt = f"hs{2 ** (k + 1)}"
        out.append(f"  have {nxt} : ({cur}) ^ 2 ∈ Set.Icc {rl(nlo)} {rl(nhi)} := by")
        out.append(f"    obtain ⟨h1, h2⟩ := {prev}")
        out.append(f"    constructor")
        out.append(f"    · calc {rl(nlo)} ≤ {rl(lo)} ^ 2 := by norm_num")
        out.append(f"        _ ≤ ({cur}) ^ 2 := pow_le_pow_left₀ (by positivity) h1 2")
        out.append(f"    · calc ({cur}) ^ 2 ≤ {rl(hi)} ^ 2 := "
                   f"pow_le_pow_left₀ (by positivity) h2 2")
        out.append(f"        _ ≤ {rl(nhi)} := by norm_num")
        prev = nxt
        cur = f"({cur}) ^ 2"
    out.append(f"  have hfin := {prev}")
    out.append(f"  obtain ⟨h1, h2⟩ := hfin")
    out.append(f"  constructor")
    out.append(f"  · have h3 : {rl(lo16)} ≤ {rl(chain[-1][0])} := by norm_num")
    out.append(f"    linarith")
    out.append(f"  · have h3 : {rl(chain[-1][1])} ≤ {rl(hi16)} := by norm_num")
    out.append(f"    linarith")
    out.append("")


# --------------------------------------------------------------------------
# cos(x), |x| ≤ 36, via six doublings from cos(x/64)
# --------------------------------------------------------------------------

def cos_doublings(x):
    """`d` with `|x| / 2^d ≤ 1` (and `d = 0` for `|x| ≤ 1`)."""
    ax = abs(x)
    d = 0
    while ax > 1:
        ax /= 2
        d += 1
    return d


def cos_data(x):
    d = cos_doublings(x)
    y = F(x) / (2 ** d)
    n = COS_TERMS
    P = sum(F((-1) ** (m // 2)) * y ** m / F(math.factorial(m))
            for m in range(n) if m % 2 == 0)
    eps = abs(y) ** n * F(n + 1) / (F(math.factorial(n)) * F(n))
    Plo = floor_at(P - REM_COS, 16)
    Phi = ceil_at(P + REM_COS, 16)
    chain = [(Plo, Phi)]
    for _ in range(d):
        lo, hi = chain[-1]
        if lo >= 0:
            sqlo, sqhi = lo * lo, hi * hi
        elif hi <= 0:
            sqlo, sqhi = hi * hi, lo * lo
        else:
            sqlo, sqhi = F(0), max(lo * lo, hi * hi)
        chain.append((floor_at(2 * sqlo - 1, DEC), ceil_at(2 * sqhi - 1, DEC)))
    final = (floor_at(chain[-1][0], DEC_OUT), ceil_at(chain[-1][1], DEC_OUT))
    return y, P, Plo, Phi, eps, chain, final, d


def cos_lemma(name, x, out):
    y, P, Plo, Phi, eps, chain, final, d = cos_data(x)
    yl = rl(y)
    out.append(f"/-- `cos({x})`, via {d} doublings from `cos({y})`. -/")
    out.append(f"theorem cos_{name}_mem : Real.cos {rl(x)} ∈ "
               f"Set.Icc {rl(final[0])} {rl(final[1])} := by")
    out.append(f"  have hx : |{yl}| ≤ 1 := by norm_num")
    out.append(f"  have hb := cos_bound_small (x := {yl}) hx (n := {COS_TERMS}) (by norm_num)")
    out.append(f"  have heps0 : |{yl}| ^ {COS_TERMS} * "
               f"((↑(Nat.succ {COS_TERMS}) : ℝ) / ((Nat.factorial {COS_TERMS} : ℝ) * (↑{COS_TERMS}))) "
               f"≤ (1 : ℝ) / (10 ^ 8 : ℝ) := by")
    out.append(f"    norm_num [Nat.factorial]")
    out.append(f"  have he : Real.cos {yl} ∈ Set.Icc {rl(chain[0][0])} {rl(chain[0][1])} := by")
    out.append(f"    have h1 : {rl(Plo)} ≤ "
               f"(∑ m ∈ Finset.range {COS_TERMS}, ((({yl} : ℝ) : ℂ) * Complex.I) ^ m / "
               f"(m.factorial : ℂ)).re - (1:ℝ)/(10^8:ℝ) := by")
    out.append(f"      norm_num [Finset.sum_range_succ, Nat.factorial, mul_pow, Complex.I_mul_I, Complex.div_re]")
    out.append(f"    have h2 : (∑ m ∈ Finset.range {COS_TERMS}, ((({yl} : ℝ) : ℂ) * Complex.I) ^ m / "
               f"(m.factorial : ℂ)).re + (1:ℝ)/(10^8:ℝ) ≤ {rl(Phi)} := by")
    out.append(f"      norm_num [Finset.sum_range_succ, Nat.factorial, mul_pow, Complex.I_mul_I, Complex.div_re]")
    out.append(f"    have hb' := hb")
    out.append(f"    rw [abs_le] at hb'")
    out.append(f"    constructor <;> linarith [hb'.1, hb'.2, heps0]")
    prev = "he"
    ang = yl
    for k in range(d):
        lo, hi = chain[k]
        nlo, nhi = chain[k + 1]
        nxt = f"hd{2 ** (k + 1)}"
        nang = f"(2:ℝ) * ({ang})"
        out.append(f"  have {nxt} : Real.cos ({nang}) ∈ "
                   f"Set.Icc {rl(nlo)} {rl(nhi)} := by")
        if lo >= 0:
            mv = hi
            out.append(f"    have hmax : max ({rl(lo)} ^ 2) ({rl(hi)} ^ 2) = {rl(hi)} ^ 2 := "
                       f"max_eq_right (by nlinarith)")
            out.append(f"    exact cos_double_mem_pos (nlo := {rl(nlo)}) (nhi := {rl(nhi)}) {prev} "
                       f"(by norm_num) hmax (by norm_num) (by norm_num)")
        elif hi < 0:
            out.append(f"    have hmax : max ({rl(lo)} ^ 2) ({rl(hi)} ^ 2) = {rl(lo)} ^ 2 := "
                       f"max_eq_left (by nlinarith)")
            out.append(f"    exact cos_double_mem_neg (nlo := {rl(nlo)}) (nhi := {rl(nhi)}) {prev} "
                       f"(by norm_num) hmax (by norm_num) (by norm_num)")
        else:
            mv = max(lo * lo, hi * hi)
            out.append(f"    have hmax : max ({rl(lo)} ^ 2) ({rl(hi)} ^ 2) = {rl(mv)} := by")
            out.append(f"      rcases le_total ({rl(lo)} ^ 2) ({rl(hi)} ^ 2) with h | h")
            out.append(f"      · rw [max_eq_right h]; norm_num")
            out.append(f"      · rw [max_eq_left h]; norm_num")
            out.append(f"    exact cos_double_mem_mixed (nlo := {rl(nlo)}) (nhi := {rl(nhi)}) {prev} "
                       f"(by norm_num) (by norm_num) (by norm_num) (by rw [hmax]; norm_num)")
        prev = nxt
        ang = nang
    out.append(f"  have hfin := {prev}")
    out.append(f"  have harg : {ang} = {rl(x)} := by norm_num")
    out.append(f"  rw [harg] at hfin")
    out.append(f"  obtain ⟨h1, h2⟩ := hfin")
    out.append(f"  constructor")
    out.append(f"  · have h3 : {rl(final[0])} ≤ {rl(chain[-1][0])} := by norm_num")
    out.append(f"    linarith")
    out.append(f"  · have h3 : {rl(chain[-1][1])} ≤ {rl(final[1])} := by norm_num")
    out.append(f"    linarith")
    out.append("")


# --------------------------------------------------------------------------
# one panel's data
# --------------------------------------------------------------------------

def panel_q(t, N):
    """`(N + 1/4)^2 + (t/2)^2`, exactly."""
    return (F(N) + F(1, 4)) ** 2 + (t / 2) ** 2


def log4_index(t, N):
    q = panel_q(t, N)
    j = 0
    while 4 ** (j + 1) <= q:
        j += 1
    return j


def omega_bracket(t):
    ref = omega_ref(t)
    sl = mp.mpf(OMEGA_SLACK.numerator) / OMEGA_SLACK.denominator
    lo = mp.floor((ref - sl) * 10 ** 8)
    hi = mp.ceil((ref + sl) * 10 ** 8)
    return F(int(lo), 10 ** 8), F(int(hi), 10 ** 8)


# --------------------------------------------------------------------------
# main emission
# --------------------------------------------------------------------------

OMEGA_SIMP = ("IntersectionForm.omegaLoS, IntersectionForm.omegaHiS, "
              "IntersectionForm.logPointLo, IntersectionForm.logPointHi, "
              "IntersectionForm.logPartialQ, IntersectionForm.logTermQ, "
              "IntersectionForm.logRemQ, IntersectionForm.panelQ, "
              "IntersectionForm.panelReW, IntersectionForm.panelImW, "
              "IntersectionForm.omegaTerm4, IntersectionForm.omegaSum, "
              "IntersectionForm.omegaRem, IntersectionForm.log4Lo, "
              "IntersectionForm.log4Hi, IntersectionForm.piHi, "
              "IntersectionForm.piLo, Finset.sum_range_succ")

PANELQ_SIMP = ("IntersectionForm.panelQ, IntersectionForm.panelReW, "
               "IntersectionForm.panelImW")


HEADER = """import Mathlib
{imports}import PanelDecay
import OmegaScaled
import LipSmall2
import CosBound
import DensityTail
import DensityDemo

/-!
# The density enclosure for `c = {c}`, generated by `gen/panels.py`

Graded partition of `[0,60]`: `{P0}` panels of width `1/{n0}` on `[0,1]`, then
`{P1}` panels of width `59/{n1}`.  `Ω` is enclosed at each midpoint by
`IntersectionForm.omega_mem_scaled`, the node values by `Real.exp_bound` and
`CosBound`, and the panels are glued by `PanelDecay.panel_step`.

Do not edit by hand: regenerate with the script.
-/

noncomputable section
open scoped BigOperators
set_option maxHeartbeats 8000000
set_option maxRecDepth 100000
namespace PrimeSpectrumTensor.{ns}

"""


def build_edges(n0, n1):
    assert n1 % 59 == 0 or True
    edges = [F(0)]
    for i in range(1, n0 + 1):
        edges.append(F(i, n0))
    for i in range(1, n1 + 1):
        edges.append(F(1) + F(59 * i, n1))
    return edges


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--c", default="0", help="the separation, e.g. 0, 1/5, 2/5, 3/5")
    ap.add_argument("--h0", default="1/125", help="panel width on [0,1]")
    ap.add_argument("--h1", default="1/20", help="panel width on [1,60]")
    ap.add_argument("--out", default="DensityGen.lean")
    ap.add_argument("--name", default="density_mem")
    ap.add_argument("--ns", default="Gen", help="namespace suffix")
    ap.add_argument("--start", type=int, default=0, help="first panel index (chunking)")
    ap.add_argument("--end", type=int, default=-1, help="one past the last panel index")
    ap.add_argument("--import", dest="prev", default="", help="previous chunk module")
    ap.add_argument("--final", action="store_true", help="emit the density theorem")
    args = ap.parse_args()

    c = F(args.c)
    h0 = F(args.h0)
    h1 = F(args.h1)
    n0 = int(round(1 / h0))
    n1 = int(round(59 / h1))
    edges = build_edges(n0, n1)
    P = len(edges) - 1
    p0 = args.start
    p1 = P if args.end < 0 else args.end
    mids = [(edges[p] + edges[p + 1]) / 2 for p in range(P)]
    wfun = "0" if c == 0 else rl(c)
    cout = "0" if c == 0 else rl(c)

    imports = f"import {args.prev}\n" if args.prev else ""
    out = [HEADER.format(c=args.c, P0=n0, P1=n1, n0=n0, n1=n1, P=P,
                         h=f"{float(T_END / P):.4f}", ns=args.ns, imports=imports)]

    # ---- per-node data -------------------------------------------------
    nodes = []
    for p, m in enumerate(mids):
        y = m * m * SIGMA2
        z, Slo, Shi, eeps, echain, efinal = exp_data(y)
        elo, ehi = efinal
        e0 = (elo + ehi) / 2
        epse = (ehi - elo) / 2
        if c == 0:
            w0 = floor_at(e0 / 400, DEC)
            eps = epse / 400 + (e0 / 400 - w0)
            if eps < epse / 400:
                eps = epse / 400
        else:
            x = c * m
            _, _, _, _, _, cchain, cfinal, _ = cos_data(x)
            clo, chi = cfinal
            c0 = (clo + chi) / 2
            epsc = (chi - clo) / 2
            w0 = floor_at(e0 * c0 / 400, DEC)
            base = (epse + abs(e0) * epsc) / 400
            eps = base + abs(e0 * c0 / 400 - w0)
        nodes.append((m, y, z, echain, e0, epse, w0, eps))

    # ---- per-panel numeric data (all panels, for the prefix sums) ------
    panels = []
    for p in range(P):
        m, y, z, echain, e0, epse, w0, eps = nodes[p]
        a, b = edges[p], edges[p + 1]
        h = b - a
        qlo, qhi = omega_bracket(m)
        qmid = (qlo + qhi) / 2
        j = log4_index(m, OMEGA_N)
        lip = F(6) / a if a >= 1 else F(10)
        sw = F(1, 400) / (1 + a * a / 400)
        delta = (qhi - qlo) / 2 + lip * h / 2
        E1 = ceil_at(abs(qmid) * h ** 3 / 1600 + delta * h * sw, DEC_OUT)
        R = qmid * h * w0
        E = ceil_at(E1 + abs(qmid) * h * eps, DEC_OUT)
        panels.append((a, b, m, h, qlo, qhi, qmid, j, lip, sw, delta, E1, R, E, w0, eps))

    # ---- exp / cos / w lemmas (this chunk only) -----------------------
    for p in range(p0, p1):
        m, y, z, echain, e0, epse, w0, eps = nodes[p]
        exp_lemma(f"n{p}", y, out)
        if c != 0:
            cos_lemma(f"n{p}", c * m, out)
    for p in range(p0, p1):
        m, y, z, echain, e0, epse, w0, eps = nodes[p]
        yl = rl(y)
        out.append(f"/-- The node weight `w({m})`, to absolute error `{float(eps):.3e}`. -/")
        out.append(f"theorem w{p}_mem : |weight {wfun} {rl(m)} - {rl(w0)}| ≤ {rl(eps)} := by")
        out.append(f"  unfold weight")
        out.append(f"  have harg : -((1/20 : ℝ) * {rl(m)}) ^ 2 = -{yl} := by norm_num")
        out.append(f"  rw [harg]")
        out.append(f"  obtain ⟨he1, he2⟩ := exp_n{p}_mem")
        out.append(f"  have hE : |Real.exp (-{yl}) - {rl(e0)}| ≤ {rl(epse)} := by")
        out.append(f"    rw [abs_le]")
        out.append(f"    constructor <;> linarith")
        if c == 0:
            cw = abs(e0 / 400 - w0)
            out.append(f"  simp only [zero_mul, Real.cos_zero, mul_one]")
            out.append(f"  have hd : (1/400 : ℝ) * Real.exp (-{yl}) - {rl(w0)} = "
                       f"(1/400) * (Real.exp (-{yl}) - {rl(e0)}) + "
                       f"((1/400) * {rl(e0)} - {rl(w0)}) := by ring")
            out.append(f"  rw [hd]")
            out.append(f"  have hc : |(1/400 : ℝ) * {rl(e0)} - {rl(w0)}| ≤ {rl(cw)} := by")
            out.append(f"    rw [abs_le]")
            out.append(f"    constructor <;> norm_num")
            out.append(f"  have h1 : |(1/400 : ℝ) * (Real.exp (-{yl}) - {rl(e0)})| ≤ "
                       f"(1/400) * {rl(epse)} := by")
            out.append(f"    rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 1/400)]")
            out.append(f"    exact mul_le_mul_of_nonneg_left hE (by norm_num)")
            out.append(f"  have hsum := abs_add_le ((1/400 : ℝ) * (Real.exp (-{yl}) - {rl(e0)})) "
                       f"((1/400) * {rl(e0)} - {rl(w0)})")
            out.append(f"  linarith")
        else:
            x = c * m
            _, _, _, _, _, cchain, cfinal, _ = cos_data(x)
            clo, chi = cfinal
            c0 = (clo + chi) / 2
            epsc = (chi - clo) / 2
            out.append(f"  have hcx : ({cout}) * {rl(m)} = {rl(x)} := by norm_num")
            out.append(f"  rw [hcx]")
            out.append(f"  obtain ⟨hc1, hc2⟩ := cos_n{p}_mem")
            out.append(f"  have hC : |Real.cos {rl(x)} - {rl(c0)}| ≤ {rl(epsc)} := by")
            out.append(f"    rw [abs_le]")
            out.append(f"    constructor <;> linarith")
            out.append(f"  have hd : (1/400 : ℝ) * (Real.exp (-{yl}) * Real.cos {rl(x)}) - {rl(w0)} = "
                       f"(1/400) * ((Real.exp (-{yl}) - {rl(e0)}) * Real.cos {rl(x)} + "
                       f"{rl(e0)} * (Real.cos {rl(x)} - {rl(c0)})) + "
                       f"((1/400) * ({rl(e0)} * {rl(c0)}) - {rl(w0)}) := by ring")
            out.append(f"  rw [hd]")
            out.append(f"  have hcs : |Real.cos {rl(x)}| ≤ 1 := Real.abs_cos_le_one _")
            out.append(f"  have h1 : |(Real.exp (-{yl}) - {rl(e0)}) * Real.cos {rl(x)}| ≤ {rl(epse)} := by")
            out.append(f"    rw [abs_mul]")
            out.append(f"    calc |Real.exp (-{yl}) - {rl(e0)}| * |Real.cos {rl(x)}| ≤ {rl(epse)} * 1 := "
                       f"mul_le_mul hE hcs (abs_nonneg _) (by positivity : (0:ℝ) ≤ {rl(epse)})")
            out.append(f"      _ = {rl(epse)} := by ring")
            out.append(f"  have h2 : |{rl(e0)} * (Real.cos {rl(x)} - {rl(c0)})| ≤ {rl(abs(e0))} * {rl(epsc)} := by")
            out.append(f"    rw [abs_mul]")
            out.append(f"    have h4 : |{rl(e0)}| = {rl(abs(e0))} := by norm_num")
            out.append(f"    rw [h4]")
            out.append(f"    exact mul_le_mul_of_nonneg_left hC (by positivity)")
            out.append(f"  have h3 : |(1/400 : ℝ) * ({rl(e0)} * {rl(c0)}) - {rl(w0)}| ≤ "
                       f"{rl(abs(e0 * c0 / 400 - w0))} := by")
            out.append(f"    rw [abs_le]")
            out.append(f"    constructor <;> norm_num")
            out.append(f"  have hkey := abs_add_le ((1/400 : ℝ) * "
                       f"((Real.exp (-{yl}) - {rl(e0)}) * Real.cos {rl(x)} + "
                       f"{rl(e0)} * (Real.cos {rl(x)} - {rl(c0)}))) "
                       f"((1/400) * ({rl(e0)} * {rl(c0)}) - {rl(w0)})")
            out.append(f"  have h1' : |(1/400 : ℝ) * "
                       f"((Real.exp (-{yl}) - {rl(e0)}) * Real.cos {rl(x)} + "
                       f"{rl(e0)} * (Real.cos {rl(x)} - {rl(c0)}))| ≤ "
                       f"(1/400) * ({rl(epse)} + {rl(abs(e0) * epsc)}) := by")
            out.append(f"    rw [abs_mul, abs_of_pos (by norm_num : (0:ℝ) < 1/400)]")
            out.append(f"    have hs := abs_add_le "
                       f"((Real.exp (-{yl}) - {rl(e0)}) * Real.cos {rl(x)}) "
                       f"({rl(e0)} * (Real.cos {rl(x)} - {rl(c0)}))")
            out.append(f"    nlinarith")
            out.append(f"  linarith")
        out.append("")

    # ---- omega lemmas and panel certificates (this chunk only) --------
    for p in range(p0, p1):
        a, b, m, h, qlo, qhi, qmid, j, lip, sw, delta, E1, R, E, w0, eps = panels[p]
        mq = rl(m)
        out.append(f"/-- `Ω` at the midpoint `{m}` of panel {p}: `{qlo} ≤ Ω ≤ {qhi}`. -/")
        out.append(f"theorem om{p} : {rl(qlo)} ≤ IntersectionForm.Omega {mq} ∧ "
                   f"IntersectionForm.Omega {mq} ≤ {rl(qhi)} := by")
        out.append(f"  have h := IntersectionForm.omega_mem_scaled {ql(m)} {OMEGA_N} {OMEGA_M} {j} "
                   f"(by norm_num) (by norm_num) (by norm_num [{PANELQ_SIMP}])")
        out.append(f"  have hq : {ql(qlo)} ≤ IntersectionForm.omegaLoS {ql(m)} {OMEGA_N} {OMEGA_M} {j} ∧ "
                   f"IntersectionForm.omegaHiS {ql(m)} {OMEGA_N} {OMEGA_M} {j} ≤ {ql(qhi)} := by")
        out.append(f"    constructor <;> norm_num [{OMEGA_SIMP}]")
        out.append(f"  have hq1 : {rl(qlo)} ≤ "
                   f"((IntersectionForm.omegaLoS {ql(m)} {OMEGA_N} {OMEGA_M} {j} : ℚ) : ℝ) := by")
        out.append(f"    have hcast : {rl(qlo)} = (({ql(qlo)} : ℚ) : ℝ) := by norm_num")
        out.append(f"    rw [hcast]")
        out.append(f"    exact_mod_cast hq.1")
        out.append(f"  have hq2 : "
                   f"((IntersectionForm.omegaHiS {ql(m)} {OMEGA_N} {OMEGA_M} {j} : ℚ) : ℝ) ≤ {rl(qhi)} := by")
        out.append(f"    have hcast : {rl(qhi)} = (({ql(qhi)} : ℚ) : ℝ) := by norm_num")
        out.append(f"    rw [hcast]")
        out.append(f"    exact_mod_cast hq.2")
        out.append(f"  exact ⟨by linarith [h.1, hq1], by linarith [h.2, hq2]⟩")
        out.append("")

        out.append(f"/-- Panel {p}: `[{a},{b}]`, midpoint `{m}`, lip `{lip}`. -/")
        out.append(f"theorem hp{p} : |(∫ x in {rl(a)}..{rl(b)}, weight {wfun} x * "
                   f"IntersectionForm.Omega x) - {rl(R)}| ≤ {rl(E)} := by")
        out.append(f"  have hpc := panel_certificate_decay (c := {cout}) (by norm_num)")
        out.append(f"    (a := {rl(a)}) (b := {rl(b)}) (qmlo := {rl(qlo)}) (qmhi := {rl(qhi)}) "
                   f"(lipx := {rl(lip)})")
        out.append(f"    (by norm_num) (by norm_num) (by norm_num)")
        if a >= 1:
            out.append(f"    (fun t ht => by")
            out.append(f"      have h1 : |deriv IntersectionForm.Omega t| ≤ 6 / t := "
                       f"deriv_Omega_abs_le_six (by linarith [ht.1])")
            out.append(f"      have h2 : 6 / t ≤ {rl(lip)} := by")
            out.append(f"        rw [div_le_div_iff₀ (by linarith [ht.1]) (by norm_num)]")
            out.append(f"        nlinarith [ht.1]")
            out.append(f"      linarith)")
        else:
            out.append(f"    (fun t _ => by simpa using deriv_Omega_abs_le_ten t)")
        out.append(f"    (by rw [show ({rl(a)} + {rl(b)}) / 2 = {rl(m)} by norm_num]; exact om{p}.1)")
        out.append(f"    (by rw [show ({rl(a)} + {rl(b)}) / 2 = {rl(m)} by norm_num]; exact om{p}.2)")
        qexpr = f"(({rl(qlo)} + {rl(qhi)}) / 2)"
        A = (f"({qexpr} - ({rl(qlo)} - {rl(lip)} * ({rl(b)} - {rl(a)}) / 2))")
        B = (f"(({rl(qhi)} + {rl(lip)} * ({rl(b)} - {rl(a)}) / 2) - {qexpr})")
        out.append(f"  have hE1 : |{qexpr}| * ((1/400) * ({rl(b)} - {rl(a)}) ^ 3 / 4) + "
                   f"max {A} {B} * (({rl(b)} - {rl(a)}) * ((1/400) / (1 + {rl(a)} ^ 2 / 400))) "
                   f"≤ {rl(E1)} := by")
        out.append(f"    have habs : |{qexpr}| = {rl(abs(qmid))} := by norm_num")
        out.append(f"    rw [habs]")
        out.append(f"    have hmax : max {A} {B} ≤ {rl(delta)} := max_le (by norm_num) (by norm_num)")
        out.append(f"    have hmul := mul_le_mul_of_nonneg_right hmax "
                   f"(by norm_num : (0:ℝ) ≤ ({rl(b)} - {rl(a)}) * ((1/400) / (1 + {rl(a)} ^ 2 / 400)))")
        out.append(f"    have hnum : {rl(abs(qmid))} * ((1/400) * ({rl(b)} - {rl(a)}) ^ 3 / 4) + "
                   f"{rl(delta)} * (({rl(b)} - {rl(a)}) * ((1/400) / (1 + {rl(a)} ^ 2 / 400))) "
                   f"≤ {rl(E1)} := by norm_num")
        out.append(f"    linarith")
        out.append(f"  have hpc' : |(∫ x in {rl(a)}..{rl(b)}, weight {wfun} x * "
                   f"IntersectionForm.Omega x) - "
                   f"(({rl(qlo)} + {rl(qhi)}) / 2) * (({rl(b)} - {rl(a)}) * "
                   f"weight {wfun} (({rl(a)} + {rl(b)}) / 2))| ≤ {rl(E1)} := by")
        out.append(f"    exact le_trans hpc hE1")
        out.append(f"  have hw := w{p}_mem")
        out.append(f"  have hw' : |weight {wfun} (({rl(a)} + {rl(b)}) / 2) - {rl(w0)}| ≤ {rl(eps)} := by")
        out.append(f"    convert hw using 1 <;> norm_num")
        out.append(f"  have hglue := panel_glue (c := {cout}) (a := {rl(a)}) (b := {rl(b)}) "
                   f"(qmlo := {rl(qlo)}) (qmhi := {rl(qhi)}) (E1 := {rl(E1)}) "
                   f"(w0 := {rl(w0)}) (eps := {rl(eps)}) (by norm_num) hpc' hw'")
        out.append(f"  have hR : (({rl(qlo)} + {rl(qhi)}) / 2) * (({rl(b)} - {rl(a)}) * {rl(w0)}) "
                   f"= {rl(R)} := by norm_num")
        out.append(f"  rw [hR] at hglue")
        out.append(f"  have habs' : |(({rl(qlo)} + {rl(qhi)}) / 2)| = {rl(abs(qmid))} := by norm_num")
        out.append(f"  have hEe : {rl(E1)} + |(({rl(qlo)} + {rl(qhi)}) / 2)| * ({rl(b)} - {rl(a)}) * "
                   f"{rl(eps)} ≤ {rl(E)} := by rw [habs']; norm_num")
        out.append(f"  exact le_trans hglue hEe")
        out.append("")

    # ---- cumulative assembly ------------------------------------------
    Tp = sum(panels[p][12] for p in range(p0))
    Sp = sum(panels[p][13] for p in range(p0))
    if p0 == 0:
        out.append("/-- Continuity of the panel integrand. -/")
        out.append(f"theorem hcont_w : Continuous (fun x => weight {wfun} x * "
                   f"IntersectionForm.Omega x) := by")
        out.append(f"  have h := (continuous_densityWeight ({cout})).mul continuous_Omega")
        out.append(f"  convert h using 1")
        out.append(f"  ext x")
        out.append(f"  simp only [Pi.mul_apply, weight_eq_densityWeight]")
        out.append("")
    for p in range(p0, p1):
        a, b, m, h, qlo, qhi, qmid, j, lip, sw, delta, E1, R, E, w0, eps = panels[p]
        prevT, prevS = Tp, Sp
        Tp = Tp + R
        Sp = Sp + E
        out.append(f"/-- The cumulative enclosure after panel {p}. -/")
        out.append(f"theorem cum{p} : |(∫ x in {rl(edges[0])}..{rl(edges[p + 1])}, "
                   f"weight {wfun} x * IntersectionForm.Omega x) - {rl(Tp)}| ≤ {rl(Sp)} := by")
        if p == 0:
            out.append(f"  exact hp0")
        else:
            out.append(f"  have h := panel_step (hcont := hcont_w) (T := {rl(prevT)}) (S := {rl(prevS)}) "
                       f"(R := {rl(R)}) (E := {rl(E)}) cum{p - 1} hp{p}")
            out.append(f"  convert h using 1 <;> norm_num")
        out.append("")

    if args.final:
        Etot = Sp
        T = Tp
        K = Etot + F(1, 10000)
        LO = T - K
        HI = T + K
        out.append(f"/-- **The density enclosure at `c = {args.c}`.** -/")
        out.append(f"theorem {args.name} : IntersectionForm.density (1/20) {cout} ∈ "
                   f"Set.Icc {rl(LO)} {rl(HI)} := by")
        out.append(f"  have hchain := cum{p1 - 1}")
        out.append(f"  have hint1 : MeasureTheory.IntegrableOn "
                   f"(fun x => weight {wfun} x * IntersectionForm.Omega x) (Set.Ioc 0 60) := by")
        out.append(f"    rw [← intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num : (0:ℝ) ≤ 60)]")
        out.append(f"    exact hcont_w.intervalIntegrable 0 60")
        out.append(f"  have hint2 : MeasureTheory.IntegrableOn "
                   f"(fun x => weight {wfun} x * IntersectionForm.Omega x) (Set.Ioi 60) := by")
        out.append(f"    have hgm := integrableOn_gaussian_moment (T := 60)")
        out.append(f"    refine MeasureTheory.Integrable.mono' hgm hcont_w.aestronglyMeasurable ?_")
        out.append(f"    filter_upwards [MeasureTheory.ae_restrict_mem measurableSet_Ioi] with x hx")
        out.append(f"    rw [Real.norm_eq_abs, weight_eq_densityWeight]")
        out.append(f"    exact abs_densityWeight_mul_Omega_le (le_of_lt (Set.mem_Ioi.mp hx))")
        out.append(f"  have htail : |∫ x in Set.Ioi (60:ℝ), weight {wfun} x * "
                   f"IntersectionForm.Omega x| ≤ 1/10000 := by")
        out.append(f"    have h := density_tail_le (c := {cout})")
        out.append(f"    convert h using 1")
        out.append(f"    · simp only [weight_eq_densityWeight]")
        out.append(f"  have hdens : IntersectionForm.density (1/20) {cout} = "
                   f"(∫ x in (0:ℝ)..60, weight {wfun} x * IntersectionForm.Omega x) + "
                   f"∫ x in Set.Ioi (60:ℝ), weight {wfun} x * IntersectionForm.Omega x := by")
        out.append(f"    unfold IntersectionForm.density")
        out.append(f"    have hfun : (fun t => IntersectionForm.densityWeight (1/20) {cout} t * "
                   f"IntersectionForm.Omega t) = "
                   f"(fun t => weight {wfun} t * IntersectionForm.Omega t) := by")
        out.append(f"      funext t")
        out.append(f"      rw [weight_eq_densityWeight]")
        out.append(f"    rw [hfun]")
        out.append(f"    exact integral_Ioi_split _ (by norm_num) hint1 hint2")
        out.append(f"  have hmain : |IntersectionForm.density (1/20) {cout} - {rl(T)}| ≤ "
                   f"{rl(Etot)} + 1/10000 := by")
        out.append(f"    rw [hdens]")
        out.append(f"    calc |((∫ x in (0:ℝ)..60, weight {wfun} x * IntersectionForm.Omega x) + "
                   f"∫ x in Set.Ioi (60:ℝ), weight {wfun} x * IntersectionForm.Omega x) - {rl(T)}|")
        out.append(f"        = |((∫ x in (0:ℝ)..60, weight {wfun} x * IntersectionForm.Omega x) - {rl(T)}) + "
                   f"∫ x in Set.Ioi (60:ℝ), weight {wfun} x * IntersectionForm.Omega x| := by ring_nf")
        out.append(f"      _ ≤ |(∫ x in (0:ℝ)..60, weight {wfun} x * IntersectionForm.Omega x) - {rl(T)}| + "
                   f"|∫ x in Set.Ioi (60:ℝ), weight {wfun} x * IntersectionForm.Omega x| := abs_add_le _ _")
        out.append(f"      _ ≤ {rl(Etot)} + 1/10000 := by linarith [hchain, htail]")
        out.append(f"  rw [abs_le] at hmain")
        out.append(f"  constructor <;> linarith [hmain.1, hmain.2]")
        out.append("")
    out.append(f"end PrimeSpectrumTensor.{args.ns}")

    open(args.out, "w").write("\n".join(out) + "\n")
    print(f"wrote {args.out}: chunk [{p0},{p1}) of P={P}, c={c}")
    print(f"  T  = {float(Tp):.12f}")
    print(f"  S  = {float(Sp):.4e}")


if __name__ == "__main__":
    main()
