import Mathlib
import GaussianGram
import PanelEnclosure

/-!
# R2 — the density term, via the shared analysis library

First leaf of R2. It relates the density term of `GaussianGram.lean`,

```
densityTerm c σ = σ² ∫_ℝ exp(−σ²t²) cos(ct) Ω(t) dt,
```

to the half-line density of the shared analysis library
(`intersection-form-zeta/lean/PanelEnclosure.lean`).  The integrand is even, so
the full-line integral is twice the half-line one.  The library's pointwise
enclosure `omega_mem` then applies directly.
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The archimedean density of `GaussianGram.lean` agrees with that of the
shared analysis library. -/
theorem omega_eq_Omega (t : ℝ) : omega t = IntersectionForm.Omega t := by
  unfold omega IntersectionForm.Omega
  have harg : ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2) =
      ((1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I) := by
    ring
  rw [harg]
  ring

/-- The integrand of the density term is even (in the library's `Omega`). -/
theorem density_integrand_neg (c σ t : ℝ) :
    Real.exp (-(σ * (-t)) ^ 2) * Real.cos (c * (-t)) * IntersectionForm.Omega (-t) =
      Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * IntersectionForm.Omega t := by
  have h1 : -(σ * (-t)) ^ 2 = -(σ * t) ^ 2 := by ring
  have h2 : c * (-t) = -(c * t) := by ring
  rw [h1, h2, Real.cos_neg, IntersectionForm.Omega_even]

/-- **The bridge.** The full-line density term is twice the half-line density of
the shared library. -/
theorem densityTerm_eq_two_mul_density (c σ : ℝ) :
    densityTerm c σ = 2 * IntersectionForm.density σ c := by
  have hG : ∀ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t =
      Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * IntersectionForm.Omega t := by
    intro t
    rw [omega_eq_Omega]
  have hd : IntersectionForm.density σ c =
      σ ^ 2 * ∫ t in Set.Ioi 0, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) *
        IntersectionForm.Omega t := by
    rw [IntersectionForm.density, ← MeasureTheory.integral_const_mul]
    refine MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun t _ => ?_
    unfold IntersectionForm.densityWeight
    ring
  have heven : (∫ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t) =
      ∫ t : ℝ,
        (fun u : ℝ => Real.exp (-(σ * u) ^ 2) * Real.cos (c * u) * omega u) |t| := by
    refine MeasureTheory.integral_congr_ae ?_
    filter_upwards with t
    by_cases ht : t < 0
    · rw [abs_of_neg ht]
      simp only [omega_eq_Omega]
      exact (density_integrand_neg c σ t).symm
    · rw [abs_of_nonneg (not_lt.mp ht)]
  have hI : (∫ t in Set.Ioi 0, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t) =
      ∫ t in Set.Ioi 0, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) *
        IntersectionForm.Omega t := by
    refine MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun t _ => hG t
  unfold densityTerm
  rw [heven, integral_comp_abs (f := fun u : ℝ => Real.exp (-(σ * u) ^ 2) * Real.cos (c * u) * omega u), hI, hd]
  ring

end PrimeSpectrumTensor
