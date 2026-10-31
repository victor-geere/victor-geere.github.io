import Mathlib

/-!
# The archimedean contour identity, formalised

This file formalises the identity that the sign correction of notes 38–39
turns on:

`Re A_arch(ξ) = -(1/2) Ω(ξ + i/2)`,

where

`A_arch(ξ) = (1/2)(log π - ψ(-iξ/2))` and
`Ω(z) = Re ψ(1/4 + i z/2) - log π`,

and `ψ = Complex.digamma`.

The only analytic input is the Schwarz reflection of `Γ`, which Mathlib has as
`Complex.Gamma_conj`; `digamma_conj` derives the corresponding statement for
`ψ`.  The rest is the algebra of the arguments, which is where the earlier
sign and contour errors occurred.
-/

namespace AbsoluteHodgeArchimedean

open Complex

/-- Schwarz reflection for the digamma function, derived from
`Complex.Gamma_conj`. -/
theorem digamma_conj (s : ℂ) :
    Complex.digamma ((starRingEnd ℂ) s) = (starRingEnd ℂ) (Complex.digamma s) := by
  have hGamma : Complex.Gamma =
      (starRingEnd ℂ) ∘ Complex.Gamma ∘ (starRingEnd ℂ) := by
    funext z
    simp [Complex.Gamma_conj]
  have hd : deriv Complex.Gamma ((starRingEnd ℂ) s) =
      (starRingEnd ℂ) (deriv Complex.Gamma s) := by
    conv_lhs => rw [hGamma]
    rw [deriv_conj_conj]
    simp [Function.comp_def]
  simp only [Complex.digamma_def, logDeriv_apply, Complex.Gamma_conj, hd]
  rw [map_div₀]

/-- The archimedean symbol of note 23. -/
noncomputable def archSymbol (ξ : ℝ) : ℝ :=
  (1 / 2) * (Real.log Real.pi - (Complex.digamma (-(ξ : ℂ) * Complex.I / 2)).re)

/-- The Weil archimedean factor `Ω(z) = Re ψ(1/4 + i z/2) - log π`. -/
noncomputable def weilOmega (z : ℂ) : ℝ :=
  (Complex.digamma (1 / 4 + Complex.I * z / 2)).re - Real.log Real.pi

/-- **The contour identity.**  The CCM archimedean symbol on the real line is
minus one half of the Weil factor continued to `Im = 1/2`:
`Re A_arch(ξ) = -(1/2) Ω(ξ + i/2)`. -/
theorem arch_contour_identity (ξ : ℝ) :
    archSymbol ξ = -(1 / 2) * weilOmega ((ξ : ℂ) + Complex.I / 2) := by
  have harg : (1 / 4 : ℂ) + Complex.I * ((ξ : ℂ) + Complex.I / 2) / 2
      = Complex.I * (ξ : ℂ) / 2 := by
    linear_combination (1 / 4 : ℂ) * Complex.I_mul_I
  have hconj : (-(ξ : ℂ) * Complex.I / 2) =
      (starRingEnd ℂ) (Complex.I * (ξ : ℂ) / 2) := by
    have h2 : ((starRingEnd ℂ) (2 : ℂ)) = 2 := by
      apply Complex.ext <;> simp
    rw [map_div₀, map_mul, h2]
    simp [Complex.conj_I, Complex.conj_ofReal]
    ring
  unfold archSymbol weilOmega
  rw [harg, hconj, digamma_conj]
  simp [Complex.conj_re]
  ring


/-- The archimedean symbol is **even**: `A(-ξ) = A(ξ)`.  It depends on the
real part of `ψ` at conjugate points, which `digamma_conj` identifies. -/
theorem archSymbol_even (ξ : ℝ) : archSymbol (-ξ) = archSymbol ξ := by
  unfold archSymbol
  have harg : -((-ξ : ℝ) : ℂ) * Complex.I / 2
      = (starRingEnd ℂ) (-(ξ : ℂ) * Complex.I / 2) := by
    simp only [map_div₀, map_mul, map_neg, Complex.conj_ofReal,
      Complex.conj_I, map_ofNat]
    push_cast
    ring
  rw [harg, digamma_conj]
  simp


/-- The Weil archimedean factor satisfies `Ω(-z) = Ω(conj z)`. -/
theorem weilOmega_neg_conj (z : ℂ) :
    weilOmega (-z) = weilOmega ((starRingEnd ℂ) z) := by
  unfold weilOmega
  have harg : 1 / 4 + Complex.I * (-z) / 2
      = (starRingEnd ℂ) (1 / 4 + Complex.I * ((starRingEnd ℂ) z) / 2) := by
    simp only [map_add, map_div₀, map_mul, map_ofNat, map_one, Complex.conj_I]
    have hzz : (starRingEnd ℂ) ((starRingEnd ℂ) z) = z := by simp
    rw [hzz]
    ring
  rw [harg, digamma_conj]
  simp


/-- Conjugation symmetry of the symbol `A_arch(s) - ζ'/ζ(s) = -Z'/Z(s)`. -/
theorem symbol_conj {s : ℂ} (hs : s ≠ 1) :
    (1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * Complex.digamma ((starRingEnd ℂ) s / 2)
        - logDeriv riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) ((1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * Complex.digamma (s / 2) - logDeriv riemannZeta s) := by
  have hlogpi : (starRingEnd ℂ) (Complex.log (Real.pi : ℂ))
      = Complex.log (Real.pi : ℂ) := by
    rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
    simp
  have hdig : Complex.digamma ((starRingEnd ℂ) s / 2)
      = (starRingEnd ℂ) (Complex.digamma (s / 2)) := by
    rw [show (starRingEnd ℂ) s / 2 = (starRingEnd ℂ) (s / 2) by
      rw [map_div₀, show (starRingEnd ℂ) (2 : ℂ) = 2 by
        apply Complex.ext <;> simp]]
    exact digamma_conj (s / 2)
  have hζ : logDeriv riemannZeta ((starRingEnd ℂ) s)
      = (starRingEnd ℂ) (logDeriv riemannZeta s) := by
    unfold logDeriv
    change deriv riemannZeta ((starRingEnd ℂ) s) / riemannZeta ((starRingEnd ℂ) s)
        = (starRingEnd ℂ) (deriv riemannZeta s / riemannZeta s)
    have hderiv : deriv riemannZeta ((starRingEnd ℂ) s)
        = (starRingEnd ℂ) (deriv riemannZeta s) := by
      have h := (differentiableAt_riemannZeta hs).hasDerivAt.conj_conj
      have hfun : ((starRingEnd ℂ) ∘ riemannZeta ∘ (starRingEnd ℂ)) = riemannZeta := by
        funext z
        show (starRingEnd ℂ) (riemannZeta ((starRingEnd ℂ) z)) = riemannZeta z
        rw [riemannZeta_conj]
        simp
      rw [hfun] at h
      exact h.deriv
    rw [hderiv, riemannZeta_conj, map_div₀]
  rw [hdig, hζ, map_sub, map_sub, map_mul, map_mul, map_div₀, map_one, map_ofNat, hlogpi]


/-- The symbol conjugation on the critical line:
`M(1/2 - it) = conj (M(1/2 + it))`. -/
theorem symbol_conj_critical_line (t : ℝ) :
    (1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * Complex.digamma (((1 / 2 : ℂ) - Complex.I * t) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) - Complex.I * t)
      = (starRingEnd ℂ) ((1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * Complex.digamma (((1 / 2 : ℂ) + Complex.I * t) / 2)
        - logDeriv riemannZeta ((1 / 2 : ℂ) + Complex.I * t)) := by
  have hs : ((1 / 2 : ℂ) + Complex.I * (t : ℂ)) ≠ 1 := by
    intro h
    have := congrArg Complex.re h
    norm_num at this
  have h := symbol_conj (s := ((1 / 2 : ℂ) + Complex.I * (t : ℂ))) hs
  have hconj : (starRingEnd ℂ) ((1 / 2 : ℂ) + Complex.I * (t : ℂ))
      = (1 / 2 : ℂ) - Complex.I * (t : ℂ) := by
    apply Complex.ext <;> simp
  rw [hconj] at h
  exact h


/-- `Γ` is analytic at every point of the open right half-plane. -/
theorem analyticAt_Gamma_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    AnalyticAt ℂ Complex.Gamma s := by
  rw [Complex.analyticAt_iff_eventually_differentiableAt]
  filter_upwards [Metric.ball_mem_nhds s (half_pos hs)] with z hz
  apply Complex.differentiableAt_Gamma z
  intro m h
  have hzre : z.re = -(m : ℝ) := by rw [h]; simp
  have hzrepos : 0 < z.re := by
    have hdist : dist z s < s.re / 2 := by simpa [Metric.mem_ball] using hz
    have h1 : |z.re - s.re| ≤ dist z s := by
      calc |z.re - s.re| = ‖(z - s).re‖ := by simp
        _ ≤ ‖z - s‖ := Complex.abs_re_le_norm _
        _ = dist z s := (dist_eq_norm ..).symm
    have h2 : z.re - s.re ≥ -|z.re - s.re| := neg_abs_le _
    linarith
  rw [hzre] at hzrepos
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  linarith

/-- **The digamma function is differentiable on the open right half-plane.** -/
theorem differentiableAt_digamma_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ Complex.digamma s := by
  have hGA : AnalyticAt ℂ Complex.Gamma s := analyticAt_Gamma_of_re_pos hs
  have hGne : Complex.Gamma s ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m h
    have hre : s.re = -(m : ℝ) := by rw [h]; simp
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have hGdiff : DifferentiableAt ℂ Complex.Gamma s := hGA.differentiableAt
  have hderiv : DifferentiableAt ℂ (deriv Complex.Gamma) s := hGA.deriv.differentiableAt
  rw [Complex.digamma_def]
  have hev : logDeriv Complex.Gamma =ᶠ[nhds s] fun z => deriv Complex.Gamma z / Complex.Gamma z := by
    filter_upwards [hGdiff.continuousAt.eventually_ne hGne] with z hz
    rw [logDeriv_apply]
  exact (hderiv.div hGdiff hGne).congr_of_eventuallyEq hev.symm

/-- **The digamma function is continuous on the open right half-plane.** -/
theorem continuousAt_digamma_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    ContinuousAt Complex.digamma s :=
  (differentiableAt_digamma_of_re_pos hs).continuousAt


/-- **Digamma sum at conjugate points on the critical line**:
`ψ(1/4+it/2) + ψ(1/4−it/2) = 2·Re ψ(1/4+it/2)`. -/
theorem digamma_add_conj_critical (t : ℝ) :
    Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
      + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)
      = ((2 * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)).re : ℝ) : ℂ) := by
  have hconj : ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)
      = (starRingEnd ℂ) ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2) := by
    apply Complex.ext <;> simp [map_ofNat] <;> ring
  rw [hconj, digamma_conj]
  exact Complex.add_conj _

/-- **The archimedean term on the critical line is real**:
`(1/2)log π − (1/2)(ψ(1/4+it/2)+ψ(1/4−it/2))` is a real number. -/
theorem archimedeanTerm_critical_line_real (t : ℝ) :
    ∃ x : ℝ, (1 / 2) * Complex.log (Real.pi : ℂ)
        - (1 / 2) * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)
          + Complex.digamma ((1 / 4 : ℂ) - Complex.I * (t : ℂ) / 2)) = (x : ℂ) := by
  refine ⟨(1 / 2) * Real.log Real.pi
      - (1 / 2) * (2 * (Complex.digamma ((1 / 4 : ℂ) + Complex.I * (t : ℂ) / 2)).re), ?_⟩
  rw [digamma_add_conj_critical]
  have hlog : Complex.log (Real.pi : ℂ) = (Real.log Real.pi : ℂ) :=
    (Complex.ofReal_log Real.pi_pos.le).symm
  rw [hlog]
  push_cast
  ring

end AbsoluteHodgeArchimedean




