import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import RH9.Zeros
import RH9.PhaseFunction
import RH9.RadiusFunction

/-!
# The Two Space Curves

We define and study the two space curves from rh9.tex:

1. **Unit-radius Riemann helix**
   C₁(t) = (cos φ(t), sin φ(t), t)

2. **Real-part-radius helix**
   Cᵣ(t) = (r(t) · cos φ(t), r(t) · sin φ(t), t)

Both curves are smooth. Their zero-encoding properties are verified:
- C₁(γₙ) = (1, 0, γₙ)
- Cᵣ(γₙ) = (βₙ, 0, γₙ)

Under RH (r ≡ 1/2), Cᵣ = C_{1/2} is a constant scaling of C₁.
-/

namespace RH9

open Real

variable {zd : ZeroData}

/-! ## Unit-radius helix C₁ -/

/-- The unit-radius Riemann helix C₁ : ℝ → ℝ³. -/
noncomputable def C₁ (pf : PhaseFunction zd) (t : ℝ) : ℝ × ℝ × ℝ :=
  (cos (pf.φ t), sin (pf.φ t), t)

namespace C₁

variable (pf : PhaseFunction zd)

/-- C₁ is smooth. -/
theorem smooth : ContDiff ℝ ⊤ (C₁ pf) := by
  apply ContDiff.prod
  · exact (Real.contDiff_cos.comp pf.smooth)
  apply ContDiff.prod
  · exact (Real.contDiff_sin.comp pf.smooth)
  · exact contDiff_id

/-- At the n-th zero ordinate, C₁ hits the generator (1, 0, γₙ).
    This follows because φ(γₙ) = 2πn and cos(2πn) = 1, sin(2πn) = 0. -/
theorem at_zero (n : ℕ) : C₁ pf (zd.γ n) = (1, 0, zd.γ n) := by
  simp only [C₁, pf.interpolates]
  constructor
  · rw [cos_two_pi_mul_nat]
  constructor
  · rw [sin_two_pi_mul_nat]
  · rfl

/-- The first component of C₁ lies on the unit circle for all t. -/
theorem on_unit_cylinder (t : ℝ) :
    (C₁ pf t).1 ^ 2 + (C₁ pf t).2.1 ^ 2 = 1 := by
  simp [C₁, sin_sq_add_cos_sq]
  ring_nf
  rw [sin_sq]
  ring

end C₁

/-! ## Variable-radius helix Cᵣ -/

/-- The real-part-radius helix Cᵣ : ℝ → ℝ³. -/
noncomputable def Cᵣ (pf : PhaseFunction zd) (rf : RadiusFunction zd) (t : ℝ) : ℝ × ℝ × ℝ :=
  (rf.r t * cos (pf.φ t), rf.r t * sin (pf.φ t), t)

namespace Cᵣ

variable (pf : PhaseFunction zd) (rf : RadiusFunction zd)

/-- Cᵣ is smooth (product and composition of smooth functions). -/
theorem smooth : ContDiff ℝ ⊤ (Cᵣ pf rf) := by
  apply ContDiff.prod
  · exact rf.smooth.mul (Real.contDiff_cos.comp pf.smooth)
  apply ContDiff.prod
  · exact rf.smooth.mul (Real.contDiff_sin.comp pf.smooth)
  · exact contDiff_id

/-- At the n-th zero ordinate, Cᵣ hits (βₙ, 0, γₙ). -/
theorem at_zero (n : ℕ) : Cᵣ pf rf (zd.γ n) = (zd.β n, 0, zd.γ n) := by
  simp only [Cᵣ, pf.interpolates, rf.interpolates]
  constructor
  · rw [cos_two_pi_mul_nat]; ring
  constructor
  · rw [sin_two_pi_mul_nat]; ring
  · rfl

/-- Under RH (r ≡ 1/2), Cᵣ is C₁ scaled by 1/2. -/
theorem eq_half_of_rh (hrh : zd.RH) (hconst : rf.IsConstant (1 / 2)) (t : ℝ) :
    Cᵣ pf rf t = ((1/2) * (C₁ pf t).1, (1/2) * (C₁ pf t).2.1, (C₁ pf t).2.2) := by
  simp only [Cᵣ, C₁, hconst t]

end Cᵣ

/-! ## Relationship between the two curves -/

/-- When r is constant c, Cᵣ = c • C₁ (componentwise in the xy-plane). -/
lemma Cᵣ_eq_scale_of_const (pf : PhaseFunction zd) (rf : RadiusFunction zd)
    (c : ℝ) (hconst : rf.IsConstant c) (t : ℝ) :
    Cᵣ pf rf t = (c * cos (pf.φ t), c * sin (pf.φ t), t) := by
  simp [Cᵣ, hconst t]

/-- Cᵣ with the constant-1/2 radius encodes the βₙ correctly under RH. -/
lemma Cᵣ_constHalf_at_zero (hrh : zd.RH) (pf : PhaseFunction zd) (n : ℕ) :
    Cᵣ pf (RadiusFunction.constHalf_of_rh zd hrh) (zd.γ n) = (1/2, 0, zd.γ n) := by
  have := (RadiusFunction.constHalf_of_rh zd hrh).at_zero pf n
  simp [Cᵣ.at_zero, hrh n] at *
  exact this

end RH9
