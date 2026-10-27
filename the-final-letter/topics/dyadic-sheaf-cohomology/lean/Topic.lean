import Mathlib

/-!
# Dyadic sheaf cohomology — formal core

The archived essays (`archive/essays/rh/dyadic-sheaf*.html`) propose a
dyadic sheaf on the adeles and conjecture that `H¹` vanishes off the
critical line. The construction is explicitly speculative: the essays
state that the differential `d`, the anti-involution `τ`, and the
cohomology groups are not defined. Nothing cohomological is formalised
here.

What *is* formalised is the finite dyadic/energy algebra that the essays
actually define:

* the dyadic filtration radius `2^{-k}` and its elementary order and
  limit properties (the source's balls `U_v^(k) = {2^{-k} ≤ |x| < 2^{-k+1}}`);
* the alignment energy `E(x;t) = (1 - cos(2πt/x))² + (1 - cos(2πx))²`,
  its non-negativity, its vanishing criterion, and its `x ↔ t/x`
  symmetry;
* the forward direction of the source's divisor-detection identity: for
  a positive integer `x`, `x ∣ p` forces `E(p;x) = 0`.

The converse of the divisor-detection identity, the cohomological
vanishing statements, and the RH bridge are recorded as source claims
or open items in the programme dossier.
-/

noncomputable section

open Filter Topology

namespace DyadicSheaf

/-- Dyadic ball radius `2^{-k}`. The source's dyadic boxes are
`U_v^(k) = {x : 2^{-k} ≤ |x| < 2^{-k+1}}`. -/
def dyadicRadius (k : ℕ) : ℝ := (1 / 2 : ℝ) ^ k

/-- The alignment energy of the source, written as a function of the
height `t` and the test point `x`:
`E(x;t) = (1 - cos(2πt/x))² + (1 - cos(2πx))²`. -/
def energy (t x : ℝ) : ℝ :=
  (1 - Real.cos (2 * Real.pi * t / x)) ^ 2 + (1 - Real.cos (2 * Real.pi * x)) ^ 2

/-! ## The dyadic filtration -/

theorem dyadicRadius_pos (k : ℕ) : 0 < dyadicRadius k := by
  unfold dyadicRadius
  positivity

/-- Refining the dyadic grid by one step halves the radius. This is the
finite content of "restriction maps correspond to finer dyadic grids". -/
theorem dyadicRadius_succ (k : ℕ) : dyadicRadius (k + 1) = dyadicRadius k / 2 := by
  unfold dyadicRadius
  rw [pow_succ]
  ring

theorem dyadicRadius_strictAnti : StrictAnti dyadicRadius := by
  apply strictAnti_nat_of_succ_lt
  intro k
  rw [dyadicRadius_succ]
  have h := dyadicRadius_pos k
  linarith

theorem dyadicRadius_tendsto_zero : Tendsto dyadicRadius atTop (𝓝 0) := by
  change Tendsto (fun k : ℕ => (1 / 2 : ℝ) ^ k) atTop (𝓝 0)
  exact tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num) (by norm_num)

/-! ## The alignment energy -/

theorem energy_nonneg (t x : ℝ) : 0 ≤ energy t x := by
  unfold energy
  have h1 := sq_nonneg (1 - Real.cos (2 * Real.pi * t / x))
  have h2 := sq_nonneg (1 - Real.cos (2 * Real.pi * x))
  linarith

/-- The energy vanishes exactly when both cosine alignments are perfect.
This is the "zero of energy" object that the essays discuss. -/
theorem energy_eq_zero_iff (t x : ℝ) :
    energy t x = 0 ↔
      Real.cos (2 * Real.pi * t / x) = 1 ∧ Real.cos (2 * Real.pi * x) = 1 := by
  unfold energy
  constructor
  · intro h
    have h1 : (1 - Real.cos (2 * Real.pi * t / x)) ^ 2 = 0 := by
      nlinarith [sq_nonneg (1 - Real.cos (2 * Real.pi * t / x)),
        sq_nonneg (1 - Real.cos (2 * Real.pi * x))]
    have h2 : (1 - Real.cos (2 * Real.pi * x)) ^ 2 = 0 := by
      nlinarith [sq_nonneg (1 - Real.cos (2 * Real.pi * t / x)),
        sq_nonneg (1 - Real.cos (2 * Real.pi * x))]
    have h1' : 1 - Real.cos (2 * Real.pi * t / x) = 0 :=
      pow_eq_zero_iff (by norm_num : (2 : ℕ) ≠ 0) |>.mp h1
    have h2' : 1 - Real.cos (2 * Real.pi * x) = 0 :=
      pow_eq_zero_iff (by norm_num : (2 : ℕ) ≠ 0) |>.mp h2
    exact ⟨by linarith, by linarith⟩
  · rintro ⟨h1, h2⟩
    simp [h1, h2]

/-- The energy is symmetric under `x ↦ t/x`, the reflection used in the
essays to construct the anti-involution `τ`. -/
theorem energy_symm (t x : ℝ) (ht : t ≠ 0) (hx : x ≠ 0) :
    energy t x = energy t (t / x) := by
  unfold energy
  have harg1 : 2 * Real.pi * t / (t / x) = 2 * Real.pi * x := by
    field_simp
  have harg2 : 2 * Real.pi * (t / x) = 2 * Real.pi * t / x := by
    ring
  rw [harg1, harg2]
  ring

/-- Forward direction of the source's divisor-detection identity: when
`x ≥ 1` divides `p`, the energy at `(t, x) = (p, x)` vanishes. -/
theorem energy_vanishes_of_dvd (p x : ℕ) (hx : 0 < x) (h : x ∣ p) :
    energy (p : ℝ) (x : ℝ) = 0 := by
  obtain ⟨q, rfl⟩ := h
  rw [energy_eq_zero_iff]
  constructor
  · have harg : 2 * Real.pi * ((x * q : ℕ) : ℝ) / (x : ℝ) = (q : ℝ) * (2 * Real.pi) := by
      have hxR : (x : ℝ) ≠ 0 := by exact_mod_cast hx.ne'
      push_cast
      field_simp
    rw [harg, Real.cos_nat_mul_two_pi]
  · have harg : 2 * Real.pi * (x : ℝ) = (x : ℝ) * (2 * Real.pi) := by ring
    rw [harg, Real.cos_nat_mul_two_pi]

end DyadicSheaf
