import Mathlib

/-!
# Euler transformation for alternating series

First step: the one-fold summation-by-parts identity for finite alternating sums.
-/

noncomputable section

namespace FiniteWindowZeros

open Finset

/-- Forward difference `Δ a n = a n - a (n+1)`. -/
def delta (a : ℕ → ℂ) (n : ℕ) : ℂ := a n - a (n + 1)

/-- The alternating partial sum `Σ_{n<N} (-1)^n a n`. -/
def altSum (a : ℕ → ℂ) (N : ℕ) : ℂ :=
  ∑ n ∈ range N, (-1 : ℂ) ^ n * a n

/-- The one-fold difference identity. -/
theorem altSum_delta (a : ℕ → ℂ) (N : ℕ) :
    altSum (delta a) N = 2 * altSum a N - a 0 + (-1 : ℂ) ^ N * a N := by
  induction N with
  | zero => simp [altSum]
  | succ N ih =>
      have h1 : altSum a (N + 1) = altSum a N + (-1 : ℂ) ^ N * a N := by
        simp [altSum, Finset.sum_range_succ]
      have h2 : altSum (delta a) (N + 1) =
          altSum (delta a) N + (-1 : ℂ) ^ N * delta a N := by
        simp [altSum, Finset.sum_range_succ]
      rw [h2, ih, h1]
      simp only [delta, pow_succ]
      ring

/-- One-fold Euler summation by parts. -/
theorem altSum_eq (a : ℕ → ℂ) (N : ℕ) :
    altSum a N = a 0 / 2 + (1 / 2) * altSum (delta a) N -
      ((-1 : ℂ) ^ N) * a N / 2 := by
  have h := altSum_delta a N
  linear_combination (-1 / 2 : ℂ) * h

/-- Iterated forward differences. -/
def deltaN : ℕ → (ℕ → ℂ) → (ℕ → ℂ)
  | 0, a => a
  | k + 1, a => delta (deltaN k a)

/-- Finite Euler transformation with explicit boundary terms. -/
theorem altSum_euler (K N : ℕ) (a : ℕ → ℂ) :
    altSum a N =
      (∑ k ∈ range K, (1 / 2 : ℂ) ^ (k + 1) * deltaN k a 0) +
      (1 / 2 : ℂ) ^ K * altSum (deltaN K a) N -
      (-1 : ℂ) ^ N * (∑ k ∈ range K, (1 / 2 : ℂ) ^ (k + 1) * deltaN k a N) := by
  induction K with
  | zero => simp [deltaN]
  | succ K ih =>
      rw [ih]
      have h := altSum_eq (deltaN K a) N
      rw [h]
      rw [Finset.sum_range_succ, Finset.sum_range_succ]
      simp only [deltaN, pow_succ]
      ring

end FiniteWindowZeros
