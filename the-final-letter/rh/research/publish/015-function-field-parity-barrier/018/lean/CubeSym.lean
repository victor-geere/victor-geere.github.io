/-
  CubeSym.lean — round 6 of the new programme (Target A)

  The cube symmetry of `g(x) = x^4 + a1 x`: for a cube root of unity `c`,
  `g(c x) = c g(x)`.  Hence the value set of `g` is a union of cube-class
  cosets, and the count in the `a2 = 0` row depends only on the cube class
  of `a1`.
-/
import Mathlib

namespace CubeSym

/-- If `c^3 = 1` then `(cx)^4 + a1 (cx) = c (x^4 + a1 x)`. -/
theorem cube_scaling {R : Type*} [CommRing R] (c a1 x : R) (hc : c ^ 3 = 1) :
    (c * x) ^ 4 + a1 * (c * x) = c * (x ^ 4 + a1 * x) := by
  have h4 : c ^ 4 = c := by
    rw [show c ^ 4 = c ^ 3 * c by ring, hc, one_mul]
  calc (c * x) ^ 4 + a1 * (c * x)
      = c ^ 4 * x ^ 4 + a1 * c * x := by ring
    _ = c * x ^ 4 + a1 * c * x := by rw [h4]
    _ = c * (x ^ 4 + a1 * x) := by ring

end CubeSym
