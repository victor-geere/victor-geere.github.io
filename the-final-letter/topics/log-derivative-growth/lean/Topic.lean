import GaussianZeroSide
import ZeroTail
import ZetaStrip

/-!
# The linear Z'/Z growth bound — formal core

The programme reduces `VerticalLogDerivIntegrable` to the standard
Stirling-type bound `‖(Z'/Z)(x+iy)‖ ≤ M(1+|y|)` plus measurability.

This file harvests `verticalLogDerivIntegrable_of_linear_bound` and
`integrable_one_add_abs_mul_exp_neg_sq`, and adds the pointwise reduction
from separate upper/lower bounds on `Z` and `Z'` to a `Z'/Z` bound:

`‖Z'/Z‖ = ‖Z'‖ / ‖Z‖ ≤ b / a` whenever `a ≤ ‖Z‖` and `‖Z'‖ ≤ b`.

Supplying the two bounds from Stirling/zero-free estimates is the open
analytic obligation.
-/

noncomputable section
open Complex MeasureTheory

namespace LogDerivativeGrowth
open AbsoluteHodgeExplicitFormula AbsoluteHodgeSymbol AbsoluteHodgeHadamard
open AbsoluteHodgeZetaStrip
open Set
open scoped BigOperators

/-- **The Riemann zeta function is measurable.**  `ζ` is differentiable off
`1` and `{1}` is a singleton, so `measurable_of_measurable_on_compl_singleton`
applies. -/
theorem measurable_riemannZeta : Measurable (fun z : ℂ => riemannZeta z) := by
  refine measurable_of_measurable_on_compl_singleton (1 : ℂ) ?_
  have hcont : Continuous ({x : ℂ | x ≠ 1}.domRestrict riemannZeta) :=
    continuousOn_iff_continuous_domRestrict.mp differentiableOn_riemannZeta.continuousOn
  exact hcont.measurable

/-- **The completed zeta is measurable.** -/
theorem measurable_completedZeta : Measurable (fun z : ℂ => completedZeta z) := by
  unfold completedZeta
  have h1 : Measurable (fun z : ℂ => cexp (-(z / 2) * log (Real.pi : ℂ))) := by fun_prop
  have h2 : Measurable (fun z : ℂ => Gamma (z / 2)) := by measurability
  exact (h1.mul h2).mul measurable_riemannZeta

/-- **The logarithmic derivative `Z'/Z` is measurable.**  `deriv` is
measurable for an arbitrary function and division is continuous, so the
quotient is measurable with Lean's `1/0 = 0`. -/
theorem measurable_logDeriv_completedZeta :
    Measurable (fun z : ℂ => logDeriv completedZeta z) := by
  rw [show (fun z : ℂ => logDeriv completedZeta z)
      = fun z => deriv completedZeta z / completedZeta z from rfl]
  exact (measurable_deriv completedZeta).div measurable_completedZeta

/-- **The vertical-line product is `AEStronglyMeasurable`.**  This is the
measurability input of the vertical integrability theorem, proved rather than
assumed. -/
theorem aestronglyMeasurable_logDeriv_mul_gaussian (c σ x : ℝ) :
    AEStronglyMeasurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) := by
  have h1 : Measurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)) :=
    measurable_logDeriv_completedZeta.comp (by fun_prop)
  have h2 : Continuous (fun y : ℝ =>
      gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)) :=
    (continuous_gaussianZeroTest c σ).comp (by fun_prop)
  exact (h1.mul h2.measurable).aestronglyMeasurable

/-- Pointwise bound on the logarithmic derivative from separate bounds on
`f` and `f'`: if `0 < a ≤ ‖f s‖` and `‖deriv f s‖ ≤ b`, then
`‖logDeriv f s‖ ≤ b / a`. -/
theorem norm_logDeriv_le_of_bounds {f : ℂ → ℂ} {s : ℂ} {a b : ℝ}
    (ha : 0 < a) (hb : 0 ≤ b) (hlower : a ≤ ‖f s‖) (hupper : ‖deriv f s‖ ≤ b) :
    ‖logDeriv f s‖ ≤ b / a := by
  rw [logDeriv_apply, norm_div]
  exact div_le_div₀ hb hupper ha hlower

/-- Harvested: a linear `Z'/Z` bound gives vertical integrability of
`(Z'/Z)·H_c`. -/
theorem verticalLogDerivIntegrable_of_linear_bound (c σ x M : ℝ) (hσ : 0 < σ) (hM0 : 0 ≤ M)
    (hmeas : AEStronglyMeasurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))
    (hM : ∀ y : ℝ, ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * (1 + |y|)) :
    VerticalLogDerivIntegrable c σ x :=
  AbsoluteHodgeExplicitFormula.verticalLogDerivIntegrable_of_linear_bound c σ x M hσ hM0 hmeas hM

/-- Harvested: the polynomial-times-Gaussian majorant is integrable. -/
theorem integrable_one_add_abs_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Integrable (fun y : ℝ => (1 + |y|) * Real.exp (-(σ ^ 2 / 2) * y ^ 2)) :=
  AbsoluteHodgeExplicitFormula.integrable_one_add_abs_mul_exp_neg_sq σ hσ

/-- **Every absolute power times a Gaussian is integrable.**  This is the
`|y|^k` majorant needed for polynomial growth; the existing library only
supplies the linear case `k = 1`. -/
theorem integrable_abs_pow_mul_exp_neg_mul_sq (k : ℕ) {b : ℝ} (hb : 0 < b) :
    Integrable (fun y : ℝ => |y| ^ k * Real.exp (-b * y ^ 2)) := by
  set g : ℝ → ℝ := fun y => |y| ^ k * Real.exp (-b * y ^ 2) with hg
  have hk : (-1 : ℝ) < (k : ℝ) := by
    have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
    linarith
  have hIoi : IntegrableOn g (Ioi 0) := by
    refine (integrableOn_rpow_mul_exp_neg_mul_sq hb (s := (k : ℝ)) hk).congr_fun ?_
      measurableSet_Ioi
    intro x hx
    have hx0 : (0 : ℝ) ≤ x := le_of_lt hx
    simp [hg, abs_of_nonneg hx0, Real.rpow_natCast]
  have hIio : IntegrableOn g (Iio 0) := by
    rw [← Measure.map_neg_eq_self (volume : Measure ℝ)]
    let m : MeasurableEmbedding fun x : ℝ => -x := (Homeomorph.neg ℝ).measurableEmbedding
    rw [m.integrableOn_map_iff]
    have hpre : (fun x : ℝ => -x) ⁻¹' Iio 0 = Ioi 0 := by
      ext x
      simp
    rw [hpre]
    refine hIoi.congr_fun ?_ measurableSet_Ioi
    intro x _
    simp [hg, abs_neg]
  rw [← integrableOn_univ, ← Iio_union_Ici, integrableOn_union]
  refine ⟨hIio, ?_⟩
  rw [integrableOn_Ici_iff_integrableOn_Ioi]
  exact hIoi

/-- **Polynomial-times-Gaussian majorant is integrable in every degree.**
`(1+|y|)^k exp(−σ²y²/2)` is integrable for every `k`. -/
theorem integrable_one_add_abs_pow_mul_exp_neg_sq (k : ℕ) (σ : ℝ) (hσ : 0 < σ) :
    Integrable (fun y : ℝ => (1 + |y|) ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2)) := by
  have hb : (0 : ℝ) < σ ^ 2 / 2 := by positivity
  have h0 : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 / 2) * y ^ 2)) :=
    integrable_exp_neg_mul_sq hb
  have hk : Integrable (fun y : ℝ => |y| ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2)) :=
    integrable_abs_pow_mul_exp_neg_mul_sq k hb
  have hsum : Integrable (fun y : ℝ =>
      2 ^ (k - 1) * (Real.exp (-(σ ^ 2 / 2) * y ^ 2) +
        |y| ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2))) :=
    (h0.add hk).const_mul _
  refine hsum.mono' ?_ ?_
  · apply Measurable.aestronglyMeasurable
    fun_prop
  · filter_upwards with y
    have hpow : (1 + |y|) ^ k ≤ 2 ^ (k - 1) * (1 + |y| ^ k) := by
      have h := add_pow_le (zero_le_one : (0 : ℝ) ≤ 1) (abs_nonneg y) k
      simpa using h
    have hexp : 0 < Real.exp (-(σ ^ 2 / 2) * y ^ 2) := Real.exp_pos _
    have hnonneg : 0 ≤ (1 + |y|) ^ k := by positivity
    rw [Real.norm_eq_abs, abs_of_nonneg (mul_nonneg hnonneg hexp.le)]
    calc (1 + |y|) ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2)
        ≤ (2 ^ (k - 1) * (1 + |y| ^ k)) * Real.exp (-(σ ^ 2 / 2) * y ^ 2) :=
          mul_le_mul_of_nonneg_right hpow hexp.le
      _ = 2 ^ (k - 1) * (Real.exp (-(σ ^ 2 / 2) * y ^ 2) +
            |y| ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2)) := by ring

/-- **Polynomial growth suffices for the vertical integrability input.**  The
Stirling-type analytic bound only needs to be polynomial in `|y|`; the Gaussian
test function makes every polynomial majorant integrable.  This weakens the
linear hypothesis of the harvested `verticalLogDerivIntegrable_of_linear_bound`. -/
theorem verticalLogDerivIntegrable_of_polynomial_bound (c σ x M : ℝ) (k : ℕ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M)
    (hmeas : AEStronglyMeasurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))
    (hM : ∀ y : ℝ,
      ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * (1 + |y|) ^ k) :
    VerticalLogDerivIntegrable c σ x := by
  unfold VerticalLogDerivIntegrable
  set CH : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
    Real.exp (-(c * (x - 1 / 2))) with hCH
  have hCH0 : 0 ≤ CH := by rw [hCH]; positivity
  have hg : Integrable (fun y : ℝ =>
      M * CH * ((1 + |y|) ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2))) :=
    (integrable_one_add_abs_pow_mul_exp_neg_sq k σ hσ).const_mul (M * CH)
  refine hg.mono' hmeas ?_
  filter_upwards with y
  have hH := gaussianZeroTest_norm c σ x y hσ
  have hH' : ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ =
      CH * Real.exp (-(σ ^ 2 * y ^ 2)) := by
    rw [hH, hCH]
    rw [show σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) =
      σ ^ 2 * ((x - 1 / 2) ^ 2) + (-(σ ^ 2 * y ^ 2)) by ring, Real.exp_add]
    ring
  calc ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖
      = ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ *
          ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ := norm_mul _ _
    _ ≤ (M * (1 + |y|) ^ k) * (CH * Real.exp (-(σ ^ 2 * y ^ 2))) := by
        exact mul_le_mul (hM y) (le_of_eq hH') (norm_nonneg _)
          (mul_nonneg hM0 (by positivity : (0 : ℝ) ≤ (1 + |y|) ^ k))
    _ ≤ M * CH * ((1 + |y|) ^ k * Real.exp (-(σ ^ 2 / 2) * y ^ 2)) := by
        have hexp : Real.exp (-(σ ^ 2 * y ^ 2)) ≤ Real.exp (-(σ ^ 2 / 2) * y ^ 2) := by
          apply Real.exp_le_exp.mpr
          nlinarith [sq_nonneg y]
        have hpow : (0 : ℝ) ≤ (1 + |y|) ^ k := by positivity
        nlinarith [mul_nonneg hM0 hpow,
          mul_nonneg (mul_nonneg hM0 hCH0) hpow,
          Real.exp_pos (-(σ ^ 2 / 2) * y ^ 2), hexp]

/-- The polynomial-growth theorem specialises to the harvested linear bound. -/
theorem verticalLogDerivIntegrable_of_linear_bound' (c σ x M : ℝ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M)
    (hmeas : AEStronglyMeasurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))
    (hM : ∀ y : ℝ, ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * (1 + |y|)) :
    VerticalLogDerivIntegrable c σ x :=
  verticalLogDerivIntegrable_of_polynomial_bound c σ x M 1 hσ hM0 hmeas
    (fun y => by simpa using hM y)

/-- **Cauchy estimate plus the lower bound gives the `Z'/Z` bound.**  This is
the quantitative form of the programme's two-step reduction: a bound `M` on a
circle of radius `R` bounds `f'` at the centre by `M/R`, and a lower bound
`0 < a ≤ ‖f s‖` then bounds the logarithmic derivative by `M/(R a)`. -/
theorem norm_logDeriv_le_of_sphere_bound {f : ℂ → ℂ} {s : ℂ} {R M a : ℝ}
    (hR : 0 < R) (hf : DiffContOnCl ℂ f (Metric.ball s R)) (hM0 : 0 ≤ M)
    (hM : ∀ z ∈ Metric.sphere s R, ‖f z‖ ≤ M)
    (ha : 0 < a) (hlower : a ≤ ‖f s‖) :
    ‖logDeriv f s‖ ≤ M / (R * a) := by
  have hupper : ‖deriv f s‖ ≤ M / R :=
    norm_deriv_le_of_forall_mem_sphere_norm_le (c := s) hR hf hM
  have hb : 0 ≤ M / R := div_nonneg hM0 hR.le
  calc ‖logDeriv f s‖ ≤ (M / R) / a :=
        norm_logDeriv_le_of_bounds ha hb hlower hupper
    _ = M / (R * a) := by ring

/-- **The same bound for the completed zeta.**  Differentiability on the closed
ball is supplied by `differentiableAt_completedZeta_explicit`, away from `1`
and the Gamma poles. -/
theorem norm_logDeriv_completedZeta_le_of_sphere {s : ℂ} {R M a : ℝ}
    (hR : 0 < R) (hM0 : 0 ≤ M)
    (h1 : ∀ z ∈ Metric.closedBall s R, z ≠ 1)
    (hΓ : ∀ z ∈ Metric.closedBall s R, ∀ m : ℕ, z / 2 ≠ -(m : ℂ))
    (hM : ∀ z ∈ Metric.sphere s R, ‖completedZeta z‖ ≤ M)
    (ha : 0 < a) (hlower : a ≤ ‖completedZeta s‖) :
    ‖logDeriv completedZeta s‖ ≤ M / (R * a) := by
  refine norm_logDeriv_le_of_sphere_bound hR ?_ hM0 hM ha hlower
  refine ⟨?_, ?_⟩
  · intro z hz
    exact (differentiableAt_completedZeta_explicit
      (h1 z (Metric.ball_subset_closedBall hz))
      (hΓ z (Metric.ball_subset_closedBall hz))).differentiableWithinAt
  · rw [closure_ball s (ne_of_gt hR)]
    intro z hz
    exact (differentiableAt_completedZeta_explicit (h1 z hz) (hΓ z hz)).continuousAt.continuousWithinAt

/-- A point on a circle of radius `R` around `x + iy` has real part at least
`x - R`. -/
theorem re_ge_of_mem_sphere_sub (x R y : ℝ) {z : ℂ}
    (hz : z ∈ Metric.sphere ((x : ℂ) + (y : ℂ) * I) R) : x - R ≤ z.re := by
  have hdist : ‖z - ((x : ℂ) + (y : ℂ) * I)‖ ≤ R := by
    have h := Metric.mem_sphere.mp hz
    rw [dist_eq_norm] at h
    linarith
  have hre : (z - ((x : ℂ) + (y : ℂ) * I)).re = z.re - x := by simp
  have h1 : |(z - ((x : ℂ) + (y : ℂ) * I)).re| ≤
      ‖z - ((x : ℂ) + (y : ℂ) * I)‖ := Complex.abs_re_le_norm _
  have h2 : -R ≤ (z - ((x : ℂ) + (y : ℂ) * I)).re := by
    have hlow := (abs_le.mp h1).1
    linarith
  linarith

/-- The closed-ball version of `re_ge_of_mem_sphere_sub`. -/
theorem re_ge_of_mem_closedBall_sub (x R y : ℝ) {z : ℂ}
    (hz : z ∈ Metric.closedBall ((x : ℂ) + (y : ℂ) * I) R) : x - R ≤ z.re := by
  have hdist : ‖z - ((x : ℂ) + (y : ℂ) * I)‖ ≤ R := by
    have h := Metric.mem_closedBall.mp hz
    rw [dist_eq_norm] at h
    exact h
  have hre : (z - ((x : ℂ) + (y : ℂ) * I)).re = z.re - x := by simp
  have h1 : |(z - ((x : ℂ) + (y : ℂ) * I)).re| ≤
      ‖z - ((x : ℂ) + (y : ℂ) * I)‖ := Complex.abs_re_le_norm _
  have h2 : -R ≤ (z - ((x : ℂ) + (y : ℂ) * I)).re := by
    have hlow := (abs_le.mp h1).1
    linarith
  linarith

/-- **A Gaussian-type upper bound for `Z` on a right vertical line.**  On a
circle of radius `R` around `x + iy` with `1 < x - R`, the identity
`ξ₀ = z(z−1)Z` turns the unconditional order-one bound on `ξ₀` into
`‖Z z‖ ≤ M exp(A y²)`.  This is the Stirling-type upper half of the growth
input, proved rather than assumed. -/
theorem exists_circle_growth_completedZeta_right (x R : ℝ) (hR : 0 < R)
    (hxR : 1 < x - R) :
    ∃ M A : ℝ, 0 ≤ M ∧ 0 ≤ A ∧
      ∀ y : ℝ, ∀ z ∈ Metric.sphere ((x : ℂ) + (y : ℂ) * I) R,
        ‖completedZeta z‖ ≤ M * Real.exp (A * y ^ 2) := by
  obtain ⟨A0, B0, hA0, hgrowth⟩ := exists_bound_log_norm_xi₀
  set C : ℝ := R + |x| with hC
  have hC0 : 0 ≤ C := by positivity
  have hC1 : 0 ≤ C + 1 := by linarith
  have hD0 : 0 ≤ C ^ 2 + 2 * C + (C + 1) ^ 2 := by positivity
  refine ⟨Real.exp (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
      - Real.log ((x - R) * (x - R - 1))), 2 * A0, ?_, ?_, ?_⟩
  · positivity
  · positivity
  · intro y z hz
    have hzre : x - R ≤ z.re := by
      have hdist : ‖z - ((x : ℂ) + (y : ℂ) * I)‖ ≤ R := by
        have h := Metric.mem_sphere.mp hz
        rw [dist_eq_norm] at h
        linarith
      have hre : (z - ((x : ℂ) + (y : ℂ) * I)).re = z.re - x := by simp
      have h1 : |(z - ((x : ℂ) + (y : ℂ) * I)).re| ≤
          ‖z - ((x : ℂ) + (y : ℂ) * I)‖ := Complex.abs_re_le_norm _
      have h2 : -R ≤ (z - ((x : ℂ) + (y : ℂ) * I)).re := by
        have hlow := (abs_le.mp h1).1
        linarith
      linarith
    have hz0 : z ≠ 0 := by
      intro h
      rw [h] at hzre
      norm_num at hzre
      linarith
    have hz1 : z ≠ 1 := by
      intro h
      rw [h] at hzre
      norm_num at hzre
      linarith
    have hΓ : z.Gammaℝ ≠ 0 := by
      intro h
      obtain ⟨m, hm⟩ := Complex.Gammaℝ_eq_zero_iff.mp h
      have hre : z.re = -(2 * (m : ℝ)) := by
        rw [hm]
        simp
      have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      linarith
    have hid := xi₀_eq_mul_completedZeta hz0 hz1 hΓ
    have hden_pos : 0 < (x - R) * (x - R - 1) := by
      have h1 : 0 < x - R := by linarith
      nlinarith
    have hz_norm : x - R ≤ ‖z‖ := le_trans hzre (Complex.re_le_norm z)
    have hz1_norm : x - R - 1 ≤ ‖z - 1‖ := by
      have h : (z - 1).re = z.re - 1 := by simp
      have h1 : z.re - 1 ≤ ‖z - 1‖ := by
        rw [← h]
        exact Complex.re_le_norm _
      linarith
    have hden_lb : (x - R) * (x - R - 1) ≤ ‖z‖ * ‖z - 1‖ := by
      exact mul_le_mul hz_norm hz1_norm (by linarith) (norm_nonneg _)
    have hdiv : ‖xi₀ z‖ / (‖z‖ * ‖z - 1‖)
        ≤ ‖xi₀ z‖ / ((x - R) * (x - R - 1)) :=
      div_le_div_of_nonneg_left (norm_nonneg _) hden_pos hden_lb
    have hxi_norm : ‖completedZeta z‖ = ‖xi₀ z‖ / (‖z‖ * ‖z - 1‖) := by
      rw [hid, norm_mul, norm_mul]
      field_simp [hz0, sub_ne_zero.mpr hz1, norm_ne_zero_iff.mpr hz0,
        norm_ne_zero_iff.mpr (sub_ne_zero.mpr hz1)]
    have hxi_bound : ‖xi₀ z‖
        ≤ Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0) := by
      by_cases hzero : xi₀ z = 0
      · rw [hzero, norm_zero]
        exact (Real.exp_pos _).le
      · have hpos : 0 < ‖xi₀ z‖ := norm_pos_iff.mpr hzero
        calc ‖xi₀ z‖ = Real.exp (Real.log ‖xi₀ z‖) := (Real.exp_log hpos).symm
          _ ≤ Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0) :=
              Real.exp_le_exp.mpr (hgrowth z)
    have hlogC : 0 < (x - R) * (x - R - 1) := hden_pos
    have hnorm_lb : ‖z‖ ≤ |y| + C := by
      have htriangle : ‖z‖ ≤ ‖(x : ℂ) + (y : ℂ) * I‖ + ‖z - ((x : ℂ) + (y : ℂ) * I)‖ :=
        norm_le_insert' z ((x : ℂ) + (y : ℂ) * I)
      have hdist : ‖z - ((x : ℂ) + (y : ℂ) * I)‖ ≤ R := by
        have h := Metric.mem_sphere.mp hz
        rw [dist_eq_norm] at h
        linarith
      have hxy : ‖(x : ℂ) + (y : ℂ) * I‖ ≤ |x| + |y| := by
        simpa using Complex.norm_le_abs_re_add_abs_im ((x : ℂ) + (y : ℂ) * I)
      have : ‖z‖ ≤ R + (|x| + |y|) := by linarith
      rw [hC]
      linarith
    have hlogbound : Real.log (‖z‖ + 2) ≤ ‖z‖ + 2 := by
      have h := Real.log_le_sub_one_of_pos (show (0:ℝ) < ‖z‖ + 2 by positivity)
      linarith
    have hprod : ‖z‖ * Real.log (‖z‖ + 2) ≤ 2 * y ^ 2 + (C ^ 2 + 2 * C + (C + 1) ^ 2) := by
      have hr0 : 0 ≤ ‖z‖ := norm_nonneg z
      have hlog_nonneg : 0 ≤ Real.log (‖z‖ + 2) := Real.log_nonneg (by linarith)
      have hstep : ‖z‖ * Real.log (‖z‖ + 2) ≤ ‖z‖ * (‖z‖ + 2) := by
        apply mul_le_mul_of_nonneg_left hlogbound hr0
      have hstep2 : ‖z‖ * (‖z‖ + 2) ≤ (|y| + C) * (|y| + C + 2) := by
        apply mul_le_mul hnorm_lb (by linarith) (by linarith) (by positivity)
      have hexpand : (|y| + C) * (|y| + C + 2)
          = y ^ 2 + 2 * (C + 1) * |y| + (C ^ 2 + 2 * C) := by
        have hy : y ^ 2 = |y| ^ 2 := (sq_abs y).symm
        rw [hy]
        ring
      have hq : 2 * (C + 1) * |y| ≤ (C + 1) ^ 2 + y ^ 2 := by
        nlinarith [sq_nonneg (|y| - (C + 1))]
      rw [hexpand] at hstep2
      nlinarith
    have hfinal : ‖xi₀ z‖ / ((x - R) * (x - R - 1))
        ≤ Real.exp (2 * A0 * y ^ 2
            + (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
              - Real.log ((x - R) * (x - R - 1)))) := by
      have h1 : ‖xi₀ z‖ / ((x - R) * (x - R - 1))
          ≤ Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0) / ((x - R) * (x - R - 1)) :=
        div_le_div_of_nonneg_right hxi_bound hden_pos.le
      have h2 : Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0) / ((x - R) * (x - R - 1))
          = Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0
              - Real.log ((x - R) * (x - R - 1))) := by
        rw [Real.exp_sub, Real.exp_log hlogC]
      have h3 : A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0 - Real.log ((x - R) * (x - R - 1))
          ≤ 2 * A0 * y ^ 2
            + (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
              - Real.log ((x - R) * (x - R - 1))) := by
        have := mul_le_mul_of_nonneg_left hprod hA0
        nlinarith
      calc ‖xi₀ z‖ / ((x - R) * (x - R - 1))
          ≤ Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0) / ((x - R) * (x - R - 1)) := h1
        _ = Real.exp (A0 * ‖z‖ * Real.log (‖z‖ + 2) + B0
              - Real.log ((x - R) * (x - R - 1))) := h2
        _ ≤ Real.exp (2 * A0 * y ^ 2
            + (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
              - Real.log ((x - R) * (x - R - 1)))) := Real.exp_le_exp.mpr h3
    calc ‖completedZeta z‖ = ‖xi₀ z‖ / (‖z‖ * ‖z - 1‖) := hxi_norm
      _ ≤ ‖xi₀ z‖ / ((x - R) * (x - R - 1)) := hdiv
      _ ≤ Real.exp (2 * A0 * y ^ 2
            + (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
              - Real.log ((x - R) * (x - R - 1)))) := hfinal
      _ = Real.exp (A0 * (C ^ 2 + 2 * C + (C + 1) ^ 2) + B0
            - Real.log ((x - R) * (x - R - 1))) * Real.exp ((2 * A0) * y ^ 2) := by
          rw [← Real.exp_add]
          congr 1
          ring

/-- **Exponential-in-`y²` growth also suffices.**  The Gaussian test function
dominates any bound `exp(A y²)` with `A < σ²`, so a super-polynomial Stirling
bound of this shape is still integrable. -/
theorem verticalLogDerivIntegrable_of_exp_bound (c σ x M A : ℝ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M) (hAσ : A < σ ^ 2)
    (hmeas : AEStronglyMeasurable (fun y : ℝ =>
      logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)))
    (hM : ∀ y : ℝ,
      ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * Real.exp (A * y ^ 2)) :
    VerticalLogDerivIntegrable c σ x := by
  unfold VerticalLogDerivIntegrable
  set CH : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2)) *
    Real.exp (-(c * (x - 1 / 2))) with hCH
  have hCH0 : 0 ≤ CH := by rw [hCH]; positivity
  have hb : 0 < σ ^ 2 - A := by linarith
  have hg : Integrable (fun y : ℝ => M * CH * Real.exp (-(σ ^ 2 - A) * y ^ 2)) :=
    (integrable_exp_neg_mul_sq hb).const_mul (M * CH)
  refine hg.mono' hmeas ?_
  filter_upwards with y
  have hH := gaussianZeroTest_norm c σ x y hσ
  have hH' : ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ =
      CH * Real.exp (-(σ ^ 2 * y ^ 2)) := by
    rw [hH, hCH]
    rw [show σ ^ 2 * ((x - 1 / 2) ^ 2 - y ^ 2) =
      σ ^ 2 * ((x - 1 / 2) ^ 2) + (-(σ ^ 2 * y ^ 2)) by ring, Real.exp_add]
    ring
  calc ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I) *
        gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖
      = ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ *
          ‖gaussianZeroTest c σ ((x : ℂ) + (y : ℂ) * I)‖ := norm_mul _ _
    _ ≤ (M * Real.exp (A * y ^ 2)) * (CH * Real.exp (-(σ ^ 2 * y ^ 2))) :=
        mul_le_mul (hM y) (le_of_eq hH') (norm_nonneg _)
          (mul_nonneg hM0 (Real.exp_pos _).le)
    _ = M * CH * Real.exp (-(σ ^ 2 - A) * y ^ 2) := by
        have hexp : Real.exp (A * y ^ 2) * Real.exp (-(σ ^ 2 * y ^ 2))
            = Real.exp (-(σ ^ 2 - A) * y ^ 2) := by
          rw [← Real.exp_add]
          congr 1
          ring
        calc (M * Real.exp (A * y ^ 2)) * (CH * Real.exp (-(σ ^ 2 * y ^ 2)))
            = M * CH * (Real.exp (A * y ^ 2) * Real.exp (-(σ ^ 2 * y ^ 2))) := by ring
          _ = M * CH * Real.exp (-(σ ^ 2 - A) * y ^ 2) := by rw [hexp]

/-- **The exponential-growth case without a measurability hypothesis.** -/
theorem verticalLogDerivIntegrable_of_exp_bound' (c σ x M A : ℝ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M) (hAσ : A < σ ^ 2)
    (hM : ∀ y : ℝ,
      ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * Real.exp (A * y ^ 2)) :
    VerticalLogDerivIntegrable c σ x :=
  verticalLogDerivIntegrable_of_exp_bound c σ x M A hσ hM0 hAσ
    (aestronglyMeasurable_logDeriv_mul_gaussian c σ x) hM

/-- **Measurability is discharged.**  A polynomial `Z'/Z` bound alone gives
`VerticalLogDerivIntegrable`; the `AEStronglyMeasurable` hypothesis of the
earlier theorem is now proved. -/
theorem verticalLogDerivIntegrable_of_polynomial_bound' (c σ x M : ℝ) (k : ℕ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M)
    (hM : ∀ y : ℝ,
      ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * (1 + |y|) ^ k) :
    VerticalLogDerivIntegrable c σ x :=
  verticalLogDerivIntegrable_of_polynomial_bound c σ x M k hσ hM0
    (aestronglyMeasurable_logDeriv_mul_gaussian c σ x) hM

/-- **Measurability-free linear case.** -/
theorem verticalLogDerivIntegrable_of_linear_bound'' (c σ x M : ℝ)
    (hσ : 0 < σ) (hM0 : 0 ≤ M)
    (hM : ∀ y : ℝ, ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖ ≤ M * (1 + |y|)) :
    VerticalLogDerivIntegrable c σ x :=
  verticalLogDerivIntegrable_of_polynomial_bound' c σ x M 1 hσ hM0
    (fun y => by simpa using hM y)

/-- **The right-line interface.**  On a circle of radius `R` around `x + iy`
with `1 < x - R`, a Gaussian upper bound `M exp(A y²)` plus an exponential
lower bound `a exp(-B|y|)` with `A + B/2 < σ²` gives
`VerticalLogDerivIntegrable`.  The upper bound is proved from the `ξ₀` growth
in `exists_circle_growth_completedZeta_right`; the lower bound is the remaining
Gamma/Stirling estimate. -/
theorem verticalLogDerivIntegrable_of_right_growth_lower
    (c σ x R M A a B : ℝ)
    (hσ : 0 < σ) (hR : 0 < R) (hxR : 1 < x - R)
    (hM0 : 0 ≤ M) (ha : 0 < a) (hB0 : 0 ≤ B)
    (hAσ : A + B / 2 < σ ^ 2)
    (hM : ∀ y : ℝ, ∀ z ∈ Metric.sphere ((x : ℂ) + (y : ℂ) * I) R,
      ‖completedZeta z‖ ≤ M * Real.exp (A * y ^ 2))
    (hlower : ∀ y : ℝ,
      a * Real.exp (-(B * |y|)) ≤ ‖completedZeta ((x : ℂ) + (y : ℂ) * I)‖) :
    VerticalLogDerivIntegrable c σ x := by
  set M' : ℝ := (M / (R * a)) * Real.exp (B / 2) with hM'
  have hM'0 : 0 ≤ M' := by
    rw [hM']
    positivity
  refine verticalLogDerivIntegrable_of_exp_bound' c σ x M' (A + B / 2)
    hσ hM'0 hAσ ?_
  intro y
  have hden : 0 < a * Real.exp (-(B * |y|)) := mul_pos ha (Real.exp_pos _)
  have hb := norm_logDeriv_completedZeta_le_of_sphere (s := (x : ℂ) + (y : ℂ) * I)
    hR (mul_nonneg hM0 (Real.exp_pos _).le)
    (fun z hz => by
      have hzre := re_ge_of_mem_closedBall_sub x R y hz
      intro h
      rw [h] at hzre
      norm_num at hzre
      linarith)
    (fun z hz m => by
      have hzre := re_ge_of_mem_closedBall_sub x R y hz
      intro h
      have h1 : z.re / 2 = -(m : ℝ) := by
        have := congrArg Complex.re h
        simpa using this
      have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
      nlinarith)
    (hM y) hden (hlower y)
  have hEq : (M * Real.exp (A * y ^ 2)) / (R * (a * Real.exp (-(B * |y|))))
      = (M / (R * a)) * (Real.exp (A * y ^ 2) * Real.exp (B * |y|)) := by
    have hR0 : R ≠ 0 := ne_of_gt hR
    have ha0 : a ≠ 0 := ne_of_gt ha
    have hexp0 : Real.exp (-(B * |y|)) ≠ 0 := Real.exp_ne_zero _
    rw [div_eq_mul_inv, mul_inv, mul_inv]
    have hinv : (Real.exp (-(B * |y|)))⁻¹ = Real.exp (B * |y|) := by
      rw [← Real.exp_neg]
      ring_nf
    rw [hinv]
    field_simp
  calc ‖logDeriv completedZeta ((x : ℂ) + (y : ℂ) * I)‖
      ≤ (M * Real.exp (A * y ^ 2)) / (R * (a * Real.exp (-(B * |y|)))) := hb
    _ = (M / (R * a)) * (Real.exp (A * y ^ 2) * Real.exp (B * |y|)) := hEq
    _ = (M / (R * a)) * Real.exp (A * y ^ 2 + B * |y|) := by
        rw [Real.exp_add]
    _ ≤ (M / (R * a)) * (Real.exp (B / 2) * Real.exp ((A + B / 2) * y ^ 2)) := by
        apply mul_le_mul_of_nonneg_left ?_ (by positivity)
        rw [← Real.exp_add]
        apply Real.exp_le_exp.mpr
        have h1 : B * |y| ≤ (B / 2) * (y ^ 2 + 1) := by
          have h2 : 2 * |y| ≤ y ^ 2 + 1 := by
            have hy : y ^ 2 = |y| ^ 2 := (sq_abs y).symm
            rw [hy]
            nlinarith [sq_nonneg (|y| - 1)]
          nlinarith [hB0]
        nlinarith
    _ = M' * Real.exp ((A + B / 2) * y ^ 2) := by
        rw [hM']
        ring

/-- **A lower bound for `ζ` on the right.**  For `Re s ≥ 2`, the Dirichlet
series gives `‖ζ(s)‖ ≥ 1 − 3/4 = 1/4`: the first term is `1` and the tail is
bounded by `∑ 1/(n+2)² < 3/4`.  This is the zeta half of the right-line lower
bound; only the Gamma factor remains. -/
theorem exists_zeta_lower_bound_right (x : ℝ) (hx : 2 ≤ x) :
    ∃ c : ℝ, 0 < c ∧ ∀ y : ℝ, c ≤ ‖riemannZeta ((x : ℂ) + (y : ℂ) * I)‖ := by
  refine ⟨1 / 4, by norm_num, fun y => ?_⟩
  set s : ℂ := (x : ℂ) + (y : ℂ) * I with hs
  have hre : 1 < s.re := by rw [hs]; simp; linarith
  have hre2 : 2 ≤ s.re := by rw [hs]; simp; linarith
  have hseries : riemannZeta s = ∑' n : ℕ, 1 / ((n : ℂ) + 1) ^ s :=
    zeta_eq_tsum_one_div_nat_add_one_cpow (s := s) hre
  have hsum : Summable (fun n : ℕ => 1 / ((n : ℂ) + 1) ^ s) := by
    have h := (summable_nat_add_iff (f := fun n : ℕ => (1 : ℂ) / (n : ℂ) ^ s) 1).mpr
      (Complex.summable_one_div_nat_cpow.mpr hre)
    simpa [Nat.cast_add, Nat.cast_one] using h
  have hsplit := hsum.tsum_eq_zero_add
  have hζ : riemannZeta s = 1 + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s := by
    rw [hseries, hsplit]
    congr 1
    · norm_num
    · apply tsum_congr
      intro n
      congr 1
      push_cast
      ring
  have htail_summable : Summable (fun n : ℕ => 1 / ((n : ℂ) + 2) ^ s) := by
    have h := (summable_nat_add_iff (f := fun n : ℕ => 1 / ((n : ℂ) + 1) ^ s) 1).mpr hsum
    refine h.congr (fun n => ?_)
    push_cast
    ring_nf
  have hnorm_term : ∀ n : ℕ, ‖1 / ((n : ℂ) + 2) ^ s‖ ≤ (1 : ℝ) / ((n : ℝ) + 2) ^ 2 := by
    intro n
    have hbase : (0 : ℝ) < (n : ℝ) + 2 := by positivity
    have hbase_ge : (1 : ℝ) ≤ (n : ℝ) + 2 := by
      have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
      linarith
    have hnorm : ‖((n : ℂ) + 2) ^ s‖ = ((n : ℝ) + 2) ^ s.re := by
      have hcast : ((n : ℂ) + 2) = (((n : ℝ) + 2 : ℝ) : ℂ) := by push_cast; ring
      rw [hcast, Complex.norm_cpow_eq_rpow_re_of_pos hbase]
    have hexp : ((n : ℝ) + 2) ^ (2 : ℝ) ≤ ((n : ℝ) + 2) ^ s.re :=
      Real.rpow_le_rpow_of_exponent_le hbase_ge hre2
    have hexp2 : ((n : ℝ) + 2) ^ 2 ≤ ((n : ℝ) + 2) ^ s.re := by
      simpa [Real.rpow_two] using hexp
    rw [norm_div, hnorm, norm_one]
    exact one_div_le_one_div_of_le (by positivity) hexp2
  have hzeta2_sum : Summable (fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 2) :=
    hasSum_zeta_two.summable
  have hmajor : Summable (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 2) ^ 2) := by
    have h := (summable_nat_add_iff (f := fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 2) 2).mpr hzeta2_sum
    refine h.congr (fun n => ?_)
    push_cast
    ring_nf
  have hval : (∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 2) ^ 2) = Real.pi ^ 2 / 6 - 1 := by
    have hshift := hzeta2_sum.sum_add_tsum_nat_add 2
    have hfirst : (∑ i ∈ Finset.range 2, (1 : ℝ) / (i : ℝ) ^ 2) = 1 := by
      norm_num
    have htsum2 : (∑' n : ℕ, (1 : ℝ) / (n : ℝ) ^ 2) = Real.pi ^ 2 / 6 :=
      hasSum_zeta_two.tsum_eq
    have hshift' : (∑ i ∈ Finset.range 2, (1 : ℝ) / (i : ℝ) ^ 2)
        + (∑' i : ℕ, (1 : ℝ) / ((i : ℝ) + 2) ^ 2)
        = (∑' i : ℕ, (1 : ℝ) / (i : ℝ) ^ 2) := by
      simpa [Nat.cast_add, Nat.cast_ofNat] using hshift
    rw [hfirst, htsum2] at hshift'
    linarith
  have htail_bound : ‖∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖ ≤ 3 / 4 := by
    have hnorm_tail_summable : Summable (fun n : ℕ => ‖1 / ((n : ℂ) + 2) ^ s‖) :=
      htail_summable.norm
    have h1 : ‖∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖
        ≤ ∑' n : ℕ, ‖1 / ((n : ℂ) + 2) ^ s‖ :=
      norm_tsum_le_tsum_norm hnorm_tail_summable
    have h2 : (∑' n : ℕ, ‖1 / ((n : ℂ) + 2) ^ s‖)
        ≤ ∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 2) ^ 2 :=
      hnorm_tail_summable.tsum_le_tsum hnorm_term hmajor
    have h3 : (∑' n : ℕ, (1 : ℝ) / ((n : ℝ) + 2) ^ 2) ≤ 3 / 4 := by
      rw [hval]
      have hpi : Real.pi ^ 2 < 10.5 := by nlinarith [Real.pi_lt_d2, Real.pi_gt_d2]
      nlinarith
    linarith
  have hge : (1 : ℝ) - ‖∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖
      ≤ ‖1 + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖ := by
    have h := norm_sub_le ((1 : ℂ) + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s)
      (∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s)
    have h' : ((1 : ℂ) + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s)
        - (∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s) = 1 := by ring
    rw [h', norm_one] at h
    linarith
  calc ‖riemannZeta s‖ = ‖1 + ∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖ := by rw [hζ]
    _ ≥ 1 - ‖∑' n : ℕ, 1 / ((n : ℂ) + 2) ^ s‖ := hge
    _ ≥ 1 - 3 / 4 := by linarith
    _ = 1 / 4 := by norm_num

/-- **A conditional right-line capstone.**  Given only the exponential lower
bound `a exp(−B|y|) ≤ ‖Z(x+iy)‖` on a line with `x − R > 1`, there is a
Gaussian width `σ` for which `VerticalLogDerivIntegrable` holds.  The upper
bound is supplied by `exists_circle_growth_completedZeta_right`; the width is
chosen large enough that `A + B/2 < σ²`. -/
theorem exists_positive_verticalLogDerivIntegrable_of_right_lower
    (c x R a B : ℝ) (hR : 0 < R) (hxR : 1 < x - R) (ha : 0 < a) (hB0 : 0 ≤ B)
    (hlower : ∀ y : ℝ,
      a * Real.exp (-(B * |y|)) ≤ ‖completedZeta ((x : ℂ) + (y : ℂ) * I)‖) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ x := by
  obtain ⟨M, A, hM0, hA0, hM⟩ := exists_circle_growth_completedZeta_right x R hR hxR
  refine ⟨Real.sqrt (A + B / 2 + 1), Real.sqrt_pos.mpr (by linarith), ?_⟩
  have hσA : A + B / 2 < (Real.sqrt (A + B / 2 + 1)) ^ 2 := by
    rw [Real.sq_sqrt (by linarith)]
    linarith
  exact verticalLogDerivIntegrable_of_right_growth_lower c _ x R M A a B
    (Real.sqrt_pos.mpr (by linarith)) hR hxR hM0 ha hB0 hσA hM hlower

/-- **The left vertical line reduces to the right.**  If
`VerticalLogDerivIntegrable` holds on `Re s = 2`, then it holds on `Re s = -1`.
The proof uses `Z(1−s) = Z(s)` (so `(Z'/Z)(1−s) = −(Z'/Z)(s)`) and the norm
identity `‖H_c(−1+iy)‖ = e^{3c} ‖H_c(2−iy)‖`, then transfers integrability
under `y ↦ −y`. -/
theorem verticalLogDerivIntegrable_left_of_right (c σ : ℝ) (hσ : 0 < σ)
    (h : VerticalLogDerivIntegrable c σ 2) :
    VerticalLogDerivIntegrable c σ (-1) := by
  unfold VerticalLogDerivIntegrable at h ⊢
  set F : ℝ → ℂ := fun y =>
    logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * I)
      * gaussianZeroTest c σ ((2 : ℂ) + (y : ℂ) * I) with hF
  have hcomp : Integrable (fun y : ℝ => F (-y)) :=
    (Measure.measurePreserving_neg (volume : Measure ℝ)).integrable_comp_of_integrable h
  have hg : Integrable (fun y : ℝ => Real.exp (3 * c) * ‖F (-y)‖) :=
    hcomp.norm.const_mul _
  refine hg.mono' (aestronglyMeasurable_logDeriv_mul_gaussian c σ (-1)) ?_
  filter_upwards with y
  set s : ℂ := (2 : ℂ) + (-(y : ℂ)) * I with hs
  have hsre : s.re = 2 := by rw [hs]; simp
  have hs0 : s ≠ 0 := by intro h; rw [h] at hsre; norm_num at hsre
  have hs1 : s ≠ 1 := by intro h; rw [h] at hsre; norm_num at hsre
  have hsΓ : s.Gammaℝ ≠ 0 := by
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    rw [hsre]; norm_num
  have h1s_re : (1 - s).re = -1 := by rw [hs]; norm_num
  have h1sΓ : (1 - s).Gammaℝ ≠ 0 := by
    intro hzero
    obtain ⟨m, hm⟩ := Complex.Gammaℝ_eq_zero_iff.mp hzero
    have hre : (1 - s).re = -(2 * (m : ℝ)) := by rw [hm]; simp
    rw [h1s_re] at hre
    have h2 : (2 * (m : ℝ)) = 1 := by linarith
    have h2n : (2 * m : ℕ) = 1 := by exact_mod_cast h2
    omega
  have hg1 : ∀ m : ℕ, s / 2 ≠ -(m : ℂ) := by
    intro m hm
    have hre : (s / 2).re = -((m : ℝ)) := by rw [hm]; simp
    have hsp : (s / 2).re = 1 := by rw [hs]; simp
    have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    rw [hsp] at hre
    linarith
  have hg2 : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ) := by
    intro m hm
    have hre : ((1 - s) / 2).re = -((m : ℝ)) := by rw [hm]; simp
    have hsp : ((1 - s) / 2).re = -(1 / 2) := by rw [hs]; norm_num
    rw [hsp] at hre
    have h2 : (2 * (m : ℝ)) = 1 := by linarith
    have h2n : (2 * m : ℕ) = 1 := by exact_mod_cast h2
    omega
  have hlog := logDeriv_completedZeta_one_sub (s := s) hs0 hs1 hsΓ h1sΓ hg1 hg2
  have hlog' : logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I)
      = -logDeriv completedZeta ((2 : ℂ) + (-(y : ℂ)) * I) := by
    have h1s : 1 - s = (-1 : ℂ) + (y : ℂ) * I := by rw [hs]; ring
    rw [← h1s]
    exact hlog
  have hHnorm : ‖gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I)‖
      = Real.exp (3 * c) * ‖gaussianZeroTest c σ ((2 : ℂ) + (-(y : ℂ)) * I)‖ := by
    have harg1 : ((-1 : ℂ) + (y : ℂ) * I) = (((-1 : ℝ) : ℂ) + (y : ℂ) * I) := by norm_num
    have harg2 : ((2 : ℂ) + (-(y : ℂ)) * I) = (((2 : ℝ) : ℂ) + ((-y : ℝ) : ℂ) * I) := by push_cast; ring
    rw [harg1, harg2, gaussianZeroTest_norm c σ (-1) y hσ,
      gaussianZeroTest_norm c σ 2 (-y) hσ]
    have hexp : Real.exp (σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
          * Real.exp (-(c * ((-1 : ℝ) - 1 / 2)))
        = Real.exp (3 * c) * (Real.exp (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
          * Real.exp (-(c * ((2 : ℝ) - 1 / 2)))) := by
      have h1 : σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2)
            + -(c * ((-1 : ℝ) - 1 / 2))
          = 3 * c + (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * ((2 : ℝ) - 1 / 2))) := by
        ring_nf
      calc Real.exp (σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
            * Real.exp (-(c * ((-1 : ℝ) - 1 / 2)))
          = Real.exp (σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2)
              + -(c * ((-1 : ℝ) - 1 / 2))) := (Real.exp_add _ _).symm
        _ = Real.exp (3 * c + (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * ((2 : ℝ) - 1 / 2)))) := by rw [h1]
        _ = Real.exp (3 * c)
            * Real.exp (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * ((2 : ℝ) - 1 / 2))) := Real.exp_add _ _
        _ = Real.exp (3 * c) * (Real.exp (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
            * Real.exp (-(c * ((2 : ℝ) - 1 / 2)))) := by rw [Real.exp_add]
    calc 2 * Real.pi * σ ^ 2
          * Real.exp (σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
          * Real.exp (-(c * ((-1 : ℝ) - 1 / 2)))
        = 2 * Real.pi * σ ^ 2
          * (Real.exp (σ ^ 2 * (((-1 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
            * Real.exp (-(c * ((-1 : ℝ) - 1 / 2)))) := by ring
      _ = 2 * Real.pi * σ ^ 2
          * (Real.exp (3 * c) * (Real.exp (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
            * Real.exp (-(c * ((2 : ℝ) - 1 / 2))))) := by rw [hexp]
      _ = Real.exp (3 * c) * (2 * Real.pi * σ ^ 2
          * Real.exp (σ ^ 2 * (((2 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
          * Real.exp (-(c * ((2 : ℝ) - 1 / 2)))) := by ring
  have hfinal : ‖logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I)‖
      = Real.exp (3 * c) * ‖F (-y)‖ := by
    calc ‖logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I)‖
      = ‖logDeriv completedZeta ((-1 : ℂ) + (y : ℂ) * I)‖
        * ‖gaussianZeroTest c σ ((-1 : ℂ) + (y : ℂ) * I)‖ := norm_mul _ _
    _ = ‖logDeriv completedZeta ((2 : ℂ) + (-(y : ℂ)) * I)‖
          * (Real.exp (3 * c) * ‖gaussianZeroTest c σ ((2 : ℂ) + (-(y : ℂ)) * I)‖) := by
        rw [hlog', norm_neg, hHnorm]
      _ = Real.exp (3 * c) * ‖F (-y)‖ := by
          simp [hF, norm_mul, mul_comm, mul_left_comm, mul_assoc]
  simpa using hfinal.le

/-- **The remaining named input: a Gamma lower bound on the right line.**
This is the only analytic obligation left in the log-derivative programme. -/
def GammaRLowerBound : Prop :=
  ∃ a B : ℝ, 0 < a ∧ 0 ≤ B ∧ ∀ y : ℝ,
    a * Real.exp (-(B * |y|))
      ≤ ‖Complex.Gammaℝ (((21 : ℝ) / 10 : ℝ) + (y : ℂ) * I)‖

/-- **The Gamma lower bound closes the right line.**  Combining the named
Gamma lower bound with the zeta lower bound `‖ζ‖ ≥ 1/4` gives the required
lower bound on `Z`; T19 then produces a width `σ > 0` with
`VerticalLogDerivIntegrable` on `Re s = 21/10`. -/
theorem exists_verticalLogDerivIntegrable_right_of_gammaR_lower
    (h : GammaRLowerBound) (c : ℝ) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ ((21 : ℝ) / 10) := by
  obtain ⟨a, B, ha, hB, hγ⟩ := h
  obtain ⟨cz, hcz, hζ⟩ :=
    exists_zeta_lower_bound_right ((21 : ℝ) / 10) (by norm_num)
  have hlower : ∀ y : ℝ,
      (a * cz) * Real.exp (-(B * |y|))
        ≤ ‖completedZeta ((((21 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖ := by
    intro y
    set s : ℂ := (((21 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I with hs
    have hsre : s.re = (21 : ℝ) / 10 := by rw [hs]; simp
    have hs0 : s ≠ 0 := by
      intro hzero
      rw [hzero] at hsre
      norm_num at hsre
    have hs1 : s ≠ 1 := by
      intro hone
      rw [hone] at hsre
      norm_num at hsre
    have hΓ : Complex.Gammaℝ s ≠ 0 := by
      apply Complex.Gammaℝ_ne_zero_of_re_pos
      rw [hsre]
      norm_num
    have hZ : completedZeta s = Complex.Gammaℝ s * riemannZeta s := by
      rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓ]
      have h := riemannZeta_def_of_ne_zero (s := s) hs0
      rw [h]
      field_simp [hΓ]
    rw [hZ, norm_mul]
    have hγy := hγ y
    have hζy := hζ y
    calc (a * cz) * Real.exp (-(B * |y|))
        = (a * Real.exp (-(B * |y|))) * cz := by ring
      _ ≤ ‖Complex.Gammaℝ s‖ * ‖riemannZeta s‖ :=
          mul_le_mul hγy hζy hcz.le (norm_nonneg _)
  have hpos : 0 < a * cz := mul_pos ha hcz
  exact exists_positive_verticalLogDerivIntegrable_of_right_lower c ((21 : ℝ) / 10)
    (1 / 10) (a * cz) B (by norm_num) (by norm_num) hpos hB hlower
theorem abs_sinh_le_exp (x : ℝ) : |Real.sinh x| ≤ Real.exp |x| := by
  rw [Real.sinh_eq]
  have h1 : |Real.exp x - Real.exp (-x)| ≤ Real.exp x + Real.exp (-x) := by
    calc |Real.exp x - Real.exp (-x)| ≤ |Real.exp x| + |Real.exp (-x)| := abs_sub _ _
      _ = Real.exp x + Real.exp (-x) := by
          rw [abs_of_pos (Real.exp_pos x), abs_of_pos (Real.exp_pos (-x))]
  have h2 : Real.exp x + Real.exp (-x) ≤ 2 * Real.exp |x| := by
    rcases le_or_gt 0 x with hx | hx
    · have : Real.exp (-x) ≤ Real.exp x := Real.exp_le_exp.mpr (by linarith)
      rw [abs_of_nonneg hx]; linarith
    · have : Real.exp x ≤ Real.exp (-x) := Real.exp_le_exp.mpr (by linarith)
      rw [abs_of_neg hx]; linarith
  rw [abs_div, abs_two]
  rw [div_le_iff₀ (by norm_num : (0:ℝ) < 2)]
  linarith

theorem norm_sin_pi_mul_le (u v : ℝ) :
    ‖Complex.sin ((Real.pi : ℂ) * ((u : ℂ) + (v : ℂ) * I))‖
      ≤ 2 * Real.exp (Real.pi * |v|) := by
  have harg : (Real.pi : ℂ) * ((u : ℂ) + (v : ℂ) * I)
      = ((Real.pi * u : ℝ) : ℂ) + ((Real.pi * v : ℝ) : ℂ) * I := by push_cast; ring
  rw [harg, Complex.sin_add_mul_I]
  have hsin : ‖Complex.sin (((Real.pi * u : ℝ)) : ℂ)‖ ≤ 1 := by
    rw [← Complex.ofReal_sin, Complex.norm_real, Real.norm_eq_abs]
    exact Real.abs_sin_le_one _
  have hcos : ‖Complex.cos (((Real.pi * u : ℝ)) : ℂ)‖ ≤ 1 := by
    rw [← Complex.ofReal_cos, Complex.norm_real, Real.norm_eq_abs]
    exact Real.abs_cos_le_one _
  have hcosh : ‖Complex.cosh (((Real.pi * v : ℝ)) : ℂ)‖ = Real.cosh (Real.pi * v) := by
    rw [← Complex.ofReal_cosh, Complex.norm_real, Real.norm_eq_abs,
      abs_of_pos (Real.cosh_pos _)]
  have hsinh : ‖Complex.sinh (((Real.pi * v : ℝ)) : ℂ)‖ = |Real.sinh (Real.pi * v)| := by
    rw [← Complex.ofReal_sinh, Complex.norm_real, Real.norm_eq_abs]
  have hcosh_le : Real.cosh (Real.pi * v) ≤ Real.exp (Real.pi * |v|) := by
    rw [Real.cosh_eq, div_le_iff₀ (by norm_num : (0:ℝ) < 2)]
    have h1 : Real.exp (Real.pi * v) ≤ Real.exp (Real.pi * |v|) :=
      Real.exp_le_exp.mpr (by nlinarith [le_abs_self v, Real.pi_pos])
    have h2 : Real.exp (-(Real.pi * v)) ≤ Real.exp (Real.pi * |v|) :=
      Real.exp_le_exp.mpr (by nlinarith [neg_abs_le v, Real.pi_pos])
    nlinarith
  have hsinh_le : |Real.sinh (Real.pi * v)| ≤ Real.exp (Real.pi * |v|) := by
    have h := abs_sinh_le_exp (Real.pi * v)
    rwa [abs_mul, abs_of_pos Real.pi_pos] at h
  have h := norm_add_le
    (Complex.sin (((Real.pi * u : ℝ)) : ℂ) * Complex.cosh (((Real.pi * v : ℝ)) : ℂ))
    (Complex.cos (((Real.pi * u : ℝ)) : ℂ) * Complex.sinh (((Real.pi * v : ℝ)) : ℂ) * I)
  calc ‖Complex.sin (((Real.pi * u : ℝ)) : ℂ) * Complex.cosh (((Real.pi * v : ℝ)) : ℂ)
        + Complex.cos (((Real.pi * u : ℝ)) : ℂ) * Complex.sinh (((Real.pi * v : ℝ)) : ℂ) * I‖
      ≤ ‖Complex.sin (((Real.pi * u : ℝ)) : ℂ) * Complex.cosh (((Real.pi * v : ℝ)) : ℂ)‖
        + ‖Complex.cos (((Real.pi * u : ℝ)) : ℂ) * Complex.sinh (((Real.pi * v : ℝ)) : ℂ) * I‖ := h
    _ ≤ 1 * Real.cosh (Real.pi * v) + 1 * |Real.sinh (Real.pi * v)| := by
        apply add_le_add
        · rw [norm_mul, hcosh]
          exact mul_le_mul_of_nonneg_right hsin (Real.cosh_pos _).le
        · rw [norm_mul, norm_mul, hsinh, norm_I, mul_one]
          exact mul_le_mul_of_nonneg_right hcos (abs_nonneg _)
    _ ≤ Real.exp (Real.pi * |v|) + Real.exp (Real.pi * |v|) := by
        have := add_le_add hcosh_le hsinh_le
        linarith
    _ = 2 * Real.exp (Real.pi * |v|) := by ring





theorem Gamma_one_sub_eq (u v : ℝ) (hu0 : 0 < u) (hu1 : u < 1) :
    Complex.Gamma (1 - ((u : ℂ) + (v : ℂ) * I))
      = Complex.Gamma (2 - ((u : ℂ) + (v : ℂ) * I)) / (1 - ((u : ℂ) + (v : ℂ) * I)) := by
  set w : ℂ := (u : ℂ) + (v : ℂ) * I
  have hw : 1 - w ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp [w] at this
    linarith
  have h := Complex.Gamma_add_one (1 - w) hw
  have harg : (1 - w) + 1 = 2 - w := by ring
  rw [harg] at h
  rw [h]
  field_simp [hw]

theorem Gamma_one_sub_norm_le (u v : ℝ) (hu0 : 0 < u) (hu1 : u < 1) :
    ‖Complex.Gamma (1 - ((u : ℂ) + (v : ℂ) * I))‖
      ≤ Real.Gamma (2 - u) / ‖1 - ((u : ℂ) + (v : ℂ) * I)‖ := by
  rw [Gamma_one_sub_eq u v hu0 hu1, norm_div]
  have hre : (2 - ((u : ℂ) + (v : ℂ) * I)).re = 2 - u := by simp
  have hpos : 0 < (2 - ((u : ℂ) + (v : ℂ) * I)).re := by rw [hre]; linarith
  have h := AbsoluteHodgeHadamard.norm_Gamma_le_Gamma_re hpos
  rw [hre] at h
  exact div_le_div_of_nonneg_right h (norm_nonneg _)

theorem Gamma_lower_reflection (u v : ℝ) (hu0 : 0 < u) (hu1 : u < 1) :
    Real.pi * |v| / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|))
      ≤ ‖Complex.Gamma ((u : ℂ) + (v : ℂ) * I)‖ := by
  set w : ℂ := (u : ℂ) + (v : ℂ) * I
  have hwre : w.re = u := by simp [w]
  have h1wre : (1 - w).re = 1 - u := by simp [w]
  have hsin_ne : Complex.sin ((Real.pi : ℂ) * w) ≠ 0 := by
    intro hsin
    have hzero : Complex.Gamma w * Complex.Gamma (1 - w) = 0 := by
      rw [Complex.Gamma_mul_Gamma_one_sub, hsin, div_zero]
    have hw0 : Complex.Gamma w ≠ 0 :=
      Complex.Gamma_ne_zero_of_re_pos (by rw [hwre]; linarith)
    have h1w0 : Complex.Gamma (1 - w) ≠ 0 :=
      Complex.Gamma_ne_zero_of_re_pos (by rw [h1wre]; linarith)
    exact (mul_ne_zero hw0 h1w0) hzero
  have hsin_pos : 0 < ‖Complex.sin ((Real.pi : ℂ) * w)‖ := norm_pos_iff.mpr hsin_ne
  have h1w_pos : 0 < ‖1 - w‖ := by
    apply norm_pos_iff.mpr
    intro h
    have := congrArg Complex.re h
    simp [w] at this
    linarith
  have hG1w_pos : 0 < ‖Complex.Gamma (1 - w)‖ :=
    norm_pos_iff.mpr (Complex.Gamma_ne_zero_of_re_pos (by rw [h1wre]; linarith))
  have hM_pos : 0 < Real.Gamma (2 - u) := Real.Gamma_pos_of_pos (by linarith)
  have hexp_pos : 0 < Real.exp (Real.pi * |v|) := Real.exp_pos _
  have hnorm : ‖Complex.Gamma w‖ * ‖Complex.Gamma (1 - w)‖
      = Real.pi / ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by
    rw [← norm_mul, Complex.Gamma_mul_Gamma_one_sub, norm_div]
    have hpi : ‖(Real.pi : ℂ)‖ = Real.pi := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    rw [hpi]
  have hGamma_eq : ‖Complex.Gamma w‖
      = Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) := by
    rw [eq_div_iff (mul_ne_zero hsin_pos.ne' hG1w_pos.ne')]
    calc ‖Complex.Gamma w‖
          * (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖)
        = (‖Complex.Gamma w‖ * ‖Complex.Gamma (1 - w)‖)
            * ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by ring
      _ = (Real.pi / ‖Complex.sin ((Real.pi : ℂ) * w)‖)
            * ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by rw [hnorm]
      _ = Real.pi := by field_simp [hsin_pos.ne']
  have hsin_bound : ‖Complex.sin ((Real.pi : ℂ) * w)‖ ≤ 2 * Real.exp (Real.pi * |v|) := by
    simpa [w] using norm_sin_pi_mul_le u v
  have hG1w_bound := Gamma_one_sub_norm_le u v hu0 hu1
  have h1w_ge : |v| ≤ ‖1 - w‖ := by
    have h := Complex.abs_im_le_norm (1 - w)
    simpa [w] using h
  have hden_le : ‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖
      ≤ (2 * Real.exp (Real.pi * |v|)) * (Real.Gamma (2 - u) / ‖1 - w‖) :=
    mul_le_mul hsin_bound hG1w_bound hG1w_pos.le
      (mul_nonneg (by positivity) hexp_pos.le)
  have hden_pos : 0 < (2 * Real.exp (Real.pi * |v|)) * (Real.Gamma (2 - u) / ‖1 - w‖) :=
    mul_pos (by positivity) (div_pos hM_pos h1w_pos)
  have hstep1 : Real.pi / ((2 * Real.exp (Real.pi * |v|)) * (Real.Gamma (2 - u) / ‖1 - w‖))
      ≤ Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) := by
    apply div_le_div_of_nonneg_left (by positivity) (mul_pos hsin_pos hG1w_pos) hden_le
  have hstep2 : Real.pi * ‖1 - w‖ / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|))
      = Real.pi / ((2 * Real.exp (Real.pi * |v|)) * (Real.Gamma (2 - u) / ‖1 - w‖)) := by
    field_simp [h1w_pos.ne', hM_pos.ne', hexp_pos.ne']
  have hstep3 : Real.pi * |v| / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|))
      ≤ Real.pi * ‖1 - w‖ / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|)) := by
    apply div_le_div_of_nonneg_right ?_ (by positivity)
    exact mul_le_mul_of_nonneg_left h1w_ge (by positivity)
  calc Real.pi * |v| / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|))
      ≤ Real.pi * ‖1 - w‖ / (2 * Real.Gamma (2 - u) * Real.exp (Real.pi * |v|)) := hstep3
    _ = Real.pi / ((2 * Real.exp (Real.pi * |v|)) * (Real.Gamma (2 - u) / ‖1 - w‖)) := hstep2
    _ ≤ Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) := hstep1
    _ = ‖Complex.Gamma w‖ := hGamma_eq.symm

/-- **The shifted Gamma lower bound.**  For every `v`,
`min m (π/(2Γ(39/20))) e^{−(π+1)|v|} ≤ ‖Γ(21/20 + iv)‖`, where `m` is the
minimum of `‖Γ(21/20 + iv)‖` on `|v| ≤ 1`. -/
theorem exists_Gamma_lower_shift :
    ∃ a B : ℝ, 0 < a ∧ 0 ≤ B ∧ ∀ v : ℝ,
      a * Real.exp (-(B * |v|))
        ≤ ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by
  have hcontGamma : Continuous (fun v : ℝ =>
      Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)) := by
    rw [continuous_iff_continuousAt]
    intro v
    apply ContinuousAt.comp
    · exact (Complex.differentiableAt_Gamma _ (by
        intro m hm
        have hre := congrArg Complex.re hm
        simp at hre
        have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
        linarith)).continuousAt
    · fun_prop
  have hcont : Continuous (fun v : ℝ =>
      ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖) := hcontGamma.norm
  obtain ⟨v0, hv0, hmin⟩ := isCompact_Icc.exists_isMinOn
    (show (Set.Icc (-1 : ℝ) 1).Nonempty from ⟨0, by norm_num⟩) hcont.continuousOn
  set m : ℝ := ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v0 : ℂ) * I)‖ with hm
  have hm_pos : 0 < m := by
    rw [hm]
    apply norm_pos_iff.mpr
    apply Complex.Gamma_ne_zero_of_re_pos
    simp
  set M : ℝ := Real.Gamma (39 / 20) with hM
  have hM_pos : 0 < M := by rw [hM]; exact Real.Gamma_pos_of_pos (by norm_num)
  refine ⟨min m (Real.pi / (2 * M)), Real.pi + 1, ?_, ?_, ?_⟩
  · exact lt_min hm_pos (by positivity)
  · positivity
  · intro v
    rcases le_or_gt |v| 1 with hv | hv
    · have hminv : m ≤ ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by
        simpa [hm] using hmin (a := v) (abs_le.mp hv)
      have hle : min m (Real.pi / (2 * M)) ≤ m := min_le_left _ _
      have hexp : Real.exp (-((Real.pi + 1) * |v|)) ≤ 1 := by
        rw [Real.exp_le_one_iff]
        nlinarith [abs_nonneg v, Real.pi_pos]
      calc min m (Real.pi / (2 * M)) * Real.exp (-((Real.pi + 1) * |v|))
          ≤ m * 1 := by
            apply mul_le_mul hle hexp (Real.exp_pos _).le hm_pos.le
        _ = m := by ring
        _ ≤ ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := hminv
    · have hshift : Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)
          = (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)
              * Complex.Gamma (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I) := by
        have h := Complex.Gamma_add_one (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I) (by
          intro hzero
          have hre := congrArg Complex.re hzero
          simp at hre)
        have harg : (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I) + 1
            = (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I) := by push_cast; ring
        rw [harg] at h
        exact h
      have hw_ge : 1 ≤ ‖(((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by
        have h := Complex.abs_im_le_norm ((((1 : ℝ) / 20 : ℝ) : ℂ) + (v : ℂ) * I)
        have him : |((((1 : ℝ) / 20 : ℝ) : ℂ) + (v : ℂ) * I).im| = |v| := by simp
        rw [him] at h
        linarith
      have hstrip := Gamma_lower_reflection (1 / 20) v (by norm_num) (by norm_num)
      have hexp_le : Real.exp (-((Real.pi + 1) * |v|)) ≤ |v| * Real.exp (-(Real.pi * |v|)) := by
        have h1 : Real.exp (-|v|) ≤ |v| := by
          have h2 : Real.exp (-|v|) ≤ 1 := by
            rw [Real.exp_le_one_iff]; nlinarith [abs_nonneg v]
          linarith
        calc Real.exp (-((Real.pi + 1) * |v|)) = Real.exp (-|v|) * Real.exp (-(Real.pi * |v|)) := by
              rw [← Real.exp_add]; congr 1; ring
          _ ≤ |v| * Real.exp (-(Real.pi * |v|)) :=
              mul_le_mul_of_nonneg_right h1 (Real.exp_pos _).le
      have hstep : Real.pi / (2 * M) * Real.exp (-((Real.pi + 1) * |v|))
          ≤ Real.pi * |v| / (2 * M * Real.exp (Real.pi * |v|)) := by
        have hMpos : 0 < 2 * M := by positivity
        calc Real.pi / (2 * M) * Real.exp (-((Real.pi + 1) * |v|))
            ≤ Real.pi / (2 * M) * (|v| * Real.exp (-(Real.pi * |v|))) :=
              mul_le_mul_of_nonneg_left hexp_le (by positivity)
          _ = Real.pi * |v| / (2 * M * Real.exp (Real.pi * |v|)) := by
              rw [Real.exp_neg]
              field_simp [hMpos.ne']
      have hz_ge : Real.pi * |v| / (2 * M * Real.exp (Real.pi * |v|))
          ≤ ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by
        rw [hshift, norm_mul]
        calc Real.pi * |v| / (2 * M * Real.exp (Real.pi * |v|))
            ≤ ‖Complex.Gamma (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by
              have harg : (2 : ℝ) - 1 / 20 = 39 / 20 := by norm_num
              rw [harg] at hstrip
              simpa [hM] using hstrip
          _ = 1 * ‖Complex.Gamma (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := by ring
          _ ≤ ‖(((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖
                * ‖Complex.Gamma (((1 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ :=
              mul_le_mul_of_nonneg_right hw_ge (norm_nonneg _)
      have hminle : min m (Real.pi / (2 * M)) ≤ Real.pi / (2 * M) := min_le_right _ _
      calc min m (Real.pi / (2 * M)) * Real.exp (-((Real.pi + 1) * |v|))
          ≤ Real.pi / (2 * M) * Real.exp (-((Real.pi + 1) * |v|)) :=
            mul_le_mul_of_nonneg_right hminle (Real.exp_pos _).le
        _ ≤ Real.pi * |v| / (2 * M * Real.exp (Real.pi * |v|)) := hstep
        _ ≤ ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + (v : ℂ) * I)‖ := hz_ge

/-- **`GammaRLowerBound` is proved.**  Combining the shifted Gamma estimate with
the `Γℝ` prefactor `π^{-21/20}` gives the named input. -/
theorem gammaR_lower_bound : GammaRLowerBound := by
  obtain ⟨a, B, ha, hB, hmain⟩ := exists_Gamma_lower_shift
  refine ⟨Real.pi ^ (-(21 / 20) : ℝ) * a, B / 2, ?_, ?_, ?_⟩
  · positivity
  · positivity
  · intro y
    have hpi : 0 < Real.pi ^ (-(21 / 20) : ℝ) := Real.rpow_pos_of_pos Real.pi_pos _
    have hΓ : ‖Complex.Gammaℝ (((21 : ℝ) / 10 : ℝ) + (y : ℂ) * I)‖
        = Real.pi ^ (-(21 / 20) : ℝ)
            * ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + ((y / 2 : ℝ) : ℂ) * I)‖ := by
      rw [Complex.Gammaℝ_def, norm_mul]
      have hpow : ‖(Real.pi : ℂ) ^ (-(((21 : ℝ) / 10 : ℝ) + (y : ℂ) * I) / 2)‖
          = Real.pi ^ (-(21 / 20) : ℝ) := by
        rw [Complex.norm_cpow_eq_rpow_re_of_pos Real.pi_pos]
        congr 1
        norm_num
      rw [hpow]
      congr 1
      congr 1
      push_cast
      ring
    rw [hΓ]
    have hB2 : B / 2 * |y| = B * |y / 2| := by
      rw [abs_div]
      field_simp
      ring
    rw [hB2]
    calc (Real.pi ^ (-(21 / 20) : ℝ) * a) * Real.exp (-(B * |y / 2|))
        = Real.pi ^ (-(21 / 20) : ℝ)
            * (a * Real.exp (-(B * |y / 2|))) := by ring
      _ ≤ Real.pi ^ (-(21 / 20) : ℝ)
            * ‖Complex.Gamma (((21 : ℝ) / 20 : ℝ) + ((y / 2 : ℝ) : ℂ) * I)‖ :=
          mul_le_mul_of_nonneg_left (hmain (y / 2)) hpi.le

/-- **The right vertical line is unconditional.**  The named Gamma input is
proved, so for every test parameter `c` there is a width `σ > 0` with
`VerticalLogDerivIntegrable` on `Re s = 21/10`. -/
theorem exists_verticalLogDerivIntegrable_right (c : ℝ) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ ((21 : ℝ) / 10) :=
  exists_verticalLogDerivIntegrable_right_of_gammaR_lower gammaR_lower_bound c

theorem verticalLogDerivIntegrable_left_of_right_2110 (c σ : ℝ) (hσ : 0 < σ)
    (h : VerticalLogDerivIntegrable c σ ((21 : ℝ) / 10)) :
    VerticalLogDerivIntegrable c σ ((-11 : ℝ) / 10) := by
  unfold VerticalLogDerivIntegrable at h ⊢
  set F : ℝ → ℂ := fun y =>
    logDeriv completedZeta ((((21 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)
      * gaussianZeroTest c σ ((((21 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I) with hF
  have hcomp : Integrable (fun y : ℝ => F (-y)) :=
    (Measure.measurePreserving_neg (volume : Measure ℝ)).integrable_comp_of_integrable h
  have hg : Integrable (fun y : ℝ => Real.exp ((16 / 5 : ℝ) * c) * ‖F (-y)‖) :=
    hcomp.norm.const_mul _
  refine hg.mono' (aestronglyMeasurable_logDeriv_mul_gaussian c σ ((-11 : ℝ) / 10)) ?_
  filter_upwards with y
  set s : ℂ := (((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I with hs
  have hsre : s.re = 21 / 10 := by rw [hs]; simp
  have hs0 : s ≠ 0 := by intro h; rw [h] at hsre; norm_num at hsre
  have hs1 : s ≠ 1 := by intro h; rw [h] at hsre; norm_num at hsre
  have hsΓ : s.Gammaℝ ≠ 0 := by
    apply Complex.Gammaℝ_ne_zero_of_re_pos
    rw [hsre]; norm_num
  have h1s_re : (1 - s).re = -11 / 10 := by rw [hs]; norm_num
  have h1sΓ : (1 - s).Gammaℝ ≠ 0 := by
    intro hzero
    obtain ⟨m, hm⟩ := Complex.Gammaℝ_eq_zero_iff.mp hzero
    have hre : (1 - s).re = -(2 * (m : ℝ)) := by rw [hm]; simp
    rw [h1s_re] at hre
    have h2 : (m : ℝ) = 11 / 20 := by linarith
    have h2n : (20 * m : ℕ) = 11 := by
      exact_mod_cast (by linarith : (20 * (m : ℝ)) = 11)
    omega
  have hg1 : ∀ m : ℕ, s / 2 ≠ -(m : ℂ) := by
    intro m hm
    have hre : (s / 2).re = -((m : ℝ)) := by rw [hm]; simp
    have hsp : (s / 2).re = 21 / 20 := by rw [hs]; norm_num
    have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    rw [hsp] at hre
    linarith
  have hg2 : ∀ m : ℕ, (1 - s) / 2 ≠ -(m : ℂ) := by
    intro m hm
    have hre : ((1 - s) / 2).re = -((m : ℝ)) := by rw [hm]; simp
    have hsp : ((1 - s) / 2).re = -(11 / 20) := by rw [hs]; norm_num
    rw [hsp] at hre
    have h2 : (m : ℝ) = 11 / 20 := by linarith
    have h2n : (20 * m : ℕ) = 11 := by
      exact_mod_cast (by linarith : (20 * (m : ℝ)) = 11)
    omega
  have hlog := logDeriv_completedZeta_one_sub (s := s) hs0 hs1 hsΓ h1sΓ hg1 hg2
  have hlog' : logDeriv completedZeta ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)
      = -logDeriv completedZeta ((((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I) := by
    have h1s : 1 - s = (((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I := by rw [hs]; push_cast; ring
    rw [← h1s]
    exact hlog
  have hHnorm : ‖gaussianZeroTest c σ ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖
      = Real.exp ((16 / 5 : ℝ) * c) * ‖gaussianZeroTest c σ ((((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I)‖ := by
    have harg2 : ((((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I) = ((((21 : ℝ) / 10 : ℝ) : ℂ) + ((-y : ℝ) : ℂ) * I) := by push_cast; ring
    rw [harg2, gaussianZeroTest_norm c σ (-11 / 10) y hσ,
      gaussianZeroTest_norm c σ (21 / 10) (-y) hσ]
    have hexp : Real.exp (σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
          * Real.exp (-(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2)))
        = Real.exp ((16 / 5 : ℝ) * c) * (Real.exp (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
          * Real.exp (-(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2)))) := by
      have h1 : σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2)
            + -(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2))
          = (16 / 5 : ℝ) * c + (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2))) := by
        ring_nf
      calc Real.exp (σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
            * Real.exp (-(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2)))
          = Real.exp (σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2)
              + -(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2))) := (Real.exp_add _ _).symm
        _ = Real.exp ((16 / 5 : ℝ) * c + (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2)))) := by rw [h1]
        _ = Real.exp ((16 / 5 : ℝ) * c)
            * Real.exp (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2)
              + -(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2))) := Real.exp_add _ _
        _ = Real.exp ((16 / 5 : ℝ) * c) * (Real.exp (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
            * Real.exp (-(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2)))) := by rw [Real.exp_add]
    calc 2 * Real.pi * σ ^ 2
          * Real.exp (σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
          * Real.exp (-(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2)))
        = 2 * Real.pi * σ ^ 2
          * (Real.exp (σ ^ 2 * ((((-11 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - y ^ 2))
            * Real.exp (-(c * (((-11 : ℝ) / 10 : ℝ) - 1 / 2)))) := by ring
      _ = 2 * Real.pi * σ ^ 2
          * (Real.exp ((16 / 5 : ℝ) * c) * (Real.exp (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
            * Real.exp (-(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2))))) := by rw [hexp]
      _ = Real.exp ((16 / 5 : ℝ) * c) * (2 * Real.pi * σ ^ 2
          * Real.exp (σ ^ 2 * ((((21 : ℝ) / 10 : ℝ) - 1 / 2) ^ 2 - (-y) ^ 2))
          * Real.exp (-(c * (((21 : ℝ) / 10 : ℝ) - 1 / 2)))) := by ring
  have hfinal : ‖logDeriv completedZeta ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c σ ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖
      = Real.exp ((16 / 5 : ℝ) * c) * ‖F (-y)‖ := by
    calc ‖logDeriv completedZeta ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)
        * gaussianZeroTest c σ ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖
      = ‖logDeriv completedZeta ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖
        * ‖gaussianZeroTest c σ ((((-11 : ℝ) / 10 : ℝ) : ℂ) + (y : ℂ) * I)‖ := norm_mul _ _
    _ = ‖logDeriv completedZeta ((((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I)‖
          * (Real.exp ((16 / 5 : ℝ) * c) * ‖gaussianZeroTest c σ ((((21 : ℝ) / 10 : ℝ) : ℂ) + (-(y : ℂ)) * I)‖) := by
        rw [hlog', norm_neg, hHnorm]
      _ = Real.exp ((16 / 5 : ℝ) * c) * ‖F (-y)‖ := by
          simp [hF, norm_mul, mul_comm, mul_left_comm, mul_assoc]
  simpa using hfinal.le

/-- **Both lines of the contour are unconditional.**  The right-line result
T30 and the left transfer give a width `σ > 0` with vertical integrability on
`Re s = −11/10` as well as on `Re s = 21/10`. -/
theorem exists_verticalLogDerivIntegrable_left_2110 (c : ℝ) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ ((-11 : ℝ) / 10) := by
  obtain ⟨σ, hσ, h⟩ := exists_verticalLogDerivIntegrable_right c
  exact ⟨σ, hσ, verticalLogDerivIntegrable_left_of_right_2110 c σ hσ h⟩

theorem Gamma_one_add_I_lower (y : ℝ) (hy : y ≠ 0) :
    Real.pi * |y| / (2 * Real.exp (Real.pi * |y|))
      ≤ ‖Complex.Gamma ((1 : ℂ) + (y : ℂ) * I)‖ := by
  set w : ℂ := (1 : ℂ) + (y : ℂ) * I with hw
  have hwre : w.re = 1 := by simp [w]
  have h1w : 1 - w = -(y : ℂ) * I := by simp [w]
  have hne : (-(y : ℂ) * I) ≠ 0 := by
    intro hzero
    have him : -y = 0 := by simpa using congrArg Complex.im hzero
    exact hy (by linarith)
  have hrec : Complex.Gamma (1 - (y : ℂ) * I)
      = (-(y : ℂ) * I) * Complex.Gamma (-(y : ℂ) * I) := by
    have h := Complex.Gamma_add_one (-(y : ℂ) * I) hne
    have harg : (-(y : ℂ) * I) + 1 = 1 - (y : ℂ) * I := by ring
    rwa [harg] at h
  have hGamma_neg_ne : Complex.Gamma (-(y : ℂ) * I) ≠ 0 := by
    intro hzero
    have h1 : Complex.Gamma (1 - (y : ℂ) * I) ≠ 0 :=
      Complex.Gamma_ne_zero_of_re_pos (by simp)
    apply h1
    rw [hrec, hzero, mul_zero]
  have hneg_bound : ‖Complex.Gamma (-(y : ℂ) * I)‖ ≤ 1 / |y| := by
    have hdiv : Complex.Gamma (-(y : ℂ) * I)
        = Complex.Gamma (1 - (y : ℂ) * I) / (-(y : ℂ) * I) := by
      rw [eq_div_iff hne, hrec]
      ring
    rw [hdiv, norm_div]
    have hnum : ‖Complex.Gamma (1 - (y : ℂ) * I)‖ ≤ 1 := by
      have h := AbsoluteHodgeHadamard.norm_Gamma_le_Gamma_re
        (s := 1 - (y : ℂ) * I) (by simp)
      simpa using h
    have hden : ‖(-(y : ℂ) * I)‖ = |y| := by simp
    rw [hden]
    exact div_le_div_of_nonneg_right hnum (abs_nonneg y)
  have hsin_ne : Complex.sin ((Real.pi : ℂ) * w) ≠ 0 := by
    intro hsin
    have hzero : Complex.Gamma w * Complex.Gamma (1 - w) = 0 := by
      rw [Complex.Gamma_mul_Gamma_one_sub, hsin, div_zero]
    have hw0 : Complex.Gamma w ≠ 0 :=
      Complex.Gamma_ne_zero_of_re_pos (by rw [hwre]; norm_num)
    have h1w0 : Complex.Gamma (1 - w) ≠ 0 := by
      rw [h1w]; exact hGamma_neg_ne
    exact (mul_ne_zero hw0 h1w0) hzero
  have hsin_pos : 0 < ‖Complex.sin ((Real.pi : ℂ) * w)‖ := norm_pos_iff.mpr hsin_ne
  have hG1w_pos : 0 < ‖Complex.Gamma (1 - w)‖ := by
    rw [h1w]; exact norm_pos_iff.mpr hGamma_neg_ne
  have hnorm : ‖Complex.Gamma w‖ * ‖Complex.Gamma (1 - w)‖
      = Real.pi / ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by
    rw [← norm_mul, Complex.Gamma_mul_Gamma_one_sub, norm_div]
    have hpi : ‖(Real.pi : ℂ)‖ = Real.pi := by
      rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos Real.pi_pos]
    rw [hpi]
  have hGamma_eq : ‖Complex.Gamma w‖
      = Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) := by
    rw [eq_div_iff (mul_ne_zero hsin_pos.ne' hG1w_pos.ne')]
    calc ‖Complex.Gamma w‖
          * (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖)
        = (‖Complex.Gamma w‖ * ‖Complex.Gamma (1 - w)‖)
            * ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by ring
      _ = (Real.pi / ‖Complex.sin ((Real.pi : ℂ) * w)‖)
            * ‖Complex.sin ((Real.pi : ℂ) * w)‖ := by rw [hnorm]
      _ = Real.pi := by field_simp [hsin_pos.ne']
  have hsin_bound : ‖Complex.sin ((Real.pi : ℂ) * w)‖ ≤ 2 * Real.exp (Real.pi * |y|) := by
    simpa [w] using norm_sin_pi_mul_le 1 y
  have hG1w_bound : ‖Complex.Gamma (1 - w)‖ ≤ 1 / |y| := by
    rw [h1w]; exact hneg_bound
  have hden_le : ‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖
      ≤ (2 * Real.exp (Real.pi * |y|)) * (1 / |y|) :=
    mul_le_mul hsin_bound hG1w_bound hG1w_pos.le
      (mul_nonneg (by positivity) (Real.exp_pos _).le)
  have hden_pos : 0 < (2 * Real.exp (Real.pi * |y|)) * (1 / |y|) :=
    mul_pos (by positivity) (one_div_pos.mpr (abs_pos.mpr hy))
  have hstep1 : Real.pi / ((2 * Real.exp (Real.pi * |y|)) * (1 / |y|))
      ≤ Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) :=
    div_le_div_of_nonneg_left (by positivity) (mul_pos hsin_pos hG1w_pos) hden_le
  have hstep2 : Real.pi * |y| / (2 * Real.exp (Real.pi * |y|))
      = Real.pi / ((2 * Real.exp (Real.pi * |y|)) * (1 / |y|)) := by
    field_simp [(abs_pos.mpr hy).ne', (Real.exp_pos (Real.pi * |y|)).ne']
  rw [hstep2]
  calc Real.pi / ((2 * Real.exp (Real.pi * |y|)) * (1 / |y|))
      ≤ Real.pi / (‖Complex.sin ((Real.pi : ℂ) * w)‖ * ‖Complex.Gamma (1 - w)‖) := hstep1
    _ = ‖Complex.Gamma w‖ := hGamma_eq.symm





theorem gammaR_lower_bound_two :
    ∃ a B : ℝ, 0 < a ∧ 0 ≤ B ∧ ∀ y : ℝ,
      a * Real.exp (-(B * |y|)) ≤ ‖Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)‖ := by
  have hcontGamma : Continuous (fun v : ℝ => Complex.Gamma ((1 : ℂ) + (v : ℂ) * I)) := by
    rw [continuous_iff_continuousAt]
    intro v
    apply ContinuousAt.comp
    · exact (Complex.differentiableAt_Gamma _ (by
        intro m hm
        have hre := congrArg Complex.re hm
        simp at hre
        have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
        linarith)).continuousAt
    · fun_prop
  have hcont : Continuous (fun v : ℝ => ‖Complex.Gamma ((1 : ℂ) + (v : ℂ) * I)‖) :=
    hcontGamma.norm
  obtain ⟨v0, hv0, hmin⟩ := isCompact_Icc.exists_isMinOn
    (show (Set.Icc (-1 : ℝ) 1).Nonempty from ⟨0, by norm_num⟩) hcont.continuousOn
  set m : ℝ := ‖Complex.Gamma ((1 : ℂ) + (v0 : ℂ) * I)‖ with hm
  have hm_pos : 0 < m := by
    rw [hm]
    apply norm_pos_iff.mpr
    apply Complex.Gamma_ne_zero_of_re_pos
    simp
  have hGR : ∀ y : ℝ, ‖Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)‖
      = (1 / Real.pi) * ‖Complex.Gamma ((1 : ℂ) + ((y / 2 : ℝ) : ℂ) * I)‖ := by
    intro y
    rw [Complex.Gammaℝ_def, norm_mul]
    have hpow : ‖(Real.pi : ℂ) ^ (-(((2 : ℂ) + (y : ℂ) * I)) / 2)‖ = 1 / Real.pi := by
      rw [Complex.norm_cpow_eq_rpow_re_of_pos Real.pi_pos]
      have hre : (-(((2 : ℂ) + (y : ℂ) * I)) / 2).re = -1 := by simp
      rw [hre, Real.rpow_neg_one]
      ring
    rw [hpow]
    congr 1
    congr 1
    push_cast
    ring
  refine ⟨min m (Real.pi / 2) / Real.pi, 2 * (Real.pi + 1), ?_, ?_, ?_⟩
  · positivity
  · positivity
  · intro y
    rcases le_or_gt |y| 2 with hyle | hylt
    · have hvle : |y / 2| ≤ 1 := by
        rw [abs_div]
        norm_num
        linarith
      have hmem : y / 2 ∈ Set.Icc (-1 : ℝ) 1 := by
        rw [Set.mem_Icc]
        constructor <;> linarith [abs_le.mp hvle, neg_abs_le (y/2), le_abs_self (y/2)]
      have hminy : m ≤ ‖Complex.Gamma ((1 : ℂ) + ((y / 2 : ℝ) : ℂ) * I)‖ :=
        hmin (a := y / 2) hmem
      have hminle : min m (Real.pi / 2) / Real.pi ≤ m / Real.pi :=
        div_le_div_of_nonneg_right (min_le_left _ _) (by positivity)
      have hexp_le : Real.exp (-((2 * (Real.pi + 1)) * |y|)) ≤ 1 := by
        rw [Real.exp_le_one_iff]; nlinarith [abs_nonneg y, Real.pi_pos]
      calc (min m (Real.pi / 2) / Real.pi) * Real.exp (-((2 * (Real.pi + 1)) * |y|))
          ≤ (m / Real.pi) * 1 := by
            apply mul_le_mul hminle hexp_le (Real.exp_pos _).le (by positivity)
        _ = m / Real.pi := by ring
        _ ≤ ‖Complex.Gamma ((1 : ℂ) + ((y / 2 : ℝ) : ℂ) * I)‖ / Real.pi :=
            div_le_div_of_nonneg_right hminy (by positivity)
        _ = (1 / Real.pi) * ‖Complex.Gamma ((1 : ℂ) + ((y / 2 : ℝ) : ℂ) * I)‖ := by ring
        _ = ‖Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)‖ := by rw [hGR y]
    · have hvgt : 1 < |y / 2| := by
        rw [abs_div]; norm_num; linarith
      have hvne : y / 2 ≠ 0 := by
        intro hv; rw [hv] at hvgt; norm_num at hvgt
      have hlow := Gamma_one_add_I_lower (y / 2) hvne
      have hminle : min m (Real.pi / 2) / Real.pi ≤ 1 / 2 := by
        calc min m (Real.pi / 2) / Real.pi ≤ (Real.pi / 2) / Real.pi :=
              div_le_div_of_nonneg_right (min_le_right _ _) (by positivity)
          _ = 1 / 2 := by field_simp
      have h1 : 1 ≤ |y / 2| := le_of_lt hvgt
      have hB : 4 * (Real.pi + 1) * |y / 2| = 2 * (Real.pi + 1) * |y| := by
        rw [abs_div]; norm_num; ring
      have hexp_le : Real.exp (-((2 * (Real.pi + 1)) * |y|))
          ≤ Real.exp (-(Real.pi * |y / 2|)) := by
        rw [← hB]
        apply Real.exp_le_exp.mpr
        nlinarith [abs_nonneg (y/2), Real.pi_pos]
      have hexp_le2 : Real.exp (-(Real.pi * |y / 2|)) ≤ |y / 2| * Real.exp (-(Real.pi * |y / 2|)) := by
        have h := mul_le_mul_of_nonneg_right h1 (Real.exp_pos (-(Real.pi * |y / 2|))).le
        simpa using h
      have hchain : (min m (Real.pi / 2) / Real.pi) * Real.exp (-((2 * (Real.pi + 1)) * |y|))
          ≤ (1 / 2) * (|y / 2| * Real.exp (-(Real.pi * |y / 2|))) := by
        apply mul_le_mul hminle ?_ (Real.exp_pos _).le (by norm_num)
        calc Real.exp (-((2 * (Real.pi + 1)) * |y|))
            ≤ Real.exp (-(Real.pi * |y / 2|)) := hexp_le
          _ ≤ |y / 2| * Real.exp (-(Real.pi * |y / 2|)) := hexp_le2
      have hstep : (1 / 2) * (|y / 2| * Real.exp (-(Real.pi * |y / 2|)))
          = (1 / Real.pi) * (Real.pi * |y / 2| / (2 * Real.exp (Real.pi * |y / 2|))) := by
        rw [Real.exp_neg]
        field_simp [(Real.exp_pos (Real.pi * |y / 2|)).ne']
      calc (min m (Real.pi / 2) / Real.pi) * Real.exp (-((2 * (Real.pi + 1)) * |y|))
          ≤ (1 / 2) * (|y / 2| * Real.exp (-(Real.pi * |y / 2|))) := hchain
        _ = (1 / Real.pi) * (Real.pi * |y / 2| / (2 * Real.exp (Real.pi * |y / 2|))) := hstep
        _ ≤ (1 / Real.pi) * ‖Complex.Gamma ((1 : ℂ) + ((y / 2 : ℝ) : ℂ) * I)‖ :=
            mul_le_mul_of_nonneg_left hlow (by positivity)
        _ = ‖Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)‖ := (hGR y).symm









theorem exists_verticalLogDerivIntegrable_two (c : ℝ) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ 2 := by
  obtain ⟨a, B, ha, hB, hΓ⟩ := gammaR_lower_bound_two
  obtain ⟨cz, hcz, hζ⟩ := exists_zeta_lower_bound_right 2 (by norm_num)
  have hlower : ∀ y : ℝ, (a * cz) * Real.exp (-(B * |y|))
      ≤ ‖completedZeta ((2 : ℂ) + (y : ℂ) * I)‖ := by
    intro y
    have hs0 : ((2 : ℂ) + (y : ℂ) * I) ≠ 0 := by
      intro h
      have := congrArg Complex.re h
      simp at this
    have hs1 : ((2 : ℂ) + (y : ℂ) * I) ≠ 1 := by
      intro h
      have := congrArg Complex.re h
      simp at this
    have hΓs : Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I) ≠ 0 := by
      apply Complex.Gammaℝ_ne_zero_of_re_pos
      simp
    have hZ : completedZeta ((2 : ℂ) + (y : ℂ) * I)
        = Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)
            * riemannZeta ((2 : ℂ) + (y : ℂ) * I) := by
      rw [completedZeta_eq_completedRiemannZeta hs0 hs1 hΓs]
      have h := riemannZeta_def_of_ne_zero (s := (2 : ℂ) + (y : ℂ) * I) hs0
      rw [h]
      field_simp [hΓs]
    rw [hZ, norm_mul]
    have hγ := hΓ y
    have hζy := hζ y
    calc (a * cz) * Real.exp (-(B * |y|))
        = (a * Real.exp (-(B * |y|))) * cz := by ring
      _ ≤ ‖Complex.Gammaℝ ((2 : ℂ) + (y : ℂ) * I)‖
            * ‖riemannZeta ((2 : ℂ) + (y : ℂ) * I)‖ :=
          mul_le_mul hγ hζy hcz.le (norm_nonneg _)
  exact exists_positive_verticalLogDerivIntegrable_of_right_lower c 2 (1 / 10)
    (a * cz) B (by norm_num) (by norm_num) (mul_pos ha hcz) hB hlower

theorem exists_verticalLogDerivIntegrable_neg_one (c : ℝ) :
    ∃ σ : ℝ, 0 < σ ∧ VerticalLogDerivIntegrable c σ (-1) := by
  obtain ⟨σ, hσ, h⟩ := exists_verticalLogDerivIntegrable_two c
  exact ⟨σ, hσ, verticalLogDerivIntegrable_left_of_right c σ hσ h⟩

end LogDerivativeGrowth
