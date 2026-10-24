import Mathlib

/-!
# Geometric reformulation — formal core

This file records the elementary facts about the twin-conical-helix and
Riemann-helix construction that can be proved without the analytic
machinery of the archived paper.  The paper's Conjecture 3.1 (the
"geometric explicit formula"), its conditional Theorem 4.1, the
Möbius/prime-distribution derivation, and the CCM dictionary are *not*
formalised here; they are recorded as source claims or open items in the
programme dossier.

The torsion definitions below are the closed forms obtained from the
Frenet–Serret formula for the constant-pitch helices
`(cos (ω t), sin (ω t), t)` and `(c cos (ω t), c sin (ω t), t)`.
The Python layer re-derives them symbolically and also records that the
archived formula (3.2) is not the Frenet torsion.
-/

noncomputable section

namespace GeometricReformulation

/-- Torsion of the unit helix `(cos (ω t), sin (ω t), t)`. -/
def helixTorsion (ω : ℝ) : ℝ := ω / (1 + ω ^ 2)

/-- Torsion of the constant-radius helix `(c cos (ω t), c sin (ω t), t)`. -/
def scaledTorsion (c ω : ℝ) : ℝ := ω / (1 + c ^ 2 * ω ^ 2)

/-- Radius of the conical helix at the `k`-th intersection abscissa
`x_k = exp (k π / t)`, namely `x_k ^ (-σ) = exp (-(σ π / t) k)`. -/
def coneRadius (σ t : ℝ) (k : ℕ) : ℝ :=
  Real.exp (-(σ * Real.pi / t) * (k : ℝ))

/-- Weight of the prime-power atom `m log p` in the geometric prime
distribution: `log p / p ^ (m / 2)`. -/
def primeWeight (p : ℝ) (m : ℕ) : ℝ :=
  Real.log p / p ^ ((m : ℝ) / 2)

/-- The torsion of the unit helix is positive when the pitch parameter is. -/
theorem helixTorsion_pos {ω : ℝ} (h : 0 < ω) : 0 < helixTorsion ω := by
  unfold helixTorsion
  positivity

/-- The unit-helix torsion is strictly below `1/2` away from `ω = 1`.
This is the elementary bound behind the pitch-`1` extremal case. -/
theorem helixTorsion_lt_half {ω : ℝ} (h : ω ≠ 1) :
    helixTorsion ω < 1 / 2 := by
  unfold helixTorsion
  have hden : (0 : ℝ) < 1 + ω ^ 2 := by positivity
  rw [div_lt_iff₀ hden]
  have hsq : 0 < (ω - 1) ^ 2 := by
    have hne : ω - 1 ≠ 0 := sub_ne_zero.mpr h
    exact sq_pos_of_ne_zero hne
  nlinarith

/-- The unit-helix torsion is invariant under the reciprocal pitch
`ω ↦ 1 / ω`. -/
theorem helixTorsion_symm {ω : ℝ} (h : ω ≠ 0) :
    helixTorsion ω = helixTorsion ω⁻¹ := by
  unfold helixTorsion
  field_simp [h]
  ring

/-- At radius `1/2` and pitch `1`, the constant-radius helix has torsion
`4/5`. -/
theorem scaledTorsion_half_one :
    scaledTorsion (1 / 2) 1 = 4 / 5 := by
  unfold scaledTorsion
  norm_num

/-- Constant rescaling of the radius is *not* torsion-preserving: the
source's proof of Theorem 4.1 uses the opposite assertion. -/
theorem scaling_not_torsion_invariant :
    scaledTorsion (1 / 2) 1 ≠ helixTorsion 1 := by
  unfold scaledTorsion helixTorsion
  norm_num

/-- For `σ, t > 0` the conical-helix radius is positive everywhere and
strictly decreasing in the intersection index `k`. -/
theorem coneRadius_pos_and_strictAnti {σ t : ℝ} (hσ : 0 < σ) (ht : 0 < t) :
    (∀ k : ℕ, 0 < coneRadius σ t k) ∧ StrictAnti (coneRadius σ t) := by
  have hcoef : 0 < σ * Real.pi / t := by positivity
  constructor
  · intro k
    unfold coneRadius
    positivity
  · intro a b hab
    unfold coneRadius
    apply Real.exp_lt_exp.mpr
    have hlt : (a : ℝ) < b := by exact_mod_cast hab
    nlinarith

/-- Every prime-power atom of the geometric prime distribution has
strictly positive weight. -/
theorem primeWeight_pos {p : ℝ} (hp : 1 < p) (m : ℕ) :
    0 < primeWeight p m := by
  unfold primeWeight
  have hp0 : 0 < p := by linarith
  exact div_pos (Real.log_pos hp) (Real.rpow_pos_of_pos hp0 _)

end GeometricReformulation
