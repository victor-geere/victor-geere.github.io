/-
  DirichletWeightedResidue.lean — the first building block of the **weighted contour step**.

  The explicit formula's contour integral is `∮ F · Λ_χ'/Λ_χ`.  With the integrand now evaluated
  (`DirichletCompletedLogDeriv.lean`) the remaining analytic input is the **weighted residue
  theorem** for a rectangle:

    `∮_{∂R} g(s) · (s − a)⁻¹ ds = 2πi · g(a)`   (`a` strictly inside `R`),

  which turns the boundary integral into `∑_ρ m(ρ) g(ρ)`.  Its constant-weight part is
  `rectBoundary_const_mul_inv`, and `weighted_inv_decomp` records the exact decomposition that
  reduces the general case to the analytic (removable-singularity) slope function
  `s ↦ (g s − g a)/(s − a)`.  Mathlib's `dslope` is that slope:
  `(b − a) • dslope g a b = g b − g a` (`sub_smul_dslope`), and
  `has_fpower_series_dslope_fslope` makes it analytic where `g` is, so Cauchy–Goursat
  (`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) will vanish its boundary
  integral.  The remaining work is the interval-integrability plumbing that lifts the pointwise
  identity `mul_inv_eq_const_add_dslope` (proved below) to `rectBoundary`.
-/
import Rh45.ArgumentPrinciple
import Rh45.Weierstrass
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.Calculus.DSlope

open MeasureTheory intervalIntegral
open Filter
open scoped Topology
open scoped Interval
open Rh45RouteBAnalytic

namespace RouteABC

noncomputable section

/-- **Weighted residue, constant part.**  For `a` strictly inside the rectangle,
    `∮_{∂R} c · (s − a)⁻¹ ds = 2πi · c`. -/
theorem rectBoundary_const_mul_inv (c a : ℂ) (t0 t1 : ℝ)
    (hre0 : 0 < a.re) (hre1 : a.re < 1) (him0 : t0 < a.im) (him1 : a.im < t1) :
    rectBoundary (fun s : ℂ => c * (s - a)⁻¹) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * c := by
  rw [rectBoundary_const_mul, rectBoundary_inv_of_mem a t0 t1 hre0 hre1 him0 him1]
  ring

/-- **The weighted-residue decomposition.**  The weighted integrand splits into the constant
residue term plus the analytic slope term `(g s − g a)·(s − a)⁻¹ = (g s − g a)/(s − a)`, which
has a removable singularity at `a`. -/
theorem weighted_inv_decomp (g : ℂ → ℂ) (a s : ℂ) :
    g s * (s - a)⁻¹ = g a * (s - a)⁻¹ + (g s - g a) * (s - a)⁻¹ := by
  ring

/-- Pointwise, off the singular point: `(g s − g a)·(s − a)⁻¹ = dslope g a s`. -/
theorem sub_mul_inv_eq_dslope (g : ℂ → ℂ) (a s : ℂ) (hs : s ≠ a) :
    (g s - g a) * (s - a)⁻¹ = dslope g a s := by
  have h := sub_smul_dslope g a s
  rw [smul_eq_mul] at h
  have hsub : s - a ≠ 0 := sub_ne_zero.mpr hs
  rw [← h, mul_assoc, mul_comm (dslope g a s) ((s - a)⁻¹), ← mul_assoc,
    mul_inv_cancel₀ hsub, one_mul]

/-- Pointwise, off the singular point:
`g s·(s−a)⁻¹ = g a·(s−a)⁻¹ + dslope g a s`. -/
theorem mul_inv_eq_const_add_dslope (g : ℂ → ℂ) (a s : ℂ) (hs : s ≠ a) :
    g s * (s - a)⁻¹ = g a * (s - a)⁻¹ + dslope g a s := by
  rw [weighted_inv_decomp, sub_mul_inv_eq_dslope g a s hs]

/-- The analytic slope `s ↦ dslope g a s` is differentiable on the rectangle when `g` is
analytic there (Mathlib's `has_fpower_series_dslope_fslope` at `a`, `differentiableAt_dslope_of_ne`
elsewhere). -/
theorem dslope_differentiableOn_rect (g : ℂ → ℂ) (a : ℂ) (t0 t1 : ℝ)
    (hg : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ g s) :
    DifferentiableOn ℂ (dslope g a) ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
  intro s hs
  rcases eq_or_ne s a with rfl | hne
  · obtain ⟨p, hp⟩ := hg s hs
    exact (HasFPowerSeriesAt.has_fpower_series_dslope_fslope hp).analyticAt.differentiableAt
      |>.differentiableWithinAt
  · exact ((differentiableAt_dslope_of_ne (f := g) hne).2 (hg s hs).differentiableAt)
      |>.differentiableWithinAt

/-- **The slope has vanishing rectangle boundary integral** (Cauchy–Goursat). -/
theorem rectBoundary_dslope_eq_zero (g : ℂ → ℂ) (a : ℂ) (t0 t1 : ℝ)
    (hg : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ g s) :
    rectBoundary (dslope g a) t0 t1 = 0 := by
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn (dslope g a)
    ((t0 : ℂ) * Complex.I) (1 + (t1 : ℂ) * Complex.I) ?_
  · simpa [rectBoundary] using h
  · intro s hs
    have hs' : s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
      simpa [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im] using hs
    have hset : ([[(↑t0 * Complex.I).re, (1 + ↑t1 * Complex.I).re]] ×ℂ
        [[(↑t0 * Complex.I).im, (1 + ↑t1 * Complex.I).im]])
        = ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]) := by
      simp [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im]
    rw [hset]
    exact dslope_differentiableOn_rect g a t0 t1 hg s hs'

/-- **Weighted residue theorem (rectangle).**  For `a` strictly inside `R = [0,1] × [t₀,t₁]`
and `g` analytic on `R`, `∮_{∂R} g(s)·(s−a)⁻¹ ds = 2πi·g(a)`. -/
theorem rectBoundary_mul_inv (g : ℂ → ℂ) (a : ℂ) (t0 t1 : ℝ)
    (hre0 : 0 < a.re) (hre1 : a.re < 1) (him0 : t0 < a.im) (him1 : a.im < t1)
    (hg : ∀ s ∈ ([[(0 : ℝ), 1]] ×ℂ [[t0, t1]]), AnalyticAt ℂ g s) :
    rectBoundary (fun s => g s * (s - a)⁻¹) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * g a := by
  have hzero := rectBoundary_dslope_eq_zero g a t0 t1 hg
  have hds := dslope_differentiableOn_rect g a t0 t1 hg
  -- pointwise identity on each edge (`a` is strictly interior, hence off every edge)
  have hne01 : ∀ x : ℝ, x + t0 * Complex.I ≠ a := fun x => by
    intro h; have := congrArg Complex.im h
    simp only [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.ofReal_re,
      Complex.I_re, Complex.I_im, mul_one, mul_zero, add_zero] at this; linarith
  have hne11 : ∀ x : ℝ, x + t1 * Complex.I ≠ a := fun x => by
    intro h; have := congrArg Complex.im h
    simp only [Complex.add_im, Complex.ofReal_im, Complex.mul_im, Complex.ofReal_re,
      Complex.I_re, Complex.I_im, mul_one, mul_zero, add_zero] at this; linarith
  have hne1t : ∀ y : ℝ, 1 + y * Complex.I ≠ a := fun y => by
    intro h; have := congrArg Complex.re h
    simp only [Complex.add_re, Complex.one_re, Complex.mul_re, Complex.ofReal_re,
      Complex.I_re, Complex.ofReal_im, Complex.I_im, mul_one, mul_zero, add_zero] at this
    linarith
  have hne0t : ∀ y : ℝ, y * Complex.I ≠ a := fun y => by
    intro h; have := congrArg Complex.re h
    simp only [Complex.mul_re, Complex.ofReal_re, Complex.I_re, Complex.ofReal_im,
      Complex.I_im, mul_one, mul_zero, sub_zero] at this; linarith
  have E01 : (∫ x in (0 : ℝ)..1, g (x + t0 * Complex.I) * ((x + t0 * Complex.I) - a)⁻¹)
      = ∫ x in (0 : ℝ)..1, (g a * ((x + t0 * Complex.I) - a)⁻¹
          + dslope g a (x + t0 * Complex.I)) :=
    intervalIntegral.integral_congr fun x _ => mul_inv_eq_const_add_dslope g a _ (hne01 x)
  have E11 : (∫ x in (0 : ℝ)..1, g (x + t1 * Complex.I) * ((x + t1 * Complex.I) - a)⁻¹)
      = ∫ x in (0 : ℝ)..1, (g a * ((x + t1 * Complex.I) - a)⁻¹
          + dslope g a (x + t1 * Complex.I)) :=
    intervalIntegral.integral_congr fun x _ => mul_inv_eq_const_add_dslope g a _ (hne11 x)
  have E1t : (∫ y in t0..t1, g (1 + y * Complex.I) * ((1 + y * Complex.I) - a)⁻¹)
      = ∫ y in t0..t1, (g a * ((1 + y * Complex.I) - a)⁻¹
          + dslope g a (1 + y * Complex.I)) :=
    intervalIntegral.integral_congr fun y _ => mul_inv_eq_const_add_dslope g a _ (hne1t y)
  have E0t : (∫ y in t0..t1, g (y * Complex.I) * ((y * Complex.I) - a)⁻¹)
      = ∫ y in t0..t1, (g a * ((y * Complex.I) - a)⁻¹
          + dslope g a (y * Complex.I)) :=
    intervalIntegral.integral_congr fun y _ => mul_inv_eq_const_add_dslope g a _ (hne0t y)
  -- integrability of the two summands on the four edges
  have i01 : IntervalIntegrable (fun x : ℝ => g a * ((x + t0 * Complex.I) - a)⁻¹) volume 0 1 :=
    (continuous_const.mul (((Complex.continuous_ofReal.add (continuous_const : Continuous fun _ : ℝ =>
      t0 * Complex.I)).sub continuous_const).inv₀ (fun x => sub_ne_zero.mpr (hne01 x)))).intervalIntegrable _ _
  have i11 : IntervalIntegrable (fun x : ℝ => g a * ((x + t1 * Complex.I) - a)⁻¹) volume 0 1 :=
    (continuous_const.mul (((Complex.continuous_ofReal.add (continuous_const : Continuous fun _ : ℝ =>
      t1 * Complex.I)).sub continuous_const).inv₀ (fun x => sub_ne_zero.mpr (hne11 x)))).intervalIntegrable _ _
  have i1t : IntervalIntegrable (fun y : ℝ => g a * ((1 + y * Complex.I) - a)⁻¹) volume t0 t1 :=
    (continuous_const.mul ((((continuous_const : Continuous fun _ : ℝ => (1 : ℂ)).add
      (Complex.continuous_ofReal.mul (continuous_const : Continuous fun _ : ℝ => Complex.I))).sub
      continuous_const).inv₀ (fun y => sub_ne_zero.mpr (hne1t y)))).intervalIntegrable _ _
  have i0t : IntervalIntegrable (fun y : ℝ => g a * ((y * Complex.I) - a)⁻¹) volume t0 t1 :=
    (continuous_const.mul (((Complex.continuous_ofReal.mul (continuous_const : Continuous fun _ : ℝ =>
      Complex.I)).sub continuous_const).inv₀ (fun y => sub_ne_zero.mpr (hne0t y)))).intervalIntegrable _ _
  have ht01 : t0 ≤ t1 := le_of_lt (lt_trans him0 him1)
  have j01 : IntervalIntegrable (fun x : ℝ => dslope g a (x + t0 * Complex.I)) volume 0 1 :=
    (ContinuousOn.comp hds.continuousOn (by fun_prop) (by
      intro x hx
      simp only [Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1), Set.mem_Icc] at hx
      have hre : (x + t0 * Complex.I).re = x := by simp
      have him : (x + t0 * Complex.I).im = t0 := by simp
      rw [Complex.mem_reProdIm, hre, him, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le ht01, Set.mem_Icc, Set.mem_Icc]
      exact ⟨⟨hx.1, hx.2⟩, ⟨le_rfl, ht01⟩⟩)).intervalIntegrable
  have j11 : IntervalIntegrable (fun x : ℝ => dslope g a (x + t1 * Complex.I)) volume 0 1 :=
    (ContinuousOn.comp hds.continuousOn (by fun_prop) (by
      intro x hx
      simp only [Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1), Set.mem_Icc] at hx
      have hre : (x + t1 * Complex.I).re = x := by simp
      have him : (x + t1 * Complex.I).im = t1 := by simp
      rw [Complex.mem_reProdIm, hre, him, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le ht01, Set.mem_Icc, Set.mem_Icc]
      exact ⟨⟨hx.1, hx.2⟩, ⟨ht01, le_rfl⟩⟩)).intervalIntegrable
  have j1t : IntervalIntegrable (fun y : ℝ => dslope g a (1 + y * Complex.I)) volume t0 t1 :=
    (ContinuousOn.comp hds.continuousOn (by fun_prop) (by
      intro y hy
      simp only [Set.uIcc_of_le ht01, Set.mem_Icc] at hy
      have hre : (1 + y * Complex.I).re = 1 := by simp
      have him : (1 + y * Complex.I).im = y := by simp
      rw [Complex.mem_reProdIm, hre, him, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le ht01, Set.mem_Icc, Set.mem_Icc]
      exact ⟨⟨zero_le_one, le_rfl⟩, ⟨hy.1, hy.2⟩⟩)).intervalIntegrable
  have j0t : IntervalIntegrable (fun y : ℝ => dslope g a (y * Complex.I)) volume t0 t1 :=
    (ContinuousOn.comp hds.continuousOn (by fun_prop) (by
      intro y hy
      simp only [Set.uIcc_of_le ht01, Set.mem_Icc] at hy
      have hre : (y * Complex.I).re = 0 := by simp
      have him : (y * Complex.I).im = y := by simp
      rw [Complex.mem_reProdIm, hre, him, Set.uIcc_of_le (by norm_num : (0:ℝ) ≤ 1),
        Set.uIcc_of_le ht01, Set.mem_Icc, Set.mem_Icc]
      exact ⟨⟨le_rfl, zero_le_one⟩, ⟨hy.1, hy.2⟩⟩)).intervalIntegrable
  have hrect : rectBoundary (fun s => g s * (s - a)⁻¹) t0 t1
      = rectBoundary (fun s : ℂ => g a * (s - a)⁻¹ + dslope g a s) t0 t1 := by
    simp only [rectBoundary, E01, E11, E1t, E0t]
  rw [hrect, rectBoundary_add (fun s : ℂ => g a * (s - a)⁻¹) (dslope g a) t0 t1
        i01 i11 i1t i0t j01 j11 j1t j0t,
    rectBoundary_const_mul_inv (g a) a t0 t1 hre0 hre1 him0 him1, hzero]
  ring

end

end RouteABC
