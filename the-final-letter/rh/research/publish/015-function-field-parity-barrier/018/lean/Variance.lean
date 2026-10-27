/-
  Variance.lean — 018 round 20/21

  The degree-2 twin count over `F_5` takes only two values: `5` on the
  quadratic residues and `0` on the non-residues.  Hence its variance over
  the four nonzero shifts is `25/4` and its fourth central moment is `625/4`.
-/
import Mathlib

namespace Variance

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- The degree-2 twin count over `F_5` for shift `h`. -/
def twin2 (h : ZMod 5) : ℕ :=
  (Finset.univ.filter (fun p : ZMod 5 × ZMod 5 =>
    (∀ x : ZMod 5, x ^ 2 + p.1 * x + p.2 ≠ 0) ∧
    (∀ x : ZMod 5, x ^ 2 + p.1 * x + (p.2 + h) ≠ 0))).card

/-- The count takes only the values `5` and `0`. -/
theorem twin2_values :
    twin2 1 = 5 ∧ twin2 2 = 0 ∧ twin2 3 = 0 ∧ twin2 4 = 5 := by
  decide

/-- The fourth central moment of the degree-2 twin count over `F_5` is `625/4`
(the shift `0` is excluded from the average). -/
theorem twin2_fourth_moment :
    ((twin2 1 : ℚ) - 5 / 2) ^ 4 + ((twin2 2 : ℚ) - 5 / 2) ^ 4
      + ((twin2 3 : ℚ) - 5 / 2) ^ 4 + ((twin2 4 : ℚ) - 5 / 2) ^ 4 = 625 / 4 := by
  obtain ⟨h1, h2, h3, h4⟩ := twin2_values
  rw [h1, h2, h3, h4]
  norm_num

/-- Translation divisibility in the degree-2 case: `5 ∣ T(2;5,h)` for every
nonzero `h`.  The translation action `f ↦ f(X+a)` is free for `d = 2 < 5`. -/
theorem twin2_divisible : ∀ h : ZMod 5, h ≠ 0 → 5 ∣ twin2 h := by
  decide

end Variance
