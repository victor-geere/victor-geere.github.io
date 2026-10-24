/-
  DepressedQuartic.lean — 018 round 26

  The standard normal form of a quartic: after the translation `x = y - a/4`
  the cubic term vanishes,

      f(y - a/4) = y^4 + P y^2 + Q y + R ,

  with P = b - 3a^2/8, Q = c - ab/2 + a^3/8,
       R = d - ac/4 + a^2 b/16 - 3a^4/256 .
-/
import Mathlib

namespace DepressedQuartic

/-- Depressed quartic normal form. -/
theorem depress (a b c d y : ℚ) :
    (y - a / 4) ^ 4 + a * (y - a / 4) ^ 3 + b * (y - a / 4) ^ 2
        + c * (y - a / 4) + d
      = y ^ 4 + (b - 3 * a ^ 2 / 8) * y ^ 2
        + (c - a * b / 2 + a ^ 3 / 8) * y
        + (d - a * c / 4 + a ^ 2 * b / 16 - 3 * a ^ 4 / 256) := by
  ring

end DepressedQuartic
