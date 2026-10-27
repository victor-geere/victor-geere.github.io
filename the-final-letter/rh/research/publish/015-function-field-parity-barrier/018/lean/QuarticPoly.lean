/-
  QuarticPoly.lean — 018 round 24

  The polynomial identity behind the exact `q = 3 (mod 4)` formula:

      q = 4k + 3  =>  q^3 - q^2 - 5q - 3 = 64 k (k+1)^2 .

  Hence `T(4;q,2)/q = 4 k (k+1)^2`, which is `0 mod 8`.
-/
import Mathlib

namespace QuarticPoly

/-- `(4k+3)^3 - (4k+3)^2 - 5(4k+3) - 3 = 64 k (k+1)^2`. -/
theorem poly_identity (k : ℤ) :
    (4 * k + 3) ^ 3 - (4 * k + 3) ^ 2 - 5 * (4 * k + 3) - 3
      = 64 * k * (k + 1) ^ 2 := by
  ring

end QuarticPoly
