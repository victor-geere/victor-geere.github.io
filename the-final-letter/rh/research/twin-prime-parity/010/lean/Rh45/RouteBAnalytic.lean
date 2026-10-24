/-
  Rh45/RouteBAnalytic.lean — the analytic layer of Route B.

  Route B's Turing window rests on the identity

      N(T) = Im(I₃)/π,      I₃ = ∫_{(½,½)→(1,½)→(1,T)→(½,T)} (ξ′/ξ) ds,

  where `ξ(s) = ½ s (s−1) π^{−s/2} Γ(s/2) ζ(s)` and `N(T)` counts the zeros of `ξ`
  in the rectangle.  `Rh45/Routes.lean` formalises the set-theoretic Turing step;
  this module formalises the analytic *symmetric* step behind the identity:

  * the functional equation `ξ(1 − s) = ξ(s)` for Mathlib's completed zeta function
    (there is no `riemannXi` in Mathlib, so `ξ` is built here from
    `completedRiemannZeta`);
  * the reflection identities for the logarithmic derivative,
    `logDeriv f (1 − s) = −logDeriv f s` and `logDeriv f (conj s) = conj (logDeriv f s)`;
  * the contour reduction: if `g` satisfies the single pointwise symmetry
    `g (1 − conj s) = −conj (g s)` (which is exactly what `ξ′/ξ` satisfies given the
    functional equation and the reality of `ξ`), then the integral of `g` over the
    full boundary of the rectangle `[0,1] × [t₀,t₁]` equals
    `I₃ − conj I₃ = 2 i · Im I₃`, the three-segment path integral being `I₃`;
  * consequently, if the argument principle supplies
    `rectBoundary g t₀ t₁ = 2πi Z`, then `(rightPath g t₀ t₁).im = π Z`.

  The argument principle itself — a zero-counting theorem for `∮ f′/f` around a
  rectangle — is **not** in Mathlib, so it enters `routeB_reduction` as the explicit
  hypothesis `hAP`.  The interval-integrability side conditions are exactly
  integrability of `g` along the two horizontal edges, which for `g = ξ′/ξ` holds
  whenever no zero of `ξ` has ordinate `t₀` or `t₁`.
  See `README.md` for the inventory of what is missing.
-/
import Mathlib

open MeasureTheory intervalIntegral
open scoped ComplexConjugate

namespace Rh45RouteBAnalytic

noncomputable section

/-! ## The Riemann ξ function -/

/-- The Riemann `ξ` function `ξ(s) = ½ s (s − 1) π^{−s/2} Γ(s/2) ζ(s)`, expressed
through Mathlib's completed zeta function `completedRiemannZeta` (`Λ(s) = π^{−s/2} Γ(s/2) ζ(s)`
up to a correction at `s = 0`). -/
def xi (s : ℂ) : ℂ := (1 / 2) * s * (s - 1) * completedRiemannZeta s

/-- **Functional equation for `ξ`.**  `ξ(1 − s) = ξ(s)`; it is the polynomial identity
`½(1 − s)(−s) = ½ s(s − 1)` applied to Mathlib's `completedRiemannZeta_one_sub`. -/
theorem xi_one_sub (s : ℂ) : xi (1 - s) = xi s := by
  simp only [xi, completedRiemannZeta_one_sub]
  ring

/-! ## Reflection of the logarithmic derivative -/

/-- **Reflection.**  If `f(1 − s) = f(s)` then `f′/f` changes sign under `s ↦ 1 − s`.
The proof is the chain rule for `deriv (fun s ↦ f (1 − s))` (Mathlib's
`deriv_comp_const_sub`); no differentiability hypothesis is needed, since `deriv`
vanishes when the function is not differentiable. -/
theorem logDeriv_one_sub (f : ℂ → ℂ) (hf : ∀ s, f (1 - s) = f s) (s : ℂ) :
    logDeriv f (1 - s) = -logDeriv f s := by
  have hfun : (fun t : ℂ => f (1 - t)) = f := funext hf
  have hderiv : deriv f s = -deriv f (1 - s) := by
    have h := deriv_comp_const_sub f (1 : ℂ) s
    rwa [hfun] at h
  rw [logDeriv_apply, logDeriv_apply, hf s, hderiv]
  ring

/-- **Reality.**  If `f` takes conjugate values at conjugate points
(`f(conj s) = conj (f s)`, i.e. `f` is real on the real axis) then so does `f′/f`.
This is the conjugation identity of Mathlib's `deriv_conj_conj`. -/
theorem logDeriv_conj (f : ℂ → ℂ) (hf : ∀ s, f (conj s) = conj (f s)) (s : ℂ) :
    logDeriv f (conj s) = conj (logDeriv f s) := by
  have hfun : (conj ∘ f ∘ conj) = f := funext fun t => by
    simp only [Function.comp_apply, hf t, Complex.conj_conj]
  have hderiv : deriv f (conj s) = conj (deriv f s) := by
    have h := congrFun (deriv_conj_conj (f := f)) (conj s)
    simp only [Function.comp_apply, Complex.conj_conj] at h
    rwa [hfun] at h
  rw [logDeriv_apply, logDeriv_apply, hf s, hderiv]
  rw [map_div₀]

/-- **Combined reflection.**  If `f(1 − s) = f(s)` and `f(conj s) = conj (f s)`, then
`f′/f` satisfies `g(1 − conj s) = −conj (g s)`, the single pointwise hypothesis used
by the contour reduction below. -/
theorem logDeriv_one_sub_conj (f : ℂ → ℂ)
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s)) (s : ℂ) :
    logDeriv f (1 - conj s) = -conj (logDeriv f s) := by
  rw [logDeriv_one_sub f h1 (conj s), logDeriv_conj f h2 s]

/-- The concrete symmetry hypothesis of `routeB_reduction` for `g = ξ′/ξ`.  It reduces to
the functional equation `xi_one_sub` (proved) and the reality of `ξ` on the real axis,
`ξ(conj s) = conj (ξ s)`.  The latter is not available in Mathlib for
`completedRiemannZeta` (there is no `completedRiemannZeta_conj`), so it is a hypothesis. -/
theorem xi_logDeriv_symmetry (hre : ∀ s : ℂ, xi (conj s) = conj (xi s)) (s : ℂ) :
    logDeriv xi (1 - conj s) = -conj (logDeriv xi s) :=
  logDeriv_one_sub_conj xi xi_one_sub hre s

/-! ## The symmetric contour reduction -/

/-- Integral of `g` over the boundary of the rectangle `[0,1] × [t₀,t₁]`, written in the
same normal form as Mathlib's `Complex.integral_boundary_rect_of_differentiableOn_real`
with `z = t₀ * I`, `w = 1 + t₁ * I`: bottom edge, top edge, right edge, left edge. -/
def rectBoundary (g : ℂ → ℂ) (t₀ t₁ : ℝ) : ℂ :=
  (∫ x in (0 : ℝ)..1, g (x + t₀ * Complex.I))
    - (∫ x in (0 : ℝ)..1, g (x + t₁ * Complex.I))
    + Complex.I * (∫ y in t₀..t₁, g (1 + y * Complex.I))
    - Complex.I * (∫ y in t₀..t₁, g (y * Complex.I))

/-- Integral of `g` over the three-segment path
`(½,t₀) → (1,t₀) → (1,t₁) → (½,t₁)`: the right half of the rectangle boundary, in the
orientation used for `I₃`. -/
def rightPath (g : ℂ → ℂ) (t₀ t₁ : ℝ) : ℂ :=
  (∫ x in (1 / 2 : ℝ)..1, g (x + t₀ * Complex.I))
    + Complex.I * (∫ y in t₀..t₁, g (1 + y * Complex.I))
    - (∫ x in (1 / 2 : ℝ)..1, g (x + t₁ * Complex.I))

/-- **Reflection of a horizontal half-edge.**  Under `g(1 − conj s) = −conj (g s)`, the
integral of `g` over the left half `[0,½]` of the horizontal line `Im s = t` is minus the
conjugate of the integral over the right half `[½,1]`. -/
theorem horizontal_reflect (g : ℂ → ℂ) (t : ℝ)
    (hg : ∀ s : ℂ, g (1 - conj s) = -conj (g s)) :
    (∫ x in (0 : ℝ)..(1 / 2), g (x + t * Complex.I))
      = -conj (∫ x in (1 / 2 : ℝ)..1, g (x + t * Complex.I)) := by
  have hstep : (∫ x in (0 : ℝ)..(1 / 2), g (x + t * Complex.I))
      = ∫ x in (0 : ℝ)..(1 / 2), -conj (g ((1 - x) + t * Complex.I)) := by
    apply intervalIntegral.integral_congr
    intro x _
    have h := hg (((1 - x : ℝ) : ℂ) + (t : ℂ) * Complex.I)
    have harg : (1 : ℂ) - conj (((1 - x : ℝ) : ℂ) + (t : ℂ) * Complex.I)
        = (x : ℂ) + (t : ℂ) * Complex.I := by
      rw [map_add, map_mul]
      simp [Complex.conj_I]
      ring
    rw [harg] at h
    simpa using h
  have hcomp : (∫ x in (0 : ℝ)..(1 / 2), g ((1 - x) + t * Complex.I))
      = ∫ x in (1 / 2 : ℝ)..1, g (x + t * Complex.I) := by
    have hc := intervalIntegral.integral_comp_sub_left
      (fun x : ℝ => g (x + (t : ℂ) * Complex.I)) (a := (0 : ℝ)) (b := (1 / 2 : ℝ)) (1 : ℝ)
    rw [show (1 : ℝ) - 1 / 2 = 1 / 2 by norm_num, show (1 : ℝ) - 0 = 1 by norm_num] at hc
    simpa using hc
  rw [hstep, intervalIntegral.integral_neg, intervalIntegral.intervalIntegral_conj, hcomp]

/-- **Full horizontal line.**  Under `g(1 − conj s) = −conj (g s)`,
`∫₀¹ g(x+it) dx = (half-line) − conj (half-line)`, i.e. `2i · Im` of the half-line
integral. -/
theorem horizontal_eq_sub_conj (g : ℂ → ℂ) (t : ℝ)
    (hg : ∀ s : ℂ, g (1 - conj s) = -conj (g s))
    (hint : IntervalIntegrable (fun x : ℝ => g (x + t * Complex.I)) volume 0 (1 / 2))
    (hint' : IntervalIntegrable (fun x : ℝ => g (x + t * Complex.I)) volume (1 / 2) 1) :
    (∫ x in (0 : ℝ)..1, g (x + t * Complex.I))
      = (∫ x in (1 / 2 : ℝ)..1, g (x + t * Complex.I))
        - conj (∫ x in (1 / 2 : ℝ)..1, g (x + t * Complex.I)) := by
  rw [← intervalIntegral.integral_add_adjacent_intervals hint hint', horizontal_reflect g t hg]
  ring

/-- **Reflection of the two vertical edges.**  The left edge `Re s = 0` integral is minus
the conjugate of the right edge `Re s = 1` integral, under the same pointwise symmetry. -/
theorem vertical_reflect (g : ℂ → ℂ) (t₀ t₁ : ℝ)
    (hg : ∀ s : ℂ, g (1 - conj s) = -conj (g s)) :
    (∫ y in t₀..t₁, g (y * Complex.I))
      = -conj (∫ y in t₀..t₁, g (1 + y * Complex.I)) := by
  rw [← intervalIntegral.intervalIntegral_conj, ← intervalIntegral.integral_neg]
  apply intervalIntegral.integral_congr
  intro y _
  have h := hg (1 + ((y : ℝ) : ℂ) * Complex.I)
  have harg : (1 : ℂ) - conj (1 + ((y : ℝ) : ℂ) * Complex.I)
      = ((y : ℝ) : ℂ) * Complex.I := by
    rw [map_add, map_mul]
    simp [Complex.conj_I]
  rw [harg] at h
  exact h

/-- **The symmetric contour reduction.**  If `g(1 − conj s) = −conj (g s)` then the
integral of `g` over the full boundary of `[0,1] × [t₀,t₁]` is twice the imaginary part of
the three-segment integral `rightPath`: as a complex identity,
`rectBoundary g t₀ t₁ = rightPath g t₀ t₁ − conj (rightPath g t₀ t₁)`.

Geometrically: the reflection `s ↦ 1 − conj s` in the line `Re s = ½` preserves the
rectangle, reverses orientation, and sends the right half of the boundary to the left half;
the pointwise symmetry turns the corresponding integral into the conjugate. -/
theorem rectBoundary_eq_rightPath_sub_conj (g : ℂ → ℂ) (t₀ t₁ : ℝ)
    (hg : ∀ s : ℂ, g (1 - conj s) = -conj (g s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => g (x + t₀ * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => g (x + t₁ * Complex.I)) volume 0 1) :
    rectBoundary g t₀ t₁ = rightPath g t₀ t₁ - conj (rightPath g t₀ t₁) := by
  have hsub : ∀ {t : ℝ}, IntervalIntegrable (fun x : ℝ => g (x + t * Complex.I)) volume 0 1 →
      IntervalIntegrable (fun x : ℝ => g (x + t * Complex.I)) volume 0 (1 / 2) ∧
        IntervalIntegrable (fun x : ℝ => g (x + t * Complex.I)) volume (1 / 2) 1 := by
    intro t hint
    constructor
    · rw [intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num : (0 : ℝ) ≤ 1 / 2)]
      exact hint.1.mono_set (by
        intro x hx
        exact ⟨hx.1, hx.2.trans (by norm_num : (1 / 2 : ℝ) ≤ 1)⟩)
    · rw [intervalIntegrable_iff_integrableOn_Ioc_of_le (by norm_num : (1 / 2 : ℝ) ≤ 1)]
      exact hint.1.mono_set (by
        intro x hx
        exact ⟨lt_of_le_of_lt (by norm_num : (0 : ℝ) ≤ 1 / 2) hx.1, hx.2⟩)
  obtain ⟨h₀a, h₀b⟩ := hsub hint₀
  obtain ⟨h₁a, h₁b⟩ := hsub hint₁
  have h0 := horizontal_eq_sub_conj g t₀ hg h₀a h₀b
  have h1 := horizontal_eq_sub_conj g t₁ hg h₁a h₁b
  have hV := vertical_reflect g t₀ t₁ hg
  simp only [rectBoundary, rightPath]
  rw [h0, h1, hV]
  simp only [map_sub, map_add, map_mul, Complex.conj_I]
  ring

/-- Convenience form of `rectBoundary_eq_rightPath_sub_conj` with continuity of `g` as the
only side condition (which supplies the two interval-integrability hypotheses). -/
theorem rectBoundary_eq_rightPath_sub_conj_of_continuous (g : ℂ → ℂ) (t₀ t₁ : ℝ)
    (hcont : Continuous g) (hg : ∀ s, g (1 - conj s) = -conj (g s)) :
    rectBoundary g t₀ t₁ = rightPath g t₀ t₁ - conj (rightPath g t₀ t₁) :=
  rectBoundary_eq_rightPath_sub_conj g t₀ t₁ hg
    ((hcont.comp (by fun_prop)).intervalIntegrable 0 1)
    ((hcont.comp (by fun_prop)).intervalIntegrable 0 1)

/-- **Route B, analytic reduction.**  If the argument principle gives that the boundary
integral of `g` over `[0,1] × [t₀,t₁]` is `2πi Z` (with `Z` the multiplicity-weighted
number of zeros enclosed), and `g` satisfies the symmetry `g(1 − conj s) = −conj (g s)`,
then the three-segment integral satisfies `Im(I₃) = π Z`, i.e. `Z = Im(I₃)/π`.

The argument principle hypothesis `hAP` is the missing Mathlib ingredient; everything else
is unconditional here. -/
theorem routeB_reduction (g : ℂ → ℂ) (t₀ t₁ : ℝ)
    (hg : ∀ s : ℂ, g (1 - conj s) = -conj (g s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => g (x + t₀ * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => g (x + t₁ * Complex.I)) volume 0 1)
    (Z : ℝ) (hAP : rectBoundary g t₀ t₁ = 2 * (Real.pi : ℂ) * Complex.I * (Z : ℂ)) :
    (rightPath g t₀ t₁).im = Real.pi * Z := by
  have h := rectBoundary_eq_rightPath_sub_conj g t₀ t₁ hg hint₀ hint₁
  rw [h] at hAP
  have hI : ((2 * (rightPath g t₀ t₁).im : ℝ) : ℂ) * Complex.I
      = (((2 : ℝ) * Real.pi * Z : ℝ) : ℂ) * Complex.I := by
    calc ((2 * (rightPath g t₀ t₁).im : ℝ) : ℂ) * Complex.I
        = rightPath g t₀ t₁ - conj (rightPath g t₀ t₁) :=
          (Complex.sub_conj (rightPath g t₀ t₁)).symm
      _ = 2 * (Real.pi : ℂ) * Complex.I * (Z : ℂ) := hAP
      _ = (((2 : ℝ) * Real.pi * Z : ℝ) : ℂ) * Complex.I := by push_cast; ring
  have h2 : ((2 * (rightPath g t₀ t₁).im : ℝ) : ℂ)
      = (((2 : ℝ) * Real.pi * Z : ℝ) : ℂ) :=
    mul_right_cancel₀ Complex.I_ne_zero hI
  have h3 : 2 * (rightPath g t₀ t₁).im = (2 : ℝ) * Real.pi * Z := by exact_mod_cast h2
  linarith

/-- **Route B, analytic reduction, packaged form.**  The same conclusion as
`routeB_reduction` with the symmetry hypothesis discharged from the two structural
properties of `f`: `f(1 − s) = f(s)` and `f(conj s) = conj (f s)`, i.e. `f` is a
meromorphic function whose logarithmic derivative satisfies
`f′/f (1 − conj s) = −conj (f′/f s)`. -/
theorem routeB_reduction_of_functional_equation (f : ℂ → ℂ) (t₀ t₁ : ℝ)
    (h1 : ∀ s, f (1 - s) = f s) (h2 : ∀ s, f (conj s) = conj (f s))
    (hint₀ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t₀ * Complex.I)) volume 0 1)
    (hint₁ : IntervalIntegrable (fun x : ℝ => logDeriv f (x + t₁ * Complex.I)) volume 0 1)
    (Z : ℝ)
    (hAP : rectBoundary (logDeriv f) t₀ t₁ = 2 * (Real.pi : ℂ) * Complex.I * (Z : ℂ)) :
    (rightPath (logDeriv f) t₀ t₁).im = Real.pi * Z :=
  routeB_reduction (logDeriv f) t₀ t₁ (logDeriv_one_sub_conj f h1 h2) hint₀ hint₁ Z hAP

end

end Rh45RouteBAnalytic
