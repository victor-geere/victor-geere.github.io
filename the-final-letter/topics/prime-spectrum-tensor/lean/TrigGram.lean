import Mathlib

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The finite Fejér identity: the cosine kernel Gram form is a sum of squares. -/
theorem cos_quadratic_form {ι : Type*} [Fintype ι] (a x : ι → ℝ) (t : ℝ) :
    ∑ i, ∑ j, x i * x j * Real.cos ((a i - a j) * t)
      = (∑ i, x i * Real.cos (a i * t)) ^ 2 + (∑ i, x i * Real.sin (a i * t)) ^ 2 := by
  rw [sq, sq, Finset.sum_mul_sum, Finset.sum_mul_sum, ← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [show (a i - a j) * t = a i * t - a j * t by ring, Real.cos_sub]
  ring

/-- The cosine kernel Gram form is non-negative. -/
theorem cos_quadratic_form_nonneg {ι : Type*} [Fintype ι] (a x : ι → ℝ) (t : ℝ) :
    0 ≤ ∑ i, ∑ j, x i * x j * Real.cos ((a i - a j) * t) := by
  rw [cos_quadratic_form]
  positivity

end PrimeSpectrumTensor
