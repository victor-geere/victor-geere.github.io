/-
  QSize.lean — new goal round 1 (Target A1)

  The `a2 != 0` composition size decomposes as

      |Q| = |Q0| + |Q1 \ Q0| = (q+1)/2 + floor((q-1)/4) = q - floor((q+2)/4) .

  The arithmetic identity is recorded here; the image-count `|Q1 \ Q0| =
  floor((q-1)/4)` is the remaining verification.
-/
import Mathlib

namespace QSize

/-- `(q+1)/2 + (q-1)/4 = q - (q+2)/4` for odd `q`. -/
theorem size_identity (q : ℕ) (h : q % 2 = 1) :
    (q + 1) / 2 + (q - 1) / 4 = q - (q + 2) / 4 := by
  omega

end QSize
