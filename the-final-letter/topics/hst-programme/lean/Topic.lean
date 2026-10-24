import Mathlib

/-!
# Harmonic Sine Transform programme — finite formal core

The HST landing page (`archive/maths/hst/index.html`) is a duplicate of the
research guide for inventory item 17.  Its mathematical seed is the *greedy
harmonic expansion* of a normalised angle `x = θ / π` with respect to the
harmonic fractions `d n = 1 / (n + 2)`: at step `n` digit `1` is selected
exactly when the current residual is at least `d n`.

This file formalises the finite recursion and the convergence theorem that
the source's Programme I states: for `x ∈ [0, 1)` the residual is always
non-negative and strictly below `1 / (n + 1)`, the selected terms telescope
to `x`, and the greedy partial sums therefore converge to `x`.  The Haar
basis, the HST isometry, the transfer operator and the Fredholm determinant
are *not* formalised here and remain source claims in the programme dossier.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace HST

/-- The normalised harmonic fraction `d n = 1 / (n + 2)`. -/
def d (n : ℕ) : ℝ := 1 / ((n : ℝ) + 2)

/-- One greedy step: subtract `d n` from the residual if it fits. -/
def step (n : ℕ) (r : ℝ) : ℝ := r - if d n ≤ r then d n else 0

/-- The residual after the first `n` greedy decisions. -/
def rem (x : ℝ) : ℕ → ℝ
  | 0 => x
  | n + 1 => step n (rem x n)

/-- The greedy binary digit at index `n`: `1` iff `d n` fits in the residual. -/
def digit (x : ℝ) (n : ℕ) : ℕ := if d n ≤ rem x n then 1 else 0

/-- **T1.** Every harmonic fraction is strictly positive. -/
theorem d_pos (n : ℕ) : 0 < d n := by
  unfold d
  positivity

/-- **T2.** The harmonic fractions are strictly decreasing. -/
theorem d_strictAnti : StrictAnti d := by
  intro a b hab
  unfold d
  apply one_div_lt_one_div_of_lt
  · positivity
  · exact_mod_cast Nat.add_lt_add_right hab 2

/-- Unfolding lemma for one residual step. -/
theorem rem_succ (x : ℝ) (n : ℕ) :
    rem x (n + 1) = rem x n - (digit x n : ℝ) * d n := by
  rw [rem, step]
  unfold digit
  split_ifs <;> norm_num

/-- **T3.** The residual never becomes negative. -/
theorem rem_nonneg {x : ℝ} (hx : 0 ≤ x) (n : ℕ) : 0 ≤ rem x n := by
  induction n with
  | zero => simpa [rem] using hx
  | succ n ih =>
      rw [rem_succ]
      unfold digit
      split_ifs with h
      · have hd := d_pos n
        norm_num
        linarith
      · simpa using ih

/-- **T4.** The residual after `n` decisions is strictly below `1 / (n + 1)`.
This is the finite form of the source's estimate `θ - θ_n ≤ π / (n + 1)`. -/
theorem rem_lt {x : ℝ} (hx : x < 1) (n : ℕ) :
    rem x n < 1 / ((n : ℝ) + 1) := by
  induction n with
  | zero => simpa [rem] using hx
  | succ n ih =>
      rw [rem_succ]
      unfold digit
      have hden : (((n : ℝ) + 1) + 1) = (n : ℝ) + 2 := by ring
      push_cast
      rw [hden]
      split_ifs with h
      · -- the digit was `1`, and `r - 1/(n+2) < 1/(n+2)`
        have hsub : (1 : ℝ) / ((n : ℝ) + 1) - 1 / ((n : ℝ) + 2)
            ≤ 1 / ((n : ℝ) + 2) := by
          have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
          have h2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
          field_simp [ne_of_gt h1, ne_of_gt h2]
          nlinarith
        have hde : d n = 1 / ((n : ℝ) + 2) := rfl
        rw [hde] at h ⊢
        linarith
      · -- the digit was `0`, so `r < 1/(n+2)` by the failed test
        have hr : rem x n < d n := not_le.mp h
        simpa [d] using hr

/-- **T5.** Exact finite identity: the residual plus the selected terms is `x`. -/
theorem rem_add_sum (x : ℝ) (n : ℕ) :
    rem x n + (Finset.range n).sum (fun k => (digit x k : ℝ) * d k) = x := by
  induction n with
  | zero => simp [rem]
  | succ n ih =>
      rw [Finset.sum_range_succ, rem_succ]
      linarith

/-- **T6.** The residual tends to zero: the source's convergence lemma,
obtained by squeezing `rem x n` between `0` and `1/(n+1)`. -/
theorem rem_tendsto_zero {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    Tendsto (fun n => rem x n) atTop (𝓝 0) := by
  have hbound : Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1)) atTop (𝓝 0) :=
    tendsto_one_div_add_atTop_nhds_zero_nat (𝕜 := ℝ)
  exact squeeze_zero (fun n => rem_nonneg hx0 n)
    (fun n => le_of_lt (rem_lt hx1 n)) hbound

/-- **T7.** Greedy harmonic expansion: for `x ∈ [0, 1)` the partial sums of
selected harmonic terms converge to `x`.  This is the series theorem of the
source's Programme I, for the normalised angle. -/
theorem sum_tendsto {x : ℝ} (hx0 : 0 ≤ x) (hx1 : x < 1) :
    Tendsto (fun n => (Finset.range n).sum (fun k => (digit x k : ℝ) * d k))
      atTop (𝓝 x) := by
  have h := rem_tendsto_zero hx0 hx1
  have heq : (fun n => (Finset.range n).sum (fun k => (digit x k : ℝ) * d k))
      = fun n => x - rem x n := by
    funext n
    have hs := rem_add_sum x n
    linarith
  rw [heq]
  simpa using tendsto_const_nhds.sub h

end HST
