import Mathlib

/-!
# The non-archimedean sign structure of the explicit formula

For a non-negative test function the pole term is non-negative and the prime
sum is non-positive.  The archimedean term is the one with variable sign;
this file records the two definite signs.
-/

open scoped BigOperators

namespace AbsoluteHodgeWeil

/-- The pole term `2 ∫ h cosh(x/2)` is non-negative for `h ≥ 0`. -/
theorem pole_term_nonneg (h : ℝ → ℝ) (hh : ∀ x, 0 ≤ h x) :
    0 ≤ ∫ x in (-2)..2, h x * Real.cosh (x / 2) := by
  apply intervalIntegral.integral_nonneg (by norm_num)
  intro x _
  exact mul_nonneg (hh x) (Real.cosh_pos _).le

/-- The prime term `-2 ∑ Λ(n)/√n h(log n)` is non-positive for `h ≥ 0`. -/
theorem prime_term_nonpos (h : ℝ → ℝ) (hh : ∀ x, 0 ≤ h x) (N : ℕ) :
    (∑ n ∈ Finset.range N,
      -(2 * (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n)
        * h (Real.log n)) ≤ 0 := by
  apply Finset.sum_nonpos
  intro n _
  have hL : 0 ≤ (ArithmeticFunction.vonMangoldt n : ℝ) := by
    exact_mod_cast ArithmeticFunction.vonMangoldt_nonneg
  have hs : 0 ≤ Real.sqrt n := Real.sqrt_nonneg n
  have hc : 0 ≤ 2 * (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n := by
    positivity
  exact mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hc) (hh (Real.log n))

end AbsoluteHodgeWeil
