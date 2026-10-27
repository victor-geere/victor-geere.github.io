/-
  Fiber.lean — round 7 of the new programme (Target A)

  The bridge between the value-set size and the collision count:

      Σ_y N(y)^2 = #{(x,x') : f x = f x'} ,      N(y) = #{x : f x = y} .

  Cauchy–Schwarz on this identity gives the value-set lower bound
  `|Im f| ≥ |α|^2 / Σ N(y)^2`, the starting point of (V).
-/
import Mathlib

open Finset

namespace Fiber

/-- `Σ_y N(y)^2` equals the number of pairs with equal image. -/
theorem sum_fiber_sq {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β] (f : α → β) :
    ∑ y : β, (univ.filter (fun x : α => f x = y)).card ^ 2
      = (univ.filter (fun p : α × α => f p.1 = f p.2)).card := by
  rw [card_eq_sum_card_fiberwise (f := fun p : α × α => f p.1) (t := univ)
      (s := univ.filter (fun p : α × α => f p.1 = f p.2)) (by simp)]
  apply sum_congr rfl
  intro y _
  have hset : (univ.filter (fun p : α × α => f p.1 = f p.2)).filter (fun p => f p.1 = y)
      = (univ.filter (fun x : α => f x = y)) ×ˢ (univ.filter (fun x : α => f x = y)) := by
    ext p
    simp only [mem_filter, mem_univ, true_and, mem_product]
    constructor
    · rintro ⟨h1, h2⟩
      exact ⟨h2, h1.symm.trans h2⟩
    · rintro ⟨h1, h2⟩
      exact ⟨h1.trans h2.symm, h1⟩
  rw [hset, card_product, sq]

/-- The fibers partition the source: `Σ_y N(y) = |α|`. -/
theorem sum_fiber_card {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β] (f : α → β) :
    ∑ y : β, (univ.filter (fun x : α => f x = y)).card = Fintype.card α := by
  rw [← card_eq_sum_card_fiberwise (f := f) (t := univ)
      (s := (univ : Finset α)) (by simp), Finset.card_univ]

end Fiber
