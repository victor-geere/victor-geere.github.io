/-
# The Jacobi theta function and its functional equation

Stage 1 of a self-contained theta-based proof of the Riemann zeta functional
equation: the theta series `θ(t) = Σ'_{n ∈ ℤ} exp(−π n² t)`, its summability and
positivity for `t > 0`, and the functional equation `θ(1/t) = √t · θ(t)`.

The functional equation is obtained from Mathlib's Poisson-summation theorem
`Real.tsum_exp_neg_mul_int_sq` (the Gaussian Fourier transform).  Nothing is
assumed; the Mellin representation of `Λ` and the derivation of `Λ(1−s) = Λ(s)`
are the next stages.
-/
import Mathlib

noncomputable section
open scoped BigOperators

namespace ZetaTheta

/-- The Jacobi theta series `θ(t) = Σ'_{n ∈ ℤ} exp(−π n² t)`. -/
noncomputable def theta (t : ℝ) : ℝ :=
  ∑' n : ℤ, Real.exp (-Real.pi * t * (n : ℝ) ^ 2)

/-- **T1. The theta series is summable for `t > 0`.** -/
theorem summable_theta {t : ℝ} (ht : 0 < t) :
    Summable (fun n : ℤ => Real.exp (-Real.pi * t * (n : ℝ) ^ 2)) := by
  rw [summable_int_iff_summable_nat_and_neg]
  have hgeo : Summable (fun n : ℕ => Real.exp (-Real.pi * t) ^ n) :=
    summable_geometric_of_lt_one (Real.exp_pos _).le (by
      rw [Real.exp_lt_one_iff]
      nlinarith [Real.pi_pos, ht])
  have hpt : (0 : ℝ) < Real.pi * t := mul_pos Real.pi_pos ht
  have hbound : ∀ n : ℕ,
      Real.exp (-Real.pi * t * (n : ℝ) ^ 2) ≤ Real.exp (-Real.pi * t) ^ n := by
    intro n
    rcases Nat.eq_zero_or_pos n with h | h
    · subst h
      simp
    · have hn : (n : ℝ) ≤ (n : ℝ) ^ 2 := by
        have : (1 : ℝ) ≤ (n : ℝ) := by exact_mod_cast h
        nlinarith
      have h2 : Real.pi * t * (n : ℝ) ≤ Real.pi * t * (n : ℝ) ^ 2 :=
        mul_le_mul_of_nonneg_left hn hpt.le
      have harg : -Real.pi * t * (n : ℝ) ^ 2 ≤ (n : ℝ) * (-Real.pi * t) := by
        nlinarith
      calc Real.exp (-Real.pi * t * (n : ℝ) ^ 2)
          ≤ Real.exp ((n : ℝ) * (-Real.pi * t)) := Real.exp_le_exp.mpr harg
        _ = Real.exp (-Real.pi * t) ^ n := Real.exp_nat_mul _ _
  constructor
  · exact Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) hbound hgeo
  · have hsum : Summable (fun n : ℕ => Real.exp (-Real.pi * t * (n : ℝ) ^ 2)) :=
      Summable.of_nonneg_of_le (fun n => (Real.exp_pos _).le) hbound hgeo
    have hsame : ∀ n : ℕ,
        (fun k : ℤ => Real.exp (-Real.pi * t * (k : ℝ) ^ 2)) (-↑n)
          = Real.exp (-Real.pi * t * (n : ℝ) ^ 2) := by
      intro n
      have hc : ((-↑n : ℤ) : ℝ) = -(n : ℝ) := by push_cast; ring
      simp only [hc]
      ring_nf
    exact hsum.congr (fun n => (hsame n).symm)

/-- **T2. Positivity of the theta series for `t > 0`.** -/
theorem theta_pos {t : ℝ} (ht : 0 < t) : 0 < theta t := by
  have h := summable_theta ht
  have hpos : 0 < (fun n : ℤ => Real.exp (-Real.pi * t * (n : ℝ) ^ 2)) 0 := by simp
  exact Summable.tsum_pos h (fun n => (Real.exp_pos _).le) 0 hpos

/-- **T3. The theta functional equation:** `θ(1/t) = √t · θ(t)` for `t > 0`. -/
theorem theta_one_div {t : ℝ} (ht : 0 < t) : theta (1 / t) = Real.sqrt t * theta t := by
  have h := Real.tsum_exp_neg_mul_int_sq ht
  rw [← Real.sqrt_eq_rpow] at h
  have hs : (0 : ℝ) < Real.sqrt t := Real.sqrt_pos.mpr ht
  have hne : Real.sqrt t ≠ 0 := ne_of_gt hs
  simp only [theta]
  rw [h]
  field_simp

end ZetaTheta

namespace ZetaTheta

/-- **V4. Splitting the theta series at `n = 0`:**
`θ(t) = 1 + 2 Σ_{n ≥ 1} exp(−π n² t)`. -/
theorem theta_eq_one_add_two_tsum {t : ℝ} (ht : 0 < t) :
    theta t = 1 + 2 * ∑' n : ℕ+, Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2) := by
  have hsum := summable_theta ht
  have hev : Function.Even (fun n : ℤ => Real.exp (-Real.pi * t * (n : ℝ) ^ 2)) := by
    intro n
    show Real.exp (-Real.pi * t * (((-n : ℤ)) : ℝ) ^ 2) = Real.exp (-Real.pi * t * (n : ℝ) ^ 2)
    have hcast : (((-n : ℤ)) : ℝ) = -(n : ℝ) := by push_cast; ring
    rw [hcast]
    ring_nf
  have h := tsum_int_eq_zero_add_two_mul_tsum_pnat hev hsum
  simp only [theta]
  rw [h]
  simp only [Int.cast_zero, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
    mul_zero, neg_zero, Real.exp_zero, nsmul_eq_mul]
  norm_num

/-- `ψ(t) = (θ(t) − 1)/2`, the theta kernel whose Mellin transform is `Λ(s)`. -/
noncomputable def psi (t : ℝ) : ℂ := ((theta t - 1) / 2 : ℝ)

/-- **V5. The theta kernel as a series over the positive integers.** -/
theorem psi_eq_tsum {t : ℝ} (ht : 0 < t) :
    psi t = ∑' n : ℕ+, (Real.exp (-Real.pi * t * (((n : ℕ) : ℝ)) ^ 2) : ℝ) := by
  rw [psi, theta_eq_one_add_two_tsum ht, Complex.ofReal_tsum]
  push_cast
  ring

end ZetaTheta
