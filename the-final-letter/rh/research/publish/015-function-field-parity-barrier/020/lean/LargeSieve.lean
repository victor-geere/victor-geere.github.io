/-
  LargeSieve.lean — 020 round 114.

  Two normalisations behind the large sieve: the Cauchy–Schwarz step that turns
  the sum of squared class counts into a lower bound, and the size of the
  support (the number of monic polynomials of degree at most κ).
-/
import Mathlib

open Finset
open scoped BigOperators

namespace LargeSieve

/-- Cauchy–Schwarz for the class counts: the second moment dominates `T²/card`. -/
theorem class_second_moment {ι : Type*} [Fintype ι] (N : ι → ℝ) :
    (∑ a, N a) ^ 2 ≤ (Fintype.card ι : ℝ) * ∑ a, N a ^ 2 := by
  simpa using sq_sum_le_card_mul_sum_sq (s := (univ : Finset ι)) (f := N)

/-- The size of the level-`κ` support: `1 + q + … + q^κ = (q^{κ+1} − 1)/(q − 1)`. -/
theorem geom_support (q : ℤ) (k : ℕ) :
    (Finset.range (k + 1)).sum (fun i => q ^ i) * (q - 1) = q ^ (k + 1) - 1 := by
  induction k with
  | zero => simp
  | succ k ih =>
    rw [Finset.sum_range_succ, add_mul, ih]
    ring

end LargeSieve
