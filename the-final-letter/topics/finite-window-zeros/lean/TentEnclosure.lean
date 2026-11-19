import TentArchBound
import TentBound
import SimpsonPanel

noncomputable section
open Complex MeasureTheory
open scoped Interval

namespace FiniteWindowZeros

/-- Coarse rational box for `tentArch 1`: `|Re|, |Im| ≤ 7200`. -/
theorem tentArch_one_mem_box :
    |(tentArch 1).re| ≤ 7200 ∧ |(tentArch 1).im| ≤ 7200 := by
  have hlog : Real.log (3 : ℝ) ≤ 2 := by
    have h := Real.log_lt_sub_one_of_pos (by norm_num : (0 : ℝ) < 3) (by norm_num : (3 : ℝ) ≠ 1)
    linarith
  have hexp : Real.exp 1 ≤ 3 := Real.exp_one_lt_three.le
  have hbound : ‖tentArch 1‖ ≤ 7200 := by
    have h := norm_tentArch_le (T := 1) (by norm_num)
    norm_num at h
    have h1 : Real.log (3 : ℝ) + 22 ≤ 24 := by linarith
    have h3 : 100 * (Real.log (3 : ℝ) + 22) ≤ 100 * 24 := by gcongr
    have h4 : 100 * (Real.log (3 : ℝ) + 22) * Real.exp 1 ≤ 100 * 24 * 3 :=
      mul_le_mul h3 hexp (Real.exp_pos 1).le (by norm_num)
    linarith
  constructor
  · exact (abs_re_le_norm (tentArch 1)).trans hbound
  · exact (abs_im_le_norm (tentArch 1)).trans hbound

/-- Coarse rational box for `tentPrime 1`: `|Re|, |Im| ≤ 288`. -/
theorem tentPrime_one_mem_box :
    |(tentPrime 1).re| ≤ 288 ∧ |(tentPrime 1).im| ≤ 288 := by
  have hexp : Real.exp 1 ≤ 3 := Real.exp_one_lt_three.le
  have hbound : ‖tentPrime 1‖ ≤ 288 := by
    have h := norm_tentPrime_le (T := 1) (by norm_num)
    have h4 : 96 * Real.exp 1 ≤ 96 * 3 := by gcongr
    linarith
  constructor
  · exact (abs_re_le_norm (tentPrime 1)).trans hbound
  · exact (abs_im_le_norm (tentPrime 1)).trans hbound

/-- Box for the tent sum `-(tentArch 1) - tentPrime 1`: radius `7488`. -/
theorem tent_sum_mem_box :
    |(-tentArch 1 - tentPrime 1).re| ≤ 7488 ∧
      |(-tentArch 1 - tentPrime 1).im| ≤ 7488 := by
  obtain ⟨ha_re, ha_im⟩ := tentArch_one_mem_box
  obtain ⟨hp_re, hp_im⟩ := tentPrime_one_mem_box
  constructor
  · have h : (-tentArch 1 - tentPrime 1).re = -(tentArch 1).re - (tentPrime 1).re := by
      simp
    rw [h]
    calc |-(tentArch 1).re - (tentPrime 1).re|
        ≤ |(tentArch 1).re| + |(tentPrime 1).re| := by
          simpa using abs_sub (-(tentArch 1).re) ((tentPrime 1).re)
      _ ≤ 7200 + 288 := add_le_add ha_re hp_re
      _ = 7488 := by norm_num
  · have h : (-tentArch 1 - tentPrime 1).im = -(tentArch 1).im - (tentPrime 1).im := by
      simp
    rw [h]
    calc |-(tentArch 1).im - (tentPrime 1).im|
        ≤ |(tentArch 1).im| + |(tentPrime 1).im| := by
          simpa using abs_sub (-(tentArch 1).im) ((tentPrime 1).im)
      _ ≤ 7200 + 288 := add_le_add ha_im hp_im
      _ = 7488 := by norm_num

/-- **Simpson-panel error interface.**  Re-exports the kernel-checked generic
estimate from `intersection-form-zeta` for use by the tent quadrature. -/
theorem tent_simpson_panel_error {H : ℝ} (hH : 0 ≤ H) (G : ℝ → ℝ) (c B : ℝ)
    (hB : 0 ≤ B) (hG : ContDiffOn ℝ 4 G (Set.Icc c (c + 2 * H)))
    (hderiv : ∀ x ∈ Set.Icc c (c + 2 * H), |iteratedDeriv 4 G x| ≤ B) :
    |Rh45.simpsonPanel G c H - ∫ x in c..(c + 2 * H), G x|
      ≤ (2 * H) ^ 5 / 2880 * B :=
  Rh45.simpsonPanelEstimate H hH G c B hB hG hderiv

/-- **Tent-sum norm corollary.**  The term `-tentArch 1 - tentPrime 1` appearing
in T562 is bounded by `14976`, by substituting the coarse boxes T600/T601. -/
theorem norm_tent_sum_le :
    ‖-tentArch 1 - tentPrime 1‖ ≤ 14976 := by
  obtain ⟨hre, him⟩ := tent_sum_mem_box
  have h := Complex.norm_le_abs_re_add_abs_im (-tentArch 1 - tentPrime 1)
  linarith

end FiniteWindowZeros
