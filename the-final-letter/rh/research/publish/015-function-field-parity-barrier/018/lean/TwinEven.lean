import Mathlib

open Finset

namespace TwinEven

/-- The shift `f ↦ f + h` is injective. -/
theorem add_right_injective' (h : ℤ) : Function.Injective (fun x : ℤ => x + h) := by
  intro a b hab
  simpa using hab

/-- **The even symmetry of the twin count.**  The map `f ↦ f + h` is a bijection
from the `h`-pairs to the `(-h)`-pairs, hence the two counts agree. -/
theorem card_twin_even (s : Finset ℤ) (P : ℤ → Prop) [DecidablePred P] (h : ℤ) :
    (s.filter (fun f => P f ∧ P (f + h))).card
      = ((s.image (fun f => f + h)).filter (fun g => P g ∧ P (g - h))).card := by
  refine Finset.card_bij (fun f _ => f + h) ?_ ?_ ?_
  · intro f hf
    obtain ⟨hfs, Pf, Pfh⟩ := Finset.mem_filter.mp hf
    rw [Finset.mem_filter]
    refine ⟨Finset.mem_image.mpr ⟨f, hfs, rfl⟩, Pfh, ?_⟩
    rw [add_sub_cancel_right]
    exact Pf
  · intro a b ha hb hab
    simpa using hab
  · intro g hg
    obtain ⟨hgim, Pg, Pgh⟩ := Finset.mem_filter.mp hg
    obtain ⟨f, hfs, rfl⟩ := Finset.mem_image.mp hgim
    rw [add_sub_cancel_right] at Pgh
    exact ⟨f, Finset.mem_filter.mpr ⟨hfs, Pgh, Pg⟩, rfl⟩

end TwinEven
