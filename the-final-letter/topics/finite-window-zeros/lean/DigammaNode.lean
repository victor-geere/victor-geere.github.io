import TentArchBound
import RealAxis

/-!
# A uniform digamma bound on the tent node

For `y ≠ 0` with `|y| ≤ 1`,

`‖ψ(1 + i y/2)‖ ≤ 24`.

The digamma-contour-shift estimate (`digamma_one_add_half_bound`) controls
`ψ − log`, and the logarithmic factor is bounded exactly as in
`norm_tentArch_le` with `T = 1`: `1 ≤ ‖1 + i y/2‖ ≤ 3/2` and
`|arg| ≤ π/2 ≤ 2`, so `‖log(1 + i y/2)‖ ≤ log 3 + 2 ≤ 4`.  Hence
`19 + 4 = 23 ≤ 24`.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

open Complex

namespace FiniteWindowZeros

/-- The logarithmic factor at the tent node: `‖log(1 + i y/2)‖ ≤ 4` for `|y| ≤ 1`. -/
theorem norm_log_one_add_half_le {y : ℝ} (hy : |y| ≤ 1) :
    ‖Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ ≤ 4 := by
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
  have hnorm_upper : ‖w‖ ≤ 3 / 2 := by
    have h := Complex.norm_le_abs_re_add_abs_im w
    rw [hw_re, hw_im] at h
    have hy2 : |y / 2| ≤ 1 / 2 := by
      have : |y / 2| = |y| / 2 := by rw [abs_div]; norm_num
      rw [this]; linarith
    linarith
  have hlog_norm_le : Real.log ‖w‖ ≤ Real.log 3 := by
    apply Real.log_le_log (norm_pos_iff.mpr hw_ne)
    linarith
  have harg : |w.arg| ≤ Real.pi / 2 := by
    rw [Complex.abs_arg_le_pi_div_two_iff]
    linarith [hw_re]
  calc
    ‖Complex.log w‖ ≤ |(Complex.log w).re| + |(Complex.log w).im| :=
      Complex.norm_le_abs_re_add_abs_im _
    _ = |Real.log ‖w‖| + |w.arg| := by
      rw [Complex.log_re, Complex.log_im]
    _ ≤ Real.log 3 + Real.pi / 2 :=
      add_le_add
        (by
          rw [abs_of_nonneg (Real.log_nonneg hnorm_lower)]
          exact hlog_norm_le)
        harg
    _ ≤ 4 := by
      have hpi : Real.pi / 2 ≤ 2 := by linarith [Real.pi_lt_four]
      have h3 : Real.log 3 ≤ 2 := by
        have h := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 3)
        linarith
      linarith

/-- **Uniform digamma bound at the tent node.**  For `y ≠ 0`, `|y| ≤ 1`,
`‖ψ(1 + i y/2)‖ ≤ 24`. -/
theorem norm_digamma_one_add_half_le {y : ℝ} (hy0 : y ≠ 0) (hy : |y| ≤ 1) :
    ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖ ≤ 24 := by
  have h := digamma_one_add_half_bound hy0
  have hlog := norm_log_one_add_half_le hy
  calc
    ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))‖
        = ‖(Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))
              - Complex.log (1 + (y : ℂ) * (Complex.I / 2)))
            + Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ := by
          rw [sub_add_cancel]
    _ ≤ ‖Complex.digamma (1 + (y : ℂ) * (Complex.I / 2))
            - Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖
          + ‖Complex.log (1 + (y : ℂ) * (Complex.I / 2))‖ := norm_add_le _ _
    _ ≤ 19 + 4 := add_le_add h hlog
    _ ≤ 24 := by norm_num

end FiniteWindowZeros
