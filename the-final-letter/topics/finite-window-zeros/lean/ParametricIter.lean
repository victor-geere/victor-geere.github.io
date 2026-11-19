/-
# Iterated differentiation under the integral sign

Building on `ParametricExp.lean`, this file shows that the `k`-th derivative of
`u ↦ ∫ y in a..b, f y * exp (-(u : ℂ) * y)` is obtained by differentiating the
integrand `k` times,

`iteratedDeriv k F u = ∫ y in a..b, f y * (-(y : ℂ)) ^ k * exp (-(u : ℂ) * y)`,

and specialises this at `k = 4` to a crude explicit norm bound.
-/
import Mathlib
import ParametricExp

noncomputable section

open Complex MeasureTheory
open scoped Interval Topology

namespace FiniteWindowZeros

/-- **Iterated differentiation under the integral sign.**  For continuous `f` on
`[[a, b]]`, the `k`-th derivative of the exponential parametric integral is the
integral of the `k`-th derivative of the integrand with respect to `u`. -/
theorem iteratedDeriv_paramExp (k : ℕ) {f : ℝ → ℂ} {a b : ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) (u : ℝ) :
    iteratedDeriv k (fun u : ℝ =>
      ∫ y : ℝ in a..b, f y * Complex.exp (-(u : ℂ) * (y : ℂ))) u
      = ∫ y : ℝ in a..b,
        f y * (-(y : ℂ)) ^ k * Complex.exp (-(u : ℂ) * (y : ℂ)) := by
  induction k generalizing f with
  | zero => simp
  | succ k ih =>
      rw [iteratedDeriv_succ']
      -- The derivative of the parametric integral, by `ParametricExp`.
      have hderiv :
          deriv (fun u : ℝ =>
            ∫ y : ℝ in a..b, f y * Complex.exp (-(u : ℂ) * (y : ℂ)))
            = fun u : ℝ =>
              ∫ y : ℝ in a..b,
                f y * (-(y : ℂ)) * Complex.exp (-(u : ℂ) * (y : ℂ)) := by
        funext v
        exact (hasDerivAt_integral_exp_mul_uIcc hf).deriv
      rw [hderiv]
      -- Apply the induction hypothesis to `y ↦ f y * (-(y : ℂ))`.
      have hg : ContinuousOn (fun y : ℝ => f y * (-(y : ℂ))) (Set.uIcc a b) :=
        hf.mul (by fun_prop)
      rw [ih hg]
      congr 1 with y
      rw [pow_succ]
      ring

/-- **Crude fourth-derivative bound.**  The fourth derivative of the exponential
parametric integral is bounded by `C * M ^ 4 * |b - a| * exp (|u| * M)`, where
`C` bounds `‖f‖` and `M` bounds `|y|` on the interval of integration. -/
theorem norm_iteratedDeriv_four_paramExp_le {f : ℝ → ℂ} {a b : ℝ}
    (hf : ContinuousOn f (Set.uIcc a b)) {C M : ℝ}
    (hC : ∀ y ∈ Set.uIcc a b, ‖f y‖ ≤ C) (hC0 : 0 ≤ C)
    (hM : ∀ y ∈ Set.uIcc a b, |y| ≤ M) (hM0 : 0 ≤ M)
    (u : ℝ) :
    ‖iteratedDeriv 4 (fun u : ℝ =>
      ∫ y : ℝ in a..b, f y * Complex.exp (-(u : ℂ) * (y : ℂ))) u‖
      ≤ C * M ^ 4 * |b - a| * Real.exp (|u| * M) := by
  rw [iteratedDeriv_paramExp 4 hf u]
  have hbound : ∀ y ∈ Ι a b,
      ‖f y * (-(y : ℂ)) ^ 4 * Complex.exp (-(u : ℂ) * (y : ℂ))‖
        ≤ C * M ^ 4 * Real.exp (|u| * M) := by
    intro y hy
    have hyI : y ∈ Set.uIcc a b := Set.uIoc_subset_uIcc hy
    have hfn : ‖f y‖ ≤ C := hC y hyI
    have hym : |y| ≤ M := hM y hyI
    have hynorm : ‖(y : ℂ)‖ ≤ M := by
      rw [Complex.norm_real, Real.norm_eq_abs]
      exact hym
    have hpow : ‖(y : ℂ)‖ ^ 4 ≤ M ^ 4 :=
      pow_le_pow_left₀ (norm_nonneg _) hynorm 4
    have hexp : ‖Complex.exp (-(u : ℂ) * (y : ℂ))‖ ≤ Real.exp (|u| * M) := by
      calc ‖Complex.exp (-(u : ℂ) * (y : ℂ))‖
          ≤ Real.exp ‖(-(u : ℂ) * (y : ℂ))‖ := Complex.norm_exp_le_exp_norm _
        _ ≤ Real.exp (|u| * M) := by
          apply Real.exp_le_exp.2
          rw [norm_mul, norm_neg, Complex.norm_real, Real.norm_eq_abs,
            Complex.norm_real, Real.norm_eq_abs]
          exact mul_le_mul_of_nonneg_left hym (abs_nonneg u)
    calc ‖f y * (-(y : ℂ)) ^ 4 * Complex.exp (-(u : ℂ) * (y : ℂ))‖
        = ‖f y‖ * ‖(y : ℂ)‖ ^ 4 * ‖Complex.exp (-(u : ℂ) * (y : ℂ))‖ := by
          rw [norm_mul, norm_mul, norm_pow, norm_neg]
      _ ≤ C * M ^ 4 * Real.exp (|u| * M) :=
        mul_le_mul
          (mul_le_mul hfn hpow (pow_nonneg (norm_nonneg _) 4) hC0) hexp
          (norm_nonneg _) (mul_nonneg hC0 (pow_nonneg hM0 4))
  calc ‖∫ y : ℝ in a..b,
        f y * (-(y : ℂ)) ^ 4 * Complex.exp (-(u : ℂ) * (y : ℂ))‖
      ≤ (C * M ^ 4 * Real.exp (|u| * M)) * |b - a| :=
        intervalIntegral.norm_integral_le_of_norm_le_const hbound
    _ = C * M ^ 4 * |b - a| * Real.exp (|u| * M) := by ring

end FiniteWindowZeros
