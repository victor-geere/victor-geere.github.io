import Mathlib

/-!
# The pole-term contour connection

This file formalises the contour-residue part of the explicit-formula
connection that is visible without knowing the zeros of zeta: the two pole
terms at `0` and `1`.  For a test function `h` holomorphic on a disk containing
both points, the contour integral of `h(z) / (z (z-1))` is the difference of
the two pole evaluations.  This is the exact Cauchy-residue mechanism that the
explicit formula applies to the logarithmic derivative of zeta; the sum over
the actual zeros is a separate, still-open arithmetic statement.
-/

namespace AngularPartition

open Complex Metric Set

/-- The two-pole kernel `1 / (z (z-1))`. -/
noncomputable def poleKernel (z : ℂ) : ℂ :=
  (z * (z - 1))⁻¹

/-- **Pole-term contour connection.**
If `h` is holomorphic on a disk containing `0` and `1`, then
`∮ h(z)/(z(z−1)) dz = 2πi (h(1) − h(0))`.
This is the residue computation behind the two pole terms of the explicit
formula. -/
theorem explicitFormula_poleContour {h : ℂ → ℂ} {c : ℂ} {R : ℝ}
    (h0 : (0 : ℂ) ∈ ball c R) (h1 : (1 : ℂ) ∈ ball c R)
    (hd : DiffContOnCl ℂ h (ball c R)) :
    (∮ z in C(c, R), poleKernel z * h z) =
      (2 * (Real.pi : ℂ) * I) * (h 1 - h 0) := by
  have hR : 0 < R := dist_nonneg.trans_lt h0
  have hsphere1 : ∀ z ∈ sphere c R, z ≠ 1 := by
    intro z hz hz1
    have hzd : dist z c = R := mem_sphere.mp hz
    have h1d : dist (1 : ℂ) c < R := h1
    rw [hz1] at hzd
    linarith
  have hsphere0 : ∀ z ∈ sphere c R, z ≠ 0 := by
    intro z hz hz0
    have hzd : dist z c = R := mem_sphere.mp hz
    have h0d : dist (0 : ℂ) c < R := h0
    rw [hz0] at hzd
    linarith
  have hcball : ContinuousOn h (closedBall c R) := by
    rw [← closure_ball c hR.ne']
    exact hd.continuousOn
  have hc1 : ContinuousOn (fun z : ℂ => (z - 1)⁻¹ * h z) (sphere c R) := by
    refine ContinuousOn.mul ?_ (hcball.mono sphere_subset_closedBall)
    exact ContinuousOn.inv₀ (by fun_prop) (fun z hz => sub_ne_zero.mpr (hsphere1 z hz))
  have hc0 : ContinuousOn (fun z : ℂ => z⁻¹ * h z) (sphere c R) := by
    refine ContinuousOn.mul ?_ (hcball.mono sphere_subset_closedBall)
    exact ContinuousOn.inv₀ continuousOn_id hsphere0
  have hint1 : CircleIntegrable (fun z : ℂ => (z - 1)⁻¹ * h z) c R :=
    hc1.circleIntegrable hR.le
  have hint0 : CircleIntegrable (fun z : ℂ => z⁻¹ * h z) c R :=
    hc0.circleIntegrable hR.le
  have hsplit : Set.EqOn (fun z : ℂ => poleKernel z * h z)
      (fun z : ℂ => (z - 1)⁻¹ * h z - z⁻¹ * h z) (sphere c R) := by
    intro z hz
    have hz1 : z ≠ 1 := hsphere1 z hz
    have hz0 : z ≠ 0 := hsphere0 z hz
    simp [poleKernel]
    field_simp [hz0, hz1]
    ring
  rw [circleIntegral.integral_congr hR.le hsplit]
  rw [circleIntegral.integral_sub hint1 hint0]
  have hC1 := hd.circleIntegral_sub_inv_smul (c := c) (R := R) (w := 1) h1
  have hC0 := hd.circleIntegral_sub_inv_smul (c := c) (R := R) (w := 0) h0
  rw [show (∮ z in C(c, R), (z - 1)⁻¹ * h z) =
      (2 * (Real.pi : ℂ) * I) * h 1 by
    simpa [smul_eq_mul] using hC1]
  rw [show (∮ z in C(c, R), z⁻¹ * h z) =
      (2 * (Real.pi : ℂ) * I) * h 0 by
    simpa [smul_eq_mul] using hC0]
  ring

/-- The contour integral is invariant under the sign convention of the pole
terms: it is the sum of the residues at `1` and `0`. -/
theorem explicitFormula_poleContour_residue_form {h : ℂ → ℂ} {c : ℂ} {R : ℝ}
    (h0 : (0 : ℂ) ∈ ball c R) (h1 : (1 : ℂ) ∈ ball c R)
    (hd : DiffContOnCl ℂ h (ball c R)) :
    (∮ z in C(c, R), poleKernel z * h z) =
      (2 * (Real.pi : ℂ) * I) * h 1 +
        (2 * (Real.pi : ℂ) * I) * (-h 0) := by
  rw [explicitFormula_poleContour h0 h1 hd]
  ring

end AngularPartition
