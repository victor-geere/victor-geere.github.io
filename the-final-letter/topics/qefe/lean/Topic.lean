import Mathlib

/-!
# Quantum–Egyptian functional equation — formal core

The archived source (`archive/qefe/quantum-egyptian-functional-equation-v8.html`)
claims a Riemann-zeta-type functional equation for a Dirichlet series built from
the *Egyptian denominators* `m_i = D² / d_i²` of an integral modular tensor
category.  The full functional equation is recorded as a source claim in the
programme dossier: the archived proof has an acknowledged gap, and the exact
examples tabulated in the source do not satisfy the displayed identity away from
the central point.

This file proves the elementary part that is genuinely available: the Egyptian
denominator algebra, the finite Egyptian-fraction identity of Lemma 2.2, and the
central-point value of the gamma-factor ratio and the QEFE prefactor.
-/

noncomputable section

open scoped BigOperators

namespace QEFE

/-- The Egyptian denominator `m = D² / d²` attached to an object of squared
quantum dimension `d²`. -/
def egyptianDenom (D2 d2 : ℝ) : ℝ := D2 / d2

/-- The reciprocal Egyptian mass of the non-unit objects predicted by Lemma 2.2:
`1 - 1/D²`. -/
def egyptianUnit (D2 : ℝ) : ℝ := 1 - 1 / D2

/-- Egyptian denominators are positive whenever `D²` and `d²` are. -/
theorem egyptianDenom_pos {D2 d2 : ℝ} (hD : 0 < D2) (hd : 0 < d2) :
    0 < egyptianDenom D2 d2 := by
  unfold egyptianDenom
  exact div_pos hD hd

/-- The reciprocal of an Egyptian denominator is `d² / D²`; this is the
identity used to turn the sum of reciprocals into the quantum-dimension sum. -/
theorem inv_egyptianDenom {D2 d2 : ℝ} (hD : D2 ≠ 0) (hd : d2 ≠ 0) :
    (egyptianDenom D2 d2)⁻¹ = d2 / D2 := by
  unfold egyptianDenom
  field_simp

/-- The non-unit Egyptian mass is positive once `D² > 1`. -/
theorem egyptianUnit_pos {D2 : ℝ} (hD : 1 < D2) : 0 < egyptianUnit D2 := by
  unfold egyptianUnit
  have hpos : 0 < D2 := by linarith
  rw [sub_pos, div_lt_one hpos]
  exact hD

/-- The total Egyptian reciprocal sum is one: `∑_i 1/m_i = 1`. -/
theorem egyptian_total {n : ℕ} (d2 : Fin (n + 1) → ℝ) (D2 : ℝ)
    (hD : D2 = ∑ i, d2 i) (hd : ∀ i, d2 i ≠ 0) (hD0 : D2 ≠ 0) :
    ∑ i, (egyptianDenom D2 (d2 i))⁻¹ = 1 := by
  have h : ∀ i, (egyptianDenom D2 (d2 i))⁻¹ = d2 i / D2 := by
    intro i
    exact inv_egyptianDenom hD0 (hd i)
  simp_rw [h]
  rw [← Finset.sum_div, ← hD]
  exact div_self hD0

/-- Lemma 2.2 of the source: for a finite integral MTC datum with unit object
`d_0² = 1`, the non-unit Egyptian denominators satisfy
`∑_{i ≠ 0} 1/m_i = 1 - 1/D²`. -/
theorem egyptian_fraction_identity {n : ℕ} (d2 : Fin (n + 1) → ℝ) (D2 : ℝ)
    (hD : D2 = ∑ i, d2 i) (h0 : d2 0 = 1) (hd : ∀ i, d2 i ≠ 0) (hD0 : D2 ≠ 0) :
    ∑ i ∈ Finset.univ.erase 0, (egyptianDenom D2 (d2 i))⁻¹ = 1 - 1 / D2 := by
  have h : ∀ i, (egyptianDenom D2 (d2 i))⁻¹ = d2 i / D2 := by
    intro i
    exact inv_egyptianDenom hD0 (hd i)
  have hsplit : ∑ i ∈ Finset.univ.erase 0, d2 i + d2 0 = ∑ i, d2 i :=
    Finset.sum_erase_add Finset.univ d2 (Finset.mem_univ 0)
  have herase : ∑ i ∈ Finset.univ.erase 0, d2 i = D2 - 1 := by
    rw [h0] at hsplit
    linarith
  simp_rw [h]
  rw [← Finset.sum_div, herase]
  field_simp

/-- The gamma-factor ratio appearing in the claimed functional equation. -/
def gammaRatio (a s : ℝ) : ℝ :=
  Real.Gamma ((1 - s + a) / 2) / Real.Gamma ((s + a) / 2)

/-- At the central point `s = 1/2` the gamma-factor ratio is exactly `1`. -/
theorem gammaRatio_center {a : ℝ} (ha : 0 ≤ a) :
    gammaRatio a (1 / 2) = 1 := by
  unfold gammaRatio
  have harg : (1 - (1 / 2 : ℝ) + a) / 2 = ((1 / 2 : ℝ) + a) / 2 := by ring
  rw [harg]
  have hpos : 0 < ((1 / 2 : ℝ) + a) / 2 := by positivity
  exact div_self (ne_of_gt (Real.Gamma_pos_of_pos hpos))

/-- The full prefactor of the claimed QEFE, `(D²/π)^(s-1/2) Γ((1-s+a)/2)/Γ((s+a)/2)`. -/
def qefePrefactor (D2 a s : ℝ) : ℝ :=
  (D2 / Real.pi) ^ (s - 1 / 2) * gammaRatio a s

/-- At `s = 1/2` the QEFE prefactor is exactly `1`, so the claimed functional
equation degenerates to a self-duality statement at the central point. -/
theorem qefePrefactor_center {D2 a : ℝ} (_hD : 0 < D2) (ha : 0 ≤ a) :
    qefePrefactor D2 a (1 / 2) = 1 := by
  unfold qefePrefactor
  rw [gammaRatio_center ha, sub_self, Real.rpow_zero, one_mul]

end QEFE
