import Mathlib

/-!
# The Bernoulli/zeta residue relation, algebraic core

The finite-part identity extended to `Re s > -n` needs

`p.coeff k = (-1)^k * ζ(-k) / k! = bernoulli (k+1) / (k+1)!`,

where `p` is the Taylor series of `1/(e^z-1) - 1/z` at `0`.

This file proves the formal power series half:

* `expm1DivX = (e^X - 1)/X = Σ X^n/(n+1)!`;
* `bernoulliPowerSeries * expm1DivX = 1`;
* `gSeries = (B - 1)/X` has coefficients `bernoulli (k+1)/(k+1)!`.

The analytic identification of `gSeries` with the Taylor series of the kernel is
the next file.
-/

open PowerSeries

noncomputable section

namespace AngularPartition

/-- The formal power series `(e^X - 1)/X = Σ X^n/(n+1)!`. -/
noncomputable def expm1DivX : PowerSeries ℂ :=
  PowerSeries.mk fun n => (1 : ℂ) / (Nat.factorial (n + 1) : ℂ)

/-- `X * (e^X - 1)/X = e^X - 1`. -/
theorem X_mul_expm1DivX : (PowerSeries.X : PowerSeries ℂ) * expm1DivX =
    PowerSeries.exp ℂ - 1 := by
  ext n
  cases n with
  | zero =>
      simp [expm1DivX, PowerSeries.coeff_zero_X_mul, PowerSeries.coeff_exp]
  | succ n =>
      rw [PowerSeries.coeff_succ_X_mul]
      simp [expm1DivX, PowerSeries.coeff_exp, Nat.factorial_succ, div_eq_mul_inv,
        mul_comm, mul_left_comm, mul_assoc]

/-- **Bernoulli reciprocal identity.** `B(X) * (e^X - 1)/X = 1`. -/
theorem bernoulliPowerSeries_mul_expm1DivX :
    bernoulliPowerSeries ℂ * expm1DivX = 1 := by
  have h := bernoulliPowerSeries_mul_exp_sub_one (A := ℂ)
  rw [← X_mul_expm1DivX, ← mul_assoc] at h
  have h' : (bernoulliPowerSeries ℂ * expm1DivX) * PowerSeries.X =
      (1 : PowerSeries ℂ) * PowerSeries.X := by
    simpa [mul_assoc, mul_comm, mul_left_comm] using h
  exact PowerSeries.mul_X_cancel h'

/-- The formal series `(B(X) - 1)/X`. -/
noncomputable def gSeries : PowerSeries ℂ :=
  PowerSeries.mk fun k => (bernoulliPowerSeries ℂ).coeff (k + 1)

/-- `X * gSeries = B(X) - 1`. -/
theorem X_mul_gSeries :
    (PowerSeries.X : PowerSeries ℂ) * gSeries = bernoulliPowerSeries ℂ - 1 := by
  ext n
  cases n with
  | zero =>
      simp [gSeries, bernoulliPowerSeries, PowerSeries.coeff_zero_X_mul, PowerSeries.coeff_mk]
  | succ n =>
      rw [PowerSeries.coeff_succ_X_mul]
      simp [gSeries]

/-- **Coefficient form.** The `k`-th coefficient of `(B - 1)/X` is
`bernoulli (k+1)/(k+1)!`. -/
theorem gSeries_coeff (k : ℕ) :
    gSeries.coeff k = (bernoulli (k + 1) : ℂ) / (Nat.factorial (k + 1) : ℂ) := by
  simp [gSeries, bernoulliPowerSeries, PowerSeries.coeff_mk]


/-- **Formal counterpart of the kernel identity.**
`X·(e^X−1)·(B−1)/X = X − (e^X−1)`. -/
theorem X_mul_exp_sub_one_mul_gSeries :
    (PowerSeries.X : PowerSeries ℂ) * (PowerSeries.exp ℂ - 1) * gSeries =
      PowerSeries.X - (PowerSeries.exp ℂ - 1) := by
  have hB := bernoulliPowerSeries_mul_exp_sub_one (A := ℂ)
  have hg := X_mul_gSeries
  calc
    PowerSeries.X * (PowerSeries.exp ℂ - 1) * gSeries
        = (PowerSeries.exp ℂ - 1) *
            (PowerSeries.X * gSeries) := by ring
    _ = (PowerSeries.exp ℂ - 1) * (bernoulliPowerSeries ℂ - 1) := by rw [hg]
    _ = (PowerSeries.exp ℂ - 1) * bernoulliPowerSeries ℂ -
          (PowerSeries.exp ℂ - 1) := by ring
    _ = PowerSeries.X - (PowerSeries.exp ℂ - 1) := by
          rw [mul_comm (PowerSeries.exp ℂ - 1), hB]


/-- **Cauchy product of two absolutely summable scalar series.** If `a` and `b`
have absolutely summable norms and sums `A`, `B`, then the range convolution has
sum `A * B`. This is the `HasSum` form of Mathlib's Cauchy product theorem, the
brick needed for the power-series product comparison. -/
theorem hasSum_mul_range {a b : ℕ → ℂ} {A B : ℂ}
    (ha : HasSum a A) (hb : HasSum b B)
    (ha' : Summable fun n => ‖a n‖) (hb' : Summable fun n => ‖b n‖) :
    HasSum (fun n => ∑ k ∈ Finset.range (n + 1), a k * b (n - k)) (A * B) := by
  have hsum : Summable fun n => ∑ k ∈ Finset.range (n + 1), a k * b (n - k) :=
    (summable_norm_sum_mul_range_of_summable_norm ha' hb').of_norm
  have htsum := tsum_mul_tsum_eq_tsum_sum_range_of_summable_norm ha' hb'
  rw [ha.tsum_eq, hb.tsum_eq] at htsum
  rw [htsum]
  exact hsum.hasSum


/-- **Product of scalar power series.** If `f` and `g` have scalar power series
`a` and `b` at `0`, then their product has the Cauchy-product series. This is the
`HasFPowerSeriesAt.mul` that Mathlib does not currently provide. -/
theorem hasFPowerSeriesAt_mul_ofScalars {f g : ℂ → ℂ} {a b : ℕ → ℂ}
    (ha : HasFPowerSeriesAt f (FormalMultilinearSeries.ofScalars ℂ a) 0)
    (hb : HasFPowerSeriesAt g (FormalMultilinearSeries.ofScalars ℂ b) 0) :
    HasFPowerSeriesAt (fun z => f z * g z)
      (FormalMultilinearSeries.ofScalars ℂ
        (fun n => ∑ k ∈ Finset.range (n + 1), a k * b (n - k))) 0 := by
  rw [hasFPowerSeriesAt_iff]
  obtain ⟨ra, hra⟩ := ha
  obtain ⟨rb, hrb⟩ := hb
  have hpos : 0 < min ra rb := lt_min hra.r_pos hrb.r_pos
  filter_upwards [Metric.eball_mem_nhds 0 hpos] with z hz
  have hza : z ∈ Metric.eball (0 : ℂ) ra :=
    Metric.eball_subset_eball (min_le_left _ _) hz
  have hzb : z ∈ Metric.eball (0 : ℂ) rb :=
    Metric.eball_subset_eball (min_le_right _ _) hz
  have hza' : ‖z‖ₑ < ra := by simpa [Metric.mem_eball] using hza
  have hzb' : ‖z‖ₑ < rb := by simpa [Metric.mem_eball] using hzb
  have hsum_a : HasSum (fun n => a n * z ^ n) (f z) := by
    have h := hra.hasSum hza
    simpa [FormalMultilinearSeries.ofScalars_apply_eq', smul_eq_mul, mul_comm] using h
  have hsum_b : HasSum (fun n => b n * z ^ n) (g z) := by
    have h := hrb.hasSum hzb
    simpa [FormalMultilinearSeries.ofScalars_apply_eq', smul_eq_mul, mul_comm] using h
  have hra_le : ra ≤ (FormalMultilinearSeries.ofScalars ℂ a).radius := hra.r_le
  have hrb_le : rb ≤ (FormalMultilinearSeries.ofScalars ℂ b).radius := hrb.r_le
  have hsum_abs_a : Summable fun n => ‖a n * z ^ n‖ := by
    have h := (FormalMultilinearSeries.ofScalars ℂ a).summable_norm_apply
      (Metric.eball_subset_eball hra_le hza)
    simpa [FormalMultilinearSeries.ofScalars_apply_eq', smul_eq_mul, norm_mul, norm_pow,
      mul_comm] using h
  have hsum_abs_b : Summable fun n => ‖b n * z ^ n‖ := by
    have h := (FormalMultilinearSeries.ofScalars ℂ b).summable_norm_apply
      (Metric.eball_subset_eball hrb_le hzb)
    simpa [FormalMultilinearSeries.ofScalars_apply_eq', smul_eq_mul, norm_mul, norm_pow,
      mul_comm] using h
  have hprod := hasSum_mul_range hsum_a hsum_b hsum_abs_a hsum_abs_b
  have hfun : (fun n => z ^ n • (FormalMultilinearSeries.ofScalars ℂ
        (fun n => ∑ k ∈ Finset.range (n + 1), a k * b (n - k))).coeff n)
      = fun n => ∑ k ∈ Finset.range (n + 1),
          a k * z ^ k * (b (n - k) * z ^ (n - k)) := by
    funext n
    rw [FormalMultilinearSeries.coeff_ofScalars, smul_eq_mul, Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro k hk
    have hk' : k ≤ n := by
      have := Finset.mem_range.mp hk
      omega
    have hzk : z ^ n = z ^ k * z ^ (n - k) := by
      rw [← pow_add, Nat.add_comm k (n - k), Nat.sub_add_cancel hk']
    rw [hzk]
    ring
  rw [hfun]
  simpa using hprod

end AngularPartition
