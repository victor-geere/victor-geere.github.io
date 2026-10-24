/-
  Composition.lean — round 22 of the new programme (Target A)

  For a composition `g(x) = x^4 + a2 x^2 = h(x^2)` the value set is redundant:
  every negated value is a quadratic-factor value,

      -g(x) = q (a2 - q)   with   q = x^2 + a2 .

  Hence `-Im(g) ⊆ Q`, and the reducible set is exactly `Q`.
-/
import Mathlib

namespace Composition

/-- The explicit preimage: `-g(x) = (x²+a₂)(a₂-(x²+a₂))`. -/
theorem neg_image_mem_Q {R : Type*} [CommRing R] (a2 x : R) :
    -(x ^ 4 + a2 * x ^ 2) = (x ^ 2 + a2) * (a2 - (x ^ 2 + a2)) := by
  ring

end Composition
