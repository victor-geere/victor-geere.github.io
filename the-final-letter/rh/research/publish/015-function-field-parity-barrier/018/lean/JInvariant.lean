/-
  JInvariant.lean — 018 round 28

  In the slice `a3 = 0` the scaling `x -> c x` acts on the coefficients by
  `(a2, a1) -> (a2/c^2, a1/c^3)` and preserves the family count.  The invariant
  is the j-invariant `a1^2 / a2^3`:

      (a1/c^3)^2 / (a2/c^2)^3 = a1^2 / a2^3 .
-/
import Mathlib

namespace JInvariant

/-- The j-invariant `a1^2/a2^3` is invariant under `(a2,a1) -> (a2/c^2,a1/c^3)`. -/
theorem j_invariant_scale {K : Type*} [Field K] (a1 a2 c : K) (hc : c ≠ 0) :
    (a1 / c ^ 3) ^ 2 / (a2 / c ^ 2) ^ 3 = a1 ^ 2 / a2 ^ 3 := by
  field_simp

end JInvariant
