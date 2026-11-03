import Mellin

/-!
# The critical-strip regularization

The raw Mellin/annular integral converges only for `re s > 1`. This file
records the finite-part regularization

`M_reg(s) = Γ(s) ζ(s) - 1/(s - 1) + 1/(2s)`,

which subtracts exactly the two pole terms of the raw integral. On `re s > 1`
it is the convergent annular total minus the poles. The analytic continuation
is supplied by Mathlib's `riemannZeta`; the completed regularization `Λ₀` is
entire and satisfies the functional equation.
-/

open Complex

noncomputable section

namespace AngularPartition

/-- The finite-part regularization of the annular/Mellin total. The pole at
`s = 1` is subtracted, and the pole at `s = 0` is removed by adding `1/(2s)`. -/
noncomputable def regularizedMellin (s : ℂ) : ℂ :=
  Gamma s * riemannZeta s - 1 / (s - 1) + 1 / (2 * s)

/-- On the convergence domain, the finite part is the raw Mellin integral
minus its two pole terms. -/
theorem regularizedMellin_eq_mellin_sub_poles {s : ℂ} (hs : 1 < s.re) :
    regularizedMellin s =
      mellin zetaKernel s - 1 / (s - 1) + 1 / (2 * s) := by
  rw [regularizedMellin, mellin_zetaKernel_eq_Gamma_mul_zeta hs]

/-- The finite part is differentiable in the critical strip `0 < re s < 1`.
This is the precise sense in which the regularization continues the annular
total into the strip. -/
theorem regularizedMellin_differentiableAt_of_ne {s : ℂ}
    (hs0 : 0 < s.re) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ regularizedMellin s := by
  have hs_ne0 : s ≠ 0 := by
    intro h
    rw [h] at hs0
    norm_num at hs0
  -- `hs1` is the hypothesis `s ≠ 1`
  have hG : DifferentiableAt ℂ Gamma s := by
    refine differentiableAt_Gamma s ?_
    intro m hm
    have hre : s.re = -(m : ℝ) := by
      rw [hm]
      simp
    linarith
  have hZ : DifferentiableAt ℂ riemannZeta s := differentiableAt_riemannZeta hs1
  have h1' : DifferentiableAt ℂ (fun z : ℂ => (z - 1)⁻¹) s :=
    ((differentiableAt_id : DifferentiableAt ℂ (fun z : ℂ => z) s).sub_const 1).inv
      (sub_ne_zero.mpr hs1)
  have h1 : DifferentiableAt ℂ (fun z : ℂ => 1 / (z - 1)) s := by
    simpa [one_div] using h1'
  have h2' : DifferentiableAt ℂ (fun z : ℂ => (2 * z)⁻¹) s :=
    ((differentiableAt_const (2 : ℂ)).mul
      (differentiableAt_id : DifferentiableAt ℂ (fun z : ℂ => z) s)).inv
      (mul_ne_zero two_ne_zero hs_ne0)
  have h2 : DifferentiableAt ℂ (fun z : ℂ => 1 / (2 * z)) s := by
    simpa [one_div] using h2' 
  unfold regularizedMellin
  exact (hG.mul hZ).sub h1 |>.add h2

/-- The finite part is differentiable throughout the critical strip. -/
theorem regularizedMellin_differentiableAt {s : ℂ}
    (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    DifferentiableAt ℂ regularizedMellin s :=
  regularizedMellin_differentiableAt_of_ne hs0 (by
    intro h
    rw [h] at hs1
    norm_num at hs1)

/-- The completed finite part: `Λ₀(s) = Λ(s) + 1/s + 1/(1-s)`. This is the
entire regularization of the completed Mellin total. -/
theorem completedRiemannZeta_finite_part (s : ℂ) :
    completedRiemannZeta s = completedRiemannZeta₀ s - 1 / s - 1 / (1 - s) :=
  completedRiemannZeta_eq s

/-- The completed finite part satisfies the functional equation. -/
theorem completedRiemannZeta₀_functional_equation (s : ℂ) :
    completedRiemannZeta₀ (1 - s) = completedRiemannZeta₀ s :=
  completedRiemannZeta₀_one_sub s

end AngularPartition

namespace AngularPartition

/-- The pole at `s = 1` of `Γ(s) ζ(s)` has residue `1`: this is the pole term
subtracted by `regularizedMellin`, and the `h(1)` term of the explicit formula. -/
theorem regularizedMellin_residue_one :
    Filter.Tendsto (fun s : ℂ => (s - 1) * (Gamma s * riemannZeta s))
      (nhdsWithin 1 ({1} : Set ℂ)ᶜ) (nhds 1) := by
  have hζ : Filter.Tendsto (fun s : ℂ => (s - 1) * riemannZeta s)
      (nhdsWithin 1 ({1} : Set ℂ)ᶜ) (nhds 1) := riemannZeta_residue_one
  have hΓ : Filter.Tendsto Gamma (nhdsWithin 1 ({1} : Set ℂ)ᶜ) (nhds 1) := by
    have h := continuousAt_Gamma_one.tendsto.mono_left
      (nhdsWithin_le_nhds (a := (1 : ℂ)) (s := ({1} : Set ℂ)ᶜ))
    simpa using h
  have h := hζ.mul hΓ
  simpa [mul_assoc, mul_comm, mul_left_comm] using h

/-- The pole at `s = 0` of `Γ(s) ζ(s)` has residue `-1/2`: this is the pole
term removed by `+1/(2s)` in `regularizedMellin`, and the `h(0)` term of the
explicit formula. -/
theorem regularizedMellin_residue_zero :
    Filter.Tendsto (fun s : ℂ => s * (Gamma s * riemannZeta s))
      (nhdsWithin 0 ({0} : Set ℂ)ᶜ) (nhds (-(2⁻¹))) := by
  have hΓ : Filter.Tendsto (fun s : ℂ => s * Gamma s)
      (nhdsWithin 0 ({0} : Set ℂ)ᶜ) (nhds 1) := tendsto_self_mul_Gamma_nhds_zero
  have hζ : Filter.Tendsto riemannZeta (nhdsWithin 0 ({0} : Set ℂ)ᶜ) (nhds (-(2⁻¹))) := by
    have hcont : ContinuousAt riemannZeta 0 :=
      (differentiableAt_riemannZeta (by norm_num : (0 : ℂ) ≠ 1)).continuousAt
    have h := hcont.tendsto.mono_left
      (nhdsWithin_le_nhds (a := (0 : ℂ)) (s := ({0} : Set ℂ)ᶜ))
    have hlim : (-1 / 2 : ℂ) = -(2⁻¹) := by norm_num
    rw [riemannZeta_zero, hlim] at h
    exact h
  have h := hΓ.mul hζ
  simpa [mul_assoc] using h

end AngularPartition
