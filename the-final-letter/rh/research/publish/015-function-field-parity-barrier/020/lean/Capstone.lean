/-
  Capstone.lean — 020 round 124.

  The local-factor dichotomy that drives every constant in the phase: at a prime
  of norm `Q`, avoiding `0` (the case `Q | h`) leaves `Q - 1` residues, and
  avoiding both `0` and `-h` (the case `Q ∤ h`) leaves `Q - 2`.
-/
import Mathlib
import SieveLocal
import PolyShift

open Finset

namespace Capstone

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

/-- One statement covering both local factors. -/
theorem local_factor_dichotomy (h : F) :
    (univ.filter (fun a : F => a ≠ 0 ∧ a + h ≠ 0)).card
      = Fintype.card F - 1 - (if h = 0 then 0 else 1) := by
  by_cases hh : h = 0
  · subst hh
    simp only [add_zero, ite_true, tsub_zero]
    have hset : (univ.filter (fun a : F => a ≠ 0 ∧ a ≠ 0))
        = (univ.filter (fun a : F => a ≠ 0)) := by
      ext a; simp
    rw [hset]
    exact PolyShift.card_nonzero
  · rw [if_neg hh]
    have hneg : (-h : F) ≠ 0 := neg_ne_zero.mpr hh
    have hset : (univ.filter (fun a : F => a ≠ 0 ∧ a + h ≠ 0))
        = univ \ ({0, -h} : Finset F) := by
      ext a
      simp only [mem_filter, mem_univ, true_and, mem_sdiff, mem_insert, mem_singleton, not_or]
      constructor
      · rintro ⟨h0, hh0⟩
        exact ⟨h0, fun hc => hh0 (by rw [hc]; exact neg_add_cancel h)⟩
      · rintro ⟨h0, hnh⟩
        refine ⟨h0, ?_⟩
        intro hc
        exact hnh (eq_neg_of_add_eq_zero_left hc)
    rw [hset, card_sdiff]
    have hc : ({0, -h} : Finset F) ∩ univ = {0, -h} := inf_top_eq _
    rw [hc, card_pair (Ne.symm hneg), Nat.sub_sub]
    norm_num

end Capstone

namespace Capstone

/-- The dimension constants of the phase: one condition costs `2`, two cost `4`,
three cost `8` — `2^k` in each case. -/
theorem parity_constants : (2 : ℕ) ^ 1 = 2 ∧ 2 ^ 2 = 4 ∧ 2 ^ 3 = 8 := by
  norm_num

end Capstone
