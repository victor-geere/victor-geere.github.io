/-
  QOrbit.lean — new goal round 2 (Target A1, proof of |Q1 \ Q0|)

  The orbit involution `sigma(u) = -u - 2 a2` fixes the value
  `((a2+u)/2)^2`, and its character argument `-(2a2 + sigma(u))` equals `u`,
  so `sigma(u)` never has `chi = -1` when `u` is a square.
-/
import Mathlib

namespace QOrbit

/-- `sigma(u) = -u - 2 a2` gives the same value `(a2+u)^2`. -/
theorem sigma_y {R : Type*} [CommRing R] (a2 u : R) :
    (a2 + (-u - 2 * a2)) ^ 2 = (a2 + u) ^ 2 := by
  ring

/-- The character argument at `sigma(u)` is `u`. -/
theorem sigma_arg {R : Type*} [CommRing R] (a2 u : R) :
    -(2 * a2 + (-u - 2 * a2)) = u := by
  ring

end QOrbit
