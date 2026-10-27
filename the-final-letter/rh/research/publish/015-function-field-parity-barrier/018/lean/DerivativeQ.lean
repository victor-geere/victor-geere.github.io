/-
  DerivativeQ.lean — round 5 of the new programme (Target A)

  The critical points of `g(x) = x^4 + a2 x^2 + a1 x` are the roots of the
  cubic `g'(x) = 4 x^3 + 2 a2 x + a1`.  This is the genus-1 data behind the
  fiber distribution of round 34.
-/
import Mathlib

open Polynomial

namespace DerivativeQ

/-- `(x^4 + a2 x^2 + a1 x)' = 4 x^3 + 2 a2 x + a1`. -/
theorem deriv_quartic {R : Type*} [CommRing R] (a2 a1 : R) :
    derivative (X ^ 4 + C a2 * X ^ 2 + C a1 * X : R[X])
      = C 4 * X ^ 3 + C (2 * a2) * X + C a1 := by
  simp [derivative_pow, derivative_X, derivative_C]
  ring

/-- The derivative at `0` is the linear coefficient `a1`. -/
theorem deriv_at_zero {R : Type*} [CommRing R] (a2 a1 : R) :
    (derivative (X ^ 4 + C a2 * X ^ 2 + C a1 * X : R[X])).eval 0 = a1 := by
  simp [derivative_pow, derivative_X, derivative_C]

end DerivativeQ
