import Mathlib
import DensityEnclosure
import DigammaEnclosure

/-!
# A global bound on `|Ω|`

R2 truncates the density integral at `t = 60`; the tail needs a bound on
`|Ω(t)|` valid for all large `t`.  `IntersectionForm.digamma_expansion` is
general in its argument, so applying it at `w = 1/4 + (t/2)i` (with
`Re w = 1/4` and the correspondingly crude remainder `1/(81·(1/4)⁵)`) gives

```
|Ω(t)| ≤ log(t+2) + 19.
```
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The `ψ`-argument on the critical line: `1/4 + (t/2)i`. -/
noncomputable def omegaPoint (t : ℝ) : ℂ := (1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I

theorem omegaPoint_re (t : ℝ) : (omegaPoint t).re = 1 / 4 := by simp [omegaPoint]

theorem omegaPoint_im (t : ℝ) : (omegaPoint t).im = t / 2 := by simp [omegaPoint]

theorem omegaPoint_norm_le {t : ℝ} (ht : 0 ≤ t) : ‖omegaPoint t‖ ≤ 1 / 4 + t / 2 := by
  have h1 : ‖((t : ℝ) / 2 : ℂ) * Complex.I‖ = t / 2 := by
    rw [norm_mul, Complex.norm_I, mul_one]
    rw [show ((t : ℝ) / 2 : ℂ) = ((t / 2 : ℝ) : ℂ) by push_cast; ring]
    rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (by linarith)]
  calc ‖omegaPoint t‖ = ‖(1 / 4 : ℂ) + ((t : ℝ) / 2 : ℂ) * Complex.I‖ := rfl
    _ ≤ ‖(1 / 4 : ℂ)‖ + ‖((t : ℝ) / 2 : ℂ) * Complex.I‖ := norm_add_le _ _
    _ = 1 / 4 + t / 2 := by rw [h1]; norm_num

theorem quarter_le_norm_omegaPoint (t : ℝ) : 1 / 4 ≤ ‖omegaPoint t‖ := by
  have h := Complex.abs_re_le_norm (omegaPoint t)
  rw [omegaPoint_re] at h
  rwa [abs_of_pos (by norm_num : (0 : ℝ) < 1 / 4)] at h

theorem Omega_eq_re_digamma (t : ℝ) :
    IntersectionForm.Omega t = (Complex.digamma (omegaPoint t)).re - Real.log Real.pi := by
  unfold IntersectionForm.Omega omegaPoint
  ring

/-- Triangle inequality for the six signed terms of the expansion. -/
theorem abs_six_le (a b c d e f : ℝ) :
    |a - b - c - d + e - f| ≤ |a| + |b| + |c| + |d| + |e| + |f| := by
  have h : a - b - c - d + e - f = a + (-b) + (-c) + (-d) + e + (-f) := by ring
  rw [h]
  have e1 := abs_add_le (a + -b + -c + -d + e) (-f)
  rw [abs_neg] at e1
  have e2 := abs_add_le (a + -b + -c + -d) e
  have e3 := abs_add_le (a + -b + -c) (-d)
  rw [abs_neg] at e3
  have e4 := abs_add_le (a + -b) (-c)
  rw [abs_neg] at e4
  have e5 := abs_add_le a (-b)
  rw [abs_neg] at e5
  linarith

/-- The Euler–Maclaurin remainder of the expansion at `omegaPoint t`. -/
noncomputable def omegaRem (t : ℝ) : ℂ :=
  1 / (Nat.factorial 5 : ℂ) * ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
    iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + omegaPoint t)⁻¹) x

theorem omegaRem_norm_le {t : ℝ} (ht : 0 < t) : ‖omegaRem t‖ ≤ 13 := by
  have hre : 0 < (omegaPoint t).re := by rw [omegaPoint_re]; norm_num
  have him : (omegaPoint t).im ≠ 0 := by
    rw [omegaPoint_im]; intro h; linarith
  have h := IntersectionForm.norm_remainder_five_le (w := omegaPoint t) hre him
  rw [omegaPoint_re] at h
  have h2 : 1 / (81 * (1 / 4 : ℝ) ^ 5) ≤ 13 := by norm_num
  exact le_trans h h2

/-- The Euler–Maclaurin expansion of `Ω`, with the remainder bundled. -/
theorem Omega_expansion {t : ℝ} (ht : 0 < t) :
    IntersectionForm.Omega t = (Complex.log (omegaPoint t)).re - Real.log Real.pi
      - (1 / (2 * omegaPoint t)).re - (1 / (12 * (omegaPoint t) ^ 2)).re
      + (1 / (120 * (omegaPoint t) ^ 4)).re - (omegaRem t).re := by
  have hre : 0 < (omegaPoint t).re := by rw [omegaPoint_re]; norm_num
  have him : (omegaPoint t).im ≠ 0 := by rw [omegaPoint_im]; intro h; linarith
  have h := IntersectionForm.digamma_expansion (w := omegaPoint t) hre him
  rw [Omega_eq_re_digamma, h]
  unfold omegaRem
  simp only [Complex.sub_re, Complex.add_re]
  ring

theorem log_four_le_two : Real.log 4 ≤ 2 := by
  have h2 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.log_pow]
    norm_num
  have h3 : Real.log 2 ≤ 1 := by
    have := Real.log_le_sub_one_of_pos (by norm_num : (0 : ℝ) < 2)
    linarith
  rw [h2]; linarith

theorem abs_log_omegaPoint_le {t : ℝ} (ht : 0 < t) :
    |(Complex.log (omegaPoint t)).re| ≤ Real.log (t + 2) + 2 := by
  rw [Complex.log_re]
  have hwlo : (1 : ℝ) / 4 ≤ ‖omegaPoint t‖ := quarter_le_norm_omegaPoint t
  have hwhi : ‖omegaPoint t‖ ≤ 1 / 4 + t / 2 := omegaPoint_norm_le ht.le
  have hwpos : (0 : ℝ) < ‖omegaPoint t‖ := by linarith
  have hlog2 : (0 : ℝ) ≤ Real.log (t + 2) := Real.log_nonneg (by linarith)
  rcases lt_or_ge ‖omegaPoint t‖ 1 with h | h
  · have h2 : Real.log ‖omegaPoint t‖ < 0 := Real.log_neg hwpos h
    rw [abs_of_neg h2]
    have h5 : Real.log ‖omegaPoint t‖ ≥ Real.log (1 / 4 : ℝ) :=
      Real.log_le_log (by norm_num) hwlo
    have h6 : Real.log (1 / 4 : ℝ) = -Real.log 4 := by
      rw [show (1 / 4 : ℝ) = 4⁻¹ by norm_num, Real.log_inv]
    have h7 : Real.log 4 ≤ 2 := log_four_le_two
    have h8 : -Real.log ‖omegaPoint t‖ ≤ Real.log 4 := by linarith
    linarith
  · rw [abs_of_nonneg (Real.log_nonneg h)]
    have h3 : Real.log ‖omegaPoint t‖ ≤ Real.log (t + 2) := by
      apply Real.log_le_log (by linarith); linarith
    linarith

/-- **The global bound on `Ω`.** For `t > 0`, `|Ω(t)| ≤ log(t+2) + 19`. -/
theorem abs_Omega_le {t : ℝ} (ht : 0 < t) :
    |IntersectionForm.Omega t| ≤ Real.log (t + 2) + 24 := by
  rw [Omega_expansion ht]
  have hwlo : (1 : ℝ) / 4 ≤ ‖omegaPoint t‖ := quarter_le_norm_omegaPoint t
  have hwpos : (0 : ℝ) < ‖omegaPoint t‖ := by linarith
  have b1 : |(1 / (2 * omegaPoint t)).re| ≤ 2 := by
    refine le_trans (Complex.abs_re_le_norm _) ?_
    rw [norm_div, norm_one, norm_mul, Complex.norm_ofNat]
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  have b2 : |(1 / (12 * (omegaPoint t) ^ 2)).re| ≤ 4 / 3 := by
    refine le_trans (Complex.abs_re_le_norm _) ?_
    rw [norm_div, norm_one, norm_mul, Complex.norm_ofNat, norm_pow]
    rw [div_le_iff₀ (by positivity)]
    nlinarith [sq_nonneg ‖omegaPoint t‖]
  have b3 : |(1 / (120 * (omegaPoint t) ^ 4)).re| ≤ 3 := by
    refine le_trans (Complex.abs_re_le_norm _) ?_
    rw [norm_div, norm_one, norm_mul, Complex.norm_ofNat, norm_pow]
    rw [div_le_iff₀ (by positivity)]
    have h4 : (1 / 4 : ℝ) ^ 4 ≤ ‖omegaPoint t‖ ^ 4 := pow_le_pow_left₀ (by norm_num) hwlo 4
    nlinarith [h4]
  have b4 : |(omegaRem t).re| ≤ 13 :=
    le_trans (Complex.abs_re_le_norm _) (omegaRem_norm_le ht)
  have bpi : |Real.log Real.pi| ≤ 2 := by
    rw [abs_of_nonneg (Real.log_nonneg (by linarith [Real.pi_gt_three]))]
    have h4 : Real.log Real.pi ≤ Real.log 4 := Real.log_le_log Real.pi_pos (by linarith [Real.pi_lt_four])
    have h5 : Real.log 4 ≤ 2 := log_four_le_two
    linarith
  have blog := abs_log_omegaPoint_le ht
  calc |(Complex.log (omegaPoint t)).re - Real.log Real.pi - (1 / (2 * omegaPoint t)).re -
        (1 / (12 * (omegaPoint t) ^ 2)).re + (1 / (120 * (omegaPoint t) ^ 4)).re - (omegaRem t).re|
      ≤ |(Complex.log (omegaPoint t)).re| + |Real.log Real.pi| + |(1 / (2 * omegaPoint t)).re| +
        |(1 / (12 * (omegaPoint t) ^ 2)).re| + |(1 / (120 * (omegaPoint t) ^ 4)).re| +
        |(omegaRem t).re| := abs_six_le _ _ _ _ _ _
    _ ≤ (Real.log (t + 2) + 2) + 2 + 2 + 4 / 3 + 3 + 13 := by linarith
    _ ≤ Real.log (t + 2) + 24 := by
        have h2 : (0 : ℝ) ≤ Real.log (t + 2) := Real.log_nonneg (by linarith)
        linarith

end PrimeSpectrumTensor
