import Mathlib
import PrimeEnclosure7
import ExpSevenFifths

/-!
# The prime term at `c = 7/5`

`primeTerm (7/5) (1/20) = −2 Σ_n Λ(n)/√n · (√π/20) e^{−100(log n − 7/5)²}`.
Three terms matter: `n = 4` (weight `(log 2)/2`, exponent `E₄ ≈ 0.0188`), `n = 5`
(`log 5/√5`, `E₅ ≈ 4.3864`) and `n = 3` (`log 3/√3`, `E₃ ≈ 9.0836`); `n = 2` is
about `2·10⁻²²` and the tail from `n = 7` is below `10⁻¹⁰`, by the domination
`e^{−100(x−7/5)²} ≤ e^{−3x−22}` on `x ≥ log 7`.

This is the last input of the `8 × 8` closure ([`Closure8.lean`](Closure8.lean)).
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- `√5` in a rational interval. -/
theorem sqrt_five_mem : (2236067 / 1000000 : ℝ) ≤ Real.sqrt 5 ∧ Real.sqrt 5 ≤ 2236068 / 1000000 := by
  have h2 : Real.sqrt 5 ^ 2 = 5 := Real.sq_sqrt (by norm_num)
  have hnn : (0 : ℝ) ≤ Real.sqrt 5 := Real.sqrt_nonneg 5
  constructor <;> nlinarith [h2, hnn]

/-- `Λ(5) = log 5`. -/
theorem vonMangoldt_five : ArithmeticFunction.vonMangoldt 5 = Real.log 5 :=
  ArithmeticFunction.vonMangoldt_apply_prime (by norm_num)

/-! ## The tail from `n ≥ 7` -/

/-- On `x ≥ log 7`, `100(x − 7/5)² ≥ 3x + 22`. -/
theorem seven_fifths_domination {x : ℝ} (hx : Real.log 7 ≤ x) :
    -100 * (x - 7 / 5) ^ 2 ≤ -3 * x - 22 := by
  have h7 : (193 / 100 : ℝ) ≤ x := by
    have hlog7 : (193 / 100 : ℝ) ≤ Real.log 7 := by
      have h2 := log_two_mem.1
      have h3 := log_three_mem.1
      have hmul : Real.log 7 = Real.log 2 + Real.log 3 + Real.log (7 / 6) := by
        rw [← Real.log_mul (by norm_num) (by norm_num), ← Real.log_mul (by norm_num) (by norm_num)]
        norm_num
      have h76 : Real.log (7 / 6 : ℝ) = -Real.log (6 / 7) := by
        rw [show (7 / 6 : ℝ) = (6 / 7)⁻¹ by norm_num, Real.log_inv]
      have h67 : Real.log (6 / 7 : ℝ) ≤ 6 / 7 - 1 := Real.log_le_sub_one_of_pos (by norm_num)
      have h76' : (1 / 7 : ℝ) ≤ Real.log (7 / 6) := by rw [h76]; linarith
      linarith
    linarith
  have hfac : 100 * x ^ 2 - 283 * x + 174
      = 100 * (x - 193 / 100) * (x + 193 / 100)
        - 283 * (x - 193 / 100)
        + (100 * (193 / 100) ^ 2 - 283 * (193 / 100) + 174) := by ring
  have hpoly : 0 ≤ 100 * x ^ 2 - 283 * x + 174 := by
    rw [hfac]
    have h1 : (0 : ℝ) ≤ x - 193 / 100 := by linarith
    have h2 : (0 : ℝ) ≤ 100 * (x + 193 / 100) - 283 := by nlinarith
    have h3 : (0 : ℝ) ≤ 100 * (193 / 100) ^ 2 - 283 * (193 / 100) + 174 := by
      norm_num
    nlinarith [mul_nonneg h1 h2]
  nlinarith

/-- Termwise bound on the `n ≥ 7` tail at `c = 7/5`. -/
theorem seven_fifths_term_le (n : ℕ) :
    primeSummand (7 / 5) (n + 7) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * (((n : ℝ) + 7) ^ 2)⁻¹ := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hcast : Real.sqrt (↑(n + 7) : ℝ) = Real.sqrt ((n : ℝ) + 7) := by
    push_cast; ring_nf
  rw [hcast]
  push_cast
  have hm : (0 : ℝ) < (n : ℝ) + 7 := by positivity
  have hlogn : Real.log 7 ≤ Real.log ((n : ℝ) + 7) :=
    Real.log_le_log (by norm_num) (by linarith)
  have hdec : Real.exp (-100 * (Real.log ((n : ℝ) + 7) - 7 / 5) ^ 2) ≤
      (((n : ℝ) + 7) ^ 3)⁻¹ * (1 / 1000000000) := by
    have hdom := seven_fifths_domination hlogn
    have hsplit : (-3 * Real.log ((n : ℝ) + 7) - 22 : ℝ) =
        (-3 * Real.log ((n : ℝ) + 7)) + (-22) := by ring
    have h3 : Real.exp (-3 * Real.log ((n : ℝ) + 7)) = (((n : ℝ) + 7) ^ 3)⁻¹ := by
      rw [show -3 * Real.log ((n : ℝ) + 7) = -(3 * Real.log ((n : ℝ) + 7)) by ring,
        Real.exp_neg, show (3 : ℝ) = ((3 : ℕ) : ℝ) by norm_num, Real.exp_nat_mul,
        Real.exp_log hm]
    have he22 : Real.exp (-22 : ℝ) ≤ 1 / 1000000000 := by
      have h22 : (1000000000 : ℝ) ≤ Real.exp 1 ^ 22 := by
        have h1 : (1000000000 : ℝ) ≤ (27182818283 / 10000000000) ^ 22 := by norm_num
        have h2 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
          have h := Real.exp_one_gt_d9; linarith
        have h3' : (0 : ℝ) ≤ 27182818283 / 10000000000 := by norm_num
        exact le_trans h1 (pow_le_pow_left₀ h3' h2 22)
      have h144 : (1000000000 : ℝ) ≤ Real.exp (22 : ℝ) := by
        have heq : Real.exp (22 : ℝ) = Real.exp 1 ^ 22 * Real.exp 0 := by
          rw [← Real.exp_nat_mul (x := (1 : ℝ)) (n := 22), ← Real.exp_add]; norm_num
        rw [heq, Real.exp_zero, mul_one]
        exact h22
      rw [Real.exp_neg, ← one_div]
      exact one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 1000000000) h144
    calc Real.exp (-100 * (Real.log ((n : ℝ) + 7) - 7 / 5) ^ 2)
        ≤ Real.exp (-3 * Real.log ((n : ℝ) + 7) - 22) := Real.exp_le_exp.mpr hdom
      _ = Real.exp (-3 * Real.log ((n : ℝ) + 7)) * Real.exp (-22) := by
          rw [hsplit, Real.exp_add]
      _ ≤ (((n : ℝ) + 7) ^ 3)⁻¹ * (1 / 1000000000) := by
          rw [h3]
          exact mul_le_mul_of_nonneg_left he22 (by positivity)
  have hvm : ArithmeticFunction.vonMangoldt (n + 7) / Real.sqrt ((n : ℝ) + 7) ≤ (n : ℝ) + 7 := by
    have hle : ArithmeticFunction.vonMangoldt (n + 7) ≤ (n : ℝ) + 7 := by
      have hlt := ArithmeticFunction.vonMangoldt_le_log (n := n + 7)
      have hlogeq : Real.log ((n : ℝ) + 7) = Real.log (↑(n + 7) : ℝ) := by push_cast; ring_nf
      rw [← hlogeq] at hlt
      have hl := Real.log_le_sub_one_of_pos hm
      linarith
    have hge1 : (1 : ℝ) ≤ Real.sqrt ((n : ℝ) + 7) := by
      have h : Real.sqrt 1 ≤ Real.sqrt ((n : ℝ) + 7) :=
        Real.sqrt_le_sqrt (by linarith [Nat.cast_nonneg (α := ℝ) n])
      simpa using h
    have hinv1 : (Real.sqrt ((n : ℝ) + 7))⁻¹ ≤ 1 := by
      rw [← one_div, div_le_one (by positivity)]
      exact hge1
    calc ArithmeticFunction.vonMangoldt (n + 7) / Real.sqrt ((n : ℝ) + 7)
        = ArithmeticFunction.vonMangoldt (n + 7) * (Real.sqrt ((n : ℝ) + 7))⁻¹ := by ring
      _ ≤ ((n : ℝ) + 7) * (Real.sqrt ((n : ℝ) + 7))⁻¹ :=
          mul_le_mul_of_nonneg_right hle (by positivity)
      _ ≤ ((n : ℝ) + 7) * 1 := mul_le_mul_of_nonneg_left hinv1 (by linarith)
      _ = (n : ℝ) + 7 := by ring
  have hpi : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 := div_nonneg (Real.sqrt_nonneg _) (by norm_num)
  have hbump : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 7) - 7 / 5) ^ 2) ≤
      Real.sqrt Real.pi / 20 * ((((n : ℝ) + 7) ^ 3)⁻¹ * (1 / 1000000000)) :=
    mul_le_mul_of_nonneg_left hdec hpi
  have hmain : ArithmeticFunction.vonMangoldt (n + 7) / Real.sqrt ((n : ℝ) + 7) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 7) - 7 / 5) ^ 2))
      ≤ ((n : ℝ) + 7) *
          (Real.sqrt Real.pi / 20 * ((((n : ℝ) + 7) ^ 3)⁻¹ * (1 / 1000000000))) :=
    mul_le_mul hvm hbump (mul_nonneg hpi (by positivity)) (by linarith)
  calc ArithmeticFunction.vonMangoldt (n + 7) / Real.sqrt ((n : ℝ) + 7) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 7) - 7 / 5) ^ 2))
      ≤ ((n : ℝ) + 7) *
          (Real.sqrt Real.pi / 20 * ((((n : ℝ) + 7) ^ 3)⁻¹ * (1 / 1000000000))) := hmain
    _ = Real.sqrt Real.pi / 20 * (1 / 1000000000) * (((n : ℝ) + 7) ^ 2)⁻¹ := by
        field_simp

/-- The `n ≥ 7` tail at `c = 7/5`. -/
theorem seven_fifths_tail_le :
    ∑' n : ℕ, primeSummand (7 / 5) (n + 7) ≤ 1 / 10000000 := by
  have hC : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 * (1 / 1000000000) := by positivity
  have hmaj : ∀ N : ℕ, ∑ n ∈ Finset.range N, primeSummand (7 / 5) (n + 7) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * 1 := by
    intro N
    refine le_trans (Finset.sum_le_sum fun n _ => seven_fifths_term_le n) ?_
    rw [← Finset.mul_sum]
    refine mul_le_mul_of_nonneg_left ?_ hC
    refine le_trans (Finset.sum_le_sum fun n _ => ?_) (sum_inv_sq_le N)
    rw [show (((n : ℝ) + 7) ^ 2)⁻¹ = 1 / ((n : ℝ) + 7) ^ 2 by rw [one_div],
      show (((n : ℝ) + 2) ^ 2)⁻¹ = 1 / ((n : ℝ) + 2) ^ 2 by rw [one_div]]
    exact one_div_le_one_div_of_le (by positivity)
      (by nlinarith [Nat.cast_nonneg (α := ℝ) n])
  have hbound : ∑' n : ℕ, primeSummand (7 / 5) (n + 7) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * 1 :=
    Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg _ _) hmaj
  have hpi := sqrt_pi_div_twenty_le
  nlinarith [hbound, hpi]


/-! ## The three prefix terms -/

/-- `−100(log 4 − 7/5)² ∈ [−0.01878445678096, −0.01878440195844]`. -/
theorem seven_fifths_exponent_four :
    -100 * (Real.log 4 - 7 / 5) ^ 2 ∈
      Set.Icc (-(117402854881 / 6250000000000) : ℝ)
        (-(469610048961 / 25000000000000)) := by
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    ring
  rw [h4]
  have hl : (1370562 / 100000000 : ℝ) ≤ -(2 * Real.log 2 - 7 / 5) := by
    linarith [log_two_mem.2]
  have hu : -(2 * Real.log 2 - 7 / 5) ≤ 1370564 / 100000000 := by
    linarith [log_two_mem.1]
  have hy0 : (0 : ℝ) ≤ -(2 * Real.log 2 - 7 / 5) := by linarith
  have hclo : (1878440195844 / 10000000000000000 : ℝ) ≤ (-(2 * Real.log 2 - 7 / 5)) ^ 2 := by
    have h := pow_le_pow_left₀ (show (0 : ℝ) ≤ 1370562 / 100000000 by norm_num) hl 2
    have he : (1878440195844 / 10000000000000000 : ℝ) = (1370562 / 100000000 : ℝ) ^ 2 := by
      norm_num
    rw [he]
    exact h
  have hchi : (-(2 * Real.log 2 - 7 / 5)) ^ 2 ≤ (1878445678096 / 10000000000000000 : ℝ) := by
    have h := pow_le_pow_left₀ hy0 hu 2
    have he : (1370564 / 100000000 : ℝ) ^ 2 = (1878445678096 / 10000000000000000 : ℝ) := by
      norm_num
    rw [he] at h
    exact h
  have hsq : (2 * Real.log 2 - 7 / 5) ^ 2 = (-(2 * Real.log 2 - 7 / 5)) ^ 2 := by ring
  rw [hsq]
  constructor
  · have hle : (100 : ℝ) * ((-(2 * Real.log 2 - 7 / 5)) ^ 2) ≤
        100 * (1878445678096 / 10000000000000000) :=
      mul_le_mul_of_nonneg_left hchi (by norm_num)
    have hnum : (100 : ℝ) * (1878445678096 / 10000000000000000) ≤
        117402854881 / 6250000000000 := by norm_num
    linarith
  · have hge : (100 : ℝ) * (1878440195844 / 10000000000000000) ≤
        100 * ((-(2 * Real.log 2 - 7 / 5)) ^ 2) :=
      mul_le_mul_of_nonneg_left hclo (by norm_num)
    have hnum : (469610048961 / 25000000000000 : ℝ) ≤
        100 * (1878440195844 / 10000000000000000) := by norm_num
    linarith

/-- `−100(log 3 − 7/5)² ∈ [−9.08359321, −9.08299044]`. -/
theorem seven_fifths_exponent_three :
    -100 * (Real.log 3 - 7 / 5) ^ 2 ∈
      Set.Icc (-(908359321 / 100000000) : ℝ) (-(227074761 / 25000000)) := by
  constructor <;> nlinarith [log_three_mem.1, log_three_mem.2]

/-- `−100(log 5 − 7/5)² ∈ [−4.3864275844, −4.386423395641]`. -/
theorem seven_fifths_exponent_five :
    -100 * (Real.log 5 - 7 / 5) ^ 2 ∈
      Set.Icc (-(10966068961 / 2500000000) : ℝ) (-(4386423395641 / 1000000000000)) := by
  constructor <;> nlinarith [Real.log_five_gt_d9, Real.log_five_lt_d9]

/-- `primeSummand (7/5) 4 ∈ [0.030141, 0.030144]`. -/
theorem primeSummand_four_7_5 :
    primeSummand (7 / 5) 4 ∈ Set.Icc (30141 / 1000000 : ℝ) (30144 / 1000000) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_four]
  push_cast
  have hlog := log_two_mem
  have hspi := sqrt_pi_mem
  have hspl : (17724 / 200000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by linarith [hspi.1]
  have hspu : Real.sqrt Real.pi / 20 ≤ 17725 / 200000 := by linarith [hspi.2]
  have he := seven_fifths_exponent_four
  have helo : (981390855872871 / 1000000000000000 : ℝ) ≤
      Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2) :=
    le_trans exp_c75E4lo_mem.1 (Real.exp_le_exp.mpr he.1)
  have hehi : Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2) ≤
      (981390941126229 / 1000000000000000 : ℝ) :=
    le_trans (Real.exp_le_exp.mpr he.2) exp_c75E4hi_mem.2
  have hsqrt4 : Real.sqrt (4 : ℝ) = 2 := by
    rw [show (4 : ℝ) = (2 : ℝ) ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
  rw [hsqrt4]
  have hqlo : (3465735 / 10000000 : ℝ) ≤ Real.log 2 / 2 := by
    have h1 : (0 : ℝ) ≤ 1 / 2 := by norm_num
    have h2 : (69314718 / 100000000 : ℝ) * (1 / 2) ≤ Real.log 2 * (1 / 2) :=
      mul_le_mul_of_nonneg_right hlog.1 h1
    have h3 : (3465735 / 10000000 : ℝ) ≤ (69314718 / 100000000) * (1 / 2) := by norm_num
    rw [div_eq_mul_one_div (Real.log 2) 2]
    linarith
  have hqhi : Real.log 2 / 2 ≤ (3465740 / 10000000 : ℝ) := by
    rw [div_eq_mul_one_div (Real.log 2) 2]
    have h1 : (0 : ℝ) ≤ 1 / 2 := by norm_num
    have h2 : Real.log 2 * (1 / 2) ≤ (69314719 / 100000000 : ℝ) * (1 / 2) :=
      mul_le_mul_of_nonneg_right hlog.2 h1
    have h3 : (69314719 / 100000000 : ℝ) * (1 / 2) ≤ 3465740 / 10000000 := by norm_num
    linarith
  have hqpos : (0 : ℝ) ≤ Real.log 2 / 2 := by positivity
  have hblo : (86970 / 1000000 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2) := by
    refine le_trans ?_ (mul_le_mul hspl helo (by norm_num) (by positivity))
    norm_num
  have hbhi : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2) ≤
      (86976 / 1000000 : ℝ) := by
    refine le_trans (mul_le_mul hspu hehi (by positivity) (by norm_num)) ?_
    norm_num
  have hbpos : (0 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2) := by positivity
  constructor
  · have h1 : (3465735 / 10000000 : ℝ) * (86970 / 1000000) ≤
        (Real.log 2 / 2) * (86970 / 1000000) :=
      mul_le_mul_of_nonneg_right hqlo (by norm_num)
    have h2 : (Real.log 2 / 2 : ℝ) * (86970 / 1000000) ≤
        (Real.log 2 / 2) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_left hblo hqpos
    calc (30141 / 1000000 : ℝ) ≤ (3465735 / 10000000) * (86970 / 1000000) := by norm_num
      _ ≤ (Real.log 2 / 2) * (86970 / 1000000) := h1
      _ ≤ (Real.log 2 / 2) *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2)) := h2
  · have h1 : (Real.log 2 / 2 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2)) ≤
        (3465740 / 10000000) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_right hqhi hbpos
    have h2 : (3465740 / 10000000 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2)) ≤
        (3465740 / 10000000) * (86976 / 1000000) :=
      mul_le_mul_of_nonneg_left hbhi (by norm_num)
    calc (Real.log 2 / 2) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 7 / 5) ^ 2))
        ≤ (3465740 / 10000000) * (86976 / 1000000) := le_trans h1 h2
      _ ≤ (30144 / 1000000 : ℝ) := by norm_num

/-- `primeSummand (7/5) 3 ∈ [0.0000063, 0.0000064]`. -/
theorem primeSummand_three_7_5 :
    primeSummand (7 / 5) 3 ∈ Set.Icc (63 / 10000000 : ℝ) (64 / 10000000) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_three]
  push_cast
  have hlog := log_three_mem
  have hspi := sqrt_pi_mem
  have hspl : (17724 / 200000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by linarith [hspi.1]
  have hspu : Real.sqrt Real.pi / 20 ≤ 17725 / 200000 := by linarith [hspi.2]
  have he := seven_fifths_exponent_three
  have helo : (56756497271 / 500000000000000 : ℝ) ≤
      Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2) :=
    le_trans exp_c75E3lo_mem.1 (Real.exp_le_exp.mpr he.1)
  have hehi : Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2) ≤
      (113581443811 / 1000000000000000 : ℝ) :=
    le_trans (Real.exp_le_exp.mpr he.2) exp_c75E3hi_mem.2
  have hinvlo : (100000 / 173206 : ℝ) ≤ 1 / Real.sqrt 3 := by
    rw [div_le_div_iff₀ (by norm_num) (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3))]
    nlinarith [sqrt_three_mem.2]
  have hinvhi : 1 / Real.sqrt 3 ≤ 100000 / 173205 := by
    rw [div_le_div_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3)) (by norm_num)]
    nlinarith [sqrt_three_mem.1]
  have hqlo : (634275 / 1000000 : ℝ) ≤ Real.log 3 / Real.sqrt 3 := by
    rw [le_div_iff₀ (by positivity : (0 : ℝ) < Real.sqrt 3)]
    nlinarith [hlog.1, sqrt_three_mem.2, Real.sqrt_nonneg 3]
  have hqhi : Real.log 3 / Real.sqrt 3 ≤ (634290 / 1000000 : ℝ) := by
    rw [div_le_iff₀ (by positivity : (0 : ℝ) < Real.sqrt 3)]
    nlinarith [hlog.2, sqrt_three_mem.1, Real.sqrt_nonneg 3]
  have hqpos : (0 : ℝ) ≤ Real.log 3 / Real.sqrt 3 := by positivity
  have hblo : (1005 / 100000000 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2) := by
    refine le_trans ?_ (mul_le_mul hspl helo (by norm_num) (by positivity))
    norm_num
  have hbhi : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2) ≤
      (1007 / 100000000 : ℝ) := by
    refine le_trans (mul_le_mul hspu hehi (by positivity) (by norm_num)) ?_
    norm_num
  have hbpos : (0 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2) := by positivity
  constructor
  · have h1 : (634275 / 1000000 : ℝ) * (1005 / 100000000) ≤
        (Real.log 3 / Real.sqrt 3) * (1005 / 100000000) :=
      mul_le_mul_of_nonneg_right hqlo (by norm_num)
    have h2 : (Real.log 3 / Real.sqrt 3 : ℝ) * (1005 / 100000000) ≤
        (Real.log 3 / Real.sqrt 3) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_left hblo hqpos
    calc (63 / 10000000 : ℝ) ≤ (634275 / 1000000) * (1005 / 100000000) := by norm_num
      _ ≤ (Real.log 3 / Real.sqrt 3) * (1005 / 100000000) := h1
      _ ≤ (Real.log 3 / Real.sqrt 3) *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2)) := h2
  · have h1 : (Real.log 3 / Real.sqrt 3 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2)) ≤
        (634290 / 1000000) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_right hqhi hbpos
    have h2 : (634290 / 1000000 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2)) ≤
        (634290 / 1000000) * (1007 / 100000000) :=
      mul_le_mul_of_nonneg_left hbhi (by norm_num)
    calc (Real.log 3 / Real.sqrt 3) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 7 / 5) ^ 2))
        ≤ (634290 / 1000000) * (1007 / 100000000) := le_trans h1 h2
      _ ≤ (64 / 10000000 : ℝ) := by norm_num

/-- `primeSummand (7/5) 5 ∈ [0.0007935, 0.0007945]`. -/
theorem primeSummand_five_7_5 :
    primeSummand (7 / 5) 5 ∈ Set.Icc (7935 / 10000000 : ℝ) (7945 / 10000000) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_five]
  push_cast
  have hlog : Real.log 5 ∈ Set.Icc (16094379123 / 10000000000 : ℝ) (16094379126 / 10000000000) := by
    constructor
    · have h := Real.log_five_gt_d9
      norm_num at h ⊢
      linarith
    · have h := Real.log_five_lt_d9
      norm_num at h ⊢
      linarith
  have hspi := sqrt_pi_mem
  have hspl : (17724 / 200000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by linarith [hspi.1]
  have hspu : Real.sqrt Real.pi / 20 ≤ 17725 / 200000 := by linarith [hspi.2]
  have he := seven_fifths_exponent_five
  have helo : (6222554370657 / 500000000000000 : ℝ) ≤
      Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2) :=
    le_trans exp_c75E5lo_mem.1 (Real.exp_le_exp.mpr he.1)
  have hehi : Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2) ≤
      (12445161394891 / 1000000000000000 : ℝ) :=
    le_trans (Real.exp_le_exp.mpr he.2) exp_c75E5hi_mem.2
  have hsqrt5 : (2236067 / 1000000 : ℝ) ≤ Real.sqrt 5 ∧ Real.sqrt 5 ≤ 2236068 / 1000000 :=
    sqrt_five_mem
  have hqlo : (719762 / 1000000 : ℝ) ≤ Real.log 5 / Real.sqrt 5 := by
    rw [le_div_iff₀ (by positivity : (0 : ℝ) < Real.sqrt 5)]
    nlinarith [hlog.1, hsqrt5.2, Real.sqrt_nonneg 5]
  have hqhi : Real.log 5 / Real.sqrt 5 ≤ (719763 / 1000000 : ℝ) := by
    rw [div_le_iff₀ (by positivity : (0 : ℝ) < Real.sqrt 5)]
    nlinarith [hlog.2, hsqrt5.1, Real.sqrt_nonneg 5]
  have hqpos : (0 : ℝ) ≤ Real.log 5 / Real.sqrt 5 := by positivity
  have hblo : (11028 / 10000000 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2) := by
    refine le_trans ?_ (mul_le_mul hspl helo (by norm_num) (by positivity))
    norm_num
  have hbhi : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2) ≤
      (11030 / 10000000 : ℝ) := by
    refine le_trans (mul_le_mul hspu hehi (by positivity) (by norm_num)) ?_
    norm_num
  have hbpos : (0 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2) := by positivity
  constructor
  · have h1 : (719762 / 1000000 : ℝ) * (11028 / 10000000) ≤
        (Real.log 5 / Real.sqrt 5) * (11028 / 10000000) :=
      mul_le_mul_of_nonneg_right hqlo (by norm_num)
    have h2 : (Real.log 5 / Real.sqrt 5 : ℝ) * (11028 / 10000000) ≤
        (Real.log 5 / Real.sqrt 5) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_left hblo hqpos
    calc (7935 / 10000000 : ℝ) ≤ (719762 / 1000000) * (11028 / 10000000) := by norm_num
      _ ≤ (Real.log 5 / Real.sqrt 5) * (11028 / 10000000) := h1
      _ ≤ (Real.log 5 / Real.sqrt 5) *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2)) := h2
  · have h1 : (Real.log 5 / Real.sqrt 5 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2)) ≤
        (719763 / 1000000) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_right hqhi hbpos
    have h2 : (719763 / 1000000 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2)) ≤
        (719763 / 1000000) * (11030 / 10000000) :=
      mul_le_mul_of_nonneg_left hbhi (by norm_num)
    calc (Real.log 5 / Real.sqrt 5) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 5 - 7 / 5) ^ 2))
        ≤ (719763 / 1000000) * (11030 / 10000000) := le_trans h1 h2
      _ ≤ (7945 / 10000000 : ℝ) := by norm_num



/-- The `n = 6` term at `c = 7/5` vanishes (`Λ 6 = 0`); we only need a small bound. -/
theorem primeSummand_six_7_5 : primeSummand (7 / 5) 6 ≤ 1 / 100000 := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hm : (0 : ℝ) < 6 := by norm_num
  have hlog6 : (179 / 100 : ℝ) ≤ Real.log 6 := by
    rw [show (6 : ℝ) = 2 * 3 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    linarith [log_two_mem.1, log_three_mem.1]
  have hy : (39 / 100 : ℝ) ≤ Real.log 6 - 7 / 5 := by linarith
  have harg : -100 * (Real.log 6 - 7 / 5) ^ 2 ≤ -15 := by nlinarith [hy]
  have hdec : Real.exp (-100 * (Real.log 6 - 7 / 5) ^ 2) ≤ Real.exp (-15) :=
    Real.exp_le_exp.mpr harg
  have hexp15 : Real.exp (-15 : ℝ) ≤ 1 / 1000000 := by
    have h15 : (1000000 : ℝ) ≤ Real.exp 1 ^ 15 := by
      have h1 : (1000000 : ℝ) ≤ (27182818283 / 10000000000) ^ 15 := by norm_num
      have h2 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
        have h := Real.exp_one_gt_d9
        linarith
      have h3 : (0 : ℝ) ≤ 27182818283 / 10000000000 := by norm_num
      exact le_trans h1 (pow_le_pow_left₀ h3 h2 15)
    have h15e : (1000000 : ℝ) ≤ Real.exp (15 : ℝ) := by
      have heq : Real.exp (15 : ℝ) = Real.exp 1 ^ 15 * Real.exp 0 := by
        rw [← Real.exp_nat_mul (x := (1 : ℝ)) (n := 15), ← Real.exp_add]; norm_num
      rw [heq, Real.exp_zero, mul_one]
      exact h15
    rw [Real.exp_neg, ← one_div]
    exact one_div_le_one_div_of_le (by norm_num) h15e
  have hvm : ArithmeticFunction.vonMangoldt 6 / Real.sqrt 6 ≤ 6 := by
    have hle : ArithmeticFunction.vonMangoldt 6 ≤ 6 := by
      have hlt := ArithmeticFunction.vonMangoldt_le_log (n := 6)
      have h2 : Real.log ((6 : ℕ) : ℝ) ≤ 6 := by
        have h6 : ((6 : ℕ) : ℝ) = 6 := by norm_num
        rw [h6]
        have := Real.log_le_sub_one_of_pos (show (0 : ℝ) < 6 by norm_num)
        linarith
      linarith
    have hge1 : (1 : ℝ) ≤ Real.sqrt 6 := by
      have h : Real.sqrt 1 ≤ Real.sqrt 6 := Real.sqrt_le_sqrt (by norm_num)
      simpa using h
    have hinv1 : (Real.sqrt 6)⁻¹ ≤ 1 := by
      rw [← one_div, div_le_one (by positivity)]
      exact hge1
    calc ArithmeticFunction.vonMangoldt 6 / Real.sqrt 6
        = ArithmeticFunction.vonMangoldt 6 * (Real.sqrt 6)⁻¹ := by ring
      _ ≤ 6 * (Real.sqrt 6)⁻¹ := mul_le_mul_of_nonneg_right hle (by positivity)
      _ ≤ 6 * 1 := mul_le_mul_of_nonneg_left hinv1 (by norm_num)
      _ = 6 := by ring
  have hspi : Real.sqrt Real.pi / 20 ≤ 1 := le_trans sqrt_pi_div_twenty_le (by norm_num)
  calc ArithmeticFunction.vonMangoldt 6 / Real.sqrt 6 *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 6 - 7 / 5) ^ 2))
      ≤ 6 * (1 * Real.exp (-15)) := by
        apply mul_le_mul hvm ?_ (by positivity) (by norm_num)
        apply mul_le_mul hspi hdec (by positivity) (by norm_num)
    _ = 6 * Real.exp (-15) := by ring
    _ ≤ 1 / 100000 := by
        have h : (6 : ℝ) * Real.exp (-15) ≤ 6 * (1 / 1000000) :=
          mul_le_mul_of_nonneg_left hexp15 (by norm_num)
        linarith

/-- The `n = 2` term at `c = 7/5` is below `10⁻²⁰`. -/
theorem primeSummand_two_7_5 : primeSummand (7 / 5) 2 ≤ 1 / 100000000000000000000 := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_two]
  have hlog2 : Real.log 2 ≤ 7 / 10 := by
    have h := log_two_mem.2
    linarith
  have harg : -100 * (Real.log 2 - 7 / 5) ^ 2 ≤ -49 := by nlinarith
  have hdec : Real.exp (-100 * (Real.log 2 - 7 / 5) ^ 2) ≤ Real.exp (-49) :=
    Real.exp_le_exp.mpr harg
  have hexp : Real.exp (-49 : ℝ) ≤ 1 / 100000000000000000000 := by
    have hbig : (100000000000000000000 : ℝ) ≤ Real.exp 1 ^ 49 := by
      have h1 : (100000000000000000000 : ℝ) ≤ (27182818283 / 10000000000) ^ 49 := by norm_num
      have h2 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
        have h := Real.exp_one_gt_d9
        linarith
      have h3 : (0 : ℝ) ≤ 27182818283 / 10000000000 := by norm_num
      exact le_trans h1 (pow_le_pow_left₀ h3 h2 49)
    rw [show (-49 : ℝ) = -((49 : ℝ) * 1) by ring, Real.exp_neg,
      show (49 : ℝ) * 1 = ((49 : ℕ) : ℝ) * 1 by norm_num, Real.exp_nat_mul]
    rw [inv_le_iff_one_le_mul₀ (by positivity)]
    rw [show (1 / 100000000000000000000 : ℝ) * Real.exp 1 ^ 49
        = Real.exp 1 ^ 49 / 100000000000000000000 by ring]
    rw [le_div_iff₀ (by norm_num)]
    linarith
  have hw : Real.log 2 / Real.sqrt 2 ≤ 1 := by
    rw [div_le_one (by positivity)]
    nlinarith [hlog2, sqrt_two_mem.1, Real.log_two_gt_d9]
  have hspi : Real.sqrt Real.pi / 20 ≤ 1 := le_trans sqrt_pi_div_twenty_le (by norm_num)
  calc Real.log 2 / Real.sqrt 2 *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 7 / 5) ^ 2))
      ≤ 1 * (1 * Real.exp (-49)) := by
        apply mul_le_mul hw ?_ (by positivity) (by norm_num)
        apply mul_le_mul hspi hdec (by positivity) (by norm_num)
    _ = Real.exp (-49) := by ring
    _ ≤ 1 / 100000000000000000000 := hexp

/-- The prime sum at `c = 7/5` splits after `n = 6`. -/
theorem prime_sum_split_seven_fifths :
    (∑' n : ℕ, primeSummand (7 / 5) n) =
      primeSummand (7 / 5) 2 + primeSummand (7 / 5) 3 + primeSummand (7 / 5) 4
        + primeSummand (7 / 5) 5 + primeSummand (7 / 5) 6
        + ∑' n : ℕ, primeSummand (7 / 5) (n + 7) := by
  have htail : Summable (fun n : ℕ => primeSummand (7 / 5) (n + 7)) :=
    summable_of_sum_range_le (f := fun n : ℕ => primeSummand (7 / 5) (n + 7))
      (c := Real.sqrt Real.pi / 20 * (1 / 1000000000) * 1)
      (fun n => primeSummand_nonneg _ _) (fun N => by
      refine le_trans (Finset.sum_le_sum fun n _ => seven_fifths_term_le n) ?_
      rw [← Finset.mul_sum]
      refine mul_le_mul_of_nonneg_left ?_ (by positivity)
      refine le_trans (Finset.sum_le_sum fun n _ => ?_) (sum_inv_sq_le N)
      rw [show (((n : ℝ) + 7) ^ 2)⁻¹ = 1 / ((n : ℝ) + 7) ^ 2 by rw [one_div],
        show (((n : ℝ) + 2) ^ 2)⁻¹ = 1 / ((n : ℝ) + 2) ^ 2 by rw [one_div]]
      exact one_div_le_one_div_of_le (by positivity)
        (by nlinarith [Nat.cast_nonneg (α := ℝ) n]))
  have hsum : Summable (fun n : ℕ => primeSummand (7 / 5) n) :=
    (summable_nat_add_iff 7).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 7
  have h0 : primeSummand (7 / 5) 0 = 0 := by unfold primeSummand; simp
  have h1 : primeSummand (7 / 5) 1 = 0 := by unfold primeSummand; simp
  have hpre : ∑ n ∈ Finset.range 7, primeSummand (7 / 5) n =
      primeSummand (7 / 5) 2 + primeSummand (7 / 5) 3 + primeSummand (7 / 5) 4
        + primeSummand (7 / 5) 5 + primeSummand (7 / 5) 6 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hpre] at hsplit
  linarith [hsplit]

/-- **The prime term at `c = 7/5`.** -/
theorem primeTerm_mem_seven_fifths :
    primeTerm (7 / 5) (1 / 20) ∈ Set.Icc (-61920 / 1000000 : ℝ) (-61850 / 1000000) := by
  rw [primeTerm_eq_inv20]
  have hs := prime_sum_split_seven_fifths
  have h2 := primeSummand_two_7_5
  have h3 := primeSummand_three_7_5
  have h4 := primeSummand_four_7_5
  have h5 := primeSummand_five_7_5
  have h6 := primeSummand_six_7_5
  have ht := seven_fifths_tail_le
  have h2p := primeSummand_nonneg (7 / 5) 2
  have h3p := primeSummand_nonneg (7 / 5) 3
  have h4p := primeSummand_nonneg (7 / 5) 4
  have h5p := primeSummand_nonneg (7 / 5) 5
  have h6p := primeSummand_nonneg (7 / 5) 6
  have htp : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (7 / 5) (n + 7) :=
    tsum_nonneg (fun n => primeSummand_nonneg _ _)
  rw [hs]
  constructor
  · nlinarith [h2, h3.2, h4.2, h5.2, h6, ht]
  · nlinarith [h3.1, h4.1, h5.1, h2p, h3p, h4p, h5p, h6p, htp]

end PrimeSpectrumTensor
