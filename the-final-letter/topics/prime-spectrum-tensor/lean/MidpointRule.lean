import Mathlib

/-!
# The midpoint rule with an explicit remainder

Mathlib has no quadrature rule, so R2's panel estimate needs one.  This file
proves the *midpoint rule* with a second-derivative remainder:

```
|(∫_a^b f) − (b−a)·f(m)| ≤ B·(b−a)³/4,      m = (a+b)/2,
```

whenever `|f″| ≤ B` on `[a,b]`.  (The classical constant is `1/24`; `1/4` is
deliberately loose and still negligible for the density panels, where
`B ≈ 10⁻³` and `h ≈ 0.05` give `≈ 3·10⁻⁸` per panel.)
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

theorem midpoint_rule_bound {f : ℝ → ℝ} {a b B : ℝ} (hab : a ≤ b)
    (hf : ∀ x ∈ Set.Icc a b, HasDerivAt f (deriv f x) x)
    (hf' : ∀ x ∈ Set.Icc a b, HasDerivAt (deriv f) (deriv (deriv f) x) x)
    (hB : ∀ x ∈ Set.Icc a b, |deriv (deriv f) x| ≤ B)
    (hcont : Continuous f) :
    |(∫ x in a..b, f x) - (b - a) * f ((a + b) / 2)| ≤ B * (b - a) ^ 3 / 4 := by
  set m : ℝ := (a + b) / 2 with hm
  set C : ℝ := B * (b - a) / 2 with hC
  have hconv : Convex ℝ (Set.Icc a b) := convex_Icc a b
  have hm_mem : m ∈ Set.Icc a b := by
    constructor <;> simp only [hm] <;> linarith
  have hB0 : 0 ≤ B := le_trans (abs_nonneg _) (hB a ⟨le_rfl, hab⟩)
  have hC0 : 0 ≤ C := by rw [hC]; positivity
  -- (1) `|f′(x) − f′(m)| ≤ B |x − m|`
  have hlip : ∀ x ∈ Set.Icc a b, |deriv f x - deriv f m| ≤ B * |x - m| := by
    intro x hx
    have h := Convex.norm_image_sub_le_of_norm_deriv_le (f := deriv f) (s := Set.Icc a b)
      (C := B) (fun y hy => (hf' y hy).differentiableAt)
      (fun y hy => by rw [Real.norm_eq_abs]; exact hB y hy) hconv hm_mem hx
    rwa [Real.norm_eq_abs, Real.norm_eq_abs] at h
  -- (2) `|φ(x)| ≤ C |x − m|`, where `φ = (f − f(m)) − f′(m)(·−m)`
  have hφd : ∀ y ∈ Set.Icc a b,
      HasDerivAt (fun x : ℝ => (f x - f m) - deriv f m * (x - m)) (deriv f y - deriv f m) y := by
    intro y hy
    have h1 : HasDerivAt (fun x : ℝ => f x - f m) (deriv f y) y :=
      (hf y hy).sub_const (f m)
    have h4 : HasDerivAt (fun x : ℝ => x - m) 1 y := (hasDerivAt_id y).sub_const m
    have h5 : HasDerivAt (fun x : ℝ => deriv f m * (x - m)) (deriv f m) y := by
      simpa using h4.const_mul (deriv f m)
    exact h1.sub h5
  have hφcont : Continuous (fun x : ℝ => (f x - f m) - deriv f m * (x - m)) := by fun_prop
  have hφbound : ∀ y ∈ Set.Icc a b, ‖deriv f y - deriv f m‖ ≤ C := by
    intro y hy
    rw [Real.norm_eq_abs]
    have h1 := hlip y hy
    have h2 : |y - m| ≤ (b - a) / 2 := by
      rw [abs_le]
      constructor
      · simp only [hm]; linarith [hy.1]
      · simp only [hm]; linarith [hy.2]
    calc |deriv f y - deriv f m| ≤ B * |y - m| := h1
      _ ≤ B * ((b - a) / 2) := mul_le_mul_of_nonneg_left h2 hB0
      _ = C := by rw [hC]; ring
  have hphi : ∀ x ∈ Set.Icc a b,
      |(f x - f m) - deriv f m * (x - m)| ≤ C * |x - m| := by
    intro x hx
    have hφd' : ∀ y ∈ Set.Icc a b,
        deriv (fun x : ℝ => (f x - f m) - deriv f m * (x - m)) y = deriv f y - deriv f m := by
      intro y hy; exact (hφd y hy).deriv
    have h := Convex.norm_image_sub_le_of_norm_deriv_le
      (f := fun x : ℝ => (f x - f m) - deriv f m * (x - m)) (s := Set.Icc a b) (C := C)
      (fun y hy => (hφd y hy).differentiableAt)
      (fun y hy => by rw [hφd' y hy]; exact hφbound y hy) hconv hm_mem hx
    rw [Real.norm_eq_abs, Real.norm_eq_abs] at h
    have hzero : (f m - f m) - deriv f m * (m - m) = 0 := by ring
    rw [hzero, sub_zero] at h
    exact h
  -- (3) `∫_a^b (x − m) = 0`
  have hint_lin : (∫ x in a..b, (x - m)) = 0 := by
    have hderiv : ∀ x : ℝ, HasDerivAt (fun x : ℝ => (x - m) ^ 2 / 2) (x - m) x := by
      intro x
      have h1 : HasDerivAt (fun x : ℝ => x - m) 1 x := (hasDerivAt_id x).sub_const m
      have h2 := (h1.pow 2).div_const 2
      convert h2 using 1
      ring
    rw [intervalIntegral.integral_eq_sub_of_hasDerivAt (fun x _ => hderiv x)
      ((continuous_id.sub continuous_const).intervalIntegrable a b)]
    simp only [hm]
    ring
  -- (4) the integral identity
  have hintφ : (∫ x in a..b, (f x - f m) - deriv f m * (x - m))
      = (∫ x in a..b, f x) - (b - a) * f m := by
    rw [intervalIntegral.integral_sub (μ := MeasureTheory.volume)
      (f := fun x : ℝ => f x - f m) (g := fun x : ℝ => deriv f m * (x - m))
      ((hcont.sub continuous_const).intervalIntegrable a b)
      ((continuous_const.mul (continuous_id.sub continuous_const)).intervalIntegrable a b)]
    rw [intervalIntegral.integral_sub (μ := MeasureTheory.volume)
      (f := f) (g := fun _ : ℝ => f m)
      (hcont.intervalIntegrable a b) (continuous_const.intervalIntegrable a b)]
    rw [intervalIntegral.integral_const, intervalIntegral.integral_const_mul, hint_lin]
    simp only [smul_eq_mul]
    ring
  have hmain : (∫ x in a..b, f x) - (b - a) * f m
      = ∫ x in a..b, (f x - f m) - deriv f m * (x - m) := by
    rw [hintφ]
  rw [hmain]
  calc |∫ x in a..b, (f x - f m) - deriv f m * (x - m)|
      ≤ ∫ x in a..b, |(f x - f m) - deriv f m * (x - m)| :=
        intervalIntegral.abs_integral_le_integral_abs hab
    _ ≤ ∫ x in a..b, C * |x - m| := by
        refine intervalIntegral.integral_mono_on hab (hφcont.abs.intervalIntegrable a b)
          ((continuous_const.mul (continuous_abs.comp
            (continuous_id.sub continuous_const))).intervalIntegrable a b) ?_
        intro x hx
        exact hphi x hx
    _ = C * ∫ x in a..b, |x - m| := by
        rw [intervalIntegral.integral_const_mul]
    _ ≤ C * ((b - a) * ((b - a) / 2)) := by
        apply mul_le_mul_of_nonneg_left _ hC0
        calc ∫ x in a..b, |x - m| ≤ ∫ x in a..b, ((b - a) / 2) := by
              refine intervalIntegral.integral_mono_on hab
                ((continuous_abs.comp (continuous_id.sub continuous_const)).intervalIntegrable a b)
                (continuous_const.intervalIntegrable a b) ?_
              intro x hx
              rw [abs_le]
              constructor
              · simp only [hm]; linarith [hx.1]
              · simp only [hm]; linarith [hx.2]
          _ = (b - a) * ((b - a) / 2) := by
              rw [intervalIntegral.integral_const, smul_eq_mul]
    _ = B * (b - a) ^ 3 / 4 := by rw [hC]; ring

end PrimeSpectrumTensor
