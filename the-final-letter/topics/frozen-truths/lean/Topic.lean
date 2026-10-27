import Mathlib

/-!
# Frozen truths — formal core

This file formalises the small elementary core of `truths.md` that is
genuinely independent of the analytic estimates: the last-chord pairing
(§11.1–11.2), its self-dual scale, the boundary-term modulus, the
integer ratio identity (1.14), and the hyperbolic-cosine weight of the
cosine-kernel representation (§12.3, §13.3).

The Riemann-hypothesis-adjacent statements of the source — the uniform
Euler–Maclaurin expansions, the two-sided tracking, the Jensen/Li tower,
and the non-vanishing of `K(α,γ)` for `α ≠ 0` — are *not* proved here.
They are recorded as source claims in the programme dossier.
-/

noncomputable section

open Filter Topology

namespace FrozenTruths

/-- The unmatched last-chord boundary term
`H_N(s) = ((1 - N) / 2) * N ^ (-2s)`, as a real function of the real
exponent `s`. -/
def lastChord (N s : ℝ) : ℝ :=
  (1 - N) / 2 * N ^ (-(2 * s))

/-- The squared last-chord modulus `((N - 1)^2) / (4 N^2)`, i.e. the
constant value of `H_N(s) H_N(1 - s)` and the limit of its modulus
product as `N → ∞`. -/
def lastChordSquare (N : ℝ) : ℝ :=
  (N - 1) ^ 2 / (4 * N ^ 2)

/-- **Last-chord pairing (truths.md 11.1, 14.1).**
`H_N(s) H_N(1 - s)` is independent of `s` and equals
`(N - 1)^2 / (4 N^2)`. -/
theorem lastChord_mul_twin {N : ℝ} (hN : 0 < N) (s : ℝ) :
    lastChord N s * lastChord N (1 - s) = lastChordSquare N := by
  unfold lastChord lastChordSquare
  have hNr : N ^ (-(2 * s)) * N ^ (-(2 * (1 - s))) =
      N ^ (-2 : ℝ) := by
    rw [← Real.rpow_add hN]
    ring_nf
  calc
    (1 - N) / 2 * N ^ (-(2 * s)) *
          ((1 - N) / 2 * N ^ (-(2 * (1 - s))))
        = ((1 - N) / 2 * ((1 - N) / 2)) *
            (N ^ (-(2 * s)) * N ^ (-(2 * (1 - s)))) := by
          ring
    _ = ((1 - N) / 2 * ((1 - N) / 2)) * N ^ (-2 : ℝ) := by rw [hNr]
    _ = (N - 1) ^ 2 / (4 * N ^ 2) := by
          have h2 : N ^ (-2 : ℝ) = 1 / N ^ 2 := by
            rw [Real.rpow_neg (le_of_lt hN), Real.rpow_two]
            field_simp
          rw [h2]
          field_simp
          ring

/-- **Boundary-term modulus (truths.md 2.8, 11.2).** For `N > 1`,
`|H_N(σ)| = ((N - 1) / 2) N ^ (-2σ)`. -/
theorem lastChord_abs {N s : ℝ} (hN : 1 < N) :
    |lastChord N s| =
      (N - 1) / 2 * N ^ (-(2 * s)) := by
  unfold lastChord
  have hNpos : 0 < N := by linarith
  have hcoef : (1 - N) / 2 < 0 := by linarith
  have hpow : 0 < N ^ (-(2 * s)) := Real.rpow_pos_of_pos hNpos _
  rw [abs_mul, abs_of_neg hcoef, abs_of_pos hpow]
  ring

/-- **Uniqueness of the self-dual abscissa (truths.md 11.2, 14.4).**
For `N > 1`, the two twin moduli `|H_N(σ)|` and `|H_N(1 - σ)|` agree
exactly at `σ = 1/2`, and nowhere else. -/
theorem lastChord_twin_abs_eq_iff {N s : ℝ} (hN : 1 < N) :
    |lastChord N s| = |lastChord N (1 - s)| ↔ s = 1 / 2 := by
  rw [lastChord_abs hN, lastChord_abs hN]
  have hcoef : (N - 1) / 2 ≠ 0 := by linarith
  constructor
  · intro h
    have h' : N ^ (-(2 * s)) = N ^ (-(2 * (1 - s))) :=
      mul_left_cancel₀ hcoef h
    have hinj : Function.Injective (fun x : ℝ => N ^ x) :=
      (Real.strictMono_rpow_of_base_gt_one hN).injective
    have hexp := hinj h'
    linarith
  · intro h
    subst h
    ring_nf

/-- **The last-chord product tends to `1/4` (truths.md 11.1).** -/
theorem lastChord_limit :
    Tendsto (fun N : ℕ => lastChordSquare (N : ℝ)) atTop (𝓝 (1 / 4)) := by
  have hinv : Tendsto (fun N : ℕ => ((N : ℝ))⁻¹) atTop (𝓝 0) :=
    ((tendsto_inv_atTop_zero (𝕜 := ℝ)).comp tendsto_natCast_atTop_atTop)
  have hmain : Tendsto
      (fun N : ℕ => (1 : ℝ) / 4 - (1 / 2) * ((N : ℝ))⁻¹ +
        (1 / 4) * (((N : ℝ))⁻¹) ^ 2) atTop (𝓝 (1 / 4)) := by
    have h1 : Tendsto (fun N : ℕ => (1 : ℝ) / 4 - (1 / 2) * ((N : ℝ))⁻¹)
        atTop (𝓝 ((1 : ℝ) / 4 - (1 / 2) * 0)) :=
      tendsto_const_nhds.sub (tendsto_const_nhds.mul hinv)
    have h2 : Tendsto (fun N : ℕ => (1 : ℝ) / 4 * (((N : ℝ))⁻¹) ^ 2)
        atTop (𝓝 ((1 : ℝ) / 4 * 0 ^ 2)) :=
      tendsto_const_nhds.mul (hinv.pow 2)
    simpa using h1.add h2
  refine tendsto_congr' ?_ |>.mpr hmain
  filter_upwards [eventually_ne_atTop (0 : ℕ)] with N hN
  have hNr : (N : ℝ) ≠ 0 := by exact_mod_cast hN
  unfold lastChordSquare
  field_simp
  ring

/-- **The integer-ratio identity (truths.md 1.14).**
For positive reals `m, n`,
`exp(-|log(m/n)|) = min(m,n)/max(m,n)`. -/
theorem exp_neg_abs_log_ratio {m n : ℝ} (hm : 0 < m) (hn : 0 < n) :
    Real.exp (-|Real.log (m / n)|) = min m n / max m n := by
  have hm0 : m ≠ 0 := ne_of_gt hm
  have hn0 : n ≠ 0 := ne_of_gt hn
  rcases le_total m n with hmn | hnm
  · have hlog : Real.log (m / n) ≤ 0 := by
      rw [Real.log_div hm0 hn0]
      have hle : Real.log m ≤ Real.log n := Real.log_le_log hm hmn
      linarith
    rw [abs_of_nonpos hlog, neg_neg]
    rw [Real.exp_log (div_pos hm hn), min_eq_left hmn, max_eq_right hmn]
  · have hlog : 0 ≤ Real.log (m / n) := by
      rw [Real.log_div hm0 hn0]
      have hle : Real.log n ≤ Real.log m := Real.log_le_log hn hnm
      linarith
    rw [abs_of_nonneg hlog, Real.log_div hm0 hn0, neg_sub,
      Real.exp_sub, Real.exp_log hm, Real.exp_log hn,
      min_eq_right hnm, max_eq_left hnm]

/-- **The hyperbolic-cosine weight is strict (truths.md 12.3, 13.3).**
For `α ≠ 0` and `u > 0`, `1 < cosh(α u)`. -/
theorem cosh_weight_gt_one {α u : ℝ} (hα : α ≠ 0) (hu : 0 < u) :
    1 < Real.cosh (α * u) := by
  rw [Real.one_lt_cosh]
  exact mul_ne_zero hα (ne_of_gt hu)

/-- **The weight is even in `α` (truths.md 12.3).** -/
theorem cosh_weight_even (α u : ℝ) :
    Real.cosh (α * u) = Real.cosh ((-α) * u) := by
  rw [neg_mul, Real.cosh_neg]

end FrozenTruths
