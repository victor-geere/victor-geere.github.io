/-
  Rh45/Weierstrass.lean — dividing out the zeros of an analytic function.

  This module supplies the "Weierstrass step" that `Rh45/ArgumentPrinciple.lean`
  had to assume: an analytic function on a neighbourhood of the closed rectangle
  `[0,1] × [t₀,t₁]` whose zeros in that rectangle are the points of a finite set
  `Z` factors as

      f s = g s * ∏_{z∈Z} (s - z)^(m z)

  with `g` analytic and nowhere zero on the closed rectangle.  The construction is
  the local order factorisation of Mathlib (`AnalyticAt.analyticOrderNatAt_eq_iff`):
  at each `z ∈ Z` the order is finite and equals `m z`, so `f` agrees near `z` with
  `(s - z)^(m z) * h z` for some `h z` analytic at `z` with `h z z ≠ 0`.  Gluing
  these finitely many local descriptions produces `g`.

  The factorisation then feeds the general rectangle argument principle
  `∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`, with no factorisation hypothesis.
-/
import Rh45.ArgumentPrinciple

open MeasureTheory intervalIntegral
open Filter
open scoped Topology
open scoped Interval

namespace Rh45RouteBAnalytic

noncomputable section

/-- **Zero-division factorisation ("Weierstrass" step).**  If `f` is analytic on a neighbourhood
of the closed rectangle `[0,1] × [t₀,t₁]`, its only zeros in that rectangle are the points of the
finite set `Z` (each lying in the OPEN rectangle) and their vanishing orders are `m`, then `f`
factors as `g · ∏ z∈Z, (s - z) ^ (m z)` with `g` analytic and nowhere zero on the whole closed
rectangle. -/
theorem exists_factorization (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], u ∉ Z → f u ≠ 0) :
    ∃ g : ℂ → ℂ,
      (∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s) ∧
      (∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g u ≠ 0) ∧
      (∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], f s = g s * ∏ z ∈ Z, (s - z) ^ (m z)) := by
  -- Membership of a zero `z ∈ Z` in the closed rectangle.
  have hzR : ∀ z ∈ Z, z ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro z hz
    rw [Complex.mem_reProdIm, Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1),
      Set.uIcc_of_le (le_of_lt ht), Set.mem_Icc, Set.mem_Icc]
    exact ⟨⟨le_of_lt (hZ z hz).1, le_of_lt (hZ z hz).2.1⟩,
      ⟨le_of_lt (hZ z hz).2.2.1, le_of_lt (hZ z hz).2.2.2⟩⟩
  -- `z` is an interior point, so the closed rectangle is a neighbourhood of `z`.
  have hrect_nhds : ∀ z ∈ Z, ∀ᶠ s in 𝓝 z, s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro z hz
    have hz_int : z ∈ interior ([[(0:ℝ),1]] ×ℂ [[t0,t1]]) := by
      rw [Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1), Set.uIcc_of_le (le_of_lt ht),
        Complex.interior_reProdIm, interior_Icc, interior_Icc]
      exact ⟨⟨(hZ z hz).1, (hZ z hz).2.1⟩, ⟨(hZ z hz).2.2.1, (hZ z hz).2.2.2⟩⟩
    exact Filter.mem_of_superset (isOpen_interior.mem_nhds hz_int) interior_subset
  -- Near `z`, no other point of `Z` occurs.
  have hZ_near : ∀ z ∈ Z, ∀ᶠ s in 𝓝 z, s ∉ Z.erase z := by
    intro z hz
    have hclosed : IsClosed (((Z.erase z : Finset ℂ) : Set ℂ)) := (Z.erase z).finite_toSet.isClosed
    have hmem : z ∉ (((Z.erase z : Finset ℂ) : Set ℂ)) := by simp
    refine Filter.mem_of_superset (hclosed.isOpen_compl.mem_nhds hmem) ?_
    intro s hs
    simpa only [Set.mem_compl_iff, Finset.mem_coe, Set.mem_ofPred_eq] using hs
  have hZ_near_compl : ∀ s, s ∉ Z → ∀ᶠ w in 𝓝 s, w ∉ Z := by
    intro s hs
    have hclosed : IsClosed (((Z : Finset ℂ) : Set ℂ)) := Z.finite_toSet.isClosed
    have hmem : s ∉ (((Z : Finset ℂ) : Set ℂ)) := by simpa using hs
    refine Filter.mem_of_superset (hclosed.isOpen_compl.mem_nhds hmem) ?_
    intro w hw
    simpa only [Set.mem_compl_iff, Finset.mem_coe, Set.mem_ofPred_eq] using hw
  -- The order of `f` at each zero is finite.
  have hne_top : ∀ z ∈ Z, analyticOrderAt f z ≠ ⊤ := by
    intro z hz htop
    have hzero : ∀ᶠ s in 𝓝 z, f s = 0 := analyticOrderAt_eq_top.mp htop
    have hfalse : ∀ᶠ s in 𝓝[≠] z, False := by
      filter_upwards [Filter.Eventually.filter_mono nhdsWithin_le_nhds hzero,
        Filter.Eventually.filter_mono nhdsWithin_le_nhds (hZ_near z hz),
        Filter.Eventually.filter_mono nhdsWithin_le_nhds (hrect_nhds z hz),
        self_mem_nhdsWithin] with s hf0 hE hr hsne
      exact hno s hr (fun hsZ => hE (Finset.mem_erase.mpr ⟨hsne, hsZ⟩)) hf0
    obtain ⟨s, hs⟩ := hfalse.exists
    exact hs
  -- The local order factorisations.
  have hlocal : ∀ z ∈ Z, ∃ h : ℂ → ℂ, AnalyticAt ℂ h z ∧ h z ≠ 0 ∧
      f =ᶠ[𝓝 z] fun s => (s - z) ^ (m z) * h s := by
    intro z hz
    have hfz : AnalyticAt ℂ f z := hf z (hzR z hz)
    obtain ⟨h, hh, hh0, hfh⟩ := (hfz.analyticOrderAt_ne_top).mp (hne_top z hz)
    exact ⟨h, hh, hh0, by simpa [hm z hz, smul_eq_mul] using hfh⟩
  -- Choose them all at once.
  let h : ℂ → ℂ → ℂ := fun z =>
    if hz : z ∈ Z then Classical.choose (hlocal z hz) else fun _ => 1
  have hspec : ∀ z ∈ Z, AnalyticAt ℂ (h z) z ∧ h z z ≠ 0 ∧
      f =ᶠ[𝓝 z] fun s => (s - z) ^ (m z) * h z s := by
    intro z hz
    have hz' : h z = Classical.choose (hlocal z hz) := by simp only [h, dite_eq_left hz]
    rw [hz']
    exact Classical.choose_spec (hlocal z hz)
  -- The divided-out product, its punctured products, and the candidate `g`.
  let P : ℂ → ℂ := fun s => ∏ z ∈ Z, (s - z) ^ (m z)
  let Q : ℂ → ℂ → ℂ := fun z s => ∏ z' ∈ Z.erase z, (s - z') ^ (m z')
  let g : ℂ → ℂ := fun s => if hs : s ∈ Z then h s s / Q s s else f s / P s
  have hg_mem : ∀ s ∈ Z, g s = h s s / Q s s := by
    intro s hs; simp only [g, dite_eq_left hs]
  have hg_notMem : ∀ s, s ∉ Z → g s = f s / P s := by
    intro s hs; simp only [g, dite_eq_right hs]
  -- Splitting off the factor at `z`.
  have hPQ : ∀ z ∈ Z, ∀ s : ℂ, P s = (s - z) ^ (m z) * Q z s := by
    intro z hz s
    simp only [P, Q]
    exact (Finset.mul_prod_erase Z (fun z' => (s - z') ^ (m z')) hz).symm
  have hP_ne : ∀ s, s ∉ Z → P s ≠ 0 := by
    intro s hs
    simp only [P]
    rw [Finset.prod_ne_zero_iff]
    intro z hz
    exact pow_ne_zero _ (sub_ne_zero.mpr (fun h => hs (h ▸ hz)))
  have hQ_ne : ∀ z ∈ Z, Q z z ≠ 0 := by
    intro z hz
    simp only [Q]
    rw [Finset.prod_ne_zero_iff]
    intro z' hz'
    exact pow_ne_zero _ (sub_ne_zero.mpr (Finset.ne_of_mem_erase (s := Z) (a := z) hz').symm)
  have hP_an : ∀ s, AnalyticAt ℂ P s := by
    intro s
    simp only [P]
    exact Finset.analyticAt_fun_prod (𝕜 := ℂ) (c := s) Z
      (f := fun z w => (w - z) ^ (m z)) (fun z _ => by fun_prop)
  have hQ_an : ∀ z, AnalyticAt ℂ (Q z) z := by
    intro z
    simp only [Q]
    exact Finset.analyticAt_fun_prod (𝕜 := ℂ) (c := z) (Z.erase z)
      (f := fun z' w => (w - z') ^ (m z')) (fun z' _ => by fun_prop)
  refine ⟨g, ?_, ?_, ?_⟩
  · -- `g` is analytic at every point of the closed rectangle.
    intro s hs
    by_cases hsZ : s ∈ Z
    · -- at a zero: `g =ᶠ h s / Q s`, analytic and nonvanishing at `s`
      refine ((hspec s hsZ).1.div (hQ_an s) (hQ_ne s hsZ)).congr ?_
      filter_upwards [(hspec s hsZ).2.2, hZ_near s hsZ] with w hfw hE
      by_cases hws : w = s
      · rw [hws, hg_mem s hsZ]
        rfl
      · have hwZ : w ∉ Z := fun hwZ => hE (Finset.mem_erase.mpr ⟨hws, hwZ⟩)
        rw [hg_notMem w hwZ, hfw, hPQ s hsZ w]
        exact (mul_div_mul_left (h s w) (Q s w)
          (pow_ne_zero _ (sub_ne_zero.mpr hws))).symm
    · -- away from the zeros: `g = f / P`, analytic and `P s ≠ 0`
      refine ((hf s hs).div (hP_an s) (hP_ne s hsZ)).congr ?_
      filter_upwards [hZ_near_compl s hsZ] with w hw
      rw [hg_notMem w hw]
      rfl
  · -- `g` does not vanish on the closed rectangle.
    intro u hu
    by_cases huZ : u ∈ Z
    · rw [hg_mem u huZ]
      exact div_ne_zero (hspec u huZ).2.1 (hQ_ne u huZ)
    · rw [hg_notMem u huZ]
      exact div_ne_zero (hno u hu huZ) (hP_ne u huZ)
  · -- the product identity
    intro s hs
    by_cases hsZ : s ∈ Z
    · rw [hg_mem s hsZ]
      change f s = h s s / Q s s * P s
      rw [hPQ s hsZ s]
      have hf_s : f s = (s - s) ^ (m s) * h s s := by
        simpa using (hspec s hsZ).2.2.self_of_nhds
      rw [hf_s, sub_self]
      rcases eq_or_ne (m s) 0 with hm0 | hm0
      · rw [hm0]; simp only [pow_zero, one_mul]; rw [div_mul_cancel₀ _ (hQ_ne s hsZ)]
      · simp [hm0]
    · rw [hg_notMem s hsZ]
      exact (div_mul_cancel₀ (f s) (hP_ne s hsZ)).symm


/-! ## Additivity of `rectBoundary` and `∮ g′/g = 0` -/

/-- `rectBoundary` is additive in the integrand, provided both summands are
interval-integrable on the four edges. -/
theorem rectBoundary_add (f g : ℂ → ℂ) (t0 t1 : ℝ)
    (h0f : IntervalIntegrable (fun x : ℝ => f (x + t0 * Complex.I)) volume 0 1)
    (h1f : IntervalIntegrable (fun x : ℝ => f (x + t1 * Complex.I)) volume 0 1)
    (h2f : IntervalIntegrable (fun y : ℝ => f (1 + y * Complex.I)) volume t0 t1)
    (h3f : IntervalIntegrable (fun y : ℝ => f (y * Complex.I)) volume t0 t1)
    (h0g : IntervalIntegrable (fun x : ℝ => g (x + t0 * Complex.I)) volume 0 1)
    (h1g : IntervalIntegrable (fun x : ℝ => g (x + t1 * Complex.I)) volume 0 1)
    (h2g : IntervalIntegrable (fun y : ℝ => g (1 + y * Complex.I)) volume t0 t1)
    (h3g : IntervalIntegrable (fun y : ℝ => g (y * Complex.I)) volume t0 t1) :
    rectBoundary (fun s => f s + g s) t0 t1
      = rectBoundary f t0 t1 + rectBoundary g t0 t1 := by
  simp only [rectBoundary]
  rw [intervalIntegral.integral_add h0f h0g, intervalIntegral.integral_add h1f h1g,
    intervalIntegral.integral_add h2f h2g, intervalIntegral.integral_add h3f h3g]
  ring

/-- **Vanishing of the boundary integral of a logarithmic derivative.**  If `g` is
analytic and nowhere zero on the closed rectangle `[0,1] × [t₀,t₁]`, then
`∮_{∂R} g′/g = 0`: `logDeriv g = (deriv g)/g` is differentiable on the whole closed
rectangle, so Cauchy–Goursat for a rectangle applies. -/
theorem rectBoundary_logDeriv_eq_zero (g : ℂ → ℂ) (t0 t1 : ℝ)
    (hg : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s)
    (hgne : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g s ≠ 0) :
    rectBoundary (logDeriv g) t0 t1 = 0 := by
  have hd : DifferentiableOn ℂ (logDeriv g) ([[(0:ℝ),1]] ×ℂ [[t0,t1]]) := by
    intro s hs
    have han : AnalyticAt ℂ (logDeriv g) s := by
      rw [logDeriv]
      exact (hg s hs).deriv.div (hg s hs) (hgne s hs)
    exact han.differentiableAt.differentiableWithinAt
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn (logDeriv g)
    ((t0 : ℂ) * Complex.I) (1 + (t1 : ℂ) * Complex.I) ?_
  · simpa [rectBoundary] using h
  · intro s hs
    have hs' : s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
      simpa [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im] using hs
    have hset : ([[(↑t0 * Complex.I).re, (1 + ↑t1 * Complex.I).re]] ×ℂ
        [[(↑t0 * Complex.I).im, (1 + ↑t1 * Complex.I).im]])
        = ([[(0:ℝ),1]] ×ℂ [[t0,t1]]) := by
      simp [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im]
    rw [hset]
    exact hd s hs'

/-! ## The general rectangle argument principle -/

/-- **Argument principle with an explicit factor.**  If `f` and `g` are analytic on the closed
rectangle `[0,1] × [t₀,t₁]` (with `t₀ < t₁`), `g` is nowhere zero there, and
`f = g · ∏_{z∈Z} (s−z)^{m z}` on the rectangle with every `z ∈ Z` strictly inside, then
`∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`.

Compared with the signature sketched in the task statement, two hypotheses are made explicit:

* `ht : t₀ < t₁`, needed so that the interior of the rectangle accumulates at every boundary
  point, which is how the pointwise factorisation is upgraded to a germ identity;
* `hf`, analyticity of `f` on the rectangle.  It is **not** redundant: `logDeriv f` involves
  `deriv f`, a germ condition, while `hfac` constrains `f` only on the closed rectangle.  Without
  analyticity of `f` the statement is false (modify `f` smoothly outside the rectangle). -/
theorem argument_principle_of_factorization (f g : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hg : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ g s)
    (hgne : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], g s ≠ 0)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]],
      f s = g s * ∏ z ∈ Z, (s - z) ^ (m z)) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ)) := by
  let P : ℂ → ℂ := fun s => ∏ z ∈ Z, (s - z) ^ (m z)
  let H : ℂ → ℂ := g * P
  have hP_an : ∀ s, AnalyticAt ℂ P s := by
    intro s
    simp only [P]
    exact Finset.analyticAt_fun_prod (𝕜 := ℂ) (c := s) Z
      (f := fun z w => (w - z) ^ (m z)) (fun z _ => by fun_prop)
  have hH_an : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ H s := by
    intro s hs
    change AnalyticAt ℂ (g * P) s
    exact (hg s hs).mul (hP_an s)
  have hP_ne : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], s ∉ Z → P s ≠ 0 := by
    intro s _ hsZ
    simp only [P]
    rw [Finset.prod_ne_zero_iff]
    intro z hz
    exact pow_ne_zero _ (sub_ne_zero.mpr (fun h => hsZ (h.symm ▸ hz)))
  -- the interior of the rectangle accumulates at every point of the rectangle
  have hclosure_int : closure (interior ([[(0:ℝ),1]] ×ℂ [[t0,t1]]))
      = ([[(0:ℝ),1]] ×ℂ [[t0,t1]]) := by
    simp only [Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1), Set.uIcc_of_le (le_of_lt ht),
      Complex.interior_reProdIm, interior_Icc, interior_Icc, Complex.closure_reProdIm,
      closure_Ioo (by norm_num : (0 : ℝ) ≠ 1), closure_Ioo (ne_of_lt ht)]
  -- on the rectangle, `f` and `g · P` have the same logarithmic derivative
  have hlog_eq : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], s ∉ Z →
      logDeriv f s = logDeriv H s := by
    intro s hs hsZ
    have hs_int : s ∈ closure (interior ([[(0:ℝ),1]] ×ℂ [[t0,t1]])) := by
      rw [hclosure_int]; exact hs
    have hneBot : NeBot (𝓝[interior ([[(0:ℝ),1]] ×ℂ [[t0,t1]])] s) :=
      mem_closure_iff_nhdsWithin_neBot.mp hs_int
    have hfs : f s ≠ 0 := by
      rw [hfac s hs]
      exact mul_ne_zero (hgne s hs) (hP_ne s hs hsZ)
    have hHs : H s ≠ 0 := by
      change g s * P s ≠ 0
      exact mul_ne_zero (hgne s hs) (hP_ne s hs hsZ)
    have hfc : ContinuousAt (logDeriv f) s := by
      have han : AnalyticAt ℂ (logDeriv f) s := by
        rw [logDeriv]
        exact (hf s hs).deriv.div (hf s hs) hfs
      exact han.continuousAt
    have hHc : ContinuousAt (logDeriv H) s := by
      have han : AnalyticAt ℂ (logDeriv H) s := by
        rw [logDeriv]
        exact (hH_an s hs).deriv.div (hH_an s hs) hHs
      exact han.continuousAt
    have hev : logDeriv f =ᶠ[𝓝[interior ([[(0:ℝ),1]] ×ℂ [[t0,t1]])] s] logDeriv H := by
      filter_upwards [self_mem_nhdsWithin] with x hx
      have hball : f =ᶠ[𝓝 x] H := by
        filter_upwards [isOpen_interior.mem_nhds hx] with y hy
        change f y = g y * P y
        exact hfac y (interior_subset hy)
      exact (logDeriv_congr_nhds hball).eq_of_nhds
    exact tendsto_nhds_unique_of_eventuallyEq
      (hfc.tendsto.mono_left nhdsWithin_le_nhds)
      (hHc.tendsto.mono_left nhdsWithin_le_nhds) hev
  -- the product rule on the rectangle away from `Z`
  have hlogH : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], s ∉ Z →
      logDeriv H s = logDeriv g s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹ := by
    intro s hs hsZ
    have hPne : P s ≠ 0 := hP_ne s hs hsZ
    change logDeriv (g * P) s = logDeriv g s + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹
    rw [logDeriv_mul (f := g) (g := P) s (hgne s hs) hPne
      (hg s hs).differentiableAt (hP_an s).differentiableAt]
    congr 1
    have h1 := logDeriv_prod_pow Z m 1 one_ne_zero s
      (fun z hz => by rintro rfl; exact hsZ hz)
    simpa only [P, one_mul] using h1
  -- the four edges lie in the rectangle
  have memR0 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t0 : ℂ) * Complex.I ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memR1 : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      (x : ℂ) + (t1 : ℂ) * Complex.I ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa [Complex.add_re, Complex.mul_re] using hx,
      by simp [Complex.add_im, Complex.mul_im]⟩
  have memRv1 : ∀ y ∈ Set.uIcc t0 t1,
      (1 : ℂ) + (y : ℂ) * Complex.I ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.add_re, Complex.mul_re],
      by simpa [Complex.add_im, Complex.mul_im] using hy⟩
  have memRv0 : ∀ y ∈ Set.uIcc t0 t1,
      (y : ℂ) * Complex.I ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]] := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simp [Complex.mul_re], by simpa [Complex.mul_im] using hy⟩
  -- the four edges avoid `Z`
  have ne0 : ∀ z ∈ Z, ∀ x : ℝ, ((x : ℂ) + (t0 : ℂ) * Complex.I) ≠ z := by
    intro z hz x hzero
    have him : (((x : ℂ) + (t0 : ℂ) * Complex.I)).im = t0 := by
      simp [Complex.add_im, Complex.mul_im]
    have h2 := congrArg Complex.im hzero
    rw [him] at h2
    linarith only [h2, (hZ z hz).2.2.1]
  have ne1 : ∀ z ∈ Z, ∀ x : ℝ, ((x : ℂ) + (t1 : ℂ) * Complex.I) ≠ z := by
    intro z hz x hzero
    have him : (((x : ℂ) + (t1 : ℂ) * Complex.I)).im = t1 := by
      simp [Complex.add_im, Complex.mul_im]
    have h2 := congrArg Complex.im hzero
    rw [him] at h2
    linarith only [h2, (hZ z hz).2.2.2]
  have nev1 : ∀ z ∈ Z, ∀ y : ℝ, ((1 : ℂ) + (y : ℂ) * Complex.I) ≠ z := by
    intro z hz y hzero
    have hre : (((1 : ℂ) + (y : ℂ) * Complex.I)).re = 1 := by
      simp [Complex.add_re, Complex.mul_re]
    have h2 := congrArg Complex.re hzero
    rw [hre] at h2
    linarith only [h2, (hZ z hz).2.1]
  have nev0 : ∀ z ∈ Z, ∀ y : ℝ, ((y : ℂ) * Complex.I) ≠ z := by
    intro z hz y hzero
    have hre : (((y : ℂ) * Complex.I)).re = 0 := by simp [Complex.mul_re]
    have h2 := congrArg Complex.re hzero
    rw [hre] at h2
    linarith only [h2, (hZ z hz).1]
  -- summand integrability on the four edges
  have int0 : ∀ z ∈ Z, IntervalIntegrable
      (fun x : ℝ => (m z : ℂ) * (((x : ℂ) + (t0 : ℂ) * Complex.I) - z)⁻¹) volume 0 1 := by
    intro z hz
    have hcont : ContinuousOn (fun x : ℝ => (((x : ℂ) + (t0 : ℂ) * Complex.I) - z)⁻¹)
        (Set.uIcc (0 : ℝ) 1) := by
      refine ContinuousOn.inv₀ (by fun_prop) fun x hx hzero => ?_
      have him : (((x : ℂ) + (t0 : ℂ) * Complex.I) - z).im = t0 - z.im := by
        simp [Complex.add_im, Complex.sub_im, Complex.mul_im]
      have h2 := congrArg Complex.im hzero
      rw [him] at h2
      simp at h2
      linarith only [h2, (hZ z hz).2.2.1]
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int1 : ∀ z ∈ Z, IntervalIntegrable
      (fun x : ℝ => (m z : ℂ) * (((x : ℂ) + (t1 : ℂ) * Complex.I) - z)⁻¹) volume 0 1 := by
    intro z hz
    have hcont : ContinuousOn (fun x : ℝ => (((x : ℂ) + (t1 : ℂ) * Complex.I) - z)⁻¹)
        (Set.uIcc (0 : ℝ) 1) := by
      refine ContinuousOn.inv₀ (by fun_prop) fun x hx hzero => ?_
      have him : (((x : ℂ) + (t1 : ℂ) * Complex.I) - z).im = t1 - z.im := by
        simp [Complex.add_im, Complex.sub_im, Complex.mul_im]
      have h2 := congrArg Complex.im hzero
      rw [him] at h2
      simp at h2
      linarith only [h2, (hZ z hz).2.2.2]
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int2 : ∀ z ∈ Z, IntervalIntegrable
      (fun y : ℝ => (m z : ℂ) * (((1 : ℂ) + (y : ℂ) * Complex.I) - z)⁻¹) volume t0 t1 := by
    intro z hz
    have hcont : ContinuousOn (fun y : ℝ => (((1 : ℂ) + (y : ℂ) * Complex.I) - z)⁻¹)
        (Set.uIcc t0 t1) := by
      refine ContinuousOn.inv₀ (by fun_prop) fun y hy hzero => ?_
      have hre : (((1 : ℂ) + (y : ℂ) * Complex.I) - z).re = 1 - z.re := by
        simp [Complex.add_re, Complex.sub_re, Complex.mul_re]
      have h2 := congrArg Complex.re hzero
      rw [hre] at h2
      simp at h2
      linarith only [h2, (hZ z hz).2.1]
    exact (hcont.const_mul (m z)).intervalIntegrable
  have int3 : ∀ z ∈ Z, IntervalIntegrable
      (fun y : ℝ => (m z : ℂ) * (((y : ℂ) * Complex.I) - z)⁻¹) volume t0 t1 := by
    intro z hz
    have hcont : ContinuousOn (fun y : ℝ => (((y : ℂ) * Complex.I) - z)⁻¹)
        (Set.uIcc t0 t1) := by
      refine ContinuousOn.inv₀ (by fun_prop) fun y hy hzero => ?_
      have hre : (((y : ℂ) * Complex.I) - z).re = -z.re := by
        simp [Complex.sub_re, Complex.mul_re]
      have h2 := congrArg Complex.re hzero
      rw [hre] at h2
      simp at h2
      linarith only [h2, (hZ z hz).1]
    exact (hcont.const_mul (m z)).intervalIntegrable
  -- integrability of the whole sum
  have intS0 : IntervalIntegrable (fun x : ℝ =>
      ∑ z ∈ Z, (m z : ℂ) * (((x : ℂ) + (t0 : ℂ) * Complex.I) - z)⁻¹) volume 0 1 :=
    (IntervalIntegrable.sum Z fun z hz => int0 z hz).congr_ae
      (Filter.Eventually.of_forall fun x => by simp)
  have intS1 : IntervalIntegrable (fun x : ℝ =>
      ∑ z ∈ Z, (m z : ℂ) * (((x : ℂ) + (t1 : ℂ) * Complex.I) - z)⁻¹) volume 0 1 :=
    (IntervalIntegrable.sum Z fun z hz => int1 z hz).congr_ae
      (Filter.Eventually.of_forall fun x => by simp)
  have intS2 : IntervalIntegrable (fun y : ℝ =>
      ∑ z ∈ Z, (m z : ℂ) * (((1 : ℂ) + (y : ℂ) * Complex.I) - z)⁻¹) volume t0 t1 :=
    (IntervalIntegrable.sum Z fun z hz => int2 z hz).congr_ae
      (Filter.Eventually.of_forall fun y => by simp)
  have intS3 : IntervalIntegrable (fun y : ℝ =>
      ∑ z ∈ Z, (m z : ℂ) * (((y : ℂ) * Complex.I) - z)⁻¹) volume t0 t1 :=
    (IntervalIntegrable.sum Z fun z hz => int3 z hz).congr_ae
      (Filter.Eventually.of_forall fun y => by simp)
  -- integrability of `logDeriv g`
  have hcont_g : ContinuousOn (logDeriv g) ([[(0:ℝ),1]] ×ℂ [[t0,t1]]) := by
    intro s hs
    have han : AnalyticAt ℂ (logDeriv g) s := by
      rw [logDeriv]
      exact (hg s hs).deriv.div (hg s hs) (hgne s hs)
    exact han.continuousAt.continuousWithinAt
  have intg0 : IntervalIntegrable (fun x : ℝ => logDeriv g (x + t0 * Complex.I)) volume 0 1 :=
    (hcont_g.comp (by fun_prop) (fun x hx => memR0 x hx)).intervalIntegrable
  have intg1 : IntervalIntegrable (fun x : ℝ => logDeriv g (x + t1 * Complex.I)) volume 0 1 :=
    (hcont_g.comp (by fun_prop) (fun x hx => memR1 x hx)).intervalIntegrable
  have intg2 : IntervalIntegrable (fun y : ℝ => logDeriv g (1 + y * Complex.I)) volume t0 t1 :=
    (hcont_g.comp (by fun_prop) (fun y hy => memRv1 y hy)).intervalIntegrable
  have intg3 : IntervalIntegrable (fun y : ℝ => logDeriv g (y * Complex.I)) volume t0 t1 :=
    (hcont_g.comp (by fun_prop) (fun y hy => memRv0 y hy)).intervalIntegrable
  -- rewrite the boundary integral edge by edge
  have i0 : (∫ x in (0 : ℝ)..1, logDeriv f (x + t0 * Complex.I))
      = ∫ x in (0 : ℝ)..1, (logDeriv g (x + t0 * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * ((x + t0 * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change logDeriv f (x + t0 * Complex.I)
      = logDeriv g (x + t0 * Complex.I) + ∑ z ∈ Z, (m z : ℂ) * ((x + t0 * Complex.I) - z)⁻¹
    rw [hlog_eq _ (memR0 x hx) (fun hmem => (ne0 _ hmem x) rfl),
      hlogH _ (memR0 x hx) (fun hmem => (ne0 _ hmem x) rfl)]
  have i1 : (∫ x in (0 : ℝ)..1, logDeriv f (x + t1 * Complex.I))
      = ∫ x in (0 : ℝ)..1, (logDeriv g (x + t1 * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * ((x + t1 * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro x hx
    change logDeriv f (x + t1 * Complex.I)
      = logDeriv g (x + t1 * Complex.I) + ∑ z ∈ Z, (m z : ℂ) * ((x + t1 * Complex.I) - z)⁻¹
    rw [hlog_eq _ (memR1 x hx) (fun hmem => (ne1 _ hmem x) rfl),
      hlogH _ (memR1 x hx) (fun hmem => (ne1 _ hmem x) rfl)]
  have i2 : (∫ y in t0..t1, logDeriv f (1 + y * Complex.I))
      = ∫ y in t0..t1, (logDeriv g (1 + y * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * ((1 + y * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change logDeriv f (1 + y * Complex.I)
      = logDeriv g (1 + y * Complex.I) + ∑ z ∈ Z, (m z : ℂ) * ((1 + y * Complex.I) - z)⁻¹
    rw [hlog_eq _ (memRv1 y hy) (fun hmem => (nev1 _ hmem y) rfl),
      hlogH _ (memRv1 y hy) (fun hmem => (nev1 _ hmem y) rfl)]
  have i3 : (∫ y in t0..t1, logDeriv f (y * Complex.I))
      = ∫ y in t0..t1, (logDeriv g (y * Complex.I)
          + ∑ z ∈ Z, (m z : ℂ) * ((y * Complex.I) - z)⁻¹) := by
    apply intervalIntegral.integral_congr
    intro y hy
    change logDeriv f (y * Complex.I)
      = logDeriv g (y * Complex.I) + ∑ z ∈ Z, (m z : ℂ) * ((y * Complex.I) - z)⁻¹
    rw [hlog_eq _ (memRv0 y hy) (fun hmem => (nev0 _ hmem y) rfl),
      hlogH _ (memRv0 y hy) (fun hmem => (nev0 _ hmem y) rfl)]
  have hEq : rectBoundary (logDeriv f) t0 t1
      = rectBoundary (fun s : ℂ => logDeriv g s
          + ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹) t0 t1 := by
    simp only [rectBoundary]
    rw [i0, i1, i2, i3]
  rw [hEq]
  -- split off the logarithmic derivative of `g`
  have hadd := rectBoundary_add (logDeriv g) (fun s : ℂ => ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹)
    t0 t1 intg0 intg1 intg2 intg3 intS0 intS1 intS2 intS3
  rw [hadd, rectBoundary_logDeriv_eq_zero g t0 t1 hg hgne, zero_add]
  -- evaluate the finite sum
  rw [rectBoundary_finsetSum Z (fun z s => (m z : ℂ) * (s - z)⁻¹) t0 t1
    int0 int1 int2 int3]
  have hz : ∀ z ∈ Z, rectBoundary (fun s : ℂ => (m z : ℂ) * (s - z)⁻¹) t0 t1
      = (m z : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
    intro z hz
    rw [rectBoundary_const_mul]
    congr 1
    exact rectBoundary_inv_of_mem z t0 t1 (hZ z hz).1 (hZ z hz).2.1
      (hZ z hz).2.2.1 (hZ z hz).2.2.2
  rw [show (∑ z ∈ Z, rectBoundary (fun s : ℂ => (m z : ℂ) * (s - z)⁻¹) t0 t1)
      = ∑ z ∈ Z, ((m z : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)) from
        Finset.sum_congr rfl hz, ← Finset.sum_mul]
  ring

/-- **Argument principle, general form.**  For `f` analytic on a neighbourhood of the closed
rectangle `[0,1] × [t₀,t₁]` whose zeros there are exactly `Z` (in the open rectangle) with orders
`m`, the boundary integral of `f'/f` is `2πi · Σ_{z∈Z} m z`. -/
theorem argument_principle_general (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (ht : t0 < t1)
    (hf : ∀ s ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], AnalyticAt ℂ f s)
    (hZ : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hm : ∀ z ∈ Z, analyticOrderNatAt f z = m z)
    (hno : ∀ u ∈ [[(0:ℝ),1]] ×ℂ [[t0,t1]], u ∉ Z → f u ≠ 0) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ)) := by
  obtain ⟨g, hg, hgne, hfac⟩ := exists_factorization f t0 t1 Z m ht hf hZ hm hno
  exact argument_principle_of_factorization f g t0 t1 Z m ht hf hg hgne hZ hfac

end

end Rh45RouteBAnalytic
