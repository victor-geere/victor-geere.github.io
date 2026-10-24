/-
  DirichletStripBound.lean — part (A), step 3b: what *is* available for bounding `Λ_χ` on the
  critical strip, and the precise boundary statements.

  This file is deliberately modest.  It commits the pieces of step 3b that are genuine consequences
  of the committed analysis:

  * `exists_bound_log_mul_exp` — `(1 + log(|t|+2))·(1 + |t|/2)·e^{−|t|/8}` is bounded on `ℝ`
    (continuity plus limit `0` at `±∞`);
  * `norm_gammaFactor_re_one_le` — the archimedean factor decays on `Re s = 1` for **both** parities
    (this is what the strengthened `norm_Gammaℝ_le`, `σ ∈ [1/2,2]`, was for);
  * `completedLFunction_re_one` — the identity `Λ = γ·L` *at* `Re s = 1`, where the `1 < re s` form
    `completedLFunction_eq_gammaFactor_mul_LFunction` does not apply;
  * `norm_dirichletCompleted_re_one_le` — `Λ` is bounded on the line `Re s = 1`;
  * `diffContOnCl_dirichletCompleted` — `Λ` is holomorphic on the open strip `0 < Re s < 1`.

  What is **not** here is the closed-strip bound itself.  `PhragmenLindelof.vertical_strip` needs the
  growth hypothesis `Λ ≪ exp(B·exp(c|Im|))`, and no committed result supplies *any* strip bound for
  `Λ`: `Λ = N^{s/2}γL` needs a strip bound for `L`, the functional equation maps the open strip to
  itself, and `norm_le_of_three_lines_regularised`'s `hB` already presupposes the strip bound.
  See journal §220.
-/
import GammaBounds
import DirichletCompletedLogDeriv
import DirichletAnalytic
import Mathlib.NumberTheory.LSeries.DirichletContinuation

namespace RouteABC

noncomputable section

open scoped BigOperators
open MeasureTheory Set Filter Metric
open scoped Topology
open DirichletCharacter

/-- The `log × polynomial × exponential` profile that governs the `Re s = 1` boundary of `Λ`. -/
noncomputable def Fdecay (t : ℝ) : ℝ :=
  (1 + Real.log (|t| + 2)) * (1 + |t| / 2) * Real.exp (-(|t| / 8))

/-- `t ↦ t^k · e^{−t/8}` tends to `0` at `+∞`, from the unscaled Mathlib limits. -/
theorem tendsto_pow_mul_exp_neg_div_atTop (k : ℕ) :
    Tendsto (fun t : ℝ => t ^ k * Real.exp (-(t / 8))) atTop (𝓝 0) := by
  have hcomp : Tendsto (fun t : ℝ => t / 8) atTop atTop := by
    have h : Tendsto (fun t : ℝ => (1 / 8 : ℝ) * t) atTop atTop :=
      tendsto_id.const_mul_atTop (by norm_num : (0 : ℝ) < 1 / 8)
    refine h.congr' ?_
    filter_upwards with t; ring
  have h := ((Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero k).comp hcomp).const_mul ((8 : ℝ) ^ k)
  simp only [Function.comp_apply] at h
  have hfun : (fun t : ℝ => (8 : ℝ) ^ k * ((t / 8) ^ k * Real.exp (-(t / 8))))
      = fun t : ℝ => t ^ k * Real.exp (-(t / 8)) := by
    funext t
    rw [← mul_assoc, ← mul_pow]
    ring_nf
  rw [hfun, mul_zero] at h
  exact h

/-- `(t+3)(t+1)e^{−t/8} → 0` at `+∞`, by expanding the quadratic in powers of `t`. -/
theorem tendsto_quadratic_mul_exp_neg_div_atTop :
    Tendsto (fun t : ℝ => (t + 3) * (t + 1) * Real.exp (-(t / 8))) atTop (𝓝 0) := by
  have h2 := tendsto_pow_mul_exp_neg_div_atTop 2
  have h1 := tendsto_pow_mul_exp_neg_div_atTop 1
  have h0 := tendsto_pow_mul_exp_neg_div_atTop 0
  have hsum : Tendsto (fun t : ℝ => t ^ 2 * Real.exp (-(t / 8))
      + 4 * (t ^ 1 * Real.exp (-(t / 8))) + 3 * (t ^ 0 * Real.exp (-(t / 8))))
      atTop (𝓝 (0 + 4 * 0 + 3 * 0)) :=
    (h2.add (h1.const_mul 4)).add (h0.const_mul 3)
  have hfun : (fun t : ℝ => (t + 3) * (t + 1) * Real.exp (-(t / 8)))
      = fun t : ℝ => t ^ 2 * Real.exp (-(t / 8)) + 4 * (t ^ 1 * Real.exp (-(t / 8)))
          + 3 * (t ^ 0 * Real.exp (-(t / 8))) := by
    funext t; ring
  rw [hfun]
  simpa using hsum

/-- **The `log × polynomial × exponential` factor is bounded.**  This is the whole reason the
`Re s = 1` boundary of `Λ` is finite: the archimedean decay `e^{−|t|/8}` beats the `L`-growth
`log(|t|+2)` and the `|t|` from the archimedean factor. -/
theorem exists_bound_log_mul_exp :
    ∃ M : ℝ, 0 < M ∧ ∀ t : ℝ, Fdecay t ≤ M := by
  have hH := tendsto_quadratic_mul_exp_neg_div_atTop
  have htop : Tendsto Fdecay atTop (𝓝 0) := by
    refine squeeze_zero' ?_ ?_ hH
    · filter_upwards [eventually_ge_atTop (0 : ℝ)] with t ht
      have h1 : (0 : ℝ) ≤ 1 + Real.log (|t| + 2) := by
        have := Real.log_nonneg (show (1 : ℝ) ≤ |t| + 2 by rw [abs_of_nonneg ht]; linarith)
        linarith
      have h2 : (0 : ℝ) ≤ 1 + |t| / 2 := by positivity
      unfold Fdecay
      exact mul_nonneg (mul_nonneg h1 h2) (Real.exp_pos _).le
    · filter_upwards [eventually_ge_atTop (0 : ℝ)] with t ht
      have hlog : 1 + Real.log (t + 2) ≤ t + 3 := by
        have := Real.log_le_self (show (0 : ℝ) ≤ t + 2 by linarith)
        linarith
      have hb : 1 + t / 2 ≤ t + 1 := by linarith
      have h1 : (0 : ℝ) ≤ 1 + t / 2 := by linarith
      have h3 : (0 : ℝ) ≤ t + 3 := by linarith
      unfold Fdecay
      rw [abs_of_nonneg ht]
      exact mul_le_mul_of_nonneg_right (mul_le_mul hlog hb h1 h3) (Real.exp_pos _).le
  have hbot : Tendsto Fdecay atBot (𝓝 0) := by
    have hneg : Tendsto (fun t : ℝ => -t) atBot atTop := tendsto_neg_atBot_atTop
    refine (htop.comp hneg).congr ?_
    intro t
    simp only [Function.comp_apply, Fdecay, abs_neg]
  have hsmallTop : ∃ T₁ : ℝ, ∀ t ≥ T₁, Fdecay t ≤ 1 := by
    have h := htop.eventually (eventually_le_nhds (show (0 : ℝ) < 1 by norm_num))
    rwa [eventually_atTop] at h
  have hsmallBot : ∃ T₂ : ℝ, ∀ t ≤ T₂, Fdecay t ≤ 1 := by
    have h := hbot.eventually (eventually_le_nhds (show (0 : ℝ) < 1 by norm_num))
    rwa [eventually_atBot] at h
  obtain ⟨T₁, hT₁⟩ := hsmallTop
  obtain ⟨T₂, hT₂⟩ := hsmallBot
  set T : ℝ := max |T₁| |T₂| + 1 with hTdef
  have hT1 : T₁ ≤ T := by
    rw [hTdef]; linarith [le_max_left |T₁| |T₂|, le_abs_self T₁]
  have hT2 : -T ≤ T₂ := by
    rw [hTdef]; linarith [le_max_right |T₁| |T₂|, neg_abs_le T₂]
  have hcont : Continuous Fdecay := by
    unfold Fdecay
    refine Continuous.mul (Continuous.mul ?_ ?_) ?_
    · exact continuous_const.add (Continuous.log (continuous_abs.add continuous_const)
        (fun t => by positivity))
    · exact continuous_const.add (continuous_abs.div_const 2)
    · exact Real.continuous_exp.comp ((continuous_abs.div_const 8).neg)
  obtain ⟨x0, hx0, hmax⟩ := isCompact_Icc.exists_isMaxOn
    (Set.nonempty_Icc.mpr (by linarith [le_max_left |T₁| |T₂|, abs_nonneg T₁] : -T ≤ T))
    hcont.continuousOn
  refine ⟨max (Fdecay x0) 1 + 1, by positivity, fun t => ?_⟩
  have hle1 : Fdecay t ≤ max (Fdecay x0) 1 + 1 := by
    by_cases ht : |t| ≤ T
    · have hmem : t ∈ Set.Icc (-T) T := by
        rw [Set.mem_Icc]
        exact ⟨by linarith [neg_abs_le t], by linarith [le_abs_self t]⟩
      exact (hmax hmem).trans (by linarith [le_max_left (Fdecay x0) 1])
    · rw [not_le] at ht
      rcases lt_abs.mp ht with ht1 | ht2
      · exact (hT₁ t (by linarith [hT1, ht1])).trans (by linarith [le_max_right (Fdecay x0) 1])
      · exact (hT₂ t (by linarith [hT2, ht2])).trans (by linarith [le_max_right (Fdecay x0) 1])
  exact hle1

/-- **Archimedean decay on the line `Re s = 1`.**  Both parities are covered because the odd case
evaluates `Γ_ℝ (2 + it)`, and `norm_Gammaℝ_le` now holds for `σ ∈ [1/2,2]`. -/
theorem norm_gammaFactor_re_one_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t : ℝ) :
    ‖gammaFactor χ ((1 : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 256 * (1 + |t| / 2) * Real.exp (-(|t| / 8)) := by
  have he0 : (0 : ℝ) ≤ Real.exp (-(|t| / 8)) := (Real.exp_pos _).le
  rcases χ.even_or_odd with h | h
  · rw [h.gammaFactor_def]
    have hb := norm_Gammaℝ_le (σ := 1) (t := t) (by norm_num) (by norm_num)
    simp only [Complex.ofReal_one] at hb
    refine hb.trans ?_
    have hbase : (1 : ℝ) ≤ 1 + |t| / 2 := by have := abs_nonneg t; linarith
    have hbase0 : (0 : ℝ) ≤ 1 + |t| / 2 := by linarith
    have hpow : (1 + |t| / 2) ^ ((1 : ℝ) / 2) ≤ (1 + |t| / 2) ^ (1 : ℝ) :=
      Real.rpow_le_rpow_of_exponent_le hbase (by norm_num : (1 : ℝ) / 2 ≤ 1)
    rw [Real.rpow_one] at hpow
    nlinarith [hpow, hbase0, he0]
  · rw [h.gammaFactor_def]
    have harg : (1 : ℂ) + (t : ℂ) * Complex.I + 1 = (2 : ℂ) + (t : ℂ) * Complex.I := by ring
    rw [harg]
    have hb := norm_Gammaℝ_le (σ := 2) (t := t) (by norm_num) (by norm_num)
    refine hb.trans ?_
    have hbase0 : (0 : ℝ) ≤ 1 + |t| / 2 := by positivity
    rw [show (2 : ℝ) / 2 = 1 by norm_num, Real.rpow_one]
    nlinarith [hbase0, he0]

/-- **The identity `Λ = γ·L` *at* `Re s = 1`.**  The committed
`completedLFunction_eq_gammaFactor_mul_LFunction` requires `1 < re s` and therefore does **not**
apply on the boundary; the `s ≠ 0` form of `LFunction_eq_completed_div_gammaFactor` does. -/
theorem completedLFunction_re_one {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (t : ℝ) :
    completedLFunction χ ((1 : ℂ) + (t : ℂ) * Complex.I)
      = LFunction χ ((1 : ℂ) + (t : ℂ) * Complex.I)
        * gammaFactor χ ((1 : ℂ) + (t : ℂ) * Complex.I) := by
  have hs0 : (1 : ℂ) + (t : ℂ) * Complex.I ≠ 0 := by
    intro h
    have := congrArg Complex.re h
    simp at this
  have hgf : gammaFactor χ ((1 : ℂ) + (t : ℂ) * Complex.I) ≠ 0 :=
    gammaFactor_ne_zero_of_re_pos χ (by simp)
  have h := LFunction_eq_completed_div_gammaFactor χ ((1 : ℂ) + (t : ℂ) * Complex.I) (Or.inl hs0)
  rw [h]
  exact (div_mul_cancel₀ _ hgf).symm

/-- **`Λ` is bounded on the line `Re s = 1`.**  `N^{s/2}` contributes `N^{1/2}`, `L` contributes
`C(1 + log(|t|+2))`, and `γ` contributes the archimedean decay; the product is bounded by
`exists_bound_log_mul_exp`. -/
theorem norm_dirichletCompleted_re_one_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ t : ℝ, ‖dirichletCompleted χ ((1 : ℂ) + (t : ℂ) * Complex.I)‖ ≤ C := by
  obtain ⟨M, hM0, hM⟩ := exists_bound_log_mul_exp
  obtain ⟨C₁, hC₁0, hC₁⟩ := norm_LFunction_le χ hχ
  have hNpos : (0 : ℝ) < N := by exact_mod_cast NeZero.pos N
  refine ⟨(N : ℝ) ^ (1 / 2 : ℝ) * C₁ * 256 * M, by positivity, fun t => ?_⟩
  have hcomp := completedLFunction_re_one χ t
  have hNc : ((N : ℂ)) = (((N : ℝ)) : ℂ) := by push_cast; ring
  have hNnorm : ‖(N : ℂ) ^ (((1 : ℂ) + (t : ℂ) * Complex.I) / 2)‖ = (N : ℝ) ^ (1 / 2 : ℝ) := by
    rw [hNc, Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    congr 1
    simp
  have hL := hC₁ 1 t (by norm_num) (by norm_num)
  have hγ := norm_gammaFactor_re_one_le χ t
  rw [dirichletCompleted, hcomp, norm_mul, norm_mul, hNnorm]
  have hL0 : (0 : ℝ) ≤ C₁ * (1 + Real.log (|t| + 2)) := by
    have : (0 : ℝ) ≤ 1 + Real.log (|t| + 2) := by
      have := Real.log_nonneg (show (1 : ℝ) ≤ |t| + 2 by linarith [abs_nonneg t])
      linarith
    positivity
  have hγ0 : (0 : ℝ) ≤ 256 * (1 + |t| / 2) * Real.exp (-(|t| / 8)) := by positivity
  have hM' : Fdecay t ≤ M := hM t
  unfold Fdecay at hM'
  have hfac : (C₁ * (1 + Real.log (|t| + 2))) * (256 * (1 + |t| / 2) * Real.exp (-(|t| / 8)))
      ≤ C₁ * 256 * M := by
    nlinarith [hM', hC₁0.le, hL0, hγ0, hL, hγ, (Real.exp_pos (-(|t| / 8))).le]
  have hstep1 := mul_le_mul_of_nonneg_left (mul_le_mul hL hγ (norm_nonneg _) hL0)
    (Real.rpow_nonneg hNpos.le (1 / 2 : ℝ))
  have hstep2 := mul_le_mul_of_nonneg_left hfac (Real.rpow_nonneg hNpos.le (1 / 2 : ℝ))
  calc (N : ℝ) ^ (1 / 2 : ℝ)
        * (‖LFunction χ ((1 : ℂ) + (t : ℂ) * Complex.I)‖
          * ‖gammaFactor χ ((1 : ℂ) + (t : ℂ) * Complex.I)‖)
      ≤ (N : ℝ) ^ (1 / 2 : ℝ)
          * ((C₁ * (1 + Real.log (|t| + 2)))
            * (256 * (1 + |t| / 2) * Real.exp (-(|t| / 8)))) := hstep1
    _ ≤ (N : ℝ) ^ (1 / 2 : ℝ) * (C₁ * 256 * M) := hstep2
    _ = (N : ℝ) ^ (1 / 2 : ℝ) * C₁ * 256 * M := by ring

/-- **`Λ` is holomorphic on the open strip `0 < Re s < 1`.**  This is the `DiffContOnCl` input of
`PhragmenLindelof.vertical_strip`; it is free from `differentiable_dirichletCompleted`. -/
theorem diffContOnCl_dirichletCompleted {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) :
    DiffContOnCl ℂ (dirichletCompleted χ) (re ⁻¹' Set.Ioo 0 1) :=
  (differentiable_dirichletCompleted χ hχ).diffContOnCl


/-- **The Mellin transform is bounded on every vertical strip** for a kernel that decays faster than
any power at both `0` and `+∞`. -/
theorem norm_mellin_le {f : ℝ → ℂ} {a b : ℝ}
    (hf_int : LocallyIntegrableOn f (Ioi 0))
    (htop : ∀ r : ℝ, f =O[atTop] (· ^ r))
    (hbot : ∀ r : ℝ, f =O[𝓝[>] 0] (· ^ r)) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, a ≤ s.re → s.re ≤ b → ‖mellin f s‖ ≤ C := by
  have hconv : ∀ c : ℝ, MellinConvergent f (c : ℂ) := by
    intro c
    refine mellinConvergent_of_isBigO_rpow hf_int (htop (-(c + 1))) ?_ (hbot (-(c - 1))) ?_
    · simp
    · simp
  have hInt : ∀ c : ℝ, IntegrableOn (fun t : ℝ => t ^ (c - 1) * ‖f t‖) (Ioi 0) := by
    intro c
    refine IntegrableOn.congr_fun ((hconv c).norm) ?_ measurableSet_Ioi
    intro t ht
    change ‖(t : ℂ) ^ ((c : ℂ) - 1) • f t‖ = t ^ (c - 1) * ‖f t‖
    rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos (by exact_mod_cast ht : (0 : ℝ) < t)]
    congr 1
  refine ⟨∫ t in Ioi 0, (t ^ (a - 1) + t ^ (b - 1)) * ‖f t‖, ?_, ?_⟩
  · refine setIntegral_nonneg measurableSet_Ioi (fun t ht => ?_)
    exact mul_nonneg (add_nonneg (Real.rpow_nonneg (le_of_lt ht) _)
      (Real.rpow_nonneg (le_of_lt ht) _)) (norm_nonneg _)
  · intro s hs_a hs_b
    have hIntσ : IntegrableOn (fun t : ℝ => t ^ (s.re - 1) * ‖f t‖) (Ioi 0) := hInt s.re
    have hG : IntegrableOn (fun t : ℝ => t ^ (a - 1) * ‖f t‖ + t ^ (b - 1) * ‖f t‖) (Ioi 0) :=
      (hInt a).add (hInt b)
    have hpoint : ∀ t ∈ Ioi (0 : ℝ),
        t ^ (s.re - 1) * ‖f t‖ ≤ t ^ (a - 1) * ‖f t‖ + t ^ (b - 1) * ‖f t‖ := by
      intro t ht
      have ht0 : (0 : ℝ) < t := ht
      have hpow : t ^ (s.re - 1) ≤ t ^ (a - 1) + t ^ (b - 1) := by
        by_cases h1 : (1 : ℝ) ≤ t
        · have hle : t ^ (s.re - 1) ≤ t ^ (b - 1) :=
            Real.rpow_le_rpow_of_exponent_le h1 (by linarith)
          have h0 : (0 : ℝ) ≤ t ^ (a - 1) := Real.rpow_nonneg ht0.le _
          linarith
        · have h1' : t ≤ 1 := le_of_lt (not_le.mp h1)
          have hle : t ^ (s.re - 1) ≤ t ^ (a - 1) :=
            Real.rpow_le_rpow_of_exponent_ge ht0 h1' (by linarith)
          have h0 : (0 : ℝ) ≤ t ^ (b - 1) := Real.rpow_nonneg ht0.le _
          linarith
      rw [← add_mul]
      exact mul_le_mul_of_nonneg_right hpow (norm_nonneg _)
    rw [mellin]
    refine (norm_integral_le_integral_norm (μ := volume.restrict (Ioi 0))
      (fun t : ℝ => (t : ℂ) ^ (s - 1) • f t)).trans ?_
    have hcongr : ∫ t : ℝ, ‖(t : ℂ) ^ (s - 1) • f t‖ ∂(volume.restrict (Ioi 0))
        = ∫ t in Ioi 0, t ^ (s.re - 1) * ‖f t‖ := by
      refine setIntegral_congr_fun measurableSet_Ioi (fun t ht => ?_)
      rw [norm_smul, Complex.norm_cpow_eq_rpow_re_of_pos (by exact_mod_cast ht : (0 : ℝ) < t)]
      congr 1
    rw [hcongr]
    refine (setIntegral_mono_on hIntσ hG measurableSet_Ioi hpoint).trans ?_
    refine le_of_eq ?_
    refine setIntegral_congr_fun measurableSet_Ioi (fun t _ => ?_)
    ring


/-- `Λ₀` of **any** weak FE-pair is bounded on every vertical strip. -/
theorem norm_Lambda0_le (P : WeakFEPair ℂ) (a b : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, a ≤ s.re → s.re ≤ b → ‖P.Λ₀ s‖ ≤ C := by
  have htop : ∀ r : ℝ, P.f_modif =O[atTop] (· ^ r) := by
    intro r
    refine (P.hf_top r).congr' ?_ EventuallyEq.rfl
    filter_upwards [eventually_gt_atTop (1 : ℝ)] with x hx
    rw [WeakFEPair.f_modif, Pi.add_apply, Set.indicator_of_mem (Set.mem_Ioi.mpr hx),
      Set.indicator_of_notMem (Set.notMem_Ioo_of_ge hx.le), add_zero]
  have hbot : ∀ r : ℝ, P.f_modif =O[𝓝[>] (0 : ℝ)] (· ^ r) := by
    intro r
    refine (P.hf_zero r).congr' ?_ EventuallyEq.rfl
    have hlt : ∀ᶠ x : ℝ in 𝓝[>] (0 : ℝ), x < 1 := by
      rw [eventually_nhdsWithin_iff]
      filter_upwards [eventually_lt_nhds (by norm_num : (0 : ℝ) < 1)] with x hx _
      exact hx
    filter_upwards [self_mem_nhdsWithin, hlt] with x hx0 hx1
    rw [WeakFEPair.f_modif, Pi.add_apply, Set.indicator_of_notMem (Set.notMem_Ioi.mpr hx1.le),
      Set.indicator_of_mem (Set.mem_Ioo.mpr ⟨Set.mem_Ioi.mp hx0, hx1⟩), zero_add]
  exact norm_mellin_le P.hf_modif_int htop hbot

/-- `Λ` of a **strong** FE-pair is bounded on every vertical strip. -/
theorem norm_Lambda_le {P : WeakFEPair ℂ} (hP : IsStrongFEPair P) (a b : ℝ) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, a ≤ s.re → s.re ≤ b → ‖P.Λ s‖ ≤ C := by
  rw [hP.Λ_eq]
  exact norm_mellin_le P.hf_int hP.hf_top hP.hf_zero


/-- The completed even Hurwitz zeta (no pole) is bounded on the strip `0 ≤ Re s ≤ 1`. -/
theorem norm_completedHurwitzZetaEven₀_le (a : UnitAddCircle) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, 0 ≤ s.re → s.re ≤ 1 →
      ‖HurwitzZeta.completedHurwitzZetaEven₀ a s‖ ≤ C := by
  obtain ⟨C, hC0, hC⟩ := norm_Lambda0_le (HurwitzZeta.hurwitzEvenFEPair a) 0 (1 / 2)
  refine ⟨C / 2, by positivity, fun s hs0 hs1 => ?_⟩
  rw [HurwitzZeta.completedHurwitzZetaEven₀, norm_div]
  simp only [Complex.norm_ofNat]
  have hre : (s / 2).re = s.re / 2 := by
    rw [Complex.div_re]; simp [Complex.normSq_ofReal]; ring
  have h2 : (s / 2).re ≤ 1 / 2 := by rw [hre]; linarith
  have h0 : (0 : ℝ) ≤ (s / 2).re := by rw [hre]; linarith
  have := hC (s / 2) h0 h2
  linarith

/-- The completed odd Hurwitz zeta is bounded on the strip `0 ≤ Re s ≤ 1`. -/
theorem norm_completedHurwitzZetaOdd_le (a : UnitAddCircle) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ s : ℂ, 0 ≤ s.re → s.re ≤ 1 →
      ‖HurwitzZeta.completedHurwitzZetaOdd a s‖ ≤ C := by
  obtain ⟨C, hC0, hC⟩ := norm_Lambda_le (HurwitzZeta.isStrong_hurwitzOddFEPair a) (1 / 2) 1
  refine ⟨C / 2, by positivity, fun s hs0 hs1 => ?_⟩
  rw [HurwitzZeta.completedHurwitzZetaOdd, norm_div]
  simp only [Complex.norm_ofNat]
  have hre : ((s + 1) / 2).re = (s.re + 1) / 2 := by
    rw [Complex.div_re]; simp [Complex.normSq_ofReal]; ring
  have h2 : ((s + 1) / 2).re ≤ 1 := by rw [hre]; linarith
  have h0 : (1 / 2 : ℝ) ≤ ((s + 1) / 2).re := by rw [hre]; linarith
  have := hC ((s + 1) / 2) h0 h2
  linarith


/-- `Λ_χ = completedLFunction χ` is bounded on the closed strip `0 ≤ Re s ≤ 1`. -/
theorem norm_completedLFunction_strip_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ σ t : ℝ, 0 ≤ σ → σ ≤ 1 →
      ‖completedLFunction χ ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ C := by
  choose Ce hCe0 hCe using fun a : UnitAddCircle => norm_completedHurwitzZetaEven₀_le a
  choose Co hCo0 hCo using fun a : UnitAddCircle => norm_completedHurwitzZetaOdd_le a
  refine ⟨∑ j : ZMod N, (Ce (ZMod.toAddCircle j) + Co (ZMod.toAddCircle j)), ?_, ?_⟩
  · exact Finset.sum_nonneg fun j _ => add_nonneg (hCe0 _) (hCo0 _)
  · intro σ t hσ0 hσ1
    set s : ℂ := (σ : ℂ) + (t : ℂ) * Complex.I with hs
    have hsre : s.re = σ := by rw [hs]; simp
    have h0 : 0 ≤ s.re := by rw [hsre]; exact hσ0
    have h1 : s.re ≤ 1 := by rw [hsre]; exact hσ1
    have hEq : completedLFunction χ s = ZMod.completedLFunction₀ (χ : ZMod N → ℂ) s := by
      rw [completedLFunction, ZMod.completedLFunction_eq]
      simp [chi_zero_eq_zero χ hχ, MulChar.sum_eq_zero_of_ne_one hχ]
    have hN : ‖(N : ℂ) ^ (-s)‖ ≤ 1 := by
      rw [show ((N : ℂ)) = (((N : ℝ)) : ℂ) by push_cast; ring,
        Complex.norm_cpow_eq_rpow_re_of_pos (by exact_mod_cast NeZero.pos N)]
      have hre : (-s).re = -σ := by simp [hsre]
      rw [hre]
      have hN1 : (1 : ℝ) ≤ N := by
        exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
      calc (N : ℝ) ^ (-σ) ≤ (N : ℝ) ^ (0 : ℝ) :=
            Real.rpow_le_rpow_of_exponent_le hN1 (by linarith)
        _ = 1 := Real.rpow_zero _
    have hEven : ‖∑ j : ZMod N,
        χ (j : ZMod N) * HurwitzZeta.completedHurwitzZetaEven₀ (ZMod.toAddCircle j) s‖
        ≤ ∑ j : ZMod N, Ce (ZMod.toAddCircle j) := by
      refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun j _ => ?_)
      calc ‖χ (j : ZMod N) * HurwitzZeta.completedHurwitzZetaEven₀ (ZMod.toAddCircle j) s‖
          = ‖χ (j : ZMod N)‖ * ‖HurwitzZeta.completedHurwitzZetaEven₀ (ZMod.toAddCircle j) s‖ :=
            norm_mul _ _
        _ ≤ 1 * Ce (ZMod.toAddCircle j) :=
            mul_le_mul (χ.norm_le_one _) (hCe _ s h0 h1) (norm_nonneg _) zero_le_one
        _ = Ce (ZMod.toAddCircle j) := one_mul _
    have hOdd : ‖∑ j : ZMod N,
        χ (j : ZMod N) * HurwitzZeta.completedHurwitzZetaOdd (ZMod.toAddCircle j) s‖
        ≤ ∑ j : ZMod N, Co (ZMod.toAddCircle j) := by
      refine (norm_sum_le _ _).trans (Finset.sum_le_sum fun j _ => ?_)
      calc ‖χ (j : ZMod N) * HurwitzZeta.completedHurwitzZetaOdd (ZMod.toAddCircle j) s‖
          = ‖χ (j : ZMod N)‖ * ‖HurwitzZeta.completedHurwitzZetaOdd (ZMod.toAddCircle j) s‖ :=
            norm_mul _ _
        _ ≤ 1 * Co (ZMod.toAddCircle j) :=
            mul_le_mul (χ.norm_le_one _) (hCo _ s h0 h1) (norm_nonneg _) zero_le_one
        _ = Co (ZMod.toAddCircle j) := one_mul _
    rw [hEq, ZMod.completedLFunction₀]
    refine (norm_add_le _ _).trans ?_
    rw [norm_mul, norm_mul]
    calc ‖(N : ℂ) ^ (-s)‖ * ‖∑ j : ZMod N, χ (j : ZMod N) *
            HurwitzZeta.completedHurwitzZetaEven₀ (ZMod.toAddCircle j) s‖
          + ‖(N : ℂ) ^ (-s)‖ * ‖∑ j : ZMod N, χ (j : ZMod N) *
            HurwitzZeta.completedHurwitzZetaOdd (ZMod.toAddCircle j) s‖
        ≤ 1 * (∑ j : ZMod N, Ce (ZMod.toAddCircle j))
          + 1 * (∑ j : ZMod N, Co (ZMod.toAddCircle j)) :=
          add_le_add (mul_le_mul hN hEven (norm_nonneg _) zero_le_one)
            (mul_le_mul hN hOdd (norm_nonneg _) zero_le_one)
      _ = ∑ j : ZMod N, (Ce (ZMod.toAddCircle j) + Co (ZMod.toAddCircle j)) := by
          rw [one_mul, one_mul, ← Finset.sum_add_distrib]

/-- **Step 3b**: `dirichletCompleted χ = N^{s/2}·Λ_χ` is bounded on the closed critical strip. -/
theorem norm_dirichletCompleted_strip_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ σ t : ℝ, 0 ≤ σ → σ ≤ 1 →
      ‖dirichletCompleted χ ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ C := by
  obtain ⟨C, hC0, hC⟩ := norm_completedLFunction_strip_le χ hχ
  refine ⟨(N : ℝ) ^ (1 / 2 : ℝ) * C, by positivity, fun σ t hσ0 hσ1 => ?_⟩
  have hNpos : (0 : ℝ) < N := by exact_mod_cast NeZero.pos N
  rw [dirichletCompleted, norm_mul]
  have hNnorm : ‖(N : ℂ) ^ (((σ : ℂ) + (t : ℂ) * Complex.I) / 2)‖ = (N : ℝ) ^ (σ / 2) := by
    rw [show ((N : ℂ)) = (((N : ℝ)) : ℂ) by push_cast; ring,
      Complex.norm_cpow_eq_rpow_re_of_pos hNpos]
    congr 1
    simp
  rw [hNnorm]
  have hN1 : (1 : ℝ) ≤ N := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
  refine mul_le_mul ?_ (hC σ t hσ0 hσ1) (norm_nonneg _) (Real.rpow_nonneg hNpos.le _)
  calc (N : ℝ) ^ (σ / 2) ≤ (N : ℝ) ^ (1 / 2 : ℝ) :=
        Real.rpow_le_rpow_of_exponent_le hN1 (by linarith)


/-- `K ↦ K^{−σ} → 0` at `+∞` for `σ > 0`. -/
theorem tendsto_natCast_rpow_neg_atTop {σ : ℝ} (hσ : 0 < σ) :
    Tendsto (fun K : ℕ => ((K : ℕ) : ℝ) ^ (-σ)) atTop (𝓝 0) :=
  (tendsto_rpow_neg_atTop hσ).comp tendsto_natCast_atTop_atTop

/-- `K ↦ (K+1)^{−σ} → 0` at `+∞` for `σ > 0`. -/
theorem tendsto_natCast_succ_rpow_neg_atTop {σ : ℝ} (hσ : 0 < σ) :
    Tendsto (fun K : ℕ => (((K + 1 : ℕ)) : ℝ) ^ (-σ)) atTop (𝓝 0) := by
  have hc : Tendsto (fun K : ℕ => (((K + 1 : ℕ)) : ℝ)) atTop atTop :=
    (tendsto_natCast_atTop_atTop (R := ℝ)).comp (tendsto_add_atTop_nat 1)
  exact (tendsto_rpow_neg_atTop hσ).comp hc

/-- **Range-Cauchy of the Dirichlet series for `0 < Re s`.** -/
theorem cauchySeq_dirichlet_range {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 0 < s.re) :
    CauchySeq (fun k : ℕ => ∑ n ∈ Finset.range k,
      χ (n : ZMod N) * (((n + 1 : ℕ) : ℂ) ^ (-s))) := by
  have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hsr : (0 : ℝ) < s.re := hs
  rw [cauchySeq_iff_le_tendsto_0]
  refine ⟨fun K => (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re)
        + ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re))
      + ‖s‖ * (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re), ?_, ?_, ?_⟩
  · intro K
    have h1 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
      Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h2 : (0 : ℝ) ≤ ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
      Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h3 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg h1 hsr.le
    exact add_nonneg (mul_nonneg hNr (add_nonneg h1 h2))
      (mul_nonneg (mul_nonneg (norm_nonneg s) hNr) h3)
  · intro n m K hn hm
    have hdist : dist (∑ i ∈ Finset.range n, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
        (∑ i ∈ Finset.range m, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
        = ‖∑ i ∈ Finset.Ico (min n m) (max n m),
            χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))‖ := by
      rw [dist_eq_norm]
      rcases le_total n m with h | h
      · rw [min_eq_left h, max_eq_right h,
          Finset.sum_Ico_eq_sub (fun i => χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))) h,
          norm_sub_rev]
      · rw [min_eq_right h, max_eq_left h,
          Finset.sum_Ico_eq_sub (fun i => χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))) h]
    rw [hdist]
    rcases Nat.eq_zero_or_pos (max n m) with hc | hc
    · obtain ⟨hn0, hm0⟩ := Nat.max_eq_zero_iff.mp hc
      simp only [hn0, hm0, min_self, max_self, Finset.Ico_self, Finset.sum_empty, norm_zero]
      have h1 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_nonneg (Nat.cast_nonneg _) _
      have h2 : (0 : ℝ) ≤ ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_nonneg (Nat.cast_nonneg _) _
      have h3 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg h1 hsr.le
      have h4 : (0 : ℝ) ≤ (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re)
          + ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re)) := mul_nonneg hNr (add_nonneg h1 h2)
      have h5 : (0 : ℝ) ≤ ‖s‖ * (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re) :=
        mul_nonneg (mul_nonneg (norm_nonneg s) hNr) h3
      linarith
    · have ha' : max (min n m) 1 ≤ max n m := by omega
      have hsplit : ∑ i ∈ Finset.Ico (min n m) (max n m),
            χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))
          = ∑ i ∈ Finset.Ico (max (min n m) 1) (max n m),
              χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)) := by
        rw [← Finset.sum_Ico_consecutive
          (fun i => χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
          (le_max_left (min n m) 1) ha']
        have hzero : ∑ i ∈ Finset.Ico (min n m) (max (min n m) 1),
            χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)) = 0 := by
          refine Finset.sum_eq_zero fun i hi => ?_
          have hi0 : i = 0 := by
            simp only [Finset.mem_Ico] at hi
            omega
          subst hi0
          simp [chi_zero_eq_zero χ hχ]
        rw [hzero, zero_add]
      rw [hsplit]
      rcases lt_or_eq_of_le ha' with hlt | heq
      swap
      · rw [← heq, Finset.Ico_self, Finset.sum_empty, norm_zero]
        have h1 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
          Real.rpow_nonneg (Nat.cast_nonneg _) _
        have h2 : (0 : ℝ) ≤ ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
          Real.rpow_nonneg (Nat.cast_nonneg _) _
        have h3 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg h1 hsr.le
        have h4 : (0 : ℝ) ≤ (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re)
            + ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re)) := mul_nonneg hNr (add_nonneg h1 h2)
        have h5 : (0 : ℝ) ≤ ‖s‖ * (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re) :=
          mul_nonneg (mul_nonneg (norm_nonneg s) hNr) h3
        linarith
      have hkey := norm_sum_Ico_chi_cpow_le_of_pos χ hχ hs (m := max (min n m) 1)
        (n := max n m) (hm := by omega) (hmn := hlt)
      have hM1 : (0 : ℝ) < (((max K 1 : ℕ)) : ℝ) := by
        exact_mod_cast (by omega : 0 < max K 1)
      have h1 : (((max n m : ℕ)) : ℝ) ^ (-s.re) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_le_rpow_of_nonpos hM1
          (by exact_mod_cast (by omega : max K 1 ≤ max n m)) (by linarith)
      have h2 : ((((max (min n m) 1) + 1 : ℕ)) : ℝ) ^ (-s.re)
          ≤ ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_le_rpow_of_nonpos (by positivity)
          (by exact_mod_cast (by omega : max K 1 + 1 ≤ max (min n m) 1 + 1)) (by linarith)
      have h3 : (((max (min n m) 1 : ℕ)) : ℝ) ^ (-s.re)
          ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_le_rpow_of_nonpos (by positivity)
          (by exact_mod_cast (by omega : max K 1 ≤ max (min n m) 1)) (by linarith)
      have hsN : (0 : ℝ) ≤ ‖s‖ := norm_nonneg s
      have hK1 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_nonneg (Nat.cast_nonneg _) _
      have hK2 : (0 : ℝ) ≤ ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_nonneg (Nat.cast_nonneg _) _
      have hK3 : (0 : ℝ) ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg hK1 hsr.le
      have hca : (0 : ℝ) ≤ (((max (min n m) 1 : ℕ)) : ℝ) ^ (-s.re) / s.re :=
        div_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _) hsr.le
      have hN1 := mul_le_mul_of_nonneg_left h1 hNr
      have hN2 := mul_le_mul_of_nonneg_left h2 hNr
      have hdiv : (((max (min n m) 1 : ℕ)) : ℝ) ^ (-s.re) / s.re
          ≤ (((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := by
        rw [div_eq_mul_inv, div_eq_mul_inv]
        exact mul_le_mul_of_nonneg_right h3 (inv_nonneg.mpr hsr.le)
      have hN3 : ‖s‖ * ((N : ℝ) * ((((max (min n m) 1 : ℕ)) : ℝ) ^ (-s.re) / s.re))
          ≤ ‖s‖ * ((N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re)) :=
        mul_le_mul_of_nonneg_left (mul_le_mul_of_nonneg_left hdiv hNr) (norm_nonneg s)
      nlinarith [hkey, hN1, hN2, hN3]
  · have hsharp : Tendsto (fun K : ℕ => (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re)
          + (((K + 1 : ℕ)) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re) / s.re)) atTop (𝓝 0) := by
      have h1 : Tendsto (fun K : ℕ => ((K : ℕ) : ℝ) ^ (-s.re)) atTop (𝓝 0) :=
        tendsto_natCast_rpow_neg_atTop hs
      have h2 : Tendsto (fun K : ℕ => (((K + 1 : ℕ)) : ℝ) ^ (-s.re)) atTop (𝓝 0) :=
        tendsto_natCast_succ_rpow_neg_atTop hs
      have h3 : Tendsto (fun K : ℕ => (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re)
            + (((K + 1 : ℕ)) : ℝ) ^ (-s.re))) atTop (𝓝 0) := by
        have h := (h1.add h2).const_mul (N : ℝ)
        simpa using h
      have h4 : Tendsto (fun K : ℕ => ‖s‖ * (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re) / s.re))
          atTop (𝓝 0) := by
        have h := (h1.div_const s.re).const_mul (‖s‖ * (N : ℝ))
        simpa using h
      have h5 := h3.add h4
      simpa using h5
    have heq : (fun K : ℕ => (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re)
          + ((((max K 1) + 1 : ℕ)) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * ((((max K 1 : ℕ)) : ℝ) ^ (-s.re) / s.re))
        =ᶠ[atTop] fun K : ℕ => (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re)
          + (((K + 1 : ℕ)) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * (((K : ℕ) : ℝ) ^ (-s.re) / s.re) := by
      filter_upwards [eventually_ge_atTop 1] with K hK
      simp only [max_eq_left hK]
    exact Filter.Tendsto.congr' heq.symm hsharp

/-- **Difference bound with only the lower index.**  For `0 < Re s` and `k ≤ j`, the difference of the
`k`-th and `j`-th range partial sums of the Dirichlet series is bounded by a quantity depending on `k`
alone — the engine for both the Cauchy property and the local uniformity. -/
theorem norm_dirichlet_range_sub_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 0 < s.re) {k j : ℕ} (hkj : k ≤ j) :
    ‖(∑ i ∈ Finset.range k, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      - (∑ i ∈ Finset.range j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))‖
      ≤ (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re) := by
  have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hsr : (0 : ℝ) < s.re := hs
  have hbd : (0 : ℝ) ≤ (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re)
        + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-s.re))
      + ‖s‖ * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re) := by
    have h1 : (0 : ℝ) ≤ (((max k 1 : ℕ)) : ℝ) ^ (-s.re) :=
      Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h2 : (0 : ℝ) ≤ ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-s.re) :=
      Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h3 : (0 : ℝ) ≤ (((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg h1 hsr.le
    exact add_nonneg (mul_nonneg hNr (add_nonneg h1 h2))
      (mul_nonneg (mul_nonneg (norm_nonneg s) hNr) h3)
  have hsub : (∑ i ∈ Finset.range k, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      - (∑ i ∈ Finset.range j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      = -∑ i ∈ Finset.Ico k j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)) := by
    rw [Finset.sum_Ico_eq_sub (fun i => χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))) hkj]
    abel
  rw [hsub, norm_neg]
  rcases Nat.eq_zero_or_pos j with hj | hj
  · subst hj
    have hk0 : k = 0 := by omega
    rw [hk0, Finset.Ico_self, Finset.sum_empty, norm_zero]
    simpa [hk0] using hbd
  · have hsplit : ∑ i ∈ Finset.Ico k j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))
        = ∑ i ∈ Finset.Ico (max k 1) j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)) := by
      rw [← Finset.sum_Ico_consecutive (fun i => χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
        (le_max_left k 1) (by omega)]
      have hzero : ∑ i ∈ Finset.Ico k (max k 1),
          χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)) = 0 := by
        refine Finset.sum_eq_zero fun i hi => ?_
        have hi0 : i = 0 := by simp only [Finset.mem_Ico] at hi; omega
        subst hi0
        simp [chi_zero_eq_zero χ hχ]
      rw [hzero, zero_add]
    rw [hsplit]
    rcases lt_or_eq_of_le (show max k 1 ≤ j by omega) with hlt | heq
    swap
    · rw [← heq, Finset.Ico_self, Finset.sum_empty, norm_zero]
      exact hbd
    · have hkey := norm_sum_Ico_chi_cpow_le_of_pos χ hχ hs (m := max k 1) (n := j)
        (by omega) hlt
      have hM1 : (0 : ℝ) < (((max k 1 : ℕ)) : ℝ) := by
        exact_mod_cast (by omega : 0 < max k 1)
      have h1 : (((j : ℕ)) : ℝ) ^ (-s.re) ≤ (((max k 1 : ℕ)) : ℝ) ^ (-s.re) :=
        Real.rpow_le_rpow_of_nonpos hM1 (by exact_mod_cast (by omega : max k 1 ≤ j))
          (by linarith)
      have hN1 := mul_le_mul_of_nonneg_left h1 hNr
      nlinarith [hkey, hN1, hNr, norm_nonneg s, hsr]

/-- **Uniform Cauchy of the Dirichlet partial sums on a strip.** -/
theorem eventually_uniform_dirichlet_range_sub_lt {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {δ R ε : ℝ} (hδ : 0 < δ) (hε : 0 < ε) :
    ∀ᶠ k : ℕ in atTop, ∀ j ≥ k, ∀ s : ℂ, δ ≤ s.re → ‖s‖ ≤ R →
      ‖(∑ i ∈ Finset.range k, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
        - (∑ i ∈ Finset.range j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))‖ < ε := by
  have hN0 : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hsharp : Tendsto (fun k : ℕ => (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ)
        + (((k + 1 : ℕ)) : ℝ) ^ (-δ))
      + R * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) / δ)) atTop (𝓝 0) := by
    have h1 : Tendsto (fun k : ℕ => ((k : ℕ) : ℝ) ^ (-δ)) atTop (𝓝 0) :=
      tendsto_natCast_rpow_neg_atTop hδ
    have h2 : Tendsto (fun k : ℕ => (((k + 1 : ℕ)) : ℝ) ^ (-δ)) atTop (𝓝 0) :=
      tendsto_natCast_succ_rpow_neg_atTop hδ
    have h3 : Tendsto (fun k : ℕ => (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ)
          + (((k + 1 : ℕ)) : ℝ) ^ (-δ))) atTop (𝓝 0) := by
      simpa using (h1.add h2).const_mul (N : ℝ)
    have h4 : Tendsto (fun k : ℕ => R * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) / δ))
        atTop (𝓝 0) := by
      simpa using (h1.div_const δ).const_mul (R * (N : ℝ))
    simpa using h3.add h4
  have heq : (fun k : ℕ => (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ)
        + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-δ))
      + R * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ))
      =ᶠ[atTop] fun k : ℕ => (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ)
        + (((k + 1 : ℕ)) : ℝ) ^ (-δ))
      + R * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) / δ) := by
    filter_upwards [eventually_ge_atTop 1] with k hK
    simp only [max_eq_left hK]
  have hlim : Tendsto (fun k : ℕ => (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ)
        + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-δ))
      + R * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ)) atTop (𝓝 0) :=
    Filter.Tendsto.congr' heq.symm hsharp
  filter_upwards [hlim.eventually (eventually_lt_nhds hε)] with k hk
  intro j hjk s hsre hsR
  have hsre0 : (0 : ℝ) < s.re := lt_of_lt_of_le hδ hsre
  have hR0 : (0 : ℝ) ≤ R := le_trans (norm_nonneg s) hsR
  have hM1 : (1 : ℝ) ≤ (((max k 1 : ℕ)) : ℝ) := by exact_mod_cast le_max_right k 1
  have hx1 : (((max k 1 : ℕ)) : ℝ) ^ (-s.re) ≤ (((max k 1 : ℕ)) : ℝ) ^ (-δ) :=
    Real.rpow_le_rpow_of_exponent_le hM1 (by linarith)
  have hy1 : ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-s.re)
      ≤ ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-δ) :=
    Real.rpow_le_rpow_of_exponent_le (by exact_mod_cast (by omega : 1 ≤ max k 1 + 1))
      (by linarith)
  have hx2 : (((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re
      ≤ (((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ := by
    rw [div_eq_mul_inv, div_eq_mul_inv]
    exact mul_le_mul hx1 (by rw [inv_eq_one_div, inv_eq_one_div]; exact one_div_le_one_div_of_le hδ hsre)
      (inv_nonneg.mpr hsre0.le) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  have hN1 : (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re)
        + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-s.re))
      ≤ (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ)
        + ((((max k 1) + 1 : ℕ)) : ℝ) ^ (-δ)) :=
    mul_le_mul_of_nonneg_left (add_le_add hx1 hy1) hN0
  have hN2 : ‖s‖ * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re)
      ≤ R * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ) := by
    have hinner : (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re)
        ≤ (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ) :=
      mul_le_mul_of_nonneg_left hx2 hN0
    have hmain : ‖s‖ * ((N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re))
        ≤ R * ((N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ)) :=
      mul_le_mul hsR hinner
        (mul_nonneg hN0 (div_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _) hsre0.le)) hR0
    calc ‖s‖ * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re)
        = ‖s‖ * ((N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-s.re) / s.re)) := by ring
      _ ≤ R * ((N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ)) := hmain
      _ = R * (N : ℝ) * ((((max k 1 : ℕ)) : ℝ) ^ (-δ) / δ) := by ring
  refine lt_of_le_of_lt ?_ hk
  exact (norm_dirichlet_range_sub_le χ hχ hsre0 hjk).trans (add_le_add hN1 hN2)

/-- The pointwise limit of the Dirichlet range partial sums on `0 < Re s` (and `0` elsewhere). -/
noncomputable def dirichletRangeLimit {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (s : ℂ) : ℂ :=
  if h : 0 < s.re then
    Classical.choose (cauchySeq_tendsto_of_complete (cauchySeq_dirichlet_range χ hχ h))
  else 0

theorem tendsto_dirichletRangeLimit {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun k : ℕ => ∑ i ∈ Finset.range k,
      χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s))) atTop (𝓝 (dirichletRangeLimit χ hχ s)) := by
  rw [dirichletRangeLimit, dif_pos hs]
  exact Classical.choose_spec
    (cauchySeq_tendsto_of_complete (cauchySeq_dirichlet_range χ hχ hs))

/-- **Step 2b.**  The Dirichlet range partial sums converge locally uniformly on `0 < Re s` to
`dirichletRangeLimit`, whose analyticity on that half-plane follows. -/
theorem tendstoLocallyUniformlyOn_dirichletRangeLimit {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    TendstoLocallyUniformlyOn (fun k : ℕ => fun s : ℂ =>
        ∑ i ∈ Finset.range k, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      (dirichletRangeLimit χ hχ) atTop {s : ℂ | 0 < s.re} := by
  rw [Metric.tendstoLocallyUniformlyOn_iff]
  intro ε hε x hx
  simp only [Set.mem_setOf_eq] at hx
  have hU : {y : ℂ | x.re / 2 < y.re ∧ ‖y‖ < ‖x‖ + 1} ∈ 𝓝 x := by
    refine ((isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt continuous_norm continuous_const)).mem_nhds ?_
    simp only [Set.mem_inter_iff, Set.mem_setOf_eq]
    exact ⟨by linarith, by linarith⟩
  refine ⟨{y : ℂ | x.re / 2 < y.re ∧ ‖y‖ < ‖x‖ + 1},
    mem_nhdsWithin_of_mem_nhds hU, ?_⟩
  filter_upwards [eventually_uniform_dirichlet_range_sub_lt χ hχ (δ := x.re / 2)
      (R := ‖x‖ + 1) (ε := ε / 2) (by linarith) (by linarith)] with k hk
  intro y hy
  have hy0 : 0 < y.re := by linarith [hx, hy.1]
  have hlim := tendsto_dirichletRangeLimit χ hχ (s := y) hy0
  have hdl : Tendsto (fun j : ℕ => dist ((∑ i ∈ Finset.range k,
        χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-y))))
      (∑ i ∈ Finset.range j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-y))))
      atTop (𝓝 (dist ((∑ i ∈ Finset.range k,
        χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-y)))) (dirichletRangeLimit χ hχ y))) :=
    tendsto_const_nhds.dist hlim
  have hev : ∀ᶠ j : ℕ in atTop, dist ((∑ i ∈ Finset.range k,
        χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-y))))
      (∑ i ∈ Finset.range j, χ (i : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-y))) ≤ ε / 2 := by
    filter_upwards [eventually_ge_atTop k] with j hj
    simpa only [dist_eq_norm] using le_of_lt (hk j hj y hy.1.le hy.2.le)
  have hfin := le_of_tendsto hdl hev
  rw [dist_comm]
  linarith

/-- **Step 2c.**  `dirichletRangeLimit` is holomorphic on `0 < Re s`. -/
theorem differentiableOn_dirichletRangeLimit {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    DifferentiableOn ℂ (dirichletRangeLimit χ hχ) {s : ℂ | 0 < s.re} := by
  refine (tendstoLocallyUniformlyOn_dirichletRangeLimit χ hχ).differentiableOn ?_
    (isOpen_lt continuous_const Complex.continuous_re)
  filter_upwards with k
  induction k with
  | zero =>
    simpa only [Finset.range_zero, Finset.sum_empty] using differentiableOn_const (0 : ℂ)
  | succ k ih =>
    simp only [Finset.sum_range_succ]
    refine DifferentiableOn.add ih ?_
    have hc : (((k + 1 : ℕ)) : ℂ) ≠ 0 := by
      exact_mod_cast (by omega : k + 1 ≠ 0)
    intro s hs
    exact ((DifferentiableAt.const_cpow (differentiableAt_id.neg) (Or.inl hc)).const_mul
      (χ (k : ZMod N))).differentiableWithinAt

/-- The two partial-sum sequences of the Dirichlet series differ by the shift `n ↦ n+1`. -/
theorem dirichlet_range_shift {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    (s : ℂ) (j : ℕ) :
    (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ) : ℂ) ^ (-s)))
      = ∑ n ∈ Finset.range (j + 1), χ (n : ZMod N) * (((n : ℕ)) : ℂ) ^ (-s) := by
  simp only [Finset.sum_range_succ']
  have h0 : χ ((0 : ℕ) : ZMod N) * (((0 : ℕ)) : ℂ) ^ (-s) = 0 := by
    simp [chi_zero_eq_zero χ hχ]
  rw [h0, add_zero]

/-- The Dirichlet summand agrees with the `LSeries` term. -/
theorem dirichlet_term_eq_LSeries_term {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (s : ℂ) (n : ℕ) :
    χ (n : ZMod N) * (((n : ℕ)) : ℂ) ^ (-s)
      = LSeries.term (fun x => χ (x : ZMod N)) s n := by
  rcases eq_or_ne n 0 with h | h
  · subst h
    simp [chi_zero_eq_zero χ hχ, LSeries.term_def]
  · rw [LSeries.term_of_ne_zero h, Complex.cpow_neg, div_eq_mul_inv]

/-- For `1 < Re s` the standard Dirichlet partial sums converge to `LFunction χ s`. -/
theorem tendsto_sum_range_LFunction {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1)
    {s : ℂ} (hs : 1 < s.re) :
    Tendsto (fun k : ℕ => ∑ n ∈ Finset.range k, χ (n : ZMod N) * (((n : ℕ)) : ℂ) ^ (-s))
      atTop (𝓝 (LFunction χ s)) := by
  have hg : Summable (fun n : ℕ => 1 / ((n : ℝ) ^ s.re)) :=
    Real.summable_one_div_nat_rpow.mpr hs
  have hS : Summable (LSeries.term (fun x => χ (x : ZMod N)) s) := by
    refine Summable.of_norm_bounded_eventually hg (Filter.Eventually.of_forall fun n => ?_)
    rcases eq_or_ne n 0 with h | h
    · subst h
      rw [LSeries.term_def, if_pos rfl, norm_zero]
      exact div_nonneg zero_le_one (Real.rpow_nonneg (Nat.cast_nonneg 0) s.re)
    · rw [LSeries.term_of_ne_zero h, norm_div,
        Complex.norm_natCast_cpow_of_pos (Nat.pos_of_ne_zero h)]
      exact div_le_div_of_nonneg_right (DirichletCharacter.norm_le_one χ (n : ZMod N))
        (Real.rpow_nonneg (Nat.cast_nonneg n) _)
  have h1 : Tendsto (fun k : ℕ => ∑ n ∈ Finset.range k,
      LSeries.term (fun x => χ (x : ZMod N)) s n) atTop
      (𝓝 (∑' n, LSeries.term (fun x => χ (x : ZMod N)) s n)) :=
    hS.hasSum.tendsto_sum_nat
  have h2 : (∑' n, LSeries.term (fun x => χ (x : ZMod N)) s n) = LFunction χ s := by
    change LSeries (fun x => χ (x : ZMod N)) s = LFunction χ s
    rw [LFunction_eq_LSeries χ hs]
  rw [h2] at h1
  exact Tendsto.congr' (Filter.Eventually.of_forall fun k =>
    Finset.sum_congr rfl fun n _ => (dirichlet_term_eq_LSeries_term χ hχ s n).symm) h1

/-- Difference bound with only the lower index, for the **correct** Dirichlet partial sums
`E k = ∑_{i<k} χ(i+1)·(i+1)^{−s}`, valid for `1 ≤ k` (so no `χ(1)` correction term arises). -/
theorem norm_dirichletSucc_range_sub_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) {k j : ℕ} (hk : 1 ≤ k) (hkj : k ≤ j) :
    ‖(∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
      - (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))‖
      ≤ (N : ℝ) * (((k : ℕ) : ℝ) ^ (-s.re) + (((k + 1 : ℕ)) : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-s.re) / s.re) := by
  have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hsr : (0 : ℝ) < s.re := hs
  have hsub : (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
      - (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
      = -∑ i ∈ Finset.Ico k j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s) := by
    rw [Finset.sum_Ico_eq_sub
      (fun i => χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)) hkj]
    abel
  rw [hsub, norm_neg]
  rcases lt_or_eq_of_le hkj with hlt | heq
  · have hkey := norm_sum_Ico_chi_succ_cpow_le_of_pos χ hχ hs (m := k) (n := j) hk hlt
    have hkpos : (0 : ℝ) < ((k : ℕ) : ℝ) := by exact_mod_cast (by omega : 0 < k)
    have h1 : (((j : ℕ)) : ℝ) ^ (-s.re) ≤ (((k : ℕ)) : ℝ) ^ (-s.re) :=
      Real.rpow_le_rpow_of_nonpos hkpos (by exact_mod_cast hkj) (by linarith)
    have hN1 := mul_le_mul_of_nonneg_left h1 hNr
    have hK1 : (0 : ℝ) ≤ (((k : ℕ)) : ℝ) ^ (-s.re) := Real.rpow_nonneg (Nat.cast_nonneg _) _
    have hK2 : (0 : ℝ) ≤ (((k + 1 : ℕ)) : ℝ) ^ (-s.re) := Real.rpow_nonneg (Nat.cast_nonneg _) _
    have hK3 : (0 : ℝ) ≤ (((k : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg hK1 hsr.le
    nlinarith [hkey, hN1, hNr, norm_nonneg s, hK1, hK2, hK3]
  · rw [← heq, Finset.Ico_self, Finset.sum_empty, norm_zero]
    have h1 : (0 : ℝ) ≤ (((k : ℕ)) : ℝ) ^ (-s.re) := Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h2 : (0 : ℝ) ≤ (((k + 1 : ℕ)) : ℝ) ^ (-s.re) := Real.rpow_nonneg (Nat.cast_nonneg _) _
    have h3 : (0 : ℝ) ≤ (((k : ℕ)) : ℝ) ^ (-s.re) / s.re := div_nonneg h1 hsr.le
    have h4 : (0 : ℝ) ≤ (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) + (((k + 1 : ℕ)) : ℝ) ^ (-s.re)) :=
      mul_nonneg hNr (add_nonneg h1 h2)
    have h5 : (0 : ℝ) ≤ ‖s‖ * (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re) :=
      mul_nonneg (mul_nonneg (norm_nonneg s) hNr) h3
    linarith

/-- Uniform Cauchy on a strip, for the **correct** Dirichlet partial sums. -/
theorem eventually_uniform_dirichletSucc_range_sub_lt {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {δ R ε : ℝ} (hδ : 0 < δ) (hε : 0 < ε) :
    ∀ᶠ k : ℕ in atTop, ∀ j ≥ k, ∀ s : ℂ, δ ≤ s.re → ‖s‖ ≤ R →
      ‖(∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
        - (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))‖ < ε := by
  have hN0 : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hsharp : Tendsto (fun k : ℕ => (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) + (((k + 1 : ℕ)) : ℝ) ^ (-δ))
      + R * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) / δ)) atTop (𝓝 0) := by
    have h1 : Tendsto (fun k : ℕ => ((k : ℕ) : ℝ) ^ (-δ)) atTop (𝓝 0) :=
      tendsto_natCast_rpow_neg_atTop hδ
    have h2 : Tendsto (fun k : ℕ => (((k + 1 : ℕ)) : ℝ) ^ (-δ)) atTop (𝓝 0) :=
      tendsto_natCast_succ_rpow_neg_atTop hδ
    have h3 : Tendsto (fun k : ℕ => (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ)
          + (((k + 1 : ℕ)) : ℝ) ^ (-δ))) atTop (𝓝 0) := by
      simpa using (h1.add h2).const_mul (N : ℝ)
    have h4 : Tendsto (fun k : ℕ => R * (N : ℝ) * (((k : ℕ) : ℝ) ^ (-δ) / δ)) atTop (𝓝 0) := by
      simpa using (h1.div_const δ).const_mul (R * (N : ℝ))
    simpa using h3.add h4
  filter_upwards [hsharp.eventually (eventually_lt_nhds hε), eventually_ge_atTop 1] with k hk hk1
  intro j hjk s hsre hsR
  have hsre0 : (0 : ℝ) < s.re := lt_of_lt_of_le hδ hsre
  have hR0 : (0 : ℝ) ≤ R := le_trans (norm_nonneg s) hsR
  have hk1r : (1 : ℝ) ≤ ((k : ℕ) : ℝ) := by exact_mod_cast hk1
  have hx1 : (((k : ℕ) : ℝ)) ^ (-s.re) ≤ (((k : ℕ) : ℝ)) ^ (-δ) :=
    Real.rpow_le_rpow_of_exponent_le hk1r (by linarith)
  have hy1 : (((k + 1 : ℕ)) : ℝ) ^ (-s.re) ≤ (((k + 1 : ℕ)) : ℝ) ^ (-δ) :=
    Real.rpow_le_rpow_of_exponent_le (by exact_mod_cast (by omega : 1 ≤ k + 1)) (by linarith)
  have hx2 : (((k : ℕ) : ℝ)) ^ (-s.re) / s.re ≤ (((k : ℕ) : ℝ)) ^ (-δ) / δ := by
    rw [div_eq_mul_inv, div_eq_mul_inv]
    exact mul_le_mul hx1
      (by rw [inv_eq_one_div, inv_eq_one_div]; exact one_div_le_one_div_of_le hδ hsre)
      (inv_nonneg.mpr hsre0.le) (Real.rpow_nonneg (Nat.cast_nonneg _) _)
  have hN1 : (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) + (((k + 1 : ℕ)) : ℝ) ^ (-s.re))
      ≤ (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) + (((k + 1 : ℕ)) : ℝ) ^ (-δ)) :=
    mul_le_mul_of_nonneg_left (add_le_add hx1 hy1) hN0
  have hN2 : ‖s‖ * (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re)
      ≤ R * (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) / δ) := by
    have hinner : (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re)
        ≤ (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) / δ) := mul_le_mul_of_nonneg_left hx2 hN0
    have hmain : ‖s‖ * ((N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re))
        ≤ R * ((N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) / δ)) :=
      mul_le_mul hsR hinner
        (mul_nonneg hN0 (div_nonneg (Real.rpow_nonneg (Nat.cast_nonneg _) _) hsre0.le)) hR0
    calc ‖s‖ * (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re)
        = ‖s‖ * ((N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-s.re) / s.re)) := by ring
      _ ≤ R * ((N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) / δ)) := hmain
      _ = R * (N : ℝ) * ((((k : ℕ)) : ℝ) ^ (-δ) / δ) := by ring
  refine lt_of_le_of_lt ?_ hk
  exact (norm_dirichletSucc_range_sub_le χ hχ (s := s) (k := k) (j := j) hsre0 hk1 hjk).trans
    (add_le_add hN1 hN2)

theorem cauchySeq_dirichletSucc_range {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) :
    CauchySeq (fun k : ℕ => ∑ i ∈ Finset.range k,
      χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)) := by
  rw [Metric.cauchySeq_iff]
  intro ε hε
  obtain ⟨K, hK⟩ := Filter.eventually_atTop.mp
    (eventually_uniform_dirichletSucc_range_sub_lt χ hχ (δ := s.re) (R := ‖s‖) hs hε)
  refine ⟨max K 1, fun n hn m hm => ?_⟩
  rcases le_total n m with h | h
  · rw [dist_eq_norm]
    exact hK n (le_trans (le_max_left K 1) hn) m h s le_rfl le_rfl
  · rw [dist_eq_norm, norm_sub_rev]
    exact hK m (le_trans (le_max_left K 1) hm) n h s le_rfl le_rfl

noncomputable def dirichletSuccRangeLimit {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (s : ℂ) : ℂ :=
  if h : 0 < s.re then
    Classical.choose (cauchySeq_tendsto_of_complete (cauchySeq_dirichletSucc_range χ hχ h))
  else 0

theorem tendsto_dirichletSuccRangeLimit {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) :
    Tendsto (fun k : ℕ => ∑ i ∈ Finset.range k,
      χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)) atTop
      (𝓝 (dirichletSuccRangeLimit χ hχ s)) := by
  rw [dirichletSuccRangeLimit, dif_pos hs]
  exact Classical.choose_spec
    (cauchySeq_tendsto_of_complete (cauchySeq_dirichletSucc_range χ hχ hs))

/-- Local uniform convergence of the corrected partial sums to `dirichletSuccRangeLimit`. -/
theorem tendstoLocallyUniformlyOn_dirichletSuccRangeLimit {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    TendstoLocallyUniformlyOn (fun k : ℕ => fun s : ℂ =>
        ∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
      (dirichletSuccRangeLimit χ hχ) atTop {s : ℂ | 0 < s.re} := by
  rw [Metric.tendstoLocallyUniformlyOn_iff]
  intro ε hε x hx
  simp only [Set.mem_setOf_eq] at hx
  have hU : {y : ℂ | x.re / 2 < y.re ∧ ‖y‖ < ‖x‖ + 1} ∈ 𝓝 x := by
    refine ((isOpen_lt continuous_const Complex.continuous_re).inter
      (isOpen_lt continuous_norm continuous_const)).mem_nhds ?_
    simp only [Set.mem_inter_iff, Set.mem_setOf_eq]
    exact ⟨by linarith, by linarith⟩
  refine ⟨{y : ℂ | x.re / 2 < y.re ∧ ‖y‖ < ‖x‖ + 1},
    mem_nhdsWithin_of_mem_nhds hU, ?_⟩
  filter_upwards [eventually_uniform_dirichletSucc_range_sub_lt χ hχ (δ := x.re / 2)
      (R := ‖x‖ + 1) (ε := ε / 2) (by linarith) (by linarith)] with k hk
  intro y hy
  have hy0 : 0 < y.re := by linarith [hx, hy.1]
  have hlim := tendsto_dirichletSuccRangeLimit χ hχ (s := y) hy0
  have hdl : Tendsto (fun j : ℕ => dist
      (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-y))
      (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-y)))
      atTop (𝓝 (dist
        (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-y))
        (dirichletSuccRangeLimit χ hχ y))) :=
    tendsto_const_nhds.dist hlim
  have hev : ∀ᶠ j : ℕ in atTop, dist
      (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-y))
      (∑ i ∈ Finset.range j, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-y)) ≤ ε / 2 := by
    filter_upwards [eventually_ge_atTop k] with j hj
    simpa only [dist_eq_norm] using le_of_lt (hk j hj y hy.1.le hy.2.le)
  have hfin := le_of_tendsto hdl hev
  rw [dist_comm]
  linarith

/-- Holomorphy of `dirichletSuccRangeLimit` on `0 < Re s`. -/
theorem differentiableOn_dirichletSuccRangeLimit {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    DifferentiableOn ℂ (dirichletSuccRangeLimit χ hχ) {s : ℂ | 0 < s.re} := by
  refine (tendstoLocallyUniformlyOn_dirichletSuccRangeLimit χ hχ).differentiableOn ?_
    (isOpen_lt continuous_const Complex.continuous_re)
  filter_upwards with k
  induction k with
  | zero =>
    simpa only [Finset.range_zero, Finset.sum_empty] using differentiableOn_const (0 : ℂ)
  | succ k ih =>
    simp only [Finset.sum_range_succ]
    refine DifferentiableOn.add ih ?_
    have hc : (((k + 1 : ℕ)) : ℂ) ≠ 0 := by exact_mod_cast (by omega : k + 1 ≠ 0)
    intro s hs
    exact ((DifferentiableAt.const_cpow (differentiableAt_id.neg) (Or.inl hc)).const_mul
      (χ ((k + 1 : ℕ) : ZMod N))).differentiableWithinAt

/-- On `1 < Re s` the corrected range limit is `LFunction`. -/
theorem dirichletSuccRangeLimit_eq_LFunction {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 1 < s.re) :
    dirichletSuccRangeLimit χ hχ s = LFunction χ s := by
  have hD : Tendsto (fun j : ℕ => ∑ n ∈ Finset.range (j + 1),
      χ (n : ZMod N) * ((n : ℂ) ^ (-s))) atTop (𝓝 (LFunction χ s)) :=
    (tendsto_sum_range_LFunction χ hχ hs).comp (tendsto_add_atTop_nat 1)
  have hE : Tendsto (fun j : ℕ => ∑ i ∈ Finset.range j,
      χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)) atTop (𝓝 (LFunction χ s)) := by
    refine Tendsto.congr' (Filter.Eventually.of_forall fun j => ?_) hD
    exact (dirichlet_range_shift χ hχ s j).symm
  exact tendsto_nhds_unique
    (tendsto_dirichletSuccRangeLimit χ hχ (s := s) (by linarith : (0 : ℝ) < s.re)) hE

/-- **The identification**: `LFunction` and the corrected range limit agree on the whole half-plane
`0 < Re s` (they agree on `1 < Re s` by §251 and both are holomorphic). -/
theorem LFunction_eq_dirichletSuccRangeLimit {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {s : ℂ} (hs : 0 < s.re) :
    LFunction χ s = dirichletSuccRangeLimit χ hχ s := by
  have hU : IsOpen {s : ℂ | 0 < s.re} := isOpen_lt continuous_const Complex.continuous_re
  have hconn : IsPreconnected {s : ℂ | 0 < s.re} := (convex_halfSpace_re_gt 0).isPreconnected
  have hf : AnalyticOnNhd ℂ (LFunction χ) {s : ℂ | 0 < s.re} :=
    (differentiable_LFunction hχ).differentiableOn.analyticOnNhd hU
  have hg : AnalyticOnNhd ℂ (dirichletSuccRangeLimit χ hχ) {s : ℂ | 0 < s.re} :=
    (differentiableOn_dirichletSuccRangeLimit χ hχ).analyticOnNhd hU
  have h2 : (2 : ℂ) ∈ {s : ℂ | 0 < s.re} := by norm_num
  have hmem : {z : ℂ | 1 < z.re} ∈ 𝓝 (2 : ℂ) :=
    (isOpen_lt continuous_const Complex.continuous_re).mem_nhds (by norm_num : (1 : ℝ) < (2 : ℂ).re)
  have heq : LFunction χ =ᶠ[𝓝 (2 : ℂ)] dirichletSuccRangeLimit χ hχ :=
    Filter.eventually_iff_exists_mem.mpr ⟨{z : ℂ | 1 < z.re}, hmem, fun z hz =>
      (dirichletSuccRangeLimit_eq_LFunction χ hχ (s := z) hz).symm⟩
  exact AnalyticOnNhd.eqOn_of_preconnected_of_eventuallyEq hf hg hconn h2 heq hs

/-- **The convexity substitute**: `LFunction` is polynomially bounded on `1/2 ≤ Re s ≤ 2`. -/
theorem exists_norm_LFunction_strip_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ σ t : ℝ, 1 / 2 ≤ σ → σ ≤ 2 →
      ‖LFunction χ ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ C * (1 + |t|) := by
  have key : ∀ s : ℂ, 1 / 2 ≤ s.re → ‖LFunction χ s‖ ≤ 1 + 2 * (N : ℝ) + 2 * ‖s‖ * (N : ℝ) := by
    intro s hs
    have hs0 : 0 < s.re := by linarith
    have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
    have hsn : (0 : ℝ) ≤ ‖s‖ := norm_nonneg s
    have hE1 : ‖∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)‖ = 1 := by
      rw [Finset.sum_range_one, Nat.cast_one, Nat.cast_one, map_one χ, one_mul,
        Complex.one_cpow, norm_one]
    have hB : ‖dirichletSuccRangeLimit χ hχ s‖ ≤ 1 + (N : ℝ) * (1 + (2 : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * s.re⁻¹ := by
      have hT := (tendsto_dirichletSuccRangeLimit χ hχ (s := s) hs0).norm
      refine le_of_tendsto hT ?_
      filter_upwards [eventually_ge_atTop 1] with k hk
      have hd := norm_dirichletSucc_range_sub_le χ hχ (s := s) hs0 (k := 1) (j := k) (le_refl 1) hk
      simp only [Nat.cast_one, Real.one_rpow, one_div, one_mul] at hd
      have hdec : (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
          = (∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
            + ((∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
              - (∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))) := by
        abel
      rw [hdec]
      refine (norm_add_le _ _).trans ?_
      rw [hE1, norm_sub_rev]
      linarith [hd]
    rw [LFunction_eq_dirichletSuccRangeLimit χ hχ hs0]
    refine hB.trans ?_
    have h2p : (2 : ℝ) ^ (-s.re) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by linarith)
    have hinv : s.re⁻¹ ≤ 2 := by
      rw [inv_eq_one_div, div_le_iff₀ hs0]
      linarith
    have hA : (N : ℝ) * (2 : ℝ) ^ (-s.re) ≤ (N : ℝ) := by
      simpa using mul_le_mul_of_nonneg_left h2p hNr
    have hC : ‖s‖ * (N : ℝ) * s.re⁻¹ ≤ ‖s‖ * (N : ℝ) * 2 :=
      mul_le_mul_of_nonneg_left hinv (mul_nonneg hsn hNr)
    linarith [hA, hC, hNr, hsn]
  refine ⟨1 + 8 * (N : ℝ), by positivity, fun σ t hσ1 hσ2 => ?_⟩
  have hpt : (((σ : ℂ) + (t : ℂ) * Complex.I)).re = σ := by simp
  have h1 := key ((σ : ℂ) + (t : ℂ) * Complex.I) (by rw [hpt]; exact hσ1)
  refine h1.trans ?_
  have h1n : ‖(σ : ℂ)‖ = |σ| := by simp
  have h3n : ‖(t : ℂ) * Complex.I‖ = |t| := by simp
  have hnorm : ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ ≤ 2 + |t| := by
    have h := norm_add_le (σ : ℂ) ((t : ℂ) * Complex.I)
    rw [h1n, h3n, abs_of_nonneg (by linarith : (0 : ℝ) ≤ σ)] at h
    linarith
  have hN1 : (1 : ℝ) ≤ (N : ℝ) := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
  have hN0 : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hat : (0 : ℝ) ≤ |t| := abs_nonneg t
  have hsc : 2 * ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ * (N : ℝ) ≤ 2 * (2 + |t|) * (N : ℝ) := by
    have h2n : (0 : ℝ) ≤ 2 * (N : ℝ) := by positivity
    nlinarith [hnorm, hN0, h2n]
  nlinarith [hsc, hN0, hN1, hat, hσ2]

/-- `LFunction` is polynomially bounded on **every** right half-plane `Re s > 0`. -/
theorem exists_norm_LFunction_le_div {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ∃ C : ℝ, 0 < C ∧ ∀ σ t : ℝ, 0 < σ → σ ≤ 2 →
      ‖LFunction χ ((σ : ℂ) + (t : ℂ) * Complex.I)‖ ≤ C * (1 + |t|) / σ := by
  have key : ∀ s : ℂ, 0 < s.re →
      ‖LFunction χ s‖ ≤ 1 + 2 * (N : ℝ) + ‖s‖ * (N : ℝ) / s.re := by
    intro s hs
    have hs0 : 0 < s.re := hs
    have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
    have hsn : (0 : ℝ) ≤ ‖s‖ := norm_nonneg s
    have hE1 : ‖∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s)‖ = 1 := by
      rw [Finset.sum_range_one, Nat.cast_one, Nat.cast_one, map_one χ, one_mul,
        Complex.one_cpow, norm_one]
    have hB : ‖dirichletSuccRangeLimit χ hχ s‖ ≤ 1 + (N : ℝ) * (1 + (2 : ℝ) ^ (-s.re))
        + ‖s‖ * (N : ℝ) * s.re⁻¹ := by
      have hT := (tendsto_dirichletSuccRangeLimit χ hχ (s := s) hs0).norm
      refine le_of_tendsto hT ?_
      filter_upwards [eventually_ge_atTop 1] with k hk
      have hd := norm_dirichletSucc_range_sub_le χ hχ (s := s) hs0 (k := 1) (j := k) (le_refl 1) hk
      simp only [Nat.cast_one, Real.one_rpow, one_div, one_mul] at hd
      have hdec : (∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
          = (∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
            + ((∑ i ∈ Finset.range k, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))
              - (∑ i ∈ Finset.range 1, χ ((i + 1 : ℕ) : ZMod N) * (((i + 1 : ℕ)) : ℂ) ^ (-s))) := by
        abel
      rw [hdec]
      refine (norm_add_le _ _).trans ?_
      rw [hE1, norm_sub_rev]
      linarith [hd]
    rw [LFunction_eq_dirichletSuccRangeLimit χ hχ hs0]
    refine hB.trans ?_
    have h2p : (2 : ℝ) ^ (-s.re) ≤ 1 :=
      Real.rpow_le_one_of_one_le_of_nonpos (by norm_num) (by linarith)
    have hA : (N : ℝ) * (2 : ℝ) ^ (-s.re) ≤ (N : ℝ) := by
      simpa using mul_le_mul_of_nonneg_left h2p hNr
    rw [div_eq_mul_inv] at *
    linarith [hA, hNr, hsn]
  refine ⟨2 + 6 * (N : ℝ), by positivity, fun σ t hσ0 hσ2 => ?_⟩
  have hpt : (((σ : ℂ) + (t : ℂ) * Complex.I)).re = σ := by simp
  have h1 := key ((σ : ℂ) + (t : ℂ) * Complex.I) (by rw [hpt]; exact hσ0)
  have h1n : ‖(σ : ℂ)‖ = |σ| := by simp
  have h3n : ‖(t : ℂ) * Complex.I‖ = |t| := by simp
  have hnorm : ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ ≤ σ + |t| := by
    have h := norm_add_le (σ : ℂ) ((t : ℂ) * Complex.I)
    rw [h1n, h3n, abs_of_nonneg (by linarith : (0 : ℝ) ≤ σ)] at h
    linarith
  have hNr : (0 : ℝ) ≤ (N : ℝ) := Nat.cast_nonneg N
  have hat : (0 : ℝ) ≤ |t| := abs_nonneg t
  have hσi : (0 : ℝ) < σ⁻¹ := inv_pos.mpr hσ0
  rw [hpt, div_eq_mul_inv] at h1
  rw [div_eq_mul_inv]
  have hsc : ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ * (N : ℝ) * σ⁻¹
      ≤ σ * (N : ℝ) * σ⁻¹ + |t| * (N : ℝ) * σ⁻¹ := by
    have h := mul_le_mul_of_nonneg_right hnorm (mul_nonneg hNr hσi.le)
    linarith [h]
  have hs1 : σ * (N : ℝ) * σ⁻¹ = (N : ℝ) := by
    rw [mul_comm σ (N : ℝ), mul_assoc, mul_inv_cancel₀ (ne_of_gt hσ0), mul_one]
  have hsc2 : ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ * (N : ℝ) * σ⁻¹
      ≤ (N : ℝ) + |t| * (N : ℝ) * σ⁻¹ := by linarith [hsc, hs1]
  have hfin : 1 + 3 * (N : ℝ) ≤ (2 + 6 * (N : ℝ)) * σ⁻¹ := by
    have h : 1 + 3 * (N : ℝ) ≤ (2 + 6 * (N : ℝ)) / σ := by
      rw [le_div_iff₀ hσ0]
      nlinarith [hNr, hσ2]
    rwa [div_eq_mul_inv] at h
  have hle : (N : ℝ) ≤ 2 + 6 * (N : ℝ) := by linarith [hNr]
  calc ‖LFunction χ ((σ : ℂ) + (t : ℂ) * Complex.I)‖
      ≤ 1 + 2 * (N : ℝ) + ‖(σ : ℂ) + (t : ℂ) * Complex.I‖ * (N : ℝ) * σ⁻¹ := h1
    _ ≤ 1 + 3 * (N : ℝ) + |t| * (N : ℝ) * σ⁻¹ := by linarith [hsc2]
    _ ≤ (2 + 6 * (N : ℝ)) * σ⁻¹ + |t| * (N : ℝ) * σ⁻¹ := by linarith [hfin]
    _ ≤ (2 + 6 * (N : ℝ)) * (1 + |t|) * σ⁻¹ := by
        have h := mul_le_mul_of_nonneg_right hle (mul_nonneg hat hσi.le)
        have hexp : (2 + 6 * (N : ℝ)) * (1 + |t|) * σ⁻¹
            = (2 + 6 * (N : ℝ)) * σ⁻¹ + (2 + 6 * (N : ℝ)) * |t| * σ⁻¹ := by ring
        rw [hexp]
        nlinarith [h, hσi, hat]

/-- **The gamma half of (V).**  On `Re s = 1` the logarithmic derivative of `Γ_ℝ` grows only like
`log|y|` — the pointwise input for the vertical-edge bound of the interface. -/
theorem norm_logDeriv_Gammaℝ_re_one_le (y : ℝ) :
    ‖logDeriv Complex.Gammaℝ ((1 : ℂ) + (y : ℂ) * Complex.I)‖
      ≤ 30 * (1 + Real.log (|y| / 2 + 2)) := by
  have hpos : 0 < (((1 : ℂ) + (y : ℂ) * Complex.I)).re := by simp
  rw [Complex.logDeriv_Gammaℝ (s := (1 : ℂ) + (y : ℂ) * Complex.I) hpos]
  have hdiv : ((1 : ℂ) + (y : ℂ) * Complex.I) / 2
      = (1 / 2 : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I := by
    push_cast
    ring_nf
  rw [hdiv]
  have hψ := digamma_norm_le_quarter (σ0 := (1 / 2 : ℝ)) (t := y / 2)
    (by norm_num) (by norm_num)
  have hlog : (0 : ℝ) ≤ Real.log (|y| / 2 + 2) :=
    Real.log_nonneg (by linarith [abs_nonneg y])
  have hψ' : ‖Complex.digamma ((1 / 2 : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖
      ≤ (Real.log 2 + 25) * (1 + Real.log (|y| / 2 + 2)) := by
    simpa [abs_div] using hψ
  have hpi : ‖Complex.log (Real.pi : ℂ)‖ ≤ 3 := by
    have h1 : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) :=
      (Complex.ofReal_log (le_of_lt Real.pi_pos)).symm
    rw [h1]
    have hnorm : ‖((Real.log Real.pi : ℝ) : ℂ)‖ = |Real.log Real.pi| := by simp
    rw [hnorm, abs_of_nonneg (Real.log_nonneg (by linarith [Real.pi_gt_three] : (1 : ℝ) ≤ Real.pi))]
    have h2 : Real.log Real.pi ≤ Real.pi - 1 := Real.log_le_sub_one_of_pos Real.pi_pos
    have h3 : Real.pi < 4 := Real.pi_lt_four
    linarith
  have hsum : ‖-(1 / 2) * Complex.log (Real.pi : ℂ)
      + (1 / 2) * Complex.digamma ((1 / 2 : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖
      ≤ ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)‖
        + ‖(1 / 2 : ℂ) * Complex.digamma ((1 / 2 : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖ := by
    simpa using norm_add_le (-(1 / 2) * Complex.log (Real.pi : ℂ))
      ((1 / 2) * Complex.digamma ((1 / 2 : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I))
  rw [norm_mul, norm_mul] at hsum
  have h12 : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
  rw [h12] at hsum
  have hlog2 : Real.log 2 ≤ 1 := by
    linarith [Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)]
  nlinarith [hsum, hψ', hpi, hlog, hlog2, abs_nonneg y]

/-- **The archimedean edge bound, both parities at once.**  For `Re s ∈ [1/2, 2]` the logarithmic
derivative of `Γ_ℝ` obeys the same logarithmic shape with the same constant `30`.  The range is chosen
so that one lemma covers both `Re s = 1` (the even `gammaFactor`) and `Re s = 2` (the odd
`gammaFactor`, which is `Γ_ℝ(s+1)`), via `digamma_norm_le_quarter` at `σ₀ = Re s / 2 ∈ [1/4, 1]`.
Journal 273's `norm_logDeriv_Gammaℝ_re_one_le` is the `σ = 1` case of this. -/
theorem norm_logDeriv_Gammaℝ_le {σ y : ℝ} (h0 : 1 / 2 ≤ σ) (h1 : σ ≤ 2) :
    ‖logDeriv Complex.Gammaℝ ((σ : ℂ) + (y : ℂ) * Complex.I)‖
      ≤ 30 * (1 + Real.log (|y| / 2 + 2)) := by
  have hpos : 0 < (((σ : ℂ) + (y : ℂ) * Complex.I)).re := by
    simp only [Complex.add_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re, Complex.I_im,
      Complex.ofReal_im, mul_zero, mul_one, sub_zero, add_zero]
    linarith
  rw [Complex.logDeriv_Gammaℝ (s := (σ : ℂ) + (y : ℂ) * Complex.I) hpos]
  have hdiv : ((σ : ℂ) + (y : ℂ) * Complex.I) / 2
      = ((σ / 2 : ℝ) : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I := by
    push_cast
    ring_nf
  rw [hdiv]
  have hψ := digamma_norm_le_quarter (σ0 := σ / 2) (t := y / 2) (by linarith) (by linarith)
  have hlog : (0 : ℝ) ≤ Real.log (|y| / 2 + 2) :=
    Real.log_nonneg (by linarith [abs_nonneg y])
  have hψ' : ‖Complex.digamma (((σ / 2 : ℝ) : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖
      ≤ (Real.log 2 + 25) * (1 + Real.log (|y| / 2 + 2)) := by
    simpa [abs_div] using hψ
  have hpi : ‖Complex.log (Real.pi : ℂ)‖ ≤ 3 := by
    have h1 : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) :=
      (Complex.ofReal_log (le_of_lt Real.pi_pos)).symm
    rw [h1]
    have hnorm : ‖((Real.log Real.pi : ℝ) : ℂ)‖ = |Real.log Real.pi| := by simp
    rw [hnorm, abs_of_nonneg (Real.log_nonneg (by linarith [Real.pi_gt_three] : (1 : ℝ) ≤ Real.pi))]
    have h2 : Real.log Real.pi ≤ Real.pi - 1 := Real.log_le_sub_one_of_pos Real.pi_pos
    have h3 : Real.pi < 4 := Real.pi_lt_four
    linarith
  have hsum : ‖-(1 / 2) * Complex.log (Real.pi : ℂ)
      + (1 / 2) * Complex.digamma (((σ / 2 : ℝ) : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖
      ≤ ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)‖
        + ‖(1 / 2 : ℂ) * Complex.digamma (((σ / 2 : ℝ) : ℂ)
          + (((y / 2 : ℝ)) : ℂ) * Complex.I)‖ := by
    simpa using norm_add_le (-(1 / 2) * Complex.log (Real.pi : ℂ))
      ((1 / 2) * Complex.digamma (((σ / 2 : ℝ) : ℂ) + (((y / 2 : ℝ)) : ℂ) * Complex.I))
  rw [norm_mul, norm_mul] at hsum
  have h12 : ‖(1 / 2 : ℂ)‖ = 1 / 2 := by norm_num
  rw [h12] at hsum
  have hlog2 : Real.log 2 ≤ 1 := by
    linarith [Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)]
  nlinarith [hsum, hψ', hpi, hlog, hlog2, abs_nonneg y]

/-- **`h_γ` discharged.**  The interface's archimedean edge bound, for either parity: on `Re s = 1`
the log-derivative of `gammaFactor χ` obeys the same logarithmic shape with constant `30`.  The parity
split sends the even case to `Γ_ℝ` at `Re = 1` and the odd case (`Γ_ℝ(s+1)`) to `Γ_ℝ` at `Re = 2`, both
covered by `norm_logDeriv_Gammaℝ_le`. -/
theorem norm_logDeriv_gammaFactor_re_one_le {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (y : ℝ) :
    ‖logDeriv (gammaFactor χ) (1 + (y : ℂ) * Complex.I)‖ ≤ 30 * (1 + Real.log (|y| + 2)) := by
  have hlog : Real.log (|y| / 2 + 2) ≤ Real.log (|y| + 2) :=
    Real.log_le_log (by linarith [abs_nonneg y]) (by linarith [abs_nonneg y])
  have hfac : (0 : ℝ) ≤ 1 + Real.log (|y| / 2 + 2) := by
    have := Real.log_nonneg (by linarith [abs_nonneg y] : (1 : ℝ) ≤ |y| / 2 + 2)
    linarith
  rcases χ.even_or_odd with h | h
  · rw [show gammaFactor χ = Complex.Gammaℝ from funext h.gammaFactor_def]
    have h1 : ‖logDeriv Complex.Gammaℝ (1 + (y : ℂ) * Complex.I)‖
        ≤ 30 * (1 + Real.log (|y| / 2 + 2)) := by
      simpa using norm_logDeriv_Gammaℝ_le (σ := 1) (y := y) (by norm_num) (by norm_num)
    nlinarith [h1, hlog]
  · rw [show gammaFactor χ = fun s => Complex.Gammaℝ (s + 1) from funext h.gammaFactor_def]
    have hcomp := logDeriv_comp (f := Complex.Gammaℝ) (g := fun s : ℂ => s + 1)
      (x := 1 + (y : ℂ) * Complex.I)
      (differentiableAt_Gammaℝ (s := (1 + (y : ℂ) * Complex.I) + 1) (by
        simp only [Complex.add_re, Complex.one_re, Complex.ofReal_re, Complex.mul_re, Complex.I_re,
          Complex.I_im, Complex.ofReal_im, mul_zero, mul_one, sub_zero, add_zero]
        norm_num))
      (by fun_prop)
    have hcomp' : logDeriv (fun s : ℂ => Complex.Gammaℝ (s + 1)) (1 + (y : ℂ) * Complex.I)
        = logDeriv Complex.Gammaℝ ((1 + (y : ℂ) * Complex.I) + 1)
          * deriv (fun s : ℂ => s + 1) (1 + (y : ℂ) * Complex.I) := hcomp
    rw [hcomp']
    have hderiv : deriv (fun s : ℂ => s + 1) (1 + (y : ℂ) * Complex.I) = 1 := by
      rw [deriv_add_const]
      simp
    rw [hderiv, mul_one]
    have h2 : (1 + (y : ℂ) * Complex.I) + 1 = (2 : ℂ) + (y : ℂ) * Complex.I := by ring
    rw [h2]
    have h3 : ‖logDeriv Complex.Gammaℝ (2 + (y : ℂ) * Complex.I)‖
        ≤ 30 * (1 + Real.log (|y| / 2 + 2)) := by
      simpa using norm_logDeriv_Gammaℝ_le (σ := 2) (y := y) (by norm_num) (by norm_num)
    nlinarith [h3, hlog]



/-- **(V) on the edge, down to ONE hypothesis.**  With the archimedean bound discharged by
`norm_logDeriv_gammaFactor_re_one_le`, the assembled edge bound depends only on a pointwise
`O(log|y|)` estimate for `L'/L` on the critical line — the single input journals 275/278 localised.
This is the exact frontier of part (A). -/
theorem norm_logDeriv_completedLFunction_re_one_le_of_L {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {CL : ℝ}
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2))) :
    ∀ y : ℝ, ‖logDeriv (completedLFunction χ) (1 + y * Complex.I)‖
      ≤ (30 + CL) * (1 + Real.log (|y| + 2)) :=
  norm_logDeriv_completedLFunction_re_one_le χ hχ (norm_logDeriv_gammaFactor_re_one_le χ) hL

/-- **O1.T10 step 2: the conductor term attached.**  The interface's own integrand obeys the edge shape
in terms of a single hypothesis — a pointwise `O(log|y|)` bound for `L'/L` on the critical line.  The
conductor contributes only the constant `(1/2) log N`, exactly as the numerical probe predicted
(journal 284). -/
theorem norm_completedLogDeriv_re_one_le_of_L {N : ℕ} [NeZero N] (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) {CL : ℝ}
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2))) :
    ∀ y : ℝ, ‖completedLogDeriv χ (1 + y * Complex.I)‖
      ≤ (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖) * (1 + Real.log (|y| + 2)) := by
  intro y
  have hs : ((1 : ℂ) + (y : ℂ) * Complex.I).re = 1 := by simp
  rw [completedLogDeriv_def, logDeriv_dirichletCompleted_eq_re_one χ hχ hs]
  have hlog : (0 : ℝ) ≤ Real.log (|y| + 2) :=
    Real.log_nonneg (by linarith [abs_nonneg y] : (1 : ℝ) ≤ |y| + 2)
  have haux : ‖logDeriv (completedLFunction χ) (1 + y * Complex.I)‖
      ≤ (30 + CL) * (1 + Real.log (|y| + 2)) :=
    norm_logDeriv_completedLFunction_re_one_le_of_L χ hχ hL y
  calc ‖(1 / 2) * Complex.log (N : ℂ) + logDeriv (completedLFunction χ) (1 + y * Complex.I)‖
      ≤ ‖(1 / 2) * Complex.log (N : ℂ)‖
        + ‖logDeriv (completedLFunction χ) (1 + y * Complex.I)‖ := norm_add_le _ _
    _ ≤ ‖(1 / 2) * Complex.log (N : ℂ)‖ + (30 + CL) * (1 + Real.log (|y| + 2)) := by
        linarith
    _ ≤ (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖) * (1 + Real.log (|y| + 2)) := by
        nlinarith [hlog, norm_nonneg ((1 / 2) * Complex.log (N : ℂ))]

theorem abs_le_of_mem_Icc {t0 t1 T y : ℝ} (hy : y ∈ Set.Icc t0 t1) (h0 : |t0| ≤ T)
    (h1 : |t1| ≤ T) : |y| ≤ T := by
  rw [abs_le]
  exact ⟨by linarith [neg_abs_le t0, hy.1, h0], by linarith [hy.2, le_abs_self t1, h1]⟩

theorem continuous_one_add_log_abs : Continuous fun y : ℝ => (1 : ℝ) + Real.log (|y| + 2) :=
  continuous_const.add ((continuous_abs.add continuous_const).log (fun y => by
    have h : (0 : ℝ) ≤ |y| := abs_nonneg y
    exact ne_of_gt (by linarith : (0 : ℝ) < |y| + 2)))

theorem intervalIntegral_log_edge_le (t0 t1 T : ℝ) (ht : t0 < t1) (h0 : |t0| ≤ T) (h1 : |t1| ≤ T)
    (hT : 0 ≤ T) :
    (∫ y in t0..t1, (1 + Real.log (|y| + 2))) ≤ (1 + Real.log (T + 2)) * |t1 - t0| := by
  rw [abs_of_pos (sub_pos.mpr ht)]
  have hmono : ∀ y ∈ Set.Icc t0 t1, (1 + Real.log (|y| + 2)) ≤ (1 + Real.log (T + 2)) := by
    intro y hy
    have hwin : |y| ≤ T := abs_le_of_mem_Icc hy h0 h1
    have hx : (0 : ℝ) < |y| + 2 := by linarith [abs_nonneg y]
    have hxy : |y| + 2 ≤ T + 2 := by linarith
    have hlog := Real.log_le_log hx hxy
    linarith
  calc (∫ y in t0..t1, (1 + Real.log (|y| + 2)))
      ≤ ∫ y in t0..t1, (1 + Real.log (T + 2)) :=
        intervalIntegral.integral_mono_on ht.le (continuous_one_add_log_abs.intervalIntegrable _ _)
          intervalIntegrable_const hmono
    _ = (1 + Real.log (T + 2)) * (t1 - t0) := by
        rw [intervalIntegral.integral_const]
        ring

/-- **O1.T10 step 3(a).**  On the vertical edge `Re s = 1` the log-derivative of `dirichletCompleted χ`
is continuous — with **no** zero-avoidance hypothesis and no exceptional-height caveat, because the
function is entire and does not vanish on that line.  This is the `IntervalIntegrable` input that
`intervalIntegral.integral_mono_on` needs for `(V)`.  Contrast the horizontal-edge lemma
(`intervalIntegrable_logDeriv_dirichletCompleted`, `DirichletAnalytic.lean:114`), which must assume
zero-freeness along its edge. -/
theorem continuousOn_logDeriv_dirichletCompleted_re_one {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) :
    ContinuousOn (fun s : ℂ => logDeriv (dirichletCompleted χ) s) {s : ℂ | s.re = 1} := by
  have hdiff : Differentiable ℂ (dirichletCompleted χ) := differentiable_dirichletCompleted χ hχ
  have hderiv_cont : Continuous (deriv (dirichletCompleted χ)) := by
    have hcd : ContDiff ℂ 1 (dirichletCompleted χ) :=
      (Complex.analyticOn_univ_iff_differentiable.mpr hdiff).contDiff
    exact hcd.continuous_deriv_one
  have hne : ∀ s ∈ {s : ℂ | s.re = 1}, dirichletCompleted χ s ≠ 0 := by
    intro s hs
    have hs0 : 0 < s.re := by rw [hs]; norm_num
    have hN : (N : ℂ) ≠ 0 := by exact_mod_cast NeZero.ne N
    have hpow : (N : ℂ) ^ (s / 2) ≠ 0 := by
      rw [Complex.cpow_def_of_ne_zero hN]
      exact Complex.exp_ne_zero _
    rw [dirichletCompleted, completedLFunction_eq_gammaFactor_mul_LFunction_of_re_pos χ hχ hs0]
    exact mul_ne_zero hpow (mul_ne_zero (gammaFactor_ne_zero_of_re_pos χ hs0)
      (LFunction_ne_zero_of_re_eq_one χ hs (Or.inl hχ)))
  simpa only [logDeriv] using
    hderiv_cont.continuousOn.div hdiff.continuous.continuousOn hne

/-- Arithmetic helper for `hV` (isolated per journal 293): weighted-product chaining. -/
theorem weighted_product_le {K I L A G : ℝ} (hstep : A ≤ K * I) (hI0 : 0 ≤ I)
    (hIle : I ≤ (1 + G) * L) (hL : 0 ≤ L) (hlogN : 0 ≤ Real.log N') (hG : 0 ≤ G) :
    A ≤ (|K| + 1) * (1 + Real.log N' + G) * (1 + L) := by
  have hK1 : K ≤ |K| + 1 := by linarith [le_abs_self K]
  have hG1 : 1 + G ≤ 1 + Real.log N' + G := by linarith
  have hL1 : L ≤ 1 + L := by linarith
  have h1 : K * I ≤ (|K| + 1) * ((1 + G) * L) :=
    calc K * I ≤ (|K| + 1) * I := mul_le_mul_of_nonneg_right hK1 hI0
      _ ≤ (|K| + 1) * ((1 + G) * L) := mul_le_mul_of_nonneg_left hIle (by positivity)
  have h2 : (|K| + 1) * ((1 + G) * L) ≤ (|K| + 1) * ((1 + Real.log N' + G) * (1 + L)) :=
    mul_le_mul_of_nonneg_left
      (mul_le_mul hG1 hL1 hL (by linarith)) (by positivity)
  linarith [hstep, h1, h2]

theorem intervalIntegrable_norm_completedLogDeriv_re_one {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) (t0 t1 : ℝ) :
    IntervalIntegrable (fun y : ℝ => ‖completedLogDeriv χ (1 + y * Complex.I)‖) volume t0 t1 := by
  have hcont : Continuous fun y : ℝ => logDeriv (dirichletCompleted χ) (1 + y * Complex.I) := by
    have hmap : Continuous fun y : ℝ => (1 : ℂ) + (y : ℂ) * Complex.I := by fun_prop
    have hsub : ∀ y : ℝ, ((1 : ℂ) + (y : ℂ) * Complex.I) ∈ {s : ℂ | s.re = 1} := by
      intro y; simp
    exact (continuousOn_logDeriv_dirichletCompleted_re_one χ hχ).comp_continuous hmap hsub
  have hfun : (fun y : ℝ => ‖completedLogDeriv χ (1 + y * Complex.I)‖)
      = fun y : ℝ => ‖logDeriv (dirichletCompleted χ) (1 + y * Complex.I)‖ := by
    funext y
    rw [completedLogDeriv_def]
  rw [hfun]
  exact hcont.norm.intervalIntegrable t0 t1

/-- **O1.T10 step 3 complete — `hV` itself.**  The vertical-edge integral of the interface's integrand
obeys exactly the shape §226's `criticalStripLogDerivBound_of_edge_bounds` consumes, from the single
hypothesis `hL`. -/
theorem exists_integral_completedLogDeriv_re_one_le_of_L {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {CL : ℝ}
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2))) :
    ∃ C : ℝ, 0 < C ∧ ∀ t0 t1 T : ℝ, t0 < t1 → |t0| ≤ T → |t1| ≤ T → 0 ≤ T →
      (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
        ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) := by
  refine ⟨|30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖| + 1, ?_, ?_⟩
  · linarith [abs_nonneg (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖)]
  · intro t0 t1 T ht h0 h1 hT
    have hcont2 : Continuous fun y : ℝ => (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖)
        * (1 + Real.log (|y| + 2)) := continuous_const.mul continuous_one_add_log_abs
    have hstep : (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
        ≤ (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖)
          * ∫ y in t0..t1, (1 + Real.log (|y| + 2)) := by
      calc (∫ y in t0..t1, ‖completedLogDeriv χ (1 + y * Complex.I)‖)
          ≤ ∫ y in t0..t1, (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖)
              * (1 + Real.log (|y| + 2)) :=
            intervalIntegral.integral_mono_on ht.le
              (intervalIntegrable_norm_completedLogDeriv_re_one χ hχ t0 t1)
              (hcont2.intervalIntegrable _ _)
              (fun y _ => norm_completedLogDeriv_re_one_le_of_L χ hχ hL y)
        _ = (30 + CL + ‖(1 / 2) * Complex.log (N : ℂ)‖)
              * ∫ y in t0..t1, (1 + Real.log (|y| + 2)) :=
            intervalIntegral.integral_const_mul _ _
    have hI0 : (0 : ℝ) ≤ ∫ y in t0..t1, (1 + Real.log (|y| + 2)) :=
      intervalIntegral.integral_nonneg ht.le fun y _ => by
        have h : (0 : ℝ) ≤ Real.log (|y| + 2) :=
          Real.log_nonneg (by linarith [abs_nonneg y] : (1 : ℝ) ≤ |y| + 2)
        linarith
    have hIle := intervalIntegral_log_edge_le t0 t1 T ht h0 h1 hT
    have hN1 : (1 : ℝ) ≤ N := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
    have hlogN : (0 : ℝ) ≤ Real.log (N : ℝ) := Real.log_nonneg hN1
    have hlogT : (0 : ℝ) ≤ Real.log (T + 2) := Real.log_nonneg (by linarith)
    rw [Real.log_mul (by positivity : (N : ℝ) ≠ 0) (by linarith : T + 2 ≠ 0)]
    rw [show (1 : ℝ) + (Real.log (N : ℝ) + Real.log (T + 2))
        = 1 + Real.log (N : ℝ) + Real.log (T + 2) from by ring]
    exact weighted_product_le hstep hI0 hIle (abs_nonneg _) hlogN hlogT


/-- **O1.T10: `hH` reduces to its integrable case.**  The exceptional heights where the horizontal
integrand is *not* interval-integrable contribute `0` (journal 272's
`horizontal_edge_eq_zero_of_not_integrable`), and `0` is below any positive multiple of
`1 + log(N(T+2))`.  So `hH` needs the bound only where the integrand IS integrable — which removes the
non-integrability obligation entirely, without proving anything about poles. -/
theorem exists_horizontal_bound_of_integrable_case {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) {C : ℝ} (hC : 0 < C)
    (h : ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
        (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ C * (1 + Real.log ((N : ℝ) * (T + 2)))) :
    ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ C * (1 + Real.log ((N : ℝ) * (T + 2))) := by
  intro t T ht hT
  by_cases hint : Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
    (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1))
  · exact h t T ht hT hint
  · have hzero := horizontal_edge_eq_zero_of_not_integrable (f := fun x : ℝ =>
        completedLogDeriv χ (x + t * Complex.I)) (a := (1 / 2 : ℝ)) (b := 1) (by norm_num) hint
    rw [hzero]
    have hN1 : (1 : ℝ) ≤ N := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr (NeZero.ne N)
    have hT2 : (1 : ℝ) ≤ T + 2 := by linarith
    have hlog : (0 : ℝ) ≤ Real.log ((N : ℝ) * (T + 2)) :=
      Real.log_nonneg (by nlinarith)
    nlinarith

/-- **O1.T10 complete — the interface as a compiled conditional theorem.**  With `hV` discharged
(journal 300) and `hH` reduced to its integrable case (journal 302), §226's reduction turns
`CriticalStripLogDerivBound χ` into a theorem from just TWO named hypotheses: the pointwise `L'/L`
bound `hL`, and the horizontal integrable-case bound `hH`. -/
theorem criticalStripLogDerivBound_of_L_and_hH {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {CL : ℝ}
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2)))
    {CH : ℝ} (hCH : 0 < CH)
    (hH : ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
        (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ CH * (1 + Real.log ((N : ℝ) * (T + 2)))) :
    CriticalStripLogDerivBound χ :=
  criticalStripLogDerivBound_of_edge_bounds χ
    ⟨CH, hCH, exists_horizontal_bound_of_integrable_case χ hCH hH⟩
    (exists_integral_completedLogDeriv_re_one_le_of_L χ hχ hL)
open scoped Interval

/-- **The Riemann–von Mangoldt count bound, conditional on the two named inputs.**  Applies §226's
consumer `dirichletCompleted_zeroCount_le_of_criticalStrip` to §303's conditional interface, so the
count bound holds modulo `hL` and `hH`. -/
theorem dirichletCompleted_zeroCount_le_of_L_and_hH {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N)
    (hχ : χ ≠ 1) (hprim : IsPrimitive χ) (hχinv : χ ⁻¹ = χ) (hsign : RootNumberSign χ)
    (hreal : CompletedLFunctionConj χ) {CL CH : ℝ} (hCH : 0 < CH)
    (hL : ∀ y : ℝ, ‖logDeriv (LFunction χ) (1 + y * Complex.I)‖
      ≤ CL * (1 + Real.log (|y| + 2)))
    (hH : ∀ t T : ℝ, |t| ≤ T → 0 ≤ T →
      Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
        (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) →
      (∫ x in (1 / 2 : ℝ)..1, ‖completedLogDeriv χ (x + t * Complex.I)‖)
        ≤ CH * (1 + Real.log ((N : ℝ) * (T + 2))))
    (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ) (ht : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt (dirichletCompleted χ) z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → dirichletCompleted χ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t1 * Complex.I)) volume 0 1)
    {T : ℝ} (hT0 : |t0| ≤ T) (hT1 : |t1| ≤ T) (hT2 : 0 ≤ T) :
    ∃ C0 : ℝ, 0 < C0 ∧
      (∑ z ∈ Z, (m z : ℝ))
        ≤ C0 * (1 + Real.log ((N : ℝ) * (T + 2))) * (1 + |t1 - t0|) / Real.pi := by
  obtain ⟨C0, hC0, hcs⟩ := criticalStripLogDerivBound_of_L_and_hH χ hχ hL hCH hH
  exact ⟨C0, hC0, dirichletCompleted_zeroCount_le_of_criticalStrip χ hχ hprim hχinv hsign hreal
    t0 t1 Z m ht hmem hm hno hint₀ hint₁ hC0 hcs hT0 hT1 hT2⟩

/-- **O1.T11's cheap half.**  In the zero-free case `hH`'s `Integrable` hypothesis is automatic, so
`hH`'s only real content is the quantitative uniformity in `t` (journals 308-310). -/
theorem integrable_norm_completedLogDeriv_horizontal {N : ℕ} [NeZero N]
    (χ : DirichletCharacter ℂ N) (hχ : χ ≠ 1) {t : ℝ}
    (hne : ∀ x ∈ Set.uIcc (0 : ℝ) 1, dirichletCompleted χ (x + t * Complex.I) ≠ 0) :
    Integrable (fun x : ℝ => ‖completedLogDeriv χ (x + t * Complex.I)‖)
      (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) := by
  have ht : t ∈ Set.uIcc t t := by simp [Set.uIcc]
  have h0 : IntervalIntegrable (fun x : ℝ => logDeriv (dirichletCompleted χ)
      (x + t * Complex.I)) volume 0 1 :=
    intervalIntegrable_logDeriv_dirichletCompleted χ hχ t ht hne
  have hsub : Set.uIcc (1 / 2 : ℝ) 1 ⊆ Set.uIcc (0 : ℝ) 1 := by
    intro x hx
    rw [Set.mem_uIcc] at hx ⊢
    rcases hx with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · exact Or.inl ⟨by linarith, h2⟩
    · exact Or.inl ⟨by linarith, by linarith⟩
  have h1 : Integrable (fun x : ℝ => logDeriv (dirichletCompleted χ) (x + t * Complex.I))
      (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) := (h0.mono_set hsub).1
  have h2 : Integrable (fun x : ℝ => ‖logDeriv (dirichletCompleted χ) (x + t * Complex.I)‖)
      (volume.restrict (Set.Ioc (1 / 2 : ℝ) 1)) := h1.norm
  refine h2.congr ?_
  filter_upwards with x
  rw [completedLogDeriv_def]
end

end RouteABC
