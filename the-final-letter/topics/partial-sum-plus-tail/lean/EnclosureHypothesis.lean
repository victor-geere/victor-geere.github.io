import WidthCheck

/-!
# R14 template: an enclosure as a hypothesis

This file records the logical form of P3/R14.  A certified box that excludes
zero certifies nonvanishing *at the enclosed point*.  That is the form a
finite-window zero-count theorem would have to strengthen: for a zero count one
needs an enclosure valid on a whole rectangle in the critical strip, plus a
derivative bound or an argument principle.  P1 supplies the rectangle enclosure
only for `Re s > 1` (`ReplayGeneral.lean`), where `ζ` has no zeros; the missing
input is a certified enclosure in the critical strip, not this implication.
-/

namespace PartialTail

/-- If `B` encloses `z` and `B` does not contain `0`, then `z ≠ 0`. -/
theorem ne_zero_of_mem_of_not_mem_zero {z : ℂ} {B : Cx}
    (hz : Cx.mem z B) (h0 : ¬ Cx.mem (0 : ℂ) B) : z ≠ 0 := by
  rintro rfl
  exact h0 hz

end PartialTail
