/-
  B4.lean — 018 round 22

  A concrete piece of the `d=4` extremal family `x^4 + b` over `F_5`: the
  member `b = 4` factors completely, `x^4 + 4 = (x-1)(x-2)(x-3)(x-4)`.
-/
import Mathlib

namespace B4

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- `x^4 + 4` is the product of all four nonzero linear factors over `F_5`. -/
theorem x4_add_four :
    ∀ x : ZMod 5, x ^ 4 + 4 = (x - 1) * (x - 2) * (x - 3) * (x - 4) := by
  decide

end B4
