/-
  012/lean/Expr.lean — the checkable cell for `partial-sum-plus-tail` certificates.

  `IBox.lean` proves the interval-algebra soundness lemmas.  This file adds a
  straight-line certificate language over `Cx` boxes, a computable well-formedness
  checker `Expr.wf`, and the soundness theorem `Expr.wf_sound`: if the checker
  accepts a certificate *and* every leaf `i` is known to lie in the box `A i`,
  then the final value lies in the final box.

  A certificate is data: an `Expr` value plus an atom-box assignment `A`.  The
  Python tool `012/rigorous/partial_tail.py` emits them; `Replay.lean` contains a
  concrete one.  Leaves (`A i`) are the only trusted analytic input; they are
  independently re-derived and checked by `012/rigorous/verify_certificate.py`.
-/
import IBox

namespace PartialTail

open PartialTail

/-- A straight-line certificate over complex rational boxes.  Every node carries
the box it claims to enclose. -/
inductive Expr where
  /-- Trusted leaf: atom `i` lies in the atom box `A i`. -/
  | atom (i : Nat) (box : Cx)
  | add (box : Cx) (x y : Expr)
  | sub (box : Cx) (x y : Expr)
  | neg (box : Cx) (x : Expr)
  | scale (box : Cx) (q : ℚ) (x : Expr)
  | mul (box : Cx) (x y : Expr)
  | inflate (box : Cx) (r : ℚ) (x : Expr)
deriving DecidableEq, Repr

namespace Expr

/-- The claimed box of a node. -/
def box : Expr → Cx
  | atom _ b => b
  | add b _ _ => b
  | sub b _ _ => b
  | neg b _ => b
  | scale b _ _ => b
  | mul b _ _ => b
  | inflate b _ _ => b

/-- The complex value denoted by a certificate, given the values of its atoms. -/
def eval (σ : Nat → ℂ) : Expr → ℂ
  | atom i _ => σ i
  | add _ x y => eval σ x + eval σ y
  | sub _ x y => eval σ x - eval σ y
  | neg _ x => -eval σ x
  | scale _ q x => (q : ℂ) * eval σ x
  | mul _ x y => eval σ x * eval σ y
  | inflate _ _ x => eval σ x

/-- Computable checker: every node's box must be exactly the operation applied to
its children's boxes, and every leaf must be the declared atom box. -/
def wf (A : Nat → Cx) : Expr → Bool
  | atom i b => decide (b = A i)
  | add b x y => x.wf A && y.wf A && decide (b = x.box.add y.box)
  | sub b x y => x.wf A && y.wf A && decide (b = x.box.sub y.box)
  | neg b x => x.wf A && decide (b = x.box.neg)
  | scale b q x => x.wf A && decide (b = x.box.scale q)
  | mul b x y => x.wf A && y.wf A && decide (b = x.box.mul y.box)
  | inflate b r x => x.wf A && decide (0 ≤ r) && decide (b = x.box.inflate r)

/-- **Inclusion soundness of the checker.**  If every atom value lies in its
declared box, then a certificate accepted by `wf` encloses the value it denotes. -/
theorem wf_sound {A : Nat → Cx} {σ : Nat → ℂ} (hA : ∀ i, Cx.mem (σ i) (A i)) :
    ∀ e : Expr, e.wf A = true → Cx.mem (e.eval σ) e.box
  | atom i b, h => by
      simp only [wf, decide_eq_true_eq] at h
      rw [h]
      exact hA i
  | add b x y, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨⟨hx, hy⟩, hb⟩ := h
      rw [hb]
      exact Cx.mem_add (wf_sound hA x hx) (wf_sound hA y hy)
  | sub b x y, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨⟨hx, hy⟩, hb⟩ := h
      rw [hb]
      exact Cx.mem_sub (wf_sound hA x hx) (wf_sound hA y hy)
  | neg b x, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨hx, hb⟩ := h
      rw [hb]
      exact Cx.mem_neg (wf_sound hA x hx)
  | scale b q x, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨hx, hb⟩ := h
      rw [hb]
      exact Cx.mem_scale (wf_sound hA x hx)
  | mul b x y, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨⟨hx, hy⟩, hb⟩ := h
      rw [hb]
      exact Cx.mem_mul (wf_sound hA x hx) (wf_sound hA y hy)
  | inflate b r x, h => by
      simp only [wf, Bool.and_eq_true, decide_eq_true_eq] at h
      obtain ⟨⟨hx, hr⟩, hb⟩ := h
      rw [hb]
      exact Cx.mem_inflate hr (wf_sound hA x hx)

end Expr

end PartialTail
