/-
  Resolvent.lean — 018 round 18

  Over `F_q` every irreducible quartic has exactly one resolvent root:
  the Frobenius is an odd 4-cycle, which fixes exactly one of the three
  pairings.  Here is a concrete instance: the quartic `x^4 + x + 4` is
  irreducible over `F_5`, and its resolvent cubic `z^3 - z - 1` has
  exactly one root.
-/
import Mathlib

namespace Resolvent

instance : Fact (Nat.Prime 5) := ⟨by norm_num⟩

/-- The resolvent cubic `z^3 - z - 1` of `x^4 + x + 4` over `F_5` has
exactly one root in `F_5`. -/
theorem resolvent_roots_one :
    (Finset.univ.filter (fun z : ZMod 5 => z ^ 3 - z - 1 = 0)).card = 1 := by
  decide

/-- The quartic `x^4 + x + 4` has no root in `F_5`. -/
theorem quartic_no_root :
    ∀ x : ZMod 5, x ^ 4 + x + 4 ≠ 0 := by
  decide

end Resolvent
