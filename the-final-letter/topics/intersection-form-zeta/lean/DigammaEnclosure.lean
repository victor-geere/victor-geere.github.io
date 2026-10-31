import GammaProduct
import EulerMaclaurin

open Complex Filter MeasureTheory
open scoped Topology BigOperators

namespace IntersectionForm

theorem logDeriv_GammaSeq_of_ne (n : ℕ) (hn : n ≠ 0) {s : ℂ}
    (hs : ∀ j ≤ n, s + (j : ℂ) ≠ 0) :
    logDeriv (fun w : ℂ => GammaSeq w n) s
      = Complex.log (n : ℂ) - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹ := by
  have hnC : (n : ℂ) ≠ 0 := Nat.cast_ne_zero.mpr hn
  have hcast : ((n.factorial : ℕ) : ℂ) ≠ 0 :=
    Nat.cast_ne_zero.mpr (Nat.factorial_ne_zero n)
  have hterm : ∀ j ∈ Finset.range (n + 1), (s + (j : ℂ)) ≠ 0 := fun j hj =>
    hs j (Nat.lt_succ_iff.mp (Finset.mem_range.mp hj))
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

/-- The Gauss partial-sum form of `ψ` on the right half-plane. -/
theorem tendsto_digamma_partial {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun n : ℕ => Complex.log (n : ℂ)
        - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹) atTop
      (𝓝 (Complex.digamma s)) := by
  have hzero : ∀ j : ℕ, s + (j : ℂ) ≠ 0 := by
    intro j
    have hpos : 0 < (s + (j : ℂ)).re := by
      have hre : (s + (j : ℂ)).re = s.re + (j : ℝ) := by simp
      rw [hre]
      have hj : (0 : ℝ) ≤ (j : ℝ) := Nat.cast_nonneg j
      linarith
    exact fun h => hpos.ne' (by simp [h])
  have h := Rh45RouteBAnalytic.tendstoLocallyUniformlyOn_logDeriv_GammaSeq.tendsto_at hs
  rw [show 𝓝 (Complex.digamma s) = 𝓝 (logDeriv Complex.Gamma s) by
    rw [Complex.digamma_def]]
  have heq : (fun n : ℕ => logDeriv (fun w : ℂ => GammaSeq w n) s) =ᶠ[atTop]
      (fun n : ℕ => Complex.log (n : ℂ)
        - ∑ j ∈ Finset.range (n + 1), (s + (j : ℂ))⁻¹) := by
    filter_upwards [Filter.eventually_atTop.mpr ⟨1, fun n hn => hn⟩] with n hn
    exact logDeriv_GammaSeq_of_ne n (Nat.one_le_iff_ne_zero.mp hn) (fun j _ => hzero j)
  exact Tendsto.congr' heq h

lemma contDiff_inv_add {w : ℂ} (hw : w.im ≠ 0) :
    ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => ((x : ℂ) + w)⁻¹) := by
  have h1 : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => (x : ℂ)) :=
    Complex.ofRealCLM.contDiff
  have h2 : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => (x : ℂ) + w) :=
    h1.add contDiff_const
  apply ContDiff.inv
  · exact h2
  · intro x h
    have him : ((x : ℂ) + w).im = w.im := by simp
    rw [h] at him
    simp at him
    exact hw him.symm

theorem em_digamma_finite (K n : ℕ) {w : ℂ} (hw : w.im ≠ 0) :
    (∑ k ∈ Finset.Icc 0 n, (((k : ℂ) + w)⁻¹)) =
      (∫ x in (0 : ℝ)..(n : ℝ), (((x : ℂ) + w)⁻¹)) +
      (w⁻¹ + (((n : ℂ) + w)⁻¹)) / 2 +
      (∑ j ∈ Finset.range K,
        (((bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
            (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
          (iteratedDeriv (2 * j + 1) (fun x : ℝ => ((x : ℂ) + w)⁻¹) (n : ℝ) -
            iteratedDeriv (2 * j + 1) (fun x : ℝ => ((x : ℂ) + w)⁻¹) 0)) +
      (1 / (((2 * K + 1).factorial : ℕ) : ℂ)) *
        (∫ x in (0 : ℝ)..(n : ℝ), (PartialTail.periodicBernoulli (2 * K + 1) x : ℂ) *
          iteratedDeriv (2 * K + 1) (fun x : ℝ => ((x : ℂ) + w)⁻¹) x) := by
  have hf : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x : ℝ => ((x : ℂ) + w)⁻¹) := contDiff_inv_add hw
  have h := PartialTail.finite_eulerMaclaurin K (fun x : ℝ => ((x : ℂ) + w)⁻¹) hf 0 n (Nat.zero_le n)
  simpa using h

lemma mem_slitPlane_of_re_pos {z : ℂ} (hz : 0 < z.re) : z ∈ slitPlane := by
  rw [Complex.mem_slitPlane_iff_not_le_zero]
  intro h
  have := Complex.re_le_re h
  simp at this
  linarith

lemma hasDerivAt_clog_add {w : ℂ} (x : ℝ) (hx : 0 < (x + w).re) :
    HasDerivAt (fun y : ℝ => Complex.log ((y : ℂ) + w)) ((x : ℂ) + w)⁻¹ x := by
  have hmem : (x : ℂ) + w ∈ slitPlane := mem_slitPlane_of_re_pos hx
  have h1 : HasDerivAt (fun y : ℝ => ((y : ℂ) + w)) 1 x := by
    simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const w
  have h := (Complex.hasDerivAt_log hmem).comp x h1
  convert h using 1
  · ext y
    rfl
  · ring

lemma integral_inv_add {w : ℂ} (n : ℕ) (hw : 0 < w.re) :
    (∫ x in (0 : ℝ)..(n : ℝ), ((x : ℂ) + w)⁻¹)
      = Complex.log ((n : ℂ) + w) - Complex.log w := by
  have hderiv : ∀ x ∈ Set.uIcc (0 : ℝ) (n : ℝ),
      HasDerivAt (fun y : ℝ => Complex.log ((y : ℂ) + w)) ((x : ℂ) + w)⁻¹ x := by
    intro x hx
    apply hasDerivAt_clog_add
    have hx' : x ∈ Set.Icc (0 : ℝ) n := by
      rwa [Set.uIcc_of_le (by positivity : (0 : ℝ) ≤ n)] at hx
    have hre : ((x : ℂ) + w).re = x + w.re := by simp
    rw [hre]
    linarith [hx'.1]
  have hint : IntervalIntegrable (fun x : ℝ => ((x : ℂ) + w)⁻¹) volume (0 : ℝ) (n : ℝ) := by
    apply ContinuousOn.intervalIntegrable
    apply ContinuousOn.inv₀
    · fun_prop
    · intro x hx h
      have hx' : x ∈ Set.Icc (0 : ℝ) n := by
        rwa [Set.uIcc_of_le (by positivity : (0 : ℝ) ≤ n)] at hx
      have hre : ((x : ℂ) + w).re = x + w.re := by simp
      have hzero : ((x : ℂ) + w).re = 0 := by rw [h]; simp
      rw [hre] at hzero
      linarith [hx'.1, hw]
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  simpa using h

lemma iteratedDeriv_inv_add (k : ℕ) (x : ℝ) {w : ℂ} (h : (x : ℂ) + w ≠ 0) :
    iteratedDeriv k (fun y : ℝ => ((y : ℂ) + w)⁻¹) x =
      (-1 : ℂ) ^ k * (k.factorial : ℂ) * ((x : ℂ) + w) ^ (-(k + 1) : ℤ) := by
  induction k generalizing x with
  | zero =>
    simp only [iteratedDeriv_zero, Nat.factorial_zero, Nat.cast_one, pow_zero,
      one_mul]
    rw [show (-(↑(0 : ℕ) + 1) : ℤ) = -1 by norm_num, zpow_neg_one]
  | succ k ih =>
    have hcont : Continuous (fun y : ℝ => ((y : ℂ) + w)) := by fun_prop
    have hopen : IsOpen {y : ℝ | ((y : ℂ) + w) ≠ 0} :=
      isOpen_compl_singleton.preimage hcont
    have hfun : iteratedDeriv k (fun y : ℝ => ((y : ℂ) + w)⁻¹)
        =ᶠ[𝓝 x] fun y => (-1 : ℂ) ^ k * (k.factorial : ℂ) *
          ((y : ℂ) + w) ^ (-(k + 1) : ℤ) := by
      filter_upwards [hopen.mem_nhds h] with y hy
      exact ih y hy
    rw [iteratedDeriv_succ, hfun.deriv_eq]
    have hd : HasDerivAt (fun y : ℝ => ((y : ℂ) + w) ^ (-(k + 1) : ℤ))
        ((-(k + 1) : ℂ) * ((x : ℂ) + w) ^ (-(k + 1) - 1 : ℤ)) x := by
      have h1 : HasDerivAt (fun z : ℂ => z + w) 1 (x : ℂ) := by
        simpa using (hasDerivAt_id (x : ℂ)).add_const w
      have h2 := hasDerivAt_zpow (-(k + 1)) ((x : ℂ) + w) (Or.inl h)
      have h4 := (h2.comp (x : ℂ) h1).comp_ofReal
      simpa [Function.comp_def, mul_one] using h4
    have hd' := hd.const_mul ((-1 : ℂ) ^ k * (k.factorial : ℂ))
    rw [hd'.deriv]
    rw [pow_succ, Nat.factorial_succ]
    push_cast
    ring

lemma iteratedDeriv_inv_add_zero (k : ℕ) {w : ℂ} (hw : w ≠ 0) :
    iteratedDeriv k (fun y : ℝ => ((y : ℂ) + w)⁻¹) 0 =
      (-1 : ℂ) ^ k * (k.factorial : ℂ) * w ^ (-(k + 1) : ℤ) := by
  have h : ((0 : ℝ) : ℂ) + w ≠ 0 := by simpa using hw
  simpa using iteratedDeriv_inv_add k 0 h

lemma tendsto_iteratedDeriv_inv_add_atTop (m : ℕ) {w : ℂ} (hw : w.im ≠ 0) :
    Tendsto (fun n : ℕ => iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) (n : ℝ))
      atTop (𝓝 0) := by
  have hbase : Tendsto (fun n : ℕ => (n : ℝ) - ‖w‖) atTop atTop := by
    rw [tendsto_atTop_atTop]
    intro a
    obtain ⟨N, hN⟩ := exists_nat_gt (a + ‖w‖)
    refine ⟨N, fun n hn => ?_⟩
    have hN' : (n : ℝ) ≥ (N : ℝ) := by exact_mod_cast hn
    linarith
  have hnorm : Tendsto (fun n : ℕ => ‖(n : ℂ) + w‖) atTop atTop := by
    apply tendsto_atTop_mono (fun n => ?_) hbase
    have h := norm_add_le (((n : ℂ) + w)) (-w)
    simp only [add_neg_cancel_right, norm_neg] at h
    have hn : ‖(n : ℂ)‖ = (n : ℝ) := by simp
    rw [hn] at h
    linarith
  have hinv : Tendsto (fun n : ℕ => ((n : ℂ) + w)⁻¹) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    have h : Tendsto (fun n : ℕ => (‖(n : ℂ) + w‖)⁻¹) atTop (𝓝 0) :=
      tendsto_inv_atTop_zero.comp hnorm
    simpa [norm_inv] using h
  have hpow : Tendsto (fun n : ℕ => (((n : ℂ) + w)⁻¹) ^ (m + 1)) atTop (𝓝 0) := by
    simpa using hinv.pow (m + 1)
  have hmul := hpow.const_mul ((-1 : ℂ) ^ m * (m.factorial : ℂ))
  have hfun : (fun n : ℕ => iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) (n : ℝ))
      = fun n : ℕ => (-1 : ℂ) ^ m * (m.factorial : ℂ) *
          (((n : ℂ) + w)⁻¹) ^ (m + 1) := by
    funext n
    have h : ((n : ℝ) : ℂ) + w ≠ 0 := by
      intro hzero
      have him : (((n : ℝ) : ℂ) + w).im = w.im := by simp
      rw [hzero] at him
      simp at him
      exact hw him.symm
    rw [iteratedDeriv_inv_add m (n : ℝ) h]
    have hcast : ((↑((n : ℝ)) : ℂ) + w) = ((↑n : ℂ) + w) := by push_cast; ring
    rw [hcast]
    rw [show ((↑m : ℤ) + 1) = (↑(m + 1) : ℤ) by push_cast; ring]
    rw [zpow_neg ((↑n : ℂ) + w)]
    rw [zpow_natCast]
    rw [← inv_pow]
  rw [hfun]
  simpa using hmul

lemma norm_iteratedDeriv_inv_add_le (m : ℕ) {w : ℂ} (x : ℝ) (hx : 0 ≤ x)
    (hw : 0 < w.re) :
    ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ ≤
      (m.factorial : ℝ) / (x + w.re) ^ (m + 1) := by
  have hne : ((x : ℂ) + w) ≠ 0 := by
    intro h
    have hre : ((x : ℂ) + w).re = x + w.re := by simp
    have hzero : ((x : ℂ) + w).re = 0 := by rw [h]; simp
    rw [hre] at hzero
    linarith
  rw [iteratedDeriv_inv_add m x hne]
  have hz : x + w.re ≤ ‖(x : ℂ) + w‖ := by
    have h := Complex.abs_re_le_norm ((x : ℂ) + w)
    have hre : ((x : ℂ) + w).re = x + w.re := by simp
    rw [hre, abs_of_nonneg (by linarith : 0 ≤ x + w.re)] at h
    exact h
  have hxw : 0 < x + w.re := by linarith
  have hzpos : 0 < ‖(x : ℂ) + w‖ := lt_of_lt_of_le hxw hz
  have hpow : (x + w.re) ^ (m + 1) ≤ ‖(x : ℂ) + w‖ ^ (m + 1) :=
    pow_le_pow_left₀ hxw.le hz (m + 1)
  have hinv : (‖(x : ℂ) + w‖ ^ (m + 1))⁻¹ ≤ ((x + w.re) ^ (m + 1))⁻¹ :=
    (inv_le_inv₀ (pow_pos hzpos (m + 1)) (pow_pos hxw (m + 1))).mpr hpow
  calc ‖(-1 : ℂ) ^ m * (m.factorial : ℂ) * ((x : ℂ) + w) ^ (-(m + 1) : ℤ)‖
      = (m.factorial : ℝ) * (‖(x : ℂ) + w‖ ^ (m + 1))⁻¹ := by
        rw [norm_mul, norm_mul, norm_pow, norm_neg, norm_one, Complex.norm_natCast]
        have hzpow : ((x : ℂ) + w) ^ (-(m + 1) : ℤ) = (((x : ℂ) + w) ^ (m + 1))⁻¹ := by
          rw [show (-(m + 1) : ℤ) = -↑(m + 1) by push_cast; ring,
            zpow_neg, zpow_natCast]
        rw [hzpow, norm_inv, norm_pow]
        norm_num
    _ ≤ (m.factorial : ℝ) * ((x + w.re) ^ (m + 1))⁻¹ := by gcongr
    _ = (m.factorial : ℝ) / (x + w.re) ^ (m + 1) := by rw [div_eq_mul_inv]

lemma tsum_inv_pow_le_two {n : ℕ} (hn : 2 ≤ n) :
    (∑' m : ℕ, 1 / (m : ℝ) ^ n) ≤ 2 := by
  have hsum2 : Summable (fun m : ℕ => 1 / (m : ℝ) ^ 2) :=
    Real.summable_one_div_nat_pow.mpr (by norm_num)
  have hsumN : Summable (fun m : ℕ => 1 / (m : ℝ) ^ n) :=
    Real.summable_one_div_nat_pow.mpr (by omega)
  calc (∑' m : ℕ, 1 / (m : ℝ) ^ n) ≤ ∑' m : ℕ, 1 / (m : ℝ) ^ 2 := by
        refine hsumN.tsum_le_tsum (fun m => ?_) hsum2
        by_cases hm : m = 0
        · have hn0 : n ≠ 0 := by omega
          simp [hm, hn0]
        · have hm1 : (1 : ℝ) ≤ (m : ℝ) := by
            exact_mod_cast Nat.one_le_iff_ne_zero.mpr hm
          have hpow : (m : ℝ) ^ 2 ≤ (m : ℝ) ^ n := pow_le_pow_right₀ hm1 hn
          exact one_div_le_one_div_of_le (by positivity) hpow
    _ = Real.pi ^ 2 / 6 := hasSum_zeta_two.tsum_eq
    _ ≤ 2 := by
        have hpi := Real.pi_lt_d20
        nlinarith [Real.pi_pos]

lemma norm_periodicBernoulli_five_le (x : ℝ) :
    ‖(PartialTail.periodicBernoulli 5 x : ℂ)‖ ≤ 5 / 81 := by
  have h := PartialTail.norm_periodicBernoulli_le_two_tsum_nat (n := 5) (by norm_num) x
  have htsum : (∑' m : ℕ, 1 / (m : ℝ) ^ 5) ≤ 2 := tsum_inv_pow_le_two (by norm_num)
  have hpi : (3 : ℝ) < Real.pi := Real.pi_gt_three
  have hden : (6 : ℝ) ^ 5 ≤ (2 * Real.pi) ^ 5 := by
    apply pow_le_pow_left₀ (by norm_num)
    linarith
  have hpos : 0 < (2 * Real.pi) ^ 5 := by positivity
  have hfac : (120 : ℝ) / (2 * Real.pi) ^ 5 ≤ 120 / 7776 := by
    gcongr
    simpa [show (7776 : ℝ) = 6 ^ 5 by norm_num] using hden
  have hS : 2 * (∑' m : ℕ, 1 / (m : ℝ) ^ 5) ≤ 4 := by linarith
  have hfac0 : 0 ≤ (120 : ℝ) / (2 * Real.pi) ^ 5 := by positivity
  have hb0 : 0 ≤ 2 * (∑' m : ℕ, 1 / (m : ℝ) ^ 5) := by
    have h1 : 0 ≤ (∑' m : ℕ, 1 / (m : ℝ) ^ 5) :=
      tsum_nonneg (fun m => by
        rw [one_div]
        positivity)
    linarith
  calc ‖(PartialTail.periodicBernoulli 5 x : ℂ)‖
      ≤ ((Nat.factorial 5 : ℝ) / (2 * Real.pi) ^ 5) *
          (2 * (∑' m : ℕ, 1 / (m : ℝ) ^ 5)) := h
    _ ≤ (120 / 7776) * 4 := by
        apply mul_le_mul hfac hS hb0 (by norm_num)
    _ = 5 / 81 := by norm_num

lemma integral_inv_pow_add (m : ℕ) (hm : 1 ≤ m) {c : ℝ} (hc : 0 < c) (n : ℕ) :
    (∫ x in (0 : ℝ)..(n : ℝ), (x + c) ^ (-(m + 1) : ℝ)) =
      (1 / (m : ℝ)) * (c ^ (-(m : ℝ)) - ((n : ℝ) + c) ^ (-(m : ℝ))) := by
  have hr : (-(m + 1) : ℝ) ≠ -1 := by
    have hm1 : (1 : ℝ) ≤ m := by exact_mod_cast hm
    intro h
    have : (m : ℝ) = 0 := by linarith
    have : (0 : ℝ) < m := by linarith
    linarith
  rw [intervalIntegral.integral_comp_add_right (fun u : ℝ => u ^ (-(m + 1) : ℝ)) c]
  rw [integral_rpow]
  · have hexp : (-(m + 1) : ℝ) + 1 = -(m : ℝ) := by ring
    rw [hexp]
    have hmne : (m : ℝ) ≠ 0 := by positivity
    field_simp
    ring
  · right
    constructor
    · exact hr
    · simp only [zero_add]
      rw [Set.uIcc_of_le (by
        have hn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
        linarith)]
      simp only [Set.mem_Icc, not_and]
      intro h
      linarith


lemma integral_inv_pow_add_le (m : ℕ) (hm : 1 ≤ m) {c : ℝ} (hc : 0 < c) (n : ℕ) :
    (∫ x in (0 : ℝ)..(n : ℝ), (x + c) ^ (-(m + 1) : ℝ)) ≤
      (1 / (m : ℝ)) * c ^ (-(m : ℝ)) := by
  rw [integral_inv_pow_add m hm hc n]
  have hnonneg : 0 ≤ ((n : ℝ) + c) ^ (-(m : ℝ)) := by positivity
  have hle : c ^ (-(m : ℝ)) - ((n : ℝ) + c) ^ (-(m : ℝ)) ≤ c ^ (-(m : ℝ)) := by
    linarith
  exact mul_le_mul_of_nonneg_left hle (by positivity)

lemma integral_norm_iteratedDeriv_le (m : ℕ) (hm : 1 ≤ m) {w : ℂ} (n : ℕ)
    (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    (∫ x in (0 : ℝ)..(n : ℝ),
        ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) ≤
      (m.factorial : ℝ) / (m * w.re ^ m) := by
  have hc : 0 < w.re := hw
  have hf : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun y : ℝ => ((y : ℂ) + w)⁻¹) :=
    contDiff_inv_add hwi
  have hcont : Continuous (fun x : ℝ =>
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) :=
    (hf.continuous_iteratedDeriv m (by simp)).norm
  have hmono : ∀ x ∈ Set.Icc (0 : ℝ) (n : ℝ),
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ ≤
        (m.factorial : ℝ) / (x + w.re) ^ (m + 1) := by
    intro x hx
    exact norm_iteratedDeriv_inv_add_le m x hx.1 hw
  have hg : ContinuousOn (fun x : ℝ =>
      (m.factorial : ℝ) / (x + w.re) ^ (m + 1)) (Set.uIcc (0 : ℝ) (n : ℝ)) := by
    apply ContinuousOn.div
    · fun_prop
    · fun_prop
    · intro x hx
      have hx' : x ∈ Set.Icc (0 : ℝ) n := by
        rwa [Set.uIcc_of_le (by positivity : (0 : ℝ) ≤ (n : ℝ))] at hx
      have hx0 : (0 : ℝ) < x + w.re := by linarith [hx'.1, hc]
      exact pow_ne_zero _ hx0.ne'
  have hInt1 : IntervalIntegrable (fun x : ℝ =>
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) volume (0 : ℝ) (n : ℝ) :=
    hcont.intervalIntegrable _ _
  have hIntg : IntervalIntegrable (fun x : ℝ =>
      (m.factorial : ℝ) / (x + w.re) ^ (m + 1)) volume (0 : ℝ) (n : ℝ) :=
    hg.intervalIntegrable
  have hEq : (∫ x in (0 : ℝ)..(n : ℝ),
        (m.factorial : ℝ) / (x + w.re) ^ (m + 1)) =
      (m.factorial : ℝ) *
        ∫ x in (0 : ℝ)..(n : ℝ), (x + w.re) ^ (-(m + 1) : ℝ) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_congr
    intro x hx
    have hx0 : 0 ≤ x + w.re := by
      have hx' : x ∈ Set.Icc (0 : ℝ) n := by
        rwa [Set.uIcc_of_le (by positivity : (0 : ℝ) ≤ (n : ℝ))] at hx
      linarith [hx'.1]
    change (m.factorial : ℝ) / (x + w.re) ^ (m + 1) =
      (m.factorial : ℝ) * (x + w.re) ^ (-(m + 1) : ℝ)
    rw [div_eq_mul_inv, ← Real.rpow_natCast]
    rw [show ((m + 1 : ℕ) : ℝ) = (m : ℝ) + 1 by push_cast; ring]
    rw [← Real.rpow_neg hx0]
  calc (∫ x in (0 : ℝ)..(n : ℝ),
        ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖)
      ≤ ∫ x in (0 : ℝ)..(n : ℝ), (m.factorial : ℝ) / (x + w.re) ^ (m + 1) :=
        intervalIntegral.integral_mono_on (Nat.cast_nonneg n) hInt1 hIntg hmono
    _ = (m.factorial : ℝ) *
        ∫ x in (0 : ℝ)..(n : ℝ), (x + w.re) ^ (-(m + 1) : ℝ) := hEq
    _ ≤ (m.factorial : ℝ) * ((1 / (m : ℝ)) * w.re ^ (-(m : ℝ))) := by
        apply mul_le_mul_of_nonneg_left (integral_inv_pow_add_le m hm hc n) (by positivity)
    _ = (m.factorial : ℝ) / (m * w.re ^ m) := by
        rw [Real.rpow_neg (le_of_lt hc), ← Real.rpow_natCast]
        field_simp

lemma integrableOn_norm_iteratedDeriv (m : ℕ) (hm : 1 ≤ m) {w : ℂ}
    (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    IntegrableOn (fun x : ℝ =>
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) (Set.Ioi 0) := by
  have hf : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun y : ℝ => ((y : ℂ) + w)⁻¹) :=
    contDiff_inv_add hwi
  have hcont : Continuous (fun x : ℝ =>
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) :=
    (hf.continuous_iteratedDeriv m (by simp)).norm
  refine integrableOn_Ioi_of_intervalIntegral_norm_bounded
    (I := (m.factorial : ℝ) / (m * w.re ^ m))
    (a := 0) (b := fun n : ℕ => (n : ℝ)) (l := atTop) ?_ ?_ ?_
  · intro n
    exact (hcont.intervalIntegrable (0 : ℝ) (n : ℝ)).1
  · exact tendsto_natCast_atTop_atTop
  · filter_upwards with n
    simpa using integral_norm_iteratedDeriv_le m hm n hw hwi

lemma integrableOn_periodicBernoulli_five_mul {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    IntegrableOn (fun x : ℝ => (PartialTail.periodicBernoulli 5 x : ℂ) *
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x) (Set.Ioi 0) := by
  have hf : ContDiff ℝ (↑(⊤ : ℕ∞)) (fun y : ℝ => ((y : ℂ) + w)⁻¹) :=
    contDiff_inv_add hwi
  have hcont : Continuous (fun x : ℝ =>
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x) :=
    hf.continuous_iteratedDeriv 5 (by simp)
  have hg : IntegrableOn (fun x : ℝ =>
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x) (Set.Ioi 0) := by
    rw [IntegrableOn] at *
    refine (integrableOn_norm_iteratedDeriv 5 (by norm_num) hw hwi).mono'
      hcont.aestronglyMeasurable ?_
    filter_upwards with x
    exact le_rfl
  have hB : AEStronglyMeasurable (fun x : ℝ => (PartialTail.periodicBernoulli 5 x : ℂ))
      (volume.restrict (Set.Ioi 0)) :=
    PartialTail.aestronglyMeasurable_periodicBernoulli 5 0
  have hbound : ∀ᵐ x ∂(volume.restrict (Set.Ioi 0)),
      ‖(PartialTail.periodicBernoulli 5 x : ℂ)‖ ≤ 5 / 81 :=
    Filter.Eventually.of_forall (fun x => norm_periodicBernoulli_five_le x)
  rw [IntegrableOn] at *
  simpa [mul_comm] using hg.bdd_mul hB hbound

lemma integral_Ioi_norm_iteratedDeriv_le (m : ℕ) (hm : 1 ≤ m) {w : ℂ} (hw : 0 < w.re)
    (hwi : w.im ≠ 0) :
    (∫ x in Set.Ioi 0, ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) ≤
      (m.factorial : ℝ) / (m * w.re ^ m) := by
  have hfi : IntegrableOn (fun x : ℝ =>
      ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖) (Set.Ioi 0) :=
    integrableOn_norm_iteratedDeriv m hm hw hwi
  have htend := intervalIntegral_tendsto_integral_Ioi (a := (0 : ℝ))
    (f := fun x : ℝ => ‖iteratedDeriv m (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖)
    (b := fun n : ℕ => (n : ℝ)) (l := atTop) hfi tendsto_natCast_atTop_atTop
  refine le_of_tendsto htend ?_
  filter_upwards with n
  exact integral_norm_iteratedDeriv_le m hm n hw hwi


lemma norm_integral_periodicBernoulli_five_mul_le {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    ‖∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ ≤
      (5 / 81) * ((Nat.factorial 5 : ℝ) / (5 * w.re ^ 5)) := by
  have hf := integrableOn_periodicBernoulli_five_mul hw hwi
  have hg := integrableOn_norm_iteratedDeriv 5 (by norm_num) hw hwi
  calc ‖∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
        iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖
      ≤ ∫ x in Set.Ioi 0, ‖(PartialTail.periodicBernoulli 5 x : ℂ) *
          iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ :=
        MeasureTheory.norm_integral_le_integral_norm _
    _ ≤ ∫ x in Set.Ioi 0, (5 / 81) *
          ‖iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ := by
        apply MeasureTheory.integral_mono_ae hf.norm (hg.const_mul (5 / 81))
        filter_upwards with x
        rw [norm_mul]
        exact mul_le_mul_of_nonneg_right (norm_periodicBernoulli_five_le x) (norm_nonneg _)
    _ = (5 / 81) * ∫ x in Set.Ioi 0,
          ‖iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ := by
        rw [integral_const_mul]
    _ ≤ (5 / 81) * ((Nat.factorial 5 : ℝ) / (5 * w.re ^ 5)) := by
        gcongr
        exact integral_Ioi_norm_iteratedDeriv_le 5 (by norm_num) hw hwi


theorem norm_remainder_five_le {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    ‖(1 / (Nat.factorial 5 : ℂ)) *
      ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
        iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ ≤
      1 / (81 * w.re ^ 5) := by
  have h := norm_integral_periodicBernoulli_five_mul_le hw hwi
  have hfac : ‖(1 / (Nat.factorial 5 : ℂ))‖ = 1 / (Nat.factorial 5 : ℝ) := by
    rw [norm_div, norm_one, Complex.norm_natCast]
  calc ‖(1 / (Nat.factorial 5 : ℂ)) *
        ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
          iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖
      = ‖(1 / (Nat.factorial 5 : ℂ))‖ *
          ‖∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
            iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ := norm_mul _ _
    _ = (1 / (Nat.factorial 5 : ℝ)) *
          ‖∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
            iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ := by rw [hfac]
    _ ≤ (1 / (Nat.factorial 5 : ℝ)) *
          ((5 / 81) * ((Nat.factorial 5 : ℝ) / (5 * w.re ^ 5))) := by
        gcongr
    _ = 1 / (81 * w.re ^ 5) := by
        norm_num [Nat.factorial]
        field_simp

lemma tendsto_em_deriv_sum (K : ℕ) {w : ℂ} (hwi : w.im ≠ 0) :
    Tendsto (fun n : ℕ => ∑ j ∈ Finset.range K,
      (((bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
          (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
        iteratedDeriv (2 * j + 1) (fun y : ℝ => ((y : ℂ) + w)⁻¹) (n : ℝ))
      atTop (𝓝 0) := by
  have h : Tendsto (fun n : ℕ => ∑ j ∈ Finset.range K,
      (((bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
          (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
        iteratedDeriv (2 * j + 1) (fun y : ℝ => ((y : ℂ) + w)⁻¹) (n : ℝ))
      atTop (𝓝 (∑ j ∈ Finset.range K, (0 : ℂ))) := by
    apply tendsto_finsetSum
    intro j hj
    have h := (tendsto_iteratedDeriv_inv_add_atTop (2 * j + 1) hwi).const_mul
      ((((bernoulli (2 * (j + 1)) : ℝ) : ℂ) / (((2 * (j + 1)).factorial : ℕ) : ℂ)))
    simpa using h
  simpa using h

lemma tendsto_remainder_five {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    Tendsto (fun n : ℕ => (1 / (Nat.factorial 5 : ℂ)) *
      ∫ x in (0 : ℝ)..(n : ℝ), (PartialTail.periodicBernoulli 5 x : ℂ) *
        iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x) atTop
      (𝓝 ((1 / (Nat.factorial 5 : ℂ)) *
        ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
          iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x)) := by
  have hfi := integrableOn_periodicBernoulli_five_mul hw hwi
  have htend := intervalIntegral_tendsto_integral_Ioi (a := (0 : ℝ))
    (f := fun x : ℝ => (PartialTail.periodicBernoulli 5 x : ℂ) *
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x)
    (b := fun n : ℕ => (n : ℝ)) (l := atTop) hfi tendsto_natCast_atTop_atTop
  exact htend.const_mul _

lemma tendsto_arg_add (w : ℂ) :
    Tendsto (fun n : ℕ => Complex.arg ((n : ℂ) + w)) atTop (𝓝 0) := by
  have hinvC : Tendsto (fun n : ℕ => ((n : ℂ))⁻¹) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    have h : Tendsto (fun n : ℕ => ((n : ℝ))⁻¹) atTop (𝓝 0) :=
      tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop
    simpa [norm_inv, Complex.norm_natCast] using h
  have hz : Tendsto (fun n : ℕ => w * ((n : ℂ)⁻¹)) atTop (𝓝 0) := by
    simpa [mul_comm] using hinvC.const_mul w
  have h1 : Tendsto (fun n : ℕ => 1 + w * ((n : ℂ)⁻¹)) atTop (𝓝 1) := by
    simpa using (tendsto_const_nhds.add hz)
  have harg : Tendsto (fun n : ℕ => Complex.arg (1 + w * ((n : ℂ)⁻¹))) atTop (𝓝 0) := by
    have := (Complex.continuousAt_arg (by simp : (1 : ℂ) ∈ slitPlane)).tendsto.comp h1
    have h1arg : Complex.arg (1 : ℂ) = 0 := by simp
    rw [h1arg] at this
    simpa only [Function.comp_def] using this
  refine harg.congr' ?_
  filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
  have hnpos : (0 : ℝ) < n := by exact_mod_cast hn
  have hn0 : (n : ℂ) ≠ 0 := by exact_mod_cast hn.ne'
  have heq : (n : ℂ) + w = (1 + w * ((n : ℂ)⁻¹)) * (n : ℝ) := by
    push_cast
    field_simp [hn0]
  rw [heq, Complex.arg_mul_real hnpos]

lemma tendsto_log_norm_sub_log_nat (w : ℂ) :
    Tendsto (fun n : ℕ => Real.log (n : ℝ) - Real.log ‖(n : ℂ) + w‖) atTop (𝓝 0) := by
  have hinvC : Tendsto (fun n : ℕ => ((n : ℂ))⁻¹) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    have h : Tendsto (fun n : ℕ => ((n : ℝ))⁻¹) atTop (𝓝 0) :=
      tendsto_inv_atTop_zero.comp tendsto_natCast_atTop_atTop
    simpa [norm_inv, Complex.norm_natCast] using h
  have hz : Tendsto (fun n : ℕ => w * ((n : ℂ)⁻¹)) atTop (𝓝 0) := by
    simpa [mul_comm] using hinvC.const_mul w
  have h1 : Tendsto (fun n : ℕ => 1 + w * ((n : ℂ)⁻¹)) atTop (𝓝 1) := by
    simpa using (tendsto_const_nhds.add hz)
  have hnorm : Tendsto (fun n : ℕ => ‖1 + w * ((n : ℂ)⁻¹)‖) atTop (𝓝 1) := by
    simpa using h1.norm
  have hdiv : Tendsto (fun n : ℕ => ‖(n : ℂ) + w‖ / (n : ℝ)) atTop (𝓝 1) := by
    refine hnorm.congr' ?_
    filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
    have hnpos : (0 : ℝ) < n := by exact_mod_cast hn
    have hn0 : (n : ℂ) ≠ 0 := by exact_mod_cast hn.ne'
    have heq : (n : ℂ) + w = (1 + w * ((n : ℂ)⁻¹)) * (n : ℝ) := by
      push_cast
      field_simp [hn0]
    rw [heq, norm_mul]
    push_cast
    simp only [Complex.norm_natCast]
    field_simp
  have hlog : Tendsto (fun n : ℕ => Real.log (‖(n : ℂ) + w‖ / (n : ℝ))) atTop (𝓝 0) := by
    have := (Real.continuousAt_log (by norm_num : (1 : ℝ) ≠ 0)).tendsto.comp hdiv
    rw [Real.log_one] at this
    simpa only [Function.comp_def] using this
  have hlog' : Tendsto (fun n : ℕ => -Real.log (‖(n : ℂ) + w‖ / (n : ℝ))) atTop (𝓝 0) := by
    simpa using hlog.neg
  refine hlog'.congr' ?_
  filter_upwards [eventually_gt_atTop (0 : ℕ), eventually_gt_atTop (Nat.ceil ‖w‖)] with n hn hN
  have hnpos : (0 : ℝ) < n := by exact_mod_cast hn
  have hnormpos : 0 < ‖(n : ℂ) + w‖ := by
    have hge : (n : ℝ) - ‖w‖ ≤ ‖(n : ℂ) + w‖ := by
      have h' := norm_add_le (((n : ℂ) + w)) (-w)
      simp only [add_neg_cancel_right, norm_neg] at h'
      have hn' : ‖(n : ℂ)‖ = (n : ℝ) := by simp
      rw [hn'] at h'
      linarith
    have hN' : ‖w‖ < (n : ℝ) := by
      have hc : ‖w‖ ≤ (Nat.ceil ‖w‖ : ℝ) := Nat.le_ceil ‖w‖
      have hn' : (Nat.ceil ‖w‖ : ℝ) < n := by exact_mod_cast hN
      linarith
    linarith
  rw [Real.log_div hnormpos.ne' hnpos.ne']
  ring


lemma tendsto_log_sub_log_add (w : ℂ) :
    Tendsto (fun n : ℕ => Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w))
      atTop (𝓝 0) := by
  have hre := tendsto_log_norm_sub_log_nat w
  have him := tendsto_arg_add w
  have hre' : Tendsto (fun n : ℕ =>
      ((Real.log (n : ℝ) - Real.log ‖(n : ℂ) + w‖ : ℝ) : ℂ)) atTop (𝓝 0) := by
    simpa using hre.ofReal
  have him' : Tendsto (fun n : ℕ =>
      ((-Complex.arg ((n : ℂ) + w) : ℝ) : ℂ) * Complex.I) atTop (𝓝 0) := by
    have h := him.neg.ofReal.mul_const Complex.I
    simpa using h
  have hsum := hre'.add him'
  have hsum0 : Tendsto (fun n : ℕ =>
      ((Real.log (n : ℝ) - Real.log ‖(n : ℂ) + w‖ : ℝ) : ℂ) +
        ((-Complex.arg ((n : ℂ) + w) : ℝ) : ℂ) * Complex.I) atTop (𝓝 0) := by
    simpa using hsum
  refine hsum0.congr' ?_
  filter_upwards [eventually_gt_atTop (0 : ℕ)] with n hn
  have hn0 : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hlogn : Complex.log (n : ℂ) = ((Real.log (n : ℝ)) : ℂ) := by
    rw [show (n : ℂ) = ((n : ℝ) : ℂ) by norm_num]
    exact (Complex.ofReal_log hn0).symm
  have hlognw : Complex.log ((n : ℂ) + w) =
      ((Real.log ‖(n : ℂ) + w‖ : ℝ) : ℂ) +
        ((Complex.arg ((n : ℂ) + w) : ℝ) : ℂ) * Complex.I := by
    apply Complex.ext
    · simp [Complex.log_re]
    · simp [Complex.log_im]
  rw [hlogn, hlognw]
  push_cast
  ring

theorem em_digamma_rearranged (n : ℕ) {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    Complex.log (n : ℂ) - ∑ k ∈ Finset.Icc 0 n, (((k : ℂ) + w)⁻¹) =
      Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w) + Complex.log w
        - (w⁻¹ + (((n : ℂ) + w)⁻¹)) / 2
        - (∑ j ∈ Finset.range 2,
            (((bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
                (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
              (iteratedDeriv (2 * j + 1) (fun y : ℝ => ((y : ℂ) + w)⁻¹) (n : ℝ) -
                iteratedDeriv (2 * j + 1) (fun y : ℝ => ((y : ℂ) + w)⁻¹) 0))
        - (1 / (Nat.factorial 5 : ℂ)) *
            (∫ x in (0 : ℝ)..(n : ℝ), (PartialTail.periodicBernoulli 5 x : ℂ) *
              iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x) := by
  have h := em_digamma_finite (K := 2) n hwi
  rw [integral_inv_add n hw] at h
  norm_num [Nat.factorial] at h ⊢
  rw [h]
  ring

lemma em_sum_two {w : ℂ} (hw : w ≠ 0) :
    (∑ j ∈ Finset.range 2,
      (((bernoulli (2 * (j + 1)) : ℝ) : ℂ) /
          (((2 * (j + 1)).factorial : ℕ) : ℂ)) *
        iteratedDeriv (2 * j + 1) (fun y : ℝ => ((y : ℂ) + w)⁻¹) 0)
      = -1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) := by
  rw [Finset.sum_range_succ, Finset.sum_range_one]
  rw [iteratedDeriv_inv_add_zero (2 * 0 + 1) hw]
  rw [iteratedDeriv_inv_add_zero (2 * 1 + 1) hw]
  norm_num [bernoulli]
  field_simp
  ring

theorem digamma_expansion {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    Complex.digamma w = Complex.log w - 1 / (2 * w) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) -
      (1 / (Nat.factorial 5 : ℂ)) *
        ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
          iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x := by
  let f : ℝ → ℂ := fun y => ((y : ℂ) + w)⁻¹
  let B : ℕ → ℂ := fun j =>
    ((bernoulli (2 * (j + 1)) : ℝ) : ℂ) / (((2 * (j + 1)).factorial : ℕ) : ℂ)
  let S : ℕ → ℂ := fun n => ∑ j ∈ Finset.range 2, B j * iteratedDeriv (2 * j + 1) f (n : ℝ)
  let S0 : ℂ := ∑ j ∈ Finset.range 2, B j * iteratedDeriv (2 * j + 1) f 0
  let Rn : ℕ → ℂ := fun n => (1 / (Nat.factorial 5 : ℂ)) *
    ∫ x in (0 : ℝ)..(n : ℝ), (PartialTail.periodicBernoulli 5 x : ℂ) * iteratedDeriv 5 f x
  let Rinf : ℂ := (1 / (Nat.factorial 5 : ℂ)) *
    ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) * iteratedDeriv 5 f x
  have hlog := tendsto_log_sub_log_add w
  have hfn : Tendsto (fun n : ℕ => f (n : ℝ)) atTop (𝓝 0) := by
    simpa [f] using tendsto_iteratedDeriv_inv_add_atTop 0 hwi
  have hS : Tendsto S atTop (𝓝 0) := by
    simpa [S, B, f] using tendsto_em_deriv_sum 2 hwi
  have hR : Tendsto Rn atTop (𝓝 Rinf) := by
    simpa [Rn, Rinf, f] using tendsto_remainder_five hw hwi
  have hA : Tendsto (fun n : ℕ =>
      (Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w)) + Complex.log w
        - (w⁻¹ + f (n : ℝ)) / 2 - (S n - S0) - Rn n) atTop
      (𝓝 (Complex.log w - w⁻¹ / 2 + S0 - Rinf)) := by
    have h1 : Tendsto (fun n : ℕ =>
        (Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w)) + Complex.log w
          - (w⁻¹ + f (n : ℝ)) / 2 - (S n - S0) - Rn n) atTop
        (𝓝 (0 + Complex.log w - (w⁻¹ + 0) / 2 - (0 - S0) - Rinf)) := by
      exact ((((hlog.add tendsto_const_nhds).sub
        ((tendsto_const_nhds.add hfn).div_const 2)).sub
        (hS.sub tendsto_const_nhds)).sub hR)
    simpa using h1
  have hL : Tendsto (fun n : ℕ => Complex.log (n : ℂ) -
      ∑ k ∈ Finset.Icc 0 n, f (k : ℝ)) atTop (𝓝 (Complex.digamma w)) := by
    have h := tendsto_digamma_partial (s := w) hw
    convert h using 1
    · ext n
      have hrange : Finset.range (n + 1) = Finset.Icc 0 n := by
        ext k
        simp [Nat.lt_succ_iff]
      rw [hrange]
      congr 1
      apply Finset.sum_congr rfl
      intro k hk
      simp only [f]
      rw [add_comm]
      norm_num
  have heq : (fun n : ℕ => Complex.log (n : ℂ) -
      ∑ k ∈ Finset.Icc 0 n, f (k : ℝ)) =ᶠ[atTop]
      (fun n : ℕ => (Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w)) + Complex.log w
        - (w⁻¹ + f (n : ℝ)) / 2 - (S n - S0) - Rn n) := by
    filter_upwards with n
    change Complex.log (n : ℂ) - ∑ k ∈ Finset.Icc 0 n, ((k : ℂ) + w)⁻¹ =
      Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w) + Complex.log w
        - (w⁻¹ + f (n : ℝ)) / 2 - (S n - S0) - Rn n
    rw [em_digamma_rearranged n hw hwi]
    simp only [S, S0, B, f, Rn, mul_sub, Finset.sum_sub_distrib]
    push_cast
    ring
  have hA' : Tendsto (fun n : ℕ =>
      (Complex.log (n : ℂ) - Complex.log ((n : ℂ) + w)) + Complex.log w
        - (w⁻¹ + f (n : ℝ)) / 2 - (S n - S0) - Rn n) atTop
      (𝓝 (Complex.digamma w)) := hL.congr' heq
  have huniq := tendsto_nhds_unique hA' hA
  rw [huniq]
  have hw0 : w ≠ 0 := by
    intro h
    rw [h] at hw
    simp at hw
  simp only [S0, B]
  rw [em_sum_two hw0]
  simp only [Rinf]
  ring

theorem digamma_shifted_expansion (N : ℕ) {s : ℂ} (hs : 0 < s.re) (hsi : s.im ≠ 0) :
    Complex.digamma s =
      (Complex.log (s + N) - 1 / (2 * (s + N)) - 1 / (12 * (s + N) ^ 2) +
        1 / (120 * (s + N) ^ 4) -
        (1 / (Nat.factorial 5 : ℂ)) *
          ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
            iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + (s + N))⁻¹) x) -
      ∑ k ∈ Finset.range N, (s + (k : ℂ))⁻¹ := by
  have hshift := Complex.digamma_apply_add_nat (s := s) (n := N) (by
    intro m h
    have hre := congrArg Complex.re h
    simp at hre
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith)
  have hre : 0 < (s + N).re := by
    have : (s + N).re = s.re + (N : ℝ) := by simp
    rw [this]
    have hN : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
    linarith
  have him : (s + N).im ≠ 0 := by
    have : (s + N).im = s.im := by simp
    rwa [this]
  have hexp := digamma_expansion (w := s + N) hre him
  rw [hexp] at hshift
  exact eq_sub_of_add_eq hshift.symm

lemma log_re_eq_half_log_normSq {w : ℂ} :
    (Complex.log w).re = (1 / 2) * Real.log (Complex.normSq w) := by
  rw [Complex.log_re, Complex.normSq_eq_norm_sq, Real.log_pow]
  ring

end IntersectionForm
