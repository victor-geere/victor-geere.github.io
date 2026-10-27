import Mathlib

/-!
# Sinc, sine kernel, moments — formal core

This file isolates the finite, elementary part of the archived
sinc/zeta material: the normalised sinc function, the sine kernel, the
Montgomery pair-correlation factor, and the phase factor that appears in
Kösters' shifted-moment kernel.

Nothing here asserts the Riemann hypothesis, Montgomery's pair
correlation conjecture, Kösters' asymptotic theorem, or any random-matrix
statistics of zeta zeros. Those remain source claims / open items in the
programme dossier.
-/

noncomputable section

namespace SincKernel

/-- The normalised sinc function
`sincN x = sin (π x) / (π x)` for `x ≠ 0`, with `sincN 0 = 1`.

This is Mathlib's unnormalised `Real.sinc` composed with `x ↦ π x`. -/
noncomputable def sincN (x : ℝ) : ℝ := Real.sinc (Real.pi * x)

/-- The sine kernel `K(x, y) = sincN (x - y)`. -/
noncomputable def sineKernel (x y : ℝ) : ℝ := sincN (x - y)

/-- Montgomery's pair-correlation factor `F(α) = 1 - sincN(α)²`. -/
noncomputable def montgomeryF (α : ℝ) : ℝ := 1 - sincN α ^ 2

/-- The phase-times-kernel factor occurring on the right-hand side of
Kösters' second-moment asymptotic,
`e^{-iπ(μ-ν)} sincN(μ-ν)`. -/
noncomputable def kostersKernel (μ ν : ℝ) : ℂ :=
  Complex.exp (-(Complex.I * (Real.pi : ℂ) * ((μ : ℂ) - (ν : ℂ)))) *
    (sincN (μ - ν) : ℂ)

/-- The sinc function is normalised to one at the origin. -/
@[simp]
theorem sincN_zero : sincN 0 = 1 := by
  simp [sincN]

/-- The value at the first half-integer, `sincN(1/2) = 2/π`. -/
theorem sincN_half : sincN (1 / 2) = 2 / Real.pi := by
  unfold sincN
  have h : Real.pi * (1 / 2 : ℝ) ≠ 0 := by positivity
  rw [Real.sinc_of_ne_zero h]
  have harg : Real.pi * (1 / 2 : ℝ) = Real.pi / 2 := by ring
  rw [harg, Real.sin_pi_div_two]
  field_simp

/-- At every non-zero integer the sinc function vanishes. -/
theorem sincN_int_eq_zero (n : ℤ) (hn : n ≠ 0) : sincN (n : ℝ) = 0 := by
  unfold sincN
  have hpi : Real.pi * (n : ℝ) ≠ 0 := by
    exact mul_ne_zero Real.pi_ne_zero (by exact_mod_cast hn)
  rw [Real.sinc_of_ne_zero hpi]
  have hsin : Real.sin (Real.pi * (n : ℝ)) = 0 := by
    rw [show Real.pi * (n : ℝ) = (n : ℝ) * Real.pi by ring, Real.sin_int_mul_pi]
  rw [hsin]
  simp

/-- The sinc function is strictly positive on the open unit interval. -/
theorem sincN_pos_of_mem_Ioo {x : ℝ} (h0 : 0 < x) (h1 : x < 1) : 0 < sincN x := by
  unfold sincN
  have hx : Real.pi * x ≠ 0 := by positivity
  rw [Real.sinc_of_ne_zero hx]
  apply div_pos
  · apply Real.sin_pos_of_pos_of_lt_pi
    · positivity
    · nlinarith [Real.pi_pos]
  · positivity

/-- The sine kernel is symmetric in its two arguments. -/
theorem sineKernel_comm (x y : ℝ) : sineKernel x y = sineKernel y x := by
  unfold sineKernel sincN
  rw [show x - y = -(y - x) by ring]
  rw [show Real.pi * -(y - x) = -(Real.pi * (y - x)) by ring, Real.sinc_neg]

/-- Montgomery's factor `1 - sincN(α)²` is non-negative, because the
normalised sinc function is bounded by one in absolute value. -/
theorem montgomeryF_nonneg (α : ℝ) : 0 ≤ montgomeryF α := by
  unfold montgomeryF
  have h : |sincN α| ≤ 1 := by
    unfold sincN
    exact Real.abs_sinc_le_one _
  have h2 : sincN α ^ 2 ≤ 1 := (sq_le_one_iff_abs_le_one _).mpr h
  linarith

/-- The phase factor in Kösters' shifted-moment kernel has unit modulus:
it does not change the size of the sinc factor. -/
theorem kostersKernel_norm (μ ν : ℝ) :
    ‖kostersKernel μ ν‖ = |sincN (μ - ν)| := by
  unfold kostersKernel
  rw [norm_mul, Complex.norm_exp]
  have hre : (-(Complex.I * (Real.pi : ℂ) * ((μ : ℂ) - (ν : ℂ)))).re = 0 := by
    simp
  rw [hre, Real.exp_zero, one_mul, Complex.norm_real]
  simp

end SincKernel
