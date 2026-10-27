/-
  ExtremalQuartic.lean — 018 round 25

  The algebraic core of the extremal `d=4` family `x^4 + b`: for any `b = -s^2`
  the quartic factors as `(x^2 + s)(x^2 - s)`, i.e. it has a quadratic factor.

  Over `F_q` with `q = 1 (mod 4)`, `-1` is a square, so `-s^2` runs over all
  squares as `s` does; this makes the reducible set of `x^4 + b` equal to the
  squares, giving the cap `I = (q-1)/2`.
-/
import Mathlib

namespace ExtremalQuartic

/-- `x^4 - s^2 = (x^2 + s)(x^2 - s)`. -/
theorem factor_x4 {R : Type*} [CommRing R] (s : R) :
    (Polynomial.X ^ 4 - Polynomial.C s ^ 2 : Polynomial R) =
      (Polynomial.X ^ 2 + Polynomial.C s) * (Polynomial.X ^ 2 - Polynomial.C s) := by
  ring

end ExtremalQuartic
