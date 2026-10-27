/-
  NegSquare.lean — round 23 of the new programme (Target A)

  For `p = 1 (mod 4)`, `-1` is a square, so `(-1) * x^2` is a square.  Since
  `(-1) * x^2 = -x^2`, this is the key step in the `a2 = 0` composition proof:
  `-squares = squares`.
-/
import Mathlib

namespace NegSquare

/-- For `p % 4 = 1`, `(-1) * x²` is a square in `ZMod p`. -/
theorem neg_sq_mem_sq {p : ℕ} [Fact p.Prime] (hp : p % 4 = 1) (x : ZMod p) :
    IsSquare ((-1 : ZMod p) * x ^ 2) := by
  have h1 : IsSquare (-1 : ZMod p) :=
    ZMod.exists_sq_eq_neg_one_iff.mpr (by omega)
  exact h1.mul ⟨x, by ring⟩

end NegSquare
