import Mathlib

/-!
# Greedy harmonic decomposition — formal core

This file records the elementary order and kernel facts used by the
greedy harmonic decomposition. The source's analytic reconstruction and
the full threshold recursion are recorded as source claims in the
programme dossier; the theorems below are the part of the reconstruction
that is proved here.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace GHD

/-- The harmonic angle `α_n = π / (n + 2)`. -/
def alpha (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- The diagonal correlation kernel, as a function of the threshold `t`. -/
def Kdiag (t : ℝ) : ℝ := (t ^ 3 + (Real.pi - t) ^ 3) / (3 * Real.pi ^ 2)

theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

theorem alpha_tendsto_zero : Tendsto alpha atTop (𝓝 0) := by
  have h := tendsto_const_div_atTop_nhds_zero_nat (𝕜 := ℝ) Real.pi
  have h2 : Tendsto (fun n : ℕ => Real.pi / (((n + 2 : ℕ) : ℝ))) atTop (𝓝 0) :=
    h.comp (tendsto_add_atTop_nat 2)
  change Tendsto (fun n : ℕ => Real.pi / ((n : ℝ) + 2)) atTop (𝓝 0)
  simpa [Nat.cast_add] using h2

theorem scaled_alpha (n : ℕ) : ((n : ℝ) + 2) * alpha n = Real.pi := by
  unfold alpha
  have h : ((n : ℝ) + 2) ≠ 0 := by positivity
  field_simp [h]

theorem Kdiag_pos {t : ℝ} (h0 : 0 < t) (hπ : t < Real.pi) : 0 < Kdiag t := by
  unfold Kdiag
  have h1 : 0 < t ^ 3 := by positivity
  have h2base : 0 < Real.pi - t := by linarith
  have h2 : 0 < (Real.pi - t) ^ 3 := by positivity
  have hsum : 0 < t ^ 3 + (Real.pi - t) ^ 3 := add_pos h1 h2
  have hden : 0 < 3 * Real.pi ^ 2 := by positivity
  exact div_pos hsum hden

theorem Kdiag_symm (t : ℝ) : Kdiag t = Kdiag (Real.pi - t) := by
  unfold Kdiag
  ring

theorem Kdiag_half : Kdiag (Real.pi / 2) = Real.pi / 12 := by
  unfold Kdiag
  field_simp [Real.pi_ne_zero]
  ring

end GHD
