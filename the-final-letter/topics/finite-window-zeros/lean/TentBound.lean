import P4
import LSeriesBound

/-!
# A norm bound for the tent prime superposition

On `re s = 2` the von Mangoldt L-series is bounded by `24`
(`norm_LSeries_vonMangoldt_two_le`), the tent factor by `1` in modulus, and the
oscillating exponential `exp (i * 3u/2)` by `1`.  For `u ∈ [-1, 1]` and
`y ∈ [-T, T]` the remaining real exponential obeys

`exp (-(u*y)) ≤ exp |y|`,

and `∫ y in -T..T, exp |y| = 2 * (exp T - 1)`.  Hence the inner integral is at
most `24 * 2 * exp T`, and the outer integral over `[-1, 1]` gains a factor `2`,
giving the bound `96 * exp T`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Complex
open MeasureTheory
open scoped Interval

namespace FiniteWindowZeros

open ArithmeticFunction

theorem norm_tentPrime_le {T : ℝ} (hT : 0 ≤ T) :
    ‖tentPrime T‖ ≤ 96 * Real.exp T := by
  have integral_exp_abs :
      ∫ y : ℝ in (-T)..T, Real.exp |y| = 2 * (Real.exp T - 1) := by
    have hf : Continuous fun y : ℝ => Real.exp |y| :=
      Real.continuous_exp.comp continuous_abs
    have hright : ∫ y : ℝ in (0 : ℝ)..T, Real.exp |y| = Real.exp T - 1 := by
      calc
        ∫ y : ℝ in (0 : ℝ)..T, Real.exp |y| = ∫ y : ℝ in (0 : ℝ)..T, Real.exp y := by
          apply intervalIntegral.integral_congr
          intro y hy
          have hy' : y ∈ Set.Icc (0 : ℝ) T := by
            rwa [Set.uIcc_of_le hT] at hy
          change Real.exp |y| = Real.exp y
          rw [abs_of_nonneg hy'.1]
        _ = Real.exp T - 1 := by
          rw [integral_exp, Real.exp_zero]
    have hleft : ∫ y : ℝ in (-T)..0, Real.exp |y| = Real.exp T - 1 := by
      rw [show (0 : ℝ) = -0 by norm_num,
        ← intervalIntegral.integral_comp_neg
          (f := fun y : ℝ => Real.exp |y|) (a := (0 : ℝ)) (b := T)]
      simpa using hright
    calc
      (∫ y : ℝ in (-T)..T, Real.exp |y|)
          = (∫ y : ℝ in (-T)..0, Real.exp |y|)
              + (∫ y : ℝ in (0 : ℝ)..T, Real.exp |y|) := by
            exact (intervalIntegral.integral_add_adjacent_intervals
              (μ := volume)
              (hf.intervalIntegrable (-T) 0) (hf.intervalIntegrable 0 T)).symm
      _ = 2 * (Real.exp T - 1) := by rw [hleft, hright]; ring

  -- The inner `y`-integral, uniformly for `|u| ≤ 1`.
  have hinner : ∀ u : ℝ, |u| ≤ 1 →
      ‖∫ y : ℝ in (-T)..T,
          LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
              (2 + (y : ℂ) * Complex.I)
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
        ≤ 48 * Real.exp T := by
    intro u hu
    have hcontg : Continuous fun y : ℝ => 24 * Real.exp |y| :=
      continuous_const.mul (Real.continuous_exp.comp continuous_abs)
    have hmain := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (a := -T) (b := T)
      (f := fun y : ℝ =>
        LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
            (2 + (y : ℂ) * Complex.I)
          * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)))
      (g := fun y : ℝ => 24 * Real.exp |y|)
      (by linarith) ?_ (hcontg.intervalIntegrable _ _)
    · refine hmain.trans ?_
      rw [intervalIntegral.integral_const_mul, integral_exp_abs]
      nlinarith [Real.exp_pos T]
    · filter_upwards with y hy
      have hyI : y ∈ Set.Ioc (-T) T := hy
      have hy_abs : |y| ≤ T := abs_le.mpr ⟨by linarith [hyI.1], hyI.2⟩
      have hL : ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
          (2 + (y : ℂ) * Complex.I)‖ ≤ 24 := norm_LSeries_vonMangoldt_two_le
      have hexp_norm :
          ‖Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖ = Real.exp (-(u * y)) := by
        rw [Complex.norm_exp]
        simp
      have hexp_le : Real.exp (-(u * y)) ≤ Real.exp |y| := by
        refine Real.exp_le_exp.mpr ?_
        have h1 : -(u * y) ≤ |u * y| := neg_le_abs _
        have h2 : |u * y| = |u| * |y| := abs_mul u y
        have h3 : |u| * |y| ≤ 1 * |y| :=
          mul_le_mul_of_nonneg_right hu (abs_nonneg y)
        rw [h2] at h1
        linarith
      calc
        ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
              (2 + (y : ℂ) * Complex.I)
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
            = ‖LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
                (2 + (y : ℂ) * Complex.I)‖ * Real.exp (-(u * y)) := by
              rw [norm_mul, hexp_norm]
        _ ≤ 24 * Real.exp |y| :=
              mul_le_mul hL hexp_le (Real.exp_pos _).le (by norm_num)
  -- The outer `u`-integral.
  unfold tentPrime
  refine (intervalIntegral.norm_integral_le_of_norm_le_const
    (C := 48 * Real.exp T) ?_).trans ?_
  · intro u hu
    have huI : u ∈ Set.Ioc (-1 : ℝ) 1 := by
      rwa [Set.uIoc_of_le (by norm_num : (-1 : ℝ) ≤ 1)] at hu
    have hu_abs : |u| ≤ 1 := abs_le.mpr ⟨by linarith [huI.1], huI.2⟩
    have htent_nonneg : 0 ≤ tentS u := by
      unfold tentS
      exact le_max_left _ _
    have htent_le : tentS u ≤ 1 := by
      unfold tentS
      apply max_le
      · norm_num
      · have h : 0 ≤ |2 * u| := abs_nonneg _
        linarith
    have htent : ‖tentC u‖ ≤ 1 := by
      rw [tentC, Complex.norm_real, Real.norm_of_nonneg htent_nonneg]
      exact htent_le
    have hphase : ‖Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))‖ = 1 := by
      rw [Complex.norm_exp]
      simp
    calc
      ‖tentC u * Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))
          * ∫ y : ℝ in (-T)..T,
              LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
                  (2 + (y : ℂ) * Complex.I)
                * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
          = ‖tentC u‖
              * ‖Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))‖
              * ‖∫ y : ℝ in (-T)..T,
                  LSeries (fun n => (ArithmeticFunction.vonMangoldt n : ℂ))
                      (2 + (y : ℂ) * Complex.I)
                    * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖ := by
            rw [norm_mul, norm_mul]
      _ ≤ 1 * 1 * (48 * Real.exp T) := by
            exact mul_le_mul
              (mul_le_mul htent hphase.le (norm_nonneg _) (by norm_num))
              (hinner u hu_abs) (by positivity) (by positivity)
      _ = 48 * Real.exp T := by ring
  · have h : (48 * Real.exp T) * |(1 : ℝ) - (-1)| = 96 * Real.exp T := by
      rw [show (1 : ℝ) - (-1) = 2 by norm_num,
        abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)]
      ring
    rw [h]

end FiniteWindowZeros
