import Symbol

/-!
# The rectangle contour: Cauchy–Goursat, linearity, and the winding integral

This file builds the rectangle-contour layer of the argument principle, the
step needed to put `Z'/Z` on the contour used by the explicit formula.

Mathlib supplies the rectangle Cauchy–Goursat theorem
`Complex.integral_boundary_rect_eq_zero_of_continuousOn_of_differentiableOn`,
whose conclusion is the four interval integrals along the sides.  We package
that expression as `rectIntegral`, prove its linearity, congruence and
zero-free log-derivative form, and then evaluate the winding integral
`∮ dz/(z-w)` over the boundary: `2πi` when `w` is inside, `0` when it is
outside.

No RH proof yet.  Nothing here assumes or proves the Riemann hypothesis.
-/

namespace AbsoluteHodgeRectangle

open Complex MeasureTheory intervalIntegral Set Filter
open scoped Topology
open AbsoluteHodgeSymbol

open scoped Interval

/-- The boundary integral of `f` over the rectangle `[x₁,x₂] × [y₁,y₂]`,
oriented counter-clockwise: bottom, right, top (reversed), left (reversed). -/
noncomputable def rectIntegral (f : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ) : ℂ :=
  (∫ x : ℝ in x₁..x₂, f (x + y₁ * I)) - (∫ x : ℝ in x₁..x₂, f (x + y₂ * I))
    + I * (∫ y : ℝ in y₁..y₂, f (x₂ + y * I))
    - I * (∫ y : ℝ in y₁..y₂, f (x₁ + y * I))

/-- **Rectangle Cauchy–Goursat theorem** in boundary-integral form: a function
continuous on the closed rectangle and complex differentiable on its interior
has zero boundary integral. -/
theorem rectIntegral_eq_zero_of_differentiableOn (f : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ)
    (hc : ContinuousOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]]))
    (hd : DifferentiableOn ℂ f
      (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂))) :
    rectIntegral f x₁ x₂ y₁ y₂ = 0 := by
  unfold rectIntegral
  exact Complex.integral_boundary_rect_eq_zero_of_continuousOn_of_differentiableOn
    f ⟨x₁, y₁⟩ ⟨x₂, y₂⟩ hc hd

/-- Continuity of a horizontal slice of a function continuous on the closed
rectangle. -/
theorem continuousOn_horizontal {f : ℂ → ℂ} {x₁ x₂ y₁ y₂ : ℝ}
    (hf : ContinuousOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]])) {y : ℝ} (hy : y ∈ [[y₁, y₂]]) :
    ContinuousOn (fun x : ℝ => f (x + y * I)) [[x₁, x₂]] := by
  have hmap : ∀ x ∈ [[x₁, x₂]], (x + y * I) ∈ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro x hx
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa using hx, by simpa using hy⟩
  exact hf.comp (continuous_ofReal.add continuous_const).continuousOn hmap

/-- Continuity of a vertical slice of a function continuous on the closed
rectangle. -/
theorem continuousOn_vertical {f : ℂ → ℂ} {x₁ x₂ y₁ y₂ : ℝ}
    (hf : ContinuousOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]])) {x : ℝ} (hx : x ∈ [[x₁, x₂]]) :
    ContinuousOn (fun y : ℝ => f (x + y * I)) [[y₁, y₂]] := by
  have hmap : ∀ y ∈ [[y₁, y₂]], (x + y * I) ∈ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro y hy
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa using hx, by simpa using hy⟩
  exact hf.comp (continuous_const.add (continuous_ofReal.mul continuous_const)).continuousOn hmap

/-- Additivity of the rectangle boundary integral. -/
theorem rectIntegral_add (f g : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ)
    (hf : ContinuousOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]]))
    (hg : ContinuousOn g ([[x₁, x₂]] ×ℂ [[y₁, y₂]])) :
    rectIntegral (fun z => f z + g z) x₁ x₂ y₁ y₂
      = rectIntegral f x₁ x₂ y₁ y₂ + rectIntegral g x₁ x₂ y₁ y₂ := by
  have hb₁ : ContinuousOn (fun x : ℝ => f (x + y₁ * I)) [[x₁, x₂]] :=
    continuousOn_horizontal hf (by simp)
  have hb₂ : ContinuousOn (fun x : ℝ => g (x + y₁ * I)) [[x₁, x₂]] :=
    continuousOn_horizontal hg (by simp)
  have ht₁ : ContinuousOn (fun x : ℝ => f (x + y₂ * I)) [[x₁, x₂]] :=
    continuousOn_horizontal hf (by simp)
  have ht₂ : ContinuousOn (fun x : ℝ => g (x + y₂ * I)) [[x₁, x₂]] :=
    continuousOn_horizontal hg (by simp)
  have hr₁ : ContinuousOn (fun y : ℝ => f (x₂ + y * I)) [[y₁, y₂]] :=
    continuousOn_vertical hf (by simp)
  have hr₂ : ContinuousOn (fun y : ℝ => g (x₂ + y * I)) [[y₁, y₂]] :=
    continuousOn_vertical hg (by simp)
  have hl₁ : ContinuousOn (fun y : ℝ => f (x₁ + y * I)) [[y₁, y₂]] :=
    continuousOn_vertical hf (by simp)
  have hl₂ : ContinuousOn (fun y : ℝ => g (x₁ + y * I)) [[y₁, y₂]] :=
    continuousOn_vertical hg (by simp)
  have h1 : (∫ x : ℝ in x₁..x₂, (f (x + y₁ * I) + g (x + y₁ * I)))
      = (∫ x : ℝ in x₁..x₂, f (x + y₁ * I)) + ∫ x : ℝ in x₁..x₂, g (x + y₁ * I) :=
    intervalIntegral.integral_add (hb₁.intervalIntegrable) (hb₂.intervalIntegrable)
  have h2 : (∫ x : ℝ in x₁..x₂, (f (x + y₂ * I) + g (x + y₂ * I)))
      = (∫ x : ℝ in x₁..x₂, f (x + y₂ * I)) + ∫ x : ℝ in x₁..x₂, g (x + y₂ * I) :=
    intervalIntegral.integral_add (ht₁.intervalIntegrable) (ht₂.intervalIntegrable)
  have h3 : (∫ y : ℝ in y₁..y₂, (f (x₂ + y * I) + g (x₂ + y * I)))
      = (∫ y : ℝ in y₁..y₂, f (x₂ + y * I)) + ∫ y : ℝ in y₁..y₂, g (x₂ + y * I) :=
    intervalIntegral.integral_add (hr₁.intervalIntegrable) (hr₂.intervalIntegrable)
  have h4 : (∫ y : ℝ in y₁..y₂, (f (x₁ + y * I) + g (x₁ + y * I)))
      = (∫ y : ℝ in y₁..y₂, f (x₁ + y * I)) + ∫ y : ℝ in y₁..y₂, g (x₁ + y * I) :=
    intervalIntegral.integral_add (hl₁.intervalIntegrable) (hl₂.intervalIntegrable)
  simp only [rectIntegral, h1, h2, h3, h4, mul_add]
  ring

/-- Negation of the rectangle boundary integral. -/
theorem rectIntegral_neg (f : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ) :
    rectIntegral (fun z => -f z) x₁ x₂ y₁ y₂ = -rectIntegral f x₁ x₂ y₁ y₂ := by
  simp only [rectIntegral, intervalIntegral.integral_neg]
  ring

/-- The rectangle boundary integral depends only on the values of `f` on the
closed rectangle. -/
theorem rectIntegral_congr {f g : ℂ → ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (h : ∀ z ∈ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]), f z = g z) :
    rectIntegral f x₁ x₂ y₁ y₂ = rectIntegral g x₁ x₂ y₁ y₂ := by
  have hb : EqOn (fun x : ℝ => f (x + y₁ * I)) (fun x : ℝ => g (x + y₁ * I)) [[x₁, x₂]] := by
    intro x hx
    refine h _ ?_
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa using hx, by simp⟩
  have ht : EqOn (fun x : ℝ => f (x + y₂ * I)) (fun x : ℝ => g (x + y₂ * I)) [[x₁, x₂]] := by
    intro x hx
    refine h _ ?_
    rw [Complex.mem_reProdIm]
    exact ⟨by simpa using hx, by simp⟩
  have hr : EqOn (fun y : ℝ => f (x₂ + y * I)) (fun y : ℝ => g (x₂ + y * I)) [[y₁, y₂]] := by
    intro y hy
    refine h _ ?_
    rw [Complex.mem_reProdIm]
    exact ⟨by simp, by simpa using hy⟩
  have hl : EqOn (fun y : ℝ => f (x₁ + y * I)) (fun y : ℝ => g (x₁ + y * I)) [[y₁, y₂]] := by
    intro y hy
    refine h _ ?_
    rw [Complex.mem_reProdIm]
    exact ⟨by simp, by simpa using hy⟩
  simp only [rectIntegral, intervalIntegral.integral_congr hb, intervalIntegral.integral_congr ht,
    intervalIntegral.integral_congr hr, intervalIntegral.integral_congr hl]

/-- **Zero-free log-derivative integral on a rectangle.**  If `h` is
differentiable and nonzero on an open set containing the closed rectangle,
then `∮ h'/h = 0` around the rectangle (Cauchy's theorem). -/
theorem rectIntegral_logDeriv_eq_zero {h : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hh : DifferentiableOn ℂ h U) (hne : ∀ z ∈ U, h z ≠ 0) :
    rectIntegral (fun z => deriv h z / h z) x₁ x₂ y₁ y₂ = 0 := by
  have hderiv_diff : DifferentiableOn ℂ (deriv h) U := hh.deriv hU
  have hquot : DifferentiableOn ℂ (fun z : ℂ => deriv h z / h z) U :=
    hderiv_diff.div hh hne
  have hc : ContinuousOn (fun z : ℂ => deriv h z / h z)
      ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) :=
    hquot.continuousOn.mono hsub
  have hsub' : (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂))
      ⊆ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨Ioo_subset_Icc_self hz.1, Ioo_subset_Icc_self hz.2⟩
  have hd : DifferentiableOn ℂ (fun z : ℂ => deriv h z / h z)
      (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂)) :=
    hquot.mono (subset_trans hsub' hsub)
  exact rectIntegral_eq_zero_of_differentiableOn _ x₁ x₂ y₁ y₂ hc hd


/-! ### Side integrals of the linear reciprocal

The three evaluations below are the primitive computations behind the winding
integral.  On a horizontal segment the imaginary part of `z - w` is constant
and nonzero, so the principal logarithm is a primitive.  On the right vertical
segment the real part is positive; on the left one uses `log (w - z)` instead.
-/

/-- The horizontal side integral of `(z-w)⁻¹`. -/
theorem integral_inv_horizontal (w : ℂ) {x₁ x₂ y : ℝ} (hy : y ≠ w.im) :
    (∫ x : ℝ in x₁..x₂, ((x : ℂ) + (y : ℂ) * I - w)⁻¹)
      = Complex.log ((x₂ : ℂ) + (y : ℂ) * I - w)
        - Complex.log ((x₁ : ℂ) + (y : ℂ) * I - w) := by
  have him : ∀ x : ℝ, ((x : ℂ) + (y : ℂ) * I - w).im = y - w.im := by
    intro x
    simp
  have hne : ∀ x : ℝ, ((x : ℂ) + (y : ℂ) * I - w) ≠ 0 := by
    intro x h0
    have h := him x
    rw [h0] at h
    simp at h
    exact (sub_ne_zero.mpr hy) h.symm
  have hmem : ∀ x : ℝ, ((x : ℂ) + (y : ℂ) * I - w) ∈ Complex.slitPlane := by
    intro x
    show 0 < ((x : ℂ) + (y : ℂ) * I - w).re
      ∨ ((x : ℂ) + (y : ℂ) * I - w).im ≠ 0
    exact Or.inr ((him x).trans_ne (sub_ne_zero.mpr hy))
  have hderiv : ∀ x ∈ uIcc x₁ x₂,
      HasDerivAt (fun t : ℝ => Complex.log ((t : ℂ) + (y : ℂ) * I - w))
        (((x : ℂ) + (y : ℂ) * I - w)⁻¹) x := by
    intro x _hx
    have hφ : HasDerivAt (fun t : ℝ => ((t : ℂ) + (y : ℂ) * I - w)) 1 x := by
      simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const ((y : ℂ) * I - w)
    have hcomp := (Complex.hasDerivAt_log (hmem x)).scomp x hφ
    simpa [Function.comp_def] using hcomp
  have hcont : ContinuousOn (fun x : ℝ => ((x : ℂ) + (y : ℂ) * I - w)⁻¹) (uIcc x₁ x₂) := by
    apply ContinuousOn.inv₀
    · exact ((continuous_ofReal.add continuous_const).sub continuous_const).continuousOn
    · intro x _
      exact hne x
  exact intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable

/-- The right vertical side integral of `(z-w)⁻¹`, for `re w < x`. -/
theorem integral_inv_vertical (w : ℂ) {y₁ y₂ x : ℝ} (hx : w.re < x) :
    (∫ y : ℝ in y₁..y₂, ((x : ℂ) + (y : ℂ) * I - w)⁻¹)
      = -I * (Complex.log ((x : ℂ) + (y₂ : ℂ) * I - w)
          - Complex.log ((x : ℂ) + (y₁ : ℂ) * I - w)) := by
  have hre : ∀ y : ℝ, ((x : ℂ) + (y : ℂ) * I - w).re = x - w.re := by
    intro y
    simp
  have hne : ∀ y : ℝ, ((x : ℂ) + (y : ℂ) * I - w) ≠ 0 := by
    intro y h0
    have h := hre y
    rw [h0] at h
    simp at h
    exact (sub_ne_zero.mpr (ne_of_gt hx)) h.symm
  have hmem : ∀ y : ℝ, ((x : ℂ) + (y : ℂ) * I - w) ∈ Complex.slitPlane := by
    intro y
    show 0 < ((x : ℂ) + (y : ℂ) * I - w).re
      ∨ ((x : ℂ) + (y : ℂ) * I - w).im ≠ 0
    refine Or.inl ?_
    rw [hre y]
    exact sub_pos.mpr hx
  have hderiv : ∀ y ∈ uIcc y₁ y₂,
      HasDerivAt (fun t : ℝ => -I * Complex.log ((x : ℂ) + (t : ℂ) * I - w))
        (((x : ℂ) + (y : ℂ) * I - w)⁻¹) y := by
    intro y _hy
    have hφ : HasDerivAt (fun t : ℝ => ((x : ℂ) + (t : ℂ) * I - w)) I y := by
      have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
        (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
      have h2 := h1.const_add ((x : ℂ) - w)
      simpa [mul_one, sub_eq_add_neg, add_comm, add_left_comm, add_assoc] using h2
    have hcomp := (Complex.hasDerivAt_log (hmem y)).scomp y hφ
    have hmul := hcomp.const_mul (-I)
    have hder : -(I * (I * ((x : ℂ) + (y : ℂ) * I - w)⁻¹))
        = ((x : ℂ) + (y : ℂ) * I - w)⁻¹ := by
      rw [← mul_assoc, Complex.I_mul_I]
      simp
    simpa [Function.comp_def, hder] using hmul
  have hcont : ContinuousOn (fun y : ℝ => ((x : ℂ) + (y : ℂ) * I - w)⁻¹) (uIcc y₁ y₂) := by
    apply ContinuousOn.inv₀
    · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub
        continuous_const).continuousOn
    · intro y _
      exact hne y
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable]
  ring

/-- The left vertical side integral of `(z-w)⁻¹`, for `x < re w`, using the
branch `log (w - z)`. -/
theorem integral_inv_vertical_left (w : ℂ) {y₁ y₂ x : ℝ} (hx : x < w.re) :
    (∫ y : ℝ in y₁..y₂, ((x : ℂ) + (y : ℂ) * I - w)⁻¹)
      = -I * (Complex.log (w - ((x : ℂ) + (y₂ : ℂ) * I))
          - Complex.log (w - ((x : ℂ) + (y₁ : ℂ) * I))) := by
  have hre : ∀ y : ℝ, (w - ((x : ℂ) + (y : ℂ) * I)).re = w.re - x := by
    intro y
    simp
  have hne : ∀ y : ℝ, (w - ((x : ℂ) + (y : ℂ) * I)) ≠ 0 := by
    intro y h0
    have h := hre y
    rw [h0] at h
    simp at h
    exact (sub_ne_zero.mpr (ne_of_gt hx)) h.symm
  have hmem : ∀ y : ℝ, (w - ((x : ℂ) + (y : ℂ) * I)) ∈ Complex.slitPlane := by
    intro y
    show 0 < (w - ((x : ℂ) + (y : ℂ) * I)).re
      ∨ (w - ((x : ℂ) + (y : ℂ) * I)).im ≠ 0
    refine Or.inl ?_
    rw [hre y]
    exact sub_pos.mpr hx
  have hderiv : ∀ y ∈ uIcc y₁ y₂,
      HasDerivAt (fun t : ℝ => -I * Complex.log (w - ((x : ℂ) + (t : ℂ) * I)))
        (((x : ℂ) + (y : ℂ) * I - w)⁻¹) y := by
    intro y _hy
    have hφ : HasDerivAt (fun t : ℝ => w - ((x : ℂ) + (t : ℂ) * I)) (-I) y := by
      have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
        (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
      have h2 := h1.const_add ((x : ℂ))
      have h3 : HasDerivAt (fun t : ℝ => w - ((x : ℂ) + (t : ℂ) * I)) (-(1 * I)) y :=
        h2.const_sub w
      simpa using h3
    have hcomp := (Complex.hasDerivAt_log (hmem y)).scomp y hφ
    have hmul := hcomp.const_mul (-I)
    have hgoal : I * (I * (w - ((x : ℂ) + (y : ℂ) * I))⁻¹)
        = ((x : ℂ) + (y : ℂ) * I - w)⁻¹ := by
      calc I * (I * (w - ((x : ℂ) + (y : ℂ) * I))⁻¹)
          = (I * I) * (w - ((x : ℂ) + (y : ℂ) * I))⁻¹ := by ring
        _ = (-1 : ℂ) * (w - ((x : ℂ) + (y : ℂ) * I))⁻¹ := by rw [Complex.I_mul_I]
        _ = -(w - ((x : ℂ) + (y : ℂ) * I))⁻¹ := by rw [neg_one_mul]
        _ = (-(w - ((x : ℂ) + (y : ℂ) * I)))⁻¹ := by rw [neg_inv]
        _ = ((x : ℂ) + (y : ℂ) * I - w)⁻¹ := by congr 1; ring
    simpa [Function.comp_def, hgoal] using hmul
  have hcont : ContinuousOn (fun y : ℝ => ((x : ℂ) + (y : ℂ) * I - w)⁻¹) (uIcc y₁ y₂) := by
    apply ContinuousOn.inv₀
    · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub
        continuous_const).continuousOn
    · intro y _
      intro h0
      have h := hre y
      -- h0 : x + yI - w = 0; then w - (x+yI) = 0
      have hw : w - ((x : ℂ) + (y : ℂ) * I) = 0 := by
        have hzw : ((x : ℂ) + (y : ℂ) * I) = w := sub_eq_zero.mp h0
        rw [hzw, sub_self]
      exact hne y hw
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hcont.intervalIntegrable]
  ring


/-! ### Branch values of `log (-q)`

The principal logarithm satisfies `log (-q) = log q - πi` when `Im q > 0` and
`log (-q) = log q + πi` when `Im q < 0`; these are the branch corrections
that make the winding integral come out as `2πi`. -/

theorem log_neg_of_im_pos {q : ℂ} (hq : 0 < q.im) :
    Complex.log (-q) = Complex.log q - (Real.pi : ℂ) * I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_neg]
  · simp [Complex.log_im, Complex.arg_neg_eq_arg_sub_pi_of_im_pos hq]

theorem log_neg_of_im_neg {q : ℂ} (hq : q.im < 0) :
    Complex.log (-q) = Complex.log q + (Real.pi : ℂ) * I := by
  apply Complex.ext
  · simp [Complex.log_re, norm_neg]
  · simp [Complex.log_im, Complex.arg_neg_eq_arg_add_pi_of_im_neg hq]

theorem log_sub_log_neg_of_im_pos {q : ℂ} (hq : 0 < q.im) :
    Complex.log q - Complex.log (-q) = (Real.pi : ℂ) * I := by
  rw [log_neg_of_im_pos hq]
  ring

theorem log_neg_sub_log_of_im_neg {q : ℂ} (hq : q.im < 0) :
    Complex.log (-q) - Complex.log q = (Real.pi : ℂ) * I := by
  rw [log_neg_of_im_neg hq]
  ring

/-- **The winding integral, inside case**: for `w` strictly inside the
rectangle the boundary integral of `(z-w)⁻¹` is `2πi`. -/
theorem rectIntegral_inv_of_mem (w : ℂ) {x₁ x₂ y₁ y₂ : ℝ}
    (hx₁ : x₁ < w.re) (hx₂ : w.re < x₂) (hy₁ : y₁ < w.im) (hy₂ : w.im < y₂) :
    rectIntegral (fun z => (z - w)⁻¹) x₁ x₂ y₁ y₂ = 2 * (Real.pi : ℂ) * I := by
  have hb := integral_inv_horizontal w (x₁ := x₁) (x₂ := x₂) (y := y₁) (ne_of_lt hy₁)
  have ht := integral_inv_horizontal w (x₁ := x₁) (x₂ := x₂) (y := y₂) (ne_of_gt hy₂)
  have hr := integral_inv_vertical w (y₁ := y₁) (y₂ := y₂) (x := x₂) hx₂
  have hl := integral_inv_vertical_left w (y₁ := y₁) (y₂ := y₂) (x := x₁) hx₁
  simp only [rectIntegral, hb, ht, hr, hl]
  have hI : ∀ z : ℂ, I * (-I * z) = z := by
    intro z
    rw [← mul_assoc, mul_neg, Complex.I_mul_I]
    simp
  have hw₂ : w - ((x₁ : ℂ) + (y₂ : ℂ) * I) = -((x₁ : ℂ) + (y₂ : ℂ) * I - w) := by ring
  have hw₁ : w - ((x₁ : ℂ) + (y₁ : ℂ) * I) = -((x₁ : ℂ) + (y₁ : ℂ) * I - w) := by ring
  rw [hw₂, hw₁]
  simp only [hI]
  have hp₂ : 0 < (((x₁ : ℂ) + (y₂ : ℂ) * I - w)).im := by
    simp
    linarith
  have hp₁ : (((x₁ : ℂ) + (y₁ : ℂ) * I - w)).im < 0 := by
    simp
    linarith
  have h₁ := log_sub_log_neg_of_im_pos hp₂
  have h₂ := log_neg_sub_log_of_im_neg hp₁
  linear_combination h₁ + h₂


/-- **The winding integral, outside case**: for `w` outside the closed
rectangle the reciprocal `(z-w)⁻¹` is differentiable on a neighbourhood of the
rectangle, so Cauchy–Goursat gives boundary integral `0`. -/
theorem rectIntegral_inv_of_not_mem (w : ℂ) {x₁ x₂ y₁ y₂ : ℝ}
    (hw : w ∉ ([[x₁, x₂]] ×ℂ [[y₁, y₂]])) :
    rectIntegral (fun z => (z - w)⁻¹) x₁ x₂ y₁ y₂ = 0 := by
  have hc : ContinuousOn (fun z : ℂ => (z - w)⁻¹) ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz
      exact sub_ne_zero.mpr (fun h => hw (h ▸ hz))
  have hclosed : ∀ z ∈ (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂)),
      z ∈ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨Ioo_subset_Icc_self hz.1, Ioo_subset_Icc_self hz.2⟩
  have hd : DifferentiableOn ℂ (fun z : ℂ => (z - w)⁻¹)
      (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂)) := by
    apply DifferentiableOn.inv
    · exact (differentiable_id.sub_const w).differentiableOn
    · intro z hz
      exact sub_ne_zero.mpr (fun h => hw (h ▸ hclosed z hz))
  exact rectIntegral_eq_zero_of_differentiableOn _ x₁ x₂ y₁ y₂ hc hd


/-! ### The boundary set of a rectangle

The four side integrals only see values on the boundary.  Working with the
boundary set (rather than the closed rectangle) mirrors the circle case, where
the integral only sees the sphere, and is what lets the argument principle
treat roots strictly inside without evaluating at them. -/

/-- The boundary of the rectangle `[x₁,x₂] × [y₁,y₂]`: the points of the
closed rectangle lying on one of its four sides. -/
def rectBoundarySet (x₁ x₂ y₁ y₂ : ℝ) : Set ℂ :=
  {z | z ∈ ([[x₁, x₂]] ×ℂ [[y₁, y₂]])
    ∧ (z.re = x₁ ∨ z.re = x₂ ∨ z.im = y₁ ∨ z.im = y₂)}

theorem mem_rectBoundarySet_horizontal {x₁ x₂ y₁ y₂ x : ℝ} (hx : x ∈ [[x₁, x₂]]) :
    ((x : ℂ) + (y₁ : ℂ) * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
  refine ⟨?_, Or.inr (Or.inr (Or.inl (by simp)))⟩
  rw [Complex.mem_reProdIm]
  exact ⟨by simpa using hx, by simp⟩

theorem mem_rectBoundarySet_horizontal' {x₁ x₂ y₁ y₂ x : ℝ} (hx : x ∈ [[x₁, x₂]]) :
    ((x : ℂ) + (y₂ : ℂ) * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
  refine ⟨?_, Or.inr (Or.inr (Or.inr (by simp)))⟩
  rw [Complex.mem_reProdIm]
  exact ⟨by simpa using hx, by simp⟩

theorem mem_rectBoundarySet_vertical {x₁ x₂ y₁ y₂ y : ℝ} (hy : y ∈ [[y₁, y₂]]) :
    ((x₂ : ℂ) + (y : ℂ) * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
  refine ⟨?_, Or.inr (Or.inl (by simp))⟩
  rw [Complex.mem_reProdIm]
  exact ⟨by simp, by simpa using hy⟩

theorem mem_rectBoundarySet_vertical' {x₁ x₂ y₁ y₂ y : ℝ} (hy : y ∈ [[y₁, y₂]]) :
    ((x₁ : ℂ) + (y : ℂ) * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
  refine ⟨?_, Or.inl (by simp)⟩
  rw [Complex.mem_reProdIm]
  exact ⟨by simp, by simpa using hy⟩

theorem continuousOn_horizontal_boundary {f : ℂ → ℂ} {x₁ x₂ y₁ y₂ : ℝ}
    (hf : ContinuousOn f (rectBoundarySet x₁ x₂ y₁ y₂)) {y : ℝ}
    (hy : y = y₁ ∨ y = y₂) :
    ContinuousOn (fun x : ℝ => f (x + y * I)) [[x₁, x₂]] := by
  have hmap : ∀ x ∈ [[x₁, x₂]], (x + y * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
    intro x hx
    rcases hy with rfl | rfl
    · exact mem_rectBoundarySet_horizontal hx
    · exact mem_rectBoundarySet_horizontal' hx
  exact hf.comp (continuous_ofReal.add continuous_const).continuousOn hmap

theorem continuousOn_vertical_boundary {f : ℂ → ℂ} {x₁ x₂ y₁ y₂ : ℝ}
    (hf : ContinuousOn f (rectBoundarySet x₁ x₂ y₁ y₂)) {x : ℝ}
    (hx : x = x₁ ∨ x = x₂) :
    ContinuousOn (fun y : ℝ => f (x + y * I)) [[y₁, y₂]] := by
  have hmap : ∀ y ∈ [[y₁, y₂]], (x + y * I) ∈ rectBoundarySet x₁ x₂ y₁ y₂ := by
    intro y hy
    rcases hx with rfl | rfl
    · exact mem_rectBoundarySet_vertical' hy
    · exact mem_rectBoundarySet_vertical hy
  exact hf.comp (continuous_const.add (continuous_ofReal.mul continuous_const)).continuousOn hmap

/-- Additivity of the rectangle boundary integral, with continuity required only
on the boundary. -/
theorem rectIntegral_add_boundary (f g : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ)
    (hf : ContinuousOn f (rectBoundarySet x₁ x₂ y₁ y₂))
    (hg : ContinuousOn g (rectBoundarySet x₁ x₂ y₁ y₂)) :
    rectIntegral (fun z => f z + g z) x₁ x₂ y₁ y₂
      = rectIntegral f x₁ x₂ y₁ y₂ + rectIntegral g x₁ x₂ y₁ y₂ := by
  have key : ∀ h : ℂ → ℂ, ContinuousOn h (rectBoundarySet x₁ x₂ y₁ y₂) →
      rectIntegral h x₁ x₂ y₁ y₂
        = (∫ x : ℝ in x₁..x₂, h (x + y₁ * I)) - (∫ x : ℝ in x₁..x₂, h (x + y₂ * I))
          + I * (∫ y : ℝ in y₁..y₂, h (x₂ + y * I))
          - I * (∫ y : ℝ in y₁..y₂, h (x₁ + y * I)) := fun h _ => rfl
  have hb₁ := continuousOn_horizontal_boundary hf (Or.inl rfl)
  have hb₂ := continuousOn_horizontal_boundary hg (Or.inl rfl)
  have ht₁ := continuousOn_horizontal_boundary hf (Or.inr rfl)
  have ht₂ := continuousOn_horizontal_boundary hg (Or.inr rfl)
  have hr₁ := continuousOn_vertical_boundary hf (Or.inr rfl)
  have hr₂ := continuousOn_vertical_boundary hg (Or.inr rfl)
  have hl₁ := continuousOn_vertical_boundary hf (Or.inl rfl)
  have hl₂ := continuousOn_vertical_boundary hg (Or.inl rfl)
  have h1 : (∫ x : ℝ in x₁..x₂, (f (x + y₁ * I) + g (x + y₁ * I)))
      = (∫ x : ℝ in x₁..x₂, f (x + y₁ * I)) + ∫ x : ℝ in x₁..x₂, g (x + y₁ * I) :=
    intervalIntegral.integral_add hb₁.intervalIntegrable hb₂.intervalIntegrable
  have h2 : (∫ x : ℝ in x₁..x₂, (f (x + y₂ * I) + g (x + y₂ * I)))
      = (∫ x : ℝ in x₁..x₂, f (x + y₂ * I)) + ∫ x : ℝ in x₁..x₂, g (x + y₂ * I) :=
    intervalIntegral.integral_add ht₁.intervalIntegrable ht₂.intervalIntegrable
  have h3 : (∫ y : ℝ in y₁..y₂, (f (x₂ + y * I) + g (x₂ + y * I)))
      = (∫ y : ℝ in y₁..y₂, f (x₂ + y * I)) + ∫ y : ℝ in y₁..y₂, g (x₂ + y * I) :=
    intervalIntegral.integral_add hr₁.intervalIntegrable hr₂.intervalIntegrable
  have h4 : (∫ y : ℝ in y₁..y₂, (f (x₁ + y * I) + g (x₁ + y * I)))
      = (∫ y : ℝ in y₁..y₂, f (x₁ + y * I)) + ∫ y : ℝ in y₁..y₂, g (x₁ + y * I) :=
    intervalIntegral.integral_add hl₁.intervalIntegrable hl₂.intervalIntegrable
  simp only [rectIntegral, h1, h2, h3, h4, mul_add]
  ring

/-- The rectangle boundary integral depends only on the values on the boundary
set. -/
theorem rectIntegral_congr_boundary {f g : ℂ → ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (h : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, f z = g z) :
    rectIntegral f x₁ x₂ y₁ y₂ = rectIntegral g x₁ x₂ y₁ y₂ := by
  have hb : EqOn (fun x : ℝ => f (x + y₁ * I)) (fun x : ℝ => g (x + y₁ * I)) [[x₁, x₂]] := by
    intro x hx
    exact h _ (mem_rectBoundarySet_horizontal hx)
  have ht : EqOn (fun x : ℝ => f (x + y₂ * I)) (fun x : ℝ => g (x + y₂ * I)) [[x₁, x₂]] := by
    intro x hx
    exact h _ (mem_rectBoundarySet_horizontal' hx)
  have hr : EqOn (fun y : ℝ => f (x₂ + y * I)) (fun y : ℝ => g (x₂ + y * I)) [[y₁, y₂]] := by
    intro y hy
    exact h _ (mem_rectBoundarySet_vertical hy)
  have hl : EqOn (fun y : ℝ => f (x₁ + y * I)) (fun y : ℝ => g (x₁ + y * I)) [[y₁, y₂]] := by
    intro y hy
    exact h _ (mem_rectBoundarySet_vertical' hy)
  simp only [rectIntegral, intervalIntegral.integral_congr hb, intervalIntegral.integral_congr ht,
    intervalIntegral.integral_congr hr, intervalIntegral.integral_congr hl]

/-- Linearity of the rectangle boundary integral for finite sums, with
continuity only on the boundary. -/
theorem rectIntegral_finset_sum_boundary {ι : Type*} (s : Finset ι) (f : ι → ℂ → ℂ)
    (x₁ x₂ y₁ y₂ : ℝ)
    (hf : ∀ i ∈ s, ContinuousOn (f i) (rectBoundarySet x₁ x₂ y₁ y₂)) :
    rectIntegral (fun z => ∑ i ∈ s, f i z) x₁ x₂ y₁ y₂
      = ∑ i ∈ s, rectIntegral (f i) x₁ x₂ y₁ y₂ := by
  classical
  revert hf
  refine Finset.induction_on s ?base ?step
  · intro hf
    simp [rectIntegral]
  · intro a s ha ih hf
    have hfun : (fun z => ∑ i ∈ insert a s, f i z) = (fun z => f a z + ∑ i ∈ s, f i z) := by
      funext z
      rw [Finset.sum_insert ha]
    rw [hfun, Finset.sum_insert ha]
    have hfa : ContinuousOn (f a) (rectBoundarySet x₁ x₂ y₁ y₂) :=
      hf a (Finset.mem_insert_self a s)
    have hfs : ContinuousOn (fun z => ∑ i ∈ s, f i z) (rectBoundarySet x₁ x₂ y₁ y₂) :=
      continuousOn_finsetSum s (fun i hi => hf i (Finset.mem_insert_of_mem hi))
    rw [rectIntegral_add_boundary (f a) (fun z => ∑ i ∈ s, f i z) x₁ x₂ y₁ y₂ hfa hfs]
    rw [ih (fun i hi => hf i (Finset.mem_insert_of_mem hi))]


/-- **Product count on a rectangle.**  For a finite root set strictly inside
the open rectangle, `∮ d(log ∏(z-w)) = 2πi·#S`. -/
theorem rectIntegral_logDeriv_prod_eq (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ)
    (hS : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂) :
    rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z) x₁ x₂ y₁ y₂
      = (S.card : ℂ) * (2 * (Real.pi : ℂ) * I) := by
  have hz_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, ∀ w ∈ S, z ≠ w := by
    intro z hz w hw hzw
    obtain ⟨h1, h2, h3, h4⟩ := hS w hw
    rcases hz.2 with h | h | h | h
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
  have hcongr : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z = ∑ w ∈ S, (z - w)⁻¹ := by
    intro z hz
    have hne : ∀ w ∈ S, z - w ≠ 0 := by
      intro w hw
      exact sub_ne_zero.mpr (hz_ne z hz w hw)
    have hd : ∀ w ∈ S, DifferentiableAt ℂ (fun y : ℂ => y - w) z := by
      intro w hw
      fun_prop
    have hfun : (fun y : ℂ => ∏ w ∈ S, (y - w)) = ∏ w ∈ S, (fun y : ℂ => y - w) := by
      funext y
      simp [Finset.prod_apply]
    rw [hfun, logDeriv_prod hne hd]
    apply Finset.sum_congr rfl
    intro w hw
    exact logDeriv_sub_const w z (sub_ne_zero.mp (hne w hw))
  have hcont : ∀ w ∈ S, ContinuousOn (fun z : ℂ => (z - w)⁻¹) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    intro w hw
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz
      exact sub_ne_zero.mpr (hz_ne z hz w hw)
  have hInt : rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w)) z)
        x₁ x₂ y₁ y₂
      = rectIntegral (fun z => ∑ w ∈ S, (z - w)⁻¹) x₁ x₂ y₁ y₂ :=
    rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hcongr
  have hsum := rectIntegral_finset_sum_boundary S (fun w z => (z - w)⁻¹)
    x₁ x₂ y₁ y₂ hcont
  rw [hInt, hsum]
  calc ∑ w ∈ S, rectIntegral (fun z => (z - w)⁻¹) x₁ x₂ y₁ y₂
      = ∑ w ∈ S, (2 * (Real.pi : ℂ) * I) := by
        apply Finset.sum_congr rfl
        intro w hw
        obtain ⟨h1, h2, h3, h4⟩ := hS w hw
        exact rectIntegral_inv_of_mem w h1 h2 h3 h4
    _ = (S.card : ℂ) * (2 * (Real.pi : ℂ) * I) := by
        rw [Finset.sum_const, nsmul_eq_mul]


/-- **Divisor-form argument principle on a rectangle.**  If `f = P_Z·P_P⁻¹·h`
with zeros `Z` and poles `P` strictly inside the rectangle and `h`
differentiable and zero-free on an open set containing the closed rectangle,
then `∮ f'/f = 2πi·(#Z − #P)`. -/
theorem rectIntegral_logDeriv_div_prod {h : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (Z P : Finset ℂ) (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : ∀ w ∈ Z, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hP : ∀ w ∈ P, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hh : DifferentiableOn ℂ h U) (hne : ∀ z ∈ U, h z ≠ 0) :
    rectIntegral (fun z => logDeriv
        (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z)
      x₁ x₂ y₁ y₂
      = ((Z.card : ℂ) - (P.card : ℂ)) * (2 * (Real.pi : ℂ) * I) := by
  have hz_neZ : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, ∀ w ∈ Z, z ≠ w := by
    intro z hz w hw hzw
    obtain ⟨h1, h2, h3, h4⟩ := hZ w hw
    rcases hz.2 with h | h | h | h
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
  have hz_neP : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, ∀ w ∈ P, z ≠ w := by
    intro z hz w hw hzw
    obtain ⟨h1, h2, h3, h4⟩ := hP w hw
    rcases hz.2 with h | h | h | h
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
  have hZne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, (∏ w ∈ Z, (z - w)) ≠ 0 := by
    intro z hz
    exact Finset.prod_ne_zero_iff.mpr (fun w hw => sub_ne_zero.mpr (hz_neZ z hz w hw))
  have hPne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, (∏ w ∈ P, (z - w)) ≠ 0 := by
    intro z hz
    exact Finset.prod_ne_zero_iff.mpr (fun w hw => sub_ne_zero.mpr (hz_neP z hz w hw))
  have hhnz : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, h z ≠ 0 :=
    fun z hz => hne z (hsub hz.1)
  have hlog : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z
        = logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z := by
    intro z hz
    have hzZ := hZne z hz
    have hzP := hPne z hz
    have hzh := hhnz z hz
    have hPzd : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ Z, (y - w)) z := by fun_prop
    have hPpd : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ P, (y - w)) z := by fun_prop
    have hinvd : DifferentiableAt ℂ (fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹) z :=
      hPpd.inv hzP
    have hhd : DifferentiableAt ℂ h z :=
      hh.differentiableAt (hU.mem_nhds (hsub hz.1))
    have houter : (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y)
        = ((fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹) * h) := by
      funext y
      rfl
    have hinner : (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹)
        = ((fun y : ℂ => ∏ w ∈ Z, (y - w)) * (fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹)) := by
      funext y
      rfl
    rw [houter]
    rw [logDeriv_mul (f := fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹)
      (g := h) z (mul_ne_zero hzZ (inv_ne_zero hzP)) hzh (hPzd.mul hinvd) hhd]
    rw [hinner]
    rw [logDeriv_mul (f := fun y : ℂ => ∏ w ∈ Z, (y - w))
      (g := fun y : ℂ => (∏ w ∈ P, (y - w))⁻¹) z hzZ (inv_ne_zero hzP) hPzd hinvd]
    rw [logDeriv_inv_comp (f := fun y : ℂ => ∏ w ∈ P, (y - w)) hPpd hzP]
  have hcontZ : ContinuousOn (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)))
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hd : ContinuousOn (deriv (fun y : ℂ => ∏ w ∈ Z, (y - w)))
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hp : ContinuousOn (fun z : ℂ => ∏ w ∈ Z, (z - w))
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hfun : logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        = fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z / (∏ w ∈ Z, (z - w)) := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hd.div hp hZne
  have hcontP : ContinuousOn (logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)))
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hd : ContinuousOn (deriv (fun y : ℂ => ∏ w ∈ P, (y - w)))
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hp : ContinuousOn (fun z : ℂ => ∏ w ∈ P, (z - w))
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hfun : logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))
        = fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z / (∏ w ∈ P, (z - w)) := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hd.div hp hPne
  have hcontH : ContinuousOn (logDeriv h) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hderiv_diff : DifferentiableOn ℂ (deriv h) U := hh.deriv hU
    have hlogd : DifferentiableOn ℂ (logDeriv h) U := by
      have hquot : DifferentiableOn ℂ (fun z : ℂ => deriv h z / h z) U :=
        hderiv_diff.div hh hne
      have hfun : logDeriv h = fun z : ℂ => deriv h z / h z := by
        funext z
        rw [logDeriv_apply]
      rw [hfun]
      exact hquot
    exact hlogd.continuousOn.mono (fun z hz => hsub hz.1)
  have hInt : rectIntegral (fun z => logDeriv
        (fun y : ℂ => (∏ w ∈ Z, (y - w)) * (∏ w ∈ P, (y - w))⁻¹ * h y) z)
        x₁ x₂ y₁ y₂
      = rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z))
        x₁ x₂ y₁ y₂ :=
    rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hlog
  have hsplit : rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
        + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) + logDeriv h z))
        x₁ x₂ y₁ y₂
      = rectIntegral (fun z => ((logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
          + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z + logDeriv h z))
        x₁ x₂ y₁ y₂ := by
    apply rectIntegral_congr_boundary x₁ x₂ y₁ y₂
    intro z hz
    rfl
  have hAdd1 : rectIntegral (fun z => ((logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z + logDeriv h z))
        x₁ x₂ y₁ y₂
      = rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
          + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z) x₁ x₂ y₁ y₂
        + rectIntegral (fun z => logDeriv h z) x₁ x₂ y₁ y₂ :=
    rectIntegral_add_boundary _ _ x₁ x₂ y₁ y₂ (hcontZ.add hcontP.neg) hcontH
  have hsplit2 : rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w))
        + -logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z) x₁ x₂ y₁ y₂
      = rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
          + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)) x₁ x₂ y₁ y₂ := by
    apply rectIntegral_congr_boundary x₁ x₂ y₁ y₂
    intro z hz
    rfl
  have hAdd2 : rectIntegral (fun z => (logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z
        + (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)) x₁ x₂ y₁ y₂
      = rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z) x₁ x₂ y₁ y₂
        + rectIntegral (fun z => (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)
          x₁ x₂ y₁ y₂ :=
    rectIntegral_add_boundary _ _ x₁ x₂ y₁ y₂ hcontZ hcontP.neg
  have hZint : rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ Z, (y - w)) z)
        x₁ x₂ y₁ y₂
      = (Z.card : ℂ) * (2 * (Real.pi : ℂ) * I) :=
    rectIntegral_logDeriv_prod_eq x₁ x₂ y₁ y₂ Z hZ
  have hPint : rectIntegral (fun z => (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)
        x₁ x₂ y₁ y₂
      = -((P.card : ℂ) * (2 * (Real.pi : ℂ) * I)) := by
    have hneg : rectIntegral (fun z => (-logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w))) z)
          x₁ x₂ y₁ y₂
        = -rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z)
            x₁ x₂ y₁ y₂ := by
      simpa only [Pi.neg_apply] using rectIntegral_neg
        (f := fun z : ℂ => logDeriv (fun y : ℂ => ∏ w ∈ P, (y - w)) z) x₁ x₂ y₁ y₂
    rw [hneg, rectIntegral_logDeriv_prod_eq x₁ x₂ y₁ y₂ P hP]
  have hHint : rectIntegral (fun z => logDeriv h z) x₁ x₂ y₁ y₂ = 0 := by
    simpa [logDeriv_apply] using rectIntegral_logDeriv_eq_zero x₁ x₂ y₁ y₂ hU hsub hh hne
  rw [hInt]
  rw [hsplit]
  rw [hAdd1]
  rw [hsplit2]
  rw [hAdd2]
  rw [hZint]
  rw [hPint]
  rw [hHint]
  ring


/-! ### Local factorisation at a simple zero

Mathlib's analytic order machinery gives the local factor `g` at a simple zero:
if `f` is analytic at `w`, `f w = 0` and `f' w ≠ 0`, then `f = (z-w)·g` near
`w` with `g` analytic and `g w ≠ 0`.  This is the input needed to turn an
argument-principle count with an explicit zero set into a count for a function
given only by its zeros. -/

/-- **Local factorisation at a simple zero.** -/
theorem AnalyticAt.exists_eventuallyEq_sub_mul {f : ℂ → ℂ} {w : ℂ}
    (hf : AnalyticAt ℂ f w) (h0 : f w = 0) (h1 : deriv f w ≠ 0) :
    ∃ g : ℂ → ℂ, AnalyticAt ℂ g w ∧ g w ≠ 0
      ∧ f =ᶠ[nhds w] fun z => (z - w) * g z := by
  have hord : analyticOrderAt f w = 1 :=
    hf.analyticOrderAt_eq_one_of_zero_deriv_ne_zero h0 h1
  obtain ⟨g, hg, hg0, hfg⟩ := (hf.analyticOrderAt_eq_natCast (n := 1)).mp hord
  refine ⟨g, hg, hg0, ?_⟩
  filter_upwards [hfg] with z hz
  simpa using hz


/-- **Rectangle Cauchy–Goursat theorem, off a countable set.**  Continuity on
the closed rectangle and complex differentiability on the open rectangle
except at a countable set suffice for a zero boundary integral.  This is the
form needed for quotients that have removable singularities inside. -/
theorem rectIntegral_eq_zero_of_differentiable_on_off_countable (f : ℂ → ℂ)
    (x₁ x₂ y₁ y₂ : ℝ) (s : Set ℂ) (hs : s.Countable)
    (hc : ContinuousOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]]))
    (hd : ∀ z ∈ (Ioo (min x₁ x₂) (max x₁ x₂) ×ℂ Ioo (min y₁ y₂) (max y₁ y₂)) \ s,
      DifferentiableAt ℂ f z) :
    rectIntegral f x₁ x₂ y₁ y₂ = 0 := by
  unfold rectIntegral
  exact Complex.integral_boundary_rect_eq_zero_of_differentiable_on_off_countable
    f ⟨x₁, y₁⟩ ⟨x₂, y₂⟩ s hs hc hd


/-! ### The polynomial with a prescribed simple-root set

For a finite set `S` of points, `polyProd S z = ∏ w ∈ S, (z-w)`.  At a point
`w ∈ S` it factors as `(z-w)·Q` with `Q w = ∏ w' ∈ S.erase w, (w-w')`, which is
nonzero: this is the derivative of `polyProd S` at `w`, and it is what makes
the quotient `f / polyProd S` have a removable singularity at a simple zero
of `f`. -/

/-- The monic polynomial with the finite root set `S`. -/
noncomputable def polyProd (S : Finset ℂ) : ℂ → ℂ := fun z => ∏ w ∈ S, (z - w)

/-- `polyProd S` is the pointwise product of the linear factors. -/
theorem polyProd_eq_prod (S : Finset ℂ) :
    polyProd S = ∏ i ∈ S, (fun z : ℂ => z - i) := by
  funext z
  simp [polyProd, Finset.prod_apply]

/-- The product over a finite set is differentiable. -/
theorem differentiable_polyProd (S : Finset ℂ) : Differentiable ℂ (polyProd S) := by
  rw [polyProd_eq_prod]
  intro z
  apply DifferentiableAt.finsetProd
  intro i hi
  fun_prop

/-- `polyProd S` evaluated at a point of `S`. -/
theorem polyProd_apply (S : Finset ℂ) (z : ℂ) :
    polyProd S z = ∏ w ∈ S, (z - w) := rfl

/-- **Factoring out one root**: at `w ∈ S`, `polyProd S z = (z-w)·Q z` with
`Q z = ∏ w' ∈ S.erase w, (z-w')`. -/
theorem polyProd_eq_mul_erase (S : Finset ℂ) {w : ℂ} (hw : w ∈ S) (z : ℂ) :
    polyProd S z = (z - w) * ∏ w' ∈ S.erase w, (z - w') := by
  rw [polyProd_apply, ← Finset.mul_prod_erase S (fun x => z - x) hw]

/-- **Derivative of the root polynomial at one of its roots**: it is the
product of the differences to the other roots. -/
theorem deriv_polyProd_mem (S : Finset ℂ) {w : ℂ} (hw : w ∈ S) :
    deriv (polyProd S) w = ∏ w' ∈ S.erase w, (w - w') := by
  have hderiv : HasDerivAt (polyProd S)
      (∑ i ∈ S, (∏ j ∈ S.erase i, (w - j)) • (1 : ℂ)) w := by
    rw [polyProd_eq_prod]
    exact HasDerivAt.finsetProd (fun i hi => (hasDerivAt_id w).sub_const i)
  rw [hderiv.deriv]
  rw [Finset.sum_eq_single w]
  · simp
  · intro i hi hne
    have hmem : w ∈ S.erase i := Finset.mem_erase.mpr ⟨Ne.symm hne, hw⟩
    have hzero : (∏ j ∈ S.erase i, (w - j)) = 0 :=
      Finset.prod_eq_zero hmem (sub_self w)
    simp [hzero]
  · intro h
    exact absurd hw h

/-- **The erased product is nonzero**: `S` has no repeated elements, so the
derivative of `polyProd S` does not vanish at a root. -/
theorem prod_erase_ne_zero (S : Finset ℂ) {w : ℂ} (_hw : w ∈ S) :
    (∏ w' ∈ S.erase w, (w - w')) ≠ 0 := by
  apply Finset.prod_ne_zero_iff.mpr
  intro w' hw'
  have hne : w' ≠ w := (Finset.mem_erase.mp hw').1
  exact sub_ne_zero.mpr (Ne.symm hne)


/-! ### The quotient extension at the zero set

Given `f` and a finite set `S` of simple zeros, the quotient `f / polyProd S`
has removable singularities at `S`.  We extend it across `S` by the removable
value `g w / Q w w`, where `g` is the local factor of `f` at the simple zero
and `Q w = ∏ w' ∈ S.erase w, (z-w')`.  The extension is analytic on `U`,
zero-free on `U`, and satisfies `f = polyProd S · q` off `S`. -/

/-- The quotient extension: `f / polyProd S` off `S`, and the removable value
at a point of `S`. -/
noncomputable def quotientExtension (f : ℂ → ℂ) (S : Finset ℂ) : ℂ → ℂ :=
  fun z => if z ∈ S then limUnder (𝓝[≠] z) (fun y => f y / polyProd S y)
    else f z / polyProd S z

theorem quotientExtension_of_not_mem {f : ℂ → ℂ} {S : Finset ℂ} {z : ℂ} (hz : z ∉ S) :
    quotientExtension f S z = f z / polyProd S z := by
  simp [quotientExtension, hz]

theorem polyProd_ne_zero_of_not_mem {S : Finset ℂ} {z : ℂ} (hz : z ∉ S) :
    polyProd S z ≠ 0 := by
  rw [polyProd_apply]
  exact Finset.prod_ne_zero_iff.mpr (fun w hw => sub_ne_zero.mpr (fun h => hz (h ▸ hw)))

/-- The quotient `f / polyProd S` tends, along the punctured neighbourhood of a
root `w ∈ S`, to the removable value `g w / Q w w`. -/
theorem tendsto_div_polyProd {f g : ℂ → ℂ} {S : Finset ℂ} {w : ℂ} (hw : w ∈ S)
    (hfg : f =ᶠ[nhds w] fun z => (z - w) * g z) (hg : ContinuousAt g w) :
    Tendsto (fun y => f y / polyProd S y) (𝓝[≠] w)
      (𝓝 (g w / ∏ w' ∈ S.erase w, (w - w'))) := by
  have hQcont : ContinuousAt (fun y : ℂ => ∏ w' ∈ S.erase w, (y - w')) w := by
    apply Continuous.continuousAt
    exact continuous_finsetProd (S.erase w) (fun i hi => by fun_prop)
  have hQw : (∏ w' ∈ S.erase w, (w - w')) ≠ 0 := prod_erase_ne_zero S hw
  have hcont : ContinuousAt (fun y : ℂ => g y / ∏ w' ∈ S.erase w, (y - w')) w :=
    hg.div hQcont hQw
  have hev : (fun y : ℂ => f y / polyProd S y) =ᶠ[𝓝[≠] w]
      (fun y : ℂ => g y / ∏ w' ∈ S.erase w, (y - w')) := by
    filter_upwards [self_mem_nhdsWithin, hfg.filter_mono nhdsWithin_le_nhds] with y hy hfy
    rw [hfy, polyProd_eq_mul_erase S hw y]
    exact mul_div_mul_left (g y) (∏ w' ∈ S.erase w, (y - w')) (sub_ne_zero.mpr hy)
  exact hcont.tendsto.mono_left nhdsWithin_le_nhds |>.congr' hev.symm

theorem quotientExtension_mem_value {f g : ℂ → ℂ} {S : Finset ℂ} {w : ℂ} (hw : w ∈ S)
    (hfg : f =ᶠ[nhds w] fun z => (z - w) * g z) (hg : ContinuousAt g w) :
    quotientExtension f S w = g w / ∏ w' ∈ S.erase w, (w - w') := by
  rw [quotientExtension, if_pos hw]
  exact (tendsto_div_polyProd hw hfg hg).limUnder_eq

/-- Continuity of the quotient extension at a simple zero. -/
theorem continuousAt_quotientExtension_of_mem {f g : ℂ → ℂ} {S : Finset ℂ} {w : ℂ}
    (hw : w ∈ S) (hfg : f =ᶠ[nhds w] fun z => (z - w) * g z) (hg : ContinuousAt g w) :
    ContinuousAt (quotientExtension f S) w := by
  have hval := quotientExtension_mem_value hw hfg hg
  have htend := tendsto_div_polyProd hw hfg hg
  have hopen : IsOpen (↑(S.erase w) : Set ℂ)ᶜ :=
    (S.erase w).finite_toSet.isClosed.isOpen_compl
  have hcompl : (↑(S.erase w) : Set ℂ)ᶜ ∈ 𝓝[≠] w :=
    nhdsWithin_le_nhds (hopen.mem_nhds (by simp))
  have hev : quotientExtension f S =ᶠ[𝓝[≠] w] fun y => f y / polyProd S y := by
    filter_upwards [self_mem_nhdsWithin, hcompl] with y hy hycomp
    have hyS : y ∉ S := by
      intro hyS
      exact hycomp (Finset.mem_erase.mpr ⟨by simpa using hy, hyS⟩)
    exact quotientExtension_of_not_mem hyS
  rw [continuousAt_iff_punctured_nhds, hval]
  exact htend.congr' hev.symm

/-- Differentiability of the quotient extension away from `S`. -/
theorem differentiableAt_quotientExtension_of_not_mem {f : ℂ → ℂ} {S : Finset ℂ}
    {U : Set ℂ} (hU : IsOpen U) (hf : DifferentiableOn ℂ f U) {z : ℂ}
    (hzS : z ∉ S) (hzU : z ∈ U) :
    DifferentiableAt ℂ (quotientExtension f S) z := by
  have hopen : IsOpen (↑S : Set ℂ)ᶜ := S.finite_toSet.isClosed.isOpen_compl
  have hev : quotientExtension f S =ᶠ[𝓝 z] fun y => f y / polyProd S y := by
    filter_upwards [hopen.mem_nhds (by simpa using hzS)] with y hy
    exact quotientExtension_of_not_mem (by simpa using hy)
  rw [hev.differentiableAt_iff]
  exact (hf.differentiableAt (hU.mem_nhds hzU)).div
    (differentiable_polyProd S z) (polyProd_ne_zero_of_not_mem hzS)

/-- **Analyticity of the quotient extension at a simple zero**, by the
removable singularity theorem: the quotient is differentiable on a punctured
neighbourhood and continuous at the zero. -/
theorem analyticAt_quotientExtension_of_mem {f : ℂ → ℂ} {S : Finset ℂ} {U : Set ℂ}
    (hU : IsOpen U) (hf : DifferentiableOn ℂ f U) {w : ℂ} (hw : w ∈ S) (hwU : w ∈ U)
    (h0 : f w = 0) (h1 : deriv f w ≠ 0) :
    AnalyticAt ℂ (quotientExtension f S) w := by
  obtain ⟨g, hg, hg0, hfg⟩ :=
    AbsoluteHodgeRectangle.AnalyticAt.exists_eventuallyEq_sub_mul (hf.analyticAt (hU.mem_nhds hwU)) h0 h1
  apply Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
  · have hopenU : U ∈ 𝓝[≠] w := nhdsWithin_le_nhds (hU.mem_nhds hwU)
    have hopenS : (↑(S.erase w) : Set ℂ)ᶜ ∈ 𝓝[≠] w :=
      nhdsWithin_le_nhds (((S.erase w).finite_toSet.isClosed.isOpen_compl).mem_nhds (by simp))
    filter_upwards [self_mem_nhdsWithin, hopenU, hopenS] with y hy hyU hyS
    have hyS' : y ∉ S := by
      intro hyS'
      exact hyS (Finset.mem_erase.mpr ⟨by simpa using hy, hyS'⟩)
    exact differentiableAt_quotientExtension_of_not_mem hU hf hyS' hyU
  · exact continuousAt_quotientExtension_of_mem hw hfg hg.continuousAt

/-- The quotient extension is zero-free on `U`. -/
theorem quotientExtension_ne_zero {f : ℂ → ℂ} {S : Finset ℂ} {U : Set ℂ}
    (hU : IsOpen U) (hf : DifferentiableOn ℂ f U)
    (h0 : ∀ w ∈ S, f w = 0) (h1 : ∀ w ∈ S, deriv f w ≠ 0)
    (hno : ∀ z ∈ U, z ∉ S → f z ≠ 0) :
    ∀ z ∈ U, quotientExtension f S z ≠ 0 := by
  intro z hzU
  by_cases hzS : z ∈ S
  · obtain ⟨g, hg, hg0, hfg⟩ :=
      AbsoluteHodgeRectangle.AnalyticAt.exists_eventuallyEq_sub_mul (hf.analyticAt (hU.mem_nhds hzU)) (h0 z hzS) (h1 z hzS)
    rw [quotientExtension_mem_value hzS hfg hg.continuousAt]
    exact div_ne_zero hg0 (prod_erase_ne_zero S hzS)
  · rw [quotientExtension_of_not_mem hzS]
    exact div_ne_zero (hno z hzU hzS) (polyProd_ne_zero_of_not_mem hzS)

/-- The quotient extension is differentiable on `U`. -/
theorem differentiableOn_quotientExtension {f : ℂ → ℂ} {S : Finset ℂ} {U : Set ℂ}
    (hU : IsOpen U) (hf : DifferentiableOn ℂ f U)
    (h0 : ∀ w ∈ S, f w = 0) (h1 : ∀ w ∈ S, deriv f w ≠ 0) :
    DifferentiableOn ℂ (quotientExtension f S) U := by
  intro z hzU
  by_cases hzS : z ∈ S
  · exact (analyticAt_quotientExtension_of_mem hU hf hzS hzU (h0 z hzS) (h1 z hzS)).differentiableAt.differentiableWithinAt
  · exact (differentiableAt_quotientExtension_of_not_mem hU hf hzS hzU).differentiableWithinAt

/-- Off `S`, `f = polyProd S · quotientExtension`. -/
theorem polyProd_mul_quotientExtension {f : ℂ → ℂ} {S : Finset ℂ} {U : Set ℂ}
    (hU : IsOpen U) {z : ℂ} (hzU : z ∈ U) (hzS : z ∉ S) :
    polyProd S z * quotientExtension f S z = f z := by
  rw [quotientExtension_of_not_mem hzS]
  field_simp [polyProd_ne_zero_of_not_mem hzS]


/-- **Argument principle for an analytic function with simple zeros.**  Let
`f` be complex differentiable on an open set `U` containing the closed
rectangle.  Suppose the zeros of `f` in `U` are exactly a finite set `S` of
simple zeros, all strictly inside the rectangle.  Then
`∮ f'/f = 2πi·#S` around the rectangle.

This is the rectangle argument principle in the form needed for `Z'/Z`: the
zero set is not presupposed in the contour integral, only the analytic facts
that the quotient `f / ∏(z-w)` has removable singularities and is zero-free. -/
theorem rectIntegral_logDeriv_eq_card_of_simple_zeros
    {f : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hS_zero : ∀ w ∈ S, f w = 0)
    (hS_simple : ∀ w ∈ S, deriv f w ≠ 0)
    (hno_zero : ∀ z ∈ U, z ∉ S → f z ≠ 0) :
    rectIntegral (fun z => logDeriv f z) x₁ x₂ y₁ y₂
      = (S.card : ℂ) * (2 * (Real.pi : ℂ) * I) := by
  have hS_U : ∀ w ∈ S, w ∈ U := by
    intro w hw
    apply hsub
    rw [Complex.mem_reProdIm]
    obtain ⟨h1, h2, h3, h4⟩ := hS_in w hw
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt h1), le_trans (le_of_lt h2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt h3), le_trans (le_of_lt h4) (le_max_right _ _)⟩⟩
  have hq_diff : DifferentiableOn ℂ (quotientExtension f S) U :=
    differentiableOn_quotientExtension hU hf hS_zero hS_simple
  have hq_ne : ∀ z ∈ U, quotientExtension f S z ≠ 0 :=
    quotientExtension_ne_zero hU hf hS_zero hS_simple hno_zero
  have hbound_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ∉ S := by
    intro z hz hzS
    obtain ⟨h1, h2, h3, h4⟩ := hS_in z hzS
    rcases hz.2 with h | h | h | h
    · linarith
    · linarith
    · linarith
    · linarith
  have hcongr : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv f z = logDeriv (fun y => polyProd S y * quotientExtension f S y) z := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hzS : z ∉ S := hbound_ne z hz
    have hopen : IsOpen (↑S : Set ℂ)ᶜ := S.finite_toSet.isClosed.isOpen_compl
    have hev : f =ᶠ[𝓝 z] fun y => polyProd S y * quotientExtension f S y := by
      filter_upwards [hU.mem_nhds hzU, hopen.mem_nhds (by simpa using hzS)] with y hyU hyS
      exact (polyProd_mul_quotientExtension hU hyU (by simpa using hyS)).symm
    exact (logDeriv_congr_nhds hev).eq_of_nhds
  have h1 : rectIntegral (fun z => logDeriv f z) x₁ x₂ y₁ y₂
      = rectIntegral (fun z => logDeriv (fun y => polyProd S y * quotientExtension f S y) z)
          x₁ x₂ y₁ y₂ :=
    rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hcongr
  have h2 : rectIntegral (fun z => logDeriv (fun y => polyProd S y * quotientExtension f S y) z)
        x₁ x₂ y₁ y₂ = (S.card : ℂ) * (2 * (Real.pi : ℂ) * I) := by
    have hdiv := rectIntegral_logDeriv_div_prod x₁ x₂ y₁ y₂ S ∅ hU hsub hS_in
      (fun w hw => absurd hw (by simp)) hq_diff hq_ne
    have hfun : (fun y : ℂ => (∏ w ∈ S, (y - w)) * (∏ w ∈ (∅ : Finset ℂ), (y - w))⁻¹
          * quotientExtension f S y)
        = (fun y : ℂ => polyProd S y * quotientExtension f S y) := by
      funext y
      simp [polyProd]
    rw [hfun] at hdiv
    simpa using hdiv
  rw [h1, h2]


/-! ### The zero side of the explicit formula for the completed zeta

`g(s) = s(s-1)Z(s)` is entire wherever `Z` is, with the poles of `Z` at `0,1`
removed.  If the zeros of `g` in an open set containing the rectangle are
exactly a finite set `S` of simple zeros, the zero-count theorem applies to
`g`, and the identities `g'/g = 1/s + 1/(s-1) + Z'/Z` and
`∮ dz/(z-w) = 2πi` give the contour count
`∮ Z'/Z = 2πi·(#S - 2)` over the rectangle. -/

/-- **Zero side of the explicit formula**: the rectangle contour integral of
`Z'/Z` equals `2πi` times the number of zeros in the rectangle minus the two
poles. -/
theorem rectIntegral_logDeriv_completedZeta_eq_card
    {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1 : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hg : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hg_zero : ∀ s ∈ U, (s * (s - 1) * completedZeta s = 0 ↔ s ∈ S))
    (hg_simple : ∀ w ∈ S,
      deriv (fun s : ℂ => s * (s - 1) * completedZeta s) w ≠ 0) :
    rectIntegral (fun s => logDeriv completedZeta s) x₁ x₂ y₁ y₂
      = ((S.card : ℂ) - 2) * (2 * (Real.pi : ℂ) * I) := by
  have hS_U : ∀ w ∈ S, w ∈ U := by
    intro w hw
    apply hsub
    rw [Complex.mem_reProdIm]
    obtain ⟨h1', h2', h3', h4'⟩ := hS_in w hw
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt h1'), le_trans (le_of_lt h2') (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt h3'), le_trans (le_of_lt h4') (le_max_right _ _)⟩⟩
  have hg_zero' : ∀ w ∈ S, w * (w - 1) * completedZeta w = 0 :=
    fun w hw => (hg_zero w (hS_U w hw)).mpr hw
  have hg_no : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0 := by
    intro z hzU hzS hgz
    exact hzS ((hg_zero z hzU).mp hgz)
  have hzero := rectIntegral_logDeriv_eq_card_of_simple_zeros x₁ x₂ y₁ y₂ S hU hsub
    hg hS_in hg_zero' hg_simple hg_no
  have hbound_neS : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ∉ S := by
    intro z hz hzS
    obtain ⟨h1', h2', h3', h4'⟩ := hS_in z hzS
    rcases hz.2 with h | h | h | h
    · linarith
    · linarith
    · linarith
    · linarith
  have hb_ne0 : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ 0 := by
    intro z hz h
    rcases hz.2 with hh | hh | hh | hh
    · rw [h] at hh; simp at hh; linarith [h0.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.2.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.2.2]
  have hb_ne1 : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ 1 := by
    intro z hz h
    rcases hz.2 with hh | hh | hh | hh
    · rw [h] at hh; simp at hh; linarith [h1.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.2.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.2.2]
  have hZne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, completedZeta z ≠ 0 := by
    intro z hz hZ0
    have hgz : z * (z - 1) * completedZeta z = 0 := by rw [hZ0, mul_zero]
    exact hbound_neS z hz ((hg_zero z (hsub hz.1)).mp hgz)
  have hcontId : ContinuousOn (logDeriv (fun s : ℂ => s)) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hfun : logDeriv (fun s : ℂ => s) = fun s : ℂ => s⁻¹ := by
      funext s
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact ContinuousOn.inv₀ continuous_id.continuousOn (fun z hz => hb_ne0 z hz)
  have hcontShift : ContinuousOn (logDeriv (fun s : ℂ => s - 1))
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hfun : logDeriv (fun s : ℂ => s - 1) = fun s : ℂ => (s - 1)⁻¹ := by
      funext s
      rw [logDeriv_apply]
      simp
    rw [hfun]
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz h
      exact hb_ne1 z hz (sub_eq_zero.mp h)
  have hcontZ : ContinuousOn (logDeriv completedZeta) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hzS : z ∉ S := hbound_neS z hz
    have hZd : DifferentiableAt ℂ completedZeta z := hZ.differentiableAt (hU.mem_nhds hzU)
    have hderivd : DifferentiableAt ℂ (deriv completedZeta) z :=
      (hZ.deriv hU).differentiableAt (hU.mem_nhds hzU)
    have hlogd : DifferentiableAt ℂ (logDeriv completedZeta) z := by
      have hfun : logDeriv completedZeta = fun w : ℂ => deriv completedZeta w / completedZeta w := by
        funext w
        rw [logDeriv_apply]
      rw [hfun]
      exact hderivd.div hZd (hZne z hz)
    exact hlogd.continuousAt.continuousWithinAt
  have hlog : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
        = logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z
          + logDeriv completedZeta z := by
    intro z hz
    have hz0 := hb_ne0 z hz
    have hz1 := hb_ne1 z hz
    have hzU : z ∈ U := hsub hz.1
    have hzZ := hZne z hz
    have hZd : DifferentiableAt ℂ completedZeta z := hZ.differentiableAt (hU.mem_nhds hzU)
    have hd1 : DifferentiableAt ℂ (fun s : ℂ => s) z := differentiableAt_id
    have hd2 : DifferentiableAt ℂ (fun s : ℂ => s - 1) z := by fun_prop
    have hfun : (fun s : ℂ => s * (s - 1) * completedZeta s)
        = ((fun s : ℂ => s) * (fun s : ℂ => s - 1)) * completedZeta := rfl
    rw [hfun]
    have hfne : ((fun s : ℂ => s) * (fun s : ℂ => s - 1)) z ≠ 0 :=
      mul_ne_zero hz0 (sub_ne_zero.mpr hz1)
    rw [logDeriv_mul (f := (fun s : ℂ => s) * (fun s : ℂ => s - 1))
      (g := completedZeta) z hfne hzZ (hd1.mul hd2) hZd]
    rw [logDeriv_mul (f := fun s : ℂ => s) (g := fun s : ℂ => s - 1) z hz0
      (sub_ne_zero.mpr hz1) hd1 hd2]
  have hInt : rectIntegral
        (fun z => logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z)
        x₁ x₂ y₁ y₂
      = (rectIntegral (fun z => logDeriv (fun s : ℂ => s) z) x₁ x₂ y₁ y₂)
        + (rectIntegral (fun z => logDeriv (fun s : ℂ => s - 1) z) x₁ x₂ y₁ y₂)
        + rectIntegral (fun z => logDeriv completedZeta z) x₁ x₂ y₁ y₂ := by
    have hcongr : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
        logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
          = (logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z)
              + logDeriv completedZeta z := by
      intro z hz
      simpa only [Pi.add_apply] using hlog z hz
    have hstep := rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hcongr
    rw [hstep]
    rw [rectIntegral_add_boundary
      (fun z => logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z)
      (fun z => logDeriv completedZeta z) x₁ x₂ y₁ y₂ (hcontId.add hcontShift) hcontZ]
    rw [rectIntegral_add_boundary (fun z => logDeriv (fun s : ℂ => s) z)
      (fun z => logDeriv (fun s : ℂ => s - 1) z) x₁ x₂ y₁ y₂ hcontId hcontShift]
  have hIntId : rectIntegral (fun z => logDeriv (fun s : ℂ => s) z) x₁ x₂ y₁ y₂
      = 2 * (Real.pi : ℂ) * I := by
    have hfun : (fun z : ℂ => logDeriv (fun s : ℂ => s) z) = fun z : ℂ => (z - 0)⁻¹ := by
      funext z
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact rectIntegral_inv_of_mem 0 h0.1 h0.2.1 h0.2.2.1 h0.2.2.2
  have hIntShift : rectIntegral (fun z => logDeriv (fun s : ℂ => s - 1) z)
        x₁ x₂ y₁ y₂ = 2 * (Real.pi : ℂ) * I := by
    have hfun : (fun z : ℂ => logDeriv (fun s : ℂ => s - 1) z)
        = fun z : ℂ => (z - 1)⁻¹ := by
      funext z
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact rectIntegral_inv_of_mem 1 h1.1 h1.2.1 h1.2.2.1 h1.2.2.2
  rw [hInt] at hzero
  rw [hIntId, hIntShift] at hzero
  linear_combination hzero


/-- Multiplication of the rectangle boundary integral by a constant. -/
theorem rectIntegral_const_mul (c : ℂ) (f : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ) :
    rectIntegral (fun z => c * f z) x₁ x₂ y₁ y₂ = c * rectIntegral f x₁ x₂ y₁ y₂ := by
  simp only [rectIntegral, intervalIntegral.integral_const_mul]
  ring

/-- **Argument principle with multiplicities.**  Suppose `f = P·q` on the open
set `U` off a finite set `S`, where `P z = ∏ w ∈ S, (z-w)^(m w)` and `q` is
differentiable and zero-free on `U`.  Then
`∮ f'/f = 2πi · ∑ w ∈ S, m w` around the rectangle.

This is the multiplicity form of the zero count: the hypotheses encode the
divisor of `f` on `U`, and no simplicity of the zeros is assumed. -/
theorem rectIntegral_logDeriv_eq_sum_multiplicity
    {f q : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U) (hq : DifferentiableOn ℂ q U)
    (hq_ne : ∀ z ∈ U, q z ≠ 0)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hfac : ∀ z ∈ U, z ∉ S → f z = (∏ w ∈ S, (z - w) ^ m w) * q z) :
    rectIntegral (fun z => logDeriv f z) x₁ x₂ y₁ y₂
      = (∑ w ∈ S, (m w : ℂ)) * (2 * (Real.pi : ℂ) * I) := by
  have hz_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, ∀ w ∈ S, z ≠ w := by
    intro z hz w hw hzw
    obtain ⟨h1', h2', h3', h4'⟩ := hS_in w hw
    rcases hz.2 with h | h | h | h
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
    · rw [hzw] at h; linarith
  have hPne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, (∏ w ∈ S, (z - w) ^ m w) ≠ 0 := by
    intro z hz
    apply Finset.prod_ne_zero_iff.mpr
    intro w hw
    exact pow_ne_zero _ (sub_ne_zero.mpr (hz_ne z hz w hw))
  -- pointwise log-derivative of the polynomial part
  have hlogP : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) z
        = ∑ w ∈ S, (m w : ℂ) * (z - w)⁻¹ := by
    intro z hz
    have hne : ∀ w ∈ S, (z - w) ^ m w ≠ 0 := by
      intro w hw
      exact pow_ne_zero _ (sub_ne_zero.mpr (hz_ne z hz w hw))
    have hd : ∀ w ∈ S, DifferentiableAt ℂ (fun y : ℂ => (y - w) ^ m w) z := by
      intro w hw
      fun_prop
    have hfun : (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w)
        = ∏ w ∈ S, (fun y : ℂ => (y - w) ^ m w) := by
      funext y
      simp [Finset.prod_apply]
    rw [hfun, logDeriv_prod hne hd]
    apply Finset.sum_congr rfl
    intro w hw
    rw [logDeriv_fun_pow (f := fun y : ℂ => y - w) (by fun_prop) (m w)]
    rw [logDeriv_sub_const w z (hz_ne z hz w hw)]
  have hcontP : ContinuousOn (logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w))
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hd : ContinuousOn (deriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w))
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hp : ContinuousOn (fun z : ℂ => ∏ w ∈ S, (z - w) ^ m w)
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      fun_prop
    have hfun : logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w)
        = fun z : ℂ => deriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) z
            / (∏ w ∈ S, (z - w) ^ m w) := by
      funext z
      rw [logDeriv_apply]
    rw [hfun]
    exact hd.div hp hPne
  have hcontQ : ContinuousOn (logDeriv q) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hderiv : DifferentiableOn ℂ (deriv q) U := hq.deriv hU
    have hlogd : DifferentiableOn ℂ (logDeriv q) U := by
      have hquot : DifferentiableOn ℂ (fun z : ℂ => deriv q z / q z) U :=
        hderiv.div hq hq_ne
      have hfun : logDeriv q = fun z : ℂ => deriv q z / q z := by
        funext z
        rw [logDeriv_apply]
      rw [hfun]
      exact hquot
    exact hlogd.continuousOn.mono (fun z hz => hsub hz.1)
  -- the polynomial contour integral
  have hIntP : rectIntegral (fun z => logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) z)
        x₁ x₂ y₁ y₂ = (∑ w ∈ S, (m w : ℂ)) * (2 * (Real.pi : ℂ) * I) := by
    have hstep := rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hlogP
    rw [hstep]
    have hcontTerm : ∀ w ∈ S, ContinuousOn (fun z : ℂ => (m w : ℂ) * (z - w)⁻¹)
        (rectBoundarySet x₁ x₂ y₁ y₂) := by
      intro w hw
      apply ContinuousOn.const_mul
      apply ContinuousOn.inv₀
      · exact (continuous_id.sub continuous_const).continuousOn
      · intro z hz
        exact sub_ne_zero.mpr (hz_ne z hz w hw)
    have hsum := rectIntegral_finset_sum_boundary S
      (fun w z => (m w : ℂ) * (z - w)⁻¹) x₁ x₂ y₁ y₂ hcontTerm
    rw [hsum]
    calc ∑ w ∈ S, rectIntegral (fun z => (m w : ℂ) * (z - w)⁻¹) x₁ x₂ y₁ y₂
        = ∑ w ∈ S, (m w : ℂ) * (2 * (Real.pi : ℂ) * I) := by
          apply Finset.sum_congr rfl
          intro w hw
          rw [rectIntegral_const_mul]
          rw [rectIntegral_inv_of_mem w (hS_in w hw).1 (hS_in w hw).2.1
            (hS_in w hw).2.2.1 (hS_in w hw).2.2.2]
      _ = (∑ w ∈ S, (m w : ℂ)) * (2 * (Real.pi : ℂ) * I) := by
          rw [Finset.sum_mul]
  -- pointwise splitting of the log-derivative
  have hbound_neS : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ∉ S := by
    intro z hz hzS
    exact hz_ne z hz z hzS rfl
  have hsplit : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv f z = logDeriv (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) z + logDeriv q z := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hzS : z ∉ S := hbound_neS z hz
    have hopen : IsOpen (↑S : Set ℂ)ᶜ := S.finite_toSet.isClosed.isOpen_compl
    have hev : f =ᶠ[𝓝 z] fun y => (∏ w ∈ S, (y - w) ^ m w) * q y := by
      filter_upwards [hU.mem_nhds hzU, hopen.mem_nhds (by simpa using hzS)] with y hyU hyS
      exact hfac y hyU (by simpa using hyS)
    rw [(logDeriv_congr_nhds hev).eq_of_nhds]
    have hPd : DifferentiableAt ℂ (fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) z := by
      fun_prop
    have hqd : DifferentiableAt ℂ q z := hq.differentiableAt (hU.mem_nhds hzU)
    exact logDeriv_mul (f := fun y : ℂ => ∏ w ∈ S, (y - w) ^ m w) (g := q) z
      (hPne z hz) (hq_ne z hzU) hPd hqd
  have hstep := rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hsplit
  rw [hstep]
  rw [rectIntegral_add_boundary _ _ x₁ x₂ y₁ y₂ hcontP hcontQ]
  rw [hIntP]
  have hIntQ : rectIntegral (fun z => logDeriv q z) x₁ x₂ y₁ y₂ = 0 :=
    rectIntegral_logDeriv_eq_zero x₁ x₂ y₁ y₂ hU hsub hq hq_ne
  rw [hIntQ, add_zero]


/-- **Zero side of the explicit formula with multiplicities.**  If
`g(s) = s(s-1)Z(s)` factors on `U` off a finite set `S` as
`g = (∏ w ∈ S, (s-w)^(m w)) · q` with `q` differentiable and zero-free on `U`,
then `∮ Z'/Z = 2πi·(∑ m - 2)` over the rectangle, the two poles at `0,1`
contributing `-2`.  No simplicity of the zeros is assumed: `m w` is the
multiplicity of the zero `w`. -/
theorem rectIntegral_logDeriv_completedZeta_eq_sum
    {U : Set ℂ} {q : ℂ → ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1 : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hg : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hq : DifferentiableOn ℂ q U) (hq_ne : ∀ z ∈ U, q z ≠ 0)
    (hfac : ∀ z ∈ U, z ∉ S →
      z * (z - 1) * completedZeta z = (∏ w ∈ S, (z - w) ^ m w) * q z) :
    rectIntegral (fun s => logDeriv completedZeta s) x₁ x₂ y₁ y₂
      = ((∑ w ∈ S, (m w : ℂ)) - 2) * (2 * (Real.pi : ℂ) * I) := by
  have hzero := rectIntegral_logDeriv_eq_sum_multiplicity x₁ x₂ y₁ y₂ S m hU hsub
    hg hq hq_ne hS_in hfac
  have hbound_neS : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ∉ S := by
    intro z hz hzS
    obtain ⟨h1', h2', h3', h4'⟩ := hS_in z hzS
    rcases hz.2 with h | h | h | h
    · linarith
    · linarith
    · linarith
    · linarith
  have hb_ne0 : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ 0 := by
    intro z hz h
    rcases hz.2 with hh | hh | hh | hh
    · rw [h] at hh; simp at hh; linarith [h0.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.2.1]
    · rw [h] at hh; simp at hh; linarith [h0.2.2.2]
  have hb_ne1 : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ 1 := by
    intro z hz h
    rcases hz.2 with hh | hh | hh | hh
    · rw [h] at hh; simp at hh; linarith [h1.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.2.1]
    · rw [h] at hh; simp at hh; linarith [h1.2.2.2]
  have hPne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, (∏ w ∈ S, (z - w) ^ m w) ≠ 0 := by
    intro z hz
    apply Finset.prod_ne_zero_iff.mpr
    intro w hw
    exact pow_ne_zero _ (sub_ne_zero.mpr (by
      intro hzw
      have := (hS_in w hw)
      rcases hz.2 with h | h | h | h
      · rw [hzw] at h; linarith [this.1]
      · rw [hzw] at h; linarith [this.2.1]
      · rw [hzw] at h; linarith [this.2.2.1]
      · rw [hzw] at h; linarith [this.2.2.2]))
  have hg_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      z * (z - 1) * completedZeta z ≠ 0 := by
    intro z hz hgz
    have hzS : z ∉ S := hbound_neS z hz
    have hzU : z ∈ U := hsub hz.1
    rw [hfac z hzU hzS] at hgz
    exact mul_ne_zero (hPne z hz) (hq_ne z hzU) hgz
  have hZne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, completedZeta z ≠ 0 := by
    intro z hz hZ0
    exact hg_ne z hz (by rw [hZ0, mul_zero])
  have hcontId : ContinuousOn (logDeriv (fun s : ℂ => s)) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hfun : logDeriv (fun s : ℂ => s) = fun s : ℂ => s⁻¹ := by
      funext s
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact ContinuousOn.inv₀ continuous_id.continuousOn (fun z hz => hb_ne0 z hz)
  have hcontShift : ContinuousOn (logDeriv (fun s : ℂ => s - 1))
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    have hfun : logDeriv (fun s : ℂ => s - 1) = fun s : ℂ => (s - 1)⁻¹ := by
      funext s
      rw [logDeriv_apply]
      simp
    rw [hfun]
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz h
      exact hb_ne1 z hz (sub_eq_zero.mp h)
  have hcontZ : ContinuousOn (logDeriv completedZeta) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    intro z hz
    have hzU : z ∈ U := hsub hz.1
    have hZd : DifferentiableAt ℂ completedZeta z := hZ.differentiableAt (hU.mem_nhds hzU)
    have hderivd : DifferentiableAt ℂ (deriv completedZeta) z :=
      (hZ.deriv hU).differentiableAt (hU.mem_nhds hzU)
    have hlogd : DifferentiableAt ℂ (logDeriv completedZeta) z := by
      have hfun : logDeriv completedZeta = fun w : ℂ => deriv completedZeta w / completedZeta w := by
        funext w
        rw [logDeriv_apply]
      rw [hfun]
      exact hderivd.div hZd (hZne z hz)
    exact hlogd.continuousAt.continuousWithinAt
  have hlog : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
        = logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z
          + logDeriv completedZeta z := by
    intro z hz
    have hz0 := hb_ne0 z hz
    have hz1 := hb_ne1 z hz
    have hzU : z ∈ U := hsub hz.1
    have hzZ := hZne z hz
    have hZd : DifferentiableAt ℂ completedZeta z := hZ.differentiableAt (hU.mem_nhds hzU)
    have hd1 : DifferentiableAt ℂ (fun s : ℂ => s) z := differentiableAt_id
    have hd2 : DifferentiableAt ℂ (fun s : ℂ => s - 1) z := by fun_prop
    have hfun : (fun s : ℂ => s * (s - 1) * completedZeta s)
        = ((fun s : ℂ => s) * (fun s : ℂ => s - 1)) * completedZeta := rfl
    rw [hfun]
    have hfne : ((fun s : ℂ => s) * (fun s : ℂ => s - 1)) z ≠ 0 :=
      mul_ne_zero hz0 (sub_ne_zero.mpr hz1)
    rw [logDeriv_mul (f := (fun s : ℂ => s) * (fun s : ℂ => s - 1))
      (g := completedZeta) z hfne hzZ (hd1.mul hd2) hZd]
    rw [logDeriv_mul (f := fun s : ℂ => s) (g := fun s : ℂ => s - 1) z hz0
      (sub_ne_zero.mpr hz1) hd1 hd2]
  have hInt : rectIntegral
        (fun z => logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z)
        x₁ x₂ y₁ y₂
      = (rectIntegral (fun z => logDeriv (fun s : ℂ => s) z) x₁ x₂ y₁ y₂)
        + (rectIntegral (fun z => logDeriv (fun s : ℂ => s - 1) z) x₁ x₂ y₁ y₂)
        + rectIntegral (fun z => logDeriv completedZeta z) x₁ x₂ y₁ y₂ := by
    have hcongr : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
        logDeriv (fun s : ℂ => s * (s - 1) * completedZeta s) z
          = (logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z)
              + logDeriv completedZeta z := by
      intro z hz
      simpa only [Pi.add_apply] using hlog z hz
    have hstep := rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hcongr
    rw [hstep]
    rw [rectIntegral_add_boundary
      (fun z => logDeriv (fun s : ℂ => s) z + logDeriv (fun s : ℂ => s - 1) z)
      (fun z => logDeriv completedZeta z) x₁ x₂ y₁ y₂ (hcontId.add hcontShift) hcontZ]
    rw [rectIntegral_add_boundary (fun z => logDeriv (fun s : ℂ => s) z)
      (fun z => logDeriv (fun s : ℂ => s - 1) z) x₁ x₂ y₁ y₂ hcontId hcontShift]
  have hIntId : rectIntegral (fun z => logDeriv (fun s : ℂ => s) z) x₁ x₂ y₁ y₂
      = 2 * (Real.pi : ℂ) * I := by
    have hfun : (fun z : ℂ => logDeriv (fun s : ℂ => s) z) = fun z : ℂ => (z - 0)⁻¹ := by
      funext z
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact rectIntegral_inv_of_mem 0 h0.1 h0.2.1 h0.2.2.1 h0.2.2.2
  have hIntShift : rectIntegral (fun z => logDeriv (fun s : ℂ => s - 1) z)
        x₁ x₂ y₁ y₂ = 2 * (Real.pi : ℂ) * I := by
    have hfun : (fun z : ℂ => logDeriv (fun s : ℂ => s - 1) z)
        = fun z : ℂ => (z - 1)⁻¹ := by
      funext z
      rw [logDeriv_apply]
      simp
    rw [hfun]
    exact rectIntegral_inv_of_mem 1 h1.1 h1.2.1 h1.2.2.1 h1.2.2.2
  rw [hInt] at hzero
  rw [hIntId, hIntShift] at hzero
  linear_combination hzero


/-! ### The quotient extension with multiplicities

For the general argument principle the zero set carries multiplicities.  We
replace `polyProd` by `polyProdPow S m z = ∏ w ∈ S, (z-w)^(m w)` and repeat the
quotient construction: at `w ∈ S` the local factor of `f` is
`(z-w)^(m w)·g`, and the removable value of `f / polyProdPow S m` is
`g w / ∏_{w'≠w}(w-w')^(m w')`, which is nonzero. -/

/-- The polynomial with prescribed roots and multiplicities. -/
noncomputable def polyProdPow (S : Finset ℂ) (m : ℂ → ℕ) : ℂ → ℂ :=
  fun z => ∏ w ∈ S, (z - w) ^ m w

theorem polyProdPow_apply (S : Finset ℂ) (m : ℂ → ℕ) (z : ℂ) :
    polyProdPow S m z = ∏ w ∈ S, (z - w) ^ m w := rfl

/-- Factoring out one root together with its multiplicity. -/
theorem polyProdPow_eq_mul_erase (S : Finset ℂ) (m : ℂ → ℕ) {w : ℂ} (hw : w ∈ S) (z : ℂ) :
    polyProdPow S m z = (z - w) ^ m w * ∏ w' ∈ S.erase w, (z - w') ^ m w' := by
  rw [polyProdPow_apply, ← Finset.mul_prod_erase S (fun x => (z - x) ^ m x) hw]

theorem polyProdPow_ne_zero_of_not_mem {S : Finset ℂ} {m : ℂ → ℕ} {z : ℂ} (hz : z ∉ S) :
    polyProdPow S m z ≠ 0 := by
  rw [polyProdPow_apply]
  exact Finset.prod_ne_zero_iff.mpr
    (fun w hw => pow_ne_zero _ (sub_ne_zero.mpr (fun h => hz (h ▸ hw))))

theorem prod_erase_pow_ne_zero (S : Finset ℂ) (m : ℂ → ℕ) {w : ℂ} (hw : w ∈ S) :
    (∏ w' ∈ S.erase w, (w - w') ^ m w') ≠ 0 := by
  apply Finset.prod_ne_zero_iff.mpr
  intro w' hw'
  exact pow_ne_zero _ (sub_ne_zero.mpr (Ne.symm (Finset.mem_erase.mp hw').1))

/-- The quotient extension with multiplicities. -/
noncomputable def quotientExtensionPow (f : ℂ → ℂ) (S : Finset ℂ) (m : ℂ → ℕ) : ℂ → ℂ :=
  fun z => if z ∈ S then limUnder (𝓝[≠] z) (fun y => f y / polyProdPow S m y)
    else f z / polyProdPow S m z

theorem quotientExtensionPow_of_not_mem {f : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ} {z : ℂ}
    (hz : z ∉ S) :
    quotientExtensionPow f S m z = f z / polyProdPow S m z := by
  simp [quotientExtensionPow, hz]


theorem differentiable_polyProdPow (S : Finset ℂ) (m : ℂ → ℕ) :
    Differentiable ℂ (polyProdPow S m) := by
  have hfun : polyProdPow S m = ∏ w ∈ S, (fun z : ℂ => (z - w) ^ m w) := by
    funext z
    simp [polyProdPow, Finset.prod_apply]
  rw [hfun]
  intro z
  apply DifferentiableAt.finsetProd
  intro i hi
  fun_prop

/-- The quotient `f / polyProdPow S m` tends, along the punctured neighbourhood
of a root, to the removable value. -/
theorem tendsto_div_polyProdPow {f g : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ} {w : ℂ} (hw : w ∈ S)
    (hfg : f =ᶠ[nhds w] fun z => (z - w) ^ m w * g z) (hg : ContinuousAt g w) :
    Tendsto (fun y => f y / polyProdPow S m y) (𝓝[≠] w)
      (𝓝 (g w / ∏ w' ∈ S.erase w, (w - w') ^ m w')) := by
  have hQcont : ContinuousAt (fun y : ℂ => ∏ w' ∈ S.erase w, (y - w') ^ m w') w := by
    apply Continuous.continuousAt
    exact continuous_finsetProd (S.erase w) (fun i hi => by fun_prop)
  have hQw : (∏ w' ∈ S.erase w, (w - w') ^ m w') ≠ 0 := prod_erase_pow_ne_zero S m hw
  have hcont : ContinuousAt (fun y : ℂ => g y / ∏ w' ∈ S.erase w, (y - w') ^ m w') w :=
    hg.div hQcont hQw
  have hev : (fun y : ℂ => f y / polyProdPow S m y) =ᶠ[𝓝[≠] w]
      (fun y : ℂ => g y / ∏ w' ∈ S.erase w, (y - w') ^ m w') := by
    filter_upwards [self_mem_nhdsWithin, hfg.filter_mono nhdsWithin_le_nhds] with y hy hfy
    rw [hfy, polyProdPow_eq_mul_erase S m hw y]
    exact mul_div_mul_left (g y) (∏ w' ∈ S.erase w, (y - w') ^ m w')
      (pow_ne_zero _ (sub_ne_zero.mpr hy))
  exact hcont.tendsto.mono_left nhdsWithin_le_nhds |>.congr' hev.symm

theorem quotientExtensionPow_mem_value {f g : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ} {w : ℂ}
    (hw : w ∈ S) (hfg : f =ᶠ[nhds w] fun z => (z - w) ^ m w * g z) (hg : ContinuousAt g w) :
    quotientExtensionPow f S m w = g w / ∏ w' ∈ S.erase w, (w - w') ^ m w' := by
  rw [quotientExtensionPow, if_pos hw]
  exact (tendsto_div_polyProdPow hw hfg hg).limUnder_eq

theorem continuousAt_quotientExtensionPow_of_mem {f g : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ}
    {w : ℂ} (hw : w ∈ S) (hfg : f =ᶠ[nhds w] fun z => (z - w) ^ m w * g z)
    (hg : ContinuousAt g w) :
    ContinuousAt (quotientExtensionPow f S m) w := by
  have hval := quotientExtensionPow_mem_value hw hfg hg
  have htend := tendsto_div_polyProdPow hw hfg hg
  have hopen : IsOpen (↑(S.erase w) : Set ℂ)ᶜ :=
    (S.erase w).finite_toSet.isClosed.isOpen_compl
  have hcompl : (↑(S.erase w) : Set ℂ)ᶜ ∈ 𝓝[≠] w :=
    nhdsWithin_le_nhds (hopen.mem_nhds (by simp))
  have hev : quotientExtensionPow f S m =ᶠ[𝓝[≠] w] fun y => f y / polyProdPow S m y := by
    filter_upwards [self_mem_nhdsWithin, hcompl] with y hy hycomp
    have hyS : y ∉ S := by
      intro hyS
      exact hycomp (Finset.mem_erase.mpr ⟨by simpa using hy, hyS⟩)
    exact quotientExtensionPow_of_not_mem hyS
  rw [continuousAt_iff_punctured_nhds, hval]
  exact htend.congr' hev.symm

theorem differentiableAt_quotientExtensionPow_of_not_mem {f : ℂ → ℂ} {S : Finset ℂ}
    {m : ℂ → ℕ} {U : Set ℂ} (hU : IsOpen U) (hf : DifferentiableOn ℂ f U) {z : ℂ}
    (hzS : z ∉ S) (hzU : z ∈ U) :
    DifferentiableAt ℂ (quotientExtensionPow f S m) z := by
  have hopen : IsOpen (↑S : Set ℂ)ᶜ := S.finite_toSet.isClosed.isOpen_compl
  have hev : quotientExtensionPow f S m =ᶠ[𝓝 z] fun y => f y / polyProdPow S m y := by
    filter_upwards [hopen.mem_nhds (by simpa using hzS)] with y hy
    exact quotientExtensionPow_of_not_mem (by simpa using hy)
  rw [hev.differentiableAt_iff]
  exact (hf.differentiableAt (hU.mem_nhds hzU)).div
    (differentiable_polyProdPow S m z) (polyProdPow_ne_zero_of_not_mem hzS)

/-- **Analyticity of the multiplicity quotient extension at a zero**, using the
local factorisation supplied by the analytic order. -/
theorem analyticAt_quotientExtensionPow_of_mem {f g : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ}
    {U : Set ℂ} (hU : IsOpen U) (hf : DifferentiableOn ℂ f U) {w : ℂ} (hw : w ∈ S)
    (hwU : w ∈ U) (hfg : f =ᶠ[nhds w] fun z => (z - w) ^ m w * g z) (hg : AnalyticAt ℂ g w) :
    AnalyticAt ℂ (quotientExtensionPow f S m) w := by
  apply Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
  · have hopenU : U ∈ 𝓝[≠] w := nhdsWithin_le_nhds (hU.mem_nhds hwU)
    have hopenS : (↑(S.erase w) : Set ℂ)ᶜ ∈ 𝓝[≠] w :=
      nhdsWithin_le_nhds (((S.erase w).finite_toSet.isClosed.isOpen_compl).mem_nhds (by simp))
    filter_upwards [self_mem_nhdsWithin, hopenU, hopenS] with y hy hyU hyS
    have hyS' : y ∉ S := by
      intro hyS'
      exact hyS (Finset.mem_erase.mpr ⟨by simpa using hy, hyS'⟩)
    exact differentiableAt_quotientExtensionPow_of_not_mem hU hf hyS' hyU
  · exact continuousAt_quotientExtensionPow_of_mem hw hfg hg.continuousAt


/-- The local factorisation from the analytic order at a zero of positive
multiplicity. -/
theorem exists_eventuallyEq_pow_mul_of_order {f : ℂ → ℂ} {w : ℂ} {m : ℕ}
    (hf : AnalyticAt ℂ f w) (hm : 0 < m) (hord : analyticOrderNatAt f w = m) :
    ∃ g : ℂ → ℂ, AnalyticAt ℂ g w ∧ g w ≠ 0
      ∧ f =ᶠ[nhds w] fun z => (z - w) ^ m * g z := by
  have hfinite : analyticOrderAt f w ≠ ⊤ := by
    intro htop
    have h0 : analyticOrderNatAt f w = 0 := by simp [analyticOrderNatAt, htop]
    rw [hord] at h0
    exact (Nat.pos_iff_ne_zero.mp hm) h0
  obtain ⟨g, hg, hg0, hfg⟩ := (hf.analyticOrderNatAt_eq_iff hfinite (n := m)).mp hord
  refine ⟨g, hg, hg0, ?_⟩
  filter_upwards [hfg] with z hz
  simpa using hz

theorem quotientExtensionPow_ne_zero {f : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ} {U : Set ℂ}
    (hU : IsOpen U) (hf : DifferentiableOn ℂ f U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hord : ∀ w ∈ S, analyticOrderNatAt f w = m w)
    (hno : ∀ z ∈ U, z ∉ S → f z ≠ 0) :
    ∀ z ∈ U, quotientExtensionPow f S m z ≠ 0 := by
  intro z hzU
  by_cases hzS : z ∈ S
  · obtain ⟨g, hg, hg0, hfg⟩ := exists_eventuallyEq_pow_mul_of_order
      (hf.analyticAt (hU.mem_nhds hzU)) (hm z hzS) (hord z hzS)
    rw [quotientExtensionPow_mem_value hzS hfg hg.continuousAt]
    exact div_ne_zero hg0 (prod_erase_pow_ne_zero S m hzS)
  · rw [quotientExtensionPow_of_not_mem hzS]
    exact div_ne_zero (hno z hzU hzS) (polyProdPow_ne_zero_of_not_mem hzS)

theorem differentiableOn_quotientExtensionPow {f : ℂ → ℂ} {S : Finset ℂ} {m : ℂ → ℕ}
    {U : Set ℂ} (hU : IsOpen U) (hf : DifferentiableOn ℂ f U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hord : ∀ w ∈ S, analyticOrderNatAt f w = m w) :
    DifferentiableOn ℂ (quotientExtensionPow f S m) U := by
  intro z hzU
  by_cases hzS : z ∈ S
  · obtain ⟨g, hg, hg0, hfg⟩ := exists_eventuallyEq_pow_mul_of_order
      (hf.analyticAt (hU.mem_nhds hzU)) (hm z hzS) (hord z hzS)
    exact (analyticAt_quotientExtensionPow_of_mem hU hf hzS hzU hfg hg).differentiableAt.differentiableWithinAt
  · exact (differentiableAt_quotientExtensionPow_of_not_mem hU hf hzS hzU).differentiableWithinAt

/-- **Argument principle with multiplicities, from the analytic order.**  If
`f` is differentiable on an open set `U` containing the closed rectangle, its
zeros in `U` are exactly a finite set `S` (with `analyticOrderNatAt f w = m w`
at each `w ∈ S`, and `m w > 0`), and all zeros are strictly inside the
rectangle, then `∮ f'/f = 2πi·∑_{w∈S} m w`.

The factorisation `f = (∏(z-w)^(m w))·q` is now *constructed* from the order
data, not assumed. -/
theorem rectIntegral_logDeriv_eq_divisor_sum
    {f : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hord : ∀ w ∈ S, analyticOrderNatAt f w = m w)
    (hno : ∀ z ∈ U, z ∉ S → f z ≠ 0) :
    rectIntegral (fun z => logDeriv f z) x₁ x₂ y₁ y₂
      = (∑ w ∈ S, (m w : ℂ)) * (2 * (Real.pi : ℂ) * I) := by
  have hq := differentiableOn_quotientExtensionPow hU hf hm hord
  have hq_ne := quotientExtensionPow_ne_zero hU hf hm hord hno
  have hfac : ∀ z ∈ U, z ∉ S →
      f z = (∏ w ∈ S, (z - w) ^ m w) * quotientExtensionPow f S m z := by
    intro z hzU hzS
    rw [quotientExtensionPow_of_not_mem hzS]
    field_simp [polyProdPow_ne_zero_of_not_mem hzS]
    rfl
  exact rectIntegral_logDeriv_eq_sum_multiplicity x₁ x₂ y₁ y₂ S m hU hsub hf hq hq_ne
    hS_in hfac

/-- **Zero side of the explicit formula from the analytic order data.**  Let
`g(s) = s(s-1)Z(s)`; if the zeros of `g` in `U` are exactly `S` with orders
`m w > 0` (all strictly inside the rectangle), then
`∮ Z'/Z = 2πi·(∑ m - 2)`.  This removes the factorisation hypothesis of
`rectIntegral_logDeriv_completedZeta_eq_sum`: the quotient is constructed. -/
theorem rectIntegral_logDeriv_completedZeta_eq_divisor_sum
    {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (S : Finset ℂ) (m : ℂ → ℕ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hZ : DifferentiableOn ℂ completedZeta U)
    (h0 : x₁ < 0 ∧ 0 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (h1 : x₁ < 1 ∧ 1 < x₂ ∧ y₁ < 0 ∧ 0 < y₂)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hg : DifferentiableOn ℂ (fun s : ℂ => s * (s - 1) * completedZeta s) U)
    (hm : ∀ w ∈ S, 0 < m w)
    (hord : ∀ w ∈ S,
      analyticOrderNatAt (fun s : ℂ => s * (s - 1) * completedZeta s) w = m w)
    (hno : ∀ z ∈ U, z ∉ S → z * (z - 1) * completedZeta z ≠ 0) :
    rectIntegral (fun s => logDeriv completedZeta s) x₁ x₂ y₁ y₂
      = ((∑ w ∈ S, (m w : ℂ)) - 2) * (2 * (Real.pi : ℂ) * I) := by
  have hq := differentiableOn_quotientExtensionPow hU hg hm hord
  have hq_ne := quotientExtensionPow_ne_zero hU hg hm hord hno
  have hfac : ∀ z ∈ U, z ∉ S →
      z * (z - 1) * completedZeta z
        = (∏ w ∈ S, (z - w) ^ m w)
            * quotientExtensionPow (fun s : ℂ => s * (s - 1) * completedZeta s) S m z := by
    intro z hzU hzS
    rw [quotientExtensionPow_of_not_mem hzS]
    field_simp [polyProdPow_ne_zero_of_not_mem hzS]
    rfl
  exact rectIntegral_logDeriv_completedZeta_eq_sum x₁ x₂ y₁ y₂ S m hU hsub hZ h0 h1
    hS_in hg hq hq_ne hfac


/-! ### From Mathlib's meromorphic divisor to the analytic order

The zero-count theorems take the zero set and its multiplicities as data.  The
bridging lemma below identifies Mathlib's meromorphic divisor value with
`analyticOrderNatAt` at an analytic point of finite order, which is the first
step towards deriving that data from `f` itself. -/

/-- **Divisor value equals the analytic order** at a point of finite order. -/
theorem divisor_apply_eq_analyticOrderNatAt {f : ℂ → ℂ} {U : Set ℂ} {z : ℂ}
    (hf : AnalyticOnNhd ℂ f U) (hz : z ∈ U) (hfin : analyticOrderAt f z ≠ ⊤) :
    MeromorphicOn.divisor f U z = (analyticOrderNatAt f z : ℤ) := by
  rw [MeromorphicOn.AnalyticOnNhd.divisor_apply hf hz]
  generalize h : analyticOrderAt f z = a at hfin ⊢
  rcases a with _ | n
  · exact absurd rfl hfin
  · have htoNat : analyticOrderNatAt f z = n := by
      rw [analyticOrderNatAt, h]
      rfl
    rw [htoNat]
    rfl


/-! ### The divisor's support on a rectangle

The zero-count theorems take the zero set and its multiplicities as data.  The
lemmas here derive that data from Mathlib's meromorphic divisor: on the open
rectangle the divisor has finite support, its support lies in the open
rectangle, and its values are the analytic orders. -/

/-- The divisor of an analytic function on an open rectangle has finite
support. -/
theorem divisor_openRect_support_finite {f : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U) :
    (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).support.Finite := by
  have hOA : AnalyticOnNhd ℂ f U := hf.analyticOnNhd hU
  have hVsub : (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) ⊆ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt hz.1.1),
        le_trans (le_of_lt hz.1.2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt hz.2.1),
        le_trans (le_of_lt hz.2.2) (le_max_right _ _)⟩⟩
  have hmer : MeromorphicOn f ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) :=
    (hOA.mono hsub).meromorphicOn
  exact hmer.divisor_support_finite_of_subset
    (isCompact_uIcc.reProdIm isCompact_uIcc) hVsub

/-- A point of the divisor support on the open rectangle lies in the open
rectangle. -/
theorem divisor_openRect_support_subset {f : ℂ → ℂ} (x₁ x₂ y₁ y₂ : ℝ) :
    (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).support
      ⊆ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
  (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).supportWithinDomain

/-- At a point of the divisor support on the open rectangle, the analytic
order equals the divisor value (as a natural number). -/
theorem analyticOrderNatAt_eq_divisor_toNat {f : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U)
    {w : ℂ} (hw : w ∈ (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).support) :
    analyticOrderNatAt f w
      = ((MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w).toNat := by
  have hOA : AnalyticOnNhd ℂ f U := hf.analyticOnNhd hU
  have hVsub : (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) ⊆ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt hz.1.1),
        le_trans (le_of_lt hz.1.2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt hz.2.1),
        le_trans (le_of_lt hz.2.2) (le_max_right _ _)⟩⟩
  have hOV : AnalyticOnNhd ℂ f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
    hOA.mono (fun z hz => hsub (hVsub hz))
  have hwV : w ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
    (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).supportWithinDomain hw
  have hfin : analyticOrderAt f w ≠ ⊤ := by
    intro htop
    have hzero : (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w = 0 := by
      rw [MeromorphicOn.AnalyticOnNhd.divisor_apply hOV hwV, htop]
      simp
    exact (Function.mem_support.mp hw) hzero
  have hb := divisor_apply_eq_analyticOrderNatAt hOV hwV hfin
  rw [hb]
  simp


/-- **Argument principle from the meromorphic divisor.**  If `f` is analytic on
an open set `U` containing the closed rectangle, has finite analytic order
everywhere on `U`, and all its zeros in `U` lie in the open rectangle, then
`∮ f'/f = 2πi · ∑ m`, where `m` runs over the divisor of `f` on the open
rectangle (the zeros counted with multiplicity).  The zero set and its
multiplicities are now *derived*, not assumed. -/
theorem rectIntegral_logDeriv_eq_divisor_sum_of_analytic
    {f : ℂ → ℂ} {U : Set ℂ} (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hf : DifferentiableOn ℂ f U)
    (hfinite : ∀ z ∈ U, analyticOrderAt f z ≠ ⊤)
    (hno_out : ∀ z ∈ U, f z = 0 → z ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    ∃ S : Finset ℂ,
      (∀ w, w ∈ S ↔ w ∈ (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)).support)
      ∧ rectIntegral (fun z => logDeriv f z) x₁ x₂ y₁ y₂
          = (S.sum (fun w =>
              (((MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w).toNat : ℂ)))
            * (2 * (Real.pi : ℂ) * I) := by
  have hVsub : (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) ⊆ ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) := by
    intro z hz
    rw [Complex.mem_reProdIm] at hz ⊢
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt hz.1.1),
        le_trans (le_of_lt hz.1.2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt hz.2.1),
        le_trans (le_of_lt hz.2.2) (le_max_right _ _)⟩⟩
  have hOV : AnalyticOnNhd ℂ f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
    (hf.analyticOnNhd hU).mono (fun z hz => hsub (hVsub hz))
  have hfin := divisor_openRect_support_finite x₁ x₂ y₁ y₂ hU hsub hf
  obtain ⟨S, hS_mem⟩ := hfin.exists_finset
  let m : ℂ → ℕ := fun w => ((MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) w).toNat
  refine ⟨S, hS_mem, ?_⟩
  have hm : ∀ w ∈ S, 0 < m w := by
    intro w hw
    have hwV : w ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
      divisor_openRect_support_subset x₁ x₂ y₁ y₂ ((hS_mem w).mp hw)
    have hordw := analyticOrderNatAt_eq_divisor_toNat x₁ x₂ y₁ y₂ hU hsub hf
      ((hS_mem w).mp hw)
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hwV (hfinite w (hsub (hVsub hwV)))
    have hne : analyticOrderNatAt f w ≠ 0 := by
      intro h0
      apply (Function.mem_support.mp ((hS_mem w).mp hw))
      rw [hb, h0]
      simp
    rw [show m w = analyticOrderNatAt f w from hordw.symm]
    exact Nat.pos_iff_ne_zero.mpr hne
  have hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂ := by
    intro w hw
    have hwV : w ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) :=
      divisor_openRect_support_subset x₁ x₂ y₁ y₂ ((hS_mem w).mp hw)
    rw [Complex.mem_reProdIm] at hwV
    exact ⟨hwV.1.1, hwV.1.2, hwV.2.1, hwV.2.2⟩
  have hord : ∀ w ∈ S, analyticOrderNatAt f w = m w := by
    intro w hw
    exact analyticOrderNatAt_eq_divisor_toNat x₁ x₂ y₁ y₂ hU hsub hf ((hS_mem w).mp hw)
  have hno : ∀ z ∈ U, z ∉ S → f z ≠ 0 := by
    intro z hzU hzS hfz
    have hzV : z ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂) := hno_out z hzU hfz
    have hAnalytic : AnalyticAt ℂ f z := (hf.analyticOnNhd hU) z hzU
    have hord_ne : analyticOrderAt f z ≠ 0 := hAnalytic.analyticOrderAt_ne_zero.mpr hfz
    have hnat : analyticOrderNatAt f z ≠ 0 := by
      intro h0
      have hcast := Nat.cast_analyticOrderNatAt (z₀ := z) (hfinite z hzU)
      rw [h0] at hcast
      simp at hcast
      exact hord_ne hcast.symm
    have hb := divisor_apply_eq_analyticOrderNatAt hOV hzV (hfinite z hzU)
    have hdiv : (MeromorphicOn.divisor f (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) z ≠ 0 := by
      rw [hb]
      intro h0
      have : analyticOrderNatAt f z = 0 := by omega
      exact hnat this
    exact hzS ((hS_mem z).mpr (Function.mem_support.mpr hdiv))
  exact rectIntegral_logDeriv_eq_divisor_sum x₁ x₂ y₁ y₂ S m hU hsub hf hm hS_in hord hno


/-- **Cauchy integral formula on a rectangle.**  For `h` differentiable on an
open set containing the closed rectangle and `a` strictly inside,
`∮ h(z)/(z-a) dz = 2πi·h(a)`.  This is the rectangle analogue of the circle
formula, and the key tool for the test-function explicit formula. -/
theorem rectIntegral_mul_inv_sub_eq (h : ℂ → ℂ) {U : Set ℂ} {a : ℂ}
    (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hh : DifferentiableOn ℂ h U)
    (ha : a ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    rectIntegral (fun z => h z * (z - a)⁻¹) x₁ x₂ y₁ y₂
      = h a * (2 * (Real.pi : ℂ) * I) := by
  rw [Complex.mem_reProdIm] at ha
  obtain ⟨⟨ha1, ha2⟩, ⟨ha3, ha4⟩⟩ := ha
  have haU : a ∈ U := by
    apply hsub
    rw [Complex.mem_reProdIm]
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt ha1), le_trans (le_of_lt ha2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt ha3), le_trans (le_of_lt ha4) (le_max_right _ _)⟩⟩
  have hnhds : U ∈ 𝓝 a := hU.mem_nhds haU
  have hphi_diff : DifferentiableOn ℂ (dslope h a) U :=
    (differentiableOn_dslope hnhds).mpr hh
  have hphi_int : rectIntegral (fun z => dslope h a z) x₁ x₂ y₁ y₂ = 0 :=
    rectIntegral_eq_zero_of_differentiableOn _ x₁ x₂ y₁ y₂
      (hphi_diff.continuousOn.mono hsub)
      (hphi_diff.mono (fun z hz =>
        hsub ⟨Ioo_subset_Icc_self hz.1, Ioo_subset_Icc_self hz.2⟩))
  have hbound_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ a := by
    intro z hz h
    rcases hz.2 with h' | h' | h' | h'
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
  have hpoint : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      h z * (z - a)⁻¹ = h a * (z - a)⁻¹ + dslope h a z := by
    intro z hz
    have hza : z ≠ a := hbound_ne z hz
    have hd : (z - a) * dslope h a z = h z - h a := by
      simpa using sub_smul_dslope h a z
    have hne : z - a ≠ 0 := sub_ne_zero.mpr hza
    field_simp [hne]
    rw [hd]
    ring
  have hcont1 : ContinuousOn (fun z : ℂ => h a * (z - a)⁻¹)
      (rectBoundarySet x₁ x₂ y₁ y₂) := by
    apply ContinuousOn.const_mul
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz
      exact sub_ne_zero.mpr (hbound_ne z hz)
  have hcont2 : ContinuousOn (fun z : ℂ => dslope h a z) (rectBoundarySet x₁ x₂ y₁ y₂) :=
    hphi_diff.continuousOn.mono (fun z hz => hsub hz.1)
  rw [rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hpoint]
  rw [rectIntegral_add_boundary _ _ x₁ x₂ y₁ y₂ hcont1 hcont2]
  rw [rectIntegral_const_mul, rectIntegral_inv_of_mem a ha1 ha2 ha3 ha4, hphi_int, add_zero]


/-- **Integral of a finite sum of simple fractions.**  If all the points `w ∈ S`
lie strictly inside the rectangle and `c` is any coefficient function, then
`∮ ∑_{w∈S} c(w)/(z-w) dz = (∑_{w∈S} c(w))·2πi`.  This is the residue sum for
the test-function explicit formula. -/
theorem rectIntegral_sum_const_inv_sub (S : Finset ℂ) (c : ℂ → ℂ)
    (x₁ x₂ y₁ y₂ : ℝ)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂) :
    rectIntegral (fun z => ∑ w ∈ S, c w * (z - w)⁻¹) x₁ x₂ y₁ y₂
      = (∑ w ∈ S, c w) * (2 * (Real.pi : ℂ) * I) := by
  rw [rectIntegral_finset_sum_boundary S (fun w z => c w * (z - w)⁻¹) x₁ x₂ y₁ y₂ ?_]
  · rw [Finset.sum_mul]
    apply Finset.sum_congr rfl
    intro w hw
    rw [rectIntegral_const_mul, rectIntegral_inv_of_mem w (hS_in w hw).1 (hS_in w hw).2.1
      (hS_in w hw).2.2.1 (hS_in w hw).2.2.2]
  · intro w hw
    apply ContinuousOn.const_mul
    apply ContinuousOn.inv₀
    · exact (continuous_id.sub continuous_const).continuousOn
    · intro z hz h
      have hzw : z = w := sub_eq_zero.mp h
      rw [hzw] at hz
      rcases hz.2 with h' | h' | h' | h'
      · linarith [h', (hS_in w hw).1]
      · linarith [h', (hS_in w hw).2.1]
      · linarith [h', (hS_in w hw).2.2.1]
      · linarith [h', (hS_in w hw).2.2.2]


/-- **Assembly of the test-function residue formula.**  If on the boundary the
meromorphic integrand decomposes as `(Z'/Z)·h = ψ + ∑_{w∈S} c(w)/(z-w)`, with
`ψ` continuous and of zero rectangle integral and all `w ∈ S` strictly inside,
then `∮ (Z'/Z)·h = (∑_{w∈S} c(w))·2πi`.  The only remaining input is the
decomposition itself (the global residue patching). -/
theorem rectIntegral_logDeriv_mul_eq_residue_sum
    {Z h ψ : ℂ → ℂ} (S : Finset ℂ) (c : ℂ → ℂ) (x₁ x₂ y₁ y₂ : ℝ)
    (hS_in : ∀ w ∈ S, x₁ < w.re ∧ w.re < x₂ ∧ y₁ < w.im ∧ w.im < y₂)
    (hψ_cont : ContinuousOn ψ (rectBoundarySet x₁ x₂ y₁ y₂))
    (hfr_cont : ∀ w ∈ S,
      ContinuousOn (fun z : ℂ => c w * (z - w)⁻¹) (rectBoundarySet x₁ x₂ y₁ y₂))
    (hdecomp : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      logDeriv Z z * h z = ψ z + ∑ w ∈ S, c w * (z - w)⁻¹)
    (hψ_int : rectIntegral ψ x₁ x₂ y₁ y₂ = 0) :
    rectIntegral (fun z => logDeriv Z z * h z) x₁ x₂ y₁ y₂
      = (∑ w ∈ S, c w) * (2 * (Real.pi : ℂ) * I) := by
  rw [rectIntegral_congr_boundary x₁ x₂ y₁ y₂ hdecomp]
  rw [rectIntegral_add_boundary ψ (fun z => ∑ w ∈ S, c w * (z - w)⁻¹) x₁ x₂ y₁ y₂
    hψ_cont (continuousOn_finsetSum S hfr_cont)]
  rw [hψ_int, zero_add, rectIntegral_sum_const_inv_sub S c x₁ x₂ y₁ y₂ hS_in]


/-- **Finite removable-singularity patching.**  If `f` is differentiable on
`U` off a finite set `S`, and at each `w ∈ S` there is an analytic germ
agreeing with `f` off `w`, then `f` has an analytic extension `Ψ` on `U` which
equals `f` off `S`.  This assembles the local residue subtractions into the
global remainder of the test-function explicit formula. -/
theorem exists_analyticOnNhd_of_differentiableOn_compl_finset
    {f : ℂ → ℂ} {U : Set ℂ} (hU : IsOpen U) (S : Finset ℂ)
    (hSU : ∀ w ∈ S, w ∈ U)
    (hdiff : DifferentiableOn ℂ f (U \ ↑S))
    (hgerm : ∀ w ∈ S, ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ w ∧ ψ =ᶠ[𝓝[≠] w] f) :
    ∃ Ψ : ℂ → ℂ, AnalyticOnNhd ℂ Ψ U ∧ ∀ z ∈ U, z ∉ S → Ψ z = f z := by
  classical
  induction S using Finset.induction_on generalizing f with
  | empty =>
    have hdiffU : DifferentiableOn ℂ f U := by simpa using hdiff
    exact ⟨f, hdiffU.analyticOnNhd hU, fun z hz hzS => rfl⟩
  | insert w S' hw ih =>
    have hwU : w ∈ U := hSU w (Finset.mem_insert_self w S')
    obtain ⟨ψ, hψ_an, hψ_eq⟩ := hgerm w (Finset.mem_insert_self w S')
    set g : ℂ → ℂ := Function.update f w (ψ w) with hg_def
    have hg_off : ∀ z, z ≠ w → g z = f z := fun z hz => Function.update_of_ne hz _ _
    have hg_cont : ContinuousAt g w := by
      rw [continuousAt_iff_punctured_nhds]
      have hgw : g w = ψ w := by
        rw [hg_def]
        exact Function.update_self ..
      rw [hgw]
      have heq : g =ᶠ[𝓝[≠] w] ψ := by
        filter_upwards [self_mem_nhdsWithin, hψ_eq] with y hy hψy
        rw [hg_def, Function.update_of_ne (by simpa using hy)]
        exact hψy.symm
      exact (hψ_an.continuousAt.tendsto.mono_left nhdsWithin_le_nhds).congr' heq.symm
    have hdiff_punct : ∀ᶠ z in 𝓝[≠] w, DifferentiableAt ℂ g z := by
      have hS_closed : IsClosed (↑S' : Set ℂ) := S'.finite_toSet.isClosed
      have hw_notin : w ∉ (↑S' : Set ℂ) := by simpa using hw
      have hopen : IsOpen ((↑S' : Set ℂ)ᶜ) := hS_closed.isOpen_compl
      have hw_mem : w ∈ ((↑S' : Set ℂ)ᶜ) := by simpa using hw_notin
      filter_upwards [self_mem_nhdsWithin,
        nhdsWithin_le_nhds (hopen.mem_nhds hw_mem),
        nhdsWithin_le_nhds (hU.mem_nhds hwU)] with z hz_ne hz_notS hzU
      have hz_not_insert : z ∉ (↑(insert w S') : Set ℂ) := by
        rw [Finset.coe_insert, Set.mem_insert_iff, not_or]
        exact ⟨hz_ne, hz_notS⟩
      have hclosed : IsClosed (↑(insert w S') : Set ℂ) := (Finset.finite_toSet _).isClosed
      have hzopen : U \ (↑(insert w S') : Set ℂ) ∈ 𝓝 z :=
        (hU.sdiff hclosed).mem_nhds ⟨hzU, hz_not_insert⟩
      have hfd : DifferentiableAt ℂ f z := hdiff.differentiableAt hzopen
      exact hfd.congr_of_eventuallyEq
        (Filter.eventuallyEq_of_mem (isOpen_compl_singleton.mem_nhds hz_ne)
          (fun y hy => hg_off y hy))
    have h_an_w : AnalyticAt ℂ g w :=
      Complex.analyticAt_of_differentiable_on_punctured_nhds_of_continuousAt
        hdiff_punct hg_cont
    have hSU' : ∀ z ∈ S', z ∈ U := fun z hz => hSU z (Finset.mem_insert_of_mem hz)
    have hdiff' : DifferentiableOn ℂ g (U \ ↑S') := by
      intro z hz
      rcases eq_or_ne z w with rfl | hzw
      · exact h_an_w.differentiableAt.differentiableWithinAt
      · have hz_not_insert : z ∉ (↑(insert w S') : Set ℂ) := by
          rw [Finset.coe_insert, Set.mem_insert_iff, not_or]
          exact ⟨hzw, hz.2⟩
        have hclosed : IsClosed (↑(insert w S') : Set ℂ) := (Finset.finite_toSet _).isClosed
        have hzopen : U \ (↑(insert w S') : Set ℂ) ∈ 𝓝 z :=
          (hU.sdiff hclosed).mem_nhds ⟨hz.1, hz_not_insert⟩
        have hfd : DifferentiableAt ℂ f z := hdiff.differentiableAt hzopen
        have heq : g =ᶠ[𝓝 z] f :=
          Filter.eventuallyEq_of_mem (isOpen_compl_singleton.mem_nhds hzw)
            (fun y hy => hg_off y hy)
        exact (hfd.congr_of_eventuallyEq heq).differentiableWithinAt
    have hgerm' : ∀ z ∈ S', ∃ ψ : ℂ → ℂ, AnalyticAt ℂ ψ z ∧ ψ =ᶠ[𝓝[≠] z] g := by
      intro z hz
      obtain ⟨φ, hφ_an, hφ_eq⟩ := hgerm z (Finset.mem_insert_of_mem hz)
      have hzw : z ≠ w := by
        intro h
        exact hw (h ▸ hz)
      have hfg : f =ᶠ[𝓝[≠] z] g := by
        filter_upwards [self_mem_nhdsWithin,
          nhdsWithin_le_nhds (isOpen_compl_singleton.mem_nhds hzw)] with y hy hyw
        exact (hg_off y hyw).symm
      exact ⟨φ, hφ_an, hφ_eq.trans hfg⟩
    obtain ⟨Ψ, hΨ_an, hΨ_eq⟩ := ih (f := g) hSU' hdiff' hgerm'
    refine ⟨Ψ, hΨ_an, ?_⟩
    intro z hzU hzS
    have hz_notS' : z ∉ S' := by
      intro h
      exact hzS (Finset.mem_insert_of_mem h)
    have hzw : z ≠ w := by
      intro h
      exact hzS (h ▸ Finset.mem_insert_self w S')
    rw [hΨ_eq z hzU hz_notS', hg_off z hzw]




/-- Derivative of `-(z-a)⁻¹` is `((z-a)²)⁻¹`. -/
theorem hasDerivAt_neg_inv_sub (a z : ℂ) (hz : z ≠ a) :
    HasDerivAt (fun w : ℂ => -(w - a)⁻¹) (((z - a) ^ 2)⁻¹) z := by
  have h1 : HasDerivAt (fun w : ℂ => w - a) 1 z := by
    simpa using (hasDerivAt_id z).sub_const a
  have h2 : HasDerivAt (fun w : ℂ => (w - a)⁻¹) (-((z - a) ^ 2)⁻¹) z := by
    have := (hasDerivAt_inv (sub_ne_zero.mpr hz)).comp z h1
    simpa [Function.comp_def] using this
  have h3 : HasDerivAt (fun w : ℂ => -((w - a)⁻¹)) (-(-((z - a) ^ 2)⁻¹)) z := h2.neg
  simpa using h3

/-- **The inverse-square winding integral vanishes**: for `a` strictly inside
the rectangle, `∮ ((z-a)²)⁻¹ dz = 0`. -/
theorem rectIntegral_inv_sq_eq_zero (a : ℂ) {x₁ x₂ y₁ y₂ : ℝ}
    (hx₁ : x₁ < a.re) (hx₂ : a.re < x₂) (hy₁ : y₁ < a.im) (hy₂ : a.im < y₂) :
    rectIntegral (fun z => (((z - a) ^ 2)⁻¹)) x₁ x₂ y₁ y₂ = 0 := by
  have hb : (∫ x : ℝ in x₁..x₂, (fun z : ℂ => ((z - a) ^ 2)⁻¹) (x + y₁ * I))
      = (fun z : ℂ => -(z - a)⁻¹) (x₂ + y₁ * I) - (fun z : ℂ => -(z - a)⁻¹) (x₁ + y₁ * I) := by
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro x hx
      have hne : (x + y₁ * I : ℂ) ≠ a := by
        intro h
        have him : (x + y₁ * I : ℂ).im = y₁ := by simp
        rw [h] at him
        linarith
      have h := hasDerivAt_neg_inv_sub a (x + y₁ * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (t : ℂ) + y₁ * I) 1 x := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const (y₁ * I)
      have := h.comp x hpath
      simpa [Function.comp_def] using this
    · have hcont : ContinuousOn (fun x : ℝ => ((x + (y₁ : ℂ) * I - a) ^ 2)⁻¹) (uIcc x₁ x₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_ofReal.add continuous_const).sub continuous_const).pow 2 |>.continuousOn
        · intro x hx
          exact pow_ne_zero 2 (sub_ne_zero.mpr (by
            intro h
            have him : ((x : ℂ) + y₁ * I).im = y₁ := by simp
            rw [h] at him
            linarith))
      exact hcont.intervalIntegrable
  have ht : (∫ x : ℝ in x₁..x₂, (fun z : ℂ => ((z - a) ^ 2)⁻¹) (x + y₂ * I))
      = (fun z : ℂ => -(z - a)⁻¹) (x₂ + y₂ * I) - (fun z : ℂ => -(z - a)⁻¹) (x₁ + y₂ * I) := by
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro x hx
      have hne : (x + y₂ * I : ℂ) ≠ a := by
        intro h
        have him : (x + y₂ * I : ℂ).im = y₂ := by simp
        rw [h] at him
        linarith
      have h := hasDerivAt_neg_inv_sub a (x + y₂ * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (t : ℂ) + y₂ * I) 1 x := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const (y₂ * I)
      have := h.comp x hpath
      simpa [Function.comp_def] using this
    · have hcont : ContinuousOn (fun x : ℝ => ((x + (y₂ : ℂ) * I - a) ^ 2)⁻¹) (uIcc x₁ x₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_ofReal.add continuous_const).sub continuous_const).pow 2 |>.continuousOn
        · intro x hx
          exact pow_ne_zero 2 (sub_ne_zero.mpr (by
            intro h
            have him : ((x : ℂ) + y₂ * I).im = y₂ := by simp
            rw [h] at him
            linarith))
      exact hcont.intervalIntegrable
  have hr : I * (∫ y : ℝ in y₁..y₂, (fun z : ℂ => ((z - a) ^ 2)⁻¹) (x₂ + y * I))
      = (fun z : ℂ => -(z - a)⁻¹) (x₂ + y₂ * I) - (fun z : ℂ => -(z - a)⁻¹) (x₂ + y₁ * I) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro y hy
      have hne : (x₂ + y * I : ℂ) ≠ a := by
        intro h
        have hre : (x₂ + y * I : ℂ).re = x₂ := by simp
        rw [h] at hre
        linarith
      have h := hasDerivAt_neg_inv_sub a (x₂ + y * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (x₂ : ℂ) + (t : ℂ) * I) I y := by
        have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
          (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
        have h2 := h1.const_add ((x₂ : ℂ))
        simpa [mul_comm, mul_assoc] using h2
      have := h.comp y hpath
      simpa [Function.comp_def, mul_comm] using this
    · have hcont : ContinuousOn (fun y : ℝ => (((x₂ : ℂ) + (y : ℂ) * I - a) ^ 2)⁻¹) (uIcc y₁ y₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub continuous_const).pow 2 |>.continuousOn
        · intro y hy
          exact pow_ne_zero 2 (sub_ne_zero.mpr (by
            intro h
            have hre : ((x₂ : ℂ) + (y : ℂ) * I).re = x₂ := by simp
            rw [h] at hre
            linarith))
      exact (hcont.const_mul I).intervalIntegrable
  have hl : I * (∫ y : ℝ in y₁..y₂, (fun z : ℂ => ((z - a) ^ 2)⁻¹) (x₁ + y * I))
      = (fun z : ℂ => -(z - a)⁻¹) (x₁ + y₂ * I) - (fun z : ℂ => -(z - a)⁻¹) (x₁ + y₁ * I) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro y hy
      have hne : (x₁ + y * I : ℂ) ≠ a := by
        intro h
        have hre : (x₁ + y * I : ℂ).re = x₁ := by simp
        rw [h] at hre
        linarith
      have h := hasDerivAt_neg_inv_sub a (x₁ + y * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (x₁ : ℂ) + (t : ℂ) * I) I y := by
        have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
          (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
        have h2 := h1.const_add ((x₁ : ℂ))
        simpa [mul_comm, mul_assoc] using h2
      have := h.comp y hpath
      simpa [Function.comp_def, mul_comm] using this
    · have hcont : ContinuousOn (fun y : ℝ => (((x₁ : ℂ) + (y : ℂ) * I - a) ^ 2)⁻¹) (uIcc y₁ y₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub continuous_const).pow 2 |>.continuousOn
        · intro y hy
          exact pow_ne_zero 2 (sub_ne_zero.mpr (by
            intro h
            have hre : ((x₁ : ℂ) + (y : ℂ) * I).re = x₁ := by simp
            rw [h] at hre
            linarith))
      exact (hcont.const_mul I).intervalIntegrable
  simp only [rectIntegral, hb, ht, hr, hl]
  ring


/-- **Rectangle derivative Cauchy formula**: for `h` holomorphic on a
neighbourhood of the closed rectangle and `a` strictly inside,
`∮ h(z)·((z-a)²)⁻¹ dz = 2πi·h'(a)`. -/
theorem rectIntegral_mul_inv_sq_eq (h : ℂ → ℂ) {U : Set ℂ} {a : ℂ}
    (x₁ x₂ y₁ y₂ : ℝ) (hx : x₁ < x₂) (hy : y₁ < y₂)
    (hU : IsOpen U) (hsub : ([[x₁, x₂]] ×ℂ [[y₁, y₂]]) ⊆ U)
    (hh : DifferentiableOn ℂ h U)
    (ha : a ∈ (Ioo x₁ x₂ ×ℂ Ioo y₁ y₂)) :
    rectIntegral (fun z => h z * ((z - a) ^ 2)⁻¹) x₁ x₂ y₁ y₂
      = deriv h a * (2 * (Real.pi : ℂ) * I) := by
  rw [Complex.mem_reProdIm] at ha
  obtain ⟨⟨ha1, ha2⟩, ⟨ha3, ha4⟩⟩ := ha
  have haU : a ∈ U := by
    apply hsub
    rw [Complex.mem_reProdIm]
    exact ⟨⟨le_trans (min_le_left _ _) (le_of_lt ha1), le_trans (le_of_lt ha2) (le_max_right _ _)⟩,
      ⟨le_trans (min_le_left _ _) (le_of_lt ha3), le_trans (le_of_lt ha4) (le_max_right _ _)⟩⟩
  have hnhds : U ∈ 𝓝 a := hU.mem_nhds haU
  have hphi_diff : DifferentiableOn ℂ (dslope h a) U :=
    (differentiableOn_dslope hnhds).mpr hh
  have hq_diff : DifferentiableOn ℂ (dslope (dslope h a) a) U :=
    (differentiableOn_dslope hnhds).mpr hphi_diff
  have hq_int : rectIntegral (fun z => dslope (dslope h a) a z) x₁ x₂ y₁ y₂ = 0 :=
    rectIntegral_eq_zero_of_differentiableOn _ x₁ x₂ y₁ y₂
      (hq_diff.continuousOn.mono hsub)
      (hq_diff.mono (fun z hz =>
        hsub ⟨Ioo_subset_Icc_self hz.1, Ioo_subset_Icc_self hz.2⟩))
  have hbound_ne : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂, z ≠ a := by
    intro z hz h
    rcases hz.2 with h' | h' | h' | h'
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
    · rw [h] at h'; linarith
  have hpoint : ∀ z ∈ rectBoundarySet x₁ x₂ y₁ y₂,
      h z * ((z - a) ^ 2)⁻¹
        = h a * ((z - a) ^ 2)⁻¹ + deriv h a * (z - a)⁻¹
          + dslope (dslope h a) a z := by
    intro z hz
    have hza : z ≠ a := hbound_ne z hz
    have hd1 : (z - a) * dslope h a z = h z - h a := by
      simpa using sub_smul_dslope h a z
    have hd2 : (z - a) * dslope (dslope h a) a z = dslope h a z - deriv h a := by
      have := sub_smul_dslope (dslope h a) a z
      rw [dslope_same] at this
      simpa using this
    have hne : z - a ≠ 0 := sub_ne_zero.mpr hza
    have hz_eq : h z = h a + (z - a) * deriv h a
        + (z - a) ^ 2 * dslope (dslope h a) a z := by
      have hd2' : dslope h a z = deriv h a + (z - a) * dslope (dslope h a) a z := by
        calc dslope h a z = deriv h a + (dslope h a z - deriv h a) := by ring
          _ = deriv h a + (z - a) * dslope (dslope h a) a z := by rw [← hd2]
      calc h z = h a + (z - a) * dslope h a z := by rw [hd1]; ring
        _ = h a + (z - a) * (deriv h a + (z - a) * dslope (dslope h a) a z) := by
            rw [hd2']
        _ = h a + (z - a) * deriv h a + (z - a) ^ 2 * dslope (dslope h a) a z := by
            ring
    rw [hz_eq]
    field_simp [hne]
  have hcontA : ContinuousOn (fun z : ℂ => h a * ((z - a) ^ 2)⁻¹) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    refine continuousOn_const.mul ?_
    refine ContinuousOn.inv₀ ?_ ?_
    · exact (continuousOn_id.sub continuousOn_const).pow 2
    · intro z hz
      exact pow_ne_zero 2 (sub_ne_zero.mpr (hbound_ne z hz))
  have hcontB : ContinuousOn (fun z : ℂ => deriv h a * (z - a)⁻¹) (rectBoundarySet x₁ x₂ y₁ y₂) := by
    refine continuousOn_const.mul ?_
    exact ContinuousOn.inv₀ (continuousOn_id.sub continuousOn_const)
      (fun z hz => sub_ne_zero.mpr (hbound_ne z hz))
  have hcontC : ContinuousOn (fun z : ℂ => dslope (dslope h a) a z) (rectBoundarySet x₁ x₂ y₁ y₂) :=
    hq_diff.continuousOn.mono (fun z hz => hsub hz.1)
  have hcongr : rectIntegral (fun z => h z * ((z - a) ^ 2)⁻¹) x₁ x₂ y₁ y₂
      = rectIntegral (fun z => h a * ((z - a) ^ 2)⁻¹ + deriv h a * (z - a)⁻¹
          + dslope (dslope h a) a z) x₁ x₂ y₁ y₂ :=
    rectIntegral_congr_boundary (f := fun z => h z * ((z - a) ^ 2)⁻¹)
      (g := fun z => h a * ((z - a) ^ 2)⁻¹ + deriv h a * (z - a)⁻¹
        + dslope (dslope h a) a z) x₁ x₂ y₁ y₂ hpoint
  rw [hcongr]
  rw [rectIntegral_add_boundary (f := fun z => h a * ((z - a) ^ 2)⁻¹ + deriv h a * (z - a)⁻¹)
    (g := fun z => dslope (dslope h a) a z) x₁ x₂ y₁ y₂ (hcontA.add hcontB) hcontC]
  rw [rectIntegral_add_boundary (f := fun z => h a * ((z - a) ^ 2)⁻¹)
    (g := fun z => deriv h a * (z - a)⁻¹) x₁ x₂ y₁ y₂ hcontA hcontB]
  rw [rectIntegral_const_mul, rectIntegral_inv_sq_eq_zero a ha1 ha2 ha3 ha4, mul_zero]
  rw [rectIntegral_const_mul, rectIntegral_inv_of_mem a ha1 ha2 ha3 ha4]
  rw [hq_int]
  ring


/-- Derivative of `-(1/2)·((z-a)²)⁻¹` is `((z-a)³)⁻¹`. -/
theorem hasDerivAt_neg_half_inv_sq (a z : ℂ) (hz : z ≠ a) :
    HasDerivAt (fun w : ℂ => -(1 / 2) * (((w - a) ^ 2)⁻¹)) (((z - a) ^ 3)⁻¹) z := by
  have h1 : HasDerivAt (fun w : ℂ => w - a) 1 z := by
    simpa using (hasDerivAt_id z).sub_const a
  have h2 : HasDerivAt (fun w : ℂ => ((w - a) ^ 2)⁻¹) (-(2 : ℂ) * ((z - a) ^ 3)⁻¹) z := by
    have hsq : HasDerivAt (fun w : ℂ => (w - a) ^ 2) (2 * (z - a)) z := by
      have := h1.pow 2
      simpa [Pi.pow_def] using this
    have hne : (z - a) ^ 2 ≠ 0 := pow_ne_zero 2 (sub_ne_zero.mpr hz)
    have := hsq.inv hne
    convert this using 1
    field_simp
  have h3 : HasDerivAt (fun w : ℂ => -(1 / 2) * ((w - a) ^ 2)⁻¹)
      (-(1 / 2) * (-(2 : ℂ) * ((z - a) ^ 3)⁻¹)) z := h2.const_mul (-(1 / 2))
  convert h3 using 1
  ring

/-- **The inverse-cube winding integral vanishes**: `∮ ((z-a)³)⁻¹ dz = 0`. -/
theorem rectIntegral_inv_cube_eq_zero (a : ℂ) {x₁ x₂ y₁ y₂ : ℝ}
    (hx₁ : x₁ < a.re) (hx₂ : a.re < x₂) (hy₁ : y₁ < a.im) (hy₂ : a.im < y₂) :
    rectIntegral (fun z => (((z - a) ^ 3)⁻¹)) x₁ x₂ y₁ y₂ = 0 := by
  have hb : (∫ x : ℝ in x₁..x₂, (fun z : ℂ => ((z - a) ^ 3)⁻¹) (x + y₁ * I))
      = (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₂ + y₁ * I)
        - (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₁ + y₁ * I) := by
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro x hx
      have hne : (x + y₁ * I : ℂ) ≠ a := by
        intro h
        have him : (x + y₁ * I : ℂ).im = y₁ := by simp
        rw [h] at him
        linarith
      have h := hasDerivAt_neg_half_inv_sq a (x + y₁ * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (t : ℂ) + y₁ * I) 1 x := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const (y₁ * I)
      have := h.comp x hpath
      simpa [Function.comp_def] using this
    · have hcont : ContinuousOn (fun x : ℝ => ((x + (y₁ : ℂ) * I - a) ^ 3)⁻¹) (uIcc x₁ x₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_ofReal.add continuous_const).sub continuous_const).pow 3 |>.continuousOn
        · intro x hx
          exact pow_ne_zero 3 (sub_ne_zero.mpr (by
            intro h
            have him : ((x : ℂ) + y₁ * I).im = y₁ := by simp
            rw [h] at him
            linarith))
      exact hcont.intervalIntegrable
  have ht : (∫ x : ℝ in x₁..x₂, (fun z : ℂ => ((z - a) ^ 3)⁻¹) (x + y₂ * I))
      = (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₂ + y₂ * I)
        - (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₁ + y₂ * I) := by
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro x hx
      have hne : (x + y₂ * I : ℂ) ≠ a := by
        intro h
        have him : (x + y₂ * I : ℂ).im = y₂ := by simp
        rw [h] at him
        linarith
      have h := hasDerivAt_neg_half_inv_sq a (x + y₂ * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (t : ℂ) + y₂ * I) 1 x := by
        simpa using (Complex.ofRealCLM.hasDerivAt (x := x)).add_const (y₂ * I)
      have := h.comp x hpath
      simpa [Function.comp_def] using this
    · have hcont : ContinuousOn (fun x : ℝ => ((x + (y₂ : ℂ) * I - a) ^ 3)⁻¹) (uIcc x₁ x₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_ofReal.add continuous_const).sub continuous_const).pow 3 |>.continuousOn
        · intro x hx
          exact pow_ne_zero 3 (sub_ne_zero.mpr (by
            intro h
            have him : ((x : ℂ) + y₂ * I).im = y₂ := by simp
            rw [h] at him
            linarith))
      exact hcont.intervalIntegrable
  have hr : I * (∫ y : ℝ in y₁..y₂, (fun z : ℂ => ((z - a) ^ 3)⁻¹) (x₂ + y * I))
      = (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₂ + y₂ * I)
        - (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₂ + y₁ * I) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro y hy
      have hne : (x₂ + y * I : ℂ) ≠ a := by
        intro h
        have hre : (x₂ + y * I : ℂ).re = x₂ := by simp
        rw [h] at hre
        linarith
      have h := hasDerivAt_neg_half_inv_sq a (x₂ + y * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (x₂ : ℂ) + (t : ℂ) * I) I y := by
        have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
          (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
        simpa [mul_comm, mul_assoc] using h1.const_add (x₂ : ℂ)
      have := h.comp y hpath
      simpa [Function.comp_def, mul_comm] using this
    · have hcont : ContinuousOn (fun y : ℝ => (((x₂ : ℂ) + (y : ℂ) * I - a) ^ 3)⁻¹) (uIcc y₁ y₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub continuous_const).pow 3 |>.continuousOn
        · intro y hy
          exact pow_ne_zero 3 (sub_ne_zero.mpr (by
            intro h
            have hre : ((x₂ : ℂ) + (y : ℂ) * I).re = x₂ := by simp
            rw [h] at hre
            linarith))
      exact (hcont.const_mul I).intervalIntegrable
  have hl : I * (∫ y : ℝ in y₁..y₂, (fun z : ℂ => ((z - a) ^ 3)⁻¹) (x₁ + y * I))
      = (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₁ + y₂ * I)
        - (fun z : ℂ => -(1 / 2) * (((z - a) ^ 2)⁻¹)) (x₁ + y₁ * I) := by
    rw [← intervalIntegral.integral_const_mul]
    apply intervalIntegral.integral_eq_sub_of_hasDerivAt
    · intro y hy
      have hne : (x₁ + y * I : ℂ) ≠ a := by
        intro h
        have hre : (x₁ + y * I : ℂ).re = x₁ := by simp
        rw [h] at hre
        linarith
      have h := hasDerivAt_neg_half_inv_sq a (x₁ + y * I) hne
      have hpath : HasDerivAt (fun t : ℝ => (x₁ : ℂ) + (t : ℂ) * I) I y := by
        have h1 : HasDerivAt (fun t : ℝ => (t : ℂ) * I) (1 * I) y :=
          (Complex.ofRealCLM.hasDerivAt (x := y)).mul_const I
        simpa [mul_comm, mul_assoc] using h1.const_add (x₁ : ℂ)
      have := h.comp y hpath
      simpa [Function.comp_def, mul_comm] using this
    · have hcont : ContinuousOn (fun y : ℝ => (((x₁ : ℂ) + (y : ℂ) * I - a) ^ 3)⁻¹) (uIcc y₁ y₂) := by
        apply ContinuousOn.inv₀
        · exact ((continuous_const.add (continuous_ofReal.mul continuous_const)).sub continuous_const).pow 3 |>.continuousOn
        · intro y hy
          exact pow_ne_zero 3 (sub_ne_zero.mpr (by
            intro h
            have hre : ((x₁ : ℂ) + (y : ℂ) * I).re = x₁ := by simp
            rw [h] at hre
            linarith))
      exact (hcont.const_mul I).intervalIntegrable
  simp only [rectIntegral, hb, ht, hr, hl]
  ring

end AbsoluteHodgeRectangle
