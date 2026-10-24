/-
  JZero.lean — round 13 of the new programme (Target A)

  The `j`-invariant of the quartic `x^4 + a2 x^2 + a1 x` is `a1^2 / a2^3`
  (round 28).  It vanishes exactly when the quartic is even (`a1 = 0`), the
  one special point of the S4 stratification (round 42).
-/
import Mathlib

namespace JZero

/-- `a1^2 / a2^3 = 0 ↔ a1 = 0` for `a2 ≠ 0`. -/
theorem j_zero_iff {K : Type*} [Field K] (a1 a2 : K) (h2 : a2 ≠ 0) :
    a1 ^ 2 / a2 ^ 3 = 0 ↔ a1 = 0 := by
  rw [div_eq_zero_iff]
  constructor
  · rintro (h | h)
    · exact pow_eq_zero_iff (by norm_num) |>.mp h
    · exact absurd h (pow_ne_zero 3 h2)
  · intro h
    left
    rw [h]
    ring

end JZero
