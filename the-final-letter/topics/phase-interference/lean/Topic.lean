import Mathlib

/-!
# Phase interference — formal core

This file records the elementary phase and kernel algebra used by the
archived phase-interference note. The note's GRH conclusion is an archived
claim and is not formalised here; see `README.md` and `lean/README.md`.
-/

noncomputable section

namespace PhaseInterference

open Complex

/-- The oscillatory phase factor `w_n(t) = (n+2)^{-it} = exp(-i t log(n+2))`. -/
def phase (n : ℕ) (t : ℝ) : ℂ :=
  Complex.exp (((-(t * Real.log ((n : ℝ) + 2))) : ℝ) * Complex.I)

/-- The phase-weighted kernel entry of Definition 2.6 on `s = 1/2 + it`. -/
def weighted (K : ℝ) (n m : ℕ) (t : ℝ) : ℂ :=
  (K : ℂ) * phase n t * phase m t

theorem phase_norm (n : ℕ) (t : ℝ) : ‖phase n t‖ = 1 := by
  unfold phase
  exact Complex.norm_exp_ofReal_mul_I _

theorem phase_zero (n : ℕ) : phase n 0 = 1 := by
  simp [phase]

theorem phase_conj (n : ℕ) (t : ℝ) :
    (starRingEnd ℂ) (phase n t) = phase n (-t) := by
  unfold phase
  rw [← Complex.exp_conj]
  congr 1
  simp [Complex.conj_I]

theorem weighted_comm (K : ℝ) (n m : ℕ) (t : ℝ) :
    weighted K n m t = weighted K m n t := by
  unfold weighted
  ring

theorem weighted_conj (K : ℝ) (n m : ℕ) (t : ℝ) :
    (starRingEnd ℂ) (weighted K n m t) = weighted K n m (-t) := by
  unfold weighted
  rw [map_mul, map_mul]
  have hK : (starRingEnd ℂ) (K : ℂ) = (K : ℂ) := by simp
  rw [hK, phase_conj, phase_conj]

theorem weighted_norm (K : ℝ) (n m : ℕ) (t : ℝ) :
    ‖weighted K n m t‖ = |K| := by
  unfold weighted
  rw [norm_mul, norm_mul, Complex.norm_real, Real.norm_eq_abs, phase_norm, phase_norm]
  ring

theorem phase_add_norm_le (n m : ℕ) (t : ℝ) :
    ‖phase n t + phase m t‖ ≤ 2 := by
  calc
    ‖phase n t + phase m t‖ ≤ ‖phase n t‖ + ‖phase m t‖ := norm_add_le _ _
    _ = 2 := by rw [phase_norm, phase_norm]; norm_num

end PhaseInterference
