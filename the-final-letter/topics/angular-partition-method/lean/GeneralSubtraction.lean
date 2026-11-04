import RegularizedIntegral

/-!
# O8, first brick: the kernel `1/(e^t-1) - 1/t` is analytic at zero

The general Bernoulli subtraction needs the function

`g t = 1/(e^t - 1) - 1/t`

to be smooth at `0`, with a Taylor expansion to every order. This file proves
the foundation: the complex version has a removable singularity at `0`, so it
extends to a function analytic at `0`.

The estimates are the standard ones:

* `‖exp z - 1 - z‖ ≤ ‖z‖²` for `‖z‖ ≤ 1` (`Complex.norm_exp_sub_one_sub_id_le`);
* hence `‖exp z - 1‖ ≥ ‖z‖/2` on `‖z‖ ≤ 1`;
* hence `‖1/(exp z - 1) - 1/z‖ ≤ 2` on `0 < ‖z‖ ≤ 1/2`.

Every step is proved. The Taylor-polynomial extraction and the Mellin
identity for arbitrary order are the next files, not this one.
-/

open Complex Metric Set Filter MeasureTheory
open scoped Topology

noncomputable section

namespace AngularPartition

/-- The complex kernel `1/(e^z-1) - 1/z`, with the value at `0` left to the
removable-singularity extension. -/
noncomputable def generalKernelC (z : ℂ) : ℂ :=
  1 / (Complex.exp z - 1) - 1 / z

/-- Lower bound for `‖exp z - 1‖` near zero. -/
theorem norm_exp_sub_one_ge {z : ℂ} (hz : ‖z‖ ≤ 1 / 2) :
    ‖z‖ / 2 ≤ ‖Complex.exp z - 1‖ := by
  have h1 : ‖z‖ ≤ ‖Complex.exp z - 1‖ + ‖Complex.exp z - 1 - z‖ := by
    calc
      ‖z‖ = ‖(Complex.exp z - 1) - (Complex.exp z - 1 - z)‖ := by ring_nf
      _ ≤ ‖Complex.exp z - 1‖ + ‖Complex.exp z - 1 - z‖ := norm_sub_le _ _
  have h2 : ‖Complex.exp z - 1 - z‖ ≤ ‖z‖ ^ 2 :=
    Complex.norm_exp_sub_one_sub_id_le (by linarith : ‖z‖ ≤ 1)
  have h3 : ‖z‖ ^ 2 ≤ ‖z‖ / 2 := by
    nlinarith [norm_nonneg z]
  linarith

/-- The kernel is bounded near zero: `‖1/(e^z-1) - 1/z‖ ≤ 2` on
`0 < ‖z‖ ≤ 1/2`. -/
theorem norm_generalKernelC_le {z : ℂ} (hz0 : z ≠ 0) (hz : ‖z‖ ≤ 1 / 2) :
    ‖generalKernelC z‖ ≤ 2 := by
  have hz1 : ‖z‖ ≤ 1 := by linarith
  have hge : ‖z‖ / 2 ≤ ‖Complex.exp z - 1‖ := norm_exp_sub_one_ge hz
  have hne : Complex.exp z - 1 ≠ 0 := by
    intro h
    rw [h, norm_zero] at hge
    have hz' : ‖z‖ = 0 := by linarith [norm_nonneg z]
    exact hz0 (norm_eq_zero.mp hz')
  have hnum : ‖z - (Complex.exp z - 1)‖ ≤ ‖z‖ ^ 2 := by
    rw [show z - (Complex.exp z - 1) = -(Complex.exp z - 1 - z) by ring, norm_neg]
    exact Complex.norm_exp_sub_one_sub_id_le hz1
  have hzpos : 0 < ‖z‖ := norm_pos_iff.mpr hz0
  have hEq : generalKernelC z =
      (z - (Complex.exp z - 1)) / (z * (Complex.exp z - 1)) := by
    rw [generalKernelC]
    field_simp [hz0, hne]
  rw [hEq, norm_div, norm_mul]
  have hden' : 0 < ‖z‖ * ‖Complex.exp z - 1‖ :=
    mul_pos hzpos (by linarith)
  rw [div_le_iff₀ hden']
  have hE2 : ‖z‖ ^ 2 ≤ 2 * (‖z‖ * ‖Complex.exp z - 1‖) := by
    nlinarith [hge, norm_nonneg z]
  linarith [hnum, hE2]

/-- **Removable singularity at zero.** The kernel `1/(e^z-1) - 1/z` extends to
a function analytic at `0`. This is the analytic input for the Taylor-remainder
induction: the extension has a Taylor expansion to every order. -/
theorem analyticAt_generalKernelC_zero :
    AnalyticAt ℂ (Function.update generalKernelC 0 (limUnder (𝓝[≠] 0) generalKernelC)) 0 := by
  have hmem : ball (0 : ℂ) (1 / 2) ∈ 𝓝 0 := ball_mem_nhds 0 (by norm_num)
  have hd : DifferentiableOn ℂ generalKernelC ((ball (0 : ℂ) (1 / 2)) \ {0}) := by
    intro z hz
    have hz0 : z ≠ 0 := hz.2
    have hzball : ‖z‖ < 1 / 2 := by
      simpa [mem_ball, dist_zero_right] using hz.1
    have hz1 : ‖z‖ ≤ 1 := by linarith
    have hge : ‖z‖ / 2 ≤ ‖Complex.exp z - 1‖ := norm_exp_sub_one_ge (le_of_lt hzball)
    have hne : Complex.exp z - 1 ≠ 0 := by
      intro h
      rw [h, norm_zero] at hge
      have hz' : ‖z‖ = 0 := by linarith [norm_nonneg z]
      exact hz0 (norm_eq_zero.mp hz')
    have h1 : DifferentiableAt ℂ (fun z : ℂ => 1 / (Complex.exp z - 1)) z :=
      (differentiableAt_const (1 : ℂ)).div
        (by fun_prop : DifferentiableAt ℂ (fun z : ℂ => Complex.exp z - 1) z) hne
    have h2 : DifferentiableAt ℂ (fun z : ℂ => 1 / z) z :=
      (differentiableAt_const (1 : ℂ)).div differentiableAt_id hz0
    exact (h1.sub h2).differentiableWithinAt
  have hb : BddAbove ((norm ∘ generalKernelC) '' ((ball (0 : ℂ) (1 / 2)) \ {0})) := by
    refine ⟨2, ?_⟩
    rintro _ ⟨z, hz, rfl⟩
    have hzball : ‖z‖ < 1 / 2 := by
      simpa [mem_ball, dist_zero_right] using hz.1
    exact norm_generalKernelC_le hz.2 (le_of_lt hzball)
  have hdiff := Complex.differentiableOn_update_limUnder_of_bddAbove
    (c := 0) (s := ball (0 : ℂ) (1 / 2)) hmem hd hb
  have ha : AnalyticOnNhd ℂ
      (Function.update generalKernelC 0 (limUnder (𝓝[≠] 0) generalKernelC)) (ball (0 : ℂ) (1 / 2)) :=
    hdiff.analyticOnNhd isOpen_ball
  exact ha 0 (mem_ball_self (by norm_num))

/-- The analytic extension of the kernel at zero. -/
noncomputable def generalKernelExt : ℂ → ℂ :=
  Function.update generalKernelC 0 (limUnder (𝓝[≠] 0) generalKernelC)

/-- The analytic extension is analytic at zero. -/
theorem analyticAt_generalKernelExt_zero : AnalyticAt ℂ generalKernelExt 0 :=
  analyticAt_generalKernelC_zero

/-- **Taylor remainder.** For every order `n` there is a power series at `0`
whose `n`-th partial sum approximates the analytic extension with remainder
`O(‖z‖^n)`. This is the Taylor input of the general Bernoulli subtraction. -/
theorem exists_taylorRemainder (n : ℕ) :
    ∃ p : FormalMultilinearSeries ℂ ℂ ℂ,
      HasFPowerSeriesAt generalKernelExt p 0 ∧
      (fun z : ℂ => generalKernelExt z - p.partialSum n z)
        =O[𝓝 0] fun z => ‖z‖ ^ n := by
  obtain ⟨p, hp⟩ := analyticAt_generalKernelExt_zero
  exact ⟨p, hp, by simpa using hp.isBigO_sub_partialSum_pow n⟩

/-- The `n`-th partial sum of a complex formal power series is the polynomial
`Σ_{k<n} c_k z^k`, with `c_k = p.coeff k`. -/
theorem partialSum_eq_sum_coeff (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) (z : ℂ) :
    p.partialSum n z = ∑ k ∈ Finset.range n, p.coeff k * z ^ k := by
  rw [FormalMultilinearSeries.partialSum]
  refine Finset.sum_congr rfl ?_
  intro k _
  rw [FormalMultilinearSeries.apply_eq_prod_smul_coeff]
  simp [Finset.prod_const, smul_eq_mul, mul_comm]

/-- The real zeta kernel `1/(e^t-1)`. -/
noncomputable def zetaKernelR (t : ℝ) : ℂ :=
  1 / (Complex.exp (t : ℂ) - 1)

/-- The degree-`n` cutoff `1/t + P_n(t)` on `(0,1]`, zero elsewhere, written in
the `cpow`-indicator form used by Mathlib's Mellin lemmas. -/
noncomputable def cutoffN (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) (t : ℝ) : ℂ :=
  Set.indicator (Set.Ioc (0 : ℝ) 1)
    (fun t => (t : ℂ) ^ (-1 : ℂ) +
      ∑ k ∈ Finset.range n, p.coeff k * (t : ℂ) ^ (k : ℂ)) t

/-- The `n`-th subtracted kernel `f - (1/t + P_n)` below `1`, and `f` above. -/
noncomputable def subtractedKernel (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) (t : ℝ) : ℂ :=
  zetaKernelR t - cutoffN p n t

/-- **The `n`-th subtracted kernel is `O(t^n)` at zero.** This is the real
form of the Taylor remainder: it is the hypothesis needed by
`mellinConvergent_of_isBigO_rpow_exp` for the strip `Re s > -n`. -/
theorem subtractedKernel_isBigO_zero (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ)
    (hp : HasFPowerSeriesAt generalKernelExt p 0) :
    (fun t : ℝ => subtractedKernel p n t) =O[𝓝[>] 0] fun t : ℝ => t ^ n := by
  have heq : (fun t : ℝ => subtractedKernel p n t) =ᶠ[𝓝[>] 0]
      (fun t : ℝ => generalKernelExt (t : ℂ) - p.partialSum n (t : ℂ)) := by
    filter_upwards [self_mem_nhdsWithin,
      nhdsWithin_le_nhds (Iio_mem_nhds (by norm_num : (0 : ℝ) < 1))] with t ht0 ht1
    have ht0' : t ≠ 0 := ne_of_gt ht0
    have ht1' : t < 1 := ht1
    have htmem : t ∈ Set.Ioc (0 : ℝ) 1 := ⟨ht0, le_of_lt ht1'⟩
    simp [subtractedKernel, zetaKernelR, cutoffN, Set.indicator_of_mem htmem,
      Complex.cpow_neg_one, Complex.cpow_natCast, partialSum_eq_sum_coeff,
      generalKernelExt, generalKernelC, Function.update, ht0']
    ring
  have hcomp0 : (fun t : ℝ => generalKernelExt (t : ℂ) - p.partialSum n (t : ℂ))
      =O[𝓝 0] fun t : ℝ => ‖(t : ℂ)‖ ^ n := by
    simpa [Function.comp_def] using
      (hp.isBigO_sub_partialSum_pow n).comp_tendsto
        (show Tendsto (fun t : ℝ => (t : ℂ)) (𝓝 0) (𝓝 0) from by
          simpa using Complex.continuous_ofReal.tendsto 0)
  have hcomp : (fun t : ℝ => generalKernelExt (t : ℂ) - p.partialSum n (t : ℂ))
      =O[𝓝[>] 0] fun t : ℝ => ‖(t : ℂ)‖ ^ n := hcomp0.mono nhdsWithin_le_nhds
  have hnorm : (fun t : ℝ => ‖(t : ℂ)‖ ^ n) =ᶠ[𝓝[>] 0] fun t : ℝ => t ^ n := by
    filter_upwards [self_mem_nhdsWithin] with t ht
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_pos ht]
  exact hcomp.congr' heq.symm hnorm

/-- The `1/t` part of the cutoff. -/
noncomputable def cutoffMain (t : ℝ) : ℂ :=
  Set.indicator (Set.Ioc (0 : ℝ) 1) (fun t => (t : ℂ) ^ (-1 : ℂ)) t

/-- The `k`-th monomial part of the cutoff. -/
noncomputable def cutoffTerm (p : FormalMultilinearSeries ℂ ℂ ℂ) (k : ℕ) (t : ℝ) : ℂ :=
  Set.indicator (Set.Ioc (0 : ℝ) 1) (fun t => p.coeff k * (t : ℂ) ^ (k : ℂ)) t

/-- A finite sum of Mellin transforms. -/
theorem hasMellin_finset_sum {ι : Type*} (s : Finset ι) (f : ι → ℝ → ℂ) (v : ι → ℂ)
    {z : ℂ} (h : ∀ i ∈ s, HasMellin (f i) z (v i)) :
    HasMellin (fun t => ∑ i ∈ s, f i t) z (∑ i ∈ s, v i) := by
  classical
  induction s using Finset.induction with
  | empty =>
      constructor
      · simp [MellinConvergent]
      · simp [mellin]
  | insert a s ha ih =>
      have ha' : HasMellin (f a) z (v a) := h a (Finset.mem_insert_self a s)
      have hs' : ∀ i ∈ s, HasMellin (f i) z (v i) :=
        fun i hi => h i (Finset.mem_insert_of_mem hi)
      have ih' := ih hs'
      have hadd := hasMellin_add ha'.1 ih'.1
      have hfun : (fun t => ∑ i ∈ insert a s, f i t)
          = fun t => f a t + ∑ i ∈ s, f i t := by
        funext t
        rw [Finset.sum_insert ha]
      rw [hfun, Finset.sum_insert ha, ← ha'.2, ← ih'.2]
      exact hadd

/-- **Cutoff transform.** The Mellin transform of the polynomial cutoff
`1/t + P_n(t)` on `(0,1]` is `1/(s-1) + Σ_{k<n} c_k/(s+k)` for `Re s > 1`. -/
theorem hasMellin_cutoffN (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) {s : ℂ}
    (hs : 1 < s.re) :
    HasMellin (cutoffN p n) s
      (1 / (s - 1) + ∑ k ∈ Finset.range n, p.coeff k * (1 / (s + (k : ℂ)))) := by
  have hmain : HasMellin cutoffMain s (1 / (s - 1)) := by
    have h := hasMellin_cpow_Ioc (-1 : ℂ) (s := s) (by simpa using hs)
    have hfun : cutoffMain =
        Set.indicator (Set.Ioc (0 : ℝ) 1) (fun t => (t : ℂ) ^ (-1 : ℂ)) := rfl
    rw [hfun]
    refine ⟨h.1, ?_⟩
    rw [h.2]
    congr 1
  have hterms : ∀ k ∈ Finset.range n,
      HasMellin (cutoffTerm p k) s (p.coeff k * (1 / (s + (k : ℂ)))) := by
    intro k _
    have hkpos : 0 < (s + (k : ℂ)).re := by
      rw [Complex.add_re]
      have hk0 : (0 : ℝ) ≤ (k : ℝ) := Nat.cast_nonneg k
      have hkre : ((k : ℂ)).re = (k : ℝ) := by simp
      rw [hkre]
      linarith
    have h := hasMellin_cpow_Ioc (k : ℂ) (s := s) hkpos
    have hc := hasMellin_const_smul h.1 (p.coeff k)
    have hc' : HasMellin (fun t => p.coeff k *
        (Set.indicator (Set.Ioc (0 : ℝ) 1) (fun t => (t : ℂ) ^ (k : ℂ)) t)) s
        (p.coeff k * (1 / (s + (k : ℂ)))) := by
      refine ⟨?_, ?_⟩
      · simpa [smul_eq_mul] using hc.1
      · have h2 := hc.2
        simp only [smul_eq_mul] at h2
        rw [h2, h.2]
    have hfun : cutoffTerm p k = fun t => p.coeff k *
        (Set.indicator (Set.Ioc (0 : ℝ) 1) (fun t => (t : ℂ) ^ (k : ℂ)) t) := by
      funext t
      by_cases ht : t ∈ Set.Ioc (0 : ℝ) 1 <;> simp [cutoffTerm, ht]
    rw [hfun]
    exact hc'
  have hsum := hasMellin_finset_sum (Finset.range n) (cutoffTerm p)
    (fun k => p.coeff k * (1 / (s + (k : ℂ)))) hterms
  have hall := hasMellin_add hmain.1 hsum.1
  have hfun : cutoffN p n =
      fun t => cutoffMain t + ∑ k ∈ Finset.range n, cutoffTerm p k t := by
    funext t
    by_cases ht : t ∈ Set.Ioc (0 : ℝ) 1 <;>
      simp [cutoffN, cutoffMain, cutoffTerm, ht]
  rw [hfun]
  exact ⟨hall.1, by rw [hall.2, hmain.2, hsum.2]⟩

/-- `zetaKernelR` is the dossier's `zetaKernel`. -/
lemma zetaKernelR_eq_zetaKernel : zetaKernelR = zetaKernel := by
  funext t
  simp [zetaKernelR, zetaKernel, Complex.ofReal_exp]

/-- **Finite-part identity (convergence domain).** For `Re s > 1` and every
order `n`,
`mellin K_n(s) = Γ(s)ζ(s) − 1/(s−1) − Σ_{k<n} c_k/(s+k)`. -/
theorem mellin_subtractedKernel_eq (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ)
    {s : ℂ} (hs : 1 < s.re) :
    mellin (subtractedKernel p n) s =
      Complex.Gamma s * riemannZeta s -
        (1 / (s - 1) + ∑ k ∈ Finset.range n, p.coeff k * (1 / (s + (k : ℂ)))) := by
  have hz : HasMellin zetaKernelR s (Complex.Gamma s * riemannZeta s) := by
    rw [zetaKernelR_eq_zetaKernel]
    exact ⟨mellinConvergent_zetaKernel hs, mellin_zetaKernel_eq_Gamma_mul_zeta hs⟩
  have hc := hasMellin_cutoffN p n hs
  have hsub := hasMellin_sub hz.1 hc.1
  change mellin (fun t => zetaKernelR t - cutoffN p n t) s = _
  rw [hsub.2, hz.2, hc.2]



/-- Continuity of the zeta kernel on the positive axis. -/
theorem continuousOn_zetaKernelR : ContinuousOn zetaKernelR (Ioi 0) := by
  apply ContinuousOn.div
  · exact continuousOn_const
  · exact (Complex.continuous_exp.comp continuous_ofReal).continuousOn.sub continuousOn_const
  · intro t ht
    have h1 : 1 < Real.exp t := Real.one_lt_exp_iff.mpr ht
    have h2 : (Real.exp t - 1) ≠ 0 := by linarith
    have h3 : ((Real.exp t - 1 : ℝ) : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr h2
    simpa [zetaKernelR, Complex.ofReal_exp] using h3

/-- Continuity of the cutoff polynomial `1/t + P_n(t)` on the positive axis. -/
theorem continuousOn_cutoffFormula (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) :
    ContinuousOn (fun t : ℝ => (t : ℂ) ^ (-1 : ℂ) +
      ∑ k ∈ Finset.range n, p.coeff k * (t : ℂ) ^ (k : ℂ)) (Ioi 0) := by
  have hbase : ContinuousOn (fun t : ℝ => (t : ℂ)) (Ioi 0) := continuous_ofReal.continuousOn
  have hmem : ∀ t ∈ Ioi (0 : ℝ), (t : ℂ) ∈ Complex.slitPlane :=
    fun t ht => Complex.ofReal_mem_slitPlane.2 ht
  refine ContinuousOn.add (hbase.cpow_const hmem) ?_
  refine continuousOn_finsetSum (Finset.range n) ?_
  intro k _
  exact continuousOn_const.mul (hbase.cpow_const hmem)

/-- The subtracted kernel is locally integrable on the positive axis. -/
theorem locallyIntegrableOn_subtractedKernel (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) :
    LocallyIntegrableOn (subtractedKernel p n) (Ioi 0) := by
  rw [locallyIntegrableOn_iff isOpen_Ioi.isLocallyClosed]
  intro k hk hkcomp
  have hk1 : IntegrableOn (subtractedKernel p n) (k ∩ Iic 1) := by
    have hcomp : IsCompact (k ∩ Iic 1) := hkcomp.inter_right isClosed_Iic
    refine ContinuousOn.integrableOn_compact hcomp ?_
    have hsub : k ∩ Iic 1 ⊆ Ioi 0 := fun t ht => hk ht.1
    have heq : EqOn (subtractedKernel p n)
        (fun t : ℝ => zetaKernelR t - ((t : ℂ) ^ (-1 : ℂ) +
          ∑ j ∈ Finset.range n, p.coeff j * (t : ℂ) ^ (j : ℂ))) (k ∩ Iic 1) := by
      intro t ht
      have ht0 : 0 < t := hk ht.1
      have htmem : t ∈ Set.Ioc (0 : ℝ) 1 := ⟨ht0, ht.2⟩
      simp [subtractedKernel, cutoffN, Set.indicator_of_mem htmem]
    exact ((continuousOn_zetaKernelR.mono hsub).sub
      ((continuousOn_cutoffFormula p n).mono hsub)).congr heq
  have hk2 : IntegrableOn (subtractedKernel p n) (k ∩ Ici 1) := by
    have hcomp : IsCompact (k ∩ Ici 1) := hkcomp.inter_right isClosed_Ici
    have hcont : ContinuousOn zetaKernelR (k ∩ Ici 1) :=
      continuousOn_zetaKernelR.mono (fun t ht => hk ht.1)
    have hint : IntegrableOn zetaKernelR (k ∩ Ici 1) :=
      ContinuousOn.integrableOn_compact hcomp hcont
    refine hint.congr_fun_ae ?_
    have hae1 : ∀ᵐ t ∂(volume.restrict (k ∩ Ici 1)), t ≠ 1 := by
      rw [MeasureTheory.ae_iff]
      simp
    filter_upwards [MeasureTheory.ae_restrict_mem
      (hkcomp.measurableSet.inter measurableSet_Ici), hae1] with t ht ht1ne
    have ht1 : 1 ≤ t := ht.2
    have hnot : t ∉ Set.Ioc (0 : ℝ) 1 := by
      intro hmem
      exact ht1ne (le_antisymm hmem.2 ht1)
    simp [subtractedKernel, cutoffN, Set.indicator_of_notMem hnot]
  have hunion : (k ∩ Iic 1) ∪ (k ∩ Ici 1) = k := by
    ext t
    constructor
    · rintro (⟨ht, _⟩ | ⟨ht, _⟩) <;> exact ht
    · intro ht
      rcases le_or_gt t 1 with h | h
      · exact Or.inl ⟨ht, h⟩
      · exact Or.inr ⟨ht, le_of_lt h⟩
  rw [← hunion]
  exact hk1.union hk2


/-- The subtracted kernel decays exponentially at infinity. -/
theorem subtractedKernel_isBigO_atTop (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ) :
    (fun t : ℝ => subtractedKernel p n t) =O[atTop] fun t : ℝ => Real.exp (-t) := by
  refine Asymptotics.IsBigO.of_bound 2 ?_
  filter_upwards [Filter.eventually_gt_atTop (1 : ℝ)] with t ht
  have hnot : t ∉ Set.Ioc (0 : ℝ) 1 := by
    intro hmem
    linarith [hmem.2]
  have hker : subtractedKernel p n t = zetaKernel t := by
    simp [subtractedKernel, cutoffN, Set.indicator_of_notMem hnot, zetaKernelR_eq_zetaKernel]
  rw [hker]
  have hle := norm_zetaKernel_le_two_exp_neg (le_of_lt ht)
  simpa [Real.norm_eq_abs, abs_of_pos (Real.exp_pos _)] using hle

/-- **Convergence beyond the tripled strip (arbitrary order).** The `n`-th
subtracted annular integral converges on `Re s > -n`. -/
theorem mellinConvergent_subtractedKernel (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ)
    (hp : HasFPowerSeriesAt generalKernelExt p 0) {s : ℂ} (hs : -(n : ℝ) < s.re) :
    MellinConvergent (subtractedKernel p n) s := by
  refine mellinConvergent_of_isBigO_rpow_exp (a := 1) (b := -(n : ℝ)) one_pos
    (locallyIntegrableOn_subtractedKernel p n) ?_ ?_ hs
  · simpa [one_mul] using subtractedKernel_isBigO_atTop p n
  · simpa [Real.rpow_natCast] using subtractedKernel_isBigO_zero p n hp

/-- **Holomorphy beyond the tripled strip (arbitrary order).** -/
theorem mellin_differentiableAt_subtractedKernel (p : FormalMultilinearSeries ℂ ℂ ℂ) (n : ℕ)
    (hp : HasFPowerSeriesAt generalKernelExt p 0) {s : ℂ} (hs : -(n : ℝ) < s.re) :
    DifferentiableAt ℂ (mellin (subtractedKernel p n)) s := by
  refine mellin_differentiableAt_of_isBigO_rpow_exp (a := 1) (b := -(n : ℝ)) one_pos
    (locallyIntegrableOn_subtractedKernel p n) ?_ ?_ hs
  · simpa [one_mul] using subtractedKernel_isBigO_atTop p n
  · simpa [Real.rpow_natCast] using subtractedKernel_isBigO_zero p n hp


/-- **Kernel identity.** For `z` away from `0` and the poles of the kernel,
`z·(e^z−1)·g(z) = z − (e^z−1)`. This is the algebraic identity whose power
series comparison identifies the Taylor coefficients with `(B−1)/X`. -/
theorem kernel_mul_identity {z : ℂ} (hz : z ≠ 0) (he : Complex.exp z ≠ 1) :
    z * (Complex.exp z - 1) * generalKernelExt z = z - (Complex.exp z - 1) := by
  simp only [generalKernelExt, Function.update_of_ne hz, generalKernelC]
  field_simp [hz, sub_ne_zero.mpr he]

end AngularPartition
