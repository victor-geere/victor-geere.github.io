/-
ConeLean/ShiftBarrier.lean — deliverable (b2) of goal 3: averaging over shifts does not control a
prescribed shift.

Every un-averaged statement known for the correlation `h ↦ Σ_n λ(n)λ(n+h)` is a statement about
*almost all* shifts (Matomäki–Radziwiłł–Tao) or almost all scales (Tao–Teräväinen); the Chowla
target is the single point `h = 2`.  This file makes the logical point precise and
machine-checked: a bounded sequence can have correlations whose **total mass over all shifts** is
bounded by an absolute constant while a **prescribed shift** carries a fixed amount.  So no
almost-all-shifts theorem, by itself, can bound a prescribed shift — the averaging must be paid
for by additional input.

The witness is the two-spike sequence `1_{{0,1}}`: its aperiodic autocorrelation vanishes from
shift `2` on, equals `1` at shift `1` and `2` at shift `0`, so the total mass is `3` while the
average over `N` shifts is `3/N → 0`.
-/
import Mathlib

namespace ConeLean

open scoped BigOperators
open Finset

noncomputable section

/-- The two-spike sequence `1_{{0,1}}`. -/
def spike (n : ℕ) : ℝ := if n = 0 ∨ n = 1 then 1 else 0

/-- The aperiodic autocorrelation of `f` over `[0, N)` at shift `h`. -/
noncomputable def corr (f : ℕ → ℝ) (N h : ℕ) : ℝ := ∑ n ∈ Finset.range N, f n * f (n + h)

lemma spike_abs_le_one (n : ℕ) : |spike n| ≤ 1 := by
  rw [spike]; split_ifs <;> norm_num

lemma spike_eq_zero {n : ℕ} (hn : 2 ≤ n) : spike n = 0 := by
  simp [spike, show ¬(n = 0 ∨ n = 1) by omega]

lemma corr_spike_eq_zero {N h : ℕ} (hh : 2 ≤ h) : corr spike N h = 0 := by
  rw [corr]
  refine Finset.sum_eq_zero (fun n _ => ?_)
  rw [spike_eq_zero (by omega : 2 ≤ n + h), mul_zero]

lemma corr_spike_one {N : ℕ} (hN : 2 ≤ N) : corr spike N 1 = 1 := by
  rw [corr]
  have hsubset : ({0} : Finset ℕ) ⊆ Finset.range N := by
    intro x hx
    simp only [Finset.mem_singleton] at hx
    subst hx
    exact Finset.mem_range.mpr (by omega)
  have hzero : ∀ n ∈ Finset.range N, n ∉ ({0} : Finset ℕ) → spike n * spike (n + 1) = 0 := by
    intro n _ hn
    simp only [Finset.mem_singleton] at hn
    by_cases h1 : n = 1
    · rw [h1, spike_eq_zero (by omega : 2 ≤ 1 + 1), mul_zero]
    · rw [spike_eq_zero (show 2 ≤ n by omega), zero_mul]
  rw [← Finset.sum_subset hsubset hzero, Finset.sum_singleton]
  simp [spike]

lemma corr_spike_zero {N : ℕ} (hN : 2 ≤ N) : corr spike N 0 = 2 := by
  rw [corr]
  have hsubset : ({0, 1} : Finset ℕ) ⊆ Finset.range N := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl <;> exact Finset.mem_range.mpr (by omega)
  have hzero : ∀ n ∈ Finset.range N, n ∉ ({0, 1} : Finset ℕ) → spike n * spike (n + 0) = 0 := by
    intro n _ hn
    simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hn
    rw [spike_eq_zero (show 2 ≤ n by omega), zero_mul]
  rw [← Finset.sum_subset hsubset hzero,
    Finset.sum_insert (by norm_num : (0 : ℕ) ∉ ({1} : Finset ℕ)), Finset.sum_singleton]
  norm_num [spike]

/-- Total correlation mass of the two-spike sequence is at most `3`, for every `N ≥ 2`. -/
lemma sum_abs_corr_spike_le {N : ℕ} (hN : 2 ≤ N) :
    ∑ h ∈ Finset.range N, |corr spike N h| ≤ 3 := by
  have hsubset : ({0, 1} : Finset ℕ) ⊆ Finset.range N := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl <;> exact Finset.mem_range.mpr (by omega)
  have hzero : ∀ h ∈ Finset.range N, h ∉ ({0, 1} : Finset ℕ) → |corr spike N h| = 0 := by
    intro h _ hh
    simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hh
    rw [corr_spike_eq_zero (show 2 ≤ h by omega), abs_zero]
  rw [← Finset.sum_subset hsubset hzero,
    Finset.sum_insert (by norm_num : (0 : ℕ) ∉ ({1} : Finset ℕ)), Finset.sum_singleton,
    corr_spike_zero hN, corr_spike_one hN]
  norm_num

/-- **Barrier (b2).**  Averaging over shifts does not bound a prescribed shift: there is a bounded
sequence whose correlations have total mass `≤ 3` over all `N` shifts — average `3/N`, which tends
to `0` — while the prescribed shift `h = 1` carries correlation exactly `1`.  So an
almost-all-shifts statement (route R6) cannot, on its own, deliver a prescribed shift such as the
Chowla shift `h = 2`. -/
theorem shift_average_does_not_control_single {N : ℕ} (hN : 2 ≤ N) :
    ∃ f : ℕ → ℝ, (∀ n, |f n| ≤ 1)
      ∧ (∑ h ∈ Finset.range N, |corr f N h| ≤ 3) ∧ corr f N 1 = 1 :=
  ⟨spike, spike_abs_le_one, sum_abs_corr_spike_le hN, corr_spike_one hN⟩

/-! ## 2. The scale side: almost all scales does not control a prescribed scale -/

/-- The indicator of the block `[N/2, N)`. -/
def block (N : ℕ) : ℕ → ℝ := fun n => if N / 2 ≤ n ∧ n < N then 1 else 0

lemma block_nonneg (N n : ℕ) : 0 ≤ block N n := by
  rw [block]; split_ifs <;> norm_num

lemma block_le_one (N n : ℕ) : block N n ≤ 1 := by
  rw [block]; split_ifs <;> norm_num

/-- The partial sums of the block indicator: `Σ_{n<x} block N n = min x N - N/2`. -/
theorem sum_block_eq (N x : ℕ) :
    ∑ n ∈ Finset.range x, block N n = ((min x N - N / 2 : ℕ) : ℝ) := by
  have hset : (Finset.range x).filter (fun n => N / 2 ≤ n ∧ n < N)
      = Finset.Ico (N / 2) (min x N) := by
    ext n
    simp only [Finset.mem_filter, Finset.mem_range, Finset.mem_Ico]
    omega
  have h1 : ∑ n ∈ Finset.range x, block N n
      = (((Finset.range x).filter (fun n => N / 2 ≤ n ∧ n < N)).card : ℝ) := by
    simp only [block]
    rw [Finset.sum_boole]
  rw [h1, hset, Nat.card_Ico]

/-- **Barrier (b2), scale side.**  A sequence whose partial sums vanish at every scale up to `N/2`,
are `≍ N` at the prescribed scale `N`, and are `O(1)` from `N` onwards: the "conspiracy" is
confined to a single window of scales, so any almost-all-scales statement is blind to it.  This is
the scale-side analogue of `shift_average_does_not_control_single`. -/
theorem scale_average_does_not_control_prescribed {N : ℕ} (_hN : 2 ≤ N) :
    ∃ a : ℕ → ℝ, (∀ n, |a n| ≤ 1)
      ∧ (∀ x : ℕ, x ≤ N / 2 → ∑ n ∈ Finset.range x, a n = 0)
      ∧ (∑ n ∈ Finset.range N, a n = ((N - N / 2 : ℕ) : ℝ))
      ∧ (∀ x : ℕ, N ≤ x → ∑ n ∈ Finset.range x, a n = ((N - N / 2 : ℕ) : ℝ)) := by
  refine ⟨block N, fun n => abs_le.mpr ⟨by linarith [block_nonneg N n], block_le_one N n⟩,
    fun x hx => ?_, ?_, fun x hx => ?_⟩
  · have hxN : x ≤ N := le_trans hx (Nat.div_le_self N 2)
    rw [sum_block_eq, Nat.min_eq_left hxN, Nat.sub_eq_zero_of_le hx, Nat.cast_zero]
  · rw [sum_block_eq, Nat.min_self]
  · rw [sum_block_eq, Nat.min_eq_right hx]

end

end ConeLean
