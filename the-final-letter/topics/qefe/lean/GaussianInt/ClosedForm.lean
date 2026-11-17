import Mathlib
import GaussianInt.TwoSquares

/-!
# The two-squares formula, closed form

A single arithmetic-function identity in `n`:

`r₂(n) = 4 Σ_{d|n} χ₄(d)`,

with the character sum written inline.  This is the `d = 1` member of the trio
whose `d = 2` and `d = 3` members are
`ZsqrtdTwo.rTwo_closed` and `EisensteinInt.rThree_closed`.

No `sorry`, `axiom` or `admit`.
-/

noncomputable section

open scoped BigOperators

namespace GaussianInt

open Polynomial

/-- **The two-squares formula in closed form.** -/
theorem r2_closed (n : ℕ) (hn : 1 ≤ n) :
    (r2 n : ℤ) = 4 * ∑ d ∈ n.divisors, ZMod.χ₄ (d : ZMod 4) := by
  rw [twoSquaresFormula n hn]
  simp [divisorSumChi4]

end GaussianInt
