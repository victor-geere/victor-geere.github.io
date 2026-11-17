import DigammaEnclosure
import Mathlib

/-!
# Digamma asymptotics and the archimedean contour shift

This topic formalises the analysis behind the archimedean evaluation of the
Gaussian explicit formula.

**Harvested from `intersection-form-zeta/lean/DigammaEnclosure.lean`:**

* `digamma_expansion` — the Euler–Maclaurin expansion
  `ψ(w) = log w − 1/(2w) − 1/(12w²) + 1/(120w⁴) − R(w)`;
* `norm_remainder_five_le` — the remainder bound `‖R(w)‖ ≤ 1/(81 (Re w)^5)`.

**Proved here:** the harvested expansion and remainder bound, re-exported as the
formal core, and the definition of the archimedean factor.

**Named target:** `ArchimedeanShift`, the contour-shift identity taking the
archimedean integral from `Re s = 2` to `Re s = 1/2`.  The digamma bound makes
the horizontal segments vanish against the Gaussian test.
-/

noncomputable section

open Complex Filter MeasureTheory
open scoped Topology BigOperators

namespace DigammaContourShift

/-- The archimedean factor `(1/2) log π − (1/2) ψ(s/2)`. -/
def archFactor (s : ℂ) : ℂ :=
  (1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma (s / 2)

/-- **Harvested: the Euler–Maclaurin expansion of `ψ`.** -/
theorem digamma_expansion_harvested {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    Complex.digamma w = Complex.log w - 1 / (2 * w) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) -
      (1 / (Nat.factorial 5 : ℂ)) *
        ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
          iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x :=
  IntersectionForm.digamma_expansion hw hwi

/-- **Harvested: the remainder bound.** -/
theorem digamma_remainder_le_harvested {w : ℂ} (hw : 0 < w.re) (hwi : w.im ≠ 0) :
    ‖(1 / (Nat.factorial 5 : ℂ)) *
      ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
        iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x‖ ≤
      1 / (81 * w.re ^ 5) :=
  IntersectionForm.norm_remainder_five_le hw hwi

/-- **The archimedean contour shift.**  The vertical integral of
`archFactor(s)·H(s)` at `Re s = 2` equals the one at `Re s = 1/2`, the
horizontal segments vanishing because the Gaussian test decays super-
exponentially while the archimedean factor grows only logarithmically. -/
def ArchimedeanShift (H : ℂ → ℂ) : Prop :=
  (∫ y : ℝ, archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) * H ((2 : ℂ) + (y : ℂ) * Complex.I)) =
    ∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      H (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)



example {w : ℂ} (hre : 1 / 4 ≤ w.re) : ‖1 / (2 * w)‖ ≤ 2 := by
  rw [norm_div, norm_one, norm_mul, Complex.norm_ofNat]
  have hw : (1 / 4 : ℝ) ≤ ‖w‖ := by
    have := Complex.re_le_norm w; linarith
  have hpos : (0 : ℝ) < ‖w‖ := by linarith
  rw [div_le_iff₀ (by positivity)]
  nlinarith

example {w : ℂ} (hre : 1 / 4 ≤ w.re) : ‖1 / (12 * w ^ 2)‖ ≤ 4 / 3 := by
  rw [norm_div, norm_one, norm_mul, norm_pow]
  norm_num
  have hw : (1 / 4 : ℝ) ≤ ‖w‖ := by
    have := Complex.re_le_norm w; linarith
  have hpos : (0 : ℝ) < ‖w‖ := by linarith
  have h2 : (1 / 16 : ℝ) ≤ ‖w‖ ^ 2 := by
    have h := pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hw 2
    norm_num at h
    exact h
  have h16 : (‖w‖ ^ 2)⁻¹ ≤ 16 := by
    have h := one_div_le_one_div_of_le (show (0 : ℝ) < (1 / 16 : ℝ) by norm_num) h2
    simpa [one_div] using h
  nlinarith

example {w : ℂ} (hre : 1 / 4 ≤ w.re) : ‖1 / (120 * w ^ 4)‖ ≤ 32 / 15 := by
  rw [norm_div, norm_one, norm_mul, norm_pow]
  norm_num
  have hw : (1 / 4 : ℝ) ≤ ‖w‖ := by
    have := Complex.re_le_norm w; linarith
  have hpos : (0 : ℝ) < ‖w‖ := by linarith
  have h2 : (1 / 256 : ℝ) ≤ ‖w‖ ^ 4 := by
    have h := pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hw 4
    norm_num at h
    exact h
  have h256 : (‖w‖ ^ 4)⁻¹ ≤ 256 := by
    have h := one_div_le_one_div_of_le (show (0 : ℝ) < (1 / 256 : ℝ) by norm_num) h2
    simpa [one_div] using h
  nlinarith

example {w : ℂ} (hre : 1 / 4 ≤ w.re) : 1 / (81 * w.re ^ 5) ≤ 1024 / 81 := by
  have hpos : (0 : ℝ) < w.re := by linarith
  have h5 : (1 / 4 : ℝ) ^ 5 ≤ w.re ^ 5 := by
    have h := pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hre 5
    exact h
  have hbase : (0 : ℝ) < 81 * (1 / 4 : ℝ) ^ 5 := by norm_num
  have hmono : 1 / (81 * w.re ^ 5) ≤ 1 / (81 * (1 / 4 : ℝ) ^ 5) := by
    apply one_div_le_one_div_of_le hbase
    nlinarith
  have hval : 1 / (81 * (1 / 4 : ℝ) ^ 5) = 1024 / 81 := by norm_num
  linarith

end DigammaContourShift

namespace DigammaContourShift

/-- **Bounded digamma error in the strip.**  For `Re w ≥ 1/4` and `Im w ≠ 0`,
`‖ψ(w) − log w‖ ≤ 19`. -/
theorem digamma_sub_log_le {w : ℂ} (hre : 1 / 4 ≤ w.re) (hwi : w.im ≠ 0) :
    ‖Complex.digamma w - Complex.log w‖ ≤ 19 := by
  have hwpos : 0 < w.re := by linarith
  have hexp := IntersectionForm.digamma_expansion (w := w) hwpos hwi
  have hrem := IntersectionForm.norm_remainder_five_le (w := w) hwpos hwi
  set R : ℂ := (1 / (Nat.factorial 5 : ℂ)) *
    ∫ x in Set.Ioi 0, (PartialTail.periodicBernoulli 5 x : ℂ) *
      iteratedDeriv 5 (fun y : ℝ => ((y : ℂ) + w)⁻¹) x with hR
  rw [hexp]
  have hsub : Complex.log w - 1 / (2 * w) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) - R -
      Complex.log w = -(1 / (2 * w)) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) - R := by
    ring
  rw [hsub]
  have hw : (1 / 4 : ℝ) ≤ ‖w‖ := by
    have := Complex.re_le_norm w; linarith
  have hA : ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) - R‖
      ≤ ‖1 / (2 * w)‖ + ‖1 / (12 * w ^ 2)‖ + ‖1 / (120 * w ^ 4)‖ + ‖R‖ := by
    have h1 : ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4) - R‖
        ≤ ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4)‖ + ‖R‖ :=
      norm_sub_le _ _
    have h2 : ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2) + 1 / (120 * w ^ 4)‖
        ≤ ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2)‖ + ‖1 / (120 * w ^ 4)‖ :=
      norm_add_le _ _
    have h3 : ‖-(1 / (2 * w)) - 1 / (12 * w ^ 2)‖ ≤ ‖1 / (2 * w)‖ + ‖1 / (12 * w ^ 2)‖ := by
      have h := norm_sub_le (-(1 / (2 * w))) (1 / (12 * w ^ 2))
      have e : ‖-(1 / (2 * w))‖ = ‖1 / (2 * w)‖ := norm_neg _
      linarith [h, e]
    linarith [h1, h2, h3]
  have b1 : ‖1 / (2 * w)‖ ≤ 2 := by
    rw [norm_div, norm_one, norm_mul, Complex.norm_ofNat]
    have hpos : (0 : ℝ) < ‖w‖ := by linarith
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  have b2 : ‖1 / (12 * w ^ 2)‖ ≤ 4 / 3 := by
    rw [norm_div, norm_one, norm_mul, norm_pow]
    norm_num
    have h2 : (1 / 16 : ℝ) ≤ ‖w‖ ^ 2 := by
      have h := pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hw 2
      norm_num at h
      exact h
    have hinv : (‖w‖ ^ 2)⁻¹ ≤ 16 := by
      have h := one_div_le_one_div_of_le (show (0 : ℝ) < (1 / 16 : ℝ) by norm_num) h2
      simpa [one_div] using h
    nlinarith
  have b3 : ‖1 / (120 * w ^ 4)‖ ≤ 32 / 15 := by
    rw [norm_div, norm_one, norm_mul, norm_pow]
    norm_num
    have h2 : (1 / 256 : ℝ) ≤ ‖w‖ ^ 4 := by
      have h := pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hw 4
      norm_num at h
      exact h
    have hinv : (‖w‖ ^ 4)⁻¹ ≤ 256 := by
      have h := one_div_le_one_div_of_le (show (0 : ℝ) < (1 / 256 : ℝ) by norm_num) h2
      simpa [one_div] using h
    nlinarith
  have b4 : ‖R‖ ≤ 1024 / 81 := by
    have h5 : (1 / 4 : ℝ) ^ 5 ≤ w.re ^ 5 :=
      pow_le_pow_left₀ (by norm_num : (0:ℝ) ≤ 1/4) hre 5
    have hbase : (0 : ℝ) < 81 * (1 / 4 : ℝ) ^ 5 := by norm_num
    have hmono : 1 / (81 * w.re ^ 5) ≤ 1 / (81 * (1 / 4 : ℝ) ^ 5) := by
      apply one_div_le_one_div_of_le hbase
      nlinarith
    have hval : 1 / (81 * (1 / 4 : ℝ) ^ 5) = 1024 / 81 := by norm_num
    linarith
  linarith [hA, b1, b2, b3, b4]



/-- **`‖log w‖` is at most `log ‖w‖ + π` once `‖w‖ ≥ 1`.** -/
theorem norm_log_le {w : ℂ} (hw : 1 ≤ ‖w‖) :
    ‖Complex.log w‖ ≤ Real.log ‖w‖ + Real.pi := by
  have h := Complex.norm_le_abs_re_add_abs_im (Complex.log w)
  rw [Complex.log_re, Complex.log_im] at h
  have h1 : |Real.log ‖w‖| = Real.log ‖w‖ := abs_of_nonneg (Real.log_nonneg hw)
  have h2 : |Complex.arg w| ≤ Real.pi := Complex.abs_arg_le_pi w
  linarith

/-- **Logarithmic growth of `archFactor` on horizontal segments.** -/
theorem archFactor_norm_le {x T : ℝ} (hx4 : 1 / 4 ≤ x / 2) (hx2 : x ≤ 2) (hT : 2 ≤ T) :
    ‖archFactor (x + (T : ℂ) * Complex.I)‖ ≤
      (1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19)) := by
  have hTpos : (0 : ℝ) < T := by linarith
  set w : ℂ := (x + (T : ℂ) * Complex.I) / 2 with hw
  have hw_eq : w = (x / 2 : ℝ) + ((T / 2 : ℝ) : ℂ) * Complex.I := by
    rw [hw]; push_cast; ring
  have hwre : w.re = x / 2 := by rw [hw_eq]; simp
  have hwim : w.im = T / 2 := by rw [hw_eq]; simp
  have hwnorm : ‖w‖ = Real.sqrt ((x / 2) ^ 2 + (T / 2) ^ 2) := by
    rw [hw_eq, Complex.norm_add_mul_I]
  have hwre' : 1 / 4 ≤ w.re := by rw [hwre]; linarith
  have hwim' : w.im ≠ 0 := by rw [hwim]; positivity
  have hw1 : (1 : ℝ) ≤ ‖w‖ := by
    rw [hwnorm]
    have h2 : (1 : ℝ) ≤ Real.sqrt ((x / 2) ^ 2 + (T / 2) ^ 2) := by
      rw [show (1:ℝ) = Real.sqrt (1^2) by rw [Real.sqrt_sq]; norm_num]
      apply Real.sqrt_le_sqrt
      nlinarith
    linarith
  have hwle : ‖w‖ ≤ (T + 2) / 2 := by
    rw [hwnorm]
    have hsq : (x / 2) ^ 2 + (T / 2) ^ 2 ≤ ((T + 2) / 2) ^ 2 := by
      nlinarith [sq_nonneg (x - 2)]
    calc Real.sqrt ((x / 2) ^ 2 + (T / 2) ^ 2) ≤ Real.sqrt (((T + 2) / 2) ^ 2) :=
          Real.sqrt_le_sqrt hsq
      _ = (T + 2) / 2 := by
          rw [Real.sqrt_sq (by positivity)]
  have hlogw : ‖Complex.log w‖ ≤ Real.log ‖w‖ + Real.pi := norm_log_le hw1
  have hlogle : Real.log ‖w‖ ≤ Real.log ((T + 2) / 2) :=
    Real.log_le_log (by positivity) hwle
  have hpsi : ‖Complex.digamma w‖ ≤ Real.log ((T + 2) / 2) + Real.pi + 19 := by
    have h1 : ‖Complex.digamma w‖ ≤ ‖Complex.log w‖ + ‖Complex.digamma w - Complex.log w‖ := by
      have := norm_add_le (Complex.log w) (Complex.digamma w - Complex.log w)
      have e : Complex.log w + (Complex.digamma w - Complex.log w) = Complex.digamma w := by ring
      rw [e] at this
      exact this
    have h2 : ‖Complex.digamma w - Complex.log w‖ ≤ 19 := digamma_sub_log_le hwre' hwim'
    linarith
  have hlogpi : ‖Complex.log (Real.pi : ℂ)‖ = Real.log Real.pi := by
    have h1 : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) := by
      rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
    rw [h1, Complex.norm_real,
      Real.norm_of_nonneg (Real.log_nonneg (by nlinarith [Real.pi_gt_three]))]
  have harg : archFactor (x + (T : ℂ) * Complex.I) =
      (1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w := by
    unfold archFactor
    rw [hw]
  rw [harg]
  calc ‖(1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w‖
      ≤ ‖(1 / 2) * Complex.log (Real.pi : ℂ)‖ + ‖(1 / 2) * Complex.digamma w‖ := norm_sub_le _ _
    _ = (1 / 2) * Real.log Real.pi + (1 / 2) * ‖Complex.digamma w‖ := by
        rw [norm_mul, norm_mul, hlogpi]
        norm_num
    _ ≤ (1 / 2) * Real.log Real.pi + (1 / 2) * (Real.log ((T + 2) / 2) + Real.pi + 19) := by
        gcongr
    _ = (1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19)) := by ring



/-- The Gaussian test of the explicit-formula programme. -/
def gaussianTest (c σ : ℝ) (s : ℂ) : ℂ :=
  ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
    Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (s - 1 / 2) ^ 2) *
      Complex.exp (-((c : ℝ) : ℂ) * (s - 1 / 2))

/-- **Horizontal Gaussian decay.** -/
theorem gaussianTest_norm_le {c σ x T : ℝ} (hσ : 0 < σ)
    (hx1 : 1 / 4 ≤ x) (hx2 : x ≤ 2) :
    ‖gaussianTest c σ (x + (T : ℂ) * Complex.I)‖ ≤
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
        Real.exp (-(σ ^ 2 * T ^ 2)) := by
  have hz : (x + (T : ℂ) * Complex.I) - 1 / 2 =
      ((x - 1 / 2 : ℝ) : ℂ) + (T : ℂ) * Complex.I := by push_cast; ring
  unfold gaussianTest
  rw [hz, norm_mul, norm_mul, Complex.norm_exp, Complex.norm_exp, Complex.norm_real,
    Real.norm_of_nonneg (by positivity)]
  have hzsq : ((((x - 1 / 2 : ℝ)) : ℂ) + (T : ℂ) * Complex.I) ^ 2 =
      ((((x - 1 / 2) ^ 2 - T ^ 2 : ℝ)) : ℂ) +
        (((2 * (x - 1 / 2) * T : ℝ)) : ℂ) * Complex.I := by
    push_cast
    ring_nf
    rw [show (Complex.I : ℂ) ^ 2 = -1 from by simp [Complex.I_mul_I]]
    ring
  have hzsq' : (((σ ^ 2 : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (T : ℂ) * Complex.I) ^ 2).re =
      σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2) := by
    rw [hzsq]
    simp only [Complex.mul_re, Complex.add_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.mul_im, Complex.I_re, Complex.I_im, Complex.neg_re, Complex.neg_im,
      mul_zero, sub_zero, mul_one]
    ring
  rw [hzsq']
  have hre2 : (-((c : ℝ) : ℂ) * ((((x - 1 / 2 : ℝ)) : ℂ) + (T : ℂ) * Complex.I)).re =
      -(c * (x - 1 / 2)) := by
    simp only [Complex.mul_re, Complex.add_re, Complex.ofReal_re, Complex.ofReal_im,
      Complex.mul_im, Complex.I_re, Complex.I_im, Complex.neg_re, Complex.neg_im,
      mul_zero, sub_zero, mul_one]
    ring
  rw [hre2]
  have h1 : (x - 1 / 2) ^ 2 ≤ 9 / 4 := by
    have hA : x - 1 / 2 ≤ 3 / 2 := by linarith
    have hB : -(3 / 2 : ℝ) ≤ x - 1 / 2 := by linarith
    nlinarith
  have h2 : -(c * (x - 1 / 2)) ≤ |c| * (3 / 2) := by
    have h3 : |x - 1 / 2| ≤ 3 / 2 := abs_le.mpr ⟨by linarith, by linarith⟩
    have h4 : -(c * (x - 1 / 2)) ≤ |c * (x - 1 / 2)| := neg_le_abs _
    have h5 : |c * (x - 1 / 2)| = |c| * |x - 1 / 2| := abs_mul _ _
    have h6 : |c| * |x - 1 / 2| ≤ |c| * (3 / 2) := by
      exact mul_le_mul_of_nonneg_left h3 (abs_nonneg c)
    linarith
  have hbase : 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) *
      Real.exp (-(c * (x - 1 / 2))) ≤
      2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
        Real.exp (-(σ ^ 2 * T ^ 2)) := by
    have hsq : σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2) ≤ σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2 := by
      nlinarith [sq_nonneg σ]
    have hexp1 : Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) ≤
        Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) := Real.exp_le_exp.mpr hsq
    have hexp2 : Real.exp (-(c * (x - 1 / 2))) ≤ Real.exp (|c| * (3 / 2)) :=
      Real.exp_le_exp.mpr h2
    have hpos : (0 : ℝ) ≤ 2 * Real.pi * σ ^ 2 := by positivity
    have hE : (0 : ℝ) ≤ Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) := (Real.exp_pos _).le
    have hE2 : (0 : ℝ) ≤ Real.exp (-(c * (x - 1 / 2))) := (Real.exp_pos _).le
    have hmul1 : 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) ≤
        2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) := by
      exact mul_le_mul_of_nonneg_left hexp1 hpos
    have hmul2 : 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) *
        Real.exp (-(c * (x - 1 / 2))) ≤
        2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) *
          Real.exp (|c| * (3 / 2)) := by
      exact mul_le_mul hmul1 hexp2 hE2 (by positivity)
    calc 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * ((x - 1 / 2) ^ 2 - T ^ 2)) *
          Real.exp (-(c * (x - 1 / 2)))
        ≤ 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) *
            Real.exp (|c| * (3 / 2)) := hmul2
      _ = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
            Real.exp (-(σ ^ 2 * T ^ 2)) := by
          have h1 : Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) * Real.exp (|c| * (3 / 2)) =
              Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) * Real.exp (-(σ ^ 2 * T ^ 2)) := by
            rw [show σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2 =
              σ ^ 2 * (9 / 4) + (-(σ ^ 2 * T ^ 2)) by ring, Real.exp_add, Real.exp_add]
            ring
          calc 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) *
                Real.exp (|c| * (3 / 2))
              = 2 * Real.pi * σ ^ 2 *
                  (Real.exp (σ ^ 2 * (9 / 4) - σ ^ 2 * T ^ 2) * Real.exp (|c| * (3 / 2))) := by ring
            _ = 2 * Real.pi * σ ^ 2 *
                  (Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) * Real.exp (-(σ ^ 2 * T ^ 2))) := by
                rw [h1]
            _ = 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) *
                  Real.exp (-(σ ^ 2 * T ^ 2)) := by ring
  exact hbase



/-- **Horizontal-segment bound.** -/
theorem horizontal_segment_le {c σ T : ℝ} (hσ : 0 < σ) (hT : 2 ≤ T) :
    ‖∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (T : ℂ) * Complex.I) * gaussianTest c σ (x + (T : ℂ) * Complex.I)‖ ≤
      (2 - 1 / 2) *
        (((1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19))) *
          (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) *
            Real.exp (-(σ ^ 2 * T ^ 2)) := by
  let K : ℝ := ((1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19)) *
    (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) * Real.exp (-(σ ^ 2 * T ^ 2))
  have hK : (0 : ℝ) ≤ K := by
    unfold K
    have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
    have h2 : (0:ℝ) ≤ Real.log ((T + 2) / 2) := Real.log_nonneg (by linarith)
    positivity
  have h := intervalIntegral.norm_integral_le_of_norm_le_const (a := (1 / 2 : ℝ)) (b := 2)
    (C := K) (f := fun x : ℝ => archFactor (x + (T : ℂ) * Complex.I) *
      gaussianTest c σ (x + (T : ℂ) * Complex.I)) (fun x hx => by
      have hx1 : (1 / 2 : ℝ) ≤ x := by
        have h := hx
        rw [show Set.uIoc (1 / 2 : ℝ) 2 = Set.Ioc (1 / 2 : ℝ) 2 from
          Set.uIoc_of_le (by norm_num : (1/2:ℝ) ≤ 2)] at h
        exact h.1.le
      have hx2 : x ≤ 2 := by
        have h := hx
        rw [show Set.uIoc (1 / 2 : ℝ) 2 = Set.Ioc (1 / 2 : ℝ) 2 from
          Set.uIoc_of_le (by norm_num : (1/2:ℝ) ≤ 2)] at h
        exact h.2
      have hx4 : 1 / 4 ≤ x / 2 := by linarith
      rw [norm_mul]
      have hA := archFactor_norm_le (x := x) (T := T) hx4 hx2 hT
      have hB := gaussianTest_norm_le (c := c) (σ := σ) (x := x) (T := T) hσ (by linarith) hx2
      calc ‖archFactor (x + (T : ℂ) * Complex.I)‖ * ‖gaussianTest c σ (x + (T : ℂ) * Complex.I)‖
          ≤ ((1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19))) *
              ((2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
                Real.exp (-(σ ^ 2 * T ^ 2))) := by
            refine mul_le_mul hA hB (norm_nonneg _) ?_
            have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
            have h2 : (0:ℝ) ≤ Real.log ((T + 2) / 2) := Real.log_nonneg (by linarith)
            positivity
        _ = ((1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19))) *
              (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
                Real.exp (-(σ ^ 2 * T ^ 2)) := by ring
        _ = K := by unfold K; ring)
  calc ‖∫ x : ℝ in (1 / 2)..2, archFactor (x + (T : ℂ) * Complex.I) *
        gaussianTest c σ (x + (T : ℂ) * Complex.I)‖ ≤ K * |2 - 1 / 2| := h
    _ = (2 - 1 / 2) *
        (((1 / 2) * (Real.log Real.pi + (Real.log ((T + 2) / 2) + Real.pi + 19))) *
          (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) *
            Real.exp (-(σ ^ 2 * T ^ 2)) := by
        rw [abs_of_pos (by norm_num : (0:ℝ) < 2 - 1/2)]
        unfold K
        ring



/-- `Γ` is analytic on the open right half-plane. -/
theorem analyticAt_Gamma_of_re_pos {s : ℂ} (hs : 0 < s.re) : AnalyticAt ℂ Complex.Gamma s := by
  rw [Complex.analyticAt_iff_eventually_differentiableAt]
  filter_upwards [Metric.ball_mem_nhds s (half_pos hs)] with z hz
  apply Complex.differentiableAt_Gamma z
  intro m h
  have hzre : z.re = -(m : ℝ) := by rw [h]; simp
  have hzrepos : 0 < z.re := by
    have hdist : dist z s < s.re / 2 := by simpa [Metric.mem_ball] using hz
    have h1 : |z.re - s.re| ≤ dist z s := by
      calc |z.re - s.re| = ‖(z - s).re‖ := by simp
        _ ≤ ‖z - s‖ := Complex.abs_re_le_norm _
        _ = dist z s := (dist_eq_norm ..).symm
    have h2 : z.re - s.re ≥ -|z.re - s.re| := neg_abs_le _
    linarith
  rw [hzre] at hzrepos
  have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
  linarith

/-- The digamma function is differentiable on the open right half-plane. -/
theorem differentiableAt_digamma_of_re_pos {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ Complex.digamma s := by
  have hGA : AnalyticAt ℂ Complex.Gamma s := analyticAt_Gamma_of_re_pos hs
  have hGne : Complex.Gamma s ≠ 0 := by
    apply Complex.Gamma_ne_zero
    intro m h
    have hre : s.re = -(m : ℝ) := by rw [h]; simp
    have hm : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
    linarith
  have hGdiff : DifferentiableAt ℂ Complex.Gamma s := hGA.differentiableAt
  have hderiv : DifferentiableAt ℂ (deriv Complex.Gamma) s := hGA.deriv.differentiableAt
  rw [Complex.digamma_def]
  have hev : logDeriv Complex.Gamma =ᶠ[nhds s] fun z => deriv Complex.Gamma z / Complex.Gamma z := by
    filter_upwards [hGdiff.continuousAt.eventually_ne hGne] with z hz
    rw [logDeriv_apply]
  exact (hderiv.div hGdiff hGne).congr_of_eventuallyEq hev.symm

/-- `archFactor` is differentiable on the right half-plane. -/
theorem differentiableAt_archFactor {s : ℂ} (hs : 0 < s.re) :
    DifferentiableAt ℂ archFactor s := by
  unfold archFactor
  apply DifferentiableAt.sub (differentiableAt_const _)
  apply DifferentiableAt.const_mul
  have h2 : DifferentiableAt ℂ (fun z : ℂ => z / 2) s := differentiableAt_id.div_const 2
  have hre : (s / 2).re = s.re / 2 := by
    rw [show s / 2 = s * (1 / 2 : ℂ) by ring]
    simp [Complex.mul_re]
    ring
  exact DifferentiableAt.comp s (differentiableAt_digamma_of_re_pos (by rw [hre]; linarith)) h2

/-- The Gaussian test is entire. -/
theorem differentiable_gaussianTest (c σ : ℝ) : Differentiable ℂ (gaussianTest c σ) := by
  unfold gaussianTest
  fun_prop

/-- The product is differentiable on the closed rectangle `[1/2,2] × [-T,T]`. -/
theorem differentiableOn_rect {c σ T : ℝ} (hT : 0 < T) :
    DifferentiableOn ℂ (fun s => archFactor s * gaussianTest c σ s)
      (reProdIm (Set.Icc (1 / 2 : ℝ) 2) (Set.Icc (-T) T)) := by
  intro s hs
  have hsre : 0 < s.re := by
    have h1 : s.re ∈ Set.Icc (1 / 2 : ℝ) 2 := hs.1
    linarith [h1.1]
  exact (DifferentiableAt.mul (differentiableAt_archFactor hsre)
    ((differentiable_gaussianTest c σ) s)).differentiableWithinAt



/-- **The archimedean contour shift (limit form).**  The truncated vertical
integrals at `Re s = 1/2` and `Re s = 2` have the same limit: their difference
tends to zero. -/
def ArchimedeanShiftLim (H : ℂ → ℂ) : Prop :=
  Tendsto (fun T : ℝ =>
    (∫ y : ℝ in (-T)..T, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      H (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) -
    (∫ y : ℝ in (-T)..T, archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) *
      H ((2 : ℂ) + (y : ℂ) * Complex.I))) atTop (nhds 0)

/-- `archFactor·H` is differentiable on any set in the right half-plane. -/
theorem differentiableOn_of_re_pos {c σ : ℝ} {V : Set ℂ}
    (hV : ∀ s ∈ V, 0 < s.re) :
    DifferentiableOn ℂ (fun s => archFactor s * gaussianTest c σ s) V := by
  intro s hs
  exact (DifferentiableAt.mul (differentiableAt_archFactor (hV s hs))
    ((differentiable_gaussianTest c σ) s)).differentiableWithinAt

/-- The rectangle Cauchy identity for `archFactor·H`. -/
theorem rectangle_identity (c σ : ℝ) (hσ : 0 < σ) (T : ℝ) (hT : 2 ≤ T) :
    (∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (-T : ℝ) * Complex.I) * gaussianTest c σ (x + (-T : ℝ) * Complex.I)) -
      (∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (T : ℝ) * Complex.I) * gaussianTest c σ (x + (T : ℝ) * Complex.I)) +
      Complex.I * (∫ y : ℝ in (-T)..T,
        archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) * gaussianTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)) -
      Complex.I * (∫ y : ℝ in (-T)..T,
        archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) = 0 := by
  have hTpos : (0 : ℝ) < T := by linarith
  have h := Complex.integral_boundary_rect_eq_zero_of_differentiableOn
    (fun s => archFactor s * gaussianTest c σ s)
    ((1 / 2 : ℂ) + ((-T : ℝ) : ℂ) * Complex.I) ((2 : ℂ) + (T : ℂ) * Complex.I)
    (differentiableOn_of_re_pos (fun s hs => by
      have h1 : s.re ∈ Set.uIcc (1 / 2 : ℝ) 2 := by
        have := hs.1
        simpa using this
      rw [Set.uIcc_of_le (by norm_num : (1 / 2 : ℝ) ≤ 2)] at h1
      exact lt_of_lt_of_le (by norm_num) h1.1))
  -- rewrite the complex points to real coordinates
  have hz : (((1 / 2 : ℂ) + ((-T : ℝ) : ℂ) * Complex.I).re) = 1 / 2 := by simp
  have hzi : (((1 / 2 : ℂ) + ((-T : ℝ) : ℂ) * Complex.I).im) = -T := by simp
  have hw : (((2 : ℂ) + (T : ℂ) * Complex.I).re) = 2 := by simp
  have hwi : (((2 : ℂ) + (T : ℂ) * Complex.I).im) = T := by simp
  rw [hz, hzi, hw, hwi] at h
  simpa [Complex.real_smul, mul_comm, mul_left_comm, mul_assoc] using h

end DigammaContourShift

namespace DigammaContourShift



/-- **Logarithmic growth of `archFactor`, symmetric form.** -/
theorem archFactor_norm_le_abs {x y : ℝ} (hx4 : 1 / 4 ≤ x / 2) (hx2 : x ≤ 2)
    (hy : 2 ≤ |y|) :
    ‖archFactor (x + (y : ℂ) * Complex.I)‖ ≤
      (1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by
  have hypos : (0 : ℝ) < |y| := by linarith
  set w : ℂ := (x + (y : ℂ) * Complex.I) / 2 with hw
  have hw_eq : w = (x / 2 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I := by
    rw [hw]; push_cast; ring
  have hwre : w.re = x / 2 := by rw [hw_eq]; simp
  have hwim : w.im = y / 2 := by rw [hw_eq]; simp
  have hwnorm : ‖w‖ = Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) := by
    rw [hw_eq]
    exact Complex.norm_add_mul_I (x / 2) (y / 2)
  have hynorm : (y / 2) ^ 2 = (|y| / 2) ^ 2 := by
    rw [← sq_abs (y / 2), show |y / 2| = |y| / 2 by rw [abs_div]; norm_num]
  have hwre' : 1 / 4 ≤ w.re := by rw [hwre]; linarith
  have hwim' : w.im ≠ 0 := by
    rw [hwim]
    intro h
    have hy0 : y = 0 := by linarith
    rw [hy0] at hy
    norm_num at hy
  have hw1 : (1 : ℝ) ≤ ‖w‖ := by
    rw [hwnorm]
    have hcrit : (1 : ℝ) ≤ Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) := by
      rw [show (1 : ℝ) = Real.sqrt ((1:ℝ) ^ 2) by rw [Real.sqrt_sq]; norm_num]
      apply Real.sqrt_le_sqrt
      have h2 : (1 : ℝ) ≤ |y| / 2 := by linarith
      nlinarith [sq_nonneg (x/2), sq_nonneg (|y|/2)]
    exact hcrit
  have hwle : ‖w‖ ≤ (|y| + 2) / 2 := by
    rw [hwnorm]
    have hsq : (x / 2) ^ 2 + (y / 2) ^ 2 ≤ ((|y| + 2) / 2) ^ 2 := by
      rw [hynorm]
      nlinarith [sq_nonneg (x / 2), sq_nonneg (|y| / 2), abs_nonneg y]
    calc Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) ≤ Real.sqrt (((|y| + 2) / 2) ^ 2) :=
          Real.sqrt_le_sqrt hsq
      _ = (|y| + 2) / 2 := by rw [Real.sqrt_sq (by positivity)]
  have hlogw : ‖Complex.log w‖ ≤ Real.log ‖w‖ + Real.pi := norm_log_le hw1
  have hlogle : Real.log ‖w‖ ≤ Real.log ((|y| + 2) / 2) :=
    Real.log_le_log (by positivity) hwle
  have hpsi : ‖Complex.digamma w‖ ≤ Real.log ((|y| + 2) / 2) + Real.pi + 19 := by
    have h1 : ‖Complex.digamma w‖ ≤ ‖Complex.log w‖ + ‖Complex.digamma w - Complex.log w‖ := by
      have := norm_add_le (Complex.log w) (Complex.digamma w - Complex.log w)
      have e : Complex.log w + (Complex.digamma w - Complex.log w) = Complex.digamma w := by ring
      rw [e] at this
      exact this
    have h2 : ‖Complex.digamma w - Complex.log w‖ ≤ 19 := digamma_sub_log_le hwre' hwim'
    linarith
  have hlogpi : ‖Complex.log (Real.pi : ℂ)‖ = Real.log Real.pi := by
    have h1 : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) := by
      rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
    rw [h1, Complex.norm_real,
      Real.norm_of_nonneg (Real.log_nonneg (by nlinarith [Real.pi_gt_three]))]
  have harg : archFactor (x + (y : ℂ) * Complex.I) =
      (1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w := by
    unfold archFactor
    rw [hw]
  rw [harg]
  calc ‖(1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w‖
      ≤ ‖(1 / 2) * Complex.log (Real.pi : ℂ)‖ + ‖(1 / 2) * Complex.digamma w‖ := norm_sub_le _ _
    _ = (1 / 2) * Real.log Real.pi + (1 / 2) * ‖Complex.digamma w‖ := by
        rw [norm_mul, norm_mul, hlogpi]; norm_num
    _ ≤ (1 / 2) * Real.log Real.pi + (1 / 2) * (Real.log ((|y| + 2) / 2) + Real.pi + 19) := by
        gcongr
    _ = (1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by ring

end DigammaContourShift

namespace DigammaContourShift

/-- **Symmetric horizontal-segment bound.** -/
theorem horizontal_segment_le_abs {c σ y : ℝ} (hσ : 0 < σ) (hy : 2 ≤ |y|) :
    ‖∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (y : ℂ) * Complex.I) * gaussianTest c σ (x + (y : ℂ) * Complex.I)‖ ≤
      (2 - 1 / 2) *
        (((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
          (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) *
            Real.exp (-(σ ^ 2 * y ^ 2)) := by
  let K : ℝ := ((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19)) *
    (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) * Real.exp (-(σ ^ 2 * y ^ 2))
  have h := intervalIntegral.norm_integral_le_of_norm_le_const (a := (1 / 2 : ℝ)) (b := 2)
    (C := K) (f := fun x : ℝ => archFactor (x + (y : ℂ) * Complex.I) *
      gaussianTest c σ (x + (y : ℂ) * Complex.I)) (fun x hx => by
      have hx1 : (1 / 2 : ℝ) ≤ x := by
        have h0 := hx
        rw [show Set.uIoc (1 / 2 : ℝ) 2 = Set.Ioc (1 / 2 : ℝ) 2 from
          Set.uIoc_of_le (by norm_num : (1/2:ℝ) ≤ 2)] at h0
        exact h0.1.le
      have hx2 : x ≤ 2 := by
        have h0 := hx
        rw [show Set.uIoc (1 / 2 : ℝ) 2 = Set.Ioc (1 / 2 : ℝ) 2 from
          Set.uIoc_of_le (by norm_num : (1/2:ℝ) ≤ 2)] at h0
        exact h0.2
      have hx4 : 1 / 4 ≤ x / 2 := by linarith
      rw [norm_mul]
      have hA := archFactor_norm_le_abs (x := x) (y := y) hx4 hx2 hy
      have hB := gaussianTest_norm_le (c := c) (σ := σ) (x := x) (T := y) hσ (by linarith) hx2
      calc ‖archFactor (x + (y : ℂ) * Complex.I)‖ * ‖gaussianTest c σ (x + (y : ℂ) * Complex.I)‖
          ≤ ((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
              ((2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
                Real.exp (-(σ ^ 2 * y ^ 2))) := by
            refine mul_le_mul hA hB (norm_nonneg _) ?_
            have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
            have h2 : (0:ℝ) ≤ Real.log ((|y| + 2) / 2) := Real.log_nonneg (by
              have : (1:ℝ) ≤ (|y| + 2) / 2 := by linarith [abs_nonneg y]
              linarith)
            positivity
        _ = ((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
              (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))) *
                Real.exp (-(σ ^ 2 * y ^ 2)) := by ring
        _ = K := by unfold K; ring)
  calc ‖∫ x : ℝ in (1 / 2)..2, archFactor (x + (y : ℂ) * Complex.I) *
        gaussianTest c σ (x + (y : ℂ) * Complex.I)‖ ≤ K * |2 - 1 / 2| := h
    _ = (2 - 1 / 2) *
        (((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
          (2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)))) *
            Real.exp (-(σ ^ 2 * y ^ 2)) := by
        rw [abs_of_pos (by norm_num : (0:ℝ) < 2 - 1/2)]
        unfold K
        ring



/-- `e^{−σ²T²} → 0`. -/
theorem tendsto_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
  have h : Tendsto (fun T : ℝ => T ^ 2) atTop atTop :=
    tendsto_pow_atTop (α := ℝ) (n := 2) (by norm_num)
  have hmul : Tendsto (fun T : ℝ => σ ^ 2 * T ^ 2) atTop atTop :=
    h.const_mul_atTop (by positivity : (0:ℝ) < σ ^ 2)
  have hneg : Tendsto (fun T : ℝ => -(σ ^ 2 * T ^ 2)) atTop atBot :=
    tendsto_neg_atTop_atBot.comp hmul
  have h2 := Real.tendsto_exp_atBot.comp hneg
  convert h2 using 1
  ext T
  simp [Function.comp]

/-- `T²·e^{−σ²T²} → 0`. -/
theorem tendsto_sq_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => T ^ 2 * Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
  have h : Tendsto (fun T : ℝ => T ^ 2) atTop atTop :=
    tendsto_pow_atTop (α := ℝ) (n := 2) (by norm_num)
  have hmul : Tendsto (fun T : ℝ => σ ^ 2 * T ^ 2) atTop atTop :=
    h.const_mul_atTop (by positivity : (0:ℝ) < σ ^ 2)
  have hpow : Tendsto (fun x : ℝ => x ^ (1:ℕ) * Real.exp (-x)) atTop (nhds 0) :=
    Real.tendsto_pow_mul_exp_neg_atTop_nhds_zero 1
  have hcomp : Tendsto (fun T : ℝ => σ ^ 2 * T ^ 2 * Real.exp (-(σ ^ 2 * T ^ 2)))
      atTop (nhds 0) := by
    have h2 := hpow.comp hmul
    convert h2 using 1
    ext T
    simp [Function.comp, pow_one]
  have hdiv := hcomp.div_const (σ ^ 2)
  have h0 : (0 : ℝ) / σ ^ 2 = 0 := by simp [hσ.ne']
  rw [h0] at hdiv
  convert hdiv using 1
  ext T
  field_simp

/-- `(T²+1)·e^{−σ²T²} → 0`. -/
theorem tendsto_sq_add_one_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => (T ^ 2 + 1) * Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
  have hsum := (tendsto_sq_mul_exp_neg_sq σ hσ).add (tendsto_exp_neg_sq σ hσ)
  convert hsum using 1
  · ext T; ring
  · simp

/-- `log(T+2)·e^{−σ²T²} → 0`. -/
theorem tendsto_log_mul_exp_neg_sq (σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => Real.log (T + 2) * Real.exp (-(σ ^ 2 * T ^ 2))) atTop (nhds 0) := by
  have hbig := tendsto_sq_add_one_mul_exp_neg_sq σ hσ
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hbig ?_ ?_
  · filter_upwards [eventually_ge_atTop (2:ℝ)] with T hT
    exact mul_nonneg (Real.log_nonneg (by linarith)) (Real.exp_pos _).le
  · filter_upwards [eventually_ge_atTop (2:ℝ)] with T hT
    have hlog : Real.log (T + 2) ≤ T ^ 2 + 1 := by
      have h1 : Real.log (T + 2) ≤ T + 2 := Real.log_le_self (by linarith)
      nlinarith [sq_nonneg (T - 1), hT]
    exact mul_le_mul_of_nonneg_right hlog (Real.exp_pos _).le

end DigammaContourShift

namespace DigammaContourShift

/-- The horizontal integral tends to zero as `Im s → +∞`. -/
theorem tendsto_horizontal_atTop (c σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun y : ℝ => ∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (y : ℂ) * Complex.I) * gaussianTest c σ (x + (y : ℂ) * Complex.I))
      atTop (nhds 0) := by
  let K : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))
  have hlog := tendsto_log_mul_exp_neg_sq σ hσ
  have hexp := tendsto_exp_neg_sq σ hσ
  have hlog2 : Tendsto (fun y : ℝ => Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have := hexp.const_mul (Real.log 2)
    simpa using this
  have hlogdiv : Tendsto (fun y : ℝ => Real.log ((y + 2) / 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
      atTop (nhds 0) := by
    have hsub : Tendsto (fun y : ℝ => Real.log (y + 2) * Real.exp (-(σ ^ 2 * y ^ 2)) -
        Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
      simpa using hlog.sub hlog2
    have hcongr : (fun y : ℝ => (Real.log (y + 2) - Real.log 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
        =ᶠ[atTop] (fun y : ℝ => Real.log ((y + 2) / 2) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
      filter_upwards [eventually_ge_atTop (0:ℝ)] with y hy
      rw [Real.log_div (by linarith) (by norm_num)]
    rw [← show (fun y : ℝ => (Real.log (y + 2) - Real.log 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
        = (fun y : ℝ => Real.log (y + 2) * Real.exp (-(σ ^ 2 * y ^ 2)) -
            Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) from by funext y; ring] at hsub
    exact hsub.congr' hcongr
  have hA : Tendsto (fun y : ℝ => (Real.log Real.pi + (Real.log ((y + 2) / 2) + Real.pi + 19)) *
      Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have := hlogdiv.add (hexp.const_mul (Real.log Real.pi + Real.pi + 19))
    convert this using 1
    · ext y; ring
    · simp
  have hB : Tendsto (fun y : ℝ => (2 - 1 / 2) *
      (((1 / 2) * (Real.log Real.pi + (Real.log ((|y| + 2) / 2) + Real.pi + 19))) * K) *
        Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have h2 : Tendsto (fun y : ℝ => (2 - 1 / 2) *
        (((1 / 2) * (Real.log Real.pi + (Real.log ((y + 2) / 2) + Real.pi + 19))) * K) *
          Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
      have := hA.const_mul ((2 - 1 / 2) * (1 / 2) * K)
      convert this using 1
      · ext y; ring
      · ring
    refine h2.congr' ?_
    filter_upwards [eventually_ge_atTop (0:ℝ)] with y hy
    rw [abs_of_nonneg hy]
  rw [tendsto_zero_iff_norm_tendsto_zero]
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hB ?_ ?_
  · filter_upwards [eventually_ge_atTop (0:ℝ)] with y hy
    exact norm_nonneg _
  · filter_upwards [eventually_ge_atTop (2:ℝ)] with y hy
    have hy2 : 2 ≤ |y| := by rw [abs_of_nonneg (by linarith : (0:ℝ) ≤ y)]; exact hy
    simpa only [K] using horizontal_segment_le_abs (c := c) (σ := σ) hσ hy2

end DigammaContourShift

namespace DigammaContourShift

/-- The horizontal integral tends to zero as `Im s → −∞`. -/
theorem tendsto_horizontal_neg (c σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => ∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (-T : ℝ) * Complex.I) * gaussianTest c σ (x + (-T : ℝ) * Complex.I))
      atTop (nhds 0) := by
  let K : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2))
  have hlog := tendsto_log_mul_exp_neg_sq σ hσ
  have hexp := tendsto_exp_neg_sq σ hσ
  have hlog2 : Tendsto (fun y : ℝ => Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have := hexp.const_mul (Real.log 2); simpa using this
  have hlogdiv : Tendsto (fun y : ℝ => Real.log ((y + 2) / 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
      atTop (nhds 0) := by
    have hsub : Tendsto (fun y : ℝ => Real.log (y + 2) * Real.exp (-(σ ^ 2 * y ^ 2)) -
        Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
      simpa using hlog.sub hlog2
    have hcongr : (fun y : ℝ => (Real.log (y + 2) - Real.log 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
        =ᶠ[atTop] (fun y : ℝ => Real.log ((y + 2) / 2) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
      filter_upwards [eventually_ge_atTop (0:ℝ)] with y hy
      rw [Real.log_div (by linarith) (by norm_num)]
    rw [← show (fun y : ℝ => (Real.log (y + 2) - Real.log 2) * Real.exp (-(σ ^ 2 * y ^ 2)))
        = (fun y : ℝ => Real.log (y + 2) * Real.exp (-(σ ^ 2 * y ^ 2)) -
            Real.log 2 * Real.exp (-(σ ^ 2 * y ^ 2))) from by funext y; ring] at hsub
    exact hsub.congr' hcongr
  have hA : Tendsto (fun y : ℝ => (Real.log Real.pi + (Real.log ((y + 2) / 2) + Real.pi + 19)) *
      Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have := hlogdiv.add (hexp.const_mul (Real.log Real.pi + Real.pi + 19))
    convert this using 1
    · ext y; ring
    · simp
  have hB : Tendsto (fun y : ℝ => (2 - 1 / 2) *
      (((1 / 2) * (Real.log Real.pi + (Real.log ((y + 2) / 2) + Real.pi + 19))) * K) *
        Real.exp (-(σ ^ 2 * y ^ 2))) atTop (nhds 0) := by
    have := hA.const_mul ((2 - 1 / 2) * (1 / 2) * K)
    convert this using 1
    · ext y; ring
    · ring
  rw [tendsto_zero_iff_norm_tendsto_zero]
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hB ?_ ?_
  · filter_upwards [eventually_ge_atTop (0:ℝ)] with y hy
    exact norm_nonneg _
  · filter_upwards [eventually_ge_atTop (2:ℝ)] with y hy
    have hy2 : 2 ≤ |(-y : ℝ)| := by rw [abs_neg, abs_of_nonneg (by linarith : (0:ℝ) ≤ y)]; exact hy
    have hle := horizontal_segment_le_abs (c := c) (σ := σ) hσ (y := -y) hy2
    rw [show |(-y : ℝ)| = y from by
      rw [abs_neg, abs_of_nonneg (by linarith : (0:ℝ) ≤ y)]] at hle
    rw [show (-y : ℝ) ^ 2 = y ^ 2 from by ring] at hle
    simpa only [K] using hle

end DigammaContourShift

namespace DigammaContourShift

/-- **The archimedean contour shift for the Gaussian test.** -/
theorem archimedeanShift_gaussian (c σ : ℝ) (hσ : 0 < σ) :
    ArchimedeanShiftLim (gaussianTest c σ) := by
  have hA := tendsto_horizontal_neg c σ hσ
  have hB := tendsto_horizontal_atTop c σ hσ
  have hAB : Tendsto (fun T : ℝ =>
      (∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (-T : ℝ) * Complex.I) * gaussianTest c σ (x + (-T : ℝ) * Complex.I)) -
      (∫ x : ℝ in (1 / 2)..2,
        archFactor (x + (T : ℝ) * Complex.I) * gaussianTest c σ (x + (T : ℝ) * Complex.I)))
      atTop (nhds 0) := by
    simpa using hA.sub hB
  -- From the rectangle identity, A − B = I·(D − C) for T ≥ 2.
  have hchain : Tendsto (fun T : ℝ => Complex.I *
      ((∫ y : ℝ in (-T)..T, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) -
      (∫ y : ℝ in (-T)..T, archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)))) atTop (nhds 0) := by
    refine hAB.congr' ?_
    filter_upwards [eventually_ge_atTop (2:ℝ)] with T hT
    have h := rectangle_identity c σ hσ T hT
    linear_combination h
  have hdiv : Tendsto (fun T : ℝ => (Complex.I *
      ((∫ y : ℝ in (-T)..T, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) -
      (∫ y : ℝ in (-T)..T, archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)))) / Complex.I) atTop (nhds 0) := by
    have := hchain.div_const Complex.I
    simpa [zero_div] using this
  unfold ArchimedeanShiftLim
  refine hdiv.congr' ?_
  filter_upwards with T
  field_simp



/-- **The shift transfers a critical-line limit to `Re s = 2`.**  If the
truncated archimedean integral on the critical line tends to `L`, then so does
the one at `Re s = 2`. -/
theorem tendsto_line_two_of_shift (c σ : ℝ) (hσ : 0 < σ) {L : ℂ}
    (hcrit : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) atTop (nhds L))
    (hshift : ArchimedeanShiftLim (gaussianTest c σ)) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I)) atTop (nhds L) := by
  have h := hcrit.sub hshift
  simpa using h



/-- **Global `‖log w‖` bound** in the strip. -/
theorem norm_log_le_global {w : ℂ} {M : ℝ} (h14 : 1 / 4 ≤ ‖w‖) (hM1 : 1 ≤ M)
    (hwM : ‖w‖ ≤ M) :
    ‖Complex.log w‖ ≤ Real.log 4 + Real.log M + Real.pi := by
  have hnorm := Complex.norm_le_abs_re_add_abs_im (Complex.log w)
  rw [Complex.log_re, Complex.log_im] at hnorm
  have harg : |Complex.arg w| ≤ Real.pi := Complex.abs_arg_le_pi w
  have hlog : |Real.log ‖w‖| ≤ Real.log 4 + Real.log M := by
    rcases le_or_gt 1 ‖w‖ with h1 | h1
    · rw [abs_of_nonneg (Real.log_nonneg h1)]
      have hlogM : Real.log ‖w‖ ≤ Real.log M := Real.log_le_log (by linarith) hwM
      have h4 : (0:ℝ) ≤ Real.log 4 := Real.log_nonneg (by norm_num)
      linarith
    · rw [abs_of_neg (Real.log_neg (by linarith) (by linarith))]
      have hlog4 : -Real.log ‖w‖ ≤ Real.log 4 := by
        have h14' : Real.log (1 / 4 : ℝ) ≤ Real.log ‖w‖ := Real.log_le_log (by norm_num) h14
        rw [Real.log_div (by norm_num) (by norm_num), Real.log_one] at h14'
        linarith
      have hlogM : (0:ℝ) ≤ Real.log M := Real.log_nonneg hM1
      linarith
  linarith

/-- **Global archimedean bound** in the strip (no restriction on `|y|`). -/
theorem archFactor_norm_le_global {x y : ℝ} (hx4 : 1 / 4 ≤ x / 2) (hx2 : x ≤ 2)
    (hy : y ≠ 0) :
    ‖archFactor (x + (y : ℂ) * Complex.I)‖ ≤
      (1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by
  set w : ℂ := (x + (y : ℂ) * Complex.I) / 2 with hw
  have hw_eq : w = (x / 2 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I := by
    rw [hw]; push_cast; ring
  have hwre : w.re = x / 2 := by rw [hw_eq]; simp
  have hwim : w.im = y / 2 := by rw [hw_eq]; simp
  have hwnorm : ‖w‖ = Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) := by
    rw [hw_eq]; exact Complex.norm_add_mul_I (x / 2) (y / 2)
  have hwre' : 1 / 4 ≤ w.re := by rw [hwre]; linarith
  have hwim' : w.im ≠ 0 := by rw [hwim]; exact div_ne_zero hy (by norm_num)
  have hw14 : (1 / 4 : ℝ) ≤ ‖w‖ := by
    rw [hwnorm]
    have : (1 / 4 : ℝ) ^ 2 ≤ (x / 2) ^ 2 + (y / 2) ^ 2 := by nlinarith
    calc (1 / 4 : ℝ) = Real.sqrt ((1 / 4 : ℝ) ^ 2) := by rw [Real.sqrt_sq]; norm_num
      _ ≤ Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) := Real.sqrt_le_sqrt this
  have hwle : ‖w‖ ≤ (|y| + 2) / 2 := by
    rw [hwnorm]
    have hsq : (x / 2) ^ 2 + (y / 2) ^ 2 ≤ ((|y| + 2) / 2) ^ 2 := by
      have hy2 : (y / 2) ^ 2 = (|y| / 2) ^ 2 := by
        rw [← sq_abs (y / 2), show |y / 2| = |y| / 2 by rw [abs_div]; norm_num]
      rw [hy2]
      nlinarith [sq_nonneg (x / 2), sq_nonneg (|y| / 2), abs_nonneg y]
    calc Real.sqrt ((x / 2) ^ 2 + (y / 2) ^ 2) ≤ Real.sqrt (((|y| + 2) / 2) ^ 2) :=
          Real.sqrt_le_sqrt hsq
      _ = (|y| + 2) / 2 := by rw [Real.sqrt_sq (by positivity)]
  have hM1 : (1 : ℝ) ≤ (|y| + 2) / 2 := by
    have := abs_nonneg y; linarith
  have hlogw : ‖Complex.log w‖ ≤ Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi :=
    norm_log_le_global hw14 hM1 hwle
  have hlogle : Real.log ‖w‖ ≤ Real.log ((|y| + 2) / 2) :=
    Real.log_le_log (by positivity) hwle
  have hpsi : ‖Complex.digamma w‖ ≤
      Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19 := by
    have h1 : ‖Complex.digamma w‖ ≤ ‖Complex.log w‖ + ‖Complex.digamma w - Complex.log w‖ := by
      have := norm_add_le (Complex.log w) (Complex.digamma w - Complex.log w)
      have e : Complex.log w + (Complex.digamma w - Complex.log w) = Complex.digamma w := by ring
      rw [e] at this
      exact this
    have h2 : ‖Complex.digamma w - Complex.log w‖ ≤ 19 := digamma_sub_log_le hwre' hwim'
    linarith
  have hlogpi : ‖Complex.log (Real.pi : ℂ)‖ = Real.log Real.pi := by
    have h1 : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) := by
      rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
    rw [h1, Complex.norm_real,
      Real.norm_of_nonneg (Real.log_nonneg (by nlinarith [Real.pi_gt_three]))]
  have harg : archFactor (x + (y : ℂ) * Complex.I) =
      (1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w := by
    unfold archFactor
    rw [hw]
  rw [harg]
  calc ‖(1 / 2) * Complex.log (Real.pi : ℂ) - (1 / 2) * Complex.digamma w‖
      ≤ ‖(1 / 2) * Complex.log (Real.pi : ℂ)‖ + ‖(1 / 2) * Complex.digamma w‖ := norm_sub_le _ _
    _ = (1 / 2) * Real.log Real.pi + (1 / 2) * ‖Complex.digamma w‖ := by
        rw [norm_mul, norm_mul, hlogpi]; norm_num
    _ ≤ (1 / 2) * Real.log Real.pi +
        (1 / 2) * (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19) := by
        gcongr
    _ = (1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by
        ring

end DigammaContourShift

namespace DigammaContourShift

/-- **Integrability on the vertical line.** -/
theorem integrable_line (c σ x : ℝ) (hσ : 0 < σ) (hx4 : 1 / 4 ≤ x / 2) (hx2 : x ≤ 2) :
    Integrable (fun y : ℝ => archFactor (x + (y : ℂ) * Complex.I) *
      gaussianTest c σ (x + (y : ℂ) * Complex.I)) := by
  set K : ℝ := 2 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 * (9 / 4) + |c| * (3 / 2)) with hK
  set c0 : ℝ := Real.log Real.pi + Real.log 4 + Real.pi + 19 with hc0
  have hKpos : (0 : ℝ) < K := by unfold K; positivity
  have hc0pos : (0 : ℝ) < c0 := by
    unfold c0
    have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
    have h2 : (0:ℝ) ≤ Real.log 4 := Real.log_nonneg (by norm_num)
    nlinarith [Real.pi_pos]
  let C : ℝ := (1 / 2) * K * (3 + c0)
  have hC : (0 : ℝ) ≤ C := by unfold C; positivity
  have hexp : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have := integrable_exp_neg_mul_sq (b := σ ^ 2) (by positivity)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  have habs : Integrable (fun y : ℝ => |y| * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have h := (integrable_mul_exp_neg_mul_sq (b := σ ^ 2) (by positivity)).abs
    convert h using 1
    ext y
    rw [abs_mul, abs_of_pos (Real.exp_pos _)]
    congr 1
    ring
  have hmaj : Integrable (fun y : ℝ => C * (1 + |y|) * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have hsum : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2)) +
        |y| * Real.exp (-(σ ^ 2 * y ^ 2))) := hexp.add habs
    have h := hsum.const_mul C
    convert h using 1
    ext y; ring
  have hcont : Continuous (fun y : ℝ => archFactor (x + (y : ℂ) * Complex.I) *
      gaussianTest c σ (x + (y : ℂ) * Complex.I)) := by
    apply Continuous.mul
    · unfold archFactor
      apply Continuous.sub continuous_const
      apply Continuous.const_mul
      apply continuous_iff_continuousAt.mpr
      intro y
      have hlin : ContinuousAt (fun y : ℝ => (x + (y : ℂ) * Complex.I) / 2) y := by fun_prop
      have hre : 0 < ((x + (y : ℂ) * Complex.I) / 2).re := by
        rw [show ((x + (y : ℂ) * Complex.I) / 2) =
          (x / 2 : ℝ) + (y / 2 : ℝ) * Complex.I by push_cast; ring]
        simp
        linarith
      exact ContinuousAt.comp (differentiableAt_digamma_of_re_pos hre).continuousAt hlin
    · unfold gaussianTest
      fun_prop
  refine Integrable.mono' hmaj hcont.aestronglyMeasurable ?_
  have hne : ∀ᵐ y : ℝ ∂volume, y ≠ 0 := by
    rw [MeasureTheory.ae_iff]
    simp
  filter_upwards [hne] with y hy
  -- the pointwise bound
  have hA := archFactor_norm_le_global (x := x) (y := y) hx4 hx2 hy
  have hB := gaussianTest_norm_le (c := c) (σ := σ) (x := x) (T := y) hσ (by linarith) hx2
  rw [norm_mul]
  have hM1 : (1 : ℝ) ≤ (|y| + 2) / 2 := by have := abs_nonneg y; linarith
  have hlogM : Real.log ((|y| + 2) / 2) ≤ 1 + |y| := by
    have h := Real.log_le_sub_one_of_pos (by linarith : (0:ℝ) < (|y| + 2) / 2)
    have : (|y| + 2) / 2 - 1 = |y| / 2 := by ring
    rw [this] at h
    have : |y| / 2 ≤ 1 + |y| := by linarith [abs_nonneg y]
    linarith
  have hprod : ((1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
      (K * Real.exp (-(σ ^ 2 * y ^ 2))) ≤ C * (1 + |y|) * Real.exp (-(σ ^ 2 * y ^ 2)) := by
    have hA' : (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19)) ≤
        c0 + (1 + |y|) := by unfold c0; linarith
    have h1 : (0:ℝ) ≤ 1 + |y| := by linarith [abs_nonneg y]
    have hstep : ((1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19))) ≤
        (1 / 2) * (c0 + (1 + |y|)) := by linarith
    have hstep2 : (1 / 2) * (c0 + (1 + |y|)) ≤ (1 / 2) * (3 + c0) * (1 + |y|) := by
      have h3 : (c0 + (1 + |y|)) ≤ (3 + c0) * (1 + |y|) := by nlinarith
      linarith
    calc ((1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
          (K * Real.exp (-(σ ^ 2 * y ^ 2)))
        ≤ ((1 / 2) * (3 + c0) * (1 + |y|)) * (K * Real.exp (-(σ ^ 2 * y ^ 2))) := by
          apply mul_le_mul_of_nonneg_right ?_ (by positivity)
          linarith
      _ = C * (1 + |y|) * Real.exp (-(σ ^ 2 * y ^ 2)) := by unfold C; ring
  calc ‖archFactor (x + (y : ℂ) * Complex.I)‖ * ‖gaussianTest c σ (x + (y : ℂ) * Complex.I)‖
      ≤ ((1 / 2) * (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19))) *
          (K * Real.exp (-(σ ^ 2 * y ^ 2))) := by
        refine mul_le_mul hA hB (norm_nonneg _) ?_
        have h1 : (0:ℝ) ≤ Real.log ((|y| + 2) / 2) := Real.log_nonneg hM1
        have h2 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
        have h3 : (0:ℝ) ≤ Real.log 4 := Real.log_nonneg (by norm_num)
        positivity
    _ ≤ C * (1 + |y|) * Real.exp (-(σ ^ 2 * y ^ 2)) := hprod

end DigammaContourShift

namespace DigammaContourShift

/-- The truncated critical-line integral converges to the full integral. -/
theorem tendsto_line_integral (c σ x : ℝ) (hσ : 0 < σ) (hx4 : 1 / 4 ≤ x / 2) (hx2 : x ≤ 2) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        archFactor (x + (y : ℂ) * Complex.I) * gaussianTest c σ (x + (y : ℂ) * Complex.I))
      atTop (nhds (∫ y : ℝ,
        archFactor (x + (y : ℂ) * Complex.I) * gaussianTest c σ (x + (y : ℂ) * Complex.I))) := by
  exact intervalIntegral_tendsto_integral (integrable_line c σ x hσ hx4 hx2)
    tendsto_neg_atTop_atBot tendsto_id

/-- **The archimedean evaluation at `Re s = 2`.**  The truncated integral at
`Re s = 2` converges to the full critical-line integral. -/
theorem tendsto_line_two_lim (c σ : ℝ) (hσ : 0 < σ) :
    Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
        archFactor ((2 : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ ((2 : ℂ) + (y : ℂ) * Complex.I))
      atTop (nhds (∫ y : ℝ,
        archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I))) := by
  have hcrit : Tendsto (fun T : ℝ => ∫ y : ℝ in (-T)..T,
      archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I))
      atTop (nhds (∫ y : ℝ,
        archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I))) :=
    tendsto_line_integral c σ (1 / 2) hσ (by norm_num) (by norm_num)
  exact tendsto_line_two_of_shift c σ hσ hcrit (archimedeanShift_gaussian c σ hσ)



/-- `Ω(t) = Re ψ(1/4 + it/2) − log π`. -/
def omega (t : ℝ) : ℝ :=
  (Complex.digamma ((1 / 4 : ℝ) + (t : ℂ) * Complex.I / 2)).re - Real.log Real.pi

/-- `Im ψ(1/4 + it/2)`. -/
def psiIm (t : ℝ) : ℝ :=
  (Complex.digamma ((1 / 4 : ℝ) + (t : ℂ) * Complex.I / 2)).im

/-- The density term `σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`. -/
def densityTerm (c σ : ℝ) : ℝ :=
  σ ^ 2 * ∫ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.cos (c * t) * omega t

/-- The `Im ψ` term. -/
def imTerm (c σ : ℝ) : ℝ :=
  σ ^ 2 * ∫ t : ℝ, Real.exp (-(σ * t) ^ 2) * Real.sin (c * t) * psiIm t

/-- The critical-line Gaussian test in trigonometric form. -/
theorem gaussianTest_half_add (c σ y : ℝ) :
    gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) =
      ((2 * Real.pi * σ ^ 2 * Real.exp (-(σ * y) ^ 2) : ℝ) : ℂ) *
        ((Real.cos (c * y) : ℂ) - (Real.sin (c * y) : ℂ) * Complex.I) := by
  unfold gaussianTest
  have h1 : (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) - 1 / 2 = (y : ℂ) * Complex.I := by
    push_cast; ring
  rw [h1]
  have h2 : (((σ ^ 2 : ℝ) : ℂ) * ((y : ℂ) * Complex.I) ^ 2) = ((-(σ * y) ^ 2 : ℝ) : ℂ) := by
    have hy2 : ((y : ℂ) * Complex.I) ^ 2 = ((-(y ^ 2) : ℝ) : ℂ) := by
      rw [mul_pow]
      rw [show (Complex.I : ℂ) ^ 2 = -1 from by simp [Complex.I_mul_I]]
      push_cast
      ring
    rw [hy2]
    push_cast
    ring
  have h3 : (-((c : ℝ) : ℂ) * ((y : ℂ) * Complex.I)) = ((-(c * y) : ℝ) : ℂ) * Complex.I := by
    push_cast; ring
  rw [h2, h3]
  rw [show Complex.exp ((-(c * y) : ℝ) * Complex.I) =
      (Real.cos (c * y) : ℂ) - (Real.sin (c * y) : ℂ) * Complex.I by
    rw [Complex.exp_mul_I]
    simp only [Complex.ofReal_neg, Complex.cos_neg, Complex.sin_neg, Complex.ofReal_sin, Complex.ofReal_cos]
    ring]
  rw [show Complex.exp (((-(σ * y) ^ 2 : ℝ)) : ℂ) = ((Real.exp (-(σ * y) ^ 2) : ℝ) : ℂ) by
    rw [← Complex.ofReal_exp]]
  push_cast
  ring



/-- The archimedean factor on the critical line. -/
theorem archFactor_half_add (y : ℝ) :
    archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) =
      ((-(1 / 2) * omega y : ℝ) : ℂ) + ((-(1 / 2) * psiIm y : ℝ) : ℂ) * Complex.I := by
  have hlog : Complex.log (Real.pi : ℂ) = ((Real.log Real.pi : ℝ) : ℂ) := by
    rw [← Complex.ofReal_log (le_of_lt Real.pi_pos)]
  have hz : (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) / 2 =
      (1 / 4 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I := by
    push_cast
    ring
  have hpsi : Complex.digamma ((1 / 4 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I) =
      ((Complex.digamma ((1 / 4 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I)).re : ℂ) +
        ((Complex.digamma ((1 / 4 : ℝ) + ((y / 2 : ℝ) : ℂ) * Complex.I)).im : ℂ) * Complex.I :=
    (Complex.re_add_im _).symm
  unfold archFactor omega psiIm
  rw [hz, hlog, hpsi]
  push_cast
  ring

end DigammaContourShift

namespace DigammaContourShift

/-- **Pointwise real part of the critical-line integrand.** -/
theorem archFactor_gaussianTest_re (c σ y : ℝ) :
    (archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re =
      -Real.pi * σ ^ 2 * Real.exp (-(σ * y) ^ 2) *
        (omega y * Real.cos (c * y) + psiIm y * Real.sin (c * y)) := by
  rw [archFactor_half_add, gaussianTest_half_add]
  simp only [Complex.mul_re, Complex.add_re, Complex.add_im, Complex.mul_im, Complex.sub_re,
    Complex.sub_im, Complex.ofReal_re, Complex.ofReal_im, Complex.ofReal_mul, Complex.ofReal_neg,
    Complex.ofReal_ofNat, Complex.neg_re, Complex.neg_im, Complex.I_re, Complex.I_im, mul_zero,
    sub_zero, zero_mul, add_zero, mul_one, one_mul]
  norm_num
  ring



/-- `|Ω(y)|` is bounded by twice the archimedean factor. -/
theorem abs_omega_le (y : ℝ) :
    |omega y| ≤ 2 * ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ := by
  have h := archFactor_half_add y
  have hre : (archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re = -(1 / 2) * omega y := by
    rw [h]
    simp [Complex.add_re, Complex.mul_re, Complex.ofReal_re, Complex.ofReal_im]
  have hnorm : |(archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re| ≤
      ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ :=
    Complex.abs_re_le_norm _
  rw [hre] at hnorm
  have h2 : |-(1 / 2) * omega y| = (1 / 2) * |omega y| := by
    rw [abs_mul]; norm_num
  rw [h2] at hnorm
  linarith

/-- `|Im ψ(1/4+iy/2)|` is bounded by twice the archimedean factor. -/
theorem abs_psiIm_le (y : ℝ) :
    |psiIm y| ≤ 2 * ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ := by
  have h := archFactor_half_add y
  have him : (archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).im = -(1 / 2) * psiIm y := by
    rw [h]
    simp [Complex.add_im, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im]
  have hnorm : |(archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).im| ≤
      ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ :=
    Complex.abs_im_le_norm _
  rw [him] at hnorm
  have h2 : |-(1 / 2) * psiIm y| = (1 / 2) * |psiIm y| := by
    rw [abs_mul]; norm_num
  rw [h2] at hnorm
  linarith

end DigammaContourShift

namespace DigammaContourShift

/-- The Gaussian majorant `C(1+|y|)e^{−σ²y²}` is integrable. -/
theorem integrable_majorant (σ C : ℝ) (hσ : 0 < σ) :
    Integrable (fun y : ℝ => C * (1 + |y|) * Real.exp (-(σ * y) ^ 2)) := by
  have hexp : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have := integrable_exp_neg_mul_sq (b := σ ^ 2) (by positivity)
    simpa [neg_mul, mul_comm, mul_left_comm, mul_assoc] using this
  have habs : Integrable (fun y : ℝ => |y| * Real.exp (-(σ ^ 2 * y ^ 2))) := by
    have h := (integrable_mul_exp_neg_mul_sq (b := σ ^ 2) (by positivity)).abs
    convert h using 1
    ext y
    rw [abs_mul, abs_of_pos (Real.exp_pos _)]
    congr 1
    ring
  have hsum : Integrable (fun y : ℝ => Real.exp (-(σ ^ 2 * y ^ 2)) +
      |y| * Real.exp (-(σ ^ 2 * y ^ 2))) := hexp.add habs
  have h := hsum.const_mul C
  convert h using 1
  ext y
  rw [show -(σ * y) ^ 2 = -(σ ^ 2 * y ^ 2) by ring]
  ring



/-- Continuity of `y ↦ Ω(y)`. -/
theorem continuous_omega : Continuous omega := by
  unfold omega
  apply Continuous.sub
  · apply Complex.continuous_re.comp
    apply continuous_iff_continuousAt.mpr
    intro y
    have hlin : ContinuousAt (fun y : ℝ => ((1 / 4 : ℝ) + (y : ℂ) * Complex.I / 2)) y := by fun_prop
    have hre : 0 < ((1 / 4 : ℝ) + (y : ℂ) * Complex.I / 2).re := by
      simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
    exact ContinuousAt.comp (differentiableAt_digamma_of_re_pos hre).continuousAt hlin
  · exact continuous_const

/-- Continuity of `y ↦ Im ψ(1/4+iy/2)`. -/
theorem continuous_psiIm : Continuous psiIm := by
  unfold psiIm
  apply Complex.continuous_im.comp
  apply continuous_iff_continuousAt.mpr
  intro y
  have hlin : ContinuousAt (fun y : ℝ => ((1 / 4 : ℝ) + (y : ℂ) * Complex.I / 2)) y := by fun_prop
  have hre : 0 < ((1 / 4 : ℝ) + (y : ℂ) * Complex.I / 2).re := by
    simp [Complex.add_re, Complex.mul_re, Complex.I_re, Complex.I_im]
  exact ContinuousAt.comp (differentiableAt_digamma_of_re_pos hre).continuousAt hlin

/-- `e^{−σ²y²}cos(cy)Ω(y)` is integrable. -/
theorem integrable_omega_cos (c σ : ℝ) (hσ : 0 < σ) :
    Integrable (fun y : ℝ => Real.exp (-(σ * y) ^ 2) * Real.cos (c * y) * omega y) := by
  set c0 : ℝ := Real.log Real.pi + Real.log 4 + Real.pi + 19 with hc0
  set C : ℝ := c0 + 3 with hC
  have hmaj := integrable_majorant σ C hσ
  have hne : ∀ᵐ y : ℝ ∂volume, y ≠ 0 := by
    rw [MeasureTheory.ae_iff]; simp
  have hcont : Continuous (fun y : ℝ => Real.exp (-(σ * y) ^ 2) * Real.cos (c * y) * omega y) := by
    apply Continuous.mul
    · apply Continuous.mul
      · exact Real.continuous_exp.comp (by fun_prop : Continuous fun y : ℝ => -(σ * y) ^ 2)
      · exact Real.continuous_cos.comp (by fun_prop : Continuous fun y : ℝ => c * y)
    · exact continuous_omega
  refine Integrable.mono' hmaj hcont.aestronglyMeasurable ?_
  filter_upwards [hne] with y hy
  have hA := archFactor_norm_le_global (x := 1/2) (y := y) (by norm_num) (by norm_num) hy
  have hw := abs_omega_le y
  have hcos : |Real.cos (c * y)| ≤ 1 := Real.abs_cos_le_one _
  have hlogM : Real.log ((|y| + 2) / 2) ≤ 1 + |y| := by
    have h := Real.log_le_sub_one_of_pos (by linarith [abs_nonneg y] : (0:ℝ) < (|y| + 2) / 2)
    have : (|y| + 2) / 2 - 1 = |y| / 2 := by ring
    rw [this] at h
    linarith [abs_nonneg y]
  have h1 : |omega y| ≤ c0 + (1 + |y|) := by
    have h2 : 2 * ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ ≤
        (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by
      linarith [hA]
    rw [hc0]
    linarith
  rw [norm_mul, norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs]
  have he1 : |Real.exp (-(σ * y) ^ 2)| = Real.exp (-(σ * y) ^ 2) := abs_of_pos (Real.exp_pos _)
  rw [he1]
  have hc0' : (0:ℝ) ≤ c0 := by
    rw [hc0]
    have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
    have h2 : (0:ℝ) ≤ Real.log 4 := Real.log_nonneg (by norm_num)
    linarith [Real.pi_pos]
  have hC' : c0 + (1 + |y|) ≤ C * (1 + |y|) := by
    rw [hC]
    have hy1 : (0:ℝ) ≤ |y| := abs_nonneg y
    nlinarith [hy1, hc0']
  calc Real.exp (-(σ * y) ^ 2) * |Real.cos (c * y)| * |omega y|
      ≤ Real.exp (-(σ * y) ^ 2) * 1 * (c0 + (1 + |y|)) := by
        apply mul_le_mul
        · exact mul_le_mul_of_nonneg_left hcos (Real.exp_pos _).le
        · exact h1
        · exact abs_nonneg _
        · positivity
    _ ≤ Real.exp (-(σ * y) ^ 2) * (C * (1 + |y|)) := by
        exact mul_le_mul (by rw [mul_one]) hC' (by positivity) (le_of_lt (Real.exp_pos _))
    _ = C * (1 + |y|) * Real.exp (-(σ * y) ^ 2) := by ring

/-- `e^{−σ²y²}sin(cy)Im ψ(y)` is integrable. -/
theorem integrable_psiIm_sin (c σ : ℝ) (hσ : 0 < σ) :
    Integrable (fun y : ℝ => Real.exp (-(σ * y) ^ 2) * Real.sin (c * y) * psiIm y) := by
  set c0 : ℝ := Real.log Real.pi + Real.log 4 + Real.pi + 19 with hc0
  set C : ℝ := c0 + 3 with hC
  have hmaj := integrable_majorant σ C hσ
  have hne : ∀ᵐ y : ℝ ∂volume, y ≠ 0 := by
    rw [MeasureTheory.ae_iff]; simp
  have hcont : Continuous (fun y : ℝ => Real.exp (-(σ * y) ^ 2) * Real.sin (c * y) * psiIm y) := by
    apply Continuous.mul
    · apply Continuous.mul
      · exact Real.continuous_exp.comp (by fun_prop : Continuous fun y : ℝ => -(σ * y) ^ 2)
      · exact Real.continuous_sin.comp (by fun_prop : Continuous fun y : ℝ => c * y)
    · exact continuous_psiIm
  refine Integrable.mono' hmaj hcont.aestronglyMeasurable ?_
  filter_upwards [hne] with y hy
  have hA := archFactor_norm_le_global (x := 1/2) (y := y) (by norm_num) (by norm_num) hy
  have hw := abs_psiIm_le y
  have hsin : |Real.sin (c * y)| ≤ 1 := Real.abs_sin_le_one _
  have hlogM : Real.log ((|y| + 2) / 2) ≤ 1 + |y| := by
    have h := Real.log_le_sub_one_of_pos (by linarith [abs_nonneg y] : (0:ℝ) < (|y| + 2) / 2)
    have : (|y| + 2) / 2 - 1 = |y| / 2 := by ring
    rw [this] at h
    linarith [abs_nonneg y]
  have h1 : |psiIm y| ≤ c0 + (1 + |y|) := by
    have h2 : 2 * ‖archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)‖ ≤
        (Real.log Real.pi + (Real.log 4 + Real.log ((|y| + 2) / 2) + Real.pi + 19)) := by
      linarith [hA]
    rw [hc0]
    linarith
  rw [norm_mul, norm_mul, Real.norm_eq_abs, Real.norm_eq_abs, Real.norm_eq_abs]
  have he1 : |Real.exp (-(σ * y) ^ 2)| = Real.exp (-(σ * y) ^ 2) := abs_of_pos (Real.exp_pos _)
  rw [he1]
  have hc0' : (0:ℝ) ≤ c0 := by
    rw [hc0]
    have h1 : (0:ℝ) ≤ Real.log Real.pi := Real.log_nonneg (by nlinarith [Real.pi_gt_three])
    have h2 : (0:ℝ) ≤ Real.log 4 := Real.log_nonneg (by norm_num)
    linarith [Real.pi_pos]
  have hC' : c0 + (1 + |y|) ≤ C * (1 + |y|) := by
    rw [hC]
    have hy1 : (0:ℝ) ≤ |y| := abs_nonneg y
    nlinarith [hy1, hc0']
  calc Real.exp (-(σ * y) ^ 2) * |Real.sin (c * y)| * |psiIm y|
      ≤ Real.exp (-(σ * y) ^ 2) * 1 * (c0 + (1 + |y|)) := by
        apply mul_le_mul
        · exact mul_le_mul_of_nonneg_left hsin (Real.exp_pos _).le
        · exact h1
        · exact abs_nonneg _
        · positivity
    _ ≤ Real.exp (-(σ * y) ^ 2) * (C * (1 + |y|)) := by
        exact mul_le_mul (by rw [mul_one]) hC' (by positivity) (le_of_lt (Real.exp_pos _))
    _ = C * (1 + |y|) * Real.exp (-(σ * y) ^ 2) := by ring

end DigammaContourShift

namespace DigammaContourShift

/-- **The critical-line integral, real part.** -/
theorem integral_re_eq (c σ : ℝ) (hσ : 0 < σ) :
    (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re =
      -Real.pi * (densityTerm c σ + imTerm c σ) := by
  have hf := integrable_line c σ (1 / 2) hσ (by norm_num) (by norm_num)
  have hre : (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re =
      ∫ y : ℝ, (archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re := by
    have h := ContinuousLinearMap.integral_comp_comm Complex.reCLM hf
    conv_lhs => rw [show (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
        gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re =
        Complex.reCLM (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
          gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)) from (Complex.reCLM_apply _).symm]
    rw [← h]
    simp [Complex.reCLM_apply]
  rw [hre]
  simp_rw [archFactor_gaussianTest_re]
  have h1 := integrable_omega_cos c σ hσ
  have h2 := integrable_psiIm_sin c σ hσ
  have hsplit : ∀ y : ℝ, -Real.pi * σ ^ 2 * Real.exp (-(σ * y) ^ 2) *
      (omega y * Real.cos (c * y) + psiIm y * Real.sin (c * y)) =
      (-Real.pi * σ ^ 2) * ((Real.exp (-(σ * y) ^ 2) * Real.cos (c * y) * omega y) +
        (Real.exp (-(σ * y) ^ 2) * Real.sin (c * y) * psiIm y)) := by
    intro y; ring
  simp_rw [hsplit]
  rw [integral_const_mul, integral_add h1 h2]
  unfold densityTerm imTerm
  ring

end DigammaContourShift

namespace DigammaContourShift

/-- The density term is even in `c`. -/
theorem densityTerm_neg (c σ : ℝ) : densityTerm (-c) σ = densityTerm c σ := by
  unfold densityTerm
  congr 1
  apply integral_congr_ae
  filter_upwards with t
  rw [neg_mul, Real.cos_neg]

/-- The `Im ψ` term is odd in `c`. -/
theorem imTerm_neg (c σ : ℝ) : imTerm (-c) σ = -imTerm c σ := by
  unfold imTerm
  have hfun : (fun t : ℝ => Real.exp (-(σ * t) ^ 2) * Real.sin ((-c) * t) * psiIm t) =
      (fun t : ℝ => -(Real.exp (-(σ * t) ^ 2) * Real.sin (c * t) * psiIm t)) := by
    funext t
    rw [neg_mul, Real.sin_neg]
    ring
  rw [hfun, integral_neg]
  ring

/-- **The archimedean value, summed over `±c`.** -/
theorem archimedeanValue_sum (c σ : ℝ) (hσ : 0 < σ) :
    (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      gaussianTest c σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re +
    (∫ y : ℝ, archFactor (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I) *
      gaussianTest (-c) σ (((1 / 2 : ℝ) : ℂ) + (y : ℂ) * Complex.I)).re =
      -2 * Real.pi * densityTerm c σ := by
  rw [integral_re_eq c σ hσ, integral_re_eq (-c) σ hσ, densityTerm_neg, imTerm_neg]
  ring

end DigammaContourShift
