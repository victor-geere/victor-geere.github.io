import P4

/-!
# A norm bound for the archimedean tent superposition

For `|y| ≤ T` the archimedean factor is
`A(y) = (1/2) log π − (1/2) ψ(1 + i y/2)`.
The digamma-contour-shift estimate (`digamma_one_add_half_bound`) gives
`‖ψ(1 + i y/2) − log(1 + i y/2)‖ ≤ 19` for `y ≠ 0`, and

`‖log(1 + i y/2)‖ ≤ log(T + 2) + 2`

because `1 ≤ ‖1 + i y/2‖ ≤ (T + 2)/2` and `|arg| ≤ π/2 ≤ 2`.  Hence
`‖A(y)‖ ≤ log(T + 2) + 22`.

The exponential factor obeys `‖exp(-u y)‖ = exp(-u y) ≤ exp |y|` for
`|u| ≤ 1`, and `∫ y in -T..T, exp |y| = 2 (exp T - 1)`.  The outer integral
over `[-1, 1]` has length `2`, so the total is at most
`4 (log(T + 2) + 22) exp T ≤ 100 (log(T + 2) + 22) exp T`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Complex
open MeasureTheory
open scoped Interval

namespace FiniteWindowZeros

theorem norm_tentArch_le {T : ℝ} (hT : 0 ≤ T) :
    ‖tentArch T‖ ≤ 100 * (Real.log (T + 2) + 22) * Real.exp T := by
  have hlogT_nonneg : 0 ≤ Real.log (T + 2) :=
    Real.log_nonneg (by linarith)
  have hC_nonneg : 0 ≤ Real.log (T + 2) + 22 := by linarith

  -- `∫ y in -T..T, exp |y| = 2 * (exp T - 1)`.
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

  -- A logarithmic bound at `1 + i y / 2`.
  have hlog_bound : ∀ y : ℝ, |y| ≤ T →
      ‖Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ ≤ Real.log (T + 2) + 2 := by
    intro y hy
    set w : ℂ := 1 + (y : ℂ) * (Complex.I / 2) with hw_def
    have hw_re : w.re = 1 := by simp [hw_def]
    have hw_im : w.im = y / 2 := by
      simp [hw_def, div_eq_mul_inv]
    have hw_ne : w ≠ 0 := by
      intro h
      have hre := hw_re
      rw [h] at hre
      norm_num at hre
    have hnorm_lower : 1 ≤ ‖w‖ := by
      have h := Complex.re_le_norm w
      linarith
    have hnorm_upper : ‖w‖ ≤ (T + 2) / 2 := by
      have h := Complex.norm_le_abs_re_add_abs_im w
      rw [hw_re, hw_im] at h
      have hy2 : |y / 2| ≤ T / 2 := by
        have : |y / 2| = |y| / 2 := by rw [abs_div]; norm_num
        rw [this]; linarith
      linarith
    have hlog_norm_le : Real.log ‖w‖ ≤ Real.log (T + 2) := by
      apply Real.log_le_log (norm_pos_iff.mpr hw_ne)
      calc
        ‖w‖ ≤ (T + 2) / 2 := hnorm_upper
        _ ≤ T + 2 := by linarith
    have harg : |w.arg| ≤ Real.pi / 2 := by
      rw [Complex.abs_arg_le_pi_div_two_iff]
      linarith [hw_re]
    calc
      ‖Complex.log w‖ ≤ |(Complex.log w).re| + |(Complex.log w).im| :=
        Complex.norm_le_abs_re_add_abs_im _
      _ = |Real.log ‖w‖| + |w.arg| := by
        rw [Complex.log_re, Complex.log_im]
      _ ≤ Real.log (T + 2) + Real.pi / 2 :=
        add_le_add
          (by
            rw [abs_of_nonneg (Real.log_nonneg hnorm_lower)]
            exact hlog_norm_le)
          harg
      _ ≤ Real.log (T + 2) + 2 := by
        have hpi : Real.pi / 2 ≤ 2 := by linarith [Real.pi_lt_four]
        linarith

  -- Bound on the digamma factor.
  have hpsi_bound : ∀ y : ℝ, |y| ≤ T → y ≠ 0 →
      ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖
        ≤ Real.log (T + 2) + 21 := by
    intro y hy hy0
    have h := digamma_one_add_half_bound hy0
    have hlog := hlog_bound y hy
    calc
      ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖
          = ‖(Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))
                - Complex.log (1 + (y : ℂ) * (Complex.I / 2)))
              + Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ := by
            rw [sub_add_cancel]
      _ ≤ ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))
              - Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖
            + ‖Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ := norm_add_le _ _
      _ ≤ 19 + (Real.log (T + 2) + 2) := add_le_add h hlog
      _ = Real.log (T + 2) + 21 := by ring

  -- Bound on `A(y)` for `|y| ≤ T`, `y ≠ 0`.
  have hA_bound : ∀ y : ℝ, |y| ≤ T → y ≠ 0 →
      ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)
          - (1 / 2 : ℂ) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2)‖
        ≤ Real.log (T + 2) + 22 := by
    intro y hy hy0
    have hw : (2 + (y : ℂ) * Complex.I) / 2 = 1 + (y : ℂ) * (Complex.I / 2) := by
      ring
    have hpsi := hpsi_bound y hy hy0
    have hlogpi_le : Real.log Real.pi ≤ 4 := by
      have h1 : Real.log Real.pi ≤ Real.pi - 1 := Real.log_le_sub_one_of_pos Real.pi_pos
      have h2 : Real.pi < 4 := Real.pi_lt_four
      linarith
    have hlogpi_norm : ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)‖ ≤ 2 := by
      have hlogpi_eq : Complex.log (Real.pi : ℂ) = (Real.log Real.pi : ℂ) := by
        rw [Complex.ofReal_log Real.pi_pos.le]
      rw [hlogpi_eq, norm_mul, Complex.norm_real, Real.norm_eq_abs]
      norm_num
      have habs : |Real.log Real.pi| = Real.log Real.pi :=
        abs_of_nonneg (Real.log_nonneg (by linarith [Real.pi_gt_three] : (1 : ℝ) ≤ Real.pi))
      rw [habs]
      nlinarith
    calc
      ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)
          - (1 / 2 : ℂ) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2)‖
          = ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)
              - (1 / 2 : ℂ) * Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖ := by
            rw [hw]
      _ ≤ ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)‖
            + ‖(1 / 2 : ℂ) * Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖ :=
          norm_sub_le _ _
      _ = ‖(1 / 2 : ℂ) * Complex.log (Real.pi : ℂ)‖
            + (1 / 2) * ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖ := by
          rw [norm_mul]
          norm_num
      _ ≤ 2 + (1 / 2) * (Real.log (T + 2) + 21) :=
          add_le_add hlogpi_norm (by nlinarith [hpsi])
      _ ≤ Real.log (T + 2) + 22 := by nlinarith [hlogT_nonneg]

  -- The inner `y`-integral, uniformly for `|u| ≤ 1`.
  have hinner : ∀ u : ℝ, |u| ≤ 1 →
      ‖∫ y : ℝ in (-T)..T,
          ((1 / 2) * Complex.log (Real.pi : ℂ)
            - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2))
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
        ≤ 2 * (Real.log (T + 2) + 22) * Real.exp T := by
    intro u hu
    have hcontg : Continuous fun y : ℝ =>
        (Real.log (T + 2) + 22) * Real.exp |y| :=
      continuous_const.mul (Real.continuous_exp.comp continuous_abs)
    have hmain := intervalIntegral.norm_integral_le_of_norm_le
      (μ := volume) (a := -T) (b := T)
      (f := fun y : ℝ =>
        ((1 / 2) * Complex.log (Real.pi : ℂ)
            - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2))
          * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ)))
      (g := fun y : ℝ => (Real.log (T + 2) + 22) * Real.exp |y|)
      (by linarith) ?_ (hcontg.intervalIntegrable _ _)
    · refine hmain.trans ?_
      rw [intervalIntegral.integral_const_mul, integral_exp_abs]
      nlinarith [Real.exp_pos T]
    · filter_upwards [Measure.ae_ne (volume) (0 : ℝ)] with y hyne hyI
      have hyabs : |y| ≤ T := abs_le.mpr ⟨by linarith [hyI.1], hyI.2⟩
      have hA := hA_bound y hyabs hyne
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
        ‖((1 / 2) * Complex.log (Real.pi : ℂ)
              - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2))
            * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
            = ‖(1 / 2) * Complex.log (Real.pi : ℂ)
                - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2)‖
              * Real.exp (-(u * y)) := by
              rw [norm_mul, hexp_norm]
        _ ≤ (Real.log (T + 2) + 22) * Real.exp |y| :=
              mul_le_mul hA hexp_le (Real.exp_pos _).le hC_nonneg

  -- The outer `u`-integral.
  unfold tentArch
  refine (intervalIntegral.norm_integral_le_of_norm_le_const
    (C := 2 * (Real.log (T + 2) + 22) * Real.exp T) ?_).trans ?_
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
              ((1 / 2) * Complex.log (Real.pi : ℂ)
                - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2))
              * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖
          = ‖tentC u‖
              * ‖Complex.exp (Complex.I * ((3 / 2 : ℝ) : ℂ) * (u : ℂ))‖
              * ‖∫ y : ℝ in (-T)..T,
                  ((1 / 2) * Complex.log (Real.pi : ℂ)
                    - (1 / 2) * Complex.digamma ((2 + (y : ℂ) * Complex.I) / 2))
                  * Complex.exp (-(((u : ℝ) * (y : ℝ)) : ℝ))‖ := by
            rw [norm_mul, norm_mul]
      _ ≤ 1 * 1 * (2 * (Real.log (T + 2) + 22) * Real.exp T) := by
            exact mul_le_mul
              (mul_le_mul htent hphase.le (norm_nonneg _) (by norm_num))
              (hinner u hu_abs) (by positivity) (by positivity)
      _ = 2 * (Real.log (T + 2) + 22) * Real.exp T := by ring
  · have hlen : |(1 : ℝ) - (-1)| = 2 := by
      rw [show (1 : ℝ) - (-1) = 2 by norm_num,
        abs_of_nonneg (by norm_num : (0 : ℝ) ≤ 2)]
    rw [hlen]
    have hExp : 0 ≤ Real.exp T := (Real.exp_pos T).le
    nlinarith [hC_nonneg, hExp]

end FiniteWindowZeros
