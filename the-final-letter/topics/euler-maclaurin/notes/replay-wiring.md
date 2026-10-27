# Replay wiring — P1 specification

**Status:** implemented in rectangle form. Design note plus implementation
record. The analytic inputs were already Lean theorems; the lowering is now
done for `Re s > 1` in
[`../../partial-sum-plus-tail/lean/ReplayGeneral.lean`](../../partial-sum-plus-tail/lean/ReplayGeneral.lean)
(`zeta_mem_box`, T44–T49). The eta reduction to `0 < Re s ≤ 1` and a symbolic
single-`Expr` emission remain open. This note keeps the interface so the
remaining work does not re-derive it.

## 1. Why this is the next theorem

`EulerMaclaurin.lean` proves, for `K ≥ 1` and `Re s > 1`,

```
hurwitzZetaNP a s =
  (Σ_{k<M} (a+k)^(-s)) + ∫_M^∞ (a+x)^(-s) dx + b^(-s)/2
  + Σ_{j=1}^K B_{2j}/(2j)! · (s)_{2j-1} · b^(-s-2j+1)
  + R_K(s)
```

and

```
‖R_K(s)‖ ≤ ‖(s)_{2K+1}‖ · 2ζ(2K+1)/(2π)^(2K+1)
             · (a+M)^(-σ-2K)/(σ+2K).
```

The evaluator's `Expr` language supports atoms, `add`, `sub`, `neg`, `scale`,
`mul` and `inflate`. It does **not** currently have an integration operator, a
derivative operator, or an infinite-tail operator. The S1 right-hand side
therefore cannot be transcribed literally. The wiring theorem has to choose one
of two designs.

### Design A — opaque bounded atoms

Add atoms for the two non-rational pieces:

- the integral `I = ∫_M^∞ (a+x)^(-s) dx`;
- the Bernoulli correction terms, each already a finite rational combination
  times derivative values.

Each atom carries a rational box proved by a separate lemma. The certificate
then only checks the rational combination. This is the smallest change to the
certificate language, but it moves the analytic content into atom lemmas, which
is exactly what the current `ReplayAtoms.lean` pattern already does for
transcendentals.

### Design B — absorb the integral into the remainder

Rewrite S1 so that the integral is bounded by the same S2 machinery, producing
a pure partial-sum-plus-remainder statement. This is cleaner conceptually but
requires a second Euler–Maclaurin rearrangement and a new bound for the
integral. It is more analysis than Design A.

**Recommendation:** Design A for P1, with the atom lemma statements below. It
mirrors the existing atom-discharge architecture and keeps the analytic
theorems unchanged.

## 2. Target Lean interface

The theorem should produce a closed enclosure, not an atom hypothesis:

```lean
namespace PartialTail

/-- A closed rational rectangle containing `ζ(s)` for `s` in `S`. -/
theorem zeta_replay_mem
    (S : Cx) (hS : 0 < S.re.lo) (M K : ℕ)
    (hM : 1 ≤ M) (hK : 1 ≤ K) :
    ∃ box : Cx, box.width ≤ targetWidth M K ∧
      ∀ s : ℂ, Cx.mem s S → Cx.mem (zetaValue s) box := ...
```

For the concrete ζ(2) replay the quantifier collapses to a point, and the
existing `cert_mem_closed` is the model. The general theorem needs:

- `zetaValue` or the existing Mathlib `riemannZeta` on the domain;
- a proof that `Cx.mem s S` implies `0 < s.re` and `s ≠ 0, 1`;
- the S1/S2 theorem at `a = 1`, `M`, `K`;
- an atom lemma for the integral;
- an atom lemma for each Bernoulli correction;
- the certificate checker `Expr.wf_sound` for the rational combination.

## 3. Decomposition into lemmas

### W1 — Domain bridge

```lean
lemma zeta_eq_hurwitzZetaNP_of_mem
    {S : Cx} (hS : 0 < S.re.lo) {s : ℂ} (hs : Cx.mem s S) :
    riemannZeta s = hurwitzZetaNP 1 s
```

Status: **proved** as `zeta_eq_hurwitzZetaNP_one`. `hurwitzZetaNP_eq_hurwitzZeta_of_mem_Ico` relates
the non-periodic and periodic Hurwitz zeta for `a ∈ [0,1)`. At `a = 1` the
relation to `riemannZeta` needs the standard `ζ(s) = ζ(s,1)` identity. This is
the first concrete gap.

### W2 — Integral atom

```lean
lemma integral_atom_mem
    (a : ℝ) (ha : 0 < a) (M : ℕ) (hM : 1 ≤ M) (S : Cx)
    (hS : 0 < S.re.lo) :
    ∃ J : Cx, ∀ s : ℂ, Cx.mem s S →
      Cx.mem (∫ x in Set.Ioi (M : ℝ), ((a + x : ℝ) : ℂ) ^ (-s)) J
```

Status: **proved** as `norm_integral_le_radius`, with the rational radius
`integralRadius S M = (M+1)^(1-⌊Re lo⌋)/(Re lo−1)`. The bound is crude by
design; a narrow box needs interval integration.

### W3 — Bernoulli atom

For each `j`, the term is

```
B_{2j}/(2j)! · (s)_{2j-1} · b^(-s-2j+1).
```

The Bernoulli number is rational and exact; `(s)_{2j-1}` is a polynomial in
`s`; `b^(-s-2j+1)` is an exponential. The exponential is already covered by
`Transcend.lean` (`exp`), and the polynomial by rational interval arithmetic.

Status: **proved** as `norm_cpow_neg_le_radius`, `norm_cpow_neg_sub_le`,
`norm_iteratedDeriv_le` and `norm_bernoulli_le`. The power bound is the crude
`‖b^{−s}‖ ≤ b^{−⌊Re lo⌋}`; no complex `exp`/`cos` box is needed for existence.

### W4 — Tail radius

```lean
lemma tail_radius_mem
    (a : ℝ) (ha : 0 < a) (M K : ℕ) (hM : 1 ≤ M) (hK : 1 ≤ K) (S : Cx)
    (hS : 0 < S.re.lo) :
    ∃ T : Cx, ∀ s : ℂ, Cx.mem s S →
      ‖R_K(s)‖ ≤ T.hi ∧ Cx.mem (0 : ℂ) T
```

Status: **proved** as `norm_tail_le`, using `riemannZeta_nat_re_le_two`
(`ζ(2K+1) ≤ 2`), `π ≥ 3`, a rising-factorial bound on the rectangle, and the
crude decay `(1+M)^{−σ−2K} ≤ 1`. No monotonicity of the whole bound is claimed.

### W5 — Certificate assembly

Given W2–W4, the rational combination is an `Expr`. `Expr.wf_sound` gives the
final box. The remaining work is to *emit* the `Expr` (or prove its `wf`
computes to `true`) for the general parameters, not just the concrete ζ(2)
replay.

Status: **proved in rectangle form** as `zeta_mem_box`: the box is a sum of
five balls (`sumBall` over the partial terms, integral, boundary, Bernoulli
corrections, tail), and each membership is discharged by W1–W4. A single
symbolic `Expr` whose `wf` is checked remains open, as does the eta extension.

## 4. What P1 does and does not buy

P1 gives a closed enclosure of `ζ(s)` for arbitrary `s` in a rational
rectangle, with no atom hypothesis. It is a genuine unconditional finite-scale
theorem.

It does **not**:

- prove a zero exists from a box containing `0`;
- prove an asymptotic statement;
- supply Weil positivity or any global input;
- certify the width unless W4/W5 also prove a target-width bound (that is P2).

So P1 closes R13, but not R14. R14 needs a theorem whose *premise* is an
enclosure; P1 is the library that makes such a premise usable.

## 5. P3 candidate after P1

The cleanest first R14 theorem is an interval-Newton isolation statement:

```lean
theorem zero_isolated_of_box
    (S : Cx) (hS : 0 < S.re.lo) (box : Cx)
    (hbox : Cx.mem (0 : ℂ) box)
    (hrep : ∀ s : ℂ, Cx.mem s S → Cx.mem (riemannZeta s) box)
    (hderiv : ∀ s ∈ S, ‖deriv riemannZeta s‖ ≤ L) :
    ∃! s ∈ S, riemannZeta s = 0
```

The enclosure discharges `hbox`; the derivative bound is a separate analytic
input. This is a finite-window theorem, not RH, but it is a real theorem with an
enclosure as a hypothesis. It is the smallest honest instance of R14.

## 6. Acceptance criteria for P1

1. `zeta_mem_box` compiles with no `sorry`, `axiom` or `admit`. **Met.**
2. It has no atom hypothesis: every atom is discharged by W1–W4. **Met.**
3. It specialises to ζ(2) (`zeta_two_mem_box`). It does not reproduce
   `cert_mem_closed`: the generated replay proves membership for
   `cert.eval σ`, not for `ζ(2)`, because the tail atom is `0`. **Met at the
   level of ζ(2), not at the level of the generated certificate.**
4. A Python test checks the emitted certificate against the independent
   verifier. **Not met:** the rectangle theorem does not emit an `Expr`; the
   width check is Lean-side (`WidthCheck.lean`).
5. `status.html` §7 moves P1 to partial and P2 to done (format); R15 is
   marked done as a format, R13 half done. **Met.**

## 7. Estimated order of work

1. W1 domain bridge (small, but needs the `ζ(s) = ζ(s,1)` identity).
2. W2 crude integral atom (moderate).
3. W3 Bernoulli atoms (routine, repetitive).
4. W4 uniform tail packaging (small).
5. W5 general `Expr` emission (largest; may need a certificate DSL change).

The first two are the right next Lean files. Neither requires new mathematics;
both require careful interval bookkeeping.

[Back to the dossier](../README.md) · [Status](../../../status.html) · [Proof ledger C](../../../categories/05-proofs/proofs.md#c-the-certified-evaluation-layer)
