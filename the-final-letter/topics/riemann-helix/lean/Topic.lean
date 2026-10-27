import Mathlib

/-!
# Riemann helix — formal core

The archived source (`archive/maths/r-helix/conjecture.html`) proposes an
equivalence between the Riemann Hypothesis and the vanishing of the
extra torsion terms of a varying-radius helix
`C_r(t) = (r(t) cos φ(t), r(t) sin φ(t), t)`.

This file does **not** formalise that equivalence.  It formalises the
elementary constant-radius helix geometry on which the source's
argument relies, and two facts that expose gaps in the source's proof
sketch:

* torsion is *not* invariant under scaling of the helix (`torsion_scale`);
* consequently the source's step `τ_{1/2} = τ_1` is false for the curve
  as displayed (`torsion_half_ne_unit`).

The distributional limit, the varying-radius torsion formula, and the
RH equivalence itself are recorded as source claims / open items in the
programme README.
-/

noncomputable section

namespace RiemannHelix

/-- The circular helix of radius `R` and pitch `c`,
`C(t) = (R cos t, R sin t, c t)`. -/
def helix (R c t : ℝ) : ℝ × ℝ × ℝ :=
  (R * Real.cos t, R * Real.sin t, c * t)

/-- Curvature of the circular helix of radius `R` and pitch `c`.
The value is the classical `κ = R / (R² + c²)`. -/
def curvature (R c : ℝ) : ℝ := R / (R ^ 2 + c ^ 2)

/-- Torsion of the circular helix of radius `R` and pitch `c`.
The value is the classical `τ = c / (R² + c²)`. -/
def torsion (R c : ℝ) : ℝ := c / (R ^ 2 + c ^ 2)

/-- The helix has constant cylindrical radius: its horizontal
coordinates satisfy `x² + y² = R²`. -/
theorem helix_on_cylinder (R c t : ℝ) :
    (helix R c t).1 ^ 2 + (helix R c t).2.1 ^ 2 = R ^ 2 := by
  unfold helix
  rw [mul_pow, mul_pow, ← mul_add, Real.cos_sq_add_sin_sq, mul_one]

/-- For positive radius and pitch the torsion is positive. -/
theorem torsion_pos {R c : ℝ} (hR : 0 < R) (hc : 0 < c) : 0 < torsion R c := by
  unfold torsion
  positivity

/-- For fixed positive pitch the torsion is strictly decreasing in the
radius.  In particular the torsion carries genuine radius information. -/
theorem torsion_strictAnti_radius {R₁ R₂ c : ℝ} (hR₁ : 0 < R₁) (h12 : R₁ < R₂)
    (hc : 0 < c) : torsion R₂ c < torsion R₁ c := by
  have hden₁ : 0 < R₁ ^ 2 + c ^ 2 := by positivity
  have hden₂ : 0 < R₂ ^ 2 + c ^ 2 := by positivity
  have hsq : R₁ ^ 2 < R₂ ^ 2 :=
    pow_lt_pow_left₀ h12 (le_of_lt hR₁) (by norm_num : (2 : ℕ) ≠ 0)
  have hs : R₁ ^ 2 + c ^ 2 < R₂ ^ 2 + c ^ 2 := by linarith
  unfold torsion
  rw [div_lt_div_iff₀ hden₂ hden₁]
  exact mul_lt_mul_of_pos_left hs hc

/-- Uniform scaling of the helix by `λ > 0` scales its torsion by `1 / λ`.
Torsion has dimension `1 / length`, so it is not scale invariant. -/
theorem torsion_scale {R c lam : ℝ} (hR : 0 < R) (hc : 0 < c) (hlam : 0 < lam) :
    torsion (lam * R) (lam * c) = torsion R c / lam := by
  have hden : R ^ 2 + c ^ 2 ≠ 0 := by positivity
  have hden' : (lam * R) ^ 2 + (lam * c) ^ 2 ≠ 0 := by positivity
  unfold torsion
  field_simp [hden, hden', ne_of_gt hlam]

/-- Scaling by a factor other than `1` changes the torsion.  This is the
precise sense in which the source's "scaling does not change the torsion"
step fails. -/
theorem torsion_not_scale_invariant {R c lam : ℝ} (hR : 0 < R) (hc : 0 < c)
    (hlam : 0 < lam) (hlam1 : lam ≠ 1) :
    torsion (lam * R) (lam * c) ≠ torsion R c := by
  rw [torsion_scale hR hc hlam]
  intro h
  have hpos : 0 < torsion R c := torsion_pos hR hc
  have hmul : torsion R c = torsion R c * lam := by
    calc
      torsion R c = (torsion R c / lam) * lam :=
        (div_mul_cancel₀ _ (ne_of_gt hlam)).symm
      _ = torsion R c * lam := by rw [h]
  have hzero : torsion R c * (lam - 1) = 0 := by
    rw [mul_sub, mul_one, ← hmul, sub_self]
  have hne : torsion R c ≠ 0 := ne_of_gt hpos
  exact hlam1 (by
    have : lam - 1 = 0 := (mul_eq_zero.mp hzero).resolve_left hne
    linarith)

/-- In the constant-rate family, the helix with radius `1/2` and pitch `1`
does **not** have the same torsion as the unit-radius helix: the closed
forms are `4/5` and `1/2`.  This is the simplest counterexample to the
source's step "scaling does not change the torsion"; the source's
`C_{1/2}` is moreover not a uniform scaling of `C_1`, since `z = t` is
unchanged. -/
theorem torsion_half_ne_unit : torsion (1 / 2) 1 ≠ torsion 1 1 := by
  norm_num [torsion]

/-- The algebraic criterion relating the Frenet invariants of a circular
helix to its radius and pitch.  For `R² + c² ≠ 0`:

* `κ² + τ² = 1 / (R² + c²)`;
* the radius is recovered as `R = κ / (κ² + τ²)`;
* the pitch is recovered as `c = τ / (κ² + τ²)`.

Thus a constant-radius helix is determined, up to rigid motion, by its
constant curvature and torsion. -/
theorem curvature_torsion_inversion {R c : ℝ} (h : R ^ 2 + c ^ 2 ≠ 0) :
    curvature R c ^ 2 + torsion R c ^ 2 = 1 / (R ^ 2 + c ^ 2) ∧
      curvature R c / (curvature R c ^ 2 + torsion R c ^ 2) = R ∧
        torsion R c / (curvature R c ^ 2 + torsion R c ^ 2) = c := by
  have hsum : curvature R c ^ 2 + torsion R c ^ 2 = 1 / (R ^ 2 + c ^ 2) := by
    unfold curvature torsion
    field_simp [h]
  refine ⟨hsum, ?_, ?_⟩
  · rw [hsum]
    unfold curvature
    field_simp [h]
  · rw [hsum]
    unfold torsion
    field_simp [h]

end RiemannHelix
