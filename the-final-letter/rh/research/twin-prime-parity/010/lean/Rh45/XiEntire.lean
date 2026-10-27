/-
  Rh45/XiEntire.lean — the concrete ingredients for instantiating Route B at `ξ`,
  and the instantiation itself.

  `Rh45/RouteBGeneral.lean` proves Route B in the abstract: for an analytic `f` whose
  zeros on the rectangle `[0,1] × [t₀,t₁]` are exactly `Z` with orders `m`, and which
  satisfies `f(1 − s) = f(s)`, `f(conj s) = conj (f s)`,

      (rightPath (logDeriv f) t₀ t₁).im = π · ∑_{z∈Z} m z.

  Two concrete facts about the Riemann `ξ` function were missing from Mathlib and are
  supplied here, so that the abstract theorem can actually be applied to `ξ`:

  * the conjugation symmetry of Mathlib's completed zeta function
    `completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s)`
    (together with the archimedean factor `Gammaℝ_conj`), which is the `f(conj s) =
    conj (f s)` input — Mathlib has `riemannZeta_conj` and `Gamma_conj` but nothing for
    `completedRiemannZeta₀`, which is defined through the Hurwitz zeta and not as
    `Gammaℝ · riemannZeta`;

  * the entire normalisation `xi₀ s = ½ s(s−1) Λ₀(s) + ½` of the paper's
    `xi s = ½ s(s−1) Λ(s)`, with `xi s = xi₀ s` away from `s = 0, 1` (where both
    definitions give the removable singularity the same value), its symmetry
    `xi₀(1 − s) = xi₀ s`, its reality `xi₀(conj s) = conj (xi₀ s)`, its entireness, and
    `logDeriv xi = logDeriv xi₀` away from `s = 0, 1`.

  `xi_routeB_general` is then Route B at `ξ`: the zero count on `[0,1] × [t₀,t₁]`
  equals `Im(I₃)/π`.
-/
import Rh45.RouteBGeneral

open MeasureTheory intervalIntegral
open scoped Topology
open scoped ComplexConjugate
open Complex Filter

namespace Rh45RouteBAnalytic

noncomputable section

/-! ## Conjugation symmetry of the completed zeta function -/

/-- **Conjugation symmetry of the archimedean factor.**
`Gammaℝ (conj s) = conj (Gammaℝ s)`; `Gammaℝ s = π^{−s/2} Γ(s/2)` and both factors
commute with conjugation (`cpow_conj` for the real base `π`, `Gamma_conj` for `Γ`). -/
theorem Gammaℝ_conj (s : ℂ) : Gammaℝ (conj s) = conj (Gammaℝ s) := by
  have harg : ((Real.pi : ℂ)).arg ≠ Real.pi := by
    rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
    exact Real.pi_ne_zero.symm
  calc Gammaℝ (conj s)
      = (Real.pi : ℂ) ^ (-(conj s) / 2) * Complex.Gamma (conj s / 2) := Gammaℝ_def _
    _ = conj ((Real.pi : ℂ) ^ (-s / 2)) * conj (Complex.Gamma (s / 2)) := by
          rw [show -(conj s) / 2 = conj (-s / 2) by
                rw [map_div₀, map_neg, map_ofNat],
              show conj s / 2 = conj (s / 2) by
                rw [map_div₀, map_ofNat],
              Complex.cpow_conj _ _ harg, Complex.conj_ofReal, Complex.Gamma_conj]
    _ = conj ((Real.pi : ℂ) ^ (-s / 2) * Complex.Gamma (s / 2)) := by rw [map_mul]
    _ = conj (Gammaℝ s) := by rw [Gammaℝ_def]

/-- `Λ₀(s) = ζ(s) · Gammaℝ(s) + 1/s + 1/(1−s)` away from `s = 0` and the poles of
`Gammaℝ`; the product form of `riemannZeta_def_of_ne_zero` and `completedRiemannZeta_eq`. -/
private theorem completedRiemannZeta₀_eq_zeta_mul {s : ℂ} (hs : s ≠ 0) (hD : Gammaℝ s ≠ 0) :
    completedRiemannZeta₀ s = riemannZeta s * Gammaℝ s + 1 / s + 1 / (1 - s) := by
  have h := riemannZeta_eq_completedRiemannZeta₀ hs
  rw [Gammaℝ_def] at hD ⊢
  rw [eq_div_iff hD] at h
  rw [h]
  ring

/-- `Gammaℝ s ≠ 0` for `1 < re s` (where `Gammaℝ s = π^{−s/2} Γ(s/2)`). -/
private theorem Gammaℝ_ne_zero_of_re_gt_one {s : ℂ} (hs : 1 < s.re) : Gammaℝ s ≠ 0 := by
  rw [Gammaℝ_def]
  refine mul_ne_zero ?_ ?_
  · rw [Complex.cpow_ne_zero_iff]
    exact Or.inl (Complex.ofReal_ne_zero.mpr Real.pi_ne_zero)
  · refine Complex.Gamma_ne_zero_of_re_pos ?_
    rw [Complex.div_ofNat_re]
    linarith only [hs]

/-- **Reality on the right half-plane.**  For `1 < re s` the identity
`Λ₀(s) = ζ(s) Gammaℝ(s) + 1/s + 1/(1−s)` is available on both `s` and `conj s`, and
`riemannZeta_conj`, `Gammaℝ_conj` give `Λ₀(conj s) = conj (Λ₀ s)`. -/
private theorem completedRiemannZeta₀_conj_of_re_gt_one {s : ℂ} (hs : 1 < s.re) :
    completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) := by
  have hs0 : s ≠ 0 := by
    intro h
    rw [h] at hs
    exact absurd hs (by norm_num)
  have hcs0 : conj s ≠ 0 := fun h => hs0 (by simpa using congrArg conj h)
  have hD : Gammaℝ s ≠ 0 := Gammaℝ_ne_zero_of_re_gt_one hs
  have hDc : Gammaℝ (conj s) ≠ 0 := by
    rw [Gammaℝ_conj]
    exact fun h => hD (by simpa using congrArg conj h)
  have h1 := completedRiemannZeta₀_eq_zeta_mul hs0 hD
  have h2 := completedRiemannZeta₀_eq_zeta_mul hcs0 hDc
  have h1c := congrArg conj h1
  simp only [map_add, map_mul, map_div₀, map_one, map_sub] at h1c
  rw [h2, riemannZeta_conj, Gammaℝ_conj]
  exact h1c.symm

/-- **Reality of the completed zeta function.**  `Λ₀(conj s) = conj (Λ₀ s)` for all `s`.

The identity is proved on the open half-plane `1 < re s` (where `Λ₀ = ζ · Gammaℝ + 1/s +
1/(1−s)` is valid with a nonzero archimedean factor) and propagated to all of `ℂ` with the
identity principle: `Λ₀` and the holomorphic reflection `conj ∘ Λ₀ ∘ conj` are entire and
coincide in a whole neighbourhood of the point `2`. -/
theorem completedRiemannZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ (conj s) = conj (completedRiemannZeta₀ s) := by
  have hF : Differentiable ℂ (fun z : ℂ => conj (completedRiemannZeta₀ (conj z))) := by
    intro z
    exact differentiableAt_conj_conj_iff.mpr differentiable_completedZeta₀.differentiableAt
  have heq : (fun z : ℂ => completedRiemannZeta₀ z)
      = (fun z : ℂ => conj (completedRiemannZeta₀ (conj z))) := by
    refine AnalyticOnNhd.eq_of_eventuallyEq (z₀ := 2)
      (differentiable_completedZeta₀.differentiableOn.analyticOnNhd isOpen_univ)
      (hF.differentiableOn.analyticOnNhd isOpen_univ) ?_
    refine eventuallyEq_of_mem
      ((isOpen_lt continuous_const continuous_re).mem_nhds (by simp : (1 : ℝ) < (2 : ℂ).re)) ?_
    intro z hz
    have h' : conj (completedRiemannZeta₀ (conj z)) = completedRiemannZeta₀ z := by
      simpa using congrArg conj (completedRiemannZeta₀_conj_of_re_gt_one hz)
    exact h'.symm
  have hfin := congrFun heq s
  have : conj (completedRiemannZeta₀ s) = completedRiemannZeta₀ (conj s) := by
    have := congrArg conj hfin
    simpa using this
  exact this.symm

/-! ## The entire normalisation of `ξ` -/

/-- The **entire** normalisation of the Riemann `ξ` function,
`xi₀ s = ½ s(s−1) Λ₀(s) + ½`, where `Λ₀ = completedRiemannZeta₀`.  Away from `s = 0, 1`
this agrees with the paper's `xi s = ½ s(s−1) Λ(s)` (`xi_eq_xi₀`); at `s = 0, 1` the
correction term `½` supplies the removable-singularity values, so `xi₀` is entire
(`differentiable_xi₀`). -/
def xi₀ (s : ℂ) : ℂ := (1 / 2) * (s * (s - 1)) * completedRiemannZeta₀ s + 1 / 2

/-- **The correction identity at `s = 0, 1`.**  For `s ≠ 0, 1`, the paper's `ξ` agrees with
the entire normalisation `xi₀`; the algebra is `½ s(s−1)(Λ₀(s) − 1/s − 1/(1−s)) =
½ s(s−1) Λ₀(s) + ½`. -/
theorem xi_eq_xi₀ {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) : xi s = xi₀ s := by
  rw [xi, xi₀, completedRiemannZeta_eq]
  field_simp
  ring

/-- **Functional equation for `xi₀`.**  `xi₀(1 − s) = xi₀ s`, from
`completedRiemannZeta₀_one_sub` and the polynomial identity `(1−s)(−s) = s(s−1)`. -/
theorem xi₀_one_sub (s : ℂ) : xi₀ (1 - s) = xi₀ s := by
  simp only [xi₀, completedRiemannZeta₀_one_sub]
  ring

/-- **Reality of `xi₀`.**  `xi₀(conj s) = conj (xi₀ s)`, the `f(conj s) = conj (f s)`
input of Route B, from `completedRiemannZeta₀_conj`. -/
theorem xi₀_conj (s : ℂ) : xi₀ (conj s) = conj (xi₀ s) := by
  simp only [xi₀, completedRiemannZeta₀_conj, map_add, map_mul, map_sub, map_div₀, map_one,
    Complex.conj_ofNat]

/-- **Entireness of `xi₀`**, from the entireness of `completedRiemannZeta₀`. -/
theorem differentiable_xi₀ : Differentiable ℂ xi₀ := by
  have hΛ : Differentiable ℂ completedRiemannZeta₀ := differentiable_completedZeta₀
  unfold xi₀
  fun_prop

/-- **`logDeriv` transfer.**  Away from `s = 0, 1` the logarithmic derivatives of `ξ` and
of its entire normalisation coincide: the two functions agree on the open complement of the
finite closed set `{0, 1}`, hence in a neighbourhood of `s`. -/
theorem logDeriv_xi_eq_xi₀ {s : ℂ} (h0 : s ≠ 0) (h1 : s ≠ 1) :
    logDeriv xi s = logDeriv xi₀ s := by
  have hev : xi =ᶠ[𝓝 s] xi₀ := by
    filter_upwards [eventually_ne_nhds h0, eventually_ne_nhds h1] with z hz0 hz1
    exact xi_eq_xi₀ hz0 hz1
  exact (logDeriv_congr_nhds hev).self_of_nhds

/-! ## Route B at `ξ` -/

/-- The point `x + i t` with `t > 0` is neither `0` nor `1` (its imaginary part is `t`). -/
private lemma ofReal_add_mul_I_ne_zero_one {x t : ℝ} (ht : 0 < t) :
    (x : ℂ) + (t : ℂ) * Complex.I ≠ 0 ∧ (x : ℂ) + (t : ℂ) * Complex.I ≠ 1 := by
  constructor
  · intro h
    have him := congrArg Complex.im h
    simp at him
    linarith only [ht, him]
  · intro h
    have him := congrArg Complex.im h
    simp at him
    linarith only [ht, him]

/-- The point `1 + i t` with `t > 0` is neither `0` nor `1` (its imaginary part is `t`). -/
private lemma one_add_mul_I_ne_zero_one {t : ℝ} (ht : 0 < t) :
    (1 : ℂ) + (t : ℂ) * Complex.I ≠ 0 ∧ (1 : ℂ) + (t : ℂ) * Complex.I ≠ 1 := by
  constructor
  · intro h
    have him := congrArg Complex.im h
    simp at him
    linarith only [ht, him]
  · intro h
    have him := congrArg Complex.im h
    simp at him
    linarith only [ht, him]

/-- **Route B at `ξ`.**  With `t₀ > 0`, let `Z` be the zeros of `xi₀` in the rectangle
`[0,1] × [t₀,t₁]` (each strictly interior, of order `m`), `xi₀` zero-free there outside `Z`,
and `logDeriv xi₀` interval-integrable along the two horizontal edges.  Then the
three-segment integral of `ξ′/ξ` over the right half of the rectangle has imaginary part
`π · ∑_{z∈Z} m z`, i.e. `N = Im(I₃)/π` for `ξ`.

`routeB_reduction_general` is applied to the entire normalisation `xi₀` (entireness, the
functional equation `xi₀_one_sub` and reality `xi₀_conj`), and the resulting `rightPath`
is transferred from `logDeriv xi₀` to `logDeriv xi` edge by edge with `logDeriv_xi_eq_xi₀`:
`t₀ > 0` puts every point of the rectangle off `{0,1}`. -/
theorem xi_routeB_general (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : 0 < t0) (ht' : t0 < t1)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt xi₀ z = m z)
    (hno : ∀ u ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), u ∉ Z → xi₀ u ≠ 0)
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv xi₀ (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv xi₀ (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv xi) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  have hred : (rightPath (logDeriv xi₀) t0 t1).im
      = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
    refine routeB_reduction_general xi₀ t0 t1 Z m ht' ?_ hmem hm hno
      xi₀_one_sub xi₀_conj hint₀ hint₁
    intro s _
    exact (differentiable_xi₀.differentiableOn.analyticOnNhd isOpen_univ) s (Set.mem_univ s)
  have ht1 : 0 < t1 := by linarith only [ht, ht']
  have hbot : (∫ x in (1 / 2 : ℝ)..1, logDeriv xi (x + t0 * Complex.I))
      = ∫ x in (1 / 2 : ℝ)..1, logDeriv xi₀ (x + t0 * Complex.I) := by
    apply intervalIntegral.integral_congr
    intro x _
    obtain ⟨hz, ho⟩ := ofReal_add_mul_I_ne_zero_one (x := x) ht
    exact logDeriv_xi_eq_xi₀ hz ho
  have htop : (∫ x in (1 / 2 : ℝ)..1, logDeriv xi (x + t1 * Complex.I))
      = ∫ x in (1 / 2 : ℝ)..1, logDeriv xi₀ (x + t1 * Complex.I) := by
    apply intervalIntegral.integral_congr
    intro x _
    obtain ⟨hz, ho⟩ := ofReal_add_mul_I_ne_zero_one (x := x) ht1
    exact logDeriv_xi_eq_xi₀ hz ho
  have hvert : (∫ y in t0..t1, logDeriv xi (1 + y * Complex.I))
      = ∫ y in t0..t1, logDeriv xi₀ (1 + y * Complex.I) := by
    apply intervalIntegral.integral_congr
    intro y hy
    rw [Set.uIcc_of_le ht'.le] at hy
    obtain ⟨hz, ho⟩ := one_add_mul_I_ne_zero_one (t := y) (lt_of_lt_of_le ht hy.1)
    exact logDeriv_xi_eq_xi₀ hz ho
  have hright : rightPath (logDeriv xi) t0 t1 = rightPath (logDeriv xi₀) t0 t1 := by
    simp only [rightPath]
    rw [hbot, hvert, htop]
  rw [hright]
  exact hred

end

end Rh45RouteBAnalytic
