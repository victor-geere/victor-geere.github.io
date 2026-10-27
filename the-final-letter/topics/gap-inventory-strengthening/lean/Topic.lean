import Mathlib

/-!
# Gap inventory — formal core of the last-chord identity

The archived gap inventory (`gaps.html`) is a checklist, not a proof
programme.  Its one elementary identity with a complete proof is the
*last-chord identity* in the section "The remaining gap, collapsed":

`H_N(s) = ((1 - N) / 2) * N ^ (-2 s)` and
`H_N(s) * H_N(1 - s) = (N - 1)^2 / (4 N^2) -> 1/4`.

The identity is an identity of monomials and holds for every real `s`.
The file proves it, together with the algebraic facts used to read the
off-line dichotomy: at a point `s = 1/2 + δ` the two factors are
`N ^ (-2 δ)` and `N ^ (2 δ)` times a fixed constant, so one tends to
zero and the other to infinity as `N -> ∞`, while their product remains
the fixed chord value.  Nothing about zeros of `ζ` is formalised here;
those statements remain source claims or open items in the dossier.
-/

noncomputable section

open Filter Topology

namespace GapInventory

/-- The last chord `H_N(s) = ((1 - N)/2) * N^(-2s)` at integer scale `N`. -/
def chord (N : ℕ) (s : ℝ) : ℝ := ((1 - (N : ℝ)) / 2) * (N : ℝ) ^ (-2 * s)

/-- The north-pole factor `N^(-2δ)` at a displacement `δ` from the centre. -/
def north (N : ℕ) (δ : ℝ) : ℝ := (N : ℝ) ^ (-2 * δ)

/-- The south-pole factor `N^(2δ)` at a displacement `δ` from the centre. -/
def south (N : ℕ) (δ : ℝ) : ℝ := (N : ℝ) ^ (2 * δ)

/-- The closed form `(N - 1)^2 / (4 N^2)` of the chord product. -/
def chordClosed (N : ℕ) : ℝ := ((N : ℝ) - 1) ^ 2 / (4 * (N : ℝ) ^ 2)

/-- **Last-chord identity.**  The product of the chord at `s` and at
`1 - s` is independent of `s` and equals `(N - 1)^2 / (4 N^2)`. -/
theorem chord_product {N : ℕ} (hN : 0 < N) (s : ℝ) :
    chord N s * chord N (1 - s) = chordClosed N := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
  have hpow : (N : ℝ) ^ (-2 * s) * (N : ℝ) ^ (-2 * (1 - s)) = ((N : ℝ) ^ 2)⁻¹ := by
    rw [← Real.rpow_add hNpos]
    have hexp : -2 * s + -2 * (1 - s) = -2 := by ring
    rw [hexp, Real.rpow_neg (le_of_lt hNpos) 2, Real.rpow_two]
  unfold chord chordClosed
  rw [mul_mul_mul_comm, hpow]
  field_simp
  ring

/-- The chord vanishes identically at the degenerate scale `N = 1`. -/
theorem chord_one (s : ℝ) : chord 1 s = 0 := by
  unfold chord
  norm_num

/-- At the centre `s = 1/2` the chord equals `(1 - N) / (2 N)`. -/
theorem chord_half {N : ℕ} (hN : 0 < N) :
    chord N (1 / 2) = (1 - (N : ℝ)) / (2 * (N : ℝ)) := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
  unfold chord
  rw [show -2 * (1 / 2 : ℝ) = -1 by norm_num, Real.rpow_neg (le_of_lt hNpos),
    Real.rpow_one]
  field_simp

/-- The chord product is positive at every scale `N > 1`. -/
theorem chord_product_pos {N : ℕ} (hN : 1 < N) : 0 < chordClosed N := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (Nat.zero_lt_of_lt hN)
  have hN1 : (1 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  unfold chordClosed
  have hnum : 0 < ((N : ℝ) - 1) ^ 2 := by
    have : 0 < (N : ℝ) - 1 := by linarith
    positivity
  have hden : 0 < 4 * (N : ℝ) ^ 2 := by positivity
  exact div_pos hnum hden

/-- The chord product written as the quarter minus its two corrections. -/
theorem chord_product_quarter {N : ℕ} (hN : 0 < N) :
    chordClosed N = 1 / 4 - 1 / (2 * (N : ℝ)) + 1 / (4 * (N : ℝ) ^ 2) := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
  unfold chordClosed
  field_simp
  ring

/-- **The chord product tends to `1/4`.**  This is the limit asserted in
the archived inventory; it is proved here as an elementary limit of the
closed form, not as a statement about zeros of `ζ`. -/
theorem chord_product_tendsto :
    Tendsto (fun N : ℕ => chordClosed N) atTop (𝓝 (1 / 4)) := by
  have hu : Tendsto (fun N : ℕ => ((N : ℝ))⁻¹) atTop (𝓝 0) :=
    tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop
  have hlim :
      Tendsto (fun N : ℕ => 1 / 4 - 1 / 2 * ((N : ℝ))⁻¹ + 1 / 4 * (((N : ℝ))⁻¹) ^ 2)
        atTop (𝓝 (1 / 4 - 1 / 2 * 0 + 1 / 4 * 0 ^ 2)) := by
    exact ((tendsto_const_nhds.sub ((tendsto_const_nhds.mul hu))).add
      (tendsto_const_nhds.mul (hu.pow 2)))
  have hcongr :
      (fun N : ℕ => chordClosed N) =ᶠ[atTop]
        fun N : ℕ => 1 / 4 - 1 / 2 * ((N : ℝ))⁻¹ + 1 / 4 * (((N : ℝ))⁻¹) ^ 2 := by
    filter_upwards [eventually_gt_atTop 0] with N hN
    have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast hN
    have hNne : (N : ℝ) ≠ 0 := ne_of_gt hNpos
    unfold chordClosed
    field_simp
    ring
  rw [tendsto_congr' hcongr]
  simpa using hlim

/-- **Off-line dichotomy.**  At `s = 1/2 + δ` the two factors are a fixed
constant times `N^(-2δ)` and `N^(2δ)`; for `N > 1` and `δ > 0` one is
below `1`, the other above `1`, and their product is exactly `1`. -/
theorem pole_dichotomy {N : ℕ} (hN : 1 < N) {δ : ℝ} (hδ : 0 < δ) :
    north N δ * south N δ = 1 ∧ north N δ < 1 ∧ 1 < south N δ := by
  have hNpos : (0 : ℝ) < (N : ℝ) := by exact_mod_cast (Nat.zero_lt_of_lt hN)
  have hN1 : (1 : ℝ) < (N : ℝ) := by exact_mod_cast hN
  have hpow : north N δ * south N δ = (N : ℝ) ^ (-2 * δ + 2 * δ) := by
    unfold north south
    rw [Real.rpow_add hNpos]
  have hsum : -2 * δ + 2 * δ = 0 := by ring
  have hmul : north N δ * south N δ = 1 := by
    rw [hpow, hsum, Real.rpow_zero]
  have hnorth : north N δ < 1 := by
    unfold north
    have h := Real.one_lt_rpow hN1 (by linarith : (0 : ℝ) < 2 * δ)
    rw [show -2 * δ = -(2 * δ) by ring, Real.rpow_neg (le_of_lt hNpos)]
    exact inv_lt_one_of_one_lt₀ h
  have hsouth : 1 < south N δ := by
    unfold south
    exact Real.one_lt_rpow hN1 (by linarith : (0 : ℝ) < 2 * δ)
  exact ⟨hmul, hnorth, hsouth⟩

end GapInventory
