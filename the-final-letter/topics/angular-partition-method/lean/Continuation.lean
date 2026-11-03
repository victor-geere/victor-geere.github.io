import RegularizedIntegral

/-!
# O7: continuation beyond the critical strip

The critical-strip regularization (`CriticalStrip.lean`,
`RegularizedIntegral.lean`) sets up the finite-part Mellin integral for
`0 < re s < 1`. This file extends the same annular/Mellin method beyond the
strip.

* **First-order near-zero bound.** The once-subtracted kernel
  `h(t) = 1/(e^t − 1) − 1/t + 1/2` satisfies `0 ≤ h(t) ≤ t/12` for `t > 0`.
  The constant `1/12 = B₂/2` is the first surviving term of the Laurent
  expansion of the kernel, so the bound is sharp at `0`. Hence the Mellin
  integral converges and is holomorphic on the doubled strip `−1 < re s`, one
  full strip to the left of the critical strip
  (`mellinConvergent_regularizedKernel_of_neg_one_lt`,
  `differentiableAt_mellin_regularizedKernel_of_neg_one_lt`).

* **Extended identity.** The identification
  `mellin regularizedKernel s = regularizedMellin s` propagates to the whole
  domain `−1 < re s`, `s ∉ {0, 1}`
  (`mellin_regularizedKernel_eq_of_neg_one_lt_re`).

* **The functional equation as an integral identity.** The completed finite
  part `completedMellinPart`, built purely from the annular integral and
  elementary pole terms, equals the entire function `completedRiemannZeta₀` on
  its convergence strip and is therefore symmetric under `s ↦ 1 − s`
  (`completedMellinPart_eq_completedRiemannZeta₀`,
  `completedMellinPart_one_sub`).

* **Second subtraction.** Removing the full principal part `1/t − 1/2 + t/12`
  leaves `|h₂(t)| ≤ t³/720`, so the twice-subtracted kernel is
  Mellin-convergent and holomorphic on `−3 < re s`, with the pole term
  `−1/(12(s+1))` made explicit (`mellinConvergent_regularizedKernel₂`,
  `differentiableAt_mellin_regularizedKernel₂`,
  `mellin_regularizedKernel₂_eq_of_one_lt_re`). The scheme extends stepwise;
  step 2 is Lean-checked here.
-/

open Real Set MeasureTheory Filter
open Complex

noncomputable section

namespace AngularPartition

/-! ## The first-order near-zero bound -/

/-- The real form of the once-subtracted kernel. -/
noncomputable def regularizedReal (t : ℝ) : ℝ := 1 / (Real.exp t - 1) - 1 / t + 1 / 2

/-- One round of the derivative cascade: a function with a nonnegative
derivative on `[0, ∞)` that vanishes at `0` is nonnegative on `[0, ∞)`. -/
private theorem nonneg_of_cascade {g g' : ℝ → ℝ} (hg : ∀ t, HasDerivAt g (g' t) t)
    (hg0 : g 0 = 0) (hg' : ∀ t, 0 ≤ t → 0 ≤ g' t) {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ g t := by
  have hdiff : Differentiable ℝ g := fun x => (hg x).differentiableAt
  have hmono : MonotoneOn g (Ici (0 : ℝ)) := by
    apply monotoneOn_of_deriv_nonneg (convex_Ici 0)
    · exact hdiff.continuous.continuousOn
    · intro x _
      exact (hg x).differentiableAt.differentiableWithinAt
    · intro x hx
      rw [interior_Ici] at hx
      rw [(hg x).deriv]
      exact hg' x hx.le
  have h := hmono (mem_Ici.mpr le_rfl) (mem_Ici.mpr ht) ht
  rwa [hg0] at h

private theorem hasDerivAt_G0 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 2 * t + (t - 2) * (Real.exp t - 1))
      (1 + (t - 1) * Real.exp t) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h2t : HasDerivAt (fun t : ℝ => 2 * t) 2 t := by
    simpa using hid.const_mul 2
  have htm2 : HasDerivAt (fun t : ℝ => t - 2) 1 t := hid.sub_const 2
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod := htm2.mul hexpm1
  have h := h2t.add hprod
  rw [show 2 + (1 * (Real.exp t - 1) + (t - 2) * Real.exp t) =
      1 + (t - 1) * Real.exp t by ring] at h
  exact h

private theorem hasDerivAt_G1 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 1 + (t - 1) * Real.exp t) (t * Real.exp t) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have htm1 : HasDerivAt (fun t : ℝ => t - 1) 1 t := hid.sub_const 1
  have hprod := htm1.mul (Real.hasDerivAt_exp t)
  have h := (hasDerivAt_const t (1 : ℝ)).add hprod
  rw [show 0 + (1 * Real.exp t + (t - 1) * Real.exp t) = t * Real.exp t by ring] at h
  exact h

/-- The numerator of the once-subtracted kernel is nonnegative:
`2t + (t − 2)(e^t − 1) ≥ 0` for `t ≥ 0`. -/
private theorem phi_nonneg {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ 2 * t + (t - 2) * (Real.exp t - 1) := by
  apply nonneg_of_cascade hasDerivAt_G0 (by simp) _ ht
  intro x hx
  apply nonneg_of_cascade hasDerivAt_G1 (by simp) _ hx
  intro y hy
  exact mul_nonneg hy (Real.exp_pos y).le

private theorem hasDerivAt_psi0 (t : ℝ) :
    HasDerivAt (fun t : ℝ => (t ^ 2 - 6 * t + 12) * (Real.exp t - 1) - 12 * t)
      ((2 * t - 6) * (Real.exp t - 1) + (t ^ 2 - 6 * t + 12) * Real.exp t - 12) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have hp2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h6t : HasDerivAt (fun t : ℝ => 6 * t) 6 t := by
    simpa using hid.const_mul 6
  have hpoly : HasDerivAt (fun t : ℝ => t ^ 2 - 6 * t + 12) (2 * t - 6) t := by
    have h := (hp2.sub h6t).add (hasDerivAt_const t (12 : ℝ))
    rw [show (2 * t - 6) + 0 = 2 * t - 6 by ring] at h
    exact h
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod := hpoly.mul hexpm1
  have h12t : HasDerivAt (fun t : ℝ => 12 * t) 12 t := by
    simpa using hid.const_mul 12
  exact hprod.sub h12t

private theorem hasDerivAt_psi1 (t : ℝ) :
    HasDerivAt (fun t : ℝ => (2 * t - 6) * (Real.exp t - 1) +
        (t ^ 2 - 6 * t + 12) * Real.exp t - 12)
      ((t ^ 2 - 2 * t + 2) * Real.exp t - 2) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have hlin : HasDerivAt (fun t : ℝ => 2 * t - 6) 2 t := by
    have h2t : HasDerivAt (fun t : ℝ => 2 * t) 2 t := by
      simpa using hid.const_mul 2
    simpa using h2t.sub_const 6
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod1 := hlin.mul hexpm1
  have hp2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h6t : HasDerivAt (fun t : ℝ => 6 * t) 6 t := by
    simpa using hid.const_mul 6
  have hpoly : HasDerivAt (fun t : ℝ => t ^ 2 - 6 * t + 12) (2 * t - 6) t := by
    have h := (hp2.sub h6t).add (hasDerivAt_const t (12 : ℝ))
    rw [show (2 * t - 6) + 0 = 2 * t - 6 by ring] at h
    exact h
  have hprod2 := hpoly.mul (Real.hasDerivAt_exp t)
  have h := (hprod1.add hprod2).sub (hasDerivAt_const t (12 : ℝ))
  rw [show (2 * (Real.exp t - 1) + (2 * t - 6) * Real.exp t) +
      ((2 * t - 6) * Real.exp t + (t ^ 2 - 6 * t + 12) * Real.exp t) - 0 =
      (t ^ 2 - 2 * t + 2) * Real.exp t - 2 by ring] at h
  exact h

private theorem hasDerivAt_psi2 (t : ℝ) :
    HasDerivAt (fun t : ℝ => (t ^ 2 - 2 * t + 2) * Real.exp t - 2)
      (t ^ 2 * Real.exp t) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have hp2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h2t : HasDerivAt (fun t : ℝ => 2 * t) 2 t := by
    simpa using hid.const_mul 2
  have hpoly : HasDerivAt (fun t : ℝ => t ^ 2 - 2 * t + 2) (2 * t - 2) t := by
    have h := (hp2.sub h2t).add (hasDerivAt_const t (2 : ℝ))
    rw [show (2 * t - 2) + 0 = 2 * t - 2 by ring] at h
    exact h
  have hprod := hpoly.mul (Real.hasDerivAt_exp t)
  have h := hprod.sub (hasDerivAt_const t (2 : ℝ))
  rw [show (2 * t - 2) * Real.exp t + (t ^ 2 - 2 * t + 2) * Real.exp t - 0 =
      t ^ 2 * Real.exp t by ring] at h
  exact h

/-- The key polynomial bound: `(t² − 6t + 12)(e^t − 1) ≥ 12t` for `t ≥ 0`.
This is what bounds the once-subtracted kernel by `t/12`. -/
private theorem psi_nonneg {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ (t ^ 2 - 6 * t + 12) * (Real.exp t - 1) - 12 * t := by
  apply nonneg_of_cascade hasDerivAt_psi0 (by simp) _ ht
  intro x hx
  apply nonneg_of_cascade hasDerivAt_psi1 (by simp) _ hx
  intro y hy
  apply nonneg_of_cascade hasDerivAt_psi2 (by simp) _ hy
  intro z hz
  exact mul_nonneg (sq_nonneg z) (Real.exp_pos z).le

/-- The once-subtracted kernel as a single fraction. -/
private theorem regularizedReal_eq_div {t : ℝ} (ht : 0 < t) :
    regularizedReal t =
      (2 * t + (t - 2) * (Real.exp t - 1)) / (2 * t * (Real.exp t - 1)) := by
  have hexp : Real.exp t - 1 ≠ 0 := by
    have h : 0 < Real.exp t - 1 := by linarith [Real.add_one_le_exp t]
    exact ne_of_gt h
  rw [regularizedReal]
  field_simp [ne_of_gt ht, hexp]
  ring

/-- The once-subtracted kernel is nonnegative for `t > 0`. -/
theorem regularizedReal_nonneg {t : ℝ} (ht : 0 < t) : 0 ≤ regularizedReal t := by
  have hexp : 0 < Real.exp t - 1 := by linarith [Real.add_one_le_exp t]
  have hden : (0 : ℝ) < 2 * t * (Real.exp t - 1) := by positivity
  rw [regularizedReal_eq_div ht]
  exact div_nonneg (phi_nonneg ht.le) hden.le

/-- **First-order bound (sharp).** The once-subtracted kernel is at most
`t/12` for `t > 0`; `1/12 = B₂/2` is the next Laurent coefficient. -/
theorem regularizedReal_le_div_twelve {t : ℝ} (ht : 0 < t) :
    regularizedReal t ≤ t / 12 := by
  have hexp : 0 < Real.exp t - 1 := by linarith [Real.add_one_le_exp t]
  have hden : (0 : ℝ) < 2 * t * (Real.exp t - 1) := by positivity
  have hpsi : 0 ≤ (t ^ 2 - 6 * t + 12) * (Real.exp t - 1) - 12 * t := psi_nonneg ht.le
  rw [regularizedReal_eq_div ht, div_le_iff₀ hden]
  have key : t / 12 * (2 * t * (Real.exp t - 1)) =
      (2 * t + (t - 2) * (Real.exp t - 1)) +
        ((t ^ 2 - 6 * t + 12) * (Real.exp t - 1) - 12 * t) / 6 := by ring
  rw [key]
  linarith [hpsi]

/-- The complex once-subtracted kernel is bounded by `t/12` near zero. -/
theorem norm_regularizedKernel_le_div_twelve {t : ℝ} (ht0 : 0 < t) (ht1 : t < 1) :
    ‖regularizedKernel t‖ ≤ t / 12 := by
  have h0 : 0 ≤ regularizedReal t := regularizedReal_nonneg ht0
  have h12 : regularizedReal t ≤ t / 12 := regularizedReal_le_div_twelve ht0
  have hcast : regularizedKernel t = ((regularizedReal t : ℝ) : ℂ) := by
    rw [regularizedKernel, if_pos ht1, regularizedReal, zetaKernel]
    push_cast
    ring
  rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg h0]
  exact h12

/-- The once-subtracted kernel is `O(t)` near zero. -/
theorem regularizedKernel_isBigO_rpow_one :
    regularizedKernel =O[nhdsWithin (0 : ℝ) (Ioi 0)] (fun t : ℝ => t ^ (1 : ℝ)) := by
  refine Asymptotics.IsBigO.of_bound (1 / 12 : ℝ) ?_
  rw [eventually_nhdsWithin_iff]
  filter_upwards [Iio_mem_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht hpos
  have hnorm : ‖regularizedKernel t‖ ≤ t / 12 := norm_regularizedKernel_le_div_twelve hpos ht
  have ht1 : ‖(t : ℝ) ^ (1 : ℝ)‖ = t := by
    rw [Real.rpow_one, Real.norm_eq_abs, abs_of_pos hpos]
  rw [ht1]
  linarith [hnorm]

/-- **Convergence beyond the strip (left).** The once-subtracted annular
integral converges on the doubled strip `−1 < re s`. -/
theorem mellinConvergent_regularizedKernel_of_neg_one_lt {s : ℂ} (hs : -1 < s.re) :
    MellinConvergent regularizedKernel s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := -1) one_pos
    locallyIntegrableOn_regularizedKernel regularizedKernel_isBigO_exp ?_ ?_
  · simpa using regularizedKernel_isBigO_rpow_one
  · simpa using hs

/-- The annular integral is holomorphic on the doubled strip `−1 < re s`. -/
theorem differentiableAt_mellin_regularizedKernel_of_neg_one_lt {s : ℂ}
    (hs : -1 < s.re) :
    DifferentiableAt ℂ (mellin regularizedKernel) s := by
  refine mellin_differentiableAt_of_isBigO_rpow_exp (a := 1) (b := -1) one_pos
    locallyIntegrableOn_regularizedKernel regularizedKernel_isBigO_exp ?_ ?_
  · simpa using regularizedKernel_isBigO_rpow_one
  · simpa using hs

end AngularPartition

namespace AngularPartition

/-! ## The identity on the doubled strip -/

/-- The finite part is differentiable on the doubled strip away from the two
pole points `0` and `1`. -/
theorem regularizedMellin_differentiableAt_of_neg_one_lt {s : ℂ}
    (hs : -1 < s.re) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ regularizedMellin s := by
  have hG : DifferentiableAt ℂ Complex.Gamma s := by
    refine Complex.differentiableAt_Gamma s ?_
    intro m hm
    rcases eq_or_ne m 0 with rfl | hm0
    · simp only [Nat.cast_zero, neg_zero] at hm
      exact hs0 hm
    · have hm1 : 1 ≤ m := Nat.one_le_iff_ne_zero.mpr hm0
      have hre : s.re = -(m : ℝ) := by
        rw [hm]
        simp
      have hle : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm1
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
      (mul_ne_zero two_ne_zero hs0)
  have h2 : DifferentiableAt ℂ (fun z : ℂ => 1 / (2 * z)) s := by
    simpa [one_div] using h2'
  unfold regularizedMellin
  exact (hG.mul hZ).sub h1 |>.add h2

/-- The identity holds on the upper half of the doubled strip. -/
theorem mellin_regularizedKernel_eqOn_upper_ext :
    EqOn (mellin regularizedKernel) regularizedMellin
      {s : ℂ | -1 < s.re ∧ 0 < s.im} := by
  let U : Set ℂ := {s : ℂ | -1 < s.re ∧ 0 < s.im}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := -1)).inter (convex_halfSpace_im_gt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | -1 < s.re} ∩ {s : ℂ | 0 < s.im})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_const continuous_im)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel) U :=
    fun z hz =>
      (differentiableAt_mellin_regularizedKernel_of_neg_one_lt hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin U :=
    fun z hz => (regularizedMellin_differentiableAt_of_neg_one_lt hz.1 (by
      intro h
      have hz2 : 0 < (0 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : 0 < (1 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel) regularizedMellin U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) + Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) + Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) + Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel_eq_of_one_lt_re hz

end AngularPartition

namespace AngularPartition

/-- The identity holds on the lower half of the doubled strip. -/
theorem mellin_regularizedKernel_eqOn_lower_ext :
    EqOn (mellin regularizedKernel) regularizedMellin
      {s : ℂ | -1 < s.re ∧ s.im < 0} := by
  let U : Set ℂ := {s : ℂ | -1 < s.re ∧ s.im < 0}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := -1)).inter (convex_halfSpace_im_lt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | -1 < s.re} ∩ {s : ℂ | s.im < 0})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_im continuous_const)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel) U :=
    fun z hz =>
      (differentiableAt_mellin_regularizedKernel_of_neg_one_lt hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin U :=
    fun z hz => (regularizedMellin_differentiableAt_of_neg_one_lt hz.1 (by
      intro h
      have hz2 : (0 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : (1 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel) regularizedMellin U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) - Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) - Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) - Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel_eq_of_one_lt_re hz

/-- The identity holds on the doubled strip away from the real axis. -/
theorem mellin_regularizedKernel_eq_of_neg_one_lt_of_im_ne {s : ℂ}
    (hs : -1 < s.re) (him : s.im ≠ 0) :
    mellin regularizedKernel s = regularizedMellin s := by
  rcases lt_or_gt_of_ne (Ne.symm him) with h | h
  · exact mellin_regularizedKernel_eqOn_upper_ext ⟨hs, h⟩
  · exact mellin_regularizedKernel_eqOn_lower_ext ⟨hs, h⟩

end AngularPartition

namespace AngularPartition

/-- The identity extends to the real axis of the doubled strip by continuity
in the imaginary direction. -/
theorem mellin_regularizedKernel_eq_of_neg_one_lt_of_im_eq {s : ℂ}
    (hs : -1 < s.re) (hs0 : s ≠ 0) (hs1 : s ≠ 1) (him : s.im = 0) :
    mellin regularizedKernel s = regularizedMellin s := by
  have hs_eq : s = (s.re : ℂ) := by
    apply Complex.ext <;> simp [him]
  let z : ℝ → ℂ := fun y => (s.re : ℂ) + (y : ℂ) * Complex.I
  have hz_re : ∀ y, (z y).re = s.re := by
    intro y
    simp [z, Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im]
  have hz_im : ∀ y, y ≠ 0 → (z y).im = y := by
    intro y hy
    simp [z, Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_im, Complex.I_re]
  have hz_tend : Tendsto z (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds s) := by
    rw [hs_eq]
    have hy : Tendsto (fun y : ℝ => (y : ℂ)) (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds 0) := by
      simpa using (continuous_ofReal.tendsto 0).mono_left nhdsWithin_le_nhds
    simpa [z] using tendsto_const_nhds.add (hy.mul tendsto_const_nhds)
  have hcont : ContinuousAt (mellin regularizedKernel) s :=
    (differentiableAt_mellin_regularizedKernel_of_neg_one_lt hs).continuousAt
  have hcontG : ContinuousAt regularizedMellin s :=
    (regularizedMellin_differentiableAt_of_neg_one_lt hs hs0 hs1).continuousAt
  have hlim1 : Tendsto (fun y => mellin regularizedKernel (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (mellin regularizedKernel s)) :=
    hcont.tendsto.comp hz_tend
  have hlim2 : Tendsto (fun y => regularizedMellin (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin s)) :=
    hcontG.tendsto.comp hz_tend
  have hlim2' : Tendsto (fun y => mellin regularizedKernel (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin s)) := by
    refine hlim2.congr' ?_
    filter_upwards [self_mem_nhdsWithin] with y hy
    exact (mellin_regularizedKernel_eq_of_neg_one_lt_of_im_ne (s := z y)
      (by rw [hz_re y]; exact hs) (by rw [hz_im y hy]; exact hy)).symm
  exact tendsto_nhds_unique hlim1 hlim2'

/-- **Extended integral identity.** On the whole doubled strip, away from the
two pole points, the annular Mellin integral equals the finite part. -/
theorem mellin_regularizedKernel_eq_of_neg_one_lt_re {s : ℂ}
    (hs : -1 < s.re) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    mellin regularizedKernel s = regularizedMellin s := by
  by_cases him : s.im = 0
  · exact mellin_regularizedKernel_eq_of_neg_one_lt_of_im_eq hs hs0 hs1 him
  · exact mellin_regularizedKernel_eq_of_neg_one_lt_of_im_ne hs him

end AngularPartition

namespace AngularPartition

/-! ## The completed functional equation as an integral identity -/

/-- The completed finite part of the annular total: the entire function `Λ₀`
written in terms of the annular Mellin integral and elementary pole terms. -/
noncomputable def completedMellinPart (s : ℂ) : ℂ :=
  (Gammaℝ s / Complex.Gamma s) * (mellin regularizedKernel s + 1 / (s - 1) - 1 / (2 * s))
    + 1 / s + 1 / (1 - s)

/-- On the doubled strip the completed annular integral is the entire function
`completedRiemannZeta₀`. -/
theorem completedMellinPart_eq_completedRiemannZeta₀ {s : ℂ}
    (hs : -1 < s.re) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    completedMellinPart s = completedRiemannZeta₀ s := by
  have hG : Complex.Gamma s ≠ 0 := by
    rw [Ne, Complex.Gamma_eq_zero_iff]
    rintro ⟨m, hm⟩
    rcases eq_or_ne m 0 with rfl | hm0
    · simp only [Nat.cast_zero, neg_zero] at hm
      exact hs0 hm
    · have hm1 : 1 ≤ m := Nat.one_le_iff_ne_zero.mpr hm0
      have hre : s.re = -(m : ℝ) := by
        rw [hm]
        simp
      have hle : (1 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm1
      linarith
  have hGℝ : Gammaℝ s ≠ 0 := by
    rw [Ne, Complex.Gammaℝ_eq_zero_iff]
    rintro ⟨n, hn⟩
    rcases eq_or_ne n 0 with rfl | hn0
    · simp at hn
      exact hs0 hn
    · have hn1 : 1 ≤ n := Nat.one_le_iff_ne_zero.mpr hn0
      have hre : s.re = -(2 * (n : ℝ)) := by
        rw [hn]
        simp
      have hle : (2 : ℝ) ≤ 2 * (n : ℝ) := by
        have h1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn1
        linarith
      linarith
  rw [completedMellinPart, mellin_regularizedKernel_eq_of_neg_one_lt_re hs hs0 hs1]
  have hsub : Complex.Gamma s * riemannZeta s - 1 / (s - 1) + 1 / (2 * s) + 1 / (s - 1) - 1 / (2 * s)
      = Complex.Gamma s * riemannZeta s := by ring
  rw [regularizedMellin, hsub, riemannZeta_def_of_ne_zero hs0]
  have hcore : (Gammaℝ s / Complex.Gamma s) * (Complex.Gamma s * (completedRiemannZeta s / Gammaℝ s))
      = completedRiemannZeta s := by
    field_simp [hG, hGℝ]
  rw [hcore, completedRiemannZeta_eq]
  ring

/-- **The functional equation as an integral identity.** On the critical strip
the completed annular integral is symmetric under `s ↦ 1 − s`. -/
theorem completedMellinPart_one_sub {s : ℂ} (hs0 : 0 < s.re) (hs1 : s.re < 1) :
    completedMellinPart (1 - s) = completedMellinPart s := by
  have hs' : -1 < (1 - s).re := by
    rw [Complex.sub_re, Complex.one_re]
    linarith
  have h0' : (1 - s) ≠ 0 := by
    intro h
    have hre : (1 - s).re = 0 := by rw [h]; simp
    simp [Complex.sub_re, Complex.one_re] at hre
    linarith
  have h1' : (1 - s) ≠ 1 := by
    intro h
    have hre : (1 - s).re = 1 := by rw [h]; simp
    simp [Complex.sub_re, Complex.one_re] at hre
    linarith
  have hs0' : s ≠ 0 := by
    intro h
    rw [h] at hs0
    norm_num at hs0
  have hs1' : s ≠ 1 := by
    intro h
    rw [h] at hs1
    norm_num at hs1
  rw [completedMellinPart_eq_completedRiemannZeta₀ hs' h0' h1',
    completedMellinPart_eq_completedRiemannZeta₀ (by linarith) hs0' hs1']
  exact completedRiemannZeta₀_one_sub s

end AngularPartition

namespace AngularPartition

/-! ## The second subtraction: convergence on `−3 < re s` -/

/-- The linear cutoff `−t/12` below `1`, zero above. -/
def linCutoff (t : ℝ) : ℂ := if t < 1 then (-((t : ℂ)) / 12 : ℂ) else 0

/-- The Mellin transform of the linear cutoff is `−1/(12(s+1))`, valid on
`−1 < re s`: the second subtraction exposes the pole at `s = −1`. -/
theorem hasMellin_linCutoff {s : ℂ} (hs : -1 < s.re) :
    HasMellin linCutoff s (-(1 : ℂ) / 12 * (1 / (s + 1))) := by
  obtain ⟨hconv, hval⟩ := hasMellin_cpow_Ioc (1 : ℂ) (s := s) (by
    rw [Complex.one_re]
    linarith)
  have hind : (Set.indicator (Ioo (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ))) =ᵐ[volume]
      Set.indicator (Ioc (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ)) :=
    indicator_ae_eq_of_ae_eq_set MeasureTheory.Ioo_ae_eq_Ioc
  have hae : (fun t : ℝ => (t : ℂ) ^ (s - 1) • linCutoff t) =ᵐ[volume.restrict (Ioi 0)]
      (fun t : ℝ => (-(1 : ℂ) / 12) * ((t : ℂ) ^ (s - 1) •
        Set.indicator (Ioc (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ)) t)) := by
    filter_upwards [ae_restrict_mem measurableSet_Ioi, ae_restrict_of_ae hind] with t ht htI
    by_cases ht1 : t < 1
    · have hmem : t ∈ Ioo (0 : ℝ) 1 := ⟨ht, ht1⟩
      have hindIoo : Set.indicator (Ioo (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ)) t =
          (t : ℂ) := by
        rw [Set.indicator_of_mem hmem, Complex.cpow_one]
      rw [htI] at hindIoo
      rw [linCutoff, if_pos ht1, hindIoo, smul_eq_mul, smul_eq_mul]
      ring
    · have hnmem : t ∉ Ioo (0 : ℝ) 1 := fun h => ht1 h.2
      have hind0 : Set.indicator (Ioc (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ)) t = 0 := by
        rw [← htI, Set.indicator_of_notMem hnmem]
      rw [linCutoff, if_neg ht1, hind0, smul_zero, mul_zero]
  refine ⟨?_, ?_⟩
  · have hci : IntegrableOn (fun t : ℝ => (-(1 : ℂ) / 12) * ((t : ℂ) ^ (s - 1) •
        Set.indicator (Ioc (0 : ℝ) 1) (fun t : ℝ => (t : ℂ) ^ (1 : ℂ)) t)) (Ioi (0 : ℝ)) volume :=
      Integrable.const_mul hconv (-(1 : ℂ) / 12)
    exact IntegrableOn.congr_fun_ae hci hae.symm
  · rw [mellin, integral_congr_ae hae, integral_const_mul, ← mellin, hval]

/-- The twice-subtracted kernel: below `1` the full principal part
`1/t − 1/2 + t/12` of the zeta kernel is removed. -/
def regularizedKernel₂ (t : ℝ) : ℂ :=
  if t < 1 then (zetaKernel t - (1 : ℂ) / (t : ℂ) + 1 / 2 - (t : ℂ) / 12 : ℂ) else zetaKernel t

/-- The twice-subtracted kernel splits as the once-subtracted kernel plus the
linear cutoff. -/
theorem regularizedKernel₂_eq_regularizedKernel_add (t : ℝ) :
    regularizedKernel₂ t = regularizedKernel t + linCutoff t := by
  by_cases h : t < 1
  · simp [regularizedKernel₂, regularizedKernel, linCutoff, h]
    ring
  · simp [regularizedKernel₂, regularizedKernel, linCutoff, h]

private theorem hasDerivAt_polyP (t : ℝ) :
    HasDerivAt (fun t : ℝ => 2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440)
      (8 * t ^ 3 - 240 * t + 720) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h4 : HasDerivAt (fun t : ℝ => t ^ 4) (4 * t ^ 3) t := by
    simpa using hasDerivAt_pow 4 t
  have h2t4 : HasDerivAt (fun t : ℝ => 2 * t ^ 4) (2 * (4 * t ^ 3)) t := h4.const_mul 2
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h120 : HasDerivAt (fun t : ℝ => 120 * t ^ 2) (120 * (2 * t)) t := h2.const_mul 120
  have h720 : HasDerivAt (fun t : ℝ => 720 * t) 720 t := by
    simpa using hid.const_mul 720
  have h := ((h2t4.sub h120).add h720).sub (hasDerivAt_const t (1440 : ℝ))
  rw [show (2 * (4 * t ^ 3) - 120 * (2 * t)) + 720 - 0 = 8 * t ^ 3 - 240 * t + 720 by ring] at h
  exact h

private theorem hasDerivAt_polyP1 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 8 * t ^ 3 - 240 * t + 720) (24 * t ^ 2 - 240) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h3 : HasDerivAt (fun t : ℝ => t ^ 3) (3 * t ^ 2) t := by
    simpa using hasDerivAt_pow 3 t
  have h8 : HasDerivAt (fun t : ℝ => 8 * t ^ 3) (8 * (3 * t ^ 2)) t := h3.const_mul 8
  have h240 : HasDerivAt (fun t : ℝ => 240 * t) 240 t := by
    simpa using hid.const_mul 240
  have h := (h8.sub h240).add (hasDerivAt_const t (720 : ℝ))
  rw [show (8 * (3 * t ^ 2) - 240) + 0 = 24 * t ^ 2 - 240 by ring] at h
  exact h

private theorem hasDerivAt_polyP2 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 24 * t ^ 2 - 240) (48 * t) t := by
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h24 : HasDerivAt (fun t : ℝ => 24 * t ^ 2) (24 * (2 * t)) t := h2.const_mul 24
  have h := h24.sub (hasDerivAt_const t (240 : ℝ))
  rw [show 24 * (2 * t) - 0 = 48 * t by ring] at h
  exact h

private theorem hasDerivAt_polyR2 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 2 * t ^ 4 + 16 * t ^ 3 - 120 * t ^ 2 + 240 * t)
      (8 * t ^ 3 + 48 * t ^ 2 - 240 * t + 240) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h4 : HasDerivAt (fun t : ℝ => t ^ 4) (4 * t ^ 3) t := by
    simpa using hasDerivAt_pow 4 t
  have h2t4 : HasDerivAt (fun t : ℝ => 2 * t ^ 4) (2 * (4 * t ^ 3)) t := h4.const_mul 2
  have h3 : HasDerivAt (fun t : ℝ => t ^ 3) (3 * t ^ 2) t := by
    simpa using hasDerivAt_pow 3 t
  have h16 : HasDerivAt (fun t : ℝ => 16 * t ^ 3) (16 * (3 * t ^ 2)) t := h3.const_mul 16
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h120 : HasDerivAt (fun t : ℝ => 120 * t ^ 2) (120 * (2 * t)) t := h2.const_mul 120
  have h240 : HasDerivAt (fun t : ℝ => 240 * t) 240 t := by
    simpa using hid.const_mul 240
  have h := ((h2t4.add h16).sub h120).add h240
  rw [show (2 * (4 * t ^ 3) + 16 * (3 * t ^ 2)) - 120 * (2 * t) + 240 =
      8 * t ^ 3 + 48 * t ^ 2 - 240 * t + 240 by ring] at h
  exact h

private theorem hasDerivAt_polyR3 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 2 * t ^ 4 + 24 * t ^ 3 - 48 * t ^ 2)
      (8 * t ^ 3 + 72 * t ^ 2 - 96 * t) t := by
  have h4 : HasDerivAt (fun t : ℝ => t ^ 4) (4 * t ^ 3) t := by
    simpa using hasDerivAt_pow 4 t
  have h2t4 : HasDerivAt (fun t : ℝ => 2 * t ^ 4) (2 * (4 * t ^ 3)) t := h4.const_mul 2
  have h3 : HasDerivAt (fun t : ℝ => t ^ 3) (3 * t ^ 2) t := by
    simpa using hasDerivAt_pow 3 t
  have h24 : HasDerivAt (fun t : ℝ => 24 * t ^ 3) (24 * (3 * t ^ 2)) t := h3.const_mul 24
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h48 : HasDerivAt (fun t : ℝ => 48 * t ^ 2) (48 * (2 * t)) t := h2.const_mul 48
  have h := (h2t4.add h24).sub h48
  rw [show 2 * (4 * t ^ 3) + 24 * (3 * t ^ 2) - 48 * (2 * t) =
      8 * t ^ 3 + 72 * t ^ 2 - 96 * t by ring] at h
  exact h

private theorem hasDerivAt_polyR4 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 2 * t ^ 4 + 32 * t ^ 3 + 24 * t ^ 2 - 48 * t)
      (8 * t ^ 3 + 96 * t ^ 2 + 48 * t - 48) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h4 : HasDerivAt (fun t : ℝ => t ^ 4) (4 * t ^ 3) t := by
    simpa using hasDerivAt_pow 4 t
  have h2t4 : HasDerivAt (fun t : ℝ => 2 * t ^ 4) (2 * (4 * t ^ 3)) t := h4.const_mul 2
  have h3 : HasDerivAt (fun t : ℝ => t ^ 3) (3 * t ^ 2) t := by
    simpa using hasDerivAt_pow 3 t
  have h32 : HasDerivAt (fun t : ℝ => 32 * t ^ 3) (32 * (3 * t ^ 2)) t := h3.const_mul 32
  have h2 : HasDerivAt (fun t : ℝ => t ^ 2) (2 * t) t := by
    simpa using hasDerivAt_pow 2 t
  have h24 : HasDerivAt (fun t : ℝ => 24 * t ^ 2) (24 * (2 * t)) t := h2.const_mul 24
  have h48 : HasDerivAt (fun t : ℝ => 48 * t) 48 t := by
    simpa using hid.const_mul 48
  have h := ((h2t4.add h32).add h24).sub h48
  rw [show (2 * (4 * t ^ 3) + 32 * (3 * t ^ 2)) + 24 * (2 * t) - 48 =
      8 * t ^ 3 + 96 * t ^ 2 + 48 * t - 48 by ring] at h
  exact h

private theorem hasDerivAt_F0 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 1440 * t +
        (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * (Real.exp t - 1))
      (1440 + (8 * t ^ 3 - 240 * t + 720) * (Real.exp t - 1) +
        (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * Real.exp t) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h1440 : HasDerivAt (fun t : ℝ => 1440 * t) 1440 t := by
    simpa using hid.const_mul 1440
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod := (hasDerivAt_polyP t).mul hexpm1
  have h := h1440.add hprod
  rw [show 1440 + ((8 * t ^ 3 - 240 * t + 720) * (Real.exp t - 1) +
      (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * Real.exp t) =
    1440 + (8 * t ^ 3 - 240 * t + 720) * (Real.exp t - 1) +
      (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * Real.exp t by ring] at h
  exact h

private theorem hasDerivAt_F1 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 1440 + (8 * t ^ 3 - 240 * t + 720) * (Real.exp t - 1) +
        (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * Real.exp t)
      ((24 * t ^ 2 - 240) * (Real.exp t - 1) +
        (2 * t ^ 4 + 16 * t ^ 3 - 120 * t ^ 2 + 240 * t) * Real.exp t) t := by
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod1 := (hasDerivAt_polyP1 t).mul hexpm1
  have hprod2 := (hasDerivAt_polyP t).mul (Real.hasDerivAt_exp t)
  have h := (hasDerivAt_const t (1440 : ℝ)).add (hprod1.add hprod2)
  rw [show 0 + ((24 * t ^ 2 - 240) * (Real.exp t - 1) + (8 * t ^ 3 - 240 * t + 720) * Real.exp t +
      ((8 * t ^ 3 - 240 * t + 720) * Real.exp t +
        (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * Real.exp t)) =
      (24 * t ^ 2 - 240) * (Real.exp t - 1) +
        (2 * t ^ 4 + 16 * t ^ 3 - 120 * t ^ 2 + 240 * t) * Real.exp t by ring] at h
  refine h.congr_of_eventuallyEq (Filter.Eventually.of_forall fun x => ?_)
  simp only [Pi.add_apply, Pi.mul_apply]
  ring

private theorem hasDerivAt_F2 (t : ℝ) :
    HasDerivAt (fun t : ℝ => (24 * t ^ 2 - 240) * (Real.exp t - 1) +
        (2 * t ^ 4 + 16 * t ^ 3 - 120 * t ^ 2 + 240 * t) * Real.exp t)
      ((48 * t) * (Real.exp t - 1) + (2 * t ^ 4 + 24 * t ^ 3 - 48 * t ^ 2) * Real.exp t) t := by
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod1 := (hasDerivAt_polyP2 t).mul hexpm1
  have hprod2 := (hasDerivAt_polyR2 t).mul (Real.hasDerivAt_exp t)
  have h := hprod1.add hprod2
  rw [show (48 * t) * (Real.exp t - 1) + (24 * t ^ 2 - 240) * Real.exp t +
      ((8 * t ^ 3 + 48 * t ^ 2 - 240 * t + 240) * Real.exp t +
        (2 * t ^ 4 + 16 * t ^ 3 - 120 * t ^ 2 + 240 * t) * Real.exp t) =
      (48 * t) * (Real.exp t - 1) + (2 * t ^ 4 + 24 * t ^ 3 - 48 * t ^ 2) * Real.exp t by
    ring] at h
  exact h

private theorem hasDerivAt_F3 (t : ℝ) :
    HasDerivAt (fun t : ℝ => (48 * t) * (Real.exp t - 1) +
        (2 * t ^ 4 + 24 * t ^ 3 - 48 * t ^ 2) * Real.exp t)
      (48 * (Real.exp t - 1) + (2 * t ^ 4 + 32 * t ^ 3 + 24 * t ^ 2 - 48 * t) * Real.exp t) t := by
  have hid : HasDerivAt (fun t : ℝ => t) 1 t := hasDerivAt_id' t
  have h48 : HasDerivAt (fun t : ℝ => 48 * t) 48 t := by
    simpa using hid.const_mul 48
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod1 := h48.mul hexpm1
  have hprod2 := (hasDerivAt_polyR3 t).mul (Real.hasDerivAt_exp t)
  have h := hprod1.add hprod2
  rw [show 48 * (Real.exp t - 1) + (48 * t) * Real.exp t +
      ((8 * t ^ 3 + 72 * t ^ 2 - 96 * t) * Real.exp t +
        (2 * t ^ 4 + 24 * t ^ 3 - 48 * t ^ 2) * Real.exp t) =
      48 * (Real.exp t - 1) + (2 * t ^ 4 + 32 * t ^ 3 + 24 * t ^ 2 - 48 * t) * Real.exp t by
    ring] at h
  exact h

private theorem hasDerivAt_F4 (t : ℝ) :
    HasDerivAt (fun t : ℝ => 48 * (Real.exp t - 1) +
        (2 * t ^ 4 + 32 * t ^ 3 + 24 * t ^ 2 - 48 * t) * Real.exp t)
      ((2 * t ^ 4 + 40 * t ^ 3 + 120 * t ^ 2) * Real.exp t) t := by
  have hexpm1 : HasDerivAt (fun t : ℝ => Real.exp t - 1) (Real.exp t) t :=
    (Real.hasDerivAt_exp t).sub_const 1
  have hprod1 := (hasDerivAt_const t (48 : ℝ)).mul hexpm1
  have hprod2 := (hasDerivAt_polyR4 t).mul (Real.hasDerivAt_exp t)
  have h := hprod1.add hprod2
  rw [show 0 * (Real.exp t - 1) + 48 * Real.exp t +
      ((8 * t ^ 3 + 96 * t ^ 2 + 48 * t - 48) * Real.exp t +
        (2 * t ^ 4 + 32 * t ^ 3 + 24 * t ^ 2 - 48 * t) * Real.exp t) =
      (2 * t ^ 4 + 40 * t ^ 3 + 120 * t ^ 2) * Real.exp t by ring] at h
  exact h

/-- The quintic-cascade bound: `F(t) ≥ 0` for `t ≥ 0`, where
`F(t) = 1440t + (2t⁴ − 120t² + 720t − 1440)(e^t − 1)`. The fifth derivative is
`2t²(t² + 20t + 60)·e^t ≥ 0` and all lower derivatives vanish at `0`. -/
private theorem fcascade_nonneg {t : ℝ} (ht : 0 ≤ t) :
    0 ≤ 1440 * t + (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * (Real.exp t - 1) := by
  apply nonneg_of_cascade hasDerivAt_F0 (by simp) _ ht
  intro x hx
  apply nonneg_of_cascade hasDerivAt_F1 (by simp) _ hx
  intro y hy
  apply nonneg_of_cascade hasDerivAt_F2 (by simp) _ hy
  intro z hz
  apply nonneg_of_cascade hasDerivAt_F3 (by simp) _ hz
  intro w hw
  apply nonneg_of_cascade hasDerivAt_F4 (by simp) _ hw
  intro v hv
  have hnn : 0 ≤ 2 * v ^ 4 + 40 * v ^ 3 + 120 * v ^ 2 := by
    nlinarith [sq_nonneg v, sq_nonneg (v * v), hv]
  exact mul_nonneg hnn (Real.exp_pos v).le

/-- The second-order correction bound: `h(t) ≥ t/12 − t³/720` for `t > 0`. -/
theorem regularizedReal_sub_div_twelve_ge {t : ℝ} (ht : 0 < t) :
    t / 12 - t ^ 3 / 720 ≤ regularizedReal t := by
  have hexp : 0 < Real.exp t - 1 := by linarith [Real.add_one_le_exp t]
  have hden : (0 : ℝ) < 2 * t * (Real.exp t - 1) := by positivity
  have hF : 0 ≤ 1440 * t + (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * (Real.exp t - 1) :=
    fcascade_nonneg ht.le
  rw [regularizedReal_eq_div ht, le_div_iff₀ hden]
  have key : (2 * t + (t - 2) * (Real.exp t - 1)) =
      (t / 12 - t ^ 3 / 720) * (2 * t * (Real.exp t - 1)) +
        (1440 * t + (2 * t ^ 4 - 120 * t ^ 2 + 720 * t - 1440) * (Real.exp t - 1)) / 720 := by
    ring
  rw [key]
  linarith [hF]

/-- The twice-subtracted kernel is `O(t³)` near zero, with the sharp constant
`1/720 = −B₄/4!`. -/
theorem norm_regularizedKernel₂_le {t : ℝ} (ht0 : 0 < t) (ht1 : t < 1) :
    ‖regularizedKernel₂ t‖ ≤ t ^ 3 / 720 := by
  have hle : regularizedReal t ≤ t / 12 := regularizedReal_le_div_twelve ht0
  have hge : t / 12 - t ^ 3 / 720 ≤ regularizedReal t := regularizedReal_sub_div_twelve_ge ht0
  have hcast : regularizedKernel₂ t = ((regularizedReal t - t / 12 : ℝ) : ℂ) := by
    rw [regularizedKernel₂, if_pos ht1, regularizedReal, zetaKernel]
    push_cast
    ring
  rw [hcast, Complex.norm_real, Real.norm_eq_abs, abs_le]
  constructor <;> linarith

/-- The twice-subtracted kernel is `O(t³)` near zero (as a big-O). -/
theorem regularizedKernel₂_isBigO_rpow_three :
    regularizedKernel₂ =O[nhdsWithin (0 : ℝ) (Ioi 0)] (fun t : ℝ => t ^ (3 : ℝ)) := by
  refine Asymptotics.IsBigO.of_bound (1 / 720 : ℝ) ?_
  rw [eventually_nhdsWithin_iff]
  filter_upwards [Iio_mem_nhds (show (0 : ℝ) < 1 by norm_num)] with t ht hpos
  have hnorm : ‖regularizedKernel₂ t‖ ≤ t ^ 3 / 720 := norm_regularizedKernel₂_le hpos ht
  have ht3 : ‖(t : ℝ) ^ (3 : ℝ)‖ = t ^ 3 := by
    have ht0 : (0 : ℝ) < t := hpos
    have e : (t : ℝ) ^ (3 : ℝ) = t ^ 3 := by
      rw [show (3 : ℝ) = ((3 : ℕ) : ℝ) by norm_num]
      exact Real.rpow_natCast t 3
    rw [e, Real.norm_eq_abs, abs_of_pos (by positivity : (0 : ℝ) < t ^ 3)]
  rw [ht3]
  linarith [hnorm]

lemma measurable_regularizedKernel₂ : Measurable regularizedKernel₂ := by
  unfold regularizedKernel₂
  apply Measurable.ite measurableSet_Iio
  · have hz : Measurable zetaKernel := by
      unfold zetaKernel
      measurability
    have ht : Measurable fun t : ℝ => ((t : ℂ))⁻¹ := measurable_ofReal.inv
    have htc : Measurable fun t : ℝ => ((t : ℂ) / 12) := measurable_ofReal.div_const 12
    convert ((hz.sub ht).add (measurable_const : Measurable fun _ : ℝ => (1 / 2 : ℂ))).sub
      htc using 1
    ext x
    simp [Pi.sub_apply, Pi.add_apply, one_div]
  · unfold zetaKernel
    measurability

/-- The twice-subtracted kernel is locally integrable on `(0,∞)`. -/
theorem locallyIntegrableOn_regularizedKernel₂ :
    LocallyIntegrableOn regularizedKernel₂ (Ioi 0) := by
  intro x hx
  have hx0 : 0 < x := hx
  let a : ℝ := x / 2
  let b : ℝ := 2 * x
  have ha : 0 < a := by dsimp [a]; positivity
  have hb : a ≤ b := by dsimp [a, b]; linarith
  have hbound : ∀ t ∈ Icc a b, ‖regularizedKernel₂ t‖ ≤ max (1 : ℝ) (2 / a) := by
    intro t ht
    by_cases ht1 : t < 1
    · have ht0 : 0 < t := lt_of_lt_of_le ha ht.1
      have hle : ‖regularizedKernel₂ t‖ ≤ t ^ 3 / 720 := norm_regularizedKernel₂_le ht0 ht1
      have hcube : t ^ 3 ≤ 1 := by
        have ht0' : 0 ≤ t := le_of_lt ht0
        have ht1' : t ≤ 1 := le_of_lt ht1
        calc t ^ 3 ≤ 1 ^ 3 := pow_le_pow_left₀ ht0' ht1' 3
        _ = 1 := by norm_num
      have h1 : t ^ 3 / 720 ≤ 1 := by linarith
      exact le_trans hle (le_trans h1 (le_max_left _ _))
    · rw [regularizedKernel₂, if_neg ht1]
      have ht0 : 0 < t := lt_of_lt_of_le ha ht.1
      have hle : ‖zetaKernel t‖ ≤ 2 / t := norm_zetaKernel_le_two_div (le_of_not_gt ht1)
      have h2 : 2 / t ≤ 2 / a := div_le_div_of_nonneg_left (by norm_num) ha ht.1
      exact le_trans (le_trans hle h2) (le_max_right _ _)
  have hint : IntegrableOn regularizedKernel₂ (Icc a b) := by
    refine IntegrableOn.of_bound measure_Icc_lt_top ?_ (max (1 : ℝ) (2 / a)) ?_
    · exact measurable_regularizedKernel₂.aestronglyMeasurable
    · filter_upwards [ae_restrict_mem measurableSet_Icc] with t ht
      exact hbound t ht
  refine ⟨Icc a b, ?_, hint⟩
  apply mem_nhdsWithin_of_mem_nhds
  have hIoo : Ioo a b ∈ nhds x :=
    Ioo_mem_nhds (by show x / 2 < x; linarith) (by show x < 2 * x; linarith)
  exact Filter.mem_of_superset hIoo Ioo_subset_Icc_self

/-- `regularizedKernel₂` is `O(e^{-t})` at infinity. -/
theorem regularizedKernel₂_isBigO_exp :
    regularizedKernel₂ =O[atTop] (fun t : ℝ => Real.exp (-1 * t)) := by
  refine Asymptotics.IsBigO.of_bound (2 : ℝ) ?_
  filter_upwards [Filter.eventually_ge_atTop (1 : ℝ)] with t ht
  have hker : regularizedKernel₂ t = zetaKernel t := by
    rw [regularizedKernel₂, if_neg (not_lt.mpr ht)]
  rw [hker]
  have hle := norm_zetaKernel_le_two_exp_neg ht
  simpa [Real.exp_neg, mul_comm, mul_left_comm, mul_assoc] using hle

/-- **Convergence two strips beyond.** The twice-subtracted annular integral
converges on `−3 < re s`. -/
theorem mellinConvergent_regularizedKernel₂ {s : ℂ} (hs : -3 < s.re) :
    MellinConvergent regularizedKernel₂ s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := -3) one_pos
    locallyIntegrableOn_regularizedKernel₂ regularizedKernel₂_isBigO_exp ?_ ?_
  · simpa using regularizedKernel₂_isBigO_rpow_three
  · simpa using hs

/-- The twice-subtracted annular integral is holomorphic on `−3 < re s`. -/
theorem differentiableAt_mellin_regularizedKernel₂ {s : ℂ} (hs : -3 < s.re) :
    DifferentiableAt ℂ (mellin regularizedKernel₂) s := by
  refine mellin_differentiableAt_of_isBigO_rpow_exp (a := 1) (b := -3) one_pos
    locallyIntegrableOn_regularizedKernel₂ regularizedKernel₂_isBigO_exp ?_ ?_
  · simpa using regularizedKernel₂_isBigO_rpow_three
  · simpa using hs

end AngularPartition

namespace AngularPartition

/-- The twice-subtracted finite part: the `s = −1` pole term is removed as
well. -/
noncomputable def regularizedMellin₂ (s : ℂ) : ℂ :=
  Complex.Gamma s * riemannZeta s - 1 / (s - 1) + 1 / (2 * s) - 1 / (12 * (s + 1))

/-- The identity for the twice-subtracted kernel on the convergence domain
`re s > 1`. -/
theorem mellin_regularizedKernel₂_eq_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    mellin regularizedKernel₂ s = regularizedMellin₂ s := by
  have hsplit : regularizedKernel₂ = regularizedKernel + linCutoff :=
    funext regularizedKernel₂_eq_regularizedKernel_add
  have hconvK : MellinConvergent regularizedKernel s :=
    mellinConvergent_regularizedKernel_of_pos (by linarith)
  have hconvL : MellinConvergent linCutoff s := (hasMellin_linCutoff (by linarith)).1
  rw [hsplit, mellin_add hconvK hconvL, mellin_regularizedKernel_eq_of_one_lt_re hs,
    (hasMellin_linCutoff (by linarith)).2, regularizedMellin₂, regularizedMellin]
  have e1 : (-(1 : ℂ) / 12) * (1 / (s + 1)) = -(1 / (12 * (s + 1))) := by
    rw [div_mul_div_comm, neg_one_mul, neg_div]
  rw [e1]
  ring

/-- On the overlap strip the two kernels differ exactly by the new pole term
`-1/(12(s+1))`. -/
theorem mellin_regularizedKernel₂_sub {s : ℂ} (hs : -1 < s.re) :
    mellin regularizedKernel₂ s = mellin regularizedKernel s - 1 / (12 * (s + 1)) := by
  have hsplit : regularizedKernel₂ = regularizedKernel + linCutoff :=
    funext regularizedKernel₂_eq_regularizedKernel_add
  have hconvK : MellinConvergent regularizedKernel s :=
    mellinConvergent_regularizedKernel_of_neg_one_lt hs
  have hconvL : MellinConvergent linCutoff s := (hasMellin_linCutoff hs).1
  rw [hsplit, mellin_add hconvK hconvL, (hasMellin_linCutoff hs).2]
  have e1 : (-(1 : ℂ) / 12) * (1 / (s + 1)) = -(1 / (12 * (s + 1))) := by
    rw [div_mul_div_comm, neg_one_mul, neg_div]
  rw [e1]
  ring

/-- The twice-subtracted finite part is differentiable on `−3 < re s` away
from the pole points `−2, −1, 0, 1`. -/
theorem regularizedMellin₂_differentiableAt {s : ℂ}
    (hs : -3 < s.re) (hm2 : s ≠ -2) (hm1 : s ≠ -1) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    DifferentiableAt ℂ regularizedMellin₂ s := by
  have hs1' : s + 1 ≠ 0 := by
    intro h
    exact hm1 (neg_eq_iff_add_eq_zero.mpr (add_comm s 1 ▸ h)).symm
  have hG : DifferentiableAt ℂ Complex.Gamma s := by
    refine Complex.differentiableAt_Gamma s ?_
    intro m hm
    have hre : s.re = -(m : ℝ) := by
      rw [hm]
      simp
    rcases (by omega : m = 0 ∨ m = 1 ∨ m = 2 ∨ 3 ≤ m) with rfl | rfl | rfl | hm3
    · simp only [Nat.cast_zero, neg_zero] at hm
      exact hs0 hm
    · simp only [Nat.cast_one] at hm
      exact hm1 hm
    · simp only [Nat.cast_ofNat] at hm
      exact hm2 hm
    · have hle : (3 : ℝ) ≤ (m : ℝ) := by exact_mod_cast hm3
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
      (mul_ne_zero two_ne_zero hs0)
  have h2 : DifferentiableAt ℂ (fun z : ℂ => 1 / (2 * z)) s := by
    simpa [one_div] using h2'
  have h3' : DifferentiableAt ℂ (fun z : ℂ => (12 * (z + 1))⁻¹) s :=
    ((differentiableAt_const (12 : ℂ)).mul
      ((differentiableAt_id : DifferentiableAt ℂ (fun z : ℂ => z) s).add_const 1)).inv
      (mul_ne_zero (by norm_num) hs1')
  have h3 : DifferentiableAt ℂ (fun z : ℂ => 1 / (12 * (z + 1))) s := by
    simpa [one_div] using h3'
  unfold regularizedMellin₂
  exact ((hG.mul hZ).sub h1 |>.add h2).sub h3

end AngularPartition

namespace AngularPartition

/-- The identity for the twice-subtracted kernel holds on the upper half of
the tripled strip. -/
theorem mellin_regularizedKernel₂_eqOn_upper :
    EqOn (mellin regularizedKernel₂) regularizedMellin₂
      {s : ℂ | -3 < s.re ∧ 0 < s.im} := by
  let U : Set ℂ := {s : ℂ | -3 < s.re ∧ 0 < s.im}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := -3)).inter (convex_halfSpace_im_gt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | -3 < s.re} ∩ {s : ℂ | 0 < s.im})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_const continuous_im)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel₂) U :=
    fun z hz => (differentiableAt_mellin_regularizedKernel₂ hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin₂ U :=
    fun z hz => (regularizedMellin₂_differentiableAt hz.1 (by
      intro h
      have hz2 : 0 < (-2 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : 0 < (-1 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : 0 < (0 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : 0 < (1 : ℂ).im := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel₂) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin₂ U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel₂) regularizedMellin₂ U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) + Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) + Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) + Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel₂_eq_of_one_lt_re hz

/-- The identity for the twice-subtracted kernel holds on the lower half of
the tripled strip. -/
theorem mellin_regularizedKernel₂_eqOn_lower :
    EqOn (mellin regularizedKernel₂) regularizedMellin₂
      {s : ℂ | -3 < s.re ∧ s.im < 0} := by
  let U : Set ℂ := {s : ℂ | -3 < s.re ∧ s.im < 0}
  have hconv : Convex ℝ U := by
    simpa [U, Set.setOf_and] using
      (convex_halfSpace_re_gt (r := -3)).inter (convex_halfSpace_im_lt (r := 0))
  have hopen : IsOpen U := by
    change IsOpen ({s : ℂ | -3 < s.re} ∩ {s : ℂ | s.im < 0})
    exact (isOpen_lt continuous_const continuous_re).inter
      (isOpen_lt continuous_im continuous_const)
  have hfd : DifferentiableOn ℂ (mellin regularizedKernel₂) U :=
    fun z hz => (differentiableAt_mellin_regularizedKernel₂ hz.1).differentiableWithinAt
  have hgd : DifferentiableOn ℂ regularizedMellin₂ U :=
    fun z hz => (regularizedMellin₂_differentiableAt hz.1 (by
      intro h
      have hz2 : (-2 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : (-1 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : (0 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2) (by
      intro h
      have hz2 : (1 : ℂ).im < 0 := by simpa [h] using hz.2
      norm_num at hz2)).differentiableWithinAt
  have hf : AnalyticOnNhd ℂ (mellin regularizedKernel₂) U := hfd.analyticOnNhd hopen
  have hg : AnalyticOnNhd ℂ regularizedMellin₂ U := hgd.analyticOnNhd hopen
  change EqOn (mellin regularizedKernel₂) regularizedMellin₂ U
  refine hf.eqOn_of_preconnected_of_eventuallyEq (z₀ := (2 : ℂ) - Complex.I) hg
    (Convex.isPreconnected hconv) ?_ ?_
  · show (2 : ℂ) - Complex.I ∈ U
    norm_num [U]
  · have hmem : {z : ℂ | 1 < z.re} ∈ nhds ((2 : ℂ) - Complex.I) :=
      (isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)
    filter_upwards [hmem] with z hz
    exact mellin_regularizedKernel₂_eq_of_one_lt_re hz

/-- The identity for the twice-subtracted kernel holds on the tripled strip
away from the real axis. -/
theorem mellin_regularizedKernel₂_eq_of_neg_three_lt_of_im_ne {s : ℂ}
    (hs : -3 < s.re) (him : s.im ≠ 0) :
    mellin regularizedKernel₂ s = regularizedMellin₂ s := by
  rcases lt_or_gt_of_ne (Ne.symm him) with h | h
  · exact mellin_regularizedKernel₂_eqOn_upper ⟨hs, h⟩
  · exact mellin_regularizedKernel₂_eqOn_lower ⟨hs, h⟩

/-- The identity for the twice-subtracted kernel extends to the real axis by
continuity in the imaginary direction. -/
theorem mellin_regularizedKernel₂_eq_of_neg_three_lt_of_im_eq {s : ℂ}
    (hs : -3 < s.re) (hm2 : s ≠ -2) (hm1 : s ≠ -1) (hs0 : s ≠ 0) (hs1 : s ≠ 1)
    (him : s.im = 0) :
    mellin regularizedKernel₂ s = regularizedMellin₂ s := by
  have hs_eq : s = (s.re : ℂ) := by
    apply Complex.ext <;> simp [him]
  let z : ℝ → ℂ := fun y => (s.re : ℂ) + (y : ℂ) * Complex.I
  have hz_re : ∀ y, (z y).re = s.re := by
    intro y
    simp [z, Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im]
  have hz_im : ∀ y, y ≠ 0 → (z y).im = y := by
    intro y hy
    simp [z, Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_im, Complex.I_re]
  have hz_tend : Tendsto z (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds s) := by
    rw [hs_eq]
    have hy : Tendsto (fun y : ℝ => (y : ℂ)) (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds 0) := by
      simpa using (continuous_ofReal.tendsto 0).mono_left nhdsWithin_le_nhds
    simpa [z] using tendsto_const_nhds.add (hy.mul tendsto_const_nhds)
  have hcont : ContinuousAt (mellin regularizedKernel₂) s :=
    (differentiableAt_mellin_regularizedKernel₂ hs).continuousAt
  have hcontG : ContinuousAt regularizedMellin₂ s :=
    (regularizedMellin₂_differentiableAt hs hm2 hm1 hs0 hs1).continuousAt
  have hlim1 : Tendsto (fun y => mellin regularizedKernel₂ (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (mellin regularizedKernel₂ s)) :=
    hcont.tendsto.comp hz_tend
  have hlim2 : Tendsto (fun y => regularizedMellin₂ (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin₂ s)) :=
    hcontG.tendsto.comp hz_tend
  have hlim2' : Tendsto (fun y => mellin regularizedKernel₂ (z y))
      (nhdsWithin (0 : ℝ) {0}ᶜ) (nhds (regularizedMellin₂ s)) := by
    refine hlim2.congr' ?_
    filter_upwards [self_mem_nhdsWithin] with y hy
    exact (mellin_regularizedKernel₂_eq_of_neg_three_lt_of_im_ne (s := z y)
      (by rw [hz_re y]; exact hs) (by rw [hz_im y hy]; exact hy)).symm
  exact tendsto_nhds_unique hlim1 hlim2'

/-- **Integral identity on the tripled strip.** The twice-subtracted annular
integral equals the twice-subtracted finite part throughout `−3 < re s`, away
from the pole points. -/
theorem mellin_regularizedKernel₂_eq_of_neg_three_lt_re {s : ℂ}
    (hs : -3 < s.re) (hm2 : s ≠ -2) (hm1 : s ≠ -1) (hs0 : s ≠ 0) (hs1 : s ≠ 1) :
    mellin regularizedKernel₂ s = regularizedMellin₂ s := by
  by_cases him : s.im = 0
  · exact mellin_regularizedKernel₂_eq_of_neg_three_lt_of_im_eq hs hm2 hm1 hs0 hs1 him
  · exact mellin_regularizedKernel₂_eq_of_neg_three_lt_of_im_ne hs him

/-- **Pole cancellation at `s = −1`.** The twice-subtracted finite part is
regular at `−1`: the subtracted term `-1/(12(s+1))` cancels exactly the pole
of `Γ(s)ζ(s)` (residue `ζ(−1)·(−1) = 1/12`). -/
theorem regularizedMellin₂_residue_neg_one :
    Filter.Tendsto (fun s : ℂ => (s + 1) * regularizedMellin₂ s)
      (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds 0) := by
  have hΓlim : Tendsto (fun s : ℂ => Complex.Gamma (s + 2) / s)
      (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds (-1)) := by
    have h1 : Tendsto (fun s : ℂ => s + 2) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds 1) := by
      have hcont : ContinuousAt (fun s : ℂ => s + 2) (-1) := by fun_prop
      have h : Tendsto (fun s : ℂ => s + 2) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
          (nhds ((-1 : ℂ) + 2)) := hcont.tendsto.mono_left nhdsWithin_le_nhds
      rw [show (-1 : ℂ) + 2 = 1 by norm_num] at h
      exact h
    have h2 : Tendsto (fun s : ℂ => Complex.Gamma (s + 2))
        (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds (Complex.Gamma 1)) :=
      Complex.continuousAt_Gamma_one.tendsto.comp h1
    have h3 : Tendsto (fun s : ℂ => s) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds (-1)) :=
      continuousAt_id.tendsto.mono_left nhdsWithin_le_nhds
    have h4 := h2.div h3 (by norm_num : (-1 : ℂ) ≠ 0)
    rw [Complex.Gamma_one, show (1 : ℂ) / (-1) = -1 by norm_num] at h4
    exact h4
  have hcongr : (fun s : ℂ => Complex.Gamma (s + 2) / s) =ᶠ[nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ]
      (fun s : ℂ => (s + 1) * Complex.Gamma s) := by
    have hne : ∀ᶠ s in nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ, s ≠ 0 := by
      rw [eventually_nhdsWithin_iff]
      filter_upwards [isOpen_compl_singleton.mem_nhds
        (show (-1 : ℂ) ∈ ({0} : Set ℂ)ᶜ by simp)] with s hs
      intro _
      simpa using hs
    filter_upwards [hne, self_mem_nhdsWithin] with s hs0 hs1
    have hs1' : s + 1 ≠ 0 := by
      intro h
      exact hs1 (neg_eq_iff_add_eq_zero.mpr (add_comm s 1 ▸ h)).symm
    have h1 : Complex.Gamma (s + 1) = s * Complex.Gamma s := Complex.Gamma_add_one s hs0
    have h2' := Complex.Gamma_add_one (s + 1) hs1'
    rw [show s + 1 + 1 = s + 2 by ring] at h2'
    rw [h2', h1]
    field_simp [hs0]
  have hΓ : Tendsto (fun s : ℂ => (s + 1) * Complex.Gamma s)
      (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds (-1)) :=
    hΓlim.congr' hcongr
  have hζval : riemannZeta (-1 : ℂ) = -1 / 12 := by
    have h := riemannZeta_neg_nat_eq_bernoulli' 1
    have hcast : (-(1 : ℕ) : ℂ) = -1 := by simp
    rw [hcast, bernoulli'_two] at h
    rw [h]
    push_cast
    norm_num
  have hζ : Tendsto riemannZeta (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds (-1 / 12)) := by
    have hcontζ : ContinuousAt riemannZeta (-1) :=
      (differentiableAt_riemannZeta (by norm_num : (-1 : ℂ) ≠ 1)).continuousAt
    rw [← hζval]
    exact hcontζ.tendsto.mono_left nhdsWithin_le_nhds
  have hp1 : Tendsto (fun s : ℂ => (s + 1) / (s - 1)) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
      (nhds 0) := by
    have hnum : Tendsto (fun s : ℂ => s + 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds 0) := by
      have hcont : ContinuousAt (fun s : ℂ => s + 1) (-1) := by fun_prop
      have h : Tendsto (fun s : ℂ => s + 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
          (nhds ((-1 : ℂ) + 1)) := hcont.tendsto.mono_left nhdsWithin_le_nhds
      rw [show (-1 : ℂ) + 1 = 0 by norm_num] at h
      exact h
    have hden : Tendsto (fun s : ℂ => s - 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds (-2)) := by
      have hcont : ContinuousAt (fun s : ℂ => s - 1) (-1) := by fun_prop
      have h : Tendsto (fun s : ℂ => s - 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
          (nhds ((-1 : ℂ) - 1)) := hcont.tendsto.mono_left nhdsWithin_le_nhds
      rw [show (-1 : ℂ) - 1 = -2 by norm_num] at h
      exact h
    have h := hnum.div hden (by norm_num : (-2 : ℂ) ≠ 0)
    rw [show (0 : ℂ) / (-2) = 0 by norm_num] at h
    exact h
  have hp2 : Tendsto (fun s : ℂ => (s + 1) / (2 * s)) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
      (nhds 0) := by
    have hnum : Tendsto (fun s : ℂ => s + 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds 0) := by
      have hcont : ContinuousAt (fun s : ℂ => s + 1) (-1) := by fun_prop
      have h : Tendsto (fun s : ℂ => s + 1) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
          (nhds ((-1 : ℂ) + 1)) := hcont.tendsto.mono_left nhdsWithin_le_nhds
      rw [show (-1 : ℂ) + 1 = 0 by norm_num] at h
      exact h
    have hden : Tendsto (fun s : ℂ => 2 * s) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds (-2)) := by
      have hcont : ContinuousAt (fun s : ℂ => 2 * s) (-1) := by fun_prop
      have h : Tendsto (fun s : ℂ => 2 * s) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
          (nhds (2 * (-1 : ℂ))) := hcont.tendsto.mono_left nhdsWithin_le_nhds
      rw [show (2 : ℂ) * (-1) = -2 by norm_num] at h
      exact h
    have h := hnum.div hden (by norm_num : (-2 : ℂ) ≠ 0)
    rw [show (0 : ℂ) / (-2) = 0 by norm_num] at h
    exact h
  have hev : (fun s : ℂ => (s + 1) * regularizedMellin₂ s) =ᶠ[nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ]
      (fun s : ℂ => ((s + 1) * Complex.Gamma s) * riemannZeta s - (s + 1) / (s - 1) +
        (s + 1) / (2 * s) - 1 / 12) := by
    filter_upwards [self_mem_nhdsWithin] with s hs
    have hs1' : s + 1 ≠ 0 := by
      intro h
      exact hs (neg_eq_iff_add_eq_zero.mpr (add_comm s 1 ▸ h)).symm
    unfold regularizedMellin₂
    rw [mul_sub, mul_add, mul_sub, mul_comm ((s + 1)) (Complex.Gamma s * riemannZeta s)]
    have e1 : (s + 1) * (1 / (12 * (s + 1))) = 1 / 12 := by
      field_simp [hs1']
    rw [e1]
    ring
  have hmain : Tendsto (fun s : ℂ => ((s + 1) * Complex.Gamma s) * riemannZeta s -
        (s + 1) / (s - 1) + (s + 1) / (2 * s) - 1 / 12)
      (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds 0) := by
    have hA : Tendsto (fun s : ℂ => ((s + 1) * Complex.Gamma s) * riemannZeta s)
        (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ) (nhds ((-1) * (-1 / 12))) := hΓ.mul hζ
    have hD : Tendsto (fun _ : ℂ => (1 / 12 : ℂ)) (nhdsWithin (-1 : ℂ) ({-1} : Set ℂ)ᶜ)
        (nhds (1 / 12)) := tendsto_const_nhds
    have hcomb := ((hA.sub hp1).add hp2).sub hD
    norm_num at hcomb
    exact hcomb
  exact hmain.congr' hev.symm

end AngularPartition
