/-
  EvenQuartic.lean — 018 round 27

  The even quartic `x^4 + a x^2 + b` factors as `(x^2 - y)(x^2 - z)` whenever
  `y + z = -a` and `y z = b`, i.e. `y, z` are the roots of `t^2 + a t + b`.
-/
import Mathlib

namespace EvenQuartic

/-- Pure ring form: `(X^2 - C y)(X^2 - C z) = X^4 - C(y+z) X^2 + C(yz)`. -/
theorem even_quartic_aux {R : Type*} [CommRing R] (y z : R) :
    (Polynomial.X ^ 2 - Polynomial.C y) * (Polynomial.X ^ 2 - Polynomial.C z)
      = (Polynomial.X ^ 4 - Polynomial.C (y + z) * Polynomial.X ^ 2
          + Polynomial.C (y * z) : Polynomial R) := by
  simp only [map_add, map_mul]
  ring

/-- `x^4 + a x^2 + b = (x^2 - y)(x^2 - z)` when `y + z = -a`, `yz = b`. -/
theorem even_quartic_factor {R : Type*} [CommRing R] {a b y z : R}
    (h1 : y + z = -a) (h2 : y * z = b) :
    (Polynomial.X ^ 2 - Polynomial.C y) * (Polynomial.X ^ 2 - Polynomial.C z)
      = (Polynomial.X ^ 4 + Polynomial.C a * Polynomial.X ^ 2 + Polynomial.C b :
          Polynomial R) := by
  rw [even_quartic_aux, h1, h2]
  simp only [map_neg]
  ring_nf

/-- The even quartic `x^4 + a2 x^2` is invariant under `x ↦ -x`. -/
theorem even_quartic_neg {R : Type*} [CommRing R] (a2 x : R) :
    (-x) ^ 4 + a2 * (-x) ^ 2 = x ^ 4 + a2 * x ^ 2 := by
  ring

end EvenQuartic
