/-
  WindowCount.lean — `TRUTHS.md` §2, second bullet (checked there over
  25 044 603 cases):

  > `#{ t : window contains a_m } = max(0, min(a_m,N−L) − max(0,a_m−L+1) + 1)`
  > (exactly, all `L`).

  The right-hand side is computed in integers by the Python check (its
  `min − max + 1` can be negative), so it is stated here in `ℤ`.  Window starts
  live in `[0, N-L]`, hence the hypothesis `L ≤ N`.
-/
import Rh41.DigitWord

namespace Rh41

open Finset

/-- The number of integers in `[a,b]`, read in `ℤ`: `max 0 (b - a + 1)`. -/
lemma card_Icc_int (a b : ℕ) :
    (((Icc a b).card : ℤ) = max 0 ((b : ℤ) - (a : ℤ) + 1)) := by
  rcases le_or_gt a b with h | h
  · rw [Nat.card_Icc]
    have hcast : ((b + 1 - a : ℕ) : ℤ) = (b : ℤ) - (a : ℤ) + 1 := by omega
    rw [hcast]
    exact (max_eq_right (by omega)).symm
  · have hempty : Icc a b = ∅ := Icc_eq_empty (by omega)
    rw [hempty, card_empty]
    have hneg : (b : ℤ) - (a : ℤ) + 1 ≤ 0 := by omega
    exact (max_eq_left hneg).symm

/-- The cast of `max 0 (a_m - (L-1))` is `max 0 (a_m - L + 1)`. -/
lemma cast_max_sub (am L : ℕ) (hL : 1 ≤ L) :
    ((max 0 (am - (L - 1)) : ℕ) : ℤ) = max 0 ((am : ℤ) - L + 1) := by
  rcases le_or_gt (L - 1) am with h | h
  · rw [max_eq_right (Nat.zero_le _), Nat.cast_sub h]
    have h1 : (0 : ℤ) ≤ (am : ℤ) - L + 1 := by omega
    rw [max_eq_right h1]
    have h2 : ((L - 1 : ℕ) : ℤ) = (L : ℤ) - 1 := by
      rw [Nat.cast_sub hL]
      norm_num
    rw [h2]
    ring
  · have h1 : am - (L - 1) = 0 := by omega
    rw [h1, max_self, Nat.cast_zero]
    have h2 : (am : ℤ) - L + 1 ≤ 0 := by omega
    rw [max_eq_left h2]

/-- **`TRUTHS.md` §2, window count.**  The number of windows of length `L` that
contain the point `am` is `max(0, min(am, N-L) - max(0, am-L+1) + 1)`. -/
theorem card_windows_containing (N L am : ℕ) (hL : 1 ≤ L) (hLN : L ≤ N) :
    ((((range (N - L + 1)).filter (fun t => t ≤ am ∧ am ≤ t + L - 1)).card : ℤ)
      = max 0 (min (am : ℤ) ((N : ℤ) - L) - max 0 ((am : ℤ) - L + 1) + 1)) := by
  have hset : (range (N - L + 1)).filter (fun t => t ≤ am ∧ am ≤ t + L - 1)
      = Icc (max 0 (am - (L - 1))) (min am (N - L)) := by
    ext t
    rw [mem_filter, mem_range, mem_Icc]
    constructor
    · rintro ⟨h1, h2, h3⟩
      refine ⟨max_le (by omega) ?_, le_min h2 (by omega)⟩
      have h4 : am ≤ t + (L - 1) := by
        have := Nat.add_sub_assoc hL t
        omega
      rw [Nat.sub_le_iff_le_add]
      exact h4
    · rintro ⟨h1, h2⟩
      have h3 : am - (L - 1) ≤ t := le_trans (le_max_right _ _) h1
      rw [Nat.sub_le_iff_le_add] at h3
      have h4 : t ≤ N - L := le_trans h2 (min_le_right _ _)
      have h5 : t ≤ am := le_trans h2 (min_le_left _ _)
      have h6 : am ≤ t + L - 1 := by
        have := Nat.add_sub_assoc hL t
        omega
      exact ⟨by omega, h5, h6⟩
  rw [hset, card_Icc_int, cast_max_sub am L hL, Nat.cast_min, Nat.cast_sub hLN]

end Rh41
