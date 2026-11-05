import Mathlib

/-!
# The Gaussian moment tail

`∫_T^∞ (1/400)·x·exp(−x²/400) dx = exp(−T²/400)/2`, from the antiderivative
`−(1/2)exp(−x²/400)` (`MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto'`)
and Mathlib's Gaussian integrability `integrable_mul_exp_neg_mul_sq`.
-/

noncomputable section

open Filter
open scoped Topology

namespace PrimeSpectrumTensor

theorem tendsto_gauss_neg {b : ℝ} (hb : 0 < b) :
    Tendsto (fun y : ℝ => Real.exp (-(b * y ^ 2))) atTop (𝓝 0) := by
  have hid : Tendsto (fun y : ℝ => y) atTop atTop := tendsto_id
  have h2 : Tendsto (fun y : ℝ => y ^ 2) atTop atTop := by simpa using hid.pow 2
  have hdiv : Tendsto (fun y : ℝ => b * y ^ 2) atTop atTop :=
    Filter.Tendsto.const_mul_atTop hb h2
  exact Real.tendsto_exp_neg_atTop_nhds_zero.comp hdiv

/-- **The Gaussian moment tail.** -/
theorem integral_Ioi_gaussian_moment (T : ℝ) :
    ∫ x in Set.Ioi T, (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400)) =
      Real.exp (-(T ^ 2 / 400)) / 2 := by
  have hderiv : ∀ x ∈ Set.Ioi T,
      HasDerivAt (fun y : ℝ => -(1 / 2) * Real.exp (-(y ^ 2 / 400)))
        ((1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400))) x := by
    intro x hx
    have h1 : HasDerivAt (fun y : ℝ => -(y ^ 2 / 400)) (-(2 * x / 400)) x := by
      have h2 : HasDerivAt (fun y : ℝ => y ^ 2) (2 * x) x := by
        simpa using hasDerivAt_pow 2 x
      have h3 : HasDerivAt (fun y : ℝ => y ^ 2 / 400) (2 * x / 400) x := h2.div_const 400
      exact h3.neg
    have h4 := h1.exp
    have h5 := h4.const_mul (-(1 / 2))
    convert h5 using 1
    ring
  have hint : MeasureTheory.IntegrableOn
      (fun x : ℝ => (1 / 400 : ℝ) * x * Real.exp (-(x ^ 2 / 400))) (Set.Ioi T) := by
    have h := integrable_mul_exp_neg_mul_sq (b := 1 / 400) (by norm_num)
    have h2 := h.const_mul (1 / 400 : ℝ)
    refine h2.integrableOn.congr_fun ?_ measurableSet_Ioi
    intro x _
    ring_nf
  have htend : Tendsto (fun y : ℝ => -(1 / 2) * Real.exp (-(y ^ 2 / 400))) atTop (𝓝 0) := by
    have h := tendsto_gauss_neg (b := 1 / 400) (by norm_num)
    have h2 : (fun y : ℝ => -(1 / 2) * Real.exp (-(y ^ 2 / 400))) =
        fun y => -(1 / 2) * Real.exp (-((1 / 400 : ℝ) * y ^ 2)) := by
      funext y
      ring_nf
    rw [h2]
    have h3 := Tendsto.const_mul (-(1 / 2) : ℝ) h
    simpa using h3
  have hcont : ContinuousWithinAt (fun y : ℝ => -(1 / 2) * Real.exp (-(y ^ 2 / 400)))
      (Set.Ici T) T := by fun_prop
  have h := MeasureTheory.integral_Ioi_of_hasDerivAt_of_tendsto hcont hderiv hint htend
  rw [h]
  ring

end PrimeSpectrumTensor
