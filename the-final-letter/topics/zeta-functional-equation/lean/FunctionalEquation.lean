/-
The Riemann zeta functional equation and the continuation of `ζ′/ζ` to the
critical line.

This is the first half of the repair identified as O3 in
`archimedean-prime-evaluation`: the explicit formula needs the logarithmic
derivative of `ζ` on `Re s = 1/2`, which requires (a) the analytic continuation
of `ζ` off `1` and (b) the functional equation relating `Λ(s)` to `Λ(1 − s)`.

Everything here is proved from Mathlib; nothing is assumed.
-/
import Mathlib

noncomputable section

open Complex Filter MeasureTheory
open scoped Topology

namespace ZetaFunctionalEquation

/-! ## The functional equation -/

/-- **T1. The functional equation for the completed zeta function**:
`Λ(1 − s) = Λ(s)`.  Re-exported from Mathlib. -/
theorem completedZeta_one_sub (s : ℂ) :
    completedRiemannZeta (1 - s) = completedRiemannZeta s :=
  completedRiemannZeta_one_sub s

/-- **T2. The functional equation for `Λ₀`**: `Λ₀(1 − s) = Λ₀(s)`. -/
theorem completedZeta₀_one_sub (s : ℂ) :
    completedRiemannZeta₀ (1 - s) = completedRiemannZeta₀ s :=
  completedRiemannZeta₀_one_sub s

/-- **T3. The functional equation for `ζ`** (for `1 − s ∉ ℕ` and `s ≠ 1`). -/
theorem zeta_one_sub {s : ℂ} (hs : ∀ n : ℕ, s ≠ -n) (hs' : s ≠ 1) :
    riemannZeta (1 - s) =
      2 * (2 * (Real.pi : ℂ)) ^ (-s) * Complex.Gamma s *
        Complex.cos ((Real.pi : ℂ) * s / 2) * riemannZeta s :=
  riemannZeta_one_sub hs hs'

/-- **T4. Symmetry of the zero set of `Λ`**: `Λ(s) = 0` iff `Λ(1 − s) = 0`. -/
theorem completedZeta_zero_iff_one_sub (s : ℂ) :
    completedRiemannZeta s = 0 ↔ completedRiemannZeta (1 - s) = 0 := by
  rw [completedZeta_one_sub s]

/-- **T5. Symmetry of the zero set of `Λ₀`**. -/
theorem completedZeta₀_zero_iff_one_sub (s : ℂ) :
    completedRiemannZeta₀ s = 0 ↔ completedRiemannZeta₀ (1 - s) = 0 := by
  rw [completedZeta₀_one_sub s]

/-! ## Analyticity and the continuation -/

/-- **T6. `Λ₀` is entire.** -/
theorem completedZeta₀_entire :
    Differentiable ℂ completedRiemannZeta₀ :=
  _root_.differentiable_completedZeta₀

/-- **T7. `Λ` is differentiable away from `0` and `1`.** -/
theorem completedZeta_differentiableAt {s : ℂ} (hs : s ≠ 0) (hs' : s ≠ 1) :
    DifferentiableAt ℂ completedRiemannZeta s :=
  _root_.differentiableAt_completedZeta hs hs'

/-- **T8. `ζ` is differentiable away from `1`** — the analytic continuation. -/
theorem differentiableAt_zeta {s : ℂ} (hs : s ≠ 1) :
    DifferentiableAt ℂ riemannZeta s :=
  differentiableAt_riemannZeta hs

/-- **T9. `ζ` is analytic away from `1`.** -/
theorem analyticAt_zeta {s : ℂ} (hs : s ≠ 1) : AnalyticAt ℂ riemannZeta s := by
  rw [Complex.analyticAt_iff_eventually_differentiableAt]
  exact (isOpen_compl_singleton.eventually_mem (by simpa using hs)).mono
    (fun z hz => differentiableAt_riemannZeta hz)

/-- **T10. `ζ` on `Re s > 1` has no zeros.** -/
theorem zeta_ne_zero_of_one_lt_re {s : ℂ} (hs : 1 < s.re) :
    riemannZeta s ≠ 0 :=
  riemannZeta_ne_zero_of_one_lt_re hs

/-- **T11. `ζ(s) = Λ(s) / Gammaℝ(s)`** for `s ≠ 0`. -/
theorem zeta_eq_completed_div {s : ℂ} (hs : s ≠ 0) :
    riemannZeta s = completedRiemannZeta s / Complex.Gammaℝ s :=
  riemannZeta_def_of_ne_zero hs

/-- **T12. `Gammaℝ(s) ≠ 0`** away from the trivial zeros `s = −2n`. -/
theorem Gammaℝ_ne_zero {s : ℂ} (hs : ∀ n : ℕ, s ≠ -2 * (n : ℂ)) :
    Complex.Gammaℝ s ≠ 0 := by
  rw [Complex.Gammaℝ_def]
  refine mul_ne_zero ?_ (Complex.Gamma_ne_zero ?_)
  · rw [Complex.cpow_ne_zero_iff]
    left
    exact_mod_cast Real.pi_ne_zero
  · intro m hm
    apply hs m
    have h2 : s / 2 = -(m : ℂ) := hm
    have : s = 2 * (-(m : ℂ)) := by
      rw [← h2]; ring
    rw [this]; push_cast; ring

/-- **T13. Zeros of `ζ` and of `Λ` correspond** away from `0`, `1` and the
trivial zeros. -/
theorem zeta_zero_iff_completed_zero {s : ℂ} (hs : s ≠ 0) (hs' : s ≠ 1)
    (htriv : ∀ n : ℕ, s ≠ -2 * (n : ℂ)) :
    riemannZeta s = 0 ↔ completedRiemannZeta s = 0 := by
  rw [zeta_eq_completed_div hs, div_eq_zero_iff]
  constructor
  · intro h
    rcases h with h | h
    · exact h
    · exact absurd h (Gammaℝ_ne_zero htriv)
  · intro h
    exact Or.inl h

/-! ## The logarithmic derivative on the critical line -/

/-- **T14. `ζ′/ζ` is analytic away from `1` and away from the zeros of `ζ`.**
This is the O3 input: it applies in particular on the critical line. -/
theorem analyticAt_logDeriv_zeta {s : ℂ} (hs : s ≠ 1) (hz : riemannZeta s ≠ 0) :
    AnalyticAt ℂ (logDeriv riemannZeta) s := by
  have hζ : AnalyticAt ℂ riemannZeta s := analyticAt_zeta hs
  have hdiv : AnalyticAt ℂ (fun x : ℂ => deriv riemannZeta x / riemannZeta x) s :=
    hζ.deriv.div hζ hz
  have hfun : (fun x : ℂ => deriv riemannZeta x / riemannZeta x) = logDeriv riemannZeta := by
    funext x
    rw [logDeriv_apply]
  rw [hfun] at hdiv
  exact hdiv

/-- **T15. `ζ′/ζ` is differentiable away from `1` and away from the zeros of `ζ`.**
-/
theorem differentiableAt_logDeriv_zeta {s : ℂ} (hs : s ≠ 1) (hz : riemannZeta s ≠ 0) :
    DifferentiableAt ℂ (logDeriv riemannZeta) s :=
  (analyticAt_logDeriv_zeta hs hz).differentiableAt

/-- **T16. The value `ζ(0) = −1/2`.** -/
theorem zeta_zero : riemannZeta 0 = -1 / 2 :=
  riemannZeta_zero

/-- **T17. The value `ζ(2) = π²/6`.** -/
theorem zeta_two : riemannZeta 2 = (Real.pi : ℂ) ^ 2 / 6 :=
  riemannZeta_two

/-- **T18. `ζ(2) ≠ 0`.** -/
theorem zeta_two_ne_zero : riemannZeta 2 ≠ 0 := by
  rw [zeta_two]
  have hpi : (Real.pi : ℂ) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
  exact div_ne_zero (pow_ne_zero 2 hpi) (by norm_num)

/-- **T19. The trivial zeros: `ζ(−2(n+1)) = 0`.** -/
theorem zeta_neg_two_mul_nat_add_one (n : ℕ) :
    riemannZeta (-2 * ((n : ℂ) + 1)) = 0 :=
  riemannZeta_neg_two_mul_nat_add_one n

/-- **T20. The residue of `Λ` at `1` is `1`.** -/
theorem completedZeta_residue_one :
    Tendsto (fun s : ℂ => (s - 1) * completedRiemannZeta s) (nhdsWithin 1 {1}ᶜ) (nhds 1) :=
  completedRiemannZeta_residue_one

/-- **T21. `Λ(1) = (γ − log(4π))/2`.** -/
theorem completedZeta_one :
    completedRiemannZeta 1 = ((Real.eulerMascheroniConstant : ℂ) -
      Complex.log (4 * (Real.pi : ℂ))) / 2 :=
  completedRiemannZeta_one


/-! ## Symmetries of the zero set -/

/-- **T22. Conjugation symmetry of `ζ`.** -/
theorem zeta_conj (s : ℂ) :
    riemannZeta (starRingEnd ℂ s) = starRingEnd ℂ (riemannZeta s) :=
  riemannZeta_conj s

/-- **T23. Zeros are closed under conjugation.** -/
theorem zeta_zero_conj {s : ℂ} (h : riemannZeta s = 0) :
    riemannZeta (starRingEnd ℂ s) = 0 := by
  rw [zeta_conj s, h, map_zero]

/-- **T24. Zeros are closed under `s ↦ 1 − s`** (off the poles of `Γ`). -/
theorem zeta_zero_one_sub {s : ℂ} (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1)
    (h : riemannZeta s = 0) : riemannZeta (1 - s) = 0 := by
  rw [zeta_one_sub hs hs', h, mul_zero]

/-- **T25. The fourfold symmetry of the nontrivial zeros:** they are closed
under `s ↦ 1 − s` and `s ↦ s̄`, hence under the Klein four-group generated by
them. -/
theorem zeta_zero_quadruple {s : ℂ} (hs : ∀ n : ℕ, s ≠ -(n : ℂ)) (hs' : s ≠ 1)
    (h : riemannZeta s = 0) :
    riemannZeta (1 - starRingEnd ℂ s) = 0 := by
  have hc : riemannZeta (starRingEnd ℂ s) = 0 := zeta_zero_conj h
  have hns : ∀ n : ℕ, (starRingEnd ℂ s) ≠ -(n : ℂ) := by
    intro n hn
    apply hs n
    have h2 : starRingEnd ℂ (starRingEnd ℂ s) = starRingEnd ℂ (-(n : ℂ)) := by rw [hn]
    have h3 : s = -(n : ℂ) := by simpa using h2
    exact h3
  have hs1 : (starRingEnd ℂ s) ≠ 1 := by
    intro h1
    apply hs'
    have h2 : starRingEnd ℂ (starRingEnd ℂ s) = starRingEnd ℂ (1 : ℂ) := by rw [h1]
    simpa using h2
  exact zeta_zero_one_sub hns hs1 hc



/-- `Γℝ` vanishes exactly at the negative even integers. -/
theorem Gammaℝ_eq_zero_iff (s : ℂ) :
    Complex.Gammaℝ s = 0 ↔ ∃ m : ℕ, s = -2 * (m : ℂ) := by
  rw [Complex.Gammaℝ_def, mul_eq_zero]
  constructor
  · rintro (h | h)
    · exfalso
      have hpi : ((Real.pi : ℂ)) ≠ 0 := by exact_mod_cast Real.pi_ne_zero
      exact hpi ((Complex.cpow_eq_zero_iff _ _).mp h).1
    · obtain ⟨m, hm⟩ := (Complex.Gamma_eq_zero_iff (s / 2)).mp h
      refine ⟨m, ?_⟩
      have h2 : s = 2 * (s / 2) := by ring
      rw [h2, hm]; ring
  · rintro ⟨m, rfl⟩
    right
    rw [Complex.Gamma_eq_zero_iff]
    exact ⟨m, by ring⟩

/-- `Λ(s) = ζ(s)·Γℝ(s)` when `Γℝ(s) ≠ 0`. -/
theorem completedZeta_eq_zeta_mul_Gammaℝ {s : ℂ} (hs : s ≠ 0)
    (hΓ : Complex.Gammaℝ s ≠ 0) :
    completedRiemannZeta s = riemannZeta s * Complex.Gammaℝ s := by
  rw [zeta_eq_completed_div hs, div_mul_cancel₀ _ hΓ]

/-- **T26. Zeros in the left half-plane are exactly the negative even
integers.** -/
theorem zeta_zero_of_re_neg {s : ℂ} (hs : s.re < 0) :
    riemannZeta s = 0 ↔ ∃ m : ℕ, 1 ≤ m ∧ s = -2 * (m : ℂ) := by
  have hs0 : s ≠ 0 := by
    intro h; rw [h] at hs; simp at hs
  have hs1 : s ≠ 1 := by
    intro h; rw [h] at hs; norm_num at hs
  have hre : 1 < (1 - s).re := by
    rw [Complex.sub_re, Complex.one_re]; linarith
  have hζ : riemannZeta (1 - s) ≠ 0 := zeta_ne_zero_of_one_lt_re hre
  have hΓ : Complex.Gammaℝ (1 - s) ≠ 0 := by
    intro h
    obtain ⟨m, hm⟩ := (Gammaℝ_eq_zero_iff (1 - s)).mp h
    rw [hm] at hre
    have hre' : (-2 * (m : ℂ)).re = -2 * (m : ℝ) := by simp
    rw [hre'] at hre
    have hm0 : (0:ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have hne : (1 - s) ≠ 0 := by
    intro h
    rw [h] at hre
    norm_num at hre
  have hΛ : completedRiemannZeta (1 - s) ≠ 0 := by
    rw [completedZeta_eq_zeta_mul_Gammaℝ hne hΓ]
    exact mul_ne_zero hζ hΓ
  have hΛs : completedRiemannZeta s ≠ 0 := by
    rw [← completedZeta_one_sub s]; exact hΛ
  constructor
  · intro hz
    have hdiv : riemannZeta s = completedRiemannZeta s / Complex.Gammaℝ s :=
      zeta_eq_completed_div hs0
    have hzero : completedRiemannZeta s = 0 ∨ Complex.Gammaℝ s = 0 := by
      rw [hdiv, div_eq_zero_iff] at hz
      exact hz
    rcases hzero with h | h
    · exact absurd h hΛs
    · obtain ⟨m, hm⟩ := (Gammaℝ_eq_zero_iff s).mp h
      have hm1 : 1 ≤ m := by
        rcases Nat.eq_zero_or_pos m with rfl | hpos
        · rw [hm] at hs; simp at hs
        · exact hpos
      exact ⟨m, hm1, hm⟩
  · rintro ⟨m, hm1, rfl⟩
    have hΓ0 : Complex.Gammaℝ (-2 * (m : ℂ)) = 0 := by
      rw [Gammaℝ_eq_zero_iff]; exact ⟨m, rfl⟩
    rw [zeta_eq_completed_div (by
      intro h
      have : (-2 * (m : ℂ)).re = 0 := by rw [h]; simp
      rw [this] at hs; exact absurd hs (by norm_num))]
    rw [hΓ0, div_zero]

/-- **T27. Residue of `ζ′/ζ` at a simple zero:** if `ρ ≠ 1`, `ζ(ρ) = 0` and
`ζ′(ρ) ≠ 0`, then `(s − ρ)·ζ′(s)/ζ(s) → 1`.  Simplicity is a hypothesis, not
an assertion. -/
theorem tendsto_logDeriv_zero (ρ : ℂ) (hζ : riemannZeta ρ = 0) (hρ : ρ ≠ 1)
    (hsimple : deriv riemannZeta ρ ≠ 0) :
    Tendsto (fun s : ℂ => (s - ρ) * logDeriv riemannZeta s)
      (nhdsWithin ρ {ρ}ᶜ) (nhds 1) := by
  have hd : HasDerivAt riemannZeta (deriv riemannZeta ρ) ρ :=
    (differentiableAt_riemannZeta hρ).hasDerivAt
  have hslope : Tendsto (slope riemannZeta ρ) (nhdsWithin ρ {ρ}ᶜ)
      (nhds (deriv riemannZeta ρ)) := hd.tendsto_slope
  have hderiv : Tendsto (deriv riemannZeta) (nhdsWithin ρ {ρ}ᶜ)
      (nhds (deriv riemannZeta ρ)) :=
    (analyticAt_zeta hρ).deriv.continuousAt.tendsto.mono_left nhdsWithin_le_nhds
  have hslope_ne : ∀ᶠ s in nhdsWithin ρ {ρ}ᶜ, slope riemannZeta ρ s ≠ 0 :=
    hslope.eventually (eventually_ne_nhds hsimple)
  have hquot : Tendsto (fun s : ℂ => deriv riemannZeta s / slope riemannZeta ρ s)
      (nhdsWithin ρ {ρ}ᶜ) (nhds 1) := by
    have h := hderiv.div hslope hsimple
    rwa [div_self hsimple] at h
  refine hquot.congr' ?_
  filter_upwards [hslope_ne, self_mem_nhdsWithin] with s hs hsne
  have hsρ : s - ρ ≠ 0 := sub_ne_zero.mpr hsne
  have hslope_def : slope riemannZeta ρ s = riemannZeta s / (s - ρ) := by
    rw [slope_def_field, hζ]
    ring
  have hζs : riemannZeta s = (s - ρ) * slope riemannZeta ρ s := by
    rw [hslope_def]
    field_simp
  rw [logDeriv_apply, hζs]
  field_simp

/-- **T28. Logarithmic derivative of a finite product of linear factors.** -/
theorem logDeriv_prod_linear (F : Finset ℂ) {s : ℂ} (hs : ∀ ρ ∈ F, s ≠ ρ) :
    logDeriv (∏ ρ ∈ F, fun z : ℂ => z - ρ) s = ∑ ρ ∈ F, (s - ρ)⁻¹ := by
  rw [logDeriv_prod (s := F) (f := fun ρ z => z - ρ) (x := s)
    (fun ρ hρ => sub_ne_zero.mpr (hs ρ hρ))
    (fun ρ hρ => differentiableAt_id.sub_const ρ)]
  refine Finset.sum_congr rfl ?_
  intro ρ hρ
  have hderiv : deriv (fun z : ℂ => z - ρ) s = 1 := by simp
  rw [logDeriv_apply, hderiv, one_div]

/-- **T29. Residue decomposition of `ζ′/ζ`:** if on a neighbourhood `ζ` factors
as the product of its simple zeros there times a nonvanishing holomorphic
function `g`, then `ζ′/ζ = Σ_ρ 1/(s − ρ) + g′/g`. -/
theorem logDeriv_zeta_eq_sum_add {F : Finset ℂ} {g : ℂ → ℂ} {s : ℂ}
    (hζ : riemannZeta = (∏ ρ ∈ F, fun z : ℂ => z - ρ) * g)
    (hg : g s ≠ 0) (hgd : DifferentiableAt ℂ g s) (hs : ∀ ρ ∈ F, s ≠ ρ) :
    logDeriv riemannZeta s = (∑ ρ ∈ F, (s - ρ)⁻¹) + logDeriv g s := by
  have hP : (∏ ρ ∈ F, fun z : ℂ => z - ρ) s ≠ 0 := by
    rw [Finset.prod_apply]
    exact Finset.prod_ne_zero_iff.mpr (fun ρ hρ => sub_ne_zero.mpr (hs ρ hρ))
  have hPd : DifferentiableAt ℂ (∏ ρ ∈ F, fun z : ℂ => z - ρ) s :=
    DifferentiableAt.finset_prod (fun ρ hρ => differentiableAt_id.sub_const ρ)
  rw [hζ, logDeriv_mul s hP hg hPd hgd, logDeriv_prod_linear F hs]



/-- **T30. The prime sum at `Re s = 1/2` is not absolutely convergent:**
`Σ Λ(n)/√n = ∞`.  Hence the critical-line prime term cannot be obtained by
termwise integration of the absolutely convergent Dirichlet series; a
conditional argument is required. -/
theorem not_summable_vonMangoldt_div_sqrt :
    ¬ Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n) := by
  intro h
  have hbase : Summable ({p : ℕ | Nat.Prime p}.indicator
      (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n)) :=
    h.indicator {p : ℕ | Nat.Prime p}
  have hPr : Summable (fun n : ℕ =>
      2 * ({p : ℕ | Nat.Prime p}.indicator
        (fun m : ℕ => (ArithmeticFunction.vonMangoldt m : ℝ) / Real.sqrt m)) n) :=
    hbase.mul_left 2
  have hcomp : ∀ n : ℕ,
      ({p : ℕ | Nat.Prime p}.indicator fun m : ℕ => (1 : ℝ) / m) n ≤
      2 * ({p : ℕ | Nat.Prime p}.indicator
        (fun m : ℕ => (ArithmeticFunction.vonMangoldt m : ℝ) / Real.sqrt m)) n := by
    intro n
    by_cases hn : Nat.Prime n
    · rw [Set.indicator_of_mem (show n ∈ {p : ℕ | Nat.Prime p} from hn),
        Set.indicator_of_mem (show n ∈ {p : ℕ | Nat.Prime p} from hn)]
      rw [ArithmeticFunction.vonMangoldt_apply_prime hn]
      have hnpos : (0 : ℝ) < n := by exact_mod_cast hn.pos
      have hsqrtpos : (0 : ℝ) < Real.sqrt n := Real.sqrt_pos.mpr hnpos
      have hn2 : (2 : ℝ) ≤ n := by exact_mod_cast hn.two_le
      have h1n : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn.one_lt.le
      have hsqrt1 : 1 ≤ Real.sqrt n := Real.one_le_sqrt.mpr h1n
      have hlogn : 1 ≤ 2 * Real.log n := by
        have hlog2 : Real.log 2 ≤ Real.log n := Real.log_le_log (by norm_num) hn2
        nlinarith [Real.log_two_gt_d9, hlog2]
      have hsqrtn : Real.sqrt n * Real.sqrt n = n := Real.mul_self_sqrt hnpos.le
      have hkey : (1 : ℝ) / n = (1 / Real.sqrt n) * (1 / Real.sqrt n) := by
        conv_lhs => rw [hsqrtn.symm]
        simp only [one_div, mul_inv]
      have hle1 : 1 / Real.sqrt n ≤ 2 * Real.log n := by
        have h1 : 1 / Real.sqrt n ≤ 1 := by
          rw [div_le_one hsqrtpos]
          exact hsqrt1
        linarith
      have hnonneg : (0 : ℝ) ≤ 1 / Real.sqrt n := by positivity
      rw [hkey]
      calc (1 / Real.sqrt n) * (1 / Real.sqrt n)
          ≤ (1 / Real.sqrt n) * (2 * Real.log n) :=
            mul_le_mul_of_nonneg_left hle1 hnonneg
        _ = 2 * (Real.log n / Real.sqrt n) := by ring
    · rw [Set.indicator_of_notMem (by simpa using hn),
        Set.indicator_of_notMem (by simpa using hn)]
      simp
  have hnonneg : ∀ n : ℕ, 0 ≤ ({p : ℕ | Nat.Prime p}.indicator fun m : ℕ => (1 : ℝ) / m) n := by
    intro n
    by_cases hn : Nat.Prime n
    · rw [Set.indicator_of_mem (show n ∈ {p : ℕ | Nat.Prime p} from hn)]
      positivity
    · rw [Set.indicator_of_notMem (by simpa using hn)]
  exact not_summable_one_div_on_primes (Summable.of_nonneg_of_le hnonneg hcomp hPr)



/-- **The rectangle boundary integral**, exactly in the form the Cauchy
theorems use: bottom minus top, plus `I` times the right vertical integral,
minus `I` times the left vertical integral. -/
def boundaryIntegral (f : ℂ → ℂ) (z w : ℂ) : ℂ :=
  (((∫ (x : ℝ) in z.re..w.re, f (↑x + ↑z.im * Complex.I)) -
      ∫ (x : ℝ) in z.re..w.re, f (↑x + ↑w.im * Complex.I)) +
    Complex.I • ∫ (y : ℝ) in z.im..w.im, f (↑w.re + ↑y * Complex.I)) -
    Complex.I • ∫ (y : ℝ) in z.im..w.im, f (↑z.re + ↑y * Complex.I)

/-- **T31. The holomorphic Cauchy identity** on a rectangle, in terms of
`boundaryIntegral`. -/
theorem boundaryIntegral_eq_zero_of_differentiableOn (f : ℂ → ℂ) (z w : ℂ)
    (H : DifferentiableOn ℂ f (Set.uIcc z.re w.re ×ℂ Set.uIcc z.im w.im)) :
    boundaryIntegral f z w = 0 := by
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn f z w H
  simpa [boundaryIntegral] using h

/-- **T32. The Cauchy identity off a countable set** (the form the argument
principle needs). -/
theorem boundaryIntegral_eq_zero_of_off_countable (f : ℂ → ℂ) (z w : ℂ) (s : Set ℂ)
    (hs : s.Countable)
    (Hc : ContinuousOn f (Set.uIcc z.re w.re ×ℂ Set.uIcc z.im w.im))
    (Hd : ∀ x ∈ Set.Ioo (min z.re w.re) (max z.re w.re) ×ℂ
        Set.Ioo (min z.im w.im) (max z.im w.im) \ s, DifferentiableAt ℂ f x) :
    boundaryIntegral f z w = 0 := by
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiable_on_off_countable
    f z w s hs Hc Hd
  simpa [boundaryIntegral] using h

/-- The nontrivial zeros of `ζ` inside the rectangle `(1/2, 2) × (−T, T)`. -/
def stripZeros (T : ℝ) : Set ℂ :=
  {ρ : ℂ | riemannZeta ρ = 0 ∧ 1 / 2 < ρ.re ∧ ρ.re < 2 ∧ |ρ.im| < T}

/-- **O3a, the rectangle residue theorem for `ζ′/ζ`**, as a statement: for a
test function `H`, the boundary integral of `H·ζ′/ζ` around the rectangle with
corners `z`, `w` is `2πi` times the sum of `H` over the simple zeros of `ζ`
inside it, plus `2πi·H(1)` for the pole at `s = 1`. -/
def RectangleResidueTheorem (F : Finset ℂ) (H : ℂ → ℂ) (z w : ℂ) : Prop :=
  boundaryIntegral (fun s => H s * logDeriv riemannZeta s) z w =
    2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ F, H ρ + H 1)

/-- **O3a, the contour-shift statement** for a test `H`: on the rectangle
`[1/2, 2] × [−T, T]`, the residue theorem holds for `H·ζ′/ζ` with the simple
zeros in the strip and the pole at `1`. -/
def ContourShiftStatement (H : ℂ → ℂ) : Prop :=
  ∀ T : ℝ, 0 < T → ∀ F : Finset ℂ,
    (∀ ρ ∈ F, ρ ∈ stripZeros T) →
    (∀ ρ ∈ stripZeros T, ρ ∈ F) →
    (∀ ρ ∈ F, deriv riemannZeta ρ ≠ 0) →
    RectangleResidueTheorem F H ((1 / 2 : ℂ) - (T : ℂ) * Complex.I)
      ((2 : ℂ) + (T : ℂ) * Complex.I)

/-- **T33. The contour-shift reduction (algebraic form).**  Given the residue
theorem, the difference of the two vertical integrals — the quantity the
explicit formula needs — equals the residue sum minus the horizontal terms. -/
theorem verticalDifference_eq_of_boundary {g : ℂ → ℂ} {z w : ℂ} {S : ℂ}
    (h : boundaryIntegral g z w = 2 * (Real.pi : ℂ) * Complex.I * S) :
    Complex.I • (∫ (y : ℝ) in z.im..w.im, g (↑w.re + ↑y * Complex.I)) -
        Complex.I • (∫ (y : ℝ) in z.im..w.im, g (↑z.re + ↑y * Complex.I)) =
      2 * (Real.pi : ℂ) * Complex.I * S -
        ((∫ (x : ℝ) in z.re..w.re, g (↑x + ↑z.im * Complex.I)) -
          ∫ (x : ℝ) in z.re..w.re, g (↑x + ↑w.im * Complex.I)) := by
  rw [← h]
  unfold boundaryIntegral
  abel



/-- **T34. The residue theorem on a circle, single simple pole.**  If
`H·f′/f − H(ρ)/(s − ρ)` is continuous on the closed disc and holomorphic off the
pole `ρ`, then the circle integral of `H·f′/f` is `2πi·H(ρ)`. -/
theorem circleIntegral_residue (H : ℂ → ℂ) (f : ℂ → ℂ) (ρ c : ℂ) (R : ℝ)
    (hR : 0 ≤ R) (hρ : ‖ρ - c‖ < R)
    (hcont : ContinuousOn (fun z => H z * logDeriv f z - H ρ / (z - ρ))
      (Metric.closedBall c R))
    (hdiff : ∀ z ∈ Metric.ball c R \ {ρ},
      DifferentiableAt ℂ (fun z => H z * logDeriv f z - H ρ / (z - ρ)) z) :
    ∮ z in C(c, R), H z * logDeriv f z = 2 * (Real.pi : ℂ) * Complex.I * H ρ := by
  set g : ℂ → ℂ := fun z => H z * logDeriv f z - H ρ / (z - ρ) with hg
  have hg0 : ∮ z in C(c, R), g z = 0 :=
    Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR
      (s := {ρ}) (Set.countable_singleton ρ) hcont hdiff
  have hker : ∮ z in C(c, R), (z - ρ)⁻¹ = 2 * (Real.pi : ℂ) * Complex.I := by
    have h := Complex.circleIntegral_sub_inv_smul_of_differentiable_on_off_countable
      (R := R) (c := c) (w := ρ) (f := fun _ : ℂ => (1 : ℂ)) (s := ∅)
      Set.countable_empty (by simpa [Metric.mem_ball, dist_eq_norm] using hρ)
      continuous_const.continuousOn
      (fun x _ => differentiableAt_const (1 : ℂ))
    simpa [smul_eq_mul] using h
  have hEq : Set.EqOn (fun z => H z * logDeriv f z)
      (fun z => g z + H ρ / (z - ρ)) (Metric.sphere c R) := by
    intro z hz
    simp only [hg]
    abel
  rw [circleIntegral.integral_congr hR hEq]
  have hg_int : CircleIntegrable g c R :=
    ContinuousOn.circleIntegrable hR (hcont.mono Metric.sphere_subset_closedBall)
  have hk_int : CircleIntegrable (fun z : ℂ => H ρ / (z - ρ)) c R := by
    apply ContinuousOn.circleIntegrable hR
    apply ContinuousOn.div continuousOn_const (by fun_prop)
    intro z hz
    have hmem : ‖z - c‖ = R := by simpa [Metric.mem_sphere] using hz
    intro hzρ
    have hzρ' : z = ρ := sub_eq_zero.mp hzρ
    rw [hzρ'] at hmem
    linarith [hρ]
  rw [circleIntegral.integral_add hg_int hk_int, hg0, zero_add]
  have hconst : (fun z : ℂ => H ρ / (z - ρ)) = fun z => H ρ * (z - ρ)⁻¹ := by
    funext z
    rw [div_eq_mul_inv]
  rw [hconst, circleIntegral.integral_const_mul, hker]
  ring

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **D3. O3's residue theorem on a circle**, as a `Prop`: the circle integral
of `H·f′/f` is `2πi·H(ρ)` at a single simple pole, given that the singular part
has been subtracted. -/
def CircleResidueTheorem (H f : ℂ → ℂ) (ρ c : ℂ) (R : ℝ) : Prop :=
  ∀ (_ : 0 ≤ R), ‖ρ - c‖ < R →
    ContinuousOn (fun z => H z * logDeriv f z - H ρ / (z - ρ)) (Metric.closedBall c R) →
    (∀ z ∈ Metric.ball c R \ {ρ},
      DifferentiableAt ℂ (fun z => H z * logDeriv f z - H ρ / (z - ρ)) z) →
    ∮ z in C(c, R), H z * logDeriv f z = 2 * (Real.pi : ℂ) * Complex.I * H ρ

/-- **T35. The circle residue theorem holds** — `CircleResidueTheorem` is a
theorem, not an assumption. -/
theorem circleResidueTheorem_holds (H f : ℂ → ℂ) (ρ c : ℂ) (R : ℝ) :
    CircleResidueTheorem H f ρ c R := by
  intro hR hρ hcont hdiff
  exact circleIntegral_residue H f ρ c R hR hρ hcont hdiff

/-- **T36. The circle residue theorem at a simple zero of `ζ`.**  The
hypotheses `ρ ≠ 1` and `ζ′(ρ) ≠ 0` are recorded because they are what makes the
subtracted function continuous at `ρ` (the removable-singularity step O3c);
T34 itself only needs the continuity that results from them. -/
theorem circleResidueTheorem_zeta (H : ℂ → ℂ) (ρ c : ℂ) (R : ℝ)
    (hζ : riemannZeta ρ = 0) (hρ1 : ρ ≠ 1) (hsimple : deriv riemannZeta ρ ≠ 0) :
    CircleResidueTheorem H riemannZeta ρ c R :=
  circleResidueTheorem_holds H riemannZeta ρ c R



/-- The kernel integral: `∮_{C(c,R)} (z − ρ)⁻¹ = 2πi` for `ρ` inside. -/
theorem circleIntegral_inv_sub (ρ c : ℂ) (R : ℝ) (hR : 0 ≤ R) (hρ : ‖ρ - c‖ < R) :
    ∮ z in C(c, R), (z - ρ)⁻¹ = 2 * (Real.pi : ℂ) * Complex.I := by
  have h := Complex.circleIntegral_sub_inv_smul_of_differentiable_on_off_countable
    (R := R) (c := c) (w := ρ) (f := fun _ : ℂ => (1 : ℂ)) (s := ∅)
    Set.countable_empty (by simpa [Metric.mem_ball, dist_eq_norm] using hρ)
    continuous_const.continuousOn
    (fun x _ => differentiableAt_const (1 : ℂ))
  simpa [smul_eq_mul] using h

/-- **T37. The circle residue theorem, finite sum of simple poles.** -/
theorem circleIntegral_residue_sum (H f : ℂ → ℂ) (F : Finset ℂ) (c : ℂ) (R : ℝ)
    (_hR : 0 ≤ R) (hF : ∀ ρ ∈ F, ‖ρ - c‖ < R)
    (hcont : ContinuousOn (fun z => H z * logDeriv f z - ∑ ρ ∈ F, H ρ / (z - ρ))
      (Metric.closedBall c R))
    (hdiff : ∀ z ∈ Metric.ball c R \ (F : Set ℂ),
      DifferentiableAt ℂ (fun z => H z * logDeriv f z - ∑ ρ ∈ F, H ρ / (z - ρ)) z) :
    ∮ z in C(c, R), H z * logDeriv f z =
      2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ F, H ρ) := by
  have hR : (0 : ℝ) ≤ R := _hR
  set g : ℂ → ℂ := fun z => H z * logDeriv f z - ∑ ρ ∈ F, H ρ / (z - ρ) with hg
  have hg0 : ∮ z in C(c, R), g z = 0 :=
    Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR
      F.finite_toSet.countable hcont hdiff
  have hsingle_cont : ∀ ρ : ℂ, ‖ρ - c‖ < R →
      ContinuousOn (fun z : ℂ => H ρ / (z - ρ)) (Metric.sphere c R) := by
    intro ρ hρ
    refine ContinuousOn.div continuousOn_const (by fun_prop) ?_
    intro z hz
    have hmem : ‖z - c‖ = R := by simpa [Metric.mem_sphere] using hz
    intro hzρ
    have hzρ' : z = ρ := sub_eq_zero.mp hzρ
    rw [hzρ'] at hmem
    linarith
  have hterm : ∀ ρ ∈ F, ContinuousOn (fun z : ℂ => H ρ / (z - ρ)) (Metric.sphere c R) :=
    fun ρ hρ => hsingle_cont ρ (hF ρ hρ)
  have hsum_cont : ContinuousOn (fun z : ℂ => ∑ ρ ∈ F, H ρ / (z - ρ)) (Metric.sphere c R) :=
    continuousOn_finsetSum F hterm
  have hg_cont : ContinuousOn g (Metric.sphere c R) := hcont.mono Metric.sphere_subset_closedBall
  have hEq : Set.EqOn (fun z => H z * logDeriv f z)
      (fun z => g z + ∑ ρ ∈ F, H ρ / (z - ρ)) (Metric.sphere c R) := by
    intro z hz
    simp only [hg]
    abel
  rw [circleIntegral.integral_congr hR hEq,
    circleIntegral.integral_add (ContinuousOn.circleIntegrable hR hg_cont)
      (ContinuousOn.circleIntegrable hR hsum_cont), hg0, zero_add]
  have hkey : ∀ (G : Finset ℂ), (∀ ρ ∈ G, ‖ρ - c‖ < R) →
      ∮ z in C(c, R), (∑ ρ ∈ G, H ρ / (z - ρ)) =
        2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ G, H ρ) := by
    intro G
    induction G using Finset.induction with
    | empty =>
        intro _
        simp [circleIntegral]
    | insert a s ha ih =>
        intro hG
        have haR : ‖a - c‖ < R := hG a (Finset.mem_insert_self a s)
        have hsR : ∀ ρ ∈ s, ‖ρ - c‖ < R := fun ρ hρ => hG ρ (Finset.mem_insert_of_mem hρ)
        have ha_cont : ContinuousOn (fun z : ℂ => H a / (z - a)) (Metric.sphere c R) :=
          hsingle_cont a haR
        have hs_cont : ContinuousOn (fun z : ℂ => ∑ ρ ∈ s, H ρ / (z - ρ))
            (Metric.sphere c R) :=
          continuousOn_finsetSum s (fun ρ hρ => hsingle_cont ρ (hsR ρ hρ))
        have hsingle : ∮ z in C(c, R), H a / (z - a) =
            2 * (Real.pi : ℂ) * Complex.I * H a := by
          have hconst : (fun z : ℂ => H a / (z - a)) = fun z => H a * (z - a)⁻¹ := by
            funext z; rw [div_eq_mul_inv]
          rw [hconst, circleIntegral.integral_const_mul, circleIntegral_inv_sub a c R hR haR]
          ring
        calc ∮ z in C(c, R), (∑ ρ ∈ insert a s, H ρ / (z - ρ))
            = ∮ z in C(c, R), (H a / (z - a) + ∑ ρ ∈ s, H ρ / (z - ρ)) := by
                congr 1
                funext z
                rw [Finset.sum_insert ha]
          _ = (∮ z in C(c, R), H a / (z - a)) +
                ∮ z in C(c, R), (∑ ρ ∈ s, H ρ / (z - ρ)) :=
                circleIntegral.integral_add (ContinuousOn.circleIntegrable hR ha_cont)
                  (ContinuousOn.circleIntegrable hR hs_cont)
          _ = 2 * (Real.pi : ℂ) * Complex.I * H a +
                2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ s, H ρ) := by
                rw [hsingle, ih hsR]
          _ = 2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ insert a s, H ρ) := by
                rw [Finset.sum_insert ha]
                ring
  exact hkey F hF



/-- **T39. The prime side on `Re s > 1`:** the logarithmic derivative of `ζ` is
minus the von Mangoldt Dirichlet series,
`ζ′(s)/ζ(s) = −Σ' Λ(n)/n^s`. -/
theorem logDeriv_zeta_eq_neg_tsum {s : ℂ} (hs : 1 < s.re) :
    logDeriv riemannZeta s =
      -∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ s := by
  have hL : LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) s =
      -deriv riemannZeta s / riemannZeta s :=
    ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div hs
  have hzero : (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℂ)) 0 = 0 := by
    simp
  rw [LSeries_def₀ hzero s] at hL
  rw [logDeriv_apply]
  rw [hL]
  ring

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **D4. The prime-side explicit formula on a circle in the half-plane of
convergence**, as a `Prop`: for a circle with `Re c − R > 1`,
`∮_{C(c,R)} H·ζ′/ζ = −Σ'_n Λ(n) ∮_{C(c,R)} H(s)/n^s ds`. -/
def PrimeSideCircleFormula (H : ℂ → ℂ) (c : ℂ) (R : ℝ) : Prop :=
  0 ≤ R → 1 < c.re - R →
    ∮ z in C(c, R), H z * logDeriv riemannZeta z =
      -∑' n : ℕ, (ArithmeticFunction.vonMangoldt n : ℂ) *
        ∮ z in C(c, R), H z / (n : ℂ) ^ z



/-- **T40 (O3d). The M-test bound.**  For `σ > 1`, the von Mangoldt power sum
`Σ'_n Λ(n)/n^σ` is summable; this dominates `‖H·Λ(n)/n^s‖` uniformly on a
circle with `Re s ≥ σ`. -/
theorem summable_vonMangoldt_div_rpow (σ : ℝ) (hσ : 1 < σ) :
    Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ σ) := by
  have hsum : LSeriesSummable (fun n => (ArithmeticFunction.vonMangoldt n : ℂ)) ((σ : ℝ) : ℂ) :=
    ArithmeticFunction.LSeriesSummable_vonMangoldt (by simpa using hσ)
  convert hsum.norm using 1
  funext n
  rw [LSeries.term_def]
  by_cases hn : n = 0
  · simp [hn]
  · rw [if_neg hn, norm_div, Complex.norm_natCast_cpow_of_pos (Nat.pos_of_ne_zero hn)]
    have hre : (((σ : ℝ) : ℂ)).re = σ := Complex.ofReal_re σ
    rw [hre, Complex.norm_real, Real.norm_of_nonneg ArithmeticFunction.vonMangoldt_nonneg]



/-- **T41. Termwise integration of a uniformly dominated series over an
interval.** -/
theorem intervalIntegral_tsum {g : ℕ → ℝ → ℂ} {a b : ℝ} {M : ℕ → ℝ}
    (hab : a ≤ b) (hM : Summable M) (hg : ∀ n θ, ‖g n θ‖ ≤ M n)
    (hgc : ∀ n, Continuous (g n)) :
    ∫ θ : ℝ in a..b, (∑' n, g n θ) = ∑' n, ∫ θ : ℝ in a..b, g n θ := by
  have hMnn : ∀ n, 0 ≤ M n := fun n => le_trans (norm_nonneg _) (hg n 0)
  have hint_summable : Summable (fun n => ∫ θ : ℝ in a..b, g n θ) := by
    refine Summable.of_norm_bounded (g := fun n => M n * (b - a)) (hM.mul_right _) ?_
    intro n
    calc ‖∫ θ : ℝ in a..b, g n θ‖ ≤ ∫ θ : ℝ in a..b, ‖g n θ‖ :=
          intervalIntegral.norm_integral_le_integral_norm hab
      _ ≤ ∫ θ : ℝ in a..b, M n := by
          refine intervalIntegral.integral_mono_on hab ?_ intervalIntegrable_const ?_
          · exact (hgc n).intervalIntegrable a b |>.norm
          · intro θ hθ
            exact hg n θ
      _ = M n * (b - a) := by
          rw [intervalIntegral.integral_const, smul_eq_mul]
          ring
  set μ : Measure ℝ := volume.restrict (Set.Ioc a b) with hμ
  haveI : IsFiniteMeasure μ := ⟨by
    rw [hμ, Measure.restrict_apply_univ, Real.volume_Ioc]
    exact ENNReal.ofReal_lt_top⟩
  set S : ℕ → ℝ → ℂ := fun N θ => ∑ i ∈ Finset.range N, g i θ with hS
  have hScont : ∀ N, Continuous (S N) := fun N =>
    continuous_finsetSum _ (fun i _ => hgc i)
  have hSbound : ∀ N θ, ‖S N θ‖ ≤ ∑' n, M n := by
    intro N θ
    calc ‖S N θ‖ ≤ ∑ i ∈ Finset.range N, ‖g i θ‖ := norm_sum_le _ _
      _ ≤ ∑ i ∈ Finset.range N, M i :=
          Finset.sum_le_sum (fun i _ => hg i θ)
      _ ≤ ∑' n, M n := hM.sum_le_tsum (Finset.range N) (fun i _ => hMnn i)
  have hlim : Tendsto (fun N : ℕ => ∫ θ, S N θ ∂μ) atTop
      (nhds (∫ θ, ∑' n, g n θ ∂μ)) := by
    refine MeasureTheory.tendsto_integral_of_dominated_convergence
      (F := S) (f := fun θ => ∑' n, g n θ) (bound := fun _ => ∑' n, M n)
      (fun N => (hScont N).aestronglyMeasurable)
      (integrable_const _)
      (fun N => Filter.Eventually.of_forall (hSbound N)) ?_
    refine Filter.Eventually.of_forall (fun θ => ?_)
    exact (Summable.of_norm_bounded hM (fun n => hg n θ)).hasSum.tendsto_sum_nat
  have hfin : ∀ N, ∫ θ, S N θ ∂μ = ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ := by
    intro N
    rw [hS]
    refine MeasureTheory.integral_finset_sum _ (fun i _ => ?_)
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le (μ := volume) hab).mp
      ((hgc i).intervalIntegrable a b)
  have hlim' : Tendsto (fun N : ℕ => ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ) atTop
      (nhds (∫ θ, ∑' n, g n θ ∂μ)) := by
    simpa only [hfin] using hlim
  have hsum : Tendsto (fun N : ℕ => ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ) atTop
      (nhds (∑' n, ∫ θ, g n θ ∂μ)) := by
    have hSμ : Summable (fun n => ∫ θ, g n θ ∂μ) := by
      simpa [hμ, intervalIntegral.integral_of_le hab] using hint_summable
    exact hSμ.hasSum.tendsto_sum_nat
  have hgoal : (∫ θ, ∑' n, g n θ ∂μ) = ∑' n, ∫ θ, g n θ ∂μ :=
    tendsto_nhds_unique hlim' hsum
  simpa only [hμ, intervalIntegral.integral_of_le hab] using hgoal

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **T42. Termwise integration of a uniformly dominated series on a circle.**

If `‖F n z‖ ≤ M n` with `Σ M n < ∞` and each `F n` continuous, then
`∮_{C(c,R)} Σ'_n F n = Σ'_n ∮_{C(c,R)} F n`. -/
theorem circleIntegral_tsum {F : ℕ → ℂ → ℂ} {c : ℂ} {R : ℝ} {M : ℕ → ℝ}
    (hM : Summable M) (hF : ∀ n (z : ℂ), ‖F n z‖ ≤ M n)
    (hFc : ∀ n, Continuous (F n)) :
    ∮ z in C(c, R), (∑' n, F n z) = ∑' n, ∮ z in C(c, R), F n z := by
  simp only [circleIntegral]
  have hpush : ∀ θ : ℝ, deriv (circleMap c R) θ • (∑' n, F n (circleMap c R θ))
      = ∑' n, deriv (circleMap c R) θ • F n (circleMap c R θ) := by
    intro θ
    rw [smul_eq_mul]
    exact (tsum_mul_left (f := fun n => F n (circleMap c R θ))
      (a := deriv (circleMap c R) θ)).symm
  simp_rw [hpush]
  refine intervalIntegral_tsum (a := 0) (b := 2 * Real.pi) (by positivity)
    (M := fun n => |R| * M n) (hM.mul_left |R|) ?_ ?_
  · intro n θ
    rw [norm_smul, deriv_circleMap, norm_mul]
    have hnorm : ‖circleMap 0 R θ‖ = |R| := by
      simp only [circleMap_zero, norm_mul, Complex.norm_real, Real.norm_eq_abs,
        Complex.norm_exp]
      rw [show ((θ : ℂ) * Complex.I).re = 0 by simp]
      simp
    rw [hnorm]
    have hI : ‖Complex.I‖ = 1 := by simp
    rw [hI, mul_one]
    exact mul_le_mul_of_nonneg_left (hF n _) (abs_nonneg R)
  · intro n
    have h1 : Continuous (fun θ : ℝ => deriv (circleMap c R) θ) := by
      rw [show (fun θ : ℝ => deriv (circleMap c R) θ) =
          fun θ => circleMap 0 R θ * Complex.I from by
        funext θ; rw [deriv_circleMap]]
      exact (continuous_circleMap 0 R).mul continuous_const
    exact h1.smul ((hFc n).comp (continuous_circleMap c R))



/-- **O3f, the pointwise majorant.**  On the circle, `‖H·Λ(n)/n^z‖` is bounded
by `K·Λ(n)/n^(Re c − R)` when `‖H‖ ≤ K` on the circle. -/
theorem norm_term_le_circle {H : ℂ → ℂ} {c : ℂ} {R K : ℝ} {n : ℕ} {z : ℂ}
    (hK : ∀ w : ℂ, ‖w - c‖ = R → ‖H w‖ ≤ K) (hz : ‖z - c‖ = R)
    (hn : n ≠ 0) (hK0 : 0 ≤ K) :
    ‖H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z)‖ ≤
      K * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ (c.re - R)) := by
  have hnpos : (0 : ℝ) < (n : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hn
  have hn1 : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast Nat.one_le_iff_ne_zero.mpr hn
  have hzre : c.re - R ≤ z.re := by
    have h1 : |z.re - c.re| ≤ ‖z - c‖ := by
      simpa [Complex.sub_re] using Complex.abs_re_le_norm (z - c)
    rw [hz] at h1
    have h2 : -(R : ℝ) ≤ z.re - c.re := (abs_le.mp h1).1
    linarith
  have hnorm : ‖(n : ℂ) ^ z‖ = (n : ℝ) ^ z.re :=
    Complex.norm_natCast_cpow_of_pos (Nat.pos_of_ne_zero hn) z
  have hmono : (n : ℝ) ^ (c.re - R) ≤ (n : ℝ) ^ z.re :=
    Real.rpow_le_rpow_of_exponent_le hn1 hzre
  have hΛ : (0 : ℝ) ≤ (ArithmeticFunction.vonMangoldt n : ℝ) :=
    ArithmeticFunction.vonMangoldt_nonneg
  have hden : (0 : ℝ) < (n : ℝ) ^ (c.re - R) := Real.rpow_pos_of_pos hnpos _
  rw [norm_mul, norm_div, hnorm, Complex.norm_real, Real.norm_of_nonneg hΛ]
  have hHz : ‖H z‖ ≤ K := hK z hz
  have hratio : (ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ z.re ≤
      (ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ (c.re - R) := by
    apply div_le_div_of_nonneg_left hΛ hden hmono
  calc ‖H z‖ * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ z.re)
      ≤ K * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ z.re) :=
        mul_le_mul_of_nonneg_right hHz (by positivity)
    _ ≤ K * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ (c.re - R)) :=
        mul_le_mul_of_nonneg_left hratio hK0



/-- **T44. Termwise integration with an interval-local bound.** -/
theorem intervalIntegral_tsum_Icc {g : ℕ → ℝ → ℂ} {a b : ℝ} {M : ℕ → ℝ}
    (hab : a ≤ b) (hM : Summable M)
    (hg : ∀ n θ, θ ∈ Set.Icc a b → ‖g n θ‖ ≤ M n)
    (hgc : ∀ n, Continuous (g n)) :
    ∫ θ : ℝ in a..b, (∑' n, g n θ) = ∑' n, ∫ θ : ℝ in a..b, g n θ := by
  have hMnn : ∀ n, 0 ≤ M n := fun n =>
    le_trans (norm_nonneg _) (hg n a (Set.left_mem_Icc.mpr hab))
  have hint_summable : Summable (fun n => ∫ θ : ℝ in a..b, g n θ) := by
    refine Summable.of_norm_bounded (g := fun n => M n * (b - a)) (hM.mul_right _) ?_
    intro n
    calc ‖∫ θ : ℝ in a..b, g n θ‖ ≤ ∫ θ : ℝ in a..b, ‖g n θ‖ :=
          intervalIntegral.norm_integral_le_integral_norm hab
      _ ≤ ∫ θ : ℝ in a..b, M n := by
          refine intervalIntegral.integral_mono_on hab ?_ intervalIntegrable_const ?_
          · exact (hgc n).intervalIntegrable a b |>.norm
          · intro θ hθ
            exact hg n θ hθ
      _ = M n * (b - a) := by
          rw [intervalIntegral.integral_const, smul_eq_mul]
          ring
  set μ : Measure ℝ := volume.restrict (Set.Ioc a b) with hμ
  haveI : IsFiniteMeasure μ := ⟨by
    rw [hμ, Measure.restrict_apply_univ, Real.volume_Ioc]
    exact ENNReal.ofReal_lt_top⟩
  set S : ℕ → ℝ → ℂ := fun N θ => ∑ i ∈ Finset.range N, g i θ with hS
  have hScont : ∀ N, Continuous (S N) := fun N =>
    continuous_finsetSum _ (fun i _ => hgc i)
  have hSbound : ∀ N θ, θ ∈ Set.Ioc a b → ‖S N θ‖ ≤ ∑' n, M n := by
    intro N θ hθ
    have hIcc : θ ∈ Set.Icc a b := Set.Ioc_subset_Icc_self hθ
    calc ‖S N θ‖ ≤ ∑ i ∈ Finset.range N, ‖g i θ‖ := norm_sum_le _ _
      _ ≤ ∑ i ∈ Finset.range N, M i :=
          Finset.sum_le_sum (fun i _ => hg i θ hIcc)
      _ ≤ ∑' n, M n := hM.sum_le_tsum (Finset.range N) (fun i _ => hMnn i)
  have hlim : Tendsto (fun N : ℕ => ∫ θ, S N θ ∂μ) atTop
      (nhds (∫ θ, ∑' n, g n θ ∂μ)) := by
    refine MeasureTheory.tendsto_integral_of_dominated_convergence
      (F := S) (f := fun θ => ∑' n, g n θ) (bound := fun _ => ∑' n, M n)
      (fun N => (hScont N).aestronglyMeasurable)
      (integrable_const _)
      (fun N => (ae_restrict_mem measurableSet_Ioc).mono (fun θ hθ => hSbound N θ hθ)) ?_
    refine (ae_restrict_mem measurableSet_Ioc).mono (fun θ hθ => ?_)
    exact (Summable.of_norm_bounded hM
      (fun n => hg n θ (Set.Ioc_subset_Icc_self hθ))).hasSum.tendsto_sum_nat
  have hfin : ∀ N, ∫ θ, S N θ ∂μ = ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ := by
    intro N
    rw [hS]
    refine MeasureTheory.integral_finsetSum _ (fun i _ => ?_)
    exact (intervalIntegrable_iff_integrableOn_Ioc_of_le (μ := volume) hab).mp
      ((hgc i).intervalIntegrable a b)
  have hlim' : Tendsto (fun N : ℕ => ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ) atTop
      (nhds (∫ θ, ∑' n, g n θ ∂μ)) := by
    simpa only [hfin] using hlim
  have hsum : Tendsto (fun N : ℕ => ∑ i ∈ Finset.range N, ∫ θ, g i θ ∂μ) atTop
      (nhds (∑' n, ∫ θ, g n θ ∂μ)) := by
    have hSμ : Summable (fun n => ∫ θ, g n θ ∂μ) := by
      simpa [hμ, intervalIntegral.integral_of_le hab] using hint_summable
    exact hSμ.hasSum.tendsto_sum_nat
  have hgoal : (∫ θ, ∑' n, g n θ ∂μ) = ∑' n, ∫ θ, g n θ ∂μ :=
    tendsto_nhds_unique hlim' hsum
  simpa only [hμ, intervalIntegral.integral_of_le hab] using hgoal

/-- **T45. Termwise integration on a circle with a sphere-local bound.** -/
theorem circleIntegral_tsum_sphere {F : ℕ → ℂ → ℂ} {c : ℂ} {R : ℝ} {M : ℕ → ℝ}
    (hR : 0 ≤ R) (hM : Summable M)
    (hF : ∀ n z, z ∈ Metric.sphere c R → ‖F n z‖ ≤ M n)
    (hFc : ∀ n, Continuous (F n)) :
    ∮ z in C(c, R), (∑' n, F n z) = ∑' n, ∮ z in C(c, R), F n z := by
  simp only [circleIntegral]
  have hpush : ∀ θ : ℝ, deriv (circleMap c R) θ • (∑' n, F n (circleMap c R θ))
      = ∑' n, deriv (circleMap c R) θ • F n (circleMap c R θ) := by
    intro θ
    rw [smul_eq_mul]
    exact (tsum_mul_left (f := fun n => F n (circleMap c R θ))
      (a := deriv (circleMap c R) θ)).symm
  simp_rw [hpush]
  have hmem : ∀ θ : ℝ, circleMap c R θ ∈ Metric.sphere c R := by
    intro θ
    rw [Metric.mem_sphere, dist_eq_norm]
    have hsub : circleMap c R θ - c = (R : ℂ) * Complex.exp ((θ : ℂ) * Complex.I) := by
      simp [circleMap]
    rw [hsub, norm_mul, Complex.norm_real, Real.norm_eq_abs, Complex.norm_exp]
    rw [show ((θ : ℂ) * Complex.I).re = 0 by simp]
    simp [abs_of_nonneg hR]
  refine intervalIntegral_tsum_Icc (a := 0) (b := 2 * Real.pi) (by positivity)
    (M := fun n => |R| * M n) (hM.mul_left |R|) ?_ ?_
  · intro n θ _
    rw [norm_smul, deriv_circleMap, norm_mul]
    have hnorm : ‖circleMap 0 R θ‖ = |R| := by
      simp only [circleMap_zero, norm_mul, Complex.norm_real, Real.norm_eq_abs,
        Complex.norm_exp]
      rw [show ((θ : ℂ) * Complex.I).re = 0 by simp]
      simp
    rw [hnorm]
    have hI : ‖Complex.I‖ = 1 := by simp
    rw [hI, mul_one]
    exact mul_le_mul_of_nonneg_left (hF n _ (hmem θ)) (abs_nonneg R)
  · intro n
    have h1 : Continuous (fun θ : ℝ => deriv (circleMap c R) θ) := by
      rw [show (fun θ : ℝ => deriv (circleMap c R) θ) =
          fun θ => circleMap 0 R θ * Complex.I from by
        funext θ; rw [deriv_circleMap]]
      exact (continuous_circleMap 0 R).mul continuous_const
    exact h1.smul ((hFc n).comp (continuous_circleMap c R))

/-- **T46. The prime-side explicit formula on a circle in `Re s > 1`** (D4,
proved). -/
theorem primeSideCircleFormula_holds (H : ℂ → ℂ) (c : ℂ) (R : ℝ) (hH : Continuous H) :
    PrimeSideCircleFormula H c R := by
  intro hR hc
  obtain ⟨C₀, hC₀⟩ := (isCompact_closedBall c R).exists_bound_of_continuousOn hH.continuousOn
  set K := max C₀ 0 with hKdef
  have hK0 : 0 ≤ K := le_max_right _ _
  have hK : ∀ w : ℂ, w ∈ Metric.sphere c R → ‖H w‖ ≤ K := by
    intro w hw
    exact le_trans (hC₀ w (Metric.sphere_subset_closedBall hw)) (le_max_left _ _)
  have hEqOn : Set.EqOn (fun z => H z * logDeriv riemannZeta z)
      (fun z => ∑' n : ℕ, -(H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z)))
      (Metric.sphere c R) := by
    intro z hz
    show H z * logDeriv riemannZeta z = _
    have hmem : ‖z - c‖ = R := by simpa [Metric.mem_sphere] using hz
    have hzre : 1 < z.re := by
      have h1 : |z.re - c.re| ≤ ‖z - c‖ := by
        simpa [Complex.sub_re] using Complex.abs_re_le_norm (z - c)
      rw [hmem] at h1
      have h2 : -(R : ℝ) ≤ z.re - c.re := (abs_le.mp h1).1
      linarith
    rw [logDeriv_zeta_eq_neg_tsum hzre, mul_neg, ← tsum_mul_left, ← tsum_neg]
  rw [circleIntegral.integral_congr hR hEqOn]
  have hM : Summable (fun n : ℕ =>
      K * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ (c.re - R))) :=
    (summable_vonMangoldt_div_rpow (c.re - R) hc).mul_left K
  have hbound : ∀ (n : ℕ) (z : ℂ), z ∈ Metric.sphere c R →
      ‖-(H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z))‖ ≤
        K * ((ArithmeticFunction.vonMangoldt n : ℝ) / (n : ℝ) ^ (c.re - R)) := by
    intro n z hz
    rw [norm_neg]
    by_cases hn : n = 0
    · rw [hn]
      have hΛ0 : (ArithmeticFunction.vonMangoldt 0 : ℂ) = 0 := by simp
      have hx : (c.re - R) ≠ 0 := by linarith
      simp [hΛ0, Real.zero_rpow hx]
    · refine norm_term_le_circle (H := H) (c := c) (R := R) (K := K) ?_ ?_ hn hK0
      · intro w hw
        exact hK w (by rwa [Metric.mem_sphere, dist_eq_norm])
      · rwa [Metric.mem_sphere, dist_eq_norm] at hz
  have hcont : ∀ n, Continuous
      (fun z : ℂ => -(H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z))) := by
    intro n
    by_cases hn : n = 0
    · rw [hn]
      have hΛ0 : (ArithmeticFunction.vonMangoldt 0 : ℂ) = 0 := by simp
      simp only [hΛ0, zero_div, mul_zero, neg_zero]
      exact continuous_zero
    · haveI : NeZero (n : ℂ) := ⟨by exact_mod_cast hn⟩
      have hpow : Continuous (fun z : ℂ => (n : ℂ) ^ z) := continuous_const_cpow (n : ℂ)
      have hne : ∀ z : ℂ, (n : ℂ) ^ z ≠ 0 := by
        intro z
        rw [Complex.cpow_ne_zero_iff]
        left
        exact_mod_cast hn
      exact (hH.mul (continuous_const.div hpow hne)).neg
  rw [circleIntegral_tsum_sphere hR hM hbound hcont]
  have hterm : ∀ n : ℕ,
      ∮ z in C(c, R), -(H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z)) =
        -((ArithmeticFunction.vonMangoldt n : ℂ) *
          ∮ z in C(c, R), H z / (n : ℂ) ^ z) := by
    intro n
    have hfun : (fun z : ℂ => -(H z * ((ArithmeticFunction.vonMangoldt n : ℂ) / (n : ℂ) ^ z))) =
        fun z => (-(ArithmeticFunction.vonMangoldt n : ℂ)) * (H z / (n : ℂ) ^ z) := by
      funext z
      ring
    rw [hfun, circleIntegral.integral_const_mul]
    ring
  simp_rw [hterm]
  rw [tsum_neg]



/-- **T47. The kernel integral vanishes outside the rectangle.** -/
theorem boundaryIntegral_inv_sub_of_not_mem {ρ z w : ℂ}
    (h : ρ ∉ Set.uIcc z.re w.re ×ℂ Set.uIcc z.im w.im) :
    boundaryIntegral (fun s => (s - ρ)⁻¹) z w = 0 := by
  refine boundaryIntegral_eq_zero_of_off_countable (fun s => (s - ρ)⁻¹) z w {ρ}
    (Set.countable_singleton ρ) ?_ ?_
  · refine ContinuousOn.inv₀ (by fun_prop) ?_
    intro s hs
    intro hsp
    exact h ((sub_eq_zero.mp hsp) ▸ hs)
  · intro x hx
    have hxne : x ≠ ρ := by
      intro hxρ
      exact hx.2 (by simp [hxρ])
    exact (differentiableAt_id.sub_const ρ).inv (sub_ne_zero.mpr hxne)

/-- **T48. The circle kernel integral vanishes outside the disc.** -/
theorem circleIntegral_inv_sub_of_gt {ρ c : ℂ} {R : ℝ} (hR : 0 ≤ R) (h : R < ‖ρ - c‖) :
    ∮ z in C(c, R), (z - ρ)⁻¹ = 0 := by
  refine Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR
    (s := {ρ}) (Set.countable_singleton ρ) ?_ ?_
  · refine ContinuousOn.inv₀ (by fun_prop) ?_
    intro z hz
    have hz' : ‖z - c‖ ≤ R := by simpa [Metric.mem_closedBall, dist_eq_norm] using hz
    intro hzρ
    have hzρ' : z = ρ := sub_eq_zero.mp hzρ
    rw [hzρ'] at hz'
    linarith
  · intro x hx
    have hxne : x ≠ ρ := by
      intro hxρ
      exact hx.2 (by simp [hxρ])
    exact (differentiableAt_id.sub_const ρ).inv (sub_ne_zero.mpr hxne)



/-- **T49 (O3c). The residue of `H·ζ′/ζ` at a simple zero is `H(ρ)`.** -/
theorem tendsto_residue_mul (H : ℂ → ℂ) (ρ : ℂ) (hζ : riemannZeta ρ = 0) (hρ1 : ρ ≠ 1)
    (hsimple : deriv riemannZeta ρ ≠ 0) (hH : ContinuousAt H ρ) :
    Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s))
      (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) := by
  have h1 : Tendsto (fun s : ℂ => (s - ρ) * logDeriv riemannZeta s)
      (nhdsWithin ρ {ρ}ᶜ) (nhds 1) :=
    tendsto_logDeriv_zero ρ hζ hρ1 hsimple
  have h2 : Tendsto H (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) :=
    hH.tendsto.mono_left nhdsWithin_le_nhds
  have hprod : Tendsto (fun s : ℂ => H s * ((s - ρ) * logDeriv riemannZeta s))
      (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ * 1)) := h2.mul h1
  have hfun : (fun s : ℂ => H s * ((s - ρ) * logDeriv riemannZeta s)) =
      fun s => (s - ρ) * (H s * logDeriv riemannZeta s) := by
    funext s
    ring
  rw [hfun] at hprod
  simpa using hprod

/-- **T50. The subtracted function has at most a simple singularity:**
`(s − ρ)·(H·ζ′/ζ − H(ρ)/(s − ρ)) → 0`. -/
theorem tendsto_subtracted_mul (H : ℂ → ℂ) (ρ : ℂ) (hζ : riemannZeta ρ = 0) (hρ1 : ρ ≠ 1)
    (hsimple : deriv riemannZeta ρ ≠ 0) (hH : ContinuousAt H ρ) :
    Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s - H ρ / (s - ρ)))
      (nhdsWithin ρ {ρ}ᶜ) (nhds 0) := by
  have h1 : Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s))
      (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) :=
    tendsto_residue_mul H ρ hζ hρ1 hsimple hH
  have h2 : Tendsto (fun s : ℂ => H ρ) (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) :=
    tendsto_const_nhds
  have hsub : Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s) - H ρ)
      (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ - H ρ)) := h1.sub h2
  rw [sub_self] at hsub
  have hcongr : (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s) - H ρ)
      =ᶠ[nhdsWithin ρ {ρ}ᶜ]
      (fun s => (s - ρ) * (H s * logDeriv riemannZeta s - H ρ / (s - ρ))) := by
    filter_upwards [self_mem_nhdsWithin] with s hs
    have hsr : s - ρ ≠ 0 := sub_ne_zero.mpr hs
    field_simp
  exact hsub.congr' hcongr



/-- **T51. `ζ′` is analytic away from `1`.** -/
theorem analyticAt_deriv_zeta {ρ : ℂ} (hρ : ρ ≠ 1) :
    AnalyticAt ℂ (deriv riemannZeta) ρ :=
  (analyticAt_zeta hρ).deriv

/-- **T52. `ζ` is `C²` away from `1`:** `ζ′` is differentiable. -/
theorem differentiableAt_deriv_zeta {ρ : ℂ} (hρ : ρ ≠ 1) :
    DifferentiableAt ℂ (deriv riemannZeta) ρ :=
  (analyticAt_deriv_zeta hρ).differentiableAt

/-- **T53. `ζ′` is continuous away from `1`.** -/
theorem continuousAt_deriv_zeta {ρ : ℂ} (hρ : ρ ≠ 1) :
    ContinuousAt (deriv riemannZeta) ρ :=
  (analyticAt_deriv_zeta hρ).continuousAt

/-- **T54. The second derivative exists away from `1`.** -/
theorem differentiableAt_deriv2_zeta {ρ : ℂ} (hρ : ρ ≠ 1) :
    DifferentiableAt ℂ (deriv (deriv riemannZeta)) ρ :=
  (analyticAt_deriv_zeta hρ).deriv.differentiableAt

/-- **T55. `ζ″` is continuous away from `1`.** -/
theorem continuousAt_deriv2_zeta {ρ : ℂ} (hρ : ρ ≠ 1) :
    ContinuousAt (deriv (deriv riemannZeta)) ρ :=
  (analyticAt_deriv_zeta hρ).deriv.continuousAt



/-- **T56. `H·ζ′/ζ` is differentiable away from `1` and the zeros of `ζ`.** -/
theorem differentiableAt_mul_logDeriv (H : ℂ → ℂ) {ρ : ℂ} (hρ1 : ρ ≠ 1)
    (hz : riemannZeta ρ ≠ 0) (hH : DifferentiableAt ℂ H ρ) :
    DifferentiableAt ℂ (fun s => H s * logDeriv riemannZeta s) ρ :=
  hH.mul (differentiableAt_logDeriv_zeta hρ1 hz)

/-- **T57. The subtracted function is `o(1/(s − ρ))`:**
`(s − ρ)²·(H·ζ′/ζ − H(ρ)/(s − ρ)) → 0` at a simple zero. -/
theorem tendsto_subtracted_mul_sq (H : ℂ → ℂ) (ρ : ℂ) (hζ : riemannZeta ρ = 0)
    (hρ1 : ρ ≠ 1) (hsimple : deriv riemannZeta ρ ≠ 0) (hH : ContinuousAt H ρ) :
    Tendsto (fun s : ℂ => (s - ρ) ^ 2 * (H s * logDeriv riemannZeta s - H ρ / (s - ρ)))
      (nhdsWithin ρ {ρ}ᶜ) (nhds 0) := by
  have h1 : Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s))
      (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) :=
    tendsto_residue_mul H ρ hζ hρ1 hsimple hH
  have h2 : Tendsto (fun s : ℂ => H ρ) (nhdsWithin ρ {ρ}ᶜ) (nhds (H ρ)) :=
    tendsto_const_nhds
  have h3 : Tendsto (fun s : ℂ => (s - ρ) * (H s * logDeriv riemannZeta s) - H ρ)
      (nhdsWithin ρ {ρ}ᶜ) (nhds 0) := by
    have := h1.sub h2
    rwa [sub_self] at this
  have h4 : Tendsto (fun s : ℂ => (s - ρ)) (nhdsWithin ρ {ρ}ᶜ) (nhds 0) := by
    have h : Tendsto (fun s : ℂ => s - ρ) (nhds ρ) (nhds (ρ - ρ)) :=
      tendsto_id.sub tendsto_const_nhds
    rw [sub_self] at h
    exact h.mono_left nhdsWithin_le_nhds
  have hprod : Tendsto (fun s : ℂ => (s - ρ) * ((s - ρ) * (H s * logDeriv riemannZeta s) - H ρ))
      (nhdsWithin ρ {ρ}ᶜ) (nhds (0 * 0)) := h4.mul h3
  rw [mul_zero] at hprod
  refine hprod.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with s hs
  have hsr : s - ρ ≠ 0 := sub_ne_zero.mpr hs
  field_simp



/-- `1/√2 = √2/2`. -/
theorem one_div_sqrt_two : (1 : ℝ) / Real.sqrt 2 = Real.sqrt 2 / 2 := by
  have h2 : (0:ℝ) < Real.sqrt 2 := Real.sqrt_pos.mpr (by norm_num)
  field_simp
  nlinarith [Real.sq_sqrt (by norm_num : (0:ℝ) ≤ 2)]

/-- `arcsin (√2/2) = π/4`. -/
theorem arcsin_sqrt_two_div_two : Real.arcsin (Real.sqrt 2 / 2) = Real.pi / 4 := by
  have hsin : Real.sin (Real.pi / 4) = Real.sqrt 2 / 2 := Real.sin_pi_div_four
  rw [← hsin]
  exact Real.arcsin_sin (by linarith [Real.pi_pos]) (by linarith [Real.pi_pos])

/-- `arcsin (−√2/2) = −π/4`. -/
theorem arcsin_neg_sqrt_two_div_two : Real.arcsin (-(Real.sqrt 2 / 2)) = -(Real.pi / 4) := by
  have hsin : Real.sin (-(Real.pi / 4)) = -(Real.sqrt 2 / 2) := by
    rw [Real.sin_neg, Real.sin_pi_div_four]
  rw [← hsin]
  exact Real.arcsin_sin (by linarith [Real.pi_pos]) (by linarith [Real.pi_pos])

theorem norm_one_add_I_sq : ‖(1 : ℂ) + Complex.I‖ = Real.sqrt 2 := by
  have h := Complex.norm_add_mul_I (1 : ℝ) (1 : ℝ)
  rw [show ((1:ℂ) + Complex.I) = ((1:ℝ):ℂ) + ((1:ℝ):ℂ) * Complex.I by push_cast; ring, h]
  norm_num

theorem norm_one_sub_I_sq : ‖(1 : ℂ) - Complex.I‖ = Real.sqrt 2 := by
  have h := Complex.norm_add_mul_I (1 : ℝ) (-1 : ℝ)
  rw [show ((1:ℂ) - Complex.I) = ((1:ℝ):ℂ) + ((-1:ℝ):ℂ) * Complex.I by push_cast; ring, h]
  norm_num

/-- **Argument of `1 − i`.** -/
theorem arg_one_sub_I : Complex.arg ((1 : ℂ) - Complex.I) = -(Real.pi / 4) := by
  rw [Complex.arg_of_re_nonneg (by simp : (0:ℝ) ≤ ((1:ℂ) - Complex.I).re)]
  have him : ((1 : ℂ) - Complex.I).im = -1 := by simp
  have hnorm : ‖(1 : ℂ) - Complex.I‖ = Real.sqrt 2 := norm_one_sub_I_sq
  have hdiv : (-1 : ℝ) / Real.sqrt 2 = -(Real.sqrt 2 / 2) := by
    rw [show (-1 : ℝ) / Real.sqrt 2 = -((1:ℝ)/Real.sqrt 2) by ring, one_div_sqrt_two]
  rw [him, hnorm, hdiv]
  exact arcsin_neg_sqrt_two_div_two

/-- **Argument of `1 + i`.** -/
theorem arg_one_add_I : Complex.arg ((1 : ℂ) + Complex.I) = Real.pi / 4 := by
  rw [Complex.arg_of_re_nonneg (by simp : (0:ℝ) ≤ ((1:ℂ) + Complex.I).re)]
  have him : ((1 : ℂ) + Complex.I).im = 1 := by simp
  have hnorm : ‖(1 : ℂ) + Complex.I‖ = Real.sqrt 2 := norm_one_add_I_sq
  rw [him, hnorm, one_div_sqrt_two]
  exact arcsin_sqrt_two_div_two

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

theorem norm_neg_one_add_I : ‖((-1 : ℂ) + Complex.I)‖ = Real.sqrt 2 := by
  have h := Complex.norm_add_mul_I (-1 : ℝ) (1 : ℝ)
  rw [show ((-1:ℂ) + Complex.I) = ((-1:ℝ):ℂ) + ((1:ℝ):ℂ) * Complex.I by push_cast; ring, h]
  norm_num

theorem norm_neg_one_sub_I : ‖((-1 : ℂ) - Complex.I)‖ = Real.sqrt 2 := by
  have h := Complex.norm_add_mul_I (-1 : ℝ) (-1 : ℝ)
  rw [show ((-1:ℂ) - Complex.I) = ((-1:ℝ):ℂ) + ((-1:ℝ):ℂ) * Complex.I by push_cast; ring, h]
  norm_num

/-- **Argument of `−1 + i`.** -/
theorem arg_neg_one_add_I : Complex.arg ((-1 : ℂ) + Complex.I) = 3 * Real.pi / 4 := by
  rw [Complex.arg_of_re_neg_of_im_nonneg (by simp : ((-1:ℂ) + Complex.I).re < 0)
    (by simp : (0:ℝ) ≤ ((-1:ℂ) + Complex.I).im)]
  have hneg : -((-1 : ℂ) + Complex.I) = (1 : ℂ) - Complex.I := by ring
  rw [hneg]
  have him : ((1 : ℂ) - Complex.I).im = -1 := by simp
  have hnorm : ‖(1 : ℂ) - Complex.I‖ = Real.sqrt 2 := norm_one_sub_I_sq
  have hnorm' : ‖((-1 : ℂ) + Complex.I)‖ = Real.sqrt 2 := norm_neg_one_add_I
  rw [him, hnorm']
  have hdiv : (-1 : ℝ) / Real.sqrt 2 = -(Real.sqrt 2 / 2) := by
    rw [show (-1 : ℝ) / Real.sqrt 2 = -((1:ℝ)/Real.sqrt 2) by ring, one_div_sqrt_two]
  rw [hdiv, arcsin_neg_sqrt_two_div_two]
  ring

/-- **Argument of `−1 − i`.** -/
theorem arg_neg_one_sub_I : Complex.arg ((-1 : ℂ) - Complex.I) = -(3 * Real.pi / 4) := by
  rw [Complex.arg_of_re_neg_of_im_neg (by simp : ((-1:ℂ) - Complex.I).re < 0)
    (by simp : ((-1:ℂ) - Complex.I).im < 0)]
  have hneg : -((-1 : ℂ) - Complex.I) = (1 : ℂ) + Complex.I := by ring
  rw [hneg]
  have him : ((1 : ℂ) + Complex.I).im = 1 := by simp
  have hnorm' : ‖((-1 : ℂ) - Complex.I)‖ = Real.sqrt 2 := norm_neg_one_sub_I
  rw [him, hnorm', one_div_sqrt_two, arcsin_sqrt_two_div_two]
  ring



/-- `x ↦ log (x − ρ)` has derivative `(x − ρ)⁻¹` on the slit plane. -/
theorem hasDerivAt_log_sub (ρ : ℂ) {x : ℝ} (hx : ((x : ℂ) - ρ) ∈ Complex.slitPlane) :
    HasDerivAt (fun t : ℝ => Complex.log ((t : ℂ) - ρ)) (((x : ℂ) - ρ)⁻¹) x := by
  have hlin : HasDerivAt (fun t : ℝ => ((t : ℂ) - ρ)) (1 : ℂ) x := by
    have h1 : HasDerivAt (fun t : ℝ => (t : ℂ)) 1 x := by
      simpa using (hasDerivAt_id x).ofReal_comp
    simpa using h1.sub_const ρ
  have hlog := (Complex.hasDerivAt_log hx).hasFDerivAt
  have hlogℝ : HasFDerivAt Complex.log
      (ContinuousLinearMap.restrictScalars ℝ
        (ContinuousLinearMap.toSpanSingleton ℂ (((x : ℂ) - ρ)⁻¹))) ((x : ℂ) - ρ) :=
    hlog.restrictScalars ℝ
  have hcomp := hlogℝ.comp_hasDerivAt x hlin
  have hval : (ContinuousLinearMap.restrictScalars ℝ
      (ContinuousLinearMap.toSpanSingleton ℂ (((x : ℂ) - ρ)⁻¹))) 1 = ((x : ℂ) - ρ)⁻¹ := by
    simp [ContinuousLinearMap.toSpanSingleton_apply]
  rw [hval] at hcomp
  exact hcomp

/-- The bottom side of the unit square: `∫_{-1}^{1} (x − i)⁻¹ dx = iπ/2`. -/
theorem integral_bottom :
    ∫ x : ℝ in (-1)..1, (((x : ℂ) - Complex.I)⁻¹) = (Real.pi / 2 : ℂ) * Complex.I := by
  have hderiv : ∀ x ∈ Set.uIcc (-1:ℝ) 1,
      HasDerivAt (fun t : ℝ => Complex.log ((t : ℂ) - Complex.I))
        (((x : ℂ) - Complex.I)⁻¹) x := by
    intro x hx
    refine hasDerivAt_log_sub Complex.I ?_
    rw [Complex.mem_slitPlane_iff]
    right
    simp [Complex.sub_im]
  have hint : IntervalIntegrable (fun x : ℝ => ((x : ℂ) - Complex.I)⁻¹) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    apply Continuous.inv₀
    · fun_prop
    · intro x hx0
      have := congrArg Complex.im hx0
      simp [Complex.sub_im] at this
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  -- h : ∫ x in -1..1, (x − I)⁻¹ = log(1 − I) − log(−1 − I)
  rw [h]
  -- evaluate the logs
  have h1 : Complex.log ((1:ℂ) - Complex.I) = (Real.log (Real.sqrt 2) : ℂ) - (Real.pi/4 : ℂ) * Complex.I := by
    apply Complex.ext
    · simp [Complex.log_re, norm_one_sub_I_sq]
    · simp [Complex.log_im, arg_one_sub_I]
  have h2 : Complex.log ((-1:ℂ) - Complex.I) = (Real.log (Real.sqrt 2) : ℂ) - (3 * Real.pi/4 : ℂ) * Complex.I := by
    apply Complex.ext
    · simp [Complex.log_re, norm_neg_one_sub_I]
    · simp [Complex.log_im, arg_neg_one_sub_I]
  norm_num
  rw [h1, h2]
  ring



/-- The logarithm with the branch cut along the positive real axis:
`logShift z = log(−z) + iπ`. -/
noncomputable def logShift (z : ℂ) : ℂ := Complex.log (-z) + (Real.pi : ℂ) * Complex.I

/-- `logShift` has derivative `z⁻¹` where `−z` is in the slit plane. -/
theorem hasDerivAt_logShift {z : ℂ} (hz : -z ∈ Complex.slitPlane) :
    HasDerivAt logShift z⁻¹ z := by
  have hneg : HasDerivAt (fun w : ℂ => -w) (-1) z := by
    have h0 : HasDerivAt (fun _ : ℂ => (0:ℂ)) 0 z := hasDerivAt_const z 0
    have h1 : HasDerivAt (fun w : ℂ => w) 1 z := hasDerivAt_id z
    have := h0.sub h1
    convert this using 1
    · funext w
      simp
    · norm_num
  have hlog : HasDerivAt Complex.log ((-z)⁻¹) (-z) := Complex.hasDerivAt_log hz
  have hcomp := hlog.comp z hneg
  have hval : ((-z)⁻¹ * (-1)) = z⁻¹ := by field_simp
  rw [hval] at hcomp
  have hadd := hcomp.add_const ((Real.pi : ℂ) * Complex.I)
  convert hadd using 1
  funext x
  simp [logShift]

/-- `log (1 + i) = log √2 + iπ/4`. -/
theorem log_one_add_I :
    Complex.log ((1 : ℂ) + Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (Real.pi / 4 : ℂ) * Complex.I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_one_add_I_sq]
  · simp [Complex.log_im, arg_one_add_I]

/-- `log (1 − i) = log √2 − iπ/4`. -/
theorem log_one_sub_I :
    Complex.log ((1 : ℂ) - Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) - (Real.pi / 4 : ℂ) * Complex.I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_one_sub_I_sq]
  · simp [Complex.log_im, arg_one_sub_I]

/-- `log (−1 + i) = log √2 + 3iπ/4`. -/
theorem log_neg_one_add_I :
    Complex.log ((-1 : ℂ) + Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (3 * Real.pi / 4 : ℂ) * Complex.I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_neg_one_add_I]
  · simp [Complex.log_im, arg_neg_one_add_I]

/-- `log (−1 − i) = log √2 − 3iπ/4`. -/
theorem log_neg_one_sub_I :
    Complex.log ((-1 : ℂ) - Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) - (3 * Real.pi / 4 : ℂ) * Complex.I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_neg_one_sub_I]
  · simp [Complex.log_im, arg_neg_one_sub_I]

/-- `logShift (−1 + i) = log √2 + 3iπ/4`. -/
theorem logShift_neg_one_add_I :
    logShift ((-1 : ℂ) + Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (3 * Real.pi / 4 : ℂ) * Complex.I := by
  have hneg : -((-1 : ℂ) + Complex.I) = (1 : ℂ) - Complex.I := by ring
  simp only [logShift, hneg, log_one_sub_I]
  ring

/-- `logShift (−1 − i) = log √2 + 5iπ/4`. -/
theorem logShift_neg_one_sub_I :
    logShift ((-1 : ℂ) - Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (5 * Real.pi / 4 : ℂ) * Complex.I := by
  have hneg : -((-1 : ℂ) - Complex.I) = (1 : ℂ) + Complex.I := by ring
  simp only [logShift, hneg, log_one_add_I]
  ring

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- Chain rule for `t ↦ log (a + t·b)` over ℝ on the slit plane. -/
theorem hasDerivAt_log_affine (a b : ℂ) {x : ℝ}
    (hx : (a + (x : ℂ) * b) ∈ Complex.slitPlane) :
    HasDerivAt (fun t : ℝ => Complex.log (a + (t : ℂ) * b))
      (b * (a + (x : ℂ) * b)⁻¹) x := by
  have hlin : HasDerivAt (fun t : ℝ => a + (t : ℂ) * b) b x := by
    have h1 : HasDerivAt (fun t : ℝ => (t : ℂ)) 1 x := by
      simpa using (hasDerivAt_id x).ofReal_comp
    have h2 : HasDerivAt (fun t : ℝ => (t : ℂ) * b) (1 * b) x := h1.mul_const b
    have h3 : HasDerivAt (fun t : ℝ => a + (t : ℂ) * b) (1 * b) x := h2.const_add a
    simpa using h3
  have hlog := (Complex.hasDerivAt_log hx).hasFDerivAt
  have hlogℝ : HasFDerivAt Complex.log
      (ContinuousLinearMap.restrictScalars ℝ
        (ContinuousLinearMap.toSpanSingleton ℂ ((a + (x : ℂ) * b)⁻¹))) (a + (x : ℂ) * b) :=
    hlog.restrictScalars ℝ
  have hcomp := hlogℝ.comp_hasDerivAt x hlin
  have hval : (ContinuousLinearMap.restrictScalars ℝ
      (ContinuousLinearMap.toSpanSingleton ℂ ((a + (x : ℂ) * b)⁻¹))) b
      = b * (a + (x : ℂ) * b)⁻¹ := by
    simp [ContinuousLinearMap.toSpanSingleton_apply, mul_comm]
  rw [hval] at hcomp
  exact hcomp

theorem log_one_add_neg_I :
    Complex.log ((1 : ℂ) + -Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) - (Real.pi / 4 : ℂ) * Complex.I := by
  simpa [sub_eq_add_neg] using log_one_sub_I

theorem logShift_neg_one_add_neg_I :
    logShift ((-1 : ℂ) + -Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (5 * Real.pi / 4 : ℂ) * Complex.I := by
  simpa [sub_eq_add_neg] using logShift_neg_one_sub_I

/-- The top side of the unit square: `∫_{-1}^{1}(x+i)⁻¹dx = −iπ/2`. -/
theorem integral_top :
    ∫ x : ℝ in (-1)..1, (((x : ℂ) + Complex.I)⁻¹) = -(Real.pi / 2 : ℂ) * Complex.I := by
  have hderiv : ∀ x ∈ Set.uIcc (-1:ℝ) 1,
      HasDerivAt (fun t : ℝ => Complex.log ((t : ℂ) + Complex.I))
        (((x : ℂ) + Complex.I)⁻¹) x := by
    intro x hx
    have h := hasDerivAt_log_affine Complex.I 1 (x := x) (by
      rw [Complex.mem_slitPlane_iff]
      right
      simp [Complex.add_im])
    simpa [mul_one, add_comm] using h
  have hint : IntervalIntegrable (fun x : ℝ => ((x : ℂ) + Complex.I)⁻¹) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    apply Continuous.inv₀
    · fun_prop
    · intro x hx0
      have := congrArg Complex.im hx0
      simp [Complex.add_im] at this
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [h]
  have h1 : Complex.log ((1:ℂ) + Complex.I) = (Real.log (Real.sqrt 2) : ℂ) + (Real.pi/4 : ℂ) * Complex.I :=
    log_one_add_I
  have h2 : Complex.log ((-1:ℂ) + Complex.I) = (Real.log (Real.sqrt 2) : ℂ) + (3 * Real.pi/4 : ℂ) * Complex.I :=
    log_neg_one_add_I
  norm_num
  rw [h1, h2]
  ring_nf
  all_goals rw [pow_two, Complex.I_mul_I]
  all_goals ring

/-- The right side of the unit square: `∫_{-1}^{1}(1+iy)⁻¹dy = π/2`. -/
theorem integral_right :
    ∫ y : ℝ in (-1)..1, (((1:ℂ) + (y : ℂ) * Complex.I)⁻¹) = (Real.pi / 2 : ℂ) := by
  have hderiv : ∀ y ∈ Set.uIcc (-1:ℝ) 1,
      HasDerivAt (fun t : ℝ => -(Complex.I) * Complex.log ((1:ℂ) + (t : ℂ) * Complex.I))
        (((1:ℂ) + (y : ℂ) * Complex.I)⁻¹) y := by
    intro y hy
    have h := hasDerivAt_log_affine (1:ℂ) Complex.I (x := y) (by
      rw [Complex.mem_slitPlane_iff]
      left
      simp)
    have hmul := h.const_mul (-(Complex.I))
    have hval : (-(Complex.I)) * (Complex.I * ((1:ℂ) + (y : ℂ) * Complex.I)⁻¹)
        = ((1:ℂ) + (y : ℂ) * Complex.I)⁻¹ := by
      have hI : (-(Complex.I)) * Complex.I = 1 := by
        rw [neg_mul, Complex.I_mul_I]; ring
      rw [show (-(Complex.I)) * (Complex.I * ((1:ℂ) + (y : ℂ) * Complex.I)⁻¹)
          = ((-(Complex.I)) * Complex.I) * ((1:ℂ) + (y : ℂ) * Complex.I)⁻¹ by ring, hI, one_mul]
    rw [hval] at hmul
    simpa using hmul
  have hint : IntervalIntegrable (fun y : ℝ => ((1:ℂ) + (y : ℂ) * Complex.I)⁻¹) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    apply Continuous.inv₀
    · fun_prop
    · intro y hy0
      have := congrArg Complex.re hy0
      simp at this
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [h]
  have h1 : Complex.log ((1:ℂ) + Complex.I) = (Real.log (Real.sqrt 2) : ℂ) + (Real.pi/4 : ℂ) * Complex.I :=
    log_one_add_I
  have h2 : Complex.log ((1:ℂ) + -Complex.I) = (Real.log (Real.sqrt 2) : ℂ) - (Real.pi/4 : ℂ) * Complex.I :=
    log_one_add_neg_I
  norm_num
  rw [h1, h2]
  ring_nf
  all_goals rw [pow_two, Complex.I_mul_I]
  all_goals ring

/-- The left side of the unit square, via the shifted branch:
`∫_{-1}^{1}(−1+iy)⁻¹dy = −π/2`. -/
theorem integral_left :
    ∫ y : ℝ in (-1)..1, (((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹) = -(Real.pi / 2 : ℂ) := by
  have hderiv : ∀ y ∈ Set.uIcc (-1:ℝ) 1,
      HasDerivAt (fun t : ℝ => -(Complex.I) * logShift ((-1:ℂ) + (t : ℂ) * Complex.I))
        (((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹) y := by
    intro y hy
    have hshift : ((-1:ℂ) + (y : ℂ) * Complex.I) ≠ 0 := by
      intro h0
      have := congrArg Complex.re h0
      simp at this
    have hlog : HasDerivAt (fun t : ℝ => logShift ((-1:ℂ) + (t : ℂ) * Complex.I))
        (Complex.I * ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹) y := by
      have hlin : HasDerivAt (fun t : ℝ => ((-1:ℂ) + (t : ℂ) * Complex.I)) Complex.I y := by
        have h1 : HasDerivAt (fun t : ℝ => (t : ℂ)) 1 y := by
          simpa using (hasDerivAt_id y).ofReal_comp
        have h2 : HasDerivAt (fun t : ℝ => (t : ℂ) * Complex.I) (1 * Complex.I) y :=
          h1.mul_const Complex.I
        have h3 : HasDerivAt (fun t : ℝ => (-1:ℂ) + (t : ℂ) * Complex.I) (1 * Complex.I) y :=
          h2.const_add (-1:ℂ)
        simpa using h3
      have hneg : -((-1:ℂ) + (y : ℂ) * Complex.I) ∈ Complex.slitPlane := by
        rw [Complex.mem_slitPlane_iff]
        left
        simp
      have h := (hasDerivAt_logShift hneg).comp y hlin
      rw [show ((-1:ℂ) + (y:ℂ) * Complex.I)⁻¹ * Complex.I
          = Complex.I * ((-1:ℂ) + (y:ℂ) * Complex.I)⁻¹ by ring] at h
      exact h
    have hmul := hlog.const_mul (-(Complex.I))
    have hval : (-(Complex.I)) * (Complex.I * ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹)
        = ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹ := by
      have hI : (-(Complex.I)) * Complex.I = 1 := by
        rw [neg_mul, Complex.I_mul_I]; ring
      rw [show (-(Complex.I)) * (Complex.I * ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹)
          = ((-(Complex.I)) * Complex.I) * ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹ by ring, hI, one_mul]
    rw [hval] at hmul
    exact hmul
  have hint : IntervalIntegrable (fun y : ℝ => ((-1:ℂ) + (y : ℂ) * Complex.I)⁻¹) volume (-1) 1 := by
    apply Continuous.intervalIntegrable
    apply Continuous.inv₀
    · fun_prop
    · intro y hy0
      have := congrArg Complex.re hy0
      simp at this
  have h := intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint
  rw [h]
  have h1 : logShift ((-1:ℂ) + Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (3 * Real.pi/4 : ℂ) * Complex.I := logShift_neg_one_add_I
  have h2 : logShift ((-1:ℂ) + -Complex.I) =
      (Real.log (Real.sqrt 2) : ℂ) + (5 * Real.pi/4 : ℂ) * Complex.I := logShift_neg_one_add_neg_I
  norm_num
  rw [h1, h2]
  ring_nf
  all_goals rw [pow_two, Complex.I_mul_I]
  all_goals ring

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **The interior kernel integral for the unit square:**
`∮_{[−1,1]×[−1,1]} s⁻¹ ds = 2πi`. -/
theorem boundaryIntegral_inv_unit_square :
    boundaryIntegral (fun s : ℂ => s⁻¹) ((-1:ℂ) - Complex.I) ((1:ℂ) + Complex.I)
      = 2 * (Real.pi : ℂ) * Complex.I := by
  unfold boundaryIntegral
  simp only [Complex.sub_re, Complex.sub_im, Complex.add_re, Complex.add_im,
    Complex.ofReal_one, Complex.ofReal_neg, Complex.ofReal_zero, Complex.ofReal_re,
    Complex.ofReal_im, Complex.I_re, Complex.I_im, neg_mul, one_mul, zero_add, add_zero]
  norm_num
  have hbot : ∫ x : ℝ in (-1)..1, (((x : ℂ) + -Complex.I))⁻¹
      = (Real.pi / 2 : ℂ) * Complex.I := by
    simpa [sub_eq_add_neg] using integral_bottom
  have htop : ∫ x : ℝ in (-1)..1, (((x : ℂ) + Complex.I))⁻¹
      = -(Real.pi / 2 : ℂ) * Complex.I := integral_top
  have hright : ∫ y : ℝ in (-1)..1, (((1:ℂ) + (y : ℂ) * Complex.I))⁻¹
      = (Real.pi / 2 : ℂ) := integral_right
  have hleft : ∫ y : ℝ in (-1)..1, (((-1:ℂ) + (y : ℂ) * Complex.I))⁻¹
      = -(Real.pi / 2 : ℂ) := integral_left
  rw [hbot, htop, hright, hleft]
  ring_nf
  all_goals rw [pow_two, Complex.I_mul_I]
  all_goals ring



/-- **T85. The Taylor series of `ζ` about `ρ ≠ 1` converges to `ζ` near `ρ`.** -/
theorem zeta_taylor_eventually (ρ : ℂ) (hρ1 : ρ ≠ 1) :
    ∀ᶠ h : ℂ in 𝓝 0,
      riemannZeta (ρ + h) =
        ∑' n : ℕ, (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * h ^ n := by
  have hPS := (analyticAt_zeta hρ1).hasFPowerSeriesAt
  have h := hPS.eventually_hasSum_sub
  have ht : Tendsto (fun h : ℂ => ρ + h) (𝓝 0) (𝓝 ρ) := by
    have h1 : Tendsto (fun h : ℂ => ρ + h) (𝓝 0) (𝓝 (ρ + 0)) :=
      tendsto_const_nhds.add (tendsto_id : Tendsto (fun h : ℂ => h) (𝓝 0) (𝓝 0))
    simpa using h1
  have h' := ht.eventually h
  have hcoe : ∀ (n : ℕ) (v : ℂ),
      (FormalMultilinearSeries.ofScalars ℂ
        (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))) n
        (fun _ : Fin n => v)
        = (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * v ^ n := by
    intro n v
    rw [FormalMultilinearSeries.apply_eq_prod_smul_coeff,
      FormalMultilinearSeries.coeff_ofScalars]
    rw [Finset.prod_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul]
    ring
  filter_upwards [h'] with y hy
  simp only [add_sub_cancel_left] at hy
  have hy' : HasSum (fun n : ℕ =>
      (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * y ^ n)
      (riemannZeta (ρ + y)) := by
    convert hy using 1
    ext n
    exact (hcoe n y).symm
  rw [← hy'.tsum_eq]



/-- **T86. The second-order (Peano) decomposition of `ζ` at a zero:**
`ζ(ρ+h) = ζ′(ρ)·h + h²·Σ_n ζ^{(n+2)}(ρ)/(n+2)! · h^n` near `h = 0`. -/
theorem zeta_peano_second_order (ρ : ℂ) (hρ1 : ρ ≠ 1) (hζ : riemannZeta ρ = 0) :
    ∀ᶠ h : ℂ in 𝓝 0,
      riemannZeta (ρ + h) = deriv riemannZeta ρ * h +
        h ^ 2 * (∑' n : ℕ,
          (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n) := by
  have hPS := (analyticAt_zeta hρ1).hasFPowerSeriesAt
  have h := hPS.eventually_hasSum_sub
  have ht : Tendsto (fun h : ℂ => ρ + h) (𝓝 0) (𝓝 ρ) := by
    have h1 : Tendsto (fun h : ℂ => ρ + h) (𝓝 0) (𝓝 (ρ + 0)) :=
      tendsto_const_nhds.add (tendsto_id : Tendsto (fun h : ℂ => h) (𝓝 0) (𝓝 0))
    simpa using h1
  have h' := ht.eventually h
  have hcoe : ∀ (n : ℕ) (v : ℂ),
      (FormalMultilinearSeries.ofScalars ℂ
        (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))) n
        (fun _ : Fin n => v)
        = (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * v ^ n := by
    intro n v
    rw [FormalMultilinearSeries.apply_eq_prod_smul_coeff,
      FormalMultilinearSeries.coeff_ofScalars]
    rw [Finset.prod_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul]
    ring
  filter_upwards [h'] with y hy
  simp only [add_sub_cancel_left] at hy
  have hy' : HasSum (fun n : ℕ =>
      (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * y ^ n)
      (riemannZeta (ρ + y)) := by
    convert hy using 1
    ext n
    exact (hcoe n y).symm
  -- split off the first two terms
  have hsplit : HasSum (fun n : ℕ =>
      (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * y ^ (n + 2))
      (riemannZeta (ρ + y) - ∑ i ∈ Finset.range 2,
        (iteratedDeriv i riemannZeta ρ / (i.factorial : ℂ)) * y ^ i) :=
    (hasSum_nat_add_iff' 2).mpr hy'
  have hsum2 : ∑ i ∈ Finset.range 2,
      (iteratedDeriv i riemannZeta ρ / (i.factorial : ℂ)) * y ^ i
      = deriv riemannZeta ρ * y := by
    simp [Finset.sum_range_succ, iteratedDeriv_zero, iteratedDeriv_one, hζ]
  rw [hsum2] at hsplit
  -- factor `y^2`
  have hfac : (fun n : ℕ =>
      (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * y ^ (n + 2))
      = fun n : ℕ => y ^ 2 *
        ((iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * y ^ n) := by
    funext n
    rw [pow_add]
    set a := y ^ n
    set b := y ^ 2
    set d := (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ))
    show d * (a * b) = b * (d * a)
    ac_rfl
  rw [hfac] at hsplit
  have hval := hsplit.tsum_eq
  rw [tsum_mul_left] at hval
  rw [eq_comm] at hval
  rw [sub_eq_iff_eq_add] at hval
  rw [eq_comm]
  rw [hval]
  ring



/-- **T87. The tail of the Peano expansion:**
`Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n → ζ″(ρ)/2` as `h → 0`, given summability of the
majorant `‖ζ^{(n+2)}(ρ)/(n+2)!‖·s^n`. -/
theorem tendsto_tail_zeta (ρ : ℂ) {s : ℝ} (hs : 0 < s)
    (hsum : Summable (fun n : ℕ =>
      ‖iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)‖ * s ^ n)) :
    Tendsto (fun h : ℂ => ∑' n : ℕ,
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
      (𝓝 0) (𝓝 (iteratedDeriv 2 riemannZeta ρ / ((Nat.factorial 2) : ℂ))) := by
  have hmain := tendsto_tsum_of_dominated_convergence
    (𝓕 := 𝓝 (0 : ℂ))
    (f := fun (h : ℂ) (n : ℕ) =>
      (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
    (g := fun n : ℕ =>
      (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * (0 : ℂ) ^ n)
    (bound := fun n : ℕ =>
      ‖iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)‖ * s ^ n)
    hsum ?_ ?_
  · -- identify the limit
    have hval : ∑' n : ℕ,
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * (0 : ℂ) ^ n
        = iteratedDeriv 2 riemannZeta ρ / ((Nat.factorial 2) : ℂ) := by
      rw [tsum_eq_single 0]
      · simp
      · intro n hn
        rw [zero_pow hn, mul_zero]
    rwa [hval] at hmain
  · -- termwise continuity
    intro n
    have h : Tendsto (fun h : ℂ => h ^ n) (𝓝 0) (𝓝 ((0 : ℂ) ^ n)) :=
      (continuous_pow n).tendsto 0
    simpa using (tendsto_const_nhds.mul h :
      Tendsto (fun h : ℂ =>
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
        (𝓝 0) (𝓝 ((iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * (0:ℂ) ^ n)))
  · -- dominating bound near `0`
    filter_upwards [Metric.ball_mem_nhds (0 : ℂ) hs] with h hh
    rw [Metric.mem_ball, dist_zero_right] at hh
    intro n
    rw [norm_mul, norm_pow]
    exact mul_le_mul_of_nonneg_left
      (pow_le_pow_left₀ (norm_nonneg h) hh.le n) (norm_nonneg _)

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation



/-- **T88. `ζ′` has derivative `ζ″` away from `1`.** -/
theorem hasDerivAt_deriv_zeta {ρ : ℂ} (hρ1 : ρ ≠ 1) :
    HasDerivAt (deriv riemannZeta) (deriv (deriv riemannZeta) ρ) ρ :=
  (differentiableAt_deriv_zeta hρ1).hasDerivAt



/-- **T89. Summability of the tail majorant.** -/
theorem summable_tail_majorant (ρ : ℂ) (hρ1 : ρ ≠ 1) :
    ∃ s : ℝ, 0 < s ∧ Summable (fun n : ℕ =>
      ‖iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)‖ * s ^ n) := by
  obtain ⟨r, hr⟩ := (analyticAt_zeta hρ1).hasFPowerSeriesAt
  have hcoe : ∀ (n : ℕ) (v : ℂ),
      (FormalMultilinearSeries.ofScalars ℂ
        (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))) n
        (fun _ : Fin n => v)
        = (iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ)) * v ^ n := by
    intro n v
    rw [FormalMultilinearSeries.apply_eq_prod_smul_coeff,
      FormalMultilinearSeries.coeff_ofScalars]
    rw [Finset.prod_const, Finset.card_univ, Fintype.card_fin, smul_eq_mul]
    ring
  rcases eq_or_ne r ⊤ with htop | hfin
  · -- radius `⊤`: take `s = 1`
    have hrad : (FormalMultilinearSeries.ofScalars ℂ
        (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).radius = ⊤ :=
      le_antisymm le_top (htop ▸ hr.r_le)
    have hx : (1 : ℂ) ∈ Metric.eball (0 : ℂ)
        (FormalMultilinearSeries.ofScalars ℂ
          (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).radius := by
      rw [Metric.mem_eball, edist_dist, dist_eq_norm, sub_zero, hrad]
      simp
    have hsum := (FormalMultilinearSeries.ofScalars ℂ
      (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).summable_norm_apply hx
    have htail := (summable_nat_add_iff 2).mpr hsum
    refine ⟨1, one_pos, ?_⟩
    refine htail.congr (fun n => ?_)
    rw [hcoe (n + 2) (1 : ℂ)]
    simp
  · -- radius `↑r'`: take `s = r'/2`
    obtain ⟨r', hr'⟩ := WithTop.ne_top_iff_exists.mp hfin
    have hr'pos : (0 : NNReal) < r' := by
      have h : (0 : ENNReal) < (r' : ENNReal) := by
        have := hr.r_pos
        rwa [← hr'] at this
      exact ENNReal.coe_pos.mp h
    have hlt : ((r' / 2 : NNReal) : ENNReal) <
        (FormalMultilinearSeries.ofScalars ℂ
          (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).radius := by
      have h1 : ((r' / 2 : NNReal) : ENNReal) < ((r' : NNReal) : ENNReal) := by
        rw [ENNReal.coe_lt_coe]
        exact half_lt_self hr'pos
      calc ((r' / 2 : NNReal) : ENNReal) < ((r' : NNReal) : ENNReal) := h1
        _ = r := hr'
        _ ≤ _ := hr.r_le
    have hx : ((((r' / 2 : NNReal) : ℝ)) : ℂ) ∈ Metric.eball (0 : ℂ)
        (FormalMultilinearSeries.ofScalars ℂ
          (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).radius := by
      rw [Metric.mem_eball, edist_dist, dist_eq_norm, sub_zero]
      rw [show ENNReal.ofReal (‖((((r' / 2 : NNReal) : ℝ)) : ℂ)‖) = ((r' / 2 : NNReal) : ENNReal) by
        rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
        exact ENNReal.ofReal_coe_nnreal]
      exact hlt
    have hsum := (FormalMultilinearSeries.ofScalars ℂ
      (fun n => iteratedDeriv n riemannZeta ρ / (n.factorial : ℂ))).summable_norm_apply hx
    have htail := (summable_nat_add_iff 2).mpr hsum
    refine ⟨((r' : ℝ) / 2), by positivity, ?_⟩
    have hs : (((r' : ℝ) / 2)) ≠ 0 := by positivity
    refine (htail.mul_left ((((r' : ℝ) / 2) ^ 2))⁻¹).congr (fun n => ?_)
    rw [hcoe (n + 2) ((((r' / 2 : NNReal) : ℝ)) : ℂ)]
    rw [norm_mul, norm_pow, show ‖((((r' / 2 : NNReal) : ℝ)) : ℂ)‖ = ((r' : ℝ) / 2) by
      rw [Complex.norm_real, Real.norm_of_nonneg (by positivity)]
      norm_num]
    rw [pow_add]
    field_simp

/-- **T90. The unconditional tail limit:** `Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n → ζ″(ρ)/2`. -/
theorem tendsto_tail_zeta' (ρ : ℂ) (hρ1 : ρ ≠ 1) :
    Tendsto (fun h : ℂ => ∑' n : ℕ,
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
      (𝓝 0) (𝓝 (iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ))) := by
  obtain ⟨s, hs, hsum⟩ := summable_tail_majorant ρ hρ1
  exact tendsto_tail_zeta ρ hs hsum



/-- **T91. `ζ(ρ+h)/h → ζ′(ρ)` at a zero.** -/
theorem tendsto_zeta_div (ρ : ℂ) (hρ1 : ρ ≠ 1) (hζ : riemannZeta ρ = 0) :
    Tendsto (fun h : ℂ => riemannZeta (ρ + h) / h) (𝓝[≠] 0)
      (𝓝 (deriv riemannZeta ρ)) := by
  have htail := tendsto_tail_zeta' ρ hρ1
  have hpeano := zeta_peano_second_order ρ hρ1 hζ
  have heq : (fun h : ℂ => riemannZeta (ρ + h) / h) =ᶠ[𝓝[≠] 0]
      (fun h : ℂ => deriv riemannZeta ρ + h * (∑' n : ℕ,
            (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)) := by
    filter_upwards [Filter.Eventually.filter_mono nhdsWithin_le_nhds hpeano,
      self_mem_nhdsWithin]
      with h hpe hne
    have hne' : h ≠ 0 := by simpa using hne
    rw [hpe]
    field_simp
  refine Tendsto.congr' heq.symm ?_
  have hid : Tendsto (fun h : ℂ => h) (𝓝[≠] 0) (𝓝 0) :=
    Filter.Tendsto.mono_right
      (tendsto_id : Tendsto (fun h : ℂ => h) (𝓝[≠] 0) (𝓝[≠] 0))
      (nhdsWithin_le_nhds : 𝓝[≠] (0:ℂ) ≤ 𝓝 0)
  have hcont : Tendsto (fun h : ℂ => h * (∑' n : ℕ,
      (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n))
      (𝓝[≠] 0) (𝓝 (0 * (iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ)))) :=
    hid.mul (Filter.Tendsto.mono_left htail (nhdsWithin_le_nhds : 𝓝[≠] (0:ℂ) ≤ 𝓝 0))
  have hzero : (0 : ℂ) * (iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ)) = 0 :=
    zero_mul _
  rw [hzero] at hcont
  have := hcont.const_add (deriv riemannZeta ρ)
  simpa using this



/-- **T92 (algebra).** The quotient identity behind the O3c limit:
if `z = h·(a + h·R)` then `c/z − 1/h = ((c − a)/h − R)/(z/h)`. -/
theorem div_sub_one_div_eq (a c R : ℂ) {h z : ℂ} (hh : h ≠ 0)
    (hD : a + h * R ≠ 0) (hz : z = h * (a + h * R)) :
    c / z - 1 / h = ((c - a) / h - R) / (z / h) := by
  subst hz
  have hz0 : h * (a + h * R) ≠ 0 := mul_ne_zero hh hD
  have hzh : h * (a + h * R) / h ≠ 0 := div_ne_zero hz0 hh
  field_simp
  ring




/-- **T92. The finite O3c limit:** at a simple zero,
`ζ′/ζ − 1/(s−ρ) → ζ″(ρ)/(2ζ′(ρ))`. -/
theorem tendsto_logDeriv_sub (ρ : ℂ) (hρ1 : ρ ≠ 1) (hζ : riemannZeta ρ = 0)
    (hsimple : deriv riemannZeta ρ ≠ 0) :
    Tendsto (fun h : ℂ => deriv riemannZeta (ρ + h) / riemannZeta (ρ + h) - 1 / h)
      (𝓝[≠] 0) (𝓝 (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ))) := by
  have htail0 := tendsto_tail_zeta' ρ hρ1
  have htail : Tendsto (fun h : ℂ => ∑' n : ℕ,
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
      (𝓝[≠] 0) (𝓝 (iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ))) :=
    Filter.Tendsto.mono_left htail0 (nhdsWithin_le_nhds : 𝓝[≠] (0:ℂ) ≤ 𝓝 0)
  have hB := tendsto_zeta_div ρ hρ1 hζ
  have hd := hasDerivAt_deriv_zeta hρ1
  have hslopeρ : Tendsto (fun y : ℂ => (deriv riemannZeta y - deriv riemannZeta ρ) / (y - ρ))
      (𝓝[≠] ρ) (𝓝 (deriv (deriv riemannZeta) ρ)) := by
    have h := hd.tendsto_slope
    rw [show slope (deriv riemannZeta) ρ
        = fun y => (deriv riemannZeta y - deriv riemannZeta ρ) / (y - ρ) by
      funext y
      simp [slope, smul_eq_mul, div_eq_mul_inv, mul_comm]] at h
    exact h
  have hmap : Tendsto (fun h : ℂ => ρ + h) (𝓝[≠] 0) (𝓝[≠] ρ) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · exact Filter.Tendsto.mono_left (by
        have h1 : Tendsto (fun h : ℂ => ρ + h) (𝓝 0) (𝓝 ρ) := by
          simpa using (tendsto_const_nhds.add
            (tendsto_id : Tendsto (fun h : ℂ => h) (𝓝 0) (𝓝 0)))
        exact h1) nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with h hne
      have h0 : h ≠ 0 := by simpa using hne
      simpa using h0
  have hslope : Tendsto (fun h : ℂ => (deriv riemannZeta (ρ + h) - deriv riemannZeta ρ) / h)
      (𝓝[≠] 0) (𝓝 (deriv (deriv riemannZeta) ρ)) := by
    have h := hslopeρ.comp hmap
    convert h using 1
    funext y
    simp [Function.comp, add_sub_cancel_left]
  have hnum : Tendsto (fun h : ℂ => (deriv riemannZeta (ρ + h) - deriv riemannZeta ρ) / h
      - (∑' n : ℕ, (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n))
      (𝓝[≠] 0) (𝓝 (deriv (deriv riemannZeta) ρ
        - iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ))) := hslope.sub htail
  have hBne : ∀ᶠ h : ℂ in 𝓝[≠] 0, riemannZeta (ρ + h) ≠ 0 := by
    have h1 : ∀ᶠ h : ℂ in 𝓝[≠] 0, riemannZeta (ρ + h) / h ≠ 0 :=
      hB.eventually_ne hsimple
    filter_upwards [h1, self_mem_nhdsWithin] with h hne hzero
    intro hz
    exact hne (by rw [hz, zero_div])
  have heq : (fun h : ℂ => deriv riemannZeta (ρ + h) / riemannZeta (ρ + h) - 1 / h)
      =ᶠ[𝓝[≠] 0]
      (fun h : ℂ => ((deriv riemannZeta (ρ + h) - deriv riemannZeta ρ) / h
        - (∑' n : ℕ, (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n))
        / (riemannZeta (ρ + h) / h)) := by
    filter_upwards [Filter.Eventually.filter_mono nhdsWithin_le_nhds
      (zeta_peano_second_order ρ hρ1 hζ), self_mem_nhdsWithin, hBne] with h hpe hne hzne
    have hne' : h ≠ 0 := by simpa using hne
    have hD : deriv riemannZeta ρ + h * (∑' n : ℕ,
        (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n) ≠ 0 := by
      have hq : riemannZeta (ρ + h) / h ≠ 0 := div_ne_zero hzne hne'
      rw [hpe] at hq
      field_simp [hne'] at hq
      convert hq using 1 <;> ring
    exact div_sub_one_div_eq (deriv riemannZeta ρ) (deriv riemannZeta (ρ + h))
      (∑' n : ℕ, (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n)
      hne' hD (by rw [hpe]; ring)
  have hdiv := hnum.div hB (by simpa using hsimple)
  have hfin : Tendsto (fun h : ℂ => ((deriv riemannZeta (ρ + h) - deriv riemannZeta ρ) / h
        - (∑' n : ℕ, (iteratedDeriv (n + 2) riemannZeta ρ / ((n + 2).factorial : ℂ)) * h ^ n))
        / (riemannZeta (ρ + h) / h)) (𝓝[≠] 0)
      (𝓝 ((deriv (deriv riemannZeta) ρ - iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ))
        / deriv riemannZeta ρ)) := hdiv
  have hval : (deriv (deriv riemannZeta) ρ - iteratedDeriv 2 riemannZeta ρ / (Nat.factorial 2 : ℂ))
      / deriv riemannZeta ρ = deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ) := by
    rw [show iteratedDeriv 2 riemannZeta ρ = deriv (deriv riemannZeta) ρ by
      rw [show (2:ℕ) = 1 + 1 from rfl, iteratedDeriv_succ, iteratedDeriv_one]]
    rw [show (Nat.factorial 2 : ℂ) = 2 by norm_num]
    field_simp
    ring
  rw [← hval]
  exact Tendsto.congr' heq.symm hfin



/-- **T94. The subtracted integrand has the finite limit `H(ρ)·ζ″(ρ)/(2ζ′(ρ))`.** -/
theorem tendsto_subtracted_H (H : ℂ → ℂ) (ρ : ℂ) (hρ1 : ρ ≠ 1) (hζ : riemannZeta ρ = 0)
    (hsimple : deriv riemannZeta ρ ≠ 0) (hH : ContinuousAt H ρ) :
    Tendsto (fun s : ℂ => H s * logDeriv riemannZeta s - H s / (s - ρ))
      (𝓝[≠] ρ) (𝓝 (H ρ * (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ)))) := by
  have hmap : Tendsto (fun s : ℂ => s - ρ) (𝓝[≠] ρ) (𝓝[≠] 0) := by
    rw [tendsto_nhdsWithin_iff]
    constructor
    · exact Filter.Tendsto.mono_left (by
        have h1 : Tendsto (fun s : ℂ => s - ρ) (𝓝 ρ) (𝓝 (ρ - ρ)) :=
          tendsto_id.sub tendsto_const_nhds
        rw [sub_self] at h1
        exact h1) nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with s hs
      have hs' : s ≠ ρ := by simpa using hs
      simpa using sub_ne_zero.mpr hs'
  have hlim : Tendsto (fun s : ℂ => deriv riemannZeta s / riemannZeta s - 1 / (s - ρ))
      (𝓝[≠] ρ) (𝓝 (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ))) := by
    have h := (tendsto_logDeriv_sub ρ hρ1 hζ hsimple).comp hmap
    have hfun : ((fun h : ℂ => deriv riemannZeta (ρ + h) / riemannZeta (ρ + h) - 1 / h)
        ∘ fun s : ℂ => s - ρ)
        = fun s : ℂ => deriv riemannZeta s / riemannZeta s - 1 / (s - ρ) := by
      funext s
      simp only [Function.comp_apply]
      rw [show ρ + (s - ρ) = s by ring]
    rwa [hfun] at h
  have hHρ : Tendsto H (𝓝[≠] ρ) (𝓝 (H ρ)) :=
    Filter.Tendsto.mono_left hH nhdsWithin_le_nhds
  have hmul := hHρ.mul hlim
  have hfun : (fun s : ℂ => H s * logDeriv riemannZeta s - H s / (s - ρ))
      = fun s : ℂ => H s * (deriv riemannZeta s / riemannZeta s - 1 / (s - ρ)) := by
    funext s
    rw [logDeriv_apply]
    ring
  rw [hfun]
  exact hmul



/-- **T95. The preimage of a point under a circle map is countable.** -/
theorem circleMap_preimage_countable (ρ c : ℂ) {R : ℝ} (hR : R ≠ 0) :
    {θ : ℝ | circleMap c R θ = ρ}.Countable := by
  have hRc : (R : ℂ) ≠ 0 := Complex.ofReal_ne_zero.mpr hR
  have hsub : {θ : ℝ | circleMap c R θ = ρ}
      ⊆ Set.range (fun k : ℤ => (-Complex.I *
          (Complex.log ((ρ - c) / R) + k * (2 * (Real.pi : ℂ) * Complex.I))).re) := by
    intro θ hθ
    have h2 : (c : ℂ) + (R : ℂ) * Complex.exp ((θ : ℂ) * Complex.I) = ρ := hθ
    have h1 : Complex.exp ((θ : ℂ) * Complex.I) = (ρ - c) / R := by
      rw [eq_div_iff hRc]
      linear_combination h2
    rcases eq_or_ne ((ρ - c) / R) 0 with ha | ha
    · rw [ha] at h1
      exact absurd h1 (by simp [Complex.exp_ne_zero])
    · have hlog : Complex.exp (Complex.log ((ρ - c) / R)) = (ρ - c) / R :=
        Complex.exp_log ha
      have h3 : Complex.exp ((θ : ℂ) * Complex.I)
          = Complex.exp (Complex.log ((ρ - c) / R)) := by
        rw [h1, hlog]
      obtain ⟨k, hk⟩ := Complex.exp_eq_exp_iff_exists_int.mp h3
      refine ⟨k, ?_⟩
      have hI : (-Complex.I) * Complex.I = 1 := by
        rw [neg_mul, Complex.I_mul_I]; ring
      have h4 : ((θ : ℂ)) = -Complex.I *
          (Complex.log ((ρ - c) / R) + k * (2 * (Real.pi : ℂ) * Complex.I)) := by
        calc ((θ : ℂ)) = (θ : ℂ) * ((-Complex.I) * Complex.I) := by rw [hI, mul_one]
          _ = -Complex.I * ((θ : ℂ) * Complex.I) := by ring
          _ = -Complex.I *
              (Complex.log ((ρ - c) / R) + k * (2 * (Real.pi : ℂ) * Complex.I)) := by rw [hk]
      have := congrArg Complex.re h4
      simpa using this.symm
  exact Set.Countable.mono hsub (Set.countable_range _)

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **T96. Changing a function at a single point does not change its circle
integral.** -/
theorem circleIntegral_congr_off_singleton (g G : ℂ → ℂ) (ρ c : ℂ) (R : ℝ)
    (h : ∀ z, z ≠ ρ → g z = G z) :
    ∮ z in C(c, R), g z = ∮ z in C(c, R), G z := by
  rcases eq_or_ne R 0 with hR0 | hR
  · subst hR0
    simp only [circleIntegral]
    have hz : ∀ θ : ℝ, deriv (circleMap c 0) θ = 0 := by
      intro θ
      rw [deriv_circleMap]
      simp
    simp only [hz, zero_smul]
  · simp only [circleIntegral]
    apply intervalIntegral.integral_congr_ae
    have hcnt : {θ : ℝ | circleMap c R θ = ρ}.Countable := circleMap_preimage_countable ρ c hR
    have h0 : volume {θ : ℝ | circleMap c R θ = ρ} = 0 := hcnt.measure_zero volume
    filter_upwards [MeasureTheory.compl_mem_ae_iff.mpr h0] with θ hθ _
    have hne : circleMap c R θ ≠ ρ := by simpa using hθ
    rw [h (circleMap c R θ) hne]



/-- **T97. The limit of the `H(ρ)`-subtracted integrand at a simple zero:**
`H·ζ′/ζ − H(ρ)/(s−ρ) → H(ρ)·ζ″(ρ)/(2ζ′(ρ)) + H′(ρ)`. -/
theorem tendsto_subtracted_Hρ (H : ℂ → ℂ) (ρ : ℂ) (hρ1 : ρ ≠ 1) (hζ : riemannZeta ρ = 0)
    (hsimple : deriv riemannZeta ρ ≠ 0) (hH : HasDerivAt H (deriv H ρ) ρ) :
    Tendsto (fun s : ℂ => H s * logDeriv riemannZeta s - H ρ / (s - ρ))
      (𝓝[≠] ρ)
      (𝓝 (H ρ * (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ)) + deriv H ρ)) := by
  have hHc : ContinuousAt H ρ := hH.continuousAt
  have h1 := tendsto_subtracted_H H ρ hρ1 hζ hsimple hHc
  have h2 : Tendsto (fun s : ℂ => (H s - H ρ) / (s - ρ)) (𝓝[≠] ρ) (𝓝 (deriv H ρ)) := by
    have hslope : Tendsto (fun y : ℂ => (H y - H ρ) / (y - ρ)) (𝓝[≠] ρ) (𝓝 (deriv H ρ)) := by
      have h := hH.tendsto_slope
      rw [show slope H ρ = fun y => (H y - H ρ) / (y - ρ) by
        funext y
        simp [slope, smul_eq_mul, div_eq_mul_inv, mul_comm]] at h
      exact h
    exact hslope
  have hsum := h1.add h2
  refine hsum.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with s hs
  have hs' : s ≠ ρ := by simpa using hs
  field_simp
  ring



/-- **T98. The residue theorem at a simple zero, on the circle centred at the
zero:** `∮_{C(ρ,r)} H·ζ′/ζ = 2πi·H(ρ)`. -/
theorem circleIntegral_logDeriv_centred (H : ℂ → ℂ) (ρ : ℂ) (r : ℝ) (hr : 0 < r)
    (hζ : riemannZeta ρ = 0) (hρ1 : ρ ≠ 1) (hsimple : deriv riemannZeta ρ ≠ 0)
    (hHc : ContinuousAt H ρ)
    (hHdiff : ∀ z ∈ Metric.closedBall ρ r, z ≠ ρ → DifferentiableAt ℂ H z)
    (hnot1 : ∀ z ∈ Metric.closedBall ρ r, z ≠ 1)
    (hnoother : ∀ z ∈ Metric.closedBall ρ r, riemannZeta z = 0 → z = ρ) :
    ∮ z in C(ρ, r), H z * logDeriv riemannZeta z = 2 * (Real.pi : ℂ) * Complex.I * H ρ := by
  set f : ℂ → ℂ := fun z => (z - ρ) * (H z * logDeriv riemannZeta z) with hf
  have hmem : ρ ∈ Metric.closedBall ρ r := by
    rw [Metric.mem_closedBall]
    simp [hr.le]
  have hy : Tendsto f (𝓝[{ρ}ᶜ] ρ) (𝓝 (H ρ)) :=
    tendsto_residue_mul H ρ hζ hρ1 hsimple hHc
  have hf_diff : ∀ z ∈ Metric.closedBall ρ r, z ≠ ρ → DifferentiableAt ℂ f z := by
    intro z hz hzρ
    have h1 : DifferentiableAt ℂ (fun w : ℂ => w - ρ) z := differentiableAt_id.sub_const ρ
    have h2 : DifferentiableAt ℂ H z := hHdiff z hz hzρ
    have hz0 : riemannZeta z ≠ 0 := fun h => hzρ (hnoother z hz h)
    have h3 : DifferentiableAt ℂ (logDeriv riemannZeta) z :=
      differentiableAt_logDeriv_zeta (hnot1 z hz) hz0
    exact h1.mul (h2.mul h3)
  have hc : ContinuousOn f (Metric.closedBall ρ r \ {ρ}) := fun z hz =>
    ((hf_diff z hz.1 (by simpa using hz.2)).continuousAt).continuousWithinAt
  have hd : ∀ z ∈ (Metric.ball ρ r \ {ρ}) \ (∅ : Set ℂ), DifferentiableAt ℂ f z := by
    intro z hz
    exact hf_diff z (Metric.ball_subset_closedBall hz.1.1) hz.1.2
  have hmain := Complex.circleIntegral_sub_center_inv_smul_of_differentiable_on_off_countable_of_tendsto
    hr (s := (∅ : Set ℂ)) Set.countable_empty hc hd hy
  have hfun : ∀ z : ℂ, (z - ρ)⁻¹ • f z = H z * logDeriv riemannZeta z := by
    intro z
    by_cases hz : z = ρ
    · subst hz
      have hlog : logDeriv riemannZeta z = 0 := by
        rw [logDeriv_apply, hζ, div_zero]
      rw [hlog]
      simp [hf]
    · have hz' : z - ρ ≠ 0 := sub_ne_zero.mpr hz
      simp only [hf, smul_eq_mul]
      field_simp [hz']
  simp only [hfun, smul_eq_mul] at hmain
  exact hmain



/-- **T99. Changing a function on a finite set does not change its circle
integral.** -/
theorem circleIntegral_congr_off_finset (g G : ℂ → ℂ) (c : ℂ) (R : ℝ) (F : Finset ℂ)
    (h : ∀ z, z ∉ F → g z = G z) :
    ∮ z in C(c, R), g z = ∮ z in C(c, R), G z := by
  rcases eq_or_ne R 0 with hR0 | hR
  · subst hR0
    simp only [circleIntegral]
    have hz : ∀ θ : ℝ, deriv (circleMap c 0) θ = 0 := by
      intro θ
      rw [deriv_circleMap]
      simp
    simp only [hz, zero_smul]
  · simp only [circleIntegral]
    apply intervalIntegral.integral_congr_ae
    have hcnt : {θ : ℝ | circleMap c R θ ∈ (F : Set ℂ)}.Countable := by
      have : {θ : ℝ | circleMap c R θ ∈ (F : Set ℂ)}
          ⊆ ⋃ ρ ∈ (F : Set ℂ), {θ : ℝ | circleMap c R θ = ρ} := by
        intro θ hθ
        exact Set.mem_iUnion₂.mpr ⟨circleMap c R θ, hθ, rfl⟩
      refine Set.Countable.mono this ?_
      exact Set.Countable.biUnion (F.finite_toSet.countable)
        (fun ρ _ => circleMap_preimage_countable ρ c hR)
    have h0 : volume {θ : ℝ | circleMap c R θ ∈ (F : Set ℂ)} = 0 := hcnt.measure_zero volume
    filter_upwards [MeasureTheory.compl_mem_ae_iff.mpr h0] with θ hθ _
    have hne : circleMap c R θ ∉ (F : Set ℂ) := by simpa using hθ
    rw [h (circleMap c R θ) hne]



/-- **T100. The limit of the finitely-subtracted integrand at a zero.** -/
theorem tendsto_subtracted_finset (H : ℂ → ℂ) (F : Finset ℂ) (ρ : ℂ) (hρ : ρ ∈ F)
    (hζ : riemannZeta ρ = 0) (hρ1 : ρ ≠ 1) (hsimple : deriv riemannZeta ρ ≠ 0)
    (hH : HasDerivAt H (deriv H ρ) ρ) :
    Tendsto (fun z : ℂ => H z * logDeriv riemannZeta z - ∑ ρ' ∈ F, H ρ' / (z - ρ'))
      (𝓝[≠] ρ)
      (𝓝 (H ρ * (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ)) + deriv H ρ
        - ∑ ρ' ∈ F.erase ρ, H ρ' / (ρ - ρ'))) := by
  have hsplit : ∀ z : ℂ, (∑ ρ' ∈ F, H ρ' / (z - ρ'))
      = H ρ / (z - ρ) + ∑ ρ' ∈ F.erase ρ, H ρ' / (z - ρ') := by
    intro z
    rw [← Finset.add_sum_erase F (fun ρ' => H ρ' / (z - ρ')) hρ]
  have h1 : Tendsto (fun z : ℂ => H z * logDeriv riemannZeta z - H ρ / (z - ρ))
      (𝓝[≠] ρ)
      (𝓝 (H ρ * (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ)) + deriv H ρ)) :=
    tendsto_subtracted_Hρ H ρ hρ1 hζ hsimple hH
  have h2 : Tendsto (fun z : ℂ => ∑ ρ' ∈ F.erase ρ, H ρ' / (z - ρ')) (𝓝[≠] ρ)
      (𝓝 (∑ ρ' ∈ F.erase ρ, H ρ' / (ρ - ρ'))) := by
    apply tendsto_finset_sum
    intro ρ' hρ'
    have hne : ρ' ≠ ρ := Finset.ne_of_mem_erase hρ'
    have hcont : ContinuousAt (fun z : ℂ => H ρ' / (z - ρ')) ρ := by
      apply ContinuousAt.div continuous_const.continuousAt
      · exact (continuous_id.sub continuous_const).continuousAt
      · exact sub_ne_zero.mpr hne.symm
    exact hcont.mono_left nhdsWithin_le_nhds
  have hsub := h1.sub h2
  refine hsub.congr' ?_
  filter_upwards [self_mem_nhdsWithin] with z hz
  rw [hsplit z]
  ring



/-- **T101. The residue theorem for a finite set of zeros, applied to the
*extended* integrand** (whose values on `F` are the limits). -/
theorem circleIntegral_residue_sum_ext (H f : ℂ → ℂ) (F : Finset ℂ) (c : ℂ) (R : ℝ)
    (G : ℂ → ℂ)
    (hR : 0 ≤ R) (hF : ∀ ρ ∈ F, ‖ρ - c‖ < R)
    (hG : ∀ z, z ∉ F → G z = H z * logDeriv f z - ∑ ρ ∈ F, H ρ / (z - ρ))
    (hcont : ContinuousOn G (Metric.closedBall c R))
    (hdiff : ∀ z ∈ Metric.ball c R \ (F : Set ℂ), DifferentiableAt ℂ G z) :
    ∮ z in C(c, R), H z * logDeriv f z = 2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ F, H ρ) := by
  set g : ℂ → ℂ := fun z => H z * logDeriv f z - ∑ ρ ∈ F, H ρ / (z - ρ) with hg
  have hG0 : ∮ z in C(c, R), G z = 0 :=
    Complex.circleIntegral_eq_zero_of_differentiable_on_off_countable hR
      F.finite_toSet.countable hcont hdiff
  have hg0 : ∮ z in C(c, R), g z = 0 := by
    rw [circleIntegral_congr_off_finset g G c R F (fun z hz => by
      rw [hg]
      exact (hG z hz).symm)]
    exact hG0
  have hsingle_cont : ∀ ρ : ℂ, ‖ρ - c‖ < R →
      ContinuousOn (fun z : ℂ => H ρ / (z - ρ)) (Metric.sphere c R) := by
    intro ρ hρ
    refine ContinuousOn.div continuousOn_const (by fun_prop) ?_
    intro z hz
    have hmem : ‖z - c‖ = R := by simpa [Metric.mem_sphere] using hz
    intro hzρ
    have hzρ' : z = ρ := sub_eq_zero.mp hzρ
    rw [hzρ'] at hmem
    linarith
  have hterm : ∀ ρ ∈ F, ContinuousOn (fun z : ℂ => H ρ / (z - ρ)) (Metric.sphere c R) :=
    fun ρ hρ => hsingle_cont ρ (hF ρ hρ)
  have hsum_cont : ContinuousOn (fun z : ℂ => ∑ ρ ∈ F, H ρ / (z - ρ)) (Metric.sphere c R) :=
    continuousOn_finsetSum F hterm
  have hzF : ∀ z ∈ Metric.sphere c R, z ∉ F := by
    intro z hz hzF
    have hlt : ‖z - c‖ < R := hF z hzF
    have heq : ‖z - c‖ = R := by simpa [Metric.mem_sphere] using hz
    linarith
  have hg_cont : ContinuousOn g (Metric.sphere c R) :=
    (hcont.mono Metric.sphere_subset_closedBall).congr
      (fun z hz => (hG z (hzF z hz)).symm)
  have hEq : Set.EqOn (fun z => H z * logDeriv f z)
      (fun z => g z + ∑ ρ ∈ F, H ρ / (z - ρ)) (Metric.sphere c R) := by
    intro z hz
    simp only [hg]
    abel
  rw [circleIntegral.integral_congr hR hEq,
    circleIntegral.integral_add (ContinuousOn.circleIntegrable hR hg_cont)
      (ContinuousOn.circleIntegrable hR hsum_cont), hg0, zero_add]
  have hkey : ∀ (G' : Finset ℂ), (∀ ρ ∈ G', ‖ρ - c‖ < R) →
      ∮ z in C(c, R), (∑ ρ ∈ G', H ρ / (z - ρ)) =
        2 * (Real.pi : ℂ) * Complex.I * (∑ ρ ∈ G', H ρ) := by
    intro G'
    induction G' using Finset.induction with
    | empty =>
        intro _
        simp [circleIntegral]
    | insert a s ha ih =>
        intro hG'
        have haR : ‖a - c‖ < R := hG' a (Finset.mem_insert_self a s)
        have hsR : ∀ ρ ∈ s, ‖ρ - c‖ < R := fun ρ hρ => hG' ρ (Finset.mem_insert_of_mem hρ)
        have ha_cont : ContinuousOn (fun z : ℂ => H a / (z - a)) (Metric.sphere c R) :=
          hsingle_cont a haR
        have hs_cont : ContinuousOn (fun z : ℂ => ∑ ρ ∈ s, H ρ / (z - ρ))
            (Metric.sphere c R) :=
          continuousOn_finsetSum s (fun ρ hρ => hsingle_cont ρ (hsR ρ hρ))
        have hsingle : ∮ z in C(c, R), H a / (z - a) =
            2 * (Real.pi : ℂ) * Complex.I * H a := by
          have hconst : (fun z : ℂ => H a / (z - a)) = fun z => H a * (z - a)⁻¹ := by
            funext z; rw [div_eq_mul_inv]
          rw [hconst, circleIntegral.integral_const_mul]
          rw [circleIntegral_inv_sub a c R hR haR]
          ring
        simp only [Finset.sum_insert ha]
        rw [circleIntegral.integral_add (ContinuousOn.circleIntegrable hR ha_cont)
          (ContinuousOn.circleIntegrable hR hs_cont), hsingle, ih hsR]
        ring
  exact hkey F hF



/-- **T102. Continuity of the piecewise-extended integrand at the update point.** -/
theorem continuousWithinAt_update (g L : ℂ → ℂ) (ρ : ℂ) {s : Set ℂ}
    (htend : Tendsto g (𝓝[≠] ρ) (𝓝 (L ρ))) :
    ContinuousWithinAt (fun z => if z = ρ then L z else g z) s ρ := by
  have hnhds : (pure ρ : Filter ℂ) = 𝓝[({ρ} : Set ℂ)] ρ := (nhdsWithin_singleton ρ).symm
  have hsup : 𝓝 ρ = 𝓝[≠] ρ ⊔ pure ρ := by
    rw [hnhds, ← nhdsWithin_union, Set.compl_union_self, nhdsWithin_univ]
  have h1 : Tendsto (fun z => if z = ρ then L z else g z) (𝓝 ρ) (𝓝 (L ρ)) := by
    rw [hsup, tendsto_sup]
    constructor
    · refine htend.congr' ?_
      filter_upwards [self_mem_nhdsWithin] with z hz
      rw [if_neg]
      simpa using hz
    · simpa using tendsto_pure_nhds (fun z => if z = ρ then L z else g z) ρ
  have h2 : ContinuousAt (fun z => if z = ρ then L z else g z) ρ := by
    simpa only [ContinuousAt, if_pos rfl, if_true] using h1
  exact h2.continuousWithinAt



/-- **T103. Continuity of a finite sum of simple poles off the poles.** -/
theorem continuousAt_finset_sum_pole (F : Finset ℂ) (H : ℂ → ℂ) {z : ℂ} (hz : z ∉ F) :
    ContinuousAt (fun w : ℂ => ∑ ρ ∈ F, H ρ / (w - ρ)) z := by
  induction F using Finset.induction_on with
  | empty => simpa using continuous_const.continuousAt (x := z)
  | insert a s ha ih =>
      have hstep : (fun w : ℂ => ∑ ρ ∈ insert a s, H ρ / (w - ρ))
          = fun w => H a / (w - a) + ∑ ρ ∈ s, H ρ / (w - ρ) := by
        funext w
        rw [Finset.sum_insert ha]
      rw [hstep]
      have hzs : z ∉ s := fun h => hz (Finset.mem_insert_of_mem h)
      have hza : z ≠ a := fun h => hz (h ▸ Finset.mem_insert_self a s)
      have h1 : ContinuousAt (fun w : ℂ => H a / (w - a)) z :=
        ContinuousAt.div continuousAt_const
          (continuousAt_id.sub continuousAt_const) (sub_ne_zero.mpr hza)
      exact h1.add (ih hzs)

/-- **T104. Differentiability of a finite sum of simple poles off the poles.** -/
theorem differentiableAt_finset_sum_pole (F : Finset ℂ) (H : ℂ → ℂ) {z : ℂ} (hz : z ∉ F) :
    DifferentiableAt ℂ (fun w : ℂ => ∑ ρ ∈ F, H ρ / (w - ρ)) z := by
  induction F using Finset.induction_on with
  | empty => simpa using differentiableAt_const (0 : ℂ)
  | insert a s ha ih =>
      have hstep : (fun w : ℂ => ∑ ρ ∈ insert a s, H ρ / (w - ρ))
          = fun w => H a / (w - a) + ∑ ρ ∈ s, H ρ / (w - ρ) := by
        funext w
        rw [Finset.sum_insert ha]
      rw [hstep]
      have hzs : z ∉ s := fun h => hz (Finset.mem_insert_of_mem h)
      have hza : z ≠ a := fun h => hz (h ▸ Finset.mem_insert_self a s)
      have h1 : DifferentiableAt ℂ (fun w : ℂ => H a / (w - a)) z :=
        DifferentiableAt.div (differentiableAt_const (c := H a) (x := z))
          (differentiableAt_id.sub_const a) (sub_ne_zero.mpr hza)
      exact h1.add (ih hzs)

end ZetaFunctionalEquation

namespace ZetaFunctionalEquation

/-- **T105. The multi-zero residue theorem: the explicit formula in the circle
topology.**  For a finite set `F` containing every zero of `ζ` in the closed disc
(and no other singularity), `∮_{C(c,R)} H·ζ′/ζ = 2πi Σ_{ρ∈F} H(ρ)`. -/
theorem circleIntegral_logDeriv_zeros (H : ℂ → ℂ) (F : Finset ℂ) (c : ℂ) (R : ℝ)
    (hR : 0 ≤ R)
    (hF : ∀ ρ ∈ F, ‖ρ - c‖ < R)
    (hsimple : ∀ ρ ∈ F, riemannZeta ρ = 0 ∧ ρ ≠ 1 ∧ deriv riemannZeta ρ ≠ 0)
    (hnoother : ∀ z ∈ Metric.closedBall c R, riemannZeta z = 0 → z ∈ F)
    (hnot1 : ∀ z ∈ Metric.closedBall c R, z ≠ 1)
    (hHdiff : ∀ z ∈ Metric.closedBall c R, DifferentiableAt ℂ H z) :
    ∮ z in C(c, R), H z * logDeriv riemannZeta z
      = 2 * (Real.pi : ℂ) * Complex.I * ∑ ρ ∈ F, H ρ := by
  classical
  set g : ℂ → ℂ := fun z => H z * logDeriv riemannZeta z - ∑ ρ ∈ F, H ρ / (z - ρ) with hg
  set L : ℂ → ℂ := fun ρ => H ρ * (deriv (deriv riemannZeta) ρ / (2 * deriv riemannZeta ρ))
    + deriv H ρ - ∑ ρ' ∈ F.erase ρ, H ρ' / (ρ - ρ') with hL
  set G : ℂ → ℂ := fun z => if z ∈ F then L z else g z with hG
  have hGeq : ∀ z, z ∉ F → G z = H z * logDeriv riemannZeta z - ∑ ρ ∈ F, H ρ / (z - ρ) := by
    intro z hz
    simp only [hG, if_neg hz, hg]
  have hcont : ContinuousOn G (Metric.closedBall c R) := by
    intro z hz
    by_cases hzF : z ∈ F
    · have hz0 : riemannZeta z = 0 := (hsimple z hzF).1
      have hz1 : z ≠ 1 := (hsimple z hzF).2.1
      have hzs : deriv riemannZeta z ≠ 0 := (hsimple z hzF).2.2
      have htend : Tendsto g (𝓝[≠] z) (𝓝 (L z)) := by
        have h := tendsto_subtracted_finset H F z hzF hz0 hz1 hzs ((hHdiff z hz).hasDerivAt)
        simpa [hL, hg] using h
      have hcz := continuousWithinAt_update g L z (s := Metric.closedBall c R) htend
      have hfin : (((F.erase z : Finset ℂ) : Set ℂ)).Finite := (F.erase z).finite_toSet
      have hnh : (((F.erase z : Finset ℂ) : Set ℂ))ᶜ ∈ 𝓝 z :=
        hfin.isClosed.isOpen_compl.mem_nhds (by simp)
      have hev : (fun w => if w = z then L w else g w) =ᶠ[𝓝[Metric.closedBall c R] z] G := by
        filter_upwards [nhdsWithin_le_nhds hnh] with w hw
        by_cases hwz : w = z
        · subst hwz
          simp only [hG, if_pos hzF, ite_true]
        · have hwE : w ∈ (↑(F.erase z) : Set ℂ)ᶜ := hw
          have hwF : w ∉ F := fun h => hwE (Finset.mem_erase.mpr ⟨hwz, h⟩)
          simp only [hG, if_neg hwz, if_neg hwF]
      exact hcz.congr_of_eventuallyEq hev.symm (by simp [hG, hzF])
    · have hnh : (((F : Finset ℂ) : Set ℂ))ᶜ ∈ 𝓝 z :=
        F.finite_toSet.isClosed.isOpen_compl.mem_nhds (by simpa using hzF)
      have hev : G =ᶠ[𝓝 z] g := by
        filter_upwards [hnh] with w hw
        have hw' : w ∉ F := by simpa using hw
        simp only [hG, if_neg hw']
      have hz0 : riemannZeta z ≠ 0 := fun h0 => hzF (hnoother z hz h0)
      have h1 : ContinuousAt (fun z => H z * logDeriv riemannZeta z) z :=
        ((hHdiff z hz).continuousAt).mul
          (differentiableAt_logDeriv_zeta (hnot1 z hz) hz0).continuousAt
      have h2 : ContinuousAt (fun w => ∑ ρ ∈ F, H ρ / (w - ρ)) z :=
        continuousAt_finset_sum_pole F H hzF
      have h3 : ContinuousAt g z := h1.sub h2
      exact ContinuousAt.continuousWithinAt (h3.congr hev.symm)
  have hdiff : ∀ z ∈ Metric.ball c R \ (F : Set ℂ), DifferentiableAt ℂ G z := by
    intro z hz
    have hzF : z ∉ F := hz.2
    have hzb : z ∈ Metric.closedBall c R := Metric.ball_subset_closedBall hz.1
    have hnh : (((F : Finset ℂ) : Set ℂ))ᶜ ∈ 𝓝 z :=
      F.finite_toSet.isClosed.isOpen_compl.mem_nhds (by simpa using hzF)
    have hev : G =ᶠ[𝓝 z] g := by
      filter_upwards [hnh] with w hw
      have hw' : w ∉ F := by simpa using hw
      simp only [hG, if_neg hw']
    have hz0 : riemannZeta z ≠ 0 := fun h0 => hzF (hnoother z hzb h0)
    have h1 : DifferentiableAt ℂ (fun z => H z * logDeriv riemannZeta z) z :=
      (hHdiff z hzb).mul (differentiableAt_logDeriv_zeta (hnot1 z hzb) hz0)
    have h2 : DifferentiableAt ℂ (fun w => ∑ ρ ∈ F, H ρ / (w - ρ)) z :=
      differentiableAt_finset_sum_pole F H hzF
    have h3 : DifferentiableAt ℂ g z := h1.sub h2
    exact h3.congr_of_eventuallyEq hev
  exact circleIntegral_residue_sum_ext H riemannZeta F c R G hR hF hGeq hcont hdiff

end ZetaFunctionalEquation
