/-
  DirichletWeightedArgumentPrinciple.lean — the **weighted argument principle**.

  With the weighted residue `rectBoundary_mul_inv` (`∮_{∂R} g(s)(s−a)⁻¹ ds = 2πi·g(a)`,
  `DirichletWeightedResidue.lean`) and the factorised `logDeriv`
  (`logDeriv_prod_pow`, 010), the rectangle argument principle acquires a weight:

    `∮_{∂R} g(s) · f′(s)/f(s) ds = 2πi · ∑_{z∈Z} m z · g(z)`

  for `g` analytic on the rectangle and `f` locally `C · ∏_{z∈Z} (s−z)^{m z}`.  This is the
  weighted twin of `Rh45RouteBAnalytic.argument_principle_factorized`, and is what turns the
  explicit formula's contour integral `∮ F·Λ_χ'/Λ_χ` into the zero sum `∑_ρ m(ρ) F(ρ)`.
-/
import DirichletWeightedResidue
import Rh45.ArgumentPrinciple

open MeasureTheory intervalIntegral
open Filter
open scoped Topology
open scoped Interval
open Rh45RouteBAnalytic

namespace RouteABC

noncomputable section

theorem weighted_argument_principle_factorized (f g : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (C : ℂ) (hC : C ≠ 0)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hg : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ g s)
    (hfac : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      f =ᶠ[𝓝 s] (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z))) :
    rectBoundary (fun s => g s * logDeriv f s) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ) * g z) := by
  set h : ℂ → ℂ := fun s => C * ∏ z ∈ Z, (s - z) ^ (m z) with hh
  have hlog : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), logDeriv f s = logDeriv h s := by
    intro s hs
    rw [hh]
    exact (logDeriv_congr_nhds (hfac s hs)).eq_of_nhds
  have hhval : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), (∀ z ∈ Z, s ≠ z) →
      logDeriv h s = ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹ := by
    intro s hs hsz
    rw [hh]
    exact logDeriv_prod_pow Z m C hC s hsz
  -- edges lie in the rectangle and avoid `Z`
  have memR0 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t0 : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memR1 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t1 : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memRv1 : ∀ y ∈ Set.uIcc t0 t1,
      (1 : ℂ) + (y : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.add_re, Complex.mul_re],
      by simpa [Complex.add_im, Complex.mul_im] using hy⟩
  have memRv0 : ∀ y ∈ Set.uIcc t0 t1,
      (y : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.mul_re], by simpa [Complex.mul_im] using hy⟩
  have ne0 : ∀ z ∈ Z, ∀ x : ℝ, ((x : ℂ) + (t0 : ℂ) * Complex.I) ≠ z := by
    intro z hz x hzero
    have him : (((x : ℂ) + (t0 : ℂ) * Complex.I)).im = t0 := by
      simp [Complex.add_im, Complex.mul_im]
    have h2 := congrArg Complex.im hzero
    rw [him] at h2
    linarith [(hmem z hz).2.2.1]
  have ne1 : ∀ z ∈ Z, ∀ x : ℝ, ((x : ℂ) + (t1 : ℂ) * Complex.I) ≠ z := by
    intro z hz x hzero
    have him : (((x : ℂ) + (t1 : ℂ) * Complex.I)).im = t1 := by
      simp [Complex.add_im, Complex.mul_im]
    have h2 := congrArg Complex.im hzero
    rw [him] at h2
    linarith [(hmem z hz).2.2.2]
  have nev1 : ∀ z ∈ Z, ∀ y : ℝ, ((1 : ℂ) + (y : ℂ) * Complex.I) ≠ z := by
    intro z hz y hzero
    have hre : (((1 : ℂ) + (y : ℂ) * Complex.I)).re = 1 := by
      simp [Complex.add_re, Complex.mul_re]
    have h2 := congrArg Complex.re hzero
    rw [hre] at h2
    linarith [(hmem z hz).2.1]
  have nev0 : ∀ z ∈ Z, ∀ y : ℝ, ((y : ℂ) * Complex.I) ≠ z := by
    intro z hz y hzero
    have hre : (((y : ℂ) * Complex.I)).re = 0 := by simp [Complex.mul_re]
    have h2 := congrArg Complex.re hzero
    rw [hre] at h2
    linarith [(hmem z hz).1]
  -- rewrite the integrand on each edge as the weighted sum
  have e0 : (∫ x in (0 : ℝ)..1, g (x + t0 * Complex.I) * logDeriv f (x + t0 * Complex.I))
      = ∫ x in (0 : ℝ)..1, ∑ z ∈ Z, (m z : ℂ) * (g (x + t0 * Complex.I)
          * ((x + t0 * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change g (x + t0 * Complex.I) * logDeriv f (x + t0 * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * (g (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹)
    rw [hlog _ (memR0 x hx), hhval _ (memR0 x hx) fun z hz => ne0 z hz x, Finset.mul_sum]
    refine Finset.sum_congr rfl fun z _ => ?_; ring
  have e1 : (∫ x in (0 : ℝ)..1, g (x + t1 * Complex.I) * logDeriv f (x + t1 * Complex.I))
      = ∫ x in (0 : ℝ)..1, ∑ z ∈ Z, (m z : ℂ) * (g (x + t1 * Complex.I)
          * ((x + t1 * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change g (x + t1 * Complex.I) * logDeriv f (x + t1 * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * (g (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹)
    rw [hlog _ (memR1 x hx), hhval _ (memR1 x hx) fun z hz => ne1 z hz x, Finset.mul_sum]
    refine Finset.sum_congr rfl fun z _ => ?_; ring
  have e2 : (∫ y in t0..t1, g (1 + y * Complex.I) * logDeriv f (1 + y * Complex.I))
      = ∫ y in t0..t1, ∑ z ∈ Z, (m z : ℂ) * (g (1 + y * Complex.I)
          * ((1 + y * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change g (1 + ↑y * Complex.I) * logDeriv f (1 + ↑y * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * (g (1 + ↑y * Complex.I) * ((1 + ↑y * Complex.I) - z)⁻¹)
    rw [hlog _ (memRv1 y hy), hhval _ (memRv1 y hy) fun z hz => nev1 z hz y, Finset.mul_sum]
    refine Finset.sum_congr rfl fun z _ => ?_; ring
  have e3 : (∫ y in t0..t1, g (y * Complex.I) * logDeriv f (y * Complex.I))
      = ∫ y in t0..t1, ∑ z ∈ Z, (m z : ℂ) * (g (y * Complex.I)
          * ((y * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change g (↑y * Complex.I) * logDeriv f (↑y * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * (g (↑y * Complex.I) * ((↑y * Complex.I) - z)⁻¹)
    rw [hlog _ (memRv0 y hy), hhval _ (memRv0 y hy) fun z hz => nev0 z hz y, Finset.mul_sum]
    refine Finset.sum_congr rfl fun z _ => ?_; ring
  have hEq : rectBoundary (fun s => g s * logDeriv f s) t0 t1
      = rectBoundary (fun s : ℂ => ∑ z ∈ Z, (m z : ℂ) * (g s * (s - z)⁻¹)) t0 t1 := by
    simp only [rectBoundary]
    rw [e0, e1, e2, e3]
  rw [hEq]
  -- integrability of each summand on the four edges
  have hgcont : ContinuousOn g (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) :=
    fun s hs => (hg s hs).continuousAt.continuousWithinAt
  have int0 : ∀ z ∈ Z, IntervalIntegrable
      (fun x : ℝ => (m z : ℂ) * (g (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹))
      volume 0 1 := by
    intro z hz
    have hcont : ContinuousOn (fun x : ℝ => g (x + t0 * Complex.I)
        * ((x + t0 * Complex.I) - z)⁻¹) (Set.uIcc (0 : ℝ) 1) := by
      refine ContinuousOn.mul ?_ ?_
      · exact ContinuousOn.comp hgcont (by fun_prop) fun x hx => memR0 x hx
      · refine ContinuousOn.inv₀ (by fun_prop) fun x hx hzero => ?_
        exact ne0 z hz x (sub_eq_zero.mp hzero)
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int1 : ∀ z ∈ Z, IntervalIntegrable
      (fun x : ℝ => (m z : ℂ) * (g (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹))
      volume 0 1 := by
    intro z hz
    have hcont : ContinuousOn (fun x : ℝ => g (x + t1 * Complex.I)
        * ((x + t1 * Complex.I) - z)⁻¹) (Set.uIcc (0 : ℝ) 1) := by
      refine ContinuousOn.mul ?_ ?_
      · exact ContinuousOn.comp hgcont (by fun_prop) fun x hx => memR1 x hx
      · refine ContinuousOn.inv₀ (by fun_prop) fun x hx hzero => ?_
        exact ne1 z hz x (sub_eq_zero.mp hzero)
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int2 : ∀ z ∈ Z, IntervalIntegrable
      (fun y : ℝ => (m z : ℂ) * (g (1 + y * Complex.I) * ((1 + y * Complex.I) - z)⁻¹))
      volume t0 t1 := by
    intro z hz
    have hcont : ContinuousOn (fun y : ℝ => g (1 + y * Complex.I)
        * ((1 + y * Complex.I) - z)⁻¹) (Set.uIcc t0 t1) := by
      refine ContinuousOn.mul ?_ ?_
      · exact ContinuousOn.comp hgcont (by fun_prop) fun y hy => memRv1 y hy
      · refine ContinuousOn.inv₀ (by fun_prop) fun y hy hzero => ?_
        exact nev1 z hz y (sub_eq_zero.mp hzero)
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int3 : ∀ z ∈ Z, IntervalIntegrable
      (fun y : ℝ => (m z : ℂ) * (g (y * Complex.I) * ((y * Complex.I) - z)⁻¹))
      volume t0 t1 := by
    intro z hz
    have hcont : ContinuousOn (fun y : ℝ => g (y * Complex.I)
        * ((y * Complex.I) - z)⁻¹) (Set.uIcc t0 t1) := by
      refine ContinuousOn.mul ?_ ?_
      · exact ContinuousOn.comp hgcont (by fun_prop) fun y hy => memRv0 y hy
      · refine ContinuousOn.inv₀ (by fun_prop) fun y hy hzero => ?_
        exact nev0 z hz y (sub_eq_zero.mp hzero)
    exact (hcont.const_mul (m z)).intervalIntegrable
  rw [rectBoundary_finsetSum Z (fun z s => (m z : ℂ) * (g s * (s - z)⁻¹)) t0 t1
    int0 int1 int2 int3]
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun z hz => ?_
  rw [rectBoundary_const_mul, rectBoundary_mul_inv g z t0 t1 (hmem z hz).1 (hmem z hz).2.1
    (hmem z hz).2.2.1 (hmem z hz).2.2.2 hg]
  ring



/-- **Weighted argument principle, logarithmic-derivative form.**  If on the rectangle
`logDeriv f = logDeriv g0 + ∑_{z∈Z} m z · (s−z)⁻¹` with `g0` analytic and nonvanishing and `G`
analytic, then `∮_{∂R} G(s)·f′(s)/f(s) ds = 2πi · ∑_{z∈Z} m z · G(z)`.  This is the residue core of
the explicit formula's contour step, in the form `exists_factorization` supplies. -/
theorem weighted_argument_principle_of_logDeriv (f g0 G : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ)
    (hlog : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), s ∉ Z →
      logDeriv f s = logDeriv g0 s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹)
    (hg0 : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ g0 s)
    (hg0ne : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), g0 s ≠ 0)
    (hG : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ G s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1) :
    rectBoundary (fun s => G s * logDeriv f s) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ) * G z) := by
  have hG0zero : rectBoundary (fun s => G s * logDeriv g0 s) t0 t1 = 0 := by
    have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn
      (fun s => G s * logDeriv g0 s) ((t0 : ℂ) * Complex.I) (1 + (t1 : ℂ) * Complex.I) ?_
    · simpa [rectBoundary] using h
    · intro s hs
      have hs' : s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
        simpa [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im] using hs
      have hmem : s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := hs'
      refine DifferentiableAt.differentiableWithinAt ((hG s hmem).mul ?_).differentiableAt
      rw [logDeriv]
      exact (hg0 s hmem).deriv.div (hg0 s hmem) (hg0ne s hmem)
  have memR0 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t0 : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memR1 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t1 : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memRv1 : ∀ y ∈ Set.uIcc t0 t1,
      (1 : ℂ) + (y : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.add_re, Complex.mul_re],
      by simpa [Complex.add_im, Complex.mul_im] using hy⟩
  have memRv0 : ∀ y ∈ Set.uIcc t0 t1,
      (y : ℂ) * Complex.I ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.mul_re], by simpa [Complex.mul_im] using hy⟩
  have hne01 : ∀ z ∈ Z, ∀ x : ℝ, x + t0 * Complex.I ≠ z := fun z hz x hzero => by
    have him : (x + t0 * Complex.I).im = t0 := by simp
    have h2 := congrArg Complex.im hzero; rw [him] at h2; linarith [(hZ z hz).2.2.1]
  have hne11 : ∀ z ∈ Z, ∀ x : ℝ, x + t1 * Complex.I ≠ z := fun z hz x hzero => by
    have him : (x + t1 * Complex.I).im = t1 := by simp
    have h2 := congrArg Complex.im hzero; rw [him] at h2; linarith [(hZ z hz).2.2.2]
  have hne1t : ∀ z ∈ Z, ∀ y : ℝ, 1 + y * Complex.I ≠ z := fun z hz y hzero => by
    have hre : (1 + y * Complex.I).re = 1 := by simp
    have h2 := congrArg Complex.re hzero; rw [hre] at h2; linarith [(hZ z hz).2.1]
  have hne0t : ∀ z ∈ Z, ∀ y : ℝ, y * Complex.I ≠ z := fun z hz y hzero => by
    have hre : (y * Complex.I).re = 0 := by simp
    have h2 := congrArg Complex.re hzero; rw [hre] at h2; linarith [(hZ z hz).1]
  have hnot01 : ∀ x : ℝ, (x + t0 * Complex.I) ∉ Z := fun x hz => hne01 _ hz x rfl
  have hnot11 : ∀ x : ℝ, (x + t1 * Complex.I) ∉ Z := fun x hz => hne11 _ hz x rfl
  have hnot1t : ∀ y : ℝ, (1 + y * Complex.I) ∉ Z := fun y hz => hne1t _ hz y rfl
  have hnot0t : ∀ y : ℝ, (y * Complex.I) ∉ Z := fun y hz => hne0t _ hz y rfl
  have hGcont : ContinuousOn G (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) :=
    fun s hs => (hG s hs).continuousAt.continuousWithinAt
  have hg0cont : ContinuousOn (fun s => G s * logDeriv g0 s)
      (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1) := by
    intro s hs
    have han : AnalyticAt ℂ (fun s => G s * logDeriv g0 s) s := by
      refine (hG s hs).mul ?_
      rw [logDeriv]
      exact (hg0 s hs).deriv.div (hg0 s hs) (hg0ne s hs)
    exact han.continuousAt.continuousWithinAt
  -- the summand `G · ∑ (m z)(s-z)⁻¹` is continuous on each edge
  have hsum01 : ContinuousOn (fun x : ℝ => ∑ z ∈ Z,
      (m z : ℂ) * (G (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹))
      (Set.uIcc (0 : ℝ) 1) :=
    continuousOn_finsetSum (f := fun z (x : ℝ) => (m z : ℂ) * (G (x + t0 * Complex.I)
      * ((x + t0 * Complex.I) - z)⁻¹)) Z fun z hz =>
      (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun x hx => memR0 x hx)
        (ContinuousOn.inv₀ (by fun_prop) fun x hx hzero =>
          hne01 z hz x (sub_eq_zero.mp hzero))).const_mul (m z)
  have hsum11 : ContinuousOn (fun x : ℝ => ∑ z ∈ Z,
      (m z : ℂ) * (G (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹))
      (Set.uIcc (0 : ℝ) 1) :=
    continuousOn_finsetSum (f := fun z (x : ℝ) => (m z : ℂ) * (G (x + t1 * Complex.I)
      * ((x + t1 * Complex.I) - z)⁻¹)) Z fun z hz =>
      (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun x hx => memR1 x hx)
        (ContinuousOn.inv₀ (by fun_prop) fun x hx hzero =>
          hne11 z hz x (sub_eq_zero.mp hzero))).const_mul (m z)
  have hsum1t : ContinuousOn (fun y : ℝ => ∑ z ∈ Z,
      (m z : ℂ) * (G (1 + y * Complex.I) * ((1 + y * Complex.I) - z)⁻¹))
      (Set.uIcc t0 t1) :=
    continuousOn_finsetSum (f := fun z (y : ℝ) => (m z : ℂ) * (G (1 + y * Complex.I)
      * ((1 + y * Complex.I) - z)⁻¹)) Z fun z hz =>
      (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun y hy => memRv1 y hy)
        (ContinuousOn.inv₀ (by fun_prop) fun y hy hzero =>
          hne1t z hz y (sub_eq_zero.mp hzero))).const_mul (m z)
  have hsum0t : ContinuousOn (fun y : ℝ => ∑ z ∈ Z,
      (m z : ℂ) * (G (y * Complex.I) * ((y * Complex.I) - z)⁻¹))
      (Set.uIcc t0 t1) :=
    continuousOn_finsetSum (f := fun z (y : ℝ) => (m z : ℂ) * (G (y * Complex.I)
      * ((y * Complex.I) - z)⁻¹)) Z fun z hz =>
      (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun y hy => memRv0 y hy)
        (ContinuousOn.inv₀ (by fun_prop) fun y hy hzero =>
          hne0t z hz y (sub_eq_zero.mp hzero))).const_mul (m z)
  -- edge rewriting
  have e0 : (∫ x in (0 : ℝ)..1, G (x + t0 * Complex.I) * logDeriv f (x + t0 * Complex.I))
      = ∫ x in (0 : ℝ)..1, (G (x + t0 * Complex.I) * logDeriv g0 (x + t0 * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * (G (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹)) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change G (x + t0 * Complex.I) * logDeriv f (x + t0 * Complex.I)
      = G (x + t0 * Complex.I) * logDeriv g0 (x + t0 * Complex.I)
        + ∑ z ∈ Z, (m z : ℂ) * (G (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹)
    rw [hlog _ (memR0 x hx) (hnot01 x), mul_add, Finset.mul_sum]
    refine congrArg₂ HAdd.hAdd rfl (Finset.sum_congr rfl fun z _ => ?_); ring
  have e1 : (∫ x in (0 : ℝ)..1, G (x + t1 * Complex.I) * logDeriv f (x + t1 * Complex.I))
      = ∫ x in (0 : ℝ)..1, (G (x + t1 * Complex.I) * logDeriv g0 (x + t1 * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * (G (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹)) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change G (x + t1 * Complex.I) * logDeriv f (x + t1 * Complex.I)
      = G (x + t1 * Complex.I) * logDeriv g0 (x + t1 * Complex.I)
        + ∑ z ∈ Z, (m z : ℂ) * (G (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹)
    rw [hlog _ (memR1 x hx) (hnot11 x), mul_add, Finset.mul_sum]
    refine congrArg₂ HAdd.hAdd rfl (Finset.sum_congr rfl fun z _ => ?_); ring
  have e2 : (∫ y in t0..t1, G (1 + y * Complex.I) * logDeriv f (1 + y * Complex.I))
      = ∫ y in t0..t1, (G (1 + y * Complex.I) * logDeriv g0 (1 + y * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * (G (1 + y * Complex.I) * ((1 + y * Complex.I) - z)⁻¹)) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change G (1 + y * Complex.I) * logDeriv f (1 + y * Complex.I)
      = G (1 + y * Complex.I) * logDeriv g0 (1 + y * Complex.I)
        + ∑ z ∈ Z, (m z : ℂ) * (G (1 + y * Complex.I) * ((1 + y * Complex.I) - z)⁻¹)
    rw [hlog _ (memRv1 y hy) (hnot1t y), mul_add, Finset.mul_sum]
    refine congrArg₂ HAdd.hAdd rfl (Finset.sum_congr rfl fun z _ => ?_); ring
  have e3 : (∫ y in t0..t1, G (y * Complex.I) * logDeriv f (y * Complex.I))
      = ∫ y in t0..t1, (G (y * Complex.I) * logDeriv g0 (y * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * (G (y * Complex.I) * ((y * Complex.I) - z)⁻¹)) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change G (y * Complex.I) * logDeriv f (y * Complex.I)
      = G (y * Complex.I) * logDeriv g0 (y * Complex.I)
        + ∑ z ∈ Z, (m z : ℂ) * (G (y * Complex.I) * ((y * Complex.I) - z)⁻¹)
    rw [hlog _ (memRv0 y hy) (hnot0t y), mul_add, Finset.mul_sum]
    refine congrArg₂ HAdd.hAdd rfl (Finset.sum_congr rfl fun z _ => ?_); ring
  have hEq : rectBoundary (fun s => G s * logDeriv f s) t0 t1
      = rectBoundary (fun s : ℂ => G s * logDeriv g0 s
          + ∑ z ∈ Z, (m z : ℂ) * (G s * (s - z)⁻¹)) t0 t1 := by
    simp only [rectBoundary]
    rw [e0, e1, e2, e3]
  rw [hEq]
  have j01 : IntervalIntegrable (fun x : ℝ => G (x + t0 * Complex.I)
      * logDeriv g0 (x + t0 * Complex.I)) volume 0 1 :=
    (ContinuousOn.comp hg0cont (by fun_prop) fun x hx => memR0 x hx).intervalIntegrable
  have j11 : IntervalIntegrable (fun x : ℝ => G (x + t1 * Complex.I)
      * logDeriv g0 (x + t1 * Complex.I)) volume 0 1 :=
    (ContinuousOn.comp hg0cont (by fun_prop) fun x hx => memR1 x hx).intervalIntegrable
  have j1t : IntervalIntegrable (fun y : ℝ => G (1 + y * Complex.I)
      * logDeriv g0 (1 + y * Complex.I)) volume t0 t1 :=
    (ContinuousOn.comp hg0cont (by fun_prop) fun y hy => memRv1 y hy).intervalIntegrable
  have j0t : IntervalIntegrable (fun y : ℝ => G (y * Complex.I)
      * logDeriv g0 (y * Complex.I)) volume t0 t1 :=
    (ContinuousOn.comp hg0cont (by fun_prop) fun y hy => memRv0 y hy).intervalIntegrable
  have k0 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ =>
      (m z : ℂ) * (G (x + t0 * Complex.I) * ((x + t0 * Complex.I) - z)⁻¹)) volume 0 1 := by
    intro z hz
    exact (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun x hx => memR0 x hx)
      (ContinuousOn.inv₀ (by fun_prop) fun x hx hzero =>
        hne01 z hz x (sub_eq_zero.mp hzero))).const_mul (m z) |>.intervalIntegrable
  have k1 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ =>
      (m z : ℂ) * (G (x + t1 * Complex.I) * ((x + t1 * Complex.I) - z)⁻¹)) volume 0 1 := by
    intro z hz
    exact (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun x hx => memR1 x hx)
      (ContinuousOn.inv₀ (by fun_prop) fun x hx hzero =>
        hne11 z hz x (sub_eq_zero.mp hzero))).const_mul (m z) |>.intervalIntegrable
  have k2 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ =>
      (m z : ℂ) * (G (1 + y * Complex.I) * ((1 + y * Complex.I) - z)⁻¹)) volume t0 t1 := by
    intro z hz
    exact (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun y hy => memRv1 y hy)
      (ContinuousOn.inv₀ (by fun_prop) fun y hy hzero =>
        hne1t z hz y (sub_eq_zero.mp hzero))).const_mul (m z) |>.intervalIntegrable
  have k3 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ =>
      (m z : ℂ) * (G (y * Complex.I) * ((y * Complex.I) - z)⁻¹)) volume t0 t1 := by
    intro z hz
    exact (ContinuousOn.mul (ContinuousOn.comp hGcont (by fun_prop) fun y hy => memRv0 y hy)
      (ContinuousOn.inv₀ (by fun_prop) fun y hy hzero =>
        hne0t z hz y (sub_eq_zero.mp hzero))).const_mul (m z) |>.intervalIntegrable
  rw [rectBoundary_add (fun s : ℂ => G s * logDeriv g0 s)
      (fun s : ℂ => ∑ z ∈ Z, (m z : ℂ) * (G s * (s - z)⁻¹)) t0 t1 j01 j11 j1t j0t
      hsum01.intervalIntegrable hsum11.intervalIntegrable
      hsum1t.intervalIntegrable hsum0t.intervalIntegrable]
  rw [hG0zero, zero_add]
  rw [rectBoundary_finsetSum Z (fun z s => (m z : ℂ) * (G s * (s - z)⁻¹)) t0 t1 k0 k1 k2 k3]
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl fun z hz => ?_
  rw [rectBoundary_const_mul, rectBoundary_mul_inv G z t0 t1 (hZ z hz).1 (hZ z hz).2.1
    (hZ z hz).2.2.1 (hZ z hz).2.2.2 hG]
  ring


/-- **`logDeriv` of a factorised function.**  If `f = g₀ · ∏_{z∈Z}(s−z)^{m z}` on the closed
rectangle with `g₀` analytic and nonvanishing, then off `Z`
`logDeriv f = logDeriv g₀ + ∑_{z∈Z} m z·(s−z)⁻¹`.  This is the `hlog` hypothesis of
`weighted_argument_principle_of_logDeriv`, supplied by `exists_factorization`. -/
theorem logDeriv_eq_of_factorization (f g0 : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ f s)
    (hg0 : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ g0 s)
    (hg0ne : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), g0 s ≠ 0)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]),
      f s = g0 s * ∏ z ∈ Z, (s - z) ^ (m z)) :
    ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), s ∉ Z →
      logDeriv f s = logDeriv g0 s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹ := by
  let P : ℂ → ℂ := fun s => ∏ z ∈ Z, (s - z) ^ (m z)
  let H : ℂ → ℂ := g0 * P
  have hP_an : ∀ s, AnalyticAt ℂ P s := by
    intro s
    simp only [P]
    exact Finset.analyticAt_fun_prod (𝕜 := ℂ) (c := s) Z
      (f := fun z w => (w - z) ^ (m z)) (fun z _ => by fun_prop)
  have hP_ne : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), s ∉ Z → P s ≠ 0 := by
    intro s _ hsZ
    simp only [P]
    rw [Finset.prod_ne_zero_iff]
    intro z hz
    exact pow_ne_zero _ (sub_ne_zero.mpr fun h => hsZ (h.symm ▸ hz))
  have hclosure_int : closure (interior ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]))
      = ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
    simp only [Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1), Set.uIcc_of_le (le_of_lt ht),
      Complex.interior_reProdIm, interior_Icc, interior_Icc, Complex.closure_reProdIm,
      closure_Ioo (by norm_num : (0 : ℝ) ≠ 1), closure_Ioo (ne_of_lt ht)]
  intro s hs hsZ
  have hH_an : AnalyticAt ℂ H s := by
    change AnalyticAt ℂ (g0 * P) s
    exact (hg0 s hs).mul (hP_an s)
  have hfs : f s ≠ 0 := by rw [hfac s hs]; exact mul_ne_zero (hg0ne s hs) (hP_ne s hs hsZ)
  have hHs : H s ≠ 0 := by
    change g0 s * P s ≠ 0
    exact mul_ne_zero (hg0ne s hs) (hP_ne s hs hsZ)
  have hlog_eq : logDeriv f s = logDeriv H s := by
    have hs_int : s ∈ closure (interior ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]])) := by
      rw [hclosure_int]; exact hs
    have hneBot : NeBot (𝓝[interior ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]])] s) :=
      mem_closure_iff_nhdsWithin_neBot.mp hs_int
    have hfc : ContinuousAt (logDeriv f) s := by
      have han : AnalyticAt ℂ (logDeriv f) s := by
        rw [logDeriv]
        exact (hf s hs).deriv.div (hf s hs) hfs
      exact han.continuousAt
    have hHc : ContinuousAt (logDeriv H) s := by
      have han : AnalyticAt ℂ (logDeriv H) s := by
        rw [logDeriv]
        exact hH_an.deriv.div hH_an hHs
      exact han.continuousAt
    have hev : logDeriv f =ᶠ[𝓝[interior ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]])] s] logDeriv H := by
      filter_upwards [self_mem_nhdsWithin] with x hx
      have hball : f =ᶠ[𝓝 x] H := by
        filter_upwards [isOpen_interior.mem_nhds hx] with y hy
        change f y = g0 y * P y
        exact hfac y (interior_subset hy)
      exact (logDeriv_congr_nhds hball).eq_of_nhds
    exact tendsto_nhds_unique_of_eventuallyEq
      (hfc.tendsto.mono_left nhdsWithin_le_nhds)
      (hHc.tendsto.mono_left nhdsWithin_le_nhds) hev
  rw [hlog_eq]
  have hlogH : logDeriv H s = logDeriv g0 s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹ := by
    have hPne : P s ≠ 0 := hP_ne s hs hsZ
    change logDeriv (g0 * P) s = logDeriv g0 s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹
    rw [logDeriv_mul (f := g0) (g := P) s (hg0ne s hs) hPne
      (hg0 s hs).differentiableAt (hP_an s).differentiableAt]
    congr 1
    have h1 := logDeriv_prod_pow Z m 1 one_ne_zero s
      (fun z hz => by rintro rfl; exact hsZ hz)
    simpa only [P, one_mul] using h1
  exact hlogH


/-- **Weighted argument principle for an analytic function with prescribed zeros.**  If `f` is
analytic on the rectangle, `Z` is exactly its zero set there (orders `m`), and `G` is analytic,
then `∮_{∂R} G(s)·f′(s)/f(s) ds = 2πi · ∑_{z∈Z} m z · G(z)`.  This is the packaged form the
explicit formula's contour step consumes, obtained from `exists_factorization` +
`logDeriv_eq_of_factorization` + `weighted_argument_principle_of_logDeriv`. -/
theorem weighted_argument_principle_of_analytic (f G : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ)
    (m : ℂ → ℕ) (ht : t0 < t1)
    (hf : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ f s)
    (hG : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), AnalyticAt ℂ G s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), u ∉ Z → f u ≠ 0) :
    rectBoundary (fun s => G s * logDeriv f s) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ) * G z) := by
  obtain ⟨g0, hg0, hg0ne, hfac⟩ := exists_factorization f t0 t1 Z m ht hf hZ hm hno
  exact weighted_argument_principle_of_logDeriv f g0 G t0 t1 Z m
    (logDeriv_eq_of_factorization f g0 t0 t1 Z m ht hf hg0 hg0ne hZ hfac) hg0 hg0ne hG hZ

end

end RouteABC
