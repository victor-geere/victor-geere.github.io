/-
  ValueSet.lean — round 10 of the new programme (Target A)

  Cauchy–Schwarz for the fiber distribution:

      |α|^2  ≤  |Im f| · Σ_y N(y)^2 ,

  i.e. the value-set lower bound `|Im f| ≥ |α|^2 / Σ N(y)^2` — the starting
  point of (V).
-/
import Mathlib
import Fiber

namespace ValueSet

open Finset

theorem value_set_bound {α β : Type*} [Fintype α] [Fintype β] [DecidableEq β] (f : α → β) :
    (Fintype.card α) ^ 2
      ≤ ((Finset.univ : Finset α).image f).card
        * (Finset.univ : Finset β).sum
            (fun y => (Finset.univ.filter (fun x : α => f x = y)).card ^ 2) := by
  set s : Finset β := (Finset.univ : Finset α).image f with hs
  have hmem : ∀ y, y ∉ s → (Finset.univ.filter (fun x : α => f x = y)).card = 0 := by
    intro y hy
    rw [hs] at hy
    rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
    intro x _ hx
    exact hy (Finset.mem_image.mpr ⟨x, Finset.mem_univ x, hx⟩)
  have hsum : s.sum (fun y => (Finset.univ.filter (fun x : α => f x = y)).card) = Fintype.card α := by
    rw [Finset.sum_subset (Finset.subset_univ s) (by
      intro y _ hy
      exact hmem y hy)]
    exact Fiber.sum_fiber_card f
  have key : (Fintype.card α) ^ 2
      ≤ s.card * s.sum (fun y => (Finset.univ.filter (fun x : α => f x = y)).card ^ 2) := by
    calc (Fintype.card α) ^ 2
        = (s.sum (fun y => (Finset.univ.filter (fun x : α => f x = y)).card)) ^ 2 := by rw [hsum]
      _ ≤ s.card * s.sum (fun y => (Finset.univ.filter (fun x : α => f x = y)).card ^ 2) :=
          sq_sum_le_card_mul_sum_sq
  rw [hs]
  refine le_trans key (Nat.mul_le_mul_left _ ?_)
  exact Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _)
    (by intro y _ _; positivity)

end ValueSet
