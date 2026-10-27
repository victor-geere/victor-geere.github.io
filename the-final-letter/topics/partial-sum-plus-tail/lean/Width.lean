import Expr

/-!
# Width certification (P2)

`Expr.wf` checks *containment*: every node's box is exactly the operation applied
to its children.  It says nothing about how wide the final box is.  This file adds
a width functional on rectangles and a checker `Expr.wfWidth A w e`, which accepts
a certificate only when it is well formed *and* its final box has width at most the
target `w`.  `wfWidth_sound` is the corresponding soundness theorem: a target-width
certificate really does enclose the value in a box no wider than `w`.

The width is the `ℓ∞` (coordinate) width, which is the quantity the evaluator
reports.  It is not the diameter; the two differ by a constant factor for square
boxes.
-/

namespace PartialTail

namespace Cx

/-- Coordinate width of a complex rectangle: the larger of the two side lengths. -/
def width (Z : Cx) : ℚ := max (Z.re.hi - Z.re.lo) (Z.im.hi - Z.im.lo)

end Cx

namespace Expr

/-- Well-formedness together with a target-width bound on the final box. -/
def wfWidth (A : Nat → Cx) (w : ℚ) (e : Expr) : Bool :=
  e.wf A && decide (e.box.width ≤ w)

/-- **Soundness of width certification.**  A target-width certificate encloses the
denoted value in its final box, and that box is no wider than the target. -/
theorem wfWidth_sound {A : Nat → Cx} {σ : Nat → ℂ} (hA : ∀ i, Cx.mem (σ i) (A i)) :
    ∀ (e : Expr) (w : ℚ), e.wfWidth A w = true →
      Cx.mem (e.eval σ) e.box ∧ e.box.width ≤ w
  | e, w, h => by
      simp only [wfWidth, Bool.and_eq_true, decide_eq_true_eq] at h
      exact ⟨Expr.wf_sound hA e h.1, h.2⟩

end Expr

end PartialTail
