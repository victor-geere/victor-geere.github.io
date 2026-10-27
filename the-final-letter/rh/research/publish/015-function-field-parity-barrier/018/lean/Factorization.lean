/-
  Factorization.lean — round 19 of the new programme (Target A)

  The reducible set of `x^4 + a2 x^2 + a1 x + b` is the union of the (negated)
  value set and the quadratic-factor set

      Q = { ((a2 + p^2)^2 - (a1/p)^2) / 4 : p != 0 } .

  The algebraic core: `(x^2 + p x + q)(x^2 - p x + s)` has the right shape.
-/
import Mathlib

open Polynomial

namespace Factorization

/-- `(x²+px+q)(x²−px+s) = x⁴ + a₂x² + a₁x + b` under the three matching
conditions. -/
theorem quadratic_factor {R : Type*} [CommRing R] (p q s a2 a1 b : R)
    (h1 : s + q - p ^ 2 = a2) (h2 : p * (s - q) = a1) (h3 : q * s = b) :
    (X ^ 2 + C p * X + C q) * (X ^ 2 - C p * X + C s)
      = X ^ 4 + C a2 * X ^ 2 + C a1 * X + C b := by
  rw [← h1, ← h2, ← h3]
  simp only [map_mul, map_sub, map_add, map_pow]
  ring

/-- The `p=0` case: `(x²+q)(x²+s)` with `s+q = a₂`, `q s = b`. -/
theorem even_factor {R : Type*} [CommRing R] (q s a2 b : R)
    (h1 : s + q = a2) (h2 : q * s = b) :
    (X ^ 2 + C q) * (X ^ 2 + C s) = X ^ 4 + C a2 * X ^ 2 + C b := by
  rw [← h1, ← h2]
  simp only [map_add, map_mul]
  ring

end Factorization
