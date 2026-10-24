/-
  Window.lean — 020 round 117.

  The formal definition of a degree window: summing over the degrees
  `N, …, N+L-1` is summing the shifted sequence over `range L`.  This is the
  object the phase's "segmented window counting" refers to.
-/
import Mathlib

open Finset

namespace Window

/-- A window sum is a shifted range sum. -/
theorem window_shift (T : ℕ → ℤ) (N L : ℕ) :
    (Finset.Ico N (N + L)).sum T = (Finset.range L).sum (fun k => T (N + k)) := by
  rw [Finset.sum_Ico_eq_sum_range, Nat.add_sub_cancel_left]

/-- Windows concatenate: the window `[N, N+L+M)` is the two windows in sequence. -/
theorem window_concat (T : ℕ → ℤ) (N L M : ℕ) :
    (Finset.Ico N (N + (L + M))).sum T
      = (Finset.Ico N (N + L)).sum T + (Finset.Ico (N + L) (N + L + M)).sum T := by
  rw [window_shift, window_shift, window_shift, Finset.sum_range_add]
  simp only [Nat.add_assoc]

end Window
