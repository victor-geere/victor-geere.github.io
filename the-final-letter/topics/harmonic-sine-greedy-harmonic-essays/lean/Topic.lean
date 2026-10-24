import Mathlib

/-!
# Harmonic sine / greedy harmonic essays — formal core

Source: `archive/essays/harmonic-sine-rh-proof.html`, an essay that is
marked *retracted* in its own header and whose Riemann-hypothesis claim is
archived. The essay defines the harmonic angle sequence

  `α n = π / (n + 2)`,

the greedy selection rule `δ n = 1 iff α n ≤ θ - θ n`, the accumulated
angle `θ n`, and the sine/cosine fusion step. This file formalises the
finite part of that construction:

* `α` is positive and strictly antitone;
* the partial harmonic identity `∑_{n=0}^{N} α n = π (H_{N+2} - 1)`;
* the greedy accumulation is non-negative and never exceeds the target;
* at the target `θ = α n` no earlier index is selected, so index `n`
  itself is selected.

The analytic limit, the `O(1/N)` rate, the claimed zeta bridge and the
retracted RH argument are *not* formalised; they are recorded as source
claims or open items in the programme dossier.
-/

noncomputable section

open scoped BigOperators

namespace HarmonicEssays

/-- The harmonic angle `α n = π / (n + 2)`. -/
def alpha (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- The accumulated angle after processing indices `0, …, N-1`.

At index `n` the greedy rule adds `α n` exactly when the residual
`θ - θ n` is at least `α n`. This is Definition 2.2 of the source. -/
def greedy (θ : ℝ) : ℕ → ℝ
  | 0 => 0
  | n + 1 =>
      if alpha n ≤ θ - greedy θ n then greedy θ n + alpha n else greedy θ n

/-- The selection indicator `δ n`: `true` exactly when `α n` is taken. -/
def selected (θ : ℝ) (n : ℕ) : Bool :=
  decide (alpha n ≤ θ - greedy θ n)

theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

/-- The exact harmonic-number identity of Definition 2.1:
`∑_{n=0}^{N} α n = π (H_{N+2} - 1)`. -/
theorem sum_alpha (N : ℕ) :
    ∑ n ∈ Finset.range (N + 1), alpha n
      = Real.pi * ((harmonic (N + 2) : ℝ) - 1) := by
  induction N with
  | zero =>
      simp [alpha, harmonic]
      ring
  | succ N ih =>
      rw [Finset.sum_range_succ, ih]
      have hh : (harmonic (N + 1 + 2) : ℝ)
          = (harmonic (N + 2) : ℝ) + (((N + 3 : ℕ) : ℝ))⁻¹ := by
        rw [show N + 1 + 2 = (N + 2) + 1 by omega, harmonic_succ]
        push_cast
        ring
      rw [hh]
      have hidx : ((N + 1 : ℕ) : ℝ) + 2 = (N : ℝ) + 3 := by
        push_cast
        ring
      unfold alpha
      rw [hidx]
      have h3 : ((N : ℝ) + 3) ≠ 0 := by positivity
      field_simp [h3]
      push_cast
      ring

theorem greedy_nonneg (θ : ℝ) (N : ℕ) : 0 ≤ greedy θ N := by
  induction N with
  | zero => simp [greedy]
  | succ N ih =>
      rw [greedy]
      split
      · exact add_nonneg ih (le_of_lt (alpha_pos N))
      · exact ih

/-- The source's Lemma 3.1, lower half: the greedy accumulation never
overshoots the target. -/
theorem greedy_le_target {θ : ℝ} (hθ : 0 ≤ θ) (N : ℕ) : greedy θ N ≤ θ := by
  induction N with
  | zero => exact hθ
  | succ N ih =>
      rw [greedy]
      split
      · linarith
      · exact ih

/-- If every angle seen so far is larger than the target, nothing is
selected: `greedy θ N = 0`. -/
theorem greedy_eq_zero_of_forall {θ : ℝ} (hθ : 0 ≤ θ) :
    ∀ N : ℕ, (∀ k < N, θ < alpha k) → greedy θ N = 0
  | 0, _ => by simp [greedy]
  | N + 1, h => by
      have hN : greedy θ N = 0 :=
        greedy_eq_zero_of_forall hθ N fun k hk => h k (Nat.lt_succ_of_lt hk)
      rw [greedy, hN]
      have hle : ¬ (alpha N ≤ θ) := by
        have := h N (Nat.lt_succ_self N)
        linarith
      rw [sub_zero, ite_eq_right hle]

/-- At the target `θ = α n`, every earlier index is skipped, so the
accumulated angle stays `0`. This is the finite threshold identity in the
direction the source uses (Theorem 2.3 / Lemma 3.1). -/
theorem greedy_alpha_self (n : ℕ) : greedy (alpha n) n = 0 := by
  refine greedy_eq_zero_of_forall (le_of_lt (alpha_pos n)) n ?_
  intro k hk
  exact alpha_strictAnti hk

/-- Consequently index `n` is selected at the target `θ = α n`. -/
theorem selected_own_angle (n : ℕ) : selected (alpha n) n = true := by
  unfold selected
  rw [greedy_alpha_self]
  simp

end HarmonicEssays
