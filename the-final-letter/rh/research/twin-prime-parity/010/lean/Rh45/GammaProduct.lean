/-
  Rh45/GammaProduct.lean — from the pointwise Euler product limit to the
  polygamma series.

  Mathlib proves the *pointwise* Euler limit formula for the complex Gamma
  function: `Complex.GammaSeq_tendsto_Gamma s : Tendsto (GammaSeq s) atTop (𝓝 (Γ s))`
  (`Mathlib/Analysis/SpecialFunctions/Gamma/Beta.lean`).  This module upgrades it
  to *locally uniform* convergence on the right half-plane and differentiates it
  with Weierstrass' theorem, which is the missing analytic input for the series
  development of the polygamma functions.

  What is proved here:

  * `differentiableAt_GammaSeq`, `analyticAt_GammaSeq` — `GammaSeq · n` is analytic
    wherever `0 < re ·`;
  * `norm_GammaSeq_le` — the *integral* bound `‖GammaSeq s n‖ ≤ Real.Gamma s.re`,
    uniform in `n`, obtained from Mathlib's integral representation
    `GammaSeq_eq_approx_Gamma_integral` and
    `(1 - x/n)^n ≤ exp (-x)` rather than from the factorial formula (which is not
    uniform on a circle);
  * `tendstoLocallyUniformlyOn_GammaSeq` — locally uniform convergence on `{0 < re ·}`.
    Route: Cauchy's integral formula on a circle of radius `ρ` strictly larger than
    the radius `r` of the disc on which uniformity is wanted.  Cauchy's formula
    turns the discrepancy into a contour integral whose *norm* is bounded by
    `(2π)⁻¹ ρ (ρ - r)⁻¹ ∫ ‖GammaSeq · n - Γ‖ |dζ|`; the scalar integral tends to `0`
    by dominated convergence (pointwise convergence on the circle plus the uniform
    bound above), which is uniform in the point `s` of the disc.  This avoids both
    Mathlib's missing Vitali/Montel theorem and the more delicate uniform-in-`s`
    dominated-convergence argument for the integral representation;
  * `tendstoLocallyUniformlyOn_deriv_GammaSeq` — Weierstrass' theorem
    (`TendstoLocallyUniformlyOn.deriv`) iterated, giving locally uniform convergence
    of every derivative;
  * `tendstoLocallyUniformlyOn_logDeriv_GammaSeq` — the corresponding statement for
    the logarithmic derivative, via a direct uniform quotient estimate.

  **Not** proved here (the second half of the round): the *explicit* formula
  `deriv^[k] (logDeriv (GammaSeq · n)) s = (-1)^(k+1) k! ∑_{j≤n} (s+j)^{-(k+1)}`
  (for `k ≥ 1`, `n ≠ 0`), from which the polygamma series follows by `n → ∞`.

  There is no `sorry`, no `axiom` and no computation by reflection.
-/
import Mathlib

open MeasureTheory Filter Set
open scoped Topology BigOperators Real

namespace Rh45RouteBAnalytic

noncomputable section

open Complex Metric

/-! ## 1. Analyticity of `GammaSeq` and the uniform integral bound -/

/-- `GammaSeq · n` is complex differentiable at every point of the right half-plane. -/
theorem differentiableAt_GammaSeq (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ (fun w : ℂ => GammaSeq w n) s := by
  rcases eq_or_ne n 0 with rfl | hn
  · have hsne : s ≠ 0 := fun h => by rw [h] at hs; simp at hs
    refine (differentiableAt_const (c := (0 : ℂ))).congr_of_eventuallyEq ?_
    filter_upwards [(isOpen_compl_singleton (x := (0 : ℂ))).mem_nhds hsne] with w hw
    rw [GammaSeq, Nat.cast_zero, zero_cpow hw]
    simp
  · have hn' : ((n : ℂ)) ≠ 0 := Nat.cast_ne_zero.mpr hn
    have hden : (∏ j ∈ Finset.range (n + 1), (s + (j : ℂ))) ≠ 0 := by
      refine Finset.prod_ne_zero_iff.mpr ?_
      intro j _hj
      have hjr : (j : ℂ).re = (j : ℝ) := by simp
      have hpos : 0 < (s + (j : ℂ)).re := by
        rw [add_re, hjr]
        linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
      exact fun h => hpos.ne' (by simp [h])
    have hfun : (fun w : ℂ => GammaSeq w n) =
        fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ) *
          (∏ j ∈ Finset.range (n + 1), (w + (j : ℂ)))⁻¹ := by
      funext w
      rw [GammaSeq, div_eq_mul_inv]
    rw [hfun]
    refine DifferentiableAt.mul (DifferentiableAt.mul ?_ (differentiableAt_const _)) ?_
    · exact differentiableAt_id.const_cpow (Or.inl hn')
    · have hprod : DifferentiableAt ℂ
          (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s := by
        have hlin : ∀ j ∈ Finset.range (n + 1),
            DifferentiableAt ℂ (fun w : ℂ => w + (j : ℂ)) s := fun j _ => by fun_prop
        have h := DifferentiableAt.finsetProd (u := Finset.range (n + 1))
          (f := fun j (w : ℂ) => w + (j : ℂ)) hlin
        rw [show (∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ))) =
            (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) from
          funext fun w => Finset.prod_apply w (Finset.range (n + 1))
            (fun j (w : ℂ) => w + (j : ℂ))] at h
        exact h
      exact hprod.inv hden

/-- `GammaSeq · n` is analytic at every point of the right half-plane. -/
theorem analyticAt_GammaSeq (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    AnalyticAt ℂ (fun w : ℂ => GammaSeq w n) s := by
  have hd : DifferentiableOn ℂ (fun w : ℂ => GammaSeq w n) {w : ℂ | 0 < w.re} :=
    fun w hw => (differentiableAt_GammaSeq n hw).differentiableWithinAt
  exact hd.analyticAt ((isOpen_lt continuous_const continuous_re).mem_nhds hs)

/-- **The uniform integral bound.**  For `0 < re s` and every `n` the Euler product
term is dominated by the value of `Γ` at `re s`; the bound is uniform in `n` because
it comes from the integral representation of `Γ` and `(1 - x/n)^n ≤ exp (-x)`. -/
theorem norm_GammaSeq_le (n : ℕ) {s : ℂ} (hs : 0 < s.re) :
    ‖GammaSeq s n‖ ≤ Real.Gamma s.re := by
  rcases eq_or_ne n 0 with rfl | hn
  · have hsne : s ≠ 0 := fun h => by rw [h] at hs; simp at hs
    rw [GammaSeq, Nat.cast_zero, zero_cpow hsne]
    simp only [zero_mul, zero_div, norm_zero]
    exact (Real.Gamma_pos_of_pos hs).le
  · rw [GammaSeq_eq_approx_Gamma_integral hs hn,
      intervalIntegral.integral_of_le (Nat.cast_nonneg n)]
    set f : ℝ → ℂ := fun x => ↑((1 - x / n) ^ n) * (x : ℂ) ^ (s - 1) with hf
    set g : ℝ → ℝ := fun x => Real.exp (-x) * x ^ (s.re - 1) with hgd
    have hgint : IntegrableOn g (Ioi (0 : ℝ)) volume := Real.GammaIntegral_convergent hs
    have hgIoc : IntegrableOn g (Ioc (0 : ℝ) (n : ℝ)) volume :=
      hgint.mono_set Ioc_subset_Ioi_self
    have hnum : ContinuousOn (fun x : ℝ => (((1 - x / n) ^ n : ℝ) : ℂ)) (Ioi (0 : ℝ)) :=
      Complex.continuous_ofReal.comp_continuousOn (by fun_prop)
    have hpow : ContinuousOn (fun x : ℝ => (x : ℂ) ^ (s - 1)) (Ioi (0 : ℝ)) := by
      refine continuousOn_of_forall_continuousAt fun x hx => ?_
      exact (continuousAt_cpow_const (ofReal_mem_slitPlane.2 hx)).comp
        continuous_ofReal.continuousAt
    have hfcont : ContinuousOn f (Ioi (0 : ℝ)) := hnum.mul hpow
    have hle : ∀ x ∈ Ioc (0 : ℝ) (n : ℝ), ‖f x‖ ≤ g x := by
      intro x hx
      have hx0 : 0 < x := hx.1
      have hxn : x ≤ (n : ℝ) := hx.2
      have hbase : 0 ≤ 1 - x / n :=
        sub_nonneg.mpr (div_le_one_of_le₀ hxn (Nat.cast_nonneg n))
      rw [hf, hgd]
      rw [norm_mul, Complex.norm_of_nonneg (pow_nonneg hbase n),
        norm_cpow_eq_rpow_re_of_pos hx0]
      simp only [sub_re, one_re]
      exact mul_le_mul_of_nonneg_right (Real.one_sub_div_pow_le_exp_neg hxn)
        (Real.rpow_nonneg hx0.le _)
    have hmeas : AEStronglyMeasurable f (volume.restrict (Ioc (0 : ℝ) (n : ℝ))) :=
      (hfcont.mono Ioc_subset_Ioi_self).aestronglyMeasurable measurableSet_Ioc
    have hle_ae : ∀ᵐ x ∂(volume.restrict (Ioc (0 : ℝ) (n : ℝ))), ‖f x‖ ≤ g x :=
      (ae_restrict_iff' measurableSet_Ioc).mpr (ae_of_all _ hle)
    have hfint : IntegrableOn f (Ioc (0 : ℝ) (n : ℝ)) volume :=
      Integrable.mono' hgIoc hmeas hle_ae
    calc ‖∫ x in Ioc (0 : ℝ) (n : ℝ), f x‖
        ≤ ∫ x in Ioc (0 : ℝ) (n : ℝ), ‖f x‖ := norm_integral_le_integral_norm _
      _ ≤ ∫ x in Ioc (0 : ℝ) (n : ℝ), g x :=
          setIntegral_mono_on hfint.norm hgIoc measurableSet_Ioc hle
      _ ≤ ∫ x in Ioi (0 : ℝ), g x :=
          setIntegral_mono_set hgint
            ((ae_restrict_iff' measurableSet_Ioi).mpr (ae_of_all _ fun x hx => by
              rw [hgd]
              exact mul_nonneg (Real.exp_pos _).le (Real.rpow_nonneg hx.le _)))
            (ae_of_all _ fun x hx => hx.1)
      _ = Real.Gamma s.re := (Real.Gamma_eq_integral hs).symm

/-! ## 2. Locally uniform convergence on the right half-plane

The route is Cauchy's integral formula on a circle of radius `ρ` strictly larger than
the radius `r` of the disc where uniformity is wanted.  The first ingredient is the
norm bound for the resulting Cauchy-type integral. -/

/-- Bound for `∮ (ζ - s)⁻¹ • f ζ` over the circle `C(c, ρ)` by the interval integral
of `‖f‖` along the circle.  The gain `(ρ - r)⁻¹` is the distance from `s` to the
circle, which makes the bound uniform for `s` in `closedBall c r`. -/
private lemma norm_circleIntegral_inv_smul_le {f : ℂ → ℂ} {c s : ℂ} {ρ r : ℝ}
    (hρ : 0 < ρ) (hrρ : r < ρ) (hf : ContinuousOn f (closedBall c ρ))
    (hs : s ∈ closedBall c r) :
    ‖∮ ζ in C(c, ρ), (ζ - s)⁻¹ • f ζ‖
      ≤ ρ * (ρ - r)⁻¹ * ∫ θ in (0 : ℝ)..(2 * π), ‖f (circleMap c ρ θ)‖ := by
  have hρr : 0 < ρ - r := sub_pos.mpr hrρ
  have hcmap : Continuous (circleMap c ρ) := by unfold circleMap; fun_prop
  have hcont : Continuous (fun θ : ℝ => f (circleMap c ρ θ)) :=
    hf.comp_continuous hcmap fun θ => circleMap_mem_closedBall c hρ.le θ
  have hnormcont : Continuous (fun θ : ℝ => ‖f (circleMap c ρ θ)‖) := hcont.norm
  have hζdist : ∀ θ : ℝ, dist (circleMap c ρ θ) c = ρ := fun θ =>
    mem_sphere.mp (circleMap_mem_sphere c hρ.le θ)
  have hsc : dist s c ≤ r := mem_closedBall.mp hs
  have hsc' : ‖s - c‖ ≤ r := by simpa only [dist_eq_norm] using hsc
  have hdist : ∀ θ : ℝ, ρ - r ≤ ‖circleMap c ρ θ - s‖ := by
    intro θ
    have htri := dist_triangle (circleMap c ρ θ) s c
    rw [hζdist θ, dist_eq_norm, dist_eq_norm] at htri
    linarith only [htri, hsc']
  have hinv : ∀ θ : ℝ, ‖(circleMap c ρ θ - s)⁻¹‖ ≤ (ρ - r)⁻¹ := by
    intro θ
    rw [norm_inv, inv_le_inv₀ (lt_of_lt_of_le hρr (hdist θ)) hρr]
    exact hdist θ
  have hpoint : ∀ θ : ℝ,
      ‖deriv (circleMap c ρ) θ • ((circleMap c ρ θ - s)⁻¹ • f (circleMap c ρ θ))‖
        ≤ ρ * (ρ - r)⁻¹ * ‖f (circleMap c ρ θ)‖ := by
    intro θ
    rw [norm_smul, norm_smul, deriv_circleMap, norm_mul, norm_I, mul_one, norm_circleMap_zero,
      abs_of_pos hρ]
    calc ρ * (‖(circleMap c ρ θ - s)⁻¹‖ * ‖f (circleMap c ρ θ)‖)
        ≤ ρ * ((ρ - r)⁻¹ * ‖f (circleMap c ρ θ)‖) :=
          mul_le_mul_of_nonneg_left
            (mul_le_mul_of_nonneg_right (hinv θ) (norm_nonneg _)) hρ.le
      _ = ρ * (ρ - r)⁻¹ * ‖f (circleMap c ρ θ)‖ := by ring
  have hdc : Continuous (fun θ : ℝ => deriv (circleMap c ρ) θ) := by
    rw [show (fun θ : ℝ => deriv (circleMap c ρ) θ) = fun θ => circleMap 0 ρ θ * I from
      funext (deriv_circleMap c ρ)]
    unfold circleMap; fun_prop
  have h_inner : Continuous (fun θ : ℝ => (circleMap c ρ θ - s)⁻¹ • f (circleMap c ρ θ)) := by
    have hne : ∀ θ : ℝ, circleMap c ρ θ - s ≠ 0 := by
      intro θ h
      have hθ := hdist θ
      rw [h] at hθ
      simp only [norm_zero] at hθ
      linarith only [hθ, hρr]
    exact ((hcmap.sub continuous_const).inv₀ hne).smul hcont
  have hint1 : IntervalIntegrable (fun θ : ℝ =>
      ‖deriv (circleMap c ρ) θ • ((circleMap c ρ θ - s)⁻¹ • f (circleMap c ρ θ))‖)
      volume 0 (2 * π) := (hdc.smul h_inner).norm.intervalIntegrable _ _
  have hint2 : IntervalIntegrable
      (fun θ : ℝ => ρ * (ρ - r)⁻¹ * ‖f (circleMap c ρ θ)‖) volume 0 (2 * π) :=
    (continuous_const.mul hnormcont).intervalIntegrable _ _
  rw [circleIntegral]
  refine (intervalIntegral.norm_integral_le_integral_norm Real.two_pi_pos.le).trans ?_
  refine (intervalIntegral.integral_mono_on Real.two_pi_pos.le hint1 hint2
    fun θ _ => hpoint θ).trans ?_
  rw [intervalIntegral.integral_const_mul]

/-- `GammaSeq · n` converges uniformly to `Γ` on the closed ball `closedBall c r`,
provided `r < ρ` and the larger closed ball `closedBall c ρ` lies in the right
half-plane. -/
theorem tendstoUniformlyOn_GammaSeq_closedBall (c : ℂ) {r ρ : ℝ} (hρ : 0 < ρ)
    (hrρ : r < ρ) (hsub : closedBall c ρ ⊆ {s : ℂ | 0 < s.re}) :
    TendstoUniformlyOn (fun n : ℕ => fun s : ℂ => GammaSeq s n) Gamma atTop
      (closedBall c r) := by
  have hball : ∀ z ∈ closedBall c ρ, 0 < z.re := fun z hz => hsub hz
  have hsphere : ∀ z ∈ sphere c ρ, 0 < z.re := fun z hz =>
    hsub (sphere_subset_closedBall hz)
  -- `Gamma` has no poles on the closed ball, so it is differentiable there
  have hne : ∀ z ∈ closedBall c ρ, ∀ m : ℕ, z ≠ -(m : ℂ) := by
    intro z hz m h
    have hz' := hball z hz
    rw [h] at hz'
    simp at hz'
    linarith only [hz', (Nat.cast_nonneg m : (0 : ℝ) ≤ (m : ℝ))]
  -- a uniform bound for `GammaSeq · n - Γ` on the circle
  have hcontbound : ContinuousOn (fun z : ℂ => Real.Gamma z.re + ‖Gamma z‖) (sphere c ρ) := by
    refine ContinuousOn.add (continuousOn_of_forall_continuousAt fun z hz => ?_)
      ((continuousOn_of_forall_continuousAt fun z hz =>
        (Complex.differentiableAt_Gamma z (hne z (sphere_subset_closedBall hz))).continuousAt).norm)
    have hz' := hsphere z hz
    exact ((Real.differentiableAt_Gamma (s := z.re) (by
      intro m
      exact ne_of_gt (lt_of_le_of_lt (neg_nonpos.mpr (Nat.cast_nonneg m)) hz'))).continuousAt).comp
      continuous_re.continuousAt
  obtain ⟨C, hC⟩ := (isCompact_sphere c ρ).exists_bound_of_continuousOn hcontbound
  have hM : ∀ z ∈ sphere c ρ, Real.Gamma z.re + ‖Gamma z‖ ≤ C := by
    intro z hz
    have h := hC z hz
    rwa [Real.norm_eq_abs,
      abs_of_nonneg (add_nonneg (Real.Gamma_pos_of_pos (hsphere z hz)).le (norm_nonneg _))] at h
  let F : ℕ → ℂ → ℂ := fun n z => GammaSeq z n - Gamma z
  have hFbound : ∀ n z, z ∈ sphere c ρ → ‖F n z‖ ≤ C := by
    intro n z hz
    calc ‖GammaSeq z n - Gamma z‖ ≤ ‖GammaSeq z n‖ + ‖Gamma z‖ := norm_sub_le _ _
      _ ≤ Real.Gamma z.re + ‖Gamma z‖ :=
          add_le_add (norm_GammaSeq_le n (hsphere z hz)) le_rfl
      _ ≤ C := hM z hz
  have hFcont : ∀ n, ContinuousOn (F n) (closedBall c ρ) := by
    intro n
    refine ContinuousOn.sub ?_ ?_
    · exact continuousOn_of_forall_continuousAt fun z hz =>
        (differentiableAt_GammaSeq n (hball z hz)).continuousAt
    · exact continuousOn_of_forall_continuousAt fun z hz =>
        (Complex.differentiableAt_Gamma z (hne z hz)).continuousAt
  have hFdiff : ∀ n z, z ∈ ball c ρ → DifferentiableAt ℂ (F n) z := by
    intro n z hz
    refine DifferentiableAt.sub (differentiableAt_GammaSeq n (hball z (ball_subset_closedBall hz))) ?_
    exact Complex.differentiableAt_Gamma z (hne z (ball_subset_closedBall hz))
  have hDiffCont : ∀ n, DiffContOnCl ℂ (F n) (ball c ρ) := by
    intro n
    refine ⟨fun z hz => (hFdiff n z hz).differentiableWithinAt, ?_⟩
    rw [closure_ball c hρ.ne']
    exact hFcont n
  have hcmap : Continuous (circleMap c ρ) := by unfold circleMap; fun_prop
  -- the scalar sequence whose convergence drives everything
  let A : ℕ → ℝ := fun n => ∫ θ in (0 : ℝ)..(2 * π), ‖F n (circleMap c ρ θ)‖
  have hA_tendsto : Tendsto A atTop (𝓝 0) := by
    haveI : IsFiniteMeasure (volume.restrict (Ioc (0 : ℝ) (2 * π))) :=
      ⟨by rw [Measure.restrict_apply_univ, Real.volume_Ioc, sub_zero]; exact ENNReal.ofReal_lt_top⟩
    have hmeas : ∀ᶠ n : ℕ in atTop, AEStronglyMeasurable
        (fun θ : ℝ => ‖F n (circleMap c ρ θ)‖) (volume.restrict (Ioc (0 : ℝ) (2 * π))) :=
      Eventually.of_forall fun n =>
        ((hFcont n).comp_continuous hcmap
          (fun θ => circleMap_mem_closedBall c hρ.le θ)).continuousOn
          |>.aestronglyMeasurable measurableSet_Ioc |>.norm
    have hbound : ∃ C', ∀ᶠ n : ℕ in atTop,
        ∀ᵐ ω ∂(volume.restrict (Ioc (0 : ℝ) (2 * π))), ‖‖F n (circleMap c ρ ω)‖‖ ≤ C' :=
      ⟨C, Eventually.of_forall fun n => (ae_restrict_iff' measurableSet_Ioc).mpr <|
        ae_of_all _ fun ω _ =>
          (norm_norm _).le.trans (hFbound n (circleMap c ρ ω) (circleMap_mem_sphere c hρ.le ω))⟩
    have hlim : ∀ᵐ ω ∂(volume.restrict (Ioc (0 : ℝ) (2 * π))),
        Tendsto (fun n : ℕ => ‖F n (circleMap c ρ ω)‖) atTop (𝓝 0) :=
      (ae_restrict_iff' measurableSet_Ioc).mpr <| ae_of_all _ fun ω _ =>
        (by simpa [F] using
          (((Complex.GammaSeq_tendsto_Gamma (circleMap c ρ ω)).sub
            (tendsto_const_nhds (x := Gamma (circleMap c ρ ω)))).norm))
    have := MeasureTheory.tendsto_integral_filter_of_norm_le_const (l := atTop)
      (μ := volume.restrict (Ioc (0 : ℝ) (2 * π)))
      (F := fun n (θ : ℝ) => ‖F n (circleMap c ρ θ)‖) (f := fun _ => 0) hmeas hbound hlim
    rw [show A = fun n => ∫ θ, ‖F n (circleMap c ρ θ)‖
        ∂(volume.restrict (Ioc (0 : ℝ) (2 * π))) from
      funext fun n => intervalIntegral.integral_of_le Real.two_pi_pos.le]
    simpa using this
  -- the uniform Cauchy bound
  have hbound_main : ∀ n s, s ∈ closedBall c r →
      ‖F n s‖ ≤ (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹) * A n := by
    intro n s hs
    have hs_ball : s ∈ ball c ρ := by
      rw [mem_ball]
      exact lt_of_le_of_lt (mem_closedBall.mp hs) hrρ
    have hcauchy := (hDiffCont n).two_pi_i_inv_smul_circleIntegral_sub_inv_smul (f := F n) hs_ball
    calc ‖F n s‖ = ‖(2 * π * I : ℂ)⁻¹‖ * ‖∮ ζ in C(c, ρ), (ζ - s)⁻¹ • F n ζ‖ := by
          rw [← hcauchy, norm_smul]
      _ = (2 * π)⁻¹ * ‖∮ ζ in C(c, ρ), (ζ - s)⁻¹ • F n ζ‖ := by
          rw [show ‖(2 * π * I : ℂ)⁻¹‖ = (2 * π)⁻¹ by simp]
      _ ≤ (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹ * A n) :=
          mul_le_mul_of_nonneg_left
            (norm_circleIntegral_inv_smul_le hρ hrρ (hFcont n) hs) (by positivity)
      _ = (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹) * A n := by ring
  rw [Metric.tendstoUniformlyOn_iff]
  intro ε hε
  have hev : ∀ᶠ n : ℕ in atTop, (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹) * A n < ε := by
    have hlim2 : Tendsto (fun n : ℕ => (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹) * A n) atTop (𝓝 0) := by
      simpa using hA_tendsto.const_mul ((2 * π)⁻¹ * (ρ * (ρ - r)⁻¹))
    exact hlim2.eventually (Iio_mem_nhds hε)
  filter_upwards [hev] with n hn s hs
  calc dist (Gamma s) (GammaSeq s n) = ‖F n s‖ := by
        simp [F, dist_eq_norm, norm_sub_rev]
    _ ≤ (2 * π)⁻¹ * (ρ * (ρ - r)⁻¹) * A n := hbound_main n s hs
    _ < ε := hn

/-- **Locally uniform version of Euler's limit formula.**  On the right half-plane,
`GammaSeq · n` converges locally uniformly to `Γ`. -/
theorem tendstoLocallyUniformlyOn_GammaSeq :
    TendstoLocallyUniformlyOn (fun n : ℕ => fun s : ℂ => GammaSeq s n) Gamma atTop
      {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const continuous_re
  refine tendstoLocallyUniformlyOn_of_forall_exists_nhds fun x hx => ?_
  obtain ⟨ε, hε, hεsub⟩ := Metric.mem_nhds_iff.mp (hU.mem_nhds hx)
  have hsub : closedBall x (ε / 2) ⊆ {s : ℂ | 0 < s.re} := by
    intro z hz
    refine hεsub ?_
    rw [mem_ball]
    have hz' : dist z x ≤ ε / 2 := mem_closedBall.mp hz
    linarith only [hz', hε]
  have hmem : closedBall x (ε / 4) ∈ 𝓝 x :=
    Filter.mem_of_superset (ball_mem_nhds x (by positivity : (0 : ℝ) < ε / 4))
      ball_subset_closedBall
  refine ⟨{s : ℂ | 0 < s.re} ∩ closedBall x (ε / 4), inter_mem_nhdsWithin _ hmem, ?_⟩
  exact (tendstoUniformlyOn_GammaSeq_closedBall (r := ε / 4) (ρ := ε / 2) x (by positivity)
    (by linarith only [hε]) hsub).mono inter_subset_right

/-! ## 3. Weierstrass' theorem: locally uniform convergence of the derivatives -/

/-- **Iterated Weierstrass differentiation.**  From locally uniform convergence on the
right half-plane, every derivative converges locally uniformly to the corresponding
derivative of `Γ`. -/
theorem tendstoLocallyUniformlyOn_deriv_GammaSeq (k : ℕ) :
    TendstoLocallyUniformlyOn
      (fun n : ℕ => fun s : ℂ => deriv^[k] (fun w => GammaSeq w n) s)
      (fun s : ℂ => deriv^[k] Gamma s) atTop {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const continuous_re
  have hdiff : ∀ n k, DifferentiableOn ℂ
      (fun s : ℂ => deriv^[k] (fun w => GammaSeq w n) s) {s : ℂ | 0 < s.re} := by
    intro n k
    induction k with
    | zero => exact fun s hs => (differentiableAt_GammaSeq n hs).differentiableWithinAt
    | succ k ih => simpa only [Function.iterate_succ_apply'] using ih.deriv hU
  induction k with
  | zero => simpa using tendstoLocallyUniformlyOn_GammaSeq
  | succ k ih =>
    have hF : ∀ᶠ n : ℕ in atTop, DifferentiableOn ℂ
        (fun s : ℂ => deriv^[k] (fun w => GammaSeq w n) s) {s : ℂ | 0 < s.re} :=
      Eventually.of_forall fun n => hdiff n k
    have h := ih.deriv hF hU
    rwa [show (deriv ∘ fun n s => deriv^[k] (fun w => GammaSeq w n) s) =
        (fun n s => deriv^[k+1] (fun w => GammaSeq w n) s) from by
          funext n s; simp [Function.iterate_succ_apply'],
      show (deriv fun s => deriv^[k] Gamma s) = (fun s => deriv^[k+1] Gamma s) from by
          funext s; simp [Function.iterate_succ_apply']] at h

/-! ## 4. The logarithmic derivative

`logDeriv f = deriv f / f`, so locally uniform convergence of the logarithmic
derivatives follows from locally uniform convergence of `deriv` (item 3) and of the
functions themselves (item 2), together with a uniform lower bound for `‖Γ‖` on
compact subsets of the right half-plane.  The quotient lemma is proved directly. -/

/-- Uniform convergence of quotients: on a compact set where the limit denominator
is continuous and nowhere zero, quotients of uniformly convergent sequences converge
uniformly. -/
private lemma tendstoUniformlyOn_div {F G : ℕ → ℂ → ℂ} {f g : ℂ → ℂ} {K : Set ℂ}
    (hK : IsCompact K) (hF : TendstoUniformlyOn F f atTop K)
    (hG : TendstoUniformlyOn G g atTop K) (hfcont : ContinuousOn f K)
    (hgcont : ContinuousOn g K) (hg0 : ∀ s ∈ K, g s ≠ 0) :
    TendstoUniformlyOn (fun n s => F n s / G n s) (fun s => f s / g s) atTop K := by
  rcases K.eq_empty_or_nonempty with hKe | hne
  · subst hKe
    rw [Metric.tendstoUniformlyOn_iff]
    exact fun ε hε => Filter.Eventually.of_forall fun n x hx => absurd hx (Set.notMem_empty x)
  obtain ⟨s₀, hs₀K, hs₀min⟩ := hK.exists_isMinOn hne hgcont.norm
  set c : ℝ := ‖g s₀‖ with hc
  have hcpos : 0 < c := by rw [hc]; exact norm_pos_iff.mpr (hg0 s₀ hs₀K)
  obtain ⟨Mf, hMf⟩ := hK.exists_bound_of_continuousOn hfcont
  obtain ⟨Mg, hMg⟩ := hK.exists_bound_of_continuousOn hgcont
  set A : ℝ := max Mf Mg + 1 with hA
  have hMf0 : 0 ≤ Mf := (norm_nonneg _).trans (hMf s₀ hs₀K)
  have hMg0 : 0 ≤ Mg := (norm_nonneg _).trans (hMg s₀ hs₀K)
  have hApos : 0 < A := by rw [hA]; positivity
  have hfA : ∀ s ∈ K, ‖f s‖ ≤ A := fun s hs =>
    (hMf s hs).trans (le_trans (le_max_left Mf Mg) (le_of_lt (lt_add_one _)))
  have hgA : ∀ s ∈ K, ‖g s‖ ≤ A := fun s hs =>
    (hMg s hs).trans (le_trans (le_max_right Mf Mg) (le_of_lt (lt_add_one _)))
  rw [Metric.tendstoUniformlyOn_iff]
  intro ε hε
  have hδpos : 0 < ε * c ^ 2 / (8 * A) := by positivity
  have hhpos : 0 < c / 2 := by positivity
  filter_upwards [Metric.tendstoUniformlyOn_iff.mp hF _ hδpos,
    Metric.tendstoUniformlyOn_iff.mp hG _ hδpos,
    Metric.tendstoUniformlyOn_iff.mp hG _ hhpos] with n hFn hGn hGn2
  intro s hs
  rw [dist_comm, dist_eq_norm]
  have hgs : c ≤ ‖g s‖ := by rw [hc]; exact hs₀min hs
  have hGpos : c / 2 ≤ ‖G n s‖ := by
    have h1 : ‖g s‖ - ‖G n s‖ ≤ ‖g s - G n s‖ := norm_sub_norm_le _ _
    have h2 : ‖g s - G n s‖ < c / 2 := by
      have h := hGn2 s hs
      rwa [dist_eq_norm] at h
    linarith only [h1, h2, hgs]
  have hGne : G n s ≠ 0 := norm_pos_iff.mp (lt_of_lt_of_le hhpos hGpos)
  have hgne : g s ≠ 0 := hg0 s hs
  have hnum : ‖F n s * g s - f s * G n s‖ ≤ 2 * A * (ε * c ^ 2 / (8 * A)) := by
    have hsplit : F n s * g s - f s * G n s =
        (F n s - f s) * g s + f s * (g s - G n s) := by ring
    rw [hsplit]
    have h1 : ‖F n s - f s‖ < ε * c ^ 2 / (8 * A) := by
      have h := hFn s hs
      rwa [dist_eq_norm, norm_sub_rev] at h
    have h2 : ‖g s - G n s‖ < ε * c ^ 2 / (8 * A) := by
      have h := hGn s hs
      rwa [dist_eq_norm] at h
    calc ‖(F n s - f s) * g s + f s * (g s - G n s)‖
        ≤ ‖(F n s - f s) * g s‖ + ‖f s * (g s - G n s)‖ := norm_add_le _ _
      _ = ‖F n s - f s‖ * ‖g s‖ + ‖f s‖ * ‖g s - G n s‖ := by rw [norm_mul, norm_mul]
      _ ≤ (ε * c ^ 2 / (8 * A)) * A + A * (ε * c ^ 2 / (8 * A)) := by
          refine add_le_add ?_ ?_
          · exact mul_le_mul h1.le (hgA s hs) (norm_nonneg _) hδpos.le
          · exact mul_le_mul (hfA s hs) h2.le (norm_nonneg _) hApos.le
      _ = 2 * A * (ε * c ^ 2 / (8 * A)) := by ring
  have hden : (c / 2) * c ≤ ‖G n s‖ * ‖g s‖ :=
    mul_le_mul hGpos hgs (norm_nonneg _) (by positivity)
  calc ‖F n s / G n s - f s / g s‖
      = ‖F n s * g s - f s * G n s‖ / (‖G n s‖ * ‖g s‖) := by
        rw [div_sub_div (F n s) (f s) hGne hgne, norm_div, norm_mul, mul_comm (G n s) (f s)]
    _ ≤ (2 * A * (ε * c ^ 2 / (8 * A))) / ((c / 2) * c) :=
        div_le_div₀ ((norm_nonneg _).trans hnum) hnum (mul_pos hhpos hcpos) hden
    _ = ε / 2 := by
        field_simp
        ring
    _ < ε := by linarith only [hε]

/-- Locally uniform version of the previous lemma. -/
private lemma tendstoLocallyUniformlyOn_div {F G : ℕ → ℂ → ℂ} {f g : ℂ → ℂ} {U : Set ℂ}
    (hU : IsOpen U) (hF : TendstoLocallyUniformlyOn F f atTop U)
    (hG : TendstoLocallyUniformlyOn G g atTop U) (hfcont : ContinuousOn f U)
    (hgcont : ContinuousOn g U) (hg0 : ∀ s ∈ U, g s ≠ 0) :
    TendstoLocallyUniformlyOn (fun n s => F n s / G n s) (fun s => f s / g s) atTop U := by
  rw [tendstoLocallyUniformlyOn_iff_forall_isCompact hU] at hF hG ⊢
  exact fun K hKU hK => tendstoUniformlyOn_div hK (hF K hKU hK) (hG K hKU hK)
    (hfcont.mono hKU) (hgcont.mono hKU) fun s hs => hg0 s (hKU hs)

/-- **The logarithmic derivative converges locally uniformly.** -/
theorem tendstoLocallyUniformlyOn_logDeriv_GammaSeq :
    TendstoLocallyUniformlyOn (fun n : ℕ => logDeriv (fun w => GammaSeq w n))
      (logDeriv Gamma) atTop {s : ℂ | 0 < s.re} := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const continuous_re
  have hdiffGamma : DifferentiableOn ℂ Gamma {s : ℂ | 0 < s.re} := fun z hz =>
    (Complex.differentiableAt_Gamma z (by
      intro m h
      have hz' := hz
      rw [h] at hz'
      simp at hz'
      linarith only [hz', (Nat.cast_nonneg m : (0 : ℝ) ≤ (m : ℝ))])).differentiableWithinAt
  have hF : TendstoLocallyUniformlyOn (fun n : ℕ => fun s : ℂ => deriv (fun w => GammaSeq w n) s)
      (fun s : ℂ => deriv Gamma s) atTop {s : ℂ | 0 < s.re} := by
    simpa only [Function.iterate_one] using tendstoLocallyUniformlyOn_deriv_GammaSeq 1
  have h := tendstoLocallyUniformlyOn_div hU hF tendstoLocallyUniformlyOn_GammaSeq
    (hdiffGamma.deriv hU).continuousOn hdiffGamma.continuousOn
    (fun s hs => Complex.Gamma_ne_zero_of_re_pos hs)
  have hA' : (fun n : ℕ => logDeriv (fun w => GammaSeq w n)) =
      (fun n : ℕ => fun s : ℂ => deriv (fun w => GammaSeq w n) s / GammaSeq s n) := by
    funext n s; exact logDeriv_apply _ _
  have hB' : logDeriv Gamma = (fun s : ℂ => deriv Gamma s / Gamma s) := by
    funext s; exact logDeriv_apply _ _
  rwa [hA', hB']

/-- **The explicit logarithmic derivative of the Euler product term.**  For `n ≠ 0`
and `0 < re s`,
`logDeriv (GammaSeq · n) s = log n - ∑_{j≤n} (s+j)⁻¹`. -/
theorem logDeriv_GammaSeq (n : ℕ) (hn : n ≠ 0) {s : ℂ} (hs : 0 < s.re) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
  have hnC : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  have hcast : ((n.factorial : ℕ) : ℂ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
  have hterm : ∀ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ≠ 0 := by
    intro j _hj
    have hjr : (j : ℂ).re = (j : ℝ) := by simp
    have hpos : 0 < (s + (j : ℂ)).re := by
      rw [add_re, hjr]
      linarith only [hs, (Nat.cast_nonneg j : (0 : ℝ) ≤ (j : ℝ))]
    exact fun h => hpos.ne' (by simp [h])
  have hPne : (∏ j ∈ Finset.range (n + 1), (s + (j : ℂ))) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr hterm
  have hlin : ∀ j ∈ Finset.range (n + 1),
      DifferentiableAt ℂ (fun w : ℂ => w + (j : ℂ)) s := fun j _ => by fun_prop
  have hnum : DifferentiableAt ℂ
      (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) s :=
    (differentiableAt_id.const_cpow (Or.inl hnC)).mul (differentiableAt_const _)
  have hden : DifferentiableAt ℂ
      (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s := by
    rw [show (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) =
        (∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ))) from by
      funext w
      exact (Finset.prod_apply w (Finset.range (n + 1)) (fun j (w : ℂ) => w + (j : ℂ))).symm]
    exact DifferentiableAt.finsetProd hlin
  have hNne : ((n : ℂ) ^ s * ((n.factorial : ℕ) : ℂ)) ≠ 0 :=
    mul_ne_zero (cpow_ne_zero_iff.mpr (Or.inl hnC)) hcast
  have hfun : (fun w : ℂ => GammaSeq w n) =
      (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) /
        (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) := by
    funext w
    simp only [Pi.div_apply, GammaSeq, div_eq_mul_inv, mul_assoc]
  rw [hfun, show logDeriv ((fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) /
        (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ)))) s =
      logDeriv (fun w : ℂ => (n : ℂ) ^ w * ((n.factorial : ℕ) : ℂ)) s -
        logDeriv (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s from
      logDeriv_div s hNne hPne hnum hden,
    logDeriv_mul_const s ((n.factorial : ℕ) : ℂ) hcast,
    Complex.logDeriv_const_cpow hnC]
  have hP : logDeriv (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) s
      = ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
    rw [show (fun w : ℂ => ∏ j ∈ Finset.range (n + 1), (w + (j : ℂ))) =
        (∏ j ∈ Finset.range (n + 1), (fun w : ℂ => w + (j : ℂ))) from by
      funext w
      exact (Finset.prod_apply w (Finset.range (n + 1)) (fun j (w : ℂ) => w + (j : ℂ))).symm]
    rw [logDeriv_prod (fun j hj => hterm j hj) (fun j hj => hlin j hj)]
    refine Finset.sum_congr rfl fun j _ => ?_
    have hd : HasDerivAt (fun w : ℂ => w + (j : ℂ)) 1 s := (hasDerivAt_id s).add_const (j : ℂ)
    rw [logDeriv_apply, hd.deriv, one_div]
  rw [hP]

end

end Rh45RouteBAnalytic
