/-
  Rh45/ArgumentPrinciple.lean — the rectangle argument principle.

  `Rh45/RouteBAnalytic.lean` reduces Route B to the "argument principle"
  hypothesis `hAP : rectBoundary (logDeriv f) t₀ t₁ = 2πi Z`.  This module supplies
  the missing Mathlib ingredient for the *rectangle*: the winding number of a
  point `a` with respect to `∂([0,1] × [t₀,t₁])`,

      ∮_{∂R} (s − a)⁻¹ ds = 2πi   (a strictly inside),
                          = 0     (a outside the closed rectangle),

  and the resulting factorised argument principle

      f s = C · ∏_{z ∈ Z} (s − z) ^ (m z),  C ≠ 0
        ⟹  rectBoundary (logDeriv f) t₀ t₁ = 2πi · ∑_{z ∈ Z} m z,

  with every `z ∈ Z` strictly inside the rectangle and `Z` a `Finset`.

  The winding-number computation is a direct interval-integral bookkeeping: on
  each of the four edges `1 / (s − a)` has an explicit antiderivative whose
  domain of validity is checked by hand.

  * horizontal edge at height `t` (with `a` strictly between `t₀` and `t₁`, so
    `Im(x + it − a) = t − a.im` is either `> 0` or `< 0`, hence never on the slit):
    `∫₀¹ (x + it − a)⁻¹ dx = log(1 − a + it) − log(−a + it)`;
  * right vertical edge (`Re = 1 > a.re`, so it lies in the open right half
    plane, a subset of the slit plane):
    `∫_t₀^t₁ i (1 + iy − a)⁻¹ dy = log(1 − a + it₁) − log(1 − a + it₀)`;
  * left vertical edge (`Re = 0 < a.re`): here `iy − a` *does* cross the slit, so
    we use the antiderivative `log(a − iy)` of `i / (iy − a)` instead (its argument
    `a − iy` has positive real part):
    `∫_t₀^t₁ i (iy − a)⁻¹ dy = log(a − it₁) − log(a − it₀)`.

  Writing `u₀ = a − it₀` (first quadrant: `Im u₀ = a.im − t₀ > 0`) and
  `u₁ = a − it₁` (fourth quadrant: `Im u₁ = a.im − t₁ < 0`), the four boundary
  integrals telescope to

      (log u₀ − log(−u₀)) + (log(−u₁) − log u₁) = πi + πi = 2πi,

  where each `πi` is `Complex.arg`'s jump across the negative real axis, read off
  from `Complex.arg_neg_eq_arg_sub_pi_of_im_pos` /
  `Complex.arg_neg_eq_arg_add_pi_of_im_neg`.

  See `ARGUMENT_PRINCIPLE.md` for the precise inventory of what is proved, what is
  assumed, and what Mathlib is missing.
-/
import Rh45.RouteBAnalytic

open MeasureTheory intervalIntegral
open scoped ComplexConjugate
open Filter
open scoped Topology

namespace Rh45RouteBAnalytic

noncomputable section

/-! ## Integrals of `(s − a)⁻¹` along the edges of the rectangle -/

/-- **Fundamental theorem of calculus for `Complex.log` along a horizontal
segment.**  If the segment `{x + c | x ∈ [0,1]}` stays in the slit plane, then
`∫₀¹ (x + c)⁻¹ dx = log (1 + c) − log c`.  (`Complex.log` is differentiable with
derivative `z⁻¹` on the slit plane, `Complex.hasDerivAt_log`.) -/
theorem integral_inv_horizontal (c : ℂ)
    (hc : ∀ x ∈ Set.uIcc (0 : ℝ) 1, (x : ℂ) + c ∈ Complex.slitPlane) :
    (∫ x in (0 : ℝ)..1, ((x : ℂ) + c)⁻¹) = Complex.log (1 + c) - Complex.log c := by
  have hderiv : ∀ x ∈ Set.uIcc (0 : ℝ) 1,
      HasDerivAt (fun x : ℝ => Complex.log ((x : ℂ) + c)) (((x : ℂ) + c)⁻¹) x := by
    intro x hx
    have h1 : HasDerivAt (fun x : ℝ => (x : ℂ) + c) 1 x := by
      simpa using (hasDerivAt_id x).ofReal_comp.add_const c
    have h4 := (Complex.hasDerivAt_log (hc x hx)).comp x h1
    rw [Function.comp_def] at h4
    simpa using h4
  have hint : IntervalIntegrable (fun x : ℝ => ((x : ℂ) + c)⁻¹) volume 0 1 :=
    (ContinuousOn.inv₀ (by fun_prop)
      (fun x hx => Complex.slitPlane_ne_zero (hc x hx))).intervalIntegrable
  have h := integral_eq_sub_of_hasDerivAt hderiv hint
  simpa using h

/-- **FTC for `log` along the right vertical edge** `Re s = 1` of the rectangle:
`∫_{t₀}^{t₁} i (1 − a + iy)⁻¹ dy = log (1 − a + it₁) − log (1 − a + it₀)`. -/
theorem integral_inv_vertical_right (a : ℂ) (t0 t1 : ℝ)
    (h : ∀ y ∈ Set.uIcc t0 t1, (1 - a + (y : ℂ) * Complex.I) ∈ Complex.slitPlane) :
    (∫ y in t0..t1, Complex.I * ((1 - a + (y : ℂ) * Complex.I)⁻¹)) =
      Complex.log (1 - a + (t1 : ℂ) * Complex.I)
        - Complex.log (1 - a + (t0 : ℂ) * Complex.I) := by
  have hderiv : ∀ y ∈ Set.uIcc t0 t1,
      HasDerivAt (fun y : ℝ => Complex.log (1 - a + (y : ℂ) * Complex.I))
        (Complex.I * ((1 - a + (y : ℂ) * Complex.I)⁻¹)) y := by
    intro y hy
    have h1 : HasDerivAt (fun y : ℝ => 1 - a + (y : ℂ) * Complex.I) Complex.I y := by
      have h2 : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 y := (hasDerivAt_id y).ofReal_comp
      have h3 : HasDerivAt (fun y : ℝ => (y : ℂ) * Complex.I) (1 * Complex.I) y :=
        h2.mul_const Complex.I
      simpa using h3.const_add (1 - a)
    have h4 := (Complex.hasDerivAt_log (h y hy)).comp y h1
    rw [Function.comp_def, mul_comm] at h4
    simpa using h4
  have hint : IntervalIntegrable
      (fun y : ℝ => Complex.I * ((1 - a + (y : ℂ) * Complex.I)⁻¹)) volume t0 t1 :=
    (ContinuousOn.const_mul (ContinuousOn.inv₀ (by fun_prop)
      (fun y hy => Complex.slitPlane_ne_zero (h y hy))) Complex.I).intervalIntegrable
  have hres := integral_eq_sub_of_hasDerivAt hderiv hint
  simpa using hres

/-- **FTC for `log` along the left vertical edge** `Re s = 0` of the rectangle:
`∫_{t₀}^{t₁} i (iy − a)⁻¹ dy = log (a − it₁) − log (a − it₀)`.
The antiderivative is `log (a − iy)`, whose argument `a − iy` has positive real
part `a.re > 0` and hence stays in the slit plane; this is what avoids the slit
crossing of the naive `log (iy − a)`. -/
theorem integral_inv_vertical_left (a : ℂ) (t0 t1 : ℝ)
    (h : ∀ y ∈ Set.uIcc t0 t1, (a - (y : ℂ) * Complex.I) ∈ Complex.slitPlane) :
    (∫ y in t0..t1, Complex.I * (((y : ℂ) * Complex.I - a)⁻¹)) =
      Complex.log (a - (t1 : ℂ) * Complex.I) - Complex.log (a - (t0 : ℂ) * Complex.I) := by
  have hderiv : ∀ y ∈ Set.uIcc t0 t1,
      HasDerivAt (fun y : ℝ => Complex.log (a - (y : ℂ) * Complex.I))
        (Complex.I * (((y : ℂ) * Complex.I - a)⁻¹)) y := by
    intro y hy
    have h1 : HasDerivAt (fun y : ℝ => (y : ℂ)) 1 y := (hasDerivAt_id y).ofReal_comp
    have h2 : HasDerivAt (fun y : ℝ => (y : ℂ) * Complex.I) (1 * Complex.I) y :=
      h1.mul_const Complex.I
    have h3 : HasDerivAt (fun y : ℝ => a - (y : ℂ) * Complex.I) (-(1 * Complex.I)) y :=
      h2.const_sub a
    have h4 := (Complex.hasDerivAt_log (h y hy)).comp y h3
    rw [Function.comp_def] at h4
    have hiff : (a - (y : ℂ) * Complex.I)⁻¹ * -(1 * Complex.I)
        = Complex.I * (((y : ℂ) * Complex.I - a)⁻¹) := by
      rw [one_mul]
      have hneg : (y : ℂ) * Complex.I - a = -(a - (y : ℂ) * Complex.I) := by ring
      rw [hneg, inv_neg]
      ring
    rw [hiff] at h4
    simpa using h4
  have hint : IntervalIntegrable
      (fun y : ℝ => Complex.I * (((y : ℂ) * Complex.I - a)⁻¹)) volume t0 t1 := by
    have hcont : ContinuousOn (fun y : ℝ => ((y : ℂ) * Complex.I - a)⁻¹) (Set.uIcc t0 t1) :=
      ContinuousOn.inv₀ (by fun_prop) (fun y hy => by
        have hne := Complex.slitPlane_ne_zero (h y hy)
        intro hzero
        apply hne
        rw [show a - (y : ℂ) * Complex.I = -((y : ℂ) * Complex.I - a) by ring,
          hzero, neg_zero])
    exact (hcont.const_mul Complex.I).intervalIntegrable
  have hres := integral_eq_sub_of_hasDerivAt hderiv hint
  simpa using hres

/-! ## The two `arg` jumps of `Complex.log` -/

/-- **Jump of `log` across the negative real axis, upper side.**  If `Im u > 0`
then `log u − log(−u) = πi`: this is the change of `Complex.arg` when passing from
`u` to `−u` through the lower half-plane. -/
theorem log_sub_log_neg (u : ℂ) (h : 0 < u.im) :
    Complex.log u - Complex.log (-u) = (Real.pi : ℂ) * Complex.I := by
  have harg : (-u).arg = u.arg - Real.pi := Complex.arg_neg_eq_arg_sub_pi_of_im_pos h
  have h1 : Complex.log u = (Real.log ‖u‖ : ℂ) + (u.arg : ℂ) * Complex.I := rfl
  have h2 : Complex.log (-u) = (Real.log ‖u‖ : ℂ) + ((-u).arg : ℂ) * Complex.I := by
    rw [show Complex.log (-u) = (Real.log ‖-u‖ : ℂ) + ((-u).arg : ℂ) * Complex.I from rfl,
      norm_neg]
  rw [h1, h2, harg]
  push_cast
  ring

/-- **Jump of `log` across the negative real axis, lower side.**  If `Im u < 0`
then `log(−u) − log u = πi`. -/
theorem log_neg_sub_log (u : ℂ) (h : u.im < 0) :
    Complex.log (-u) - Complex.log u = (Real.pi : ℂ) * Complex.I := by
  have harg : (-u).arg = u.arg + Real.pi := Complex.arg_neg_eq_arg_add_pi_of_im_neg h
  have h1 : Complex.log u = (Real.log ‖u‖ : ℂ) + (u.arg : ℂ) * Complex.I := rfl
  have h2 : Complex.log (-u) = (Real.log ‖u‖ : ℂ) + ((-u).arg : ℂ) * Complex.I := by
    rw [show Complex.log (-u) = (Real.log ‖-u‖ : ℂ) + ((-u).arg : ℂ) * Complex.I from rfl,
      norm_neg]
  rw [h1, h2, harg]
  push_cast
  ring

/-! ## The winding number of a point with respect to the rectangle `[0,1] × [t₀,t₁]` -/

/-- A complex number with nonzero imaginary part lies in the slit plane. -/
theorem mem_slitPlane_of_im_ne_zero {z : ℂ} (h : z.im ≠ 0) : z ∈ Complex.slitPlane :=
  Or.inr h

/-- **The rectangle winding number: a point strictly inside.**  For `0 < a.re < 1`
and `t₀ < a.im < t₁`, the integral of `(s − a)⁻¹` over the boundary of
`[0,1] × [t₀,t₁]`, in the normal form `rectBoundary`, equals `2πi`.

The four edge integrals are computed by the FTC for `Complex.log`
(`integral_inv_horizontal`, `integral_inv_vertical_right`,
`integral_inv_vertical_left`); with `u₀ = a − it₀` in the upper half plane and
`u₁ = a − it₁` in the lower half plane they telescope to
`(log u₀ − log(−u₀)) + (log(−u₁) − log u₁) = πi + πi`. -/
theorem rectBoundary_inv_of_mem (a : ℂ) (t0 t1 : ℝ)
    (hre0 : 0 < a.re) (hre1 : a.re < 1) (him0 : t0 < a.im) (him1 : a.im < t1) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 2 * (Real.pi : ℂ) * Complex.I := by
  -- The four edges of the rectangle stay in the slit plane.
  have h_h0 : ∀ x ∈ Set.uIcc (0 : ℝ) 1, (x : ℂ) + ((t0 : ℂ) * Complex.I - a) ∈
      Complex.slitPlane := by
    intro x hx
    refine mem_slitPlane_of_im_ne_zero ?_
    have him : ((x : ℂ) + ((t0 : ℂ) * Complex.I - a)).im = t0 - a.im := by
      simp [Complex.add_im, Complex.sub_im, Complex.mul_im]
    rw [him]; linarith
  have h_h1 : ∀ x ∈ Set.uIcc (0 : ℝ) 1, (x : ℂ) + ((t1 : ℂ) * Complex.I - a) ∈
      Complex.slitPlane := by
    intro x hx
    refine mem_slitPlane_of_im_ne_zero ?_
    have him : ((x : ℂ) + ((t1 : ℂ) * Complex.I - a)).im = t1 - a.im := by
      simp [Complex.add_im, Complex.sub_im, Complex.mul_im]
    rw [him]; linarith
  have h_v1 : ∀ y ∈ Set.uIcc t0 t1, (1 - a + (y : ℂ) * Complex.I) ∈ Complex.slitPlane := by
    intro y hy
    refine Or.inl ?_
    have hre : (1 - a + (y : ℂ) * Complex.I).re = 1 - a.re := by
      simp [Complex.add_re, Complex.sub_re, Complex.mul_re]
    rw [hre]; linarith
  have h_v0 : ∀ y ∈ Set.uIcc t0 t1, (a - (y : ℂ) * Complex.I) ∈ Complex.slitPlane := by
    intro y hy
    refine Or.inl ?_
    have hre : (a - (y : ℂ) * Complex.I).re = a.re := by
      simp [Complex.sub_re, Complex.mul_re]
    rw [hre]; linarith
  -- abbreviations
  set u0 : ℂ := a - (t0 : ℂ) * Complex.I with hu0
  set u1 : ℂ := a - (t1 : ℂ) * Complex.I with hu1
  have ht0 : (t0 : ℂ) * Complex.I - a = -u0 := by rw [hu0]; ring
  have ht1 : (t1 : ℂ) * Complex.I - a = -u1 := by rw [hu1]; ring
  have hu0' : 1 - a + (t0 : ℂ) * Complex.I = 1 - u0 := by rw [hu0]; ring
  have hu1' : 1 - a + (t1 : ℂ) * Complex.I = 1 - u1 := by rw [hu1]; ring
  -- horizontal edge at height `t₀`
  have hA0 : (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t0 : ℂ) * Complex.I) - a)⁻¹)
      = Complex.log (1 - u0) - Complex.log (-u0) := by
    have hconv : (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t0 : ℂ) * Complex.I) - a)⁻¹)
        = ∫ x in (0 : ℝ)..1, ((x : ℂ) + (-u0))⁻¹ := by
      apply intervalIntegral.integral_congr
      intro x hx
      have hx_eq : ((x : ℂ) + (t0 : ℂ) * Complex.I) - a = (x : ℂ) + (-u0) := by
        rw [show ((x : ℂ) + (t0 : ℂ) * Complex.I) - a
              = (x : ℂ) + ((t0 : ℂ) * Complex.I - a) by ring, ht0]
      simp only [hx_eq]
    rw [hconv]
    have hh : ∀ x ∈ Set.uIcc (0 : ℝ) 1, (x : ℂ) + (-u0) ∈ Complex.slitPlane := by
      intro x hx
      rw [← ht0]
      exact h_h0 x hx
    rw [integral_inv_horizontal (-u0) hh, show (1 : ℂ) + -u0 = 1 - u0 by ring]
  -- horizontal edge at height `t₁`
  have hA1 : (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t1 : ℂ) * Complex.I) - a)⁻¹)
      = Complex.log (1 - u1) - Complex.log (-u1) := by
    have hconv : (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t1 : ℂ) * Complex.I) - a)⁻¹)
        = ∫ x in (0 : ℝ)..1, ((x : ℂ) + (-u1))⁻¹ := by
      apply intervalIntegral.integral_congr
      intro x hx
      have hx_eq : ((x : ℂ) + (t1 : ℂ) * Complex.I) - a = (x : ℂ) + (-u1) := by
        rw [show ((x : ℂ) + (t1 : ℂ) * Complex.I) - a
              = (x : ℂ) + ((t1 : ℂ) * Complex.I - a) by ring, ht1]
      simp only [hx_eq]
    rw [hconv]
    have hh : ∀ x ∈ Set.uIcc (0 : ℝ) 1, (x : ℂ) + (-u1) ∈ Complex.slitPlane := by
      intro x hx
      rw [← ht1]
      exact h_h1 x hx
    rw [integral_inv_horizontal (-u1) hh, show (1 : ℂ) + -u1 = 1 - u1 by ring]
  -- right vertical edge
  have hB1 : Complex.I * (∫ y in t0..t1, (((1 : ℂ) + (y : ℂ) * Complex.I) - a)⁻¹)
      = Complex.log (1 - u1) - Complex.log (1 - u0) := by
    have hconv : (∫ y in t0..t1, (((1 : ℂ) + (y : ℂ) * Complex.I) - a)⁻¹)
        = ∫ y in t0..t1, (1 - a + (y : ℂ) * Complex.I)⁻¹ := by
      apply intervalIntegral.integral_congr
      intro y hy
      ring
    rw [hconv, ← intervalIntegral.integral_const_mul,
      integral_inv_vertical_right a t0 t1 h_v1, hu1', hu0']
  -- left vertical edge
  have hB0 : Complex.I * (∫ y in t0..t1, (((y : ℂ) * Complex.I) - a)⁻¹)
      = Complex.log u1 - Complex.log u0 := by
    rw [← intervalIntegral.integral_const_mul,
      integral_inv_vertical_left a t0 t1 h_v0, ← hu1, ← hu0]
  -- telescope
  have hgoal : rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1
      = (Complex.log u0 - Complex.log (-u0)) + (Complex.log (-u1) - Complex.log u1) := by
    show (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t0 : ℂ) * Complex.I) - a)⁻¹)
        - (∫ x in (0 : ℝ)..1, (((x : ℂ) + (t1 : ℂ) * Complex.I) - a)⁻¹)
        + Complex.I * (∫ y in t0..t1, (((1 : ℂ) + (y : ℂ) * Complex.I) - a)⁻¹)
        - Complex.I * (∫ y in t0..t1, (((y : ℂ) * Complex.I) - a)⁻¹)
        = (Complex.log u0 - Complex.log (-u0)) + (Complex.log (-u1) - Complex.log u1)
    rw [hA0, hA1, hB1, hB0]
    ring
  rw [hgoal]
  have him_u0 : 0 < u0.im := by
    rw [hu0]
    simp only [Complex.sub_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, mul_one, mul_zero]
    linarith
  have him_u1 : u1.im < 0 := by
    rw [hu1]
    simp only [Complex.sub_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, mul_one, mul_zero]
    linarith
  rw [log_sub_log_neg u0 him_u0, log_neg_sub_log u1 him_u1]
  ring

/-- **The rectangle winding number: a point outside the closed rectangle.**
For `a` outside `[[0,1]] ×ℂ [[t₀,t₁]]`, the integrand `(s − a)⁻¹` is holomorphic on
a neighbourhood of the closed rectangle, so Cauchy–Goursat for a rectangle
(`Complex.integral_boundary_rect_eq_zero_of_differentiableOn`) gives `0`. -/
theorem rectBoundary_inv_of_notMem (a : ℂ) (t0 t1 : ℝ)
    (ha : a ∉ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1)) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 0 := by
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn
    (fun s : ℂ => (s - a)⁻¹) ((t0 : ℂ) * Complex.I) (1 + (t1 : ℂ) * Complex.I) ?_
  · simpa [rectBoundary] using h
  · intro s hs
    have hs' : s ∈ Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1 := by
      simpa [Complex.mul_re, Complex.mul_im, Complex.add_re, Complex.add_im] using hs
    have hsne : s - a ≠ 0 := by
      intro hzero
      have hsa : s = a := sub_eq_zero.mp hzero
      exact ha (hsa ▸ hs')
    exact ((differentiableAt_id.sub_const a).inv hsne).differentiableWithinAt

/-- **The rectangle winding number: an explicit outside condition.**  If `t₀ ≤ t₁`
and `a.re ∉ [0,1]` or `a.im ∉ [t₀,t₁]`, then `∮_{∂R} (s − a)⁻¹ = 0`. -/
theorem rectBoundary_inv_of_outside (a : ℂ) (t0 t1 : ℝ) (ht : t0 ≤ t1)
    (h : a.re < 0 ∨ 1 < a.re ∨ a.im < t0 ∨ t1 < a.im) :
    rectBoundary (fun s : ℂ => (s - a)⁻¹) t0 t1 = 0 := by
  refine rectBoundary_inv_of_notMem a t0 t1 ?_
  intro ha
  rw [Complex.mem_reProdIm] at ha
  obtain ⟨hre, him⟩ := ha
  rw [Set.uIcc_of_le (by norm_num : (0 : ℝ) ≤ 1), Set.mem_Icc] at hre
  rw [Set.uIcc_of_le ht, Set.mem_Icc] at him
  rcases h with h | h | h | h <;> linarith

/-! ## Linearity of `rectBoundary` in the integrand -/

/-- `rectBoundary` is `ℂ`-homogeneous in the integrand: the four edge integrals are
linear and the outer factors `I` commute with the scalar.  No integrability
hypothesis is needed, since `intervalIntegral.integral_const_mul` is unconditional. -/
theorem rectBoundary_const_mul (c : ℂ) (f : ℂ → ℂ) (t0 t1 : ℝ) :
    rectBoundary (fun s => c * f s) t0 t1 = c * rectBoundary f t0 t1 := by
  simp only [rectBoundary]
  rw [intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul,
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const_mul]
  ring

/-- `rectBoundary` is additive over a finite sum of integrands, provided each
summand is interval-integrable on the four edges. -/
theorem rectBoundary_finsetSum {ι : Type*} (Z : Finset ι) (F : ι → ℂ → ℂ) (t0 t1 : ℝ)
    (h0 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ => F z (x + t0 * Complex.I)) volume 0 1)
    (h1 : ∀ z ∈ Z, IntervalIntegrable (fun x : ℝ => F z (x + t1 * Complex.I)) volume 0 1)
    (h2 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ => F z (1 + y * Complex.I)) volume t0 t1)
    (h3 : ∀ z ∈ Z, IntervalIntegrable (fun y : ℝ => F z (y * Complex.I)) volume t0 t1) :
    rectBoundary (fun s => ∑ z ∈ Z, F z s) t0 t1 = ∑ z ∈ Z, rectBoundary (F z) t0 t1 := by
  simp only [rectBoundary]
  rw [intervalIntegral.integral_finsetSum h0, intervalIntegral.integral_finsetSum h1,
    intervalIntegral.integral_finsetSum h2, intervalIntegral.integral_finsetSum h3]
  simp only [Finset.mul_sum, Finset.sum_add_distrib, Finset.sum_sub_distrib]

/-! ## Logarithmic derivative of a finite product of powers -/

/-- `logDeriv` of `s ↦ s − z` is `s ↦ (s − z)⁻¹`. -/
theorem logDeriv_sub_const (z x : ℂ) : logDeriv (fun s : ℂ => s - z) x = (x - z)⁻¹ := by
  have hderiv : deriv (fun s : ℂ => s - z) x = 1 := by simp
  rw [logDeriv_apply, hderiv, one_div]

/-- **Logarithmic derivative of a factorised function.**  If `Z` is a finite set of
points and `m` assigns a multiplicity to each, then away from `Z`

  `logDeriv (fun s => C · ∏_{z∈Z} (s − z)^(m z)) s = ∑_{z∈Z} (m z) · (s − z)⁻¹`. -/
theorem logDeriv_prod_pow (Z : Finset ℂ) (m : ℂ → ℕ) (C : ℂ) (hC : C ≠ 0) (x : ℂ)
    (hx : ∀ z ∈ Z, x ≠ z) :
    logDeriv (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z)) x
      = ∑ z ∈ Z, (m z : ℂ) * (x - z)⁻¹ := by
  rw [logDeriv_const_mul x C hC,
    show (fun s : ℂ => ∏ z ∈ Z, (s - z) ^ (m z))
        = ∏ z ∈ Z, (fun s : ℂ => (s - z) ^ (m z)) from (Finset.prod_fn Z _).symm,
    logDeriv_prod (f := fun z s => (s - z) ^ (m z)) (s := Z) (x := x)
      (fun z hz => pow_ne_zero _ (sub_ne_zero.mpr (hx z hz))) (fun z hz => by fun_prop)]
  refine Finset.sum_congr rfl fun z hz => ?_
  rw [logDeriv_fun_pow (by fun_prop) (m z), logDeriv_sub_const]

/-! ## The factorised argument principle -/

/-- **The rectangle argument principle, factorised form.**  Suppose that on the
closed rectangle `R = [[0,1]] ×ℂ [[t₀,t₁]]` the function `f` agrees locally with a
finite product of powers,

  `f =ᶠ[𝓝 s] (fun s => C · ∏_{z∈Z} (s − z)^(m z))`  for every `s ∈ R`, `C ≠ 0`,

with every `z ∈ Z` strictly inside `R`.  Then

  `∮_{∂R} f′/f = 2πi · ∑_{z∈Z} m z`,

the multiplicity-weighted number of zeros of `f` in `R`.  This is the `hAP`
hypothesis of `routeB_reduction` in its factorised (hence unconditional) form. -/
theorem argument_principle_factorized (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (C : ℂ) (hC : C ≠ 0)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      f =ᶠ[𝓝 s] (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z))) :
    rectBoundary (logDeriv f) t0 t1
      = 2 * (Real.pi : ℂ) * Complex.I * (∑ z ∈ Z, (m z : ℂ)) := by
  set g : ℂ → ℂ := fun s => C * ∏ z ∈ Z, (s - z) ^ (m z) with hg
  -- on the rectangle, `logDeriv f = logDeriv g`
  have hlog : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), logDeriv f s = logDeriv g s := by
    intro s hs
    rw [hg]
    exact (logDeriv_congr_nhds (hfac s hs)).eq_of_nhds
  -- and `logDeriv g` is the sum of the `m z / (s - z)`
  have hgval : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1), (∀ z ∈ Z, s ≠ z) →
      logDeriv g s = ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹ := by
    intro s hs hsz
    rw [hg]
    exact logDeriv_prod_pow Z m C hC s hsz
  -- membership of the four edges in the rectangle
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
  -- the four edges avoid the zeros `Z`
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
  -- replace `logDeriv f` by the explicit sum on each edge
  have i0 : (∫ x in (0 : ℝ)..1, logDeriv f (x + t0 * Complex.I))
      = ∫ x in (0 : ℝ)..1, ∑ z ∈ Z, (m z : ℂ) * ((x + t0 * Complex.I) - z)⁻¹ := by
    apply intervalIntegral.integral_congr
    intro x hx
    change logDeriv f (x + t0 * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * ((x + t0 * Complex.I) - z)⁻¹
    rw [hlog _ (memR0 x hx), hgval _ (memR0 x hx) fun z hz => ne0 z hz x]
  have i1 : (∫ x in (0 : ℝ)..1, logDeriv f (x + t1 * Complex.I))
      = ∫ x in (0 : ℝ)..1, ∑ z ∈ Z, (m z : ℂ) * ((x + t1 * Complex.I) - z)⁻¹ := by
    apply intervalIntegral.integral_congr
    intro x hx
    change logDeriv f (x + t1 * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * ((x + t1 * Complex.I) - z)⁻¹
    rw [hlog _ (memR1 x hx), hgval _ (memR1 x hx) fun z hz => ne1 z hz x]
  have i2 : (∫ y in t0..t1, logDeriv f (1 + y * Complex.I))
      = ∫ y in t0..t1, ∑ z ∈ Z, (m z : ℂ) * ((1 + y * Complex.I) - z)⁻¹ := by
    apply intervalIntegral.integral_congr
    intro y hy
    change logDeriv f (1 + y * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * ((1 + y * Complex.I) - z)⁻¹
    rw [hlog _ (memRv1 y hy), hgval _ (memRv1 y hy) fun z hz => nev1 z hz y]
  have i3 : (∫ y in t0..t1, logDeriv f (y * Complex.I))
      = ∫ y in t0..t1, ∑ z ∈ Z, (m z : ℂ) * ((y * Complex.I) - z)⁻¹ := by
    apply intervalIntegral.integral_congr
    intro y hy
    change logDeriv f (y * Complex.I)
      = ∑ z ∈ Z, (m z : ℂ) * ((y * Complex.I) - z)⁻¹
    rw [hlog _ (memRv0 y hy), hgval _ (memRv0 y hy) fun z hz => nev0 z hz y]
  have hEq : rectBoundary (logDeriv f) t0 t1
      = rectBoundary (fun s : ℂ => ∑ z ∈ Z, (m z : ℂ) * (s - z)⁻¹) t0 t1 := by
    simp only [rectBoundary]
    rw [i0, i1, i2, i3]
  rw [hEq]
  -- each summand is interval-integrable on the four edges
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
      linarith [(hmem z hz).2.2.1]
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
      linarith [(hmem z hz).2.2.2]
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
      linarith [(hmem z hz).2.1]
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
      linarith [(hmem z hz).1]
    exact (hcont.const_mul (m z)).intervalIntegrable
  rw [rectBoundary_finsetSum Z (fun z s => (m z : ℂ) * (s - z)⁻¹) t0 t1
    int0 int1 int2 int3]
  have hz : ∀ z ∈ Z, rectBoundary (fun s : ℂ => (m z : ℂ) * (s - z)⁻¹) t0 t1
      = (m z : ℂ) * (2 * (Real.pi : ℂ) * Complex.I) := by
    intro z hz
    rw [rectBoundary_const_mul]
    congr 1
    exact rectBoundary_inv_of_mem z t0 t1 (hmem z hz).1 (hmem z hz).2.1
      (hmem z hz).2.2.1 (hmem z hz).2.2.2
  rw [show (∑ z ∈ Z, rectBoundary (fun s : ℂ => (m z : ℂ) * (s - z)⁻¹) t0 t1)
      = ∑ z ∈ Z, ((m z : ℂ) * (2 * (Real.pi : ℂ) * Complex.I)) from
        Finset.sum_congr rfl hz,
    ← Finset.sum_mul]
  ring

/-! ## Discharging the `hAP` hypothesis of Route B -/

/-- **Route B with the argument principle discharged (factorised case).**  Under the
same factorisation hypothesis as `argument_principle_factorized`, together with the
two structural properties of `ξ` (`f(1 − s) = f(s)` and `f(conj s) = conj (f s)`),
the argument-principle hypothesis `hAP` of `routeB_reduction` is supplied by
`argument_principle_factorized` and

  `Im(I₃) = π · ∑_{z∈Z} m z`,

i.e. `N(T) = Im(I₃)/π` with the zero count `∑_{z∈Z} m z` no longer an assumption.

**Superseded.**  The factorisation hypothesis `hfac` (and the constant `C`) is no longer
needed: `Rh45/RouteBGeneral.lean`'s `routeB_reduction_general` derives the same conclusion
from analyticity of `f` plus the zero data alone, using the zero-division factorisation of
`Rh45/Weierstrass.lean`.  This theorem is kept only for compatibility. -/
theorem routeB_reduction_factorized (f : ℂ → ℂ) (t0 t1 : ℝ) (Z : Finset ℂ) (m : ℂ → ℕ)
    (C : ℂ) (hC : C ≠ 0)
    (hmem : ∀ z ∈ Z, 0 < z.re ∧ z.re < 1 ∧ t0 < z.im ∧ z.im < t1)
    (hfac : ∀ s ∈ (Set.uIcc (0 : ℝ) 1 ×ℂ Set.uIcc t0 t1),
      f =ᶠ[𝓝 s] (fun s : ℂ => C * ∏ z ∈ Z, (s - z) ^ (m z)))
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t0 * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t1 * Complex.I)) volume 0 1) :
    (rightPath (logDeriv f) t0 t1).im = Real.pi * (∑ z ∈ Z, (m z : ℝ)) := by
  have hAP := argument_principle_factorized f t0 t1 Z m C hC hmem hfac
  have hcast : (((∑ z ∈ Z, (m z : ℝ)) : ℝ) : ℂ) = ∑ z ∈ Z, (m z : ℂ) := by
    rw [Complex.ofReal_sum]
    exact Finset.sum_congr rfl fun z _ => by simp
  rw [← hcast] at hAP
  exact routeB_reduction_of_functional_equation f t0 t1 h1 h2 hint₀ hint₁
    (∑ z ∈ Z, (m z : ℝ)) hAP

end

end Rh45RouteBAnalytic
