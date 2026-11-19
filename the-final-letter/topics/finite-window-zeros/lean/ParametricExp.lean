/-
# Differentiation under the integral sign for exponential kernels

This file proves the generic parametric derivative lemma
`HasDerivAt (fun u => ∫ y in a..b, f y * exp (-(u : ℂ) * y))
  (∫ y in a..b, f y * (-(y : ℂ)) * exp (-(u : ℂ) * y)) u`
for continuous `f` on the interval of integration.

The proof is an application of Mathlib's interval parametric-integral theorem
`intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le`.
-/
import Mathlib

noncomputable section

open Complex MeasureTheory
open scoped Interval Topology

namespace FiniteWindowZeros

/-- Differentiation under the integral sign for `f y * exp (-(u : ℂ) * y)` on an
unordered interval `[[a, b]]`.  No ordering assumption on `a` and `b` is needed:
`ContinuousOn f (uIcc a b)` is continuity on the interval between the endpoints. -/
theorem hasDerivAt_integral_exp_mul_uIcc {f : ℝ → ℂ} {a b u : ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) :
    HasDerivAt (fun u : ℝ =>
      ∫ y : ℝ in a..b, f y * Complex.exp (-(u : ℂ) * (y : ℂ)))
      (∫ y : ℝ in a..b,
        f y * (-(y : ℂ)) * Complex.exp (-(u : ℂ) * (y : ℂ))) u := by
  -- Bound `‖f‖` on the interval of integration.
  obtain ⟨C, hC⟩ := isCompact_uIcc.exists_bound_of_continuousOn hf
  -- `M` bounds `|y|` for `y ∈ [[a,b]]`, and `R` bounds `|x|` for `x` near `u`.
  let M : ℝ := max |a| |b|
  let R : ℝ := |u| + 1
  let C' : ℝ := max C 0
  let B : ℝ := C' * M * Real.exp (R * M)
  have hM0 : 0 ≤ M := le_trans (abs_nonneg a) (le_max_left _ _)
  have hR0 : 0 ≤ R := by positivity
  have hC'0 : 0 ≤ C' := le_max_right _ _
  -- The pointwise derivative in `u`.
  have hderiv : ∀ y x : ℝ,
      HasDerivAt (fun x : ℝ => f y * Complex.exp (-(x : ℂ) * (y : ℂ)))
        (f y * (-(y : ℂ)) * Complex.exp (-(x : ℂ) * (y : ℂ))) x := by
    intro y x
    have h1 : HasDerivAt (fun x : ℝ => (x : ℂ)) (1 : ℂ) x :=
      Complex.ofRealCLM.hasDerivAt
    have h2 : HasDerivAt (fun x : ℝ => (x : ℂ) * (y : ℂ)) (y : ℂ) x := by
      simpa using h1.mul_const (y : ℂ)
    have hlin : HasDerivAt (fun x : ℝ => -((x : ℂ) * (y : ℂ))) (-(y : ℂ)) x := by
      simpa only [Pi.neg_def] using h2.neg
    have h3 : HasDerivAt (fun x : ℝ => Complex.exp (-((x : ℂ) * (y : ℂ))))
        (Complex.exp (-((x : ℂ) * (y : ℂ))) * (-(y : ℂ))) x := by
      simpa only [Function.comp_def] using
        (Complex.hasDerivAt_exp (-((x : ℂ) * (y : ℂ)))).comp x hlin
    have h4 : HasDerivAt (fun x : ℝ => f y * Complex.exp (-((x : ℂ) * (y : ℂ))))
        (f y * (Complex.exp (-((x : ℂ) * (y : ℂ))) * (-(y : ℂ)))) x :=
      h3.const_mul (f y)
    have h5 : HasDerivAt (fun x : ℝ => f y * Complex.exp (-(x : ℂ) * (y : ℂ)))
        (f y * (Complex.exp (-(x : ℂ) * (y : ℂ)) * (-(y : ℂ)))) x := by
      simpa only [neg_mul] using h4
    exact h5.congr_deriv (by ring)
  -- Measurability of the integrands.
  have hcont : ∀ x : ℝ, ContinuousOn
      (fun y : ℝ => f y * Complex.exp (-(x : ℂ) * (y : ℂ))) (Set.uIcc a b) := by
    intro x
    exact hf.mul (by fun_prop)
  have hcont' : ContinuousOn
      (fun y : ℝ => f y * (-(y : ℂ)) * Complex.exp (-(u : ℂ) * (y : ℂ)))
      (Set.uIcc a b) := by
    exact (hf.mul (by fun_prop)).mul (by fun_prop)
  have hF_meas : ∀ᶠ (x : ℝ) in 𝓝 u, AEStronglyMeasurable
      (fun y : ℝ => f y * Complex.exp (-(x : ℂ) * (y : ℂ)))
      (volume.restrict (Ι a b)) := by
    filter_upwards with x
    exact (hcont x).aestronglyMeasurable_of_subset_isCompact isCompact_uIcc
      measurableSet_uIoc Set.uIoc_subset_uIcc
  have hF'_meas : AEStronglyMeasurable
      (fun y : ℝ => f y * (-(y : ℂ)) * Complex.exp (-(u : ℂ) * (y : ℂ)))
      (volume.restrict (Ι a b)) :=
    hcont'.aestronglyMeasurable_of_subset_isCompact isCompact_uIcc
      measurableSet_uIoc Set.uIoc_subset_uIcc
  -- The fixed-`u` integrand is interval integrable.
  have hF_int : IntervalIntegrable
      (fun y : ℝ => f y * Complex.exp (-(u : ℂ) * (y : ℂ))) volume a b :=
    (hcont u).intervalIntegrable
  -- A constant dominating all `u`-derivatives for `u` in `[u-1, u+1]`.
  have hbound : ∀ᵐ y ∂volume, y ∈ Ι a b →
      ∀ x ∈ Set.Icc (u - 1) (u + 1),
        ‖f y * (-(y : ℂ)) * Complex.exp (-(x : ℂ) * (y : ℂ))‖ ≤ B := by
    filter_upwards with y hy x hx
    have hyIcc : y ∈ Set.Icc (min a b) (max a b) := Set.uIoc_subset_uIcc hy
    have hmin : min a b ≤ y := hyIcc.1
    have hmax : y ≤ max a b := hyIcc.2
    have hyM : |y| ≤ M := by
      rcases le_total a b with hab | hba
      · simp only [min_eq_left hab, max_eq_right hab] at hmin hmax
        exact abs_le_max_abs_abs (b := y) hmin hmax
      · simp only [min_eq_right hba, max_eq_left hba] at hmin hmax
        calc |y| ≤ max |b| |a| := abs_le_max_abs_abs (b := y) hmin hmax
          _ = M := by simp [M, max_comm]
    have hxR : |x| ≤ R := by
      have h1 : -(R) ≤ x := by
        have := neg_abs_le u
        simp only [R] at *
        linarith [hx.1]
      have h2 : x ≤ R := by
        have := le_abs_self u
        simp only [R] at *
        linarith [hx.2]
      exact abs_le.2 ⟨h1, h2⟩
    have hfC : ‖f y‖ ≤ C' := (hC y (Set.uIoc_subset_uIcc hy)).trans (le_max_left _ _)
    have hynorm : ‖(y : ℂ)‖ ≤ M := by
      rw [Complex.norm_real, Real.norm_eq_abs]
      exact hyM
    have hexp : ‖Complex.exp (-(x : ℂ) * (y : ℂ))‖ ≤ Real.exp (R * M) := by
      calc ‖Complex.exp (-(x : ℂ) * (y : ℂ))‖
          ≤ Real.exp ‖(-(x : ℂ) * (y : ℂ))‖ := Complex.norm_exp_le_exp_norm _
        _ ≤ Real.exp (R * M) := by
          apply Real.exp_le_exp.2
          rw [norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs,
            Complex.norm_real, Real.norm_eq_abs]
          exact mul_le_mul hxR hyM (abs_nonneg y) hR0
    have hnormeq : ‖f y * (-(y : ℂ)) * Complex.exp (-(x : ℂ) * (y : ℂ))‖
        = ‖f y‖ * ‖(y : ℂ)‖ * ‖Complex.exp (-(x : ℂ) * (y : ℂ))‖ := by
      rw [norm_mul, norm_mul, norm_neg]
    rw [hnormeq]
    exact mul_le_mul (mul_le_mul hfC hynorm (norm_nonneg _) hC'0) hexp
      (norm_nonneg _) (mul_nonneg hC'0 hM0)
  -- Pointwise derivative for every `x` in the neighbourhood of `u`.
  have hdiff : ∀ᵐ y ∂volume, y ∈ Ι a b →
      ∀ x ∈ Set.Icc (u - 1) (u + 1),
        HasDerivAt (fun x : ℝ => f y * Complex.exp (-(x : ℂ) * (y : ℂ)))
          (f y * (-(y : ℂ)) * Complex.exp (-(x : ℂ) * (y : ℂ))) x := by
    filter_upwards with y _hy x _hx
    exact hderiv y x
  -- Apply the parametric interval-integral theorem.
  have hmain := intervalIntegral.hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (F := fun (x : ℝ) (y : ℝ) => f y * Complex.exp (-(x : ℂ) * (y : ℂ)))
    (F' := fun (x : ℝ) (y : ℝ) => f y * (-(y : ℂ)) * Complex.exp (-(x : ℂ) * (y : ℂ)))
    (x₀ := u) (s := Set.Icc (u - 1) (u + 1)) (μ := volume) (bound := fun _ => B)
    (Icc_mem_nhds (by linarith) (by linarith)) hF_meas hF_int hF'_meas hbound
    intervalIntegrable_const hdiff
  exact hmain.2

/-- Differentiation under the integral sign for `f y * exp (-(u : ℂ) * y)` on
`[a, b]`, for `a ≤ b` and `f` continuous on `[a, b]`.

Note: the hypothesis `hab : a ≤ b` is necessary.  When `a > b`, Mathlib's
`Set.Icc a b` is empty, so `ContinuousOn f (Set.Icc a b)` carries no information
about `f` on the actual interval of integration `[b, a]`.  Use
`hasDerivAt_integral_exp_mul_uIcc` for the unordered-interval version. -/
theorem hasDerivAt_integral_exp_mul {f : ℝ → ℂ} {a b u : ℝ}
    (hab : a ≤ b) (hf : ContinuousOn f (Set.Icc a b)) :
    HasDerivAt (fun u : ℝ =>
      ∫ y : ℝ in a..b, f y * Complex.exp (-(u : ℂ) * (y : ℂ)))
      (∫ y : ℝ in a..b,
        f y * (-(y : ℂ)) * Complex.exp (-(u : ℂ) * (y : ℂ))) u :=
  hasDerivAt_integral_exp_mul_uIcc (by simpa [Set.uIcc_of_le hab] using hf)

end FiniteWindowZeros
