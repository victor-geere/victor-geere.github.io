/-
  Collision.lean — round 3 of the new programme (Target A)

  The collision identity behind the Weil analysis of the cap:
  for `g(x) = x^4 + a2 x^2 + a1 x`,

      g(x) - g(y) = (x - y) * (x^3 + x^2 y + x y^2 + y^3 + a2 (x+y) + a1) .
-/
import Mathlib

namespace Collision

/-- The collision factorisation for `x^4 + a2 x^2 + a1 x`. -/
theorem diff_factor {R : Type*} [CommRing R] (a2 a1 x y : R) :
    (x ^ 4 + a2 * x ^ 2 + a1 * x) - (y ^ 4 + a2 * y ^ 2 + a1 * y)
      = (x - y) * (x ^ 3 + x ^ 2 * y + x * y ^ 2 + y ^ 3 + a2 * (x + y) + a1) := by
  ring

end Collision
