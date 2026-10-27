/-
  Doubling.lean — 018 round 29

  The cusp-doubling: at the degenerate quartic `x^4 + b` the density is
  `(q-1)/2`, twice the generic `j`-line density `(q-1)/4`.  A concrete
  witness: over `F_5` the reducible member `x^4 + 1` is the product of the
  two quadratics `x^2 + 2` and `x^2 + 3`.
-/
import Mathlib

namespace Doubling

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- At every point of `F_5`, `x^4 + 1 = (x^2 + 2)(x^2 + 3)`. -/
theorem x4_add_one_eval : ∀ x : ZMod 5, x ^ 4 + 1 = (x ^ 2 + 2) * (x ^ 2 + 3) := by
  decide

end Doubling
