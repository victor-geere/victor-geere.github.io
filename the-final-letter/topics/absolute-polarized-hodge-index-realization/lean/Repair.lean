import ExplicitFormula

/-!
# Pole-corrected product for the explicit formula

Mathlib's entire `completedRiemannZeta₀` satisfies

`completedRiemannZeta s = completedRiemannZeta₀ s - 1/s - 1/(1-s)`.

Hence the pole-free product is

`Fext s = s (s-1) Λ₀(s) + 1`,

which equals `s (s-1) completedZeta s` away from `0,1`, and has the correct
finite values `1` at both poles.  This replaces the raw product in the contour
remainder so that the `hF_ne` hypothesis is satisfiable at `0` and `1`.
-/

noncomputable section

namespace AbsoluteHodgeExplicitFormula

open Filter Topology AbsoluteHodgeRectangle AbsoluteHodgeSymbol

/-- The pole-corrected entire product `Fext(s) = s(s−1)Λ₀(s) + 1`. -/
noncomputable def Fext (s : ℂ) : ℂ :=
  s * (s - 1) * completedRiemannZeta₀ s + 1

@[simp] theorem Fext_zero : Fext 0 = 1 := by
  simp [Fext]

@[simp] theorem Fext_one : Fext 1 = 1 := by
  simp [Fext]

theorem differentiable_Fext : Differentiable ℂ Fext := by
  unfold Fext
  exact ((differentiable_id.mul (differentiable_id.sub_const 1)).mul
    differentiable_completedZeta₀).add_const 1

/-- Away from `0,1` (and Gamma poles), the corrected product is the old
`s(s−1)Z(s)`. -/
theorem Fext_apply_ne {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : s.Gammaℝ ≠ 0) :
    Fext s = s * (s - 1) * completedZeta s := by
  have hZ : completedZeta s = completedRiemannZeta s :=
    completedZeta_eq_completedRiemannZeta h0 h1 hΓ
  have hR : completedRiemannZeta s =
      completedRiemannZeta₀ s - 1 / s - 1 / (1 - s) :=
    completedRiemannZeta_eq s
  unfold Fext
  rw [hZ, hR]
  field_simp [h0, h1]
  ring

/-- The corrected logarithmic derivative differs from `Z'/Z` by the two simple
poles. -/
theorem logDeriv_Fext_eq {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1)
    (hΓ : ∀ᶠ x : ℂ in 𝓝 s, x.Gammaℝ ≠ 0) (hZne : completedZeta s ≠ 0)
    (hZ : DifferentiableAt ℂ completedZeta s) :
    logDeriv Fext s = s⁻¹ + (s - 1)⁻¹ + logDeriv completedZeta s := by
  have hev : Fext =ᶠ[𝓝 s] (fun x : ℂ => x * (x - 1) * completedZeta x) := by
    filter_upwards [hΓ, isOpen_compl_singleton.mem_nhds h0,
      isOpen_compl_singleton.mem_nhds h1] with x hΓx hx0 hx1
    exact Fext_apply_ne hx0 hx1 hΓx
  rw [(logDeriv_congr_nhds hev).eq_of_nhds]
  have hfun : (fun x : ℂ => x * (x - 1) * completedZeta x)
      = (fun x : ℂ => x) * (fun x : ℂ => x - 1) * completedZeta := rfl
  rw [hfun]
  rw [logDeriv_mul (𝕜 := ℂ) (f := (fun x : ℂ => x) * (fun x : ℂ => x - 1))
    (g := completedZeta) s (mul_ne_zero h0 (sub_ne_zero.mpr h1)) hZne
      (differentiableAt_id.mul (differentiableAt_id.sub_const 1)) hZ]
  · rw [logDeriv_mul (𝕜 := ℂ) (f := fun x : ℂ => x) (g := fun x : ℂ => x - 1) s h0
      (sub_ne_zero.mpr h1) differentiableAt_id (differentiableAt_id.sub_const 1)]
    have hid : logDeriv (fun x : ℂ => x) s = s⁻¹ := by
      simpa [one_div] using logDeriv_id s
    have hsub : logDeriv (fun x : ℂ => x - 1) s = (s - 1)⁻¹ :=
      logDeriv_sub_const 1 s h1
    rw [hid, hsub]

/-- **Corrected global-remainder differentiability.**  With `Fext` in place of
the raw product, the remainder
`h·Fext'/Fext - ∑ hρ/(s-ρ) - dslope h 0 - dslope h 1`
is differentiable on `U \ S`, including at `0` and `1`. -/
theorem differentiableOn_globalRemainder_repair {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (hU : IsOpen U) (hh : DifferentiableOn ℂ h U)
    (hF_ne : ∀ z ∈ U, z ∉ S → Fext z ≠ 0) :
    DifferentiableOn ℂ (fun z : ℂ =>
        h z * logDeriv Fext z
          - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z) (U \ ↑S) := by
  intro z hz
  have hzU : z ∈ U := hz.1
  have hz_notS : z ∉ S := by simpa using hz.2
  have h_an : AnalyticAt ℂ h z := (hh.analyticOnNhd hU) z hzU
  have hF_an : AnalyticAt ℂ Fext z := differentiable_Fext.analyticAt z
  have hFz_ne : Fext z ≠ 0 := hF_ne z hzU hz_notS
  have hlog : DifferentiableAt ℂ (logDeriv Fext) z :=
    differentiableAt_logDeriv_of_analyticAt hF_an hFz_ne
  have hsum_fun : DifferentiableAt ℂ (∑ ρ ∈ S, fun z : ℂ => h ρ * (z - ρ)⁻¹) z := by
    apply DifferentiableAt.sum
    intro ρ hρ
    exact ((differentiableAt_id.sub_const ρ).inv
      (sub_ne_zero.mpr (by
        intro h
        simp only [id_eq] at h
        exact hz_notS (h ▸ hρ)))).const_mul (h ρ)
  have hsum : DifferentiableAt ℂ (fun z : ℂ => ∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) z := by
    convert hsum_fun using 1
    funext z
    simp [Finset.sum_apply]
  have hd0 := differentiableAt_dslope_of_analyticAt (a := 0) h_an
  have hd1 := differentiableAt_dslope_of_analyticAt (a := 1) h_an
  have hmain : DifferentiableAt ℂ (fun z : ℂ =>
      h z * logDeriv Fext z
        - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z) z := by
    convert (((h_an.differentiableAt.mul hlog).sub hsum).sub hd0).sub hd1 using 1
  exact hmain.differentiableWithinAt

/-- **Corrected analytic global remainder.** -/
theorem exists_analyticOnNhd_globalRemainder_repair {U : Set ℂ} (h : ℂ → ℂ)
    (S : Finset ℂ) (hU : IsOpen U) (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (hh : DifferentiableOn ℂ h U)
    (hF_zero : ∀ ρ ∈ S, Fext ρ = 0)
    (hF_simple : ∀ ρ ∈ S, deriv Fext ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → Fext z ≠ 0) :
    ∃ Ψ : ℂ → ℂ, AnalyticOnNhd ℂ Ψ U ∧ ∀ z ∈ U, z ∉ S →
      Ψ z = h z * logDeriv Fext z
        - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z := by
  classical
  have hdiff := differentiableOn_globalRemainder_repair h S hU hh hF_ne
  have hgerm : ∀ ρ ∈ S, ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ ρ ∧
      ψ =ᶠ[𝓝[≠] ρ] (fun z : ℂ =>
        h z * logDeriv Fext z
          - (∑ ρ' ∈ S, h ρ' * (z - ρ')⁻¹) - dslope h 0 z - dslope h 1 z) := by
    intro ρ hρ
    have hρU : ρ ∈ U := hSU ρ hρ
    have h_an : AnalyticAt ℂ h ρ := (hh.analyticOnNhd hU) ρ hρU
    have hF_an : AnalyticAt ℂ Fext ρ := differentiable_Fext.analyticAt ρ
    have hF_zero' : Fext ρ = 0 := hF_zero ρ hρ
    have hF_simple' : deriv Fext ρ ≠ 0 := hF_simple ρ hρ
    obtain ⟨ψ, hψ_an, hψ_eq⟩ :=
      exists_analyticAt_logDeriv_mul_sub_residue hF_an hF_zero' hF_simple' h_an
    refine ⟨fun z : ℂ => ψ z - (∑ ρ' ∈ S.erase ρ, h ρ' * (z - ρ')⁻¹)
      - dslope h 0 z - dslope h 1 z, ?_, ?_⟩
    · refine ((hψ_an.sub ?_).sub (analyticAt_dslope_of_analyticAt (a := 0) h_an)).sub
        (analyticAt_dslope_of_analyticAt (a := 1) h_an)
      apply analyticAt_finset_sum
      intro ρ' hρ'
      obtain ⟨hρ'ne, hρ'S⟩ := Finset.mem_erase.mp hρ'
      have hinv : AnalyticAt ℂ (fun x : ℂ => (x - ρ')⁻¹) ρ :=
        (analyticAt_id.sub analyticAt_const).inv (sub_ne_zero.mpr (Ne.symm hρ'ne))
      have hconst : AnalyticAt ℂ (fun _ : ℂ => h ρ') ρ := analyticAt_const
      have hmul : AnalyticAt ℂ (fun x : ℂ => h ρ' * (x - ρ')⁻¹) ρ := hconst.mul hinv
      simpa [Pi.mul_apply] using hmul
    · filter_upwards [hψ_eq] with z hz
      have hsum_split : (∑ ρ' ∈ S, h ρ' * (z - ρ')⁻¹)
          = h ρ * (z - ρ)⁻¹ + ∑ ρ' ∈ S.erase ρ, h ρ' * (z - ρ')⁻¹ := by
        rw [← Finset.insert_erase hρ, Finset.sum_insert (Finset.notMem_erase ρ S),
          Finset.erase_insert (Finset.notMem_erase ρ S)]
      rw [hz, hsum_split]
      ring
  exact exists_analyticOnNhd_of_differentiableOn_compl_finset hU S hSU hdiff hgerm

/-- **Corrected boundary decomposition.**  Away from `0,1` and the finite zero
set, `h·Z'/Z` is the analytic remainder plus the residue fractions, with the
correct `h0/z`, `h1/(z−1)` pole terms. -/
theorem logDeriv_mul_eq_remainder_plus_residues_repair {h : ℂ → ℂ} {S : Finset ℂ} {z : ℂ}
    (hz0 : z ≠ 0) (hz1 : z ≠ 1) (hzS : z ∉ S)
    (hΓ : ∀ᶠ x : ℂ in 𝓝 z, x.Gammaℝ ≠ 0) (hZdiff : DifferentiableAt ℂ completedZeta z)
    (hZne : completedZeta z ≠ 0) :
    logDeriv completedZeta z * h z
      = (h z * logDeriv Fext z
          - (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - dslope h 0 z - dslope h 1 z)
        + (∑ ρ ∈ S, h ρ * (z - ρ)⁻¹) - h 0 * z⁻¹ - h 1 * (z - 1)⁻¹ := by
  have hlog : logDeriv completedZeta z
      = logDeriv Fext z - z⁻¹ - (z - 1)⁻¹ := by
    have h := logDeriv_Fext_eq hz0 hz1 hΓ hZne hZdiff
    linear_combination -h
  have hdec0 : h z = h 0 + z * dslope h 0 z := by
    have hsub := sub_smul_dslope h 0 z
    simp only [smul_eq_mul, sub_zero] at hsub
    rw [show z * dslope h 0 z = h z - h 0 from hsub]
    ring
  have hdec1 : h z = h 1 + (z - 1) * dslope h 1 z := by
    have hsub := sub_smul_dslope h 1 z
    simp only [smul_eq_mul] at hsub
    rw [show (z - 1) * dslope h 1 z = h z - h 1 from hsub]
    ring
  have e0 : h z * z⁻¹ = h 0 * z⁻¹ + dslope h 0 z := by
    rw [hdec0, add_mul]
    congr 1
    field_simp [hz0]
  have e1 : h z * (z - 1)⁻¹ = h 1 * (z - 1)⁻¹ + dslope h 1 z := by
    rw [hdec1, add_mul]
    congr 1
    field_simp [sub_ne_zero.mpr hz1]
  rw [hlog]
  linear_combination -e0 - e1

/-- **Corrected test-function explicit formula.**  Same contour formula, but
with the pole-corrected `Fext`, so the zero-side hypotheses are satisfiable at
`0` and `1`. -/
theorem test_function_explicit_formula_repair {U : Set ℂ} (h : ℂ → ℂ) (S : Finset ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc x₁ x₂) (Set.uIcc y₁ y₂) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U)
    (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hF_zero : ∀ ρ ∈ S, Fext ρ = 0)
    (hF_simple : ∀ ρ ∈ S, deriv Fext ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → Fext z ≠ 0)
    (h0_in : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1_in : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ ρ ∈ S, x₁ < ρ.re ∧ ρ.re < x₂ ∧ y₁ < ρ.im ∧ ρ.im < y₂) :
    rectIntegral (fun z => logDeriv completedZeta z * h z) x₁ x₂ y₁ y₂
      = ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * Complex.I) := by
  classical
  obtain ⟨Ψ, hΨ_an, hΨ_eq⟩ :=
    exists_analyticOnNhd_globalRemainder_repair h S hU hSU hh hF_zero hF_simple hF_ne
  let S' : Finset ℂ := insert 0 (insert 1 S)
  let c : ℂ → ℂ := fun w => if w = 0 then -h 0 else if w = 1 then -h 1 else h w
  have hS'_in : ∀ w ∈ S', x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂ := by
    intro w hw
    simp only [S', Finset.mem_insert] at hw
    rcases hw with rfl | rfl | hw
    · exact h0_in
    · exact h1_in
    · exact hS_in w hw
  have hΨ_cont : ContinuousOn Ψ (rectBoundarySet x₁ x₂ y₁ y₂) :=
    hΨ_an.continuousOn.mono (fun z hz => hsub hz.1)
  have hfr_cont : ∀ w ∈ S', ContinuousOn (fun z : ℂ => c w * (z - w)⁻¹)
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    intro w hw
    apply ContinuousOn.const_mul
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz h
      have hzw : z = w := sub_eq_zero.mp h
      rw [hzw] at hz
      rcases hz.2 with h' | h' | h' | h'
      · linarith [(hS'_in w hw).1, h']
      · linarith [(hS'_in w hw).2.1, h']
      · linarith [(hS'_in w hw).2.2.1, h']
      · linarith [(hS'_in w hw).2.2.2, h']
  have hΨ_int : rectIntegral Ψ x₁ x₂ y₁ y₂ = 0 :=
    rectIntegral_eq_zero_of_differentiableOn Ψ x₁ x₂ y₁ y₂
      (hΨ_an.continuousOn.mono hsub)
      (hΨ_an.differentiableOn.mono (fun z hz =>
        hsub ⟨Set.Ioo_subset_Icc_self hz.1, Set.Ioo_subset_Icc_self hz.2⟩))
  have hsum_eq : ∀ z : ℂ, (∑ w ∈ S', c w * (z - w)⁻¹)
      = (-h 0) * z⁻¹ + (-h 1) * (z - 1)⁻¹ + ∑ ρ ∈ S, h ρ * (z - ρ)⁻¹ := by
    intro z
    have hc0 : c 0 = -h 0 := by simp [c]
    have hc1 : c 1 = -h 1 := by simp [c]
    have hcS : ∀ ρ ∈ S, c ρ = h ρ := by
      intro ρ hρ
      simp only [c]
      rw [if_neg (by intro h; exact h0_notS (h ▸ hρ)),
        if_neg (by intro h; exact h1_notS (h ▸ hρ))]
    have hsum_c : (∑ x ∈ S, c x * (z - x)⁻¹) = ∑ x ∈ S, h x * (z - x)⁻¹ := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [hcS x hx]
    rw [show S' = insert 0 (insert 1 S) from rfl]
    rw [Finset.sum_insert (by simp [h0_notS]), Finset.sum_insert (by simp [h1_notS]),
      hc0, hc1, hsum_c]
    simp only [sub_zero]
    ring
  have hdecomp : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv completedZeta z * h z = Ψ z + ∑ w ∈ S', c w * (z - w)⁻¹ := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hzS : z ∉ S := by
      intro hzS
      obtain ⟨h1', h2', h3', h4'⟩ := hS_in z hzS
      rcases hz.2 with h' | h' | h' | h'
      · linarith
      · linarith
      · linarith
      · linarith
    have hz0 : z ≠ 0 := by
      intro h
      rcases hz.2 with h' | h' | h' | h'
      · have : (0 : ℂ).re = x₁ := by rw [← h]; exact h'
        simp at this; linarith [h0_in.1]
      · have : (0 : ℂ).re = x₂ := by rw [← h]; exact h'
        simp at this; linarith [h0_in.2.1]
      · have : (0 : ℂ).im = y₁ := by rw [← h]; exact h'
        simp at this; linarith [h0_in.2.2.1]
      · have : (0 : ℂ).im = y₂ := by rw [← h]; exact h'
        simp at this; linarith [h0_in.2.2.2]
    have hz1 : z ≠ 1 := by
      intro h
      rcases hz.2 with h' | h' | h' | h'
      · have : (1 : ℂ).re = x₁ := by rw [← h]; exact h'
        simp at this; linarith [h1_in.1]
      · have : (1 : ℂ).re = x₂ := by rw [← h]; exact h'
        simp at this; linarith [h1_in.2.1]
      · have : (1 : ℂ).im = y₁ := by rw [← h]; exact h'
        simp at this; linarith [h1_in.2.2.1]
      · have : (1 : ℂ).im = y₂ := by rw [← h]; exact h'
        simp at this; linarith [h1_in.2.2.2]
    have hZ_at : DifferentiableAt ℂ completedZeta z := by
      have hclosed : IsClosed ({0, 1} : Set ℂ) :=
        (Set.finite_singleton 0 |>.union (Set.finite_singleton 1)).isClosed
      exact (hZ.differentiableAt ((hU.sdiff hclosed).mem_nhds ⟨hzU, by simp [hz0, hz1]⟩))
    have hZ_ne : completedZeta z ≠ 0 := by
      intro hzero
      apply hF_ne z hzU hzS
      rw [Fext_apply_ne hz0 hz1 (hΓ z hzU), hzero]
      ring
    have hΓev : ∀ᶠ x : ℂ in 𝓝 z, x.Gammaℝ ≠ 0 :=
      Filter.eventually_of_mem (hU.mem_nhds hzU) (fun x hxU => hΓ x hxU)
    have hbase := logDeriv_mul_eq_remainder_plus_residues_repair (h := h) (S := S)
      hz0 hz1 hzS hΓev hZ_at hZ_ne
    rw [← hΨ_eq z hzU hzS] at hbase
    rw [hbase, hsum_eq z]
    ring
  have hmain := rectIntegral_logDeriv_mul_eq_residue_sum (Z := completedZeta) (h := h)
    S' c x₁ x₂ y₁ y₂ hS'_in hΨ_cont hfr_cont hdecomp hΨ_int
  rw [hmain]
  have hc_sum : (∑ w ∈ S', c w) = -h 0 - h 1 + ∑ ρ ∈ S, h ρ := by
    have hc0 : c 0 = -h 0 := by simp [c]
    have hc1 : c 1 = -h 1 := by simp [c]
    have hcS : ∀ ρ ∈ S, c ρ = h ρ := by
      intro ρ hρ
      simp only [c]
      rw [if_neg (by intro h; exact h0_notS (h ▸ hρ)),
        if_neg (by intro h; exact h1_notS (h ▸ hρ))]
    have hsum_c : (∑ x ∈ S, c x) = ∑ x ∈ S, h x := by
      apply Finset.sum_congr rfl
      intro x hx
      rw [hcS x hx]
    rw [show S' = insert 0 (insert 1 S) from rfl]
    rw [Finset.sum_insert (by simp [h0_notS]), Finset.sum_insert (by simp [h1_notS]),
      hc0, hc1, hsum_c]
    ring
  rw [hc_sum]
  ring

/-- Corrected symmetric contour-shift wrapper. -/
theorem contour_shift_symmetric_repair (h : ℂ → ℂ) (S : Finset ℂ) (T : ℝ) (hT : 0 < T)
    {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hh : DifferentiableOn ℂ h U)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hF_zero : ∀ ρ ∈ S, Fext ρ = 0)
    (hF_simple : ∀ ρ ∈ S, deriv Fext ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → Fext z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hleft : Complex.I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * Complex.I) * h (((-1 : ℝ) : ℂ) + y * Complex.I))
      = - Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * h ((2 : ℝ) + y * Complex.I)))
    (hbottom : (∫ x : ℝ in (-1)..2,
        logDeriv completedZeta ((x : ℂ) + (-T : ℝ) * Complex.I) * h ((x : ℂ) + (-T : ℝ) * Complex.I))
      = (starRingEnd ℂ) (∫ x : ℝ in (-1)..2,
          logDeriv completedZeta ((x : ℂ) + (T : ℝ) * Complex.I) * h ((x : ℂ) + (T : ℝ) * Complex.I))) :
    ((∑ ρ ∈ S, h ρ) - h 0 - h 1) * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * h ((2 : ℝ) + y * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℝ) * Complex.I) * h ((x : ℂ) + (T : ℝ) * Complex.I)).im : ℝ) : ℂ)) := by
  have hzero := test_function_explicit_formula_repair (h := h) S (-1) 2 (-T) T hU hsub hSU
    h0_notS h1_notS hh hΓ hZ hF_zero hF_simple hF_ne
    ⟨by norm_num, by norm_num, by linarith, hT⟩
    ⟨by norm_num, by norm_num, by linarith, hT⟩ hS_in
  rw [rectIntegral] at hzero
  rw [hbottom, hleft] at hzero
  rw [conj_sub_self_eq] at hzero
  linear_combination -hzero

/-- Corrected Paley–Wiener contour shift. -/
theorem contour_shift_paleyWiener_repair (g : ℝ → ℂ) (hg : Continuous g)
    (hge : ∀ u : ℝ, g (-u) = g u)
    (hgr : ∀ u : ℝ, (starRingEnd ℂ) (g u) = g u)
    (S : Finset ℂ) (T : ℝ) (hT : 0 < T) {U : Set ℂ} (hU : IsOpen U)
    (hsub : Complex.reProdIm (Set.uIcc (-1 : ℝ) 2) (Set.uIcc (-T) T) ⊆ U)
    (hSU : ∀ ρ ∈ S, ρ ∈ U) (h0_notS : (0 : ℂ) ∉ S) (h1_notS : (1 : ℂ) ∉ S)
    (hΓ : ∀ z ∈ U, z.Gammaℝ ≠ 0)
    (hZ : DifferentiableOn ℂ completedZeta (U \ {0, 1}))
    (hF_zero : ∀ ρ ∈ S, Fext ρ = 0)
    (hF_simple : ∀ ρ ∈ S, deriv Fext ρ ≠ 0)
    (hF_ne : ∀ z ∈ U, z ∉ S → Fext z ≠ 0)
    (hS_in : ∀ ρ ∈ S, -1 < ρ.re ∧ ρ.re < 2 ∧ -T < ρ.im ∧ ρ.im < T)
    (hint : IntervalIntegrable
      (fun x : ℝ => logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
        * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)) MeasureTheory.volume (-1) 2) :
    ((∑ ρ ∈ S, paleyWiener g ρ) - paleyWiener g 0 - paleyWiener g 1)
        * (2 * (Real.pi : ℂ) * Complex.I)
      = 2 * Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℂ) + (y : ℂ) * Complex.I)
            * paleyWiener g ((2 : ℂ) + (y : ℂ) * Complex.I))
        - 2 * Complex.I * ((((∫ x : ℝ in (-1)..2,
              logDeriv completedZeta ((x : ℂ) + (T : ℂ) * Complex.I)
                * paleyWiener g ((x : ℂ) + (T : ℂ) * Complex.I)).im : ℝ) : ℂ)) := by
  have hleft : Complex.I * (∫ y : ℝ in (-T)..T,
      logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * Complex.I) * paleyWiener g (((-1 : ℝ) : ℂ) + y * Complex.I))
      = - Complex.I * (∫ y : ℝ in (-T)..T,
          logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * paleyWiener g ((2 : ℝ) + y * Complex.I)) := by
    have h1 : Complex.I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * Complex.I) * paleyWiener g (((-1 : ℝ) : ℂ) + y * Complex.I))
        = ∫ y : ℝ in (-T)..T,
            (logDeriv completedZeta (((-1 : ℝ) : ℂ) + y * Complex.I) * paleyWiener g (((-1 : ℝ) : ℂ) + y * Complex.I)) * Complex.I := by
      rw [mul_comm Complex.I, intervalIntegral.integral_mul_const]
    have h2 : Complex.I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * paleyWiener g ((2 : ℝ) + y * Complex.I))
        = ∫ y : ℝ in (-T)..T,
            (logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * paleyWiener g ((2 : ℝ) + y * Complex.I)) * Complex.I := by
      rw [mul_comm Complex.I, intervalIntegral.integral_mul_const]
    have hneg : - Complex.I * (∫ y : ℝ in (-T)..T,
        logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * paleyWiener g ((2 : ℝ) + y * Complex.I))
        = - (Complex.I * (∫ y : ℝ in (-T)..T,
            logDeriv completedZeta ((2 : ℝ) + y * Complex.I) * paleyWiener g ((2 : ℝ) + y * Complex.I))) := by ring
    rw [h1, hneg, h2]
    simpa using integral_logDeriv_mul_left_eq_neg_right_two (paleyWiener g) T (fun w _ _ => paleyWiener_one_sub g hge w)
  have hbottom := integral_horizontal_bottom_eq_conj_top_two (paleyWiener g) T hT (fun s => (paleyWiener_one_sub g hge ((starRingEnd ℂ) s)).symm.trans (paleyWiener_conj g hg hgr s).symm) hint
  exact contour_shift_symmetric_repair (paleyWiener g) S T hT hU hsub hSU h0_notS h1_notS
    (differentiableOn_paleyWiener g hg U) hΓ hZ hF_zero hF_simple hF_ne hS_in hleft hbottom

end AbsoluteHodgeExplicitFormula
