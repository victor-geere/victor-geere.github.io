import Mathlib

/-!
# GHD correlation kernel — formal core

The archived GHD corpus defines harmonic angles `α n = π / (n + 2)` and the
centred step functions `φ n = 1[θ ≥ α n] - θ / π`, and integrates their
Gram matrix.  The resulting *step-model* kernel has exact closed forms.

This file formalises that finite core: the order facts for the angles, the
diagonal kernel in closed form, positivity and symmetry of the diagonal
entry, the exact value at `π/2`, and symmetry of the off-diagonal step
kernel.

It does **not** formalise the archived claim that the step model is the
correlation kernel of the actual greedy algorithm.  That identification is
false in general; see `lean/README.md`.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace GHD

/-- The harmonic angle `α n = π / (n + 2)`. -/
def alpha (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- Diagonal correlation kernel of the step model at threshold `t`,
`K(t,t) = (t³ + (π - t)³) / (3π²)`. -/
def Kdiag (t : ℝ) : ℝ := (t ^ 3 + (Real.pi - t) ^ 3) / (3 * Real.pi ^ 2)

/-- Off-diagonal step-model kernel in units of `a = t/π`, `b = u/π`:
`K = π((a² + b²)/2 - max a b + 1/3)`. -/
def Kstep (a b : ℝ) : ℝ :=
  Real.pi * ((a ^ 2 + b ^ 2) / 2 - max a b + 1 / 3)

theorem alpha_pos (n : ℕ) : 0 < alpha n := by
  unfold alpha
  positivity

theorem alpha_strictAnti : StrictAnti alpha := by
  intro a b hab
  unfold alpha
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact div_lt_div_of_pos_left Real.pi_pos (by positivity) h

/-- The diagonal entry at `t = α n` in the closed form advertised by the
source: `K(α n, α n) = (π/3)(1 + (n+1)³)/(n+2)³`. -/
theorem Kdiag_alpha_closed (n : ℕ) :
    Kdiag (alpha n) = Real.pi / 3 * (1 + ((n : ℝ) + 1) ^ 3) / ((n : ℝ) + 2) ^ 3 := by
  unfold Kdiag alpha
  have h : ((n : ℝ) + 2) ≠ 0 := by positivity
  field_simp [h]
  ring

theorem Kdiag_pos {t : ℝ} (h0 : 0 < t) (hπ : t < Real.pi) : 0 < Kdiag t := by
  unfold Kdiag
  have h1 : 0 < t ^ 3 := by positivity
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

/-- The finite off-diagonal kernel is symmetric. -/
theorem Kstep_symm (a b : ℝ) : Kstep a b = Kstep b a := by
  unfold Kstep
  rw [max_comm a b]
  ring

end GHD
