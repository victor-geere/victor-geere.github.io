/-
  LocalDensity.lean — 020 round 107.

  The local factor of the singular series for the pair (f, f+h): at a prime of
  norm Q the density of residues a with both a and a+h nonzero is (Q-2)/Q when
  h ≠ 0.  Stated additively: in a finite field, the set of a avoiding both 0 and
  -h has cardinality |F| - 2.
-/
import Mathlib

open Finset

namespace LocalDensity

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- Avoiding `0` and `-h` costs exactly two points. -/
theorem card_avoid_two {h : F} (hh : h ≠ 0) :
    (univ.filter (fun a : F => a ≠ 0 ∧ a + h ≠ 0)).card = Fintype.card F - 2 := by
  have hneg : (-h : F) ≠ 0 := neg_ne_zero.mpr hh
  have hset : (univ.filter (fun a : F => a ≠ 0 ∧ a + h ≠ 0))
      = univ \ ({0, -h} : Finset F) := by
    ext a
    simp only [mem_filter, mem_univ, true_and, mem_sdiff, mem_insert, mem_singleton,
      not_or]
    constructor
    · rintro ⟨h0, hh0⟩
      exact ⟨h0, fun ha => hh0 (by rw [ha]; exact neg_add_cancel h)⟩
    · rintro ⟨h0, hnh⟩
      refine ⟨h0, ?_⟩
      intro hc
      exact hnh (eq_neg_of_add_eq_zero_left hc)
  rw [hset, card_sdiff]
  have hcard : ({0, -h} : Finset F).card = 2 := card_pair (Ne.symm hneg)
  rw [show ({0, -h} : Finset F) ∩ univ = {0, -h} from inf_top_eq _, hcard, card_univ]

end LocalDensity
