/-
  Budget.lean — the rh42 "helix budget": closed forms for the signed zeta alphabet.
-/
import Mathlib

/-!
# The rh42 helix budget

The rh42 alphabet is signed: positive letters sit at the even denominators `2k`,
negative letters at the odd denominators `2k + 1`, with `k ≥ 1`.  This file
computes the total `p`-mass of each half of the alphabet in closed form from
Mathlib's zeta values `ζ(2) = π²/6` and `ζ(4) = π⁴/90`:

* positive budget `P(p) = Σ_{k≥1} (2k)^{-p}`: `P(2) = π²/24`, `P(4) = π⁴/1440`;
* negative budget `N(p) = Σ_{k≥1} (2k+1)^{-p}`: `N(2) = π²/8 - 1`, `N(4) = π⁴/96 - 1`.

The signed alphabet is balanced at weight two: `P(2) + N(2) = π²/6 - 1`.  Every
proof below splits `∑ 1/nᵖ` into its even and odd subseries, using that the
`k = 0` even term vanishes under the convention `1 / 0 = 0`.  The development is
complete: no unsolved goals, and no axioms beyond Mathlib's own.
-/

namespace Rh42

/-! ## The even half -/

/-- Even terms at weight two: `1 / (2k)^2 = (1/4) * (1/k^2)`.  The `k = 0` case
holds under the convention `1 / 0 = 0`. -/
lemma even_term_two (k : ℕ) :
    (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 2 = (1 / 4 : ℝ) * (1 / (k : ℝ) ^ 2) := by
  push_cast
  rw [mul_pow, div_mul_div_comm]
  norm_num

/-- Even terms at weight four: `1 / (2k)^4 = (1/16) * (1/k^4)`. -/
lemma even_term_four (k : ℕ) :
    (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 4 = (1 / 16 : ℝ) * (1 / (k : ℝ) ^ 4) := by
  push_cast
  rw [mul_pow, div_mul_div_comm]
  norm_num

theorem hasSum_even_zeta_two :
    HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 2) (Real.pi ^ 2 / 24) := by
  have h : HasSum (fun k : ℕ => (1 / 4 : ℝ) * (1 / (k : ℝ) ^ 2))
      ((1 / 4 : ℝ) * (Real.pi ^ 2 / 6)) :=
    HasSum.mul_left (1 / 4 : ℝ) hasSum_zeta_two
  have hfun : (fun k : ℕ => (1 / 4 : ℝ) * (1 / (k : ℝ) ^ 2))
      = fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 2 := by
    funext k
    exact (even_term_two k).symm
  rw [hfun] at h
  rw [show (1 / 4 : ℝ) * (Real.pi ^ 2 / 6) = Real.pi ^ 2 / 24 by ring] at h
  exact h

theorem hasSum_even_zeta_four :
    HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 4) (Real.pi ^ 4 / 1440) := by
  have h : HasSum (fun k : ℕ => (1 / 16 : ℝ) * (1 / (k : ℝ) ^ 4))
      ((1 / 16 : ℝ) * (Real.pi ^ 4 / 90)) :=
    HasSum.mul_left (1 / 16 : ℝ) hasSum_zeta_four
  have hfun : (fun k : ℕ => (1 / 16 : ℝ) * (1 / (k : ℝ) ^ 4))
      = fun k : ℕ => (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 4 := by
    funext k
    exact (even_term_four k).symm
  rw [hfun] at h
  rw [show (1 / 16 : ℝ) * (Real.pi ^ 4 / 90) = Real.pi ^ 4 / 1440 by ring] at h
  exact h

/-! ## The odd half -/

/-- The map `k ↦ 2k + 1` is injective, so odd subseries of summable series are summable. -/
lemma injective_two_mul_add_one : Function.Injective (fun k : ℕ => 2 * k + 1) := by
  intro a b hab
  have hab' : 2 * a + 1 = 2 * b + 1 := hab
  omega

/-- The odd second-power subseries of `ζ(2)` is summable. -/
lemma summable_odd_zeta_two :
    Summable (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2) :=
  Summable.comp_injective (f := fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 2)
    (i := fun k : ℕ => 2 * k + 1) hasSum_zeta_two.summable injective_two_mul_add_one

/-- The odd fourth-power subseries of `ζ(4)` is summable. -/
lemma summable_odd_zeta_four :
    Summable (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4) :=
  Summable.comp_injective (f := fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 4)
    (i := fun k : ℕ => 2 * k + 1) hasSum_zeta_four.summable injective_two_mul_add_one

theorem tsum_odd_zeta_two :
    (∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 8 := by
  have h : (∑' k : ℕ, (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 2)
      + (∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2)
      = (∑' k : ℕ, (1 : ℝ) / (k : ℝ) ^ 2) :=
    tsum_even_add_odd (f := fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 2)
      hasSum_even_zeta_two.summable summable_odd_zeta_two
  rw [hasSum_even_zeta_two.tsum_eq, hasSum_zeta_two.tsum_eq] at h
  linarith

theorem tsum_odd_zeta_four :
    (∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 96 := by
  have h : (∑' k : ℕ, (1 : ℝ) / ((2 * k : ℕ) : ℝ) ^ 4)
      + (∑' k : ℕ, (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4)
      = (∑' k : ℕ, (1 : ℝ) / (k : ℝ) ^ 4) :=
    tsum_even_add_odd (f := fun n : ℕ => (1 : ℝ) / (n : ℝ) ^ 4)
      hasSum_even_zeta_four.summable summable_odd_zeta_four
  rw [hasSum_even_zeta_four.tsum_eq, hasSum_zeta_four.tsum_eq] at h
  linarith

/-- `HasSum` form of the odd second-power budget, used to shift the indexing to `k ≥ 1`. -/
lemma hasSum_odd_zeta_two :
    HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 2) (Real.pi ^ 2 / 8) := by
  have h := summable_odd_zeta_two.hasSum
  rwa [tsum_odd_zeta_two] at h

/-- `HasSum` form of the odd fourth-power budget. -/
lemma hasSum_odd_zeta_four :
    HasSum (fun k : ℕ => (1 : ℝ) / ((2 * k + 1 : ℕ) : ℝ) ^ 4) (Real.pi ^ 4 / 96) := by
  have h := summable_odd_zeta_four.hasSum
  rwa [tsum_odd_zeta_four] at h

/-! ## The budgets, indexed from `k ≥ 1` -/

theorem positiveBudget_two :
    (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 24 := by
  have h : HasSum (fun n : ℕ => (1 : ℝ) / ((2 * (n + 1) : ℕ) : ℝ) ^ 2)
      (Real.pi ^ 2 / 24) := by
    simpa [Finset.sum_range_one] using
      (hasSum_nat_add_iff' (f := fun j : ℕ => (1 : ℝ) / ((2 * j : ℕ) : ℝ) ^ 2) 1).2
        hasSum_even_zeta_two
  exact h.tsum_eq

theorem negativeBudget_two :
    (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 8 - 1 := by
  have h : HasSum (fun n : ℕ => (1 : ℝ) / ((2 * (n + 1) + 1 : ℕ) : ℝ) ^ 2)
      (Real.pi ^ 2 / 8 - 1) := by
    simpa [Finset.sum_range_one] using
      (hasSum_nat_add_iff' (f := fun j : ℕ => (1 : ℝ) / ((2 * j + 1 : ℕ) : ℝ) ^ 2) 1).2
        hasSum_odd_zeta_two
  exact h.tsum_eq

theorem positiveBudget_four :
    (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 1440 := by
  have h : HasSum (fun n : ℕ => (1 : ℝ) / ((2 * (n + 1) : ℕ) : ℝ) ^ 4)
      (Real.pi ^ 4 / 1440) := by
    simpa [Finset.sum_range_one] using
      (hasSum_nat_add_iff' (f := fun j : ℕ => (1 : ℝ) / ((2 * j : ℕ) : ℝ) ^ 4) 1).2
        hasSum_even_zeta_four
  exact h.tsum_eq

theorem negativeBudget_four :
    (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 4) = Real.pi ^ 4 / 96 - 1 := by
  have h : HasSum (fun n : ℕ => (1 : ℝ) / ((2 * (n + 1) + 1 : ℕ) : ℝ) ^ 4)
      (Real.pi ^ 4 / 96 - 1) := by
    simpa [Finset.sum_range_one] using
      (hasSum_nat_add_iff' (f := fun j : ℕ => (1 : ℝ) / ((2 * j + 1 : ℕ) : ℝ) ^ 4) 1).2
        hasSum_odd_zeta_four
  exact h.tsum_eq

theorem budget_two_sum :
    (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) : ℕ) : ℝ) ^ 2)
      + (∑' k : ℕ, (1 : ℝ) / ((2 * (k + 1) + 1 : ℕ) : ℝ) ^ 2) = Real.pi ^ 2 / 6 - 1 := by
  rw [positiveBudget_two, negativeBudget_two]
  ring

end Rh42
