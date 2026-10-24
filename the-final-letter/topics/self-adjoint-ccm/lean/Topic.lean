import Mathlib

/-!
# Self-adjoint / CCM operator — formal core

The archived source is a *geometric blueprint* for the Hilbert–Pólya
programme.  It defines the generalised Riemann helix

`C(t) = (cos (φ t), sin (φ t), t)`,

states its Frenet–Serret torsion formula (equation (1) of the paper),

`τ = p (p⁴ − p r + 3 q²) / (p⁶ + p⁴ + q²)`,  `p = φ'`, `q = φ''`, `r = φ'''`,

and then asserts that a Dirac operator with point interactions at the
prime logarithms is self-adjoint with the CCM band-limited form as its
projection.  The last assertions are **not** formalised here; they are
recorded as source claims in the programme dossier.

What is proved below is the elementary layer the blueprint actually uses:
the helix lies on the unit cylinder, the torsion denominator is positive,
the torsion of a constant-phase helix is the exact constant `p/(1+p²)`,
the point-interaction matching coefficient has unit modulus, the CCM
half-integer frequencies are antisymmetric under the involution
`k ↦ −k−1`, and the logarithmic dictionary sends `p^m` to `m log p`.
-/

noncomputable section

namespace CCM

/-- The generalised Riemann helix `C(t) = (cos (φ t), sin (φ t), t)`,
as a point of `ℝ × ℝ × ℝ`. -/
def helix (φ : ℝ → ℝ) (t : ℝ) : ℝ × ℝ × ℝ :=
  (Real.cos (φ t), Real.sin (φ t), t)

/-- The helix projects onto the unit cylinder: `x² + y² = 1`. -/
theorem helix_on_unit_cylinder (φ : ℝ → ℝ) (t : ℝ) :
    (helix φ t).1 ^ 2 + (helix φ t).2.1 ^ 2 = 1 := by
  simp [helix, Real.cos_sq_add_sin_sq]

/-- The source's torsion formula, as a function of `p = φ'`, `q = φ''`,
`r = φ'''`.  It is the Frenet torsion of `helix`; that derivation is
checked symbolically in `python/programme.py`, not in this file. -/
def torsionFormula (p q r : ℝ) : ℝ :=
  p * (p ^ 4 - p * r + 3 * q ^ 2) / (p ^ 6 + p ^ 4 + q ^ 2)

/-- The torsion denominator is positive whenever the phase is strictly
increasing.  This is the regularity condition for the formula. -/
theorem torsion_denom_pos {p q : ℝ} (hp : 0 < p) :
    0 < p ^ 6 + p ^ 4 + q ^ 2 := by
  have h6 : 0 < p ^ 6 := by positivity
  have h4 : 0 < p ^ 4 := by positivity
  nlinarith [sq_nonneg q]

/-- For a constant phase rate `φ' = p`, `φ'' = φ''' = 0`, the torsion
collapses to the exact constant `p / (1 + p²)`. -/
theorem torsion_const_phase {p : ℝ} (hp : 0 < p) :
    torsionFormula p 0 0 = p / (1 + p ^ 2) := by
  unfold torsionFormula
  have hden : p ^ 6 + p ^ 4 + (0 : ℝ) ^ 2 ≠ 0 := by positivity
  field_simp
  ring

/-- The constant-phase torsion is positive for a strictly increasing
phase.  (Sanity check on the sign of equation (1).) -/
theorem torsion_const_phase_pos {p : ℝ} (hp : 0 < p) :
    0 < torsionFormula p 0 0 := by
  rw [torsion_const_phase hp]
  positivity

/-- The point-interaction matching coefficient `exp (i c)` at a
scatterer.  The source uses it in the matching condition
`ψ(x⁺) = exp(i c) ψ(x⁻)`. -/
def matchingCoeff (c : ℝ) : ℂ :=
  Complex.exp (Complex.I * c)

/-- The matching coefficient has unit modulus, hence the matching
condition is unitary.  This is one necessary ingredient of the source's
self-adjointness assertion, not the assertion itself. -/
theorem matching_unitary (c : ℝ) : ‖matchingCoeff c‖ = 1 := by
  unfold matchingCoeff
  rw [Complex.norm_exp]
  simp

/-- CCM Fourier frequencies `μ_k = (2π/L)(k + ½)`, `k ∈ ℤ`. -/
def frequency (L : ℝ) (k : ℤ) : ℝ :=
  (2 * Real.pi / L) * ((k : ℝ) + 1 / 2)

/-- The half-integer frequency family is antisymmetric under
`k ↦ −k−1`: the mode `−k−1` is the conjugate of mode `k`. -/
theorem frequency_symmetry (L : ℝ) (k : ℤ) :
    frequency L (-k - 1) = -frequency L k := by
  unfold frequency
  push_cast
  ring

/-- The logarithmic cutoff dictionary: for `p > 1` and `λ > 0`,
`p^m ≤ λ²` exactly when `m log p ≤ 2 log λ`.  This is the change of
variable `x = log t` that replaces the prime-power cutoff by the
logarithmic coordinate of the helix. -/
theorem prime_power_cutoff_iff {p lam : ℝ} (hp : 1 < p) (hlam : 0 < lam)
    (m : ℕ) : p ^ m ≤ lam ^ 2 ↔ (m : ℝ) * Real.log p ≤ 2 * Real.log lam := by
  have hp0 : 0 < p := lt_trans zero_lt_one hp
  have hpm : 0 < p ^ m := pow_pos hp0 m
  have hl2 : 0 < lam ^ 2 := by positivity
  rw [← Real.log_le_log_iff hpm hl2, Real.log_pow, Real.log_pow]
  norm_num

end CCM
