import Mathlib
import PrimeEnclosure
import ExpSixFifths

/-!
# The prime term at `c = 6/5`

`primeTerm (6/5) (1/20) = −2 Σ_n Λ(n)/√n · (√π/20) e^{−100(log n − 6/5)²}`.
Only two terms matter: `n = 3` (weight `log 3/√3`, exponent `E₃ ≈ 1.0279`) and
`n = 4` (weight `(log 2)/2`, exponent `E₄ ≈ 3.4706`).  `n = 2` contributes about
`3·10⁻¹³` and the tail from `n ≥ 5` is below `2·10⁻⁵`, by the domination
`e^{−100(x−6/5)²} ≤ e^{−7x}` on `x ≥ log 5` followed by a telescoped `Σ n⁻⁶`.

This is the last input of the `7 × 7` closure ([`Closure7.lean`](Closure7.lean)).
-/

noncomputable section

namespace PrimeSpectrumTensor

/-! ## The domination and the `n ≥ 5` tail -/

/-- On `x ≥ log 5`, `100(x − 6/5)² ≥ 7x`. -/
theorem six_fifths_domination {x : ℝ} (hx : Real.log 5 ≤ x) :
    -100 * (x - 6 / 5) ^ 2 ≤ -7 * x := by
  have h5 : (160943 / 100000 : ℝ) ≤ x := by
    have h := Real.log_five_gt_d9
    linarith
  have hfac : 100 * x ^ 2 - 247 * x + 144
      = 100 * (x - 160943 / 100000) * (x + 160943 / 100000)
        - 247 * (x - 160943 / 100000)
        + (100 * (160943 / 100000) ^ 2 - 247 * (160943 / 100000) + 144) := by ring
  have hpoly : 0 ≤ 100 * x ^ 2 - 247 * x + 144 := by
    rw [hfac]
    have h1 : (0 : ℝ) ≤ x - 160943 / 100000 := by linarith
    have h2 : (0 : ℝ) ≤ 100 * (x + 160943 / 100000) - 247 := by nlinarith
    have h3 : (0 : ℝ) ≤ 100 * (160943 / 100000) ^ 2 - 247 * (160943 / 100000) + 144 := by
      norm_num
    nlinarith [mul_nonneg h1 h2]
  nlinarith

/-- The telescoping step: `(n+5)⁻⁶ ≤ (1/5)((n+4)⁻⁵ − (n+5)⁻⁵)`. -/
theorem inv_six_telescope (n : ℕ) : (((n : ℝ) + 5) ^ 6)⁻¹ ≤
    (1 / 5) * ((((n : ℝ) + 4) ^ 5)⁻¹ - (((n : ℝ) + 5) ^ 5)⁻¹) := by
  have h4 : (0 : ℝ) < (n : ℝ) + 4 := by positivity
  have h5 : (0 : ℝ) < (n : ℝ) + 5 := by positivity
  have hdiff : ((n : ℝ) + 5) ^ 5 - ((n : ℝ) + 4) ^ 5
      = 5 * ((n : ℝ) + 4) ^ 4 + 10 * ((n : ℝ) + 4) ^ 3 + 10 * ((n : ℝ) + 4) ^ 2
        + 5 * ((n : ℝ) + 4) + 1 := by ring
  have hkey : 5 * ((n : ℝ) + 4) ^ 4 ≤ ((n : ℝ) + 5) ^ 5 - ((n : ℝ) + 4) ^ 5 := by
    rw [hdiff]
    linarith [pow_pos h4 3, sq_pos_of_pos h4]
  have hgoal : (1 / 5) * ((((n : ℝ) + 4) ^ 5)⁻¹ - (((n : ℝ) + 5) ^ 5)⁻¹)
      = (((n : ℝ) + 5) ^ 5 - ((n : ℝ) + 4) ^ 5) /
        (5 * (((n : ℝ) + 4) ^ 5 * ((n : ℝ) + 5) ^ 5)) := by
    field_simp
  have hnum : (0 : ℝ) < ((n : ℝ) + 5) ^ 5 - ((n : ℝ) + 4) ^ 5 := by
    linarith [hkey, pow_pos h4 4]
  rw [hgoal, inv_le_comm₀ (by positivity) (by positivity), inv_div]
  rw [div_le_iff₀ (by positivity : (0 : ℝ) < ((n : ℝ) + 5) ^ 5 - ((n : ℝ) + 4) ^ 5)]
  nlinarith [hkey, h4, h5, pow_nonneg (show (0 : ℝ) ≤ (n : ℝ) + 4 by positivity) 5,
    pow_nonneg (show (0 : ℝ) ≤ (n : ℝ) + 5 by positivity) 4]

/-- `Σ_{n≥5} n⁻⁶ ≤ 1/5120`. -/
theorem sum_tail_inv_six_le (N : ℕ) :
    ∑ n ∈ Finset.range N, (((n : ℝ) + 5) ^ 6)⁻¹ ≤ 1 / 5120 := by
  have hsum : ∑ n ∈ Finset.range N, (1 / 5 : ℝ) *
      ((((n : ℝ) + 4) ^ 5)⁻¹ - (((n : ℝ) + 5) ^ 5)⁻¹) ≤ 1 / 5120 := by
    rw [← Finset.mul_sum]
    have htel : ∑ n ∈ Finset.range N,
        ((((n : ℝ) + 4) ^ 5)⁻¹ - (((n : ℝ) + 5) ^ 5)⁻¹)
          = ((4 : ℝ)⁻¹ ^ 5) - (((N : ℝ) + 4) ^ 5)⁻¹ := by
      induction N with
      | zero => simp
      | succ M ih =>
        rw [Finset.sum_range_succ, ih]
        push_cast
        ring
    rw [htel, show ((4 : ℝ)⁻¹ ^ 5) = 1 / 1024 by norm_num]
    have hNN : (0 : ℝ) ≤ (((N : ℝ) + 4) ^ 5)⁻¹ := by positivity
    nlinarith
  exact le_trans (Finset.sum_le_sum fun n _ => inv_six_telescope n) hsum

/-! ## The `n ≥ 5` tail -/

/-- Termwise bound on the `n ≥ 5` tail at `c = 6/5`. -/
theorem six_fifths_term_le (n : ℕ) : primeSummand (6 / 5) (n + 5) ≤
    Real.sqrt Real.pi / 20 * (((n : ℝ) + 5) ^ 6)⁻¹ := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  push_cast
  have h5 : (0 : ℝ) < (n : ℝ) + 5 := by positivity
  have hlogn : Real.log 5 ≤ Real.log ((n : ℝ) + 5) :=
    Real.log_le_log (by norm_num) (by linarith)
  have hdec : Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2) ≤
      (((n : ℝ) + 5) ^ 7)⁻¹ := by
    have h1 : Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2) ≤
        Real.exp (-7 * Real.log ((n : ℝ) + 5)) :=
      Real.exp_le_exp.mpr (six_fifths_domination hlogn)
    have h2 : Real.exp (-7 * Real.log ((n : ℝ) + 5)) = (((n : ℝ) + 5) ^ 7)⁻¹ := by
      rw [show -7 * Real.log ((n : ℝ) + 5) = -(7 * Real.log ((n : ℝ) + 5)) by ring,
        Real.exp_neg, show (7 : ℝ) = ((7 : ℕ) : ℝ) by norm_num, Real.exp_nat_mul,
        Real.exp_log h5]
    rwa [h2] at h1
  have hvm : ArithmeticFunction.vonMangoldt (n + 5) / Real.sqrt ((n : ℝ) + 5) ≤
      (n : ℝ) + 5 := by
    have hlogeq : Real.log ((n : ℝ) + 5) = Real.log (↑(n + 5) : ℝ) := by push_cast; ring_nf
    have h1 : ArithmeticFunction.vonMangoldt (n + 5) ≤ Real.log ((n : ℝ) + 5) := by
      have := ArithmeticFunction.vonMangoldt_le_log (n := n + 5)
      rwa [hlogeq]
    have h2 : Real.log ((n : ℝ) + 5) ≤ (n : ℝ) + 5 := by
      have := Real.log_le_sub_one_of_pos h5
      linarith
    have h3 : (1 : ℝ) ≤ Real.sqrt ((n : ℝ) + 5) := by
      rw [show (1 : ℝ) = Real.sqrt 1 by simp]
      exact Real.sqrt_le_sqrt (by linarith)
    have h0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt (n + 5) :=
      ArithmeticFunction.vonMangoldt_nonneg
    rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt ((n : ℝ) + 5))]
    nlinarith
  have hpi : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 :=
    div_nonneg (Real.sqrt_nonneg _) (by norm_num)
  have hbump : Real.sqrt Real.pi / 20 *
        Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2)
      ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) + 5) ^ 7)⁻¹ :=
    mul_le_mul_of_nonneg_left hdec hpi
  have hnn : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt (n + 5) /
      Real.sqrt ((n : ℝ) + 5) := by positivity
  have hmain : ArithmeticFunction.vonMangoldt (n + 5) / Real.sqrt ((n : ℝ) + 5) *
        (Real.sqrt Real.pi / 20 *
          Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2))
      ≤ ((n : ℝ) + 5) * (Real.sqrt Real.pi / 20 * (((n : ℝ) + 5) ^ 7)⁻¹) :=
    mul_le_mul hvm hbump (mul_nonneg hpi (by positivity)) (by linarith)
  calc ArithmeticFunction.vonMangoldt (n + 5) / Real.sqrt ((n : ℝ) + 5) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2))
      = ArithmeticFunction.vonMangoldt (n + 5) / Real.sqrt ((n : ℝ) + 5) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 5) - 6 / 5) ^ 2)) := rfl
    _ ≤ ((n : ℝ) + 5) * (Real.sqrt Real.pi / 20 * (((n : ℝ) + 5) ^ 7)⁻¹) := hmain
    _ = Real.sqrt Real.pi / 20 * (((n : ℝ) + 5) ^ 6)⁻¹ := by
        field_simp

/-- The `n ≥ 5` tail of the `c = 6/5` prime sum. -/
theorem six_fifths_tail_le :
    ∑' n : ℕ, primeSummand (6 / 5) (n + 5) ≤ 1 / 50000 := by
  have hbound : ∑' n : ℕ, primeSummand (6 / 5) (n + 5) ≤
      Real.sqrt Real.pi / 20 * (1 / 5120) := by
    refine Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg (6 / 5) (n + 5))
      (fun N => ?_)
    refine le_trans (Finset.sum_le_sum fun n _ => six_fifths_term_le n) ?_
    rw [← Finset.mul_sum]
    have h := sum_tail_inv_six_le N
    exact mul_le_mul_of_nonneg_left h (div_nonneg (Real.sqrt_nonneg _) (by norm_num))
  refine le_trans hbound ?_
  have hb2 := sqrt_pi_div_twenty_le
  have h1 : Real.sqrt Real.pi / 20 * (1 / 5120) ≤ (8863 / 100000 : ℝ) * (1 / 5120) :=
    mul_le_mul_of_nonneg_right hb2 (by norm_num)
  linarith

/-! ## The prefix terms `n = 2, 3, 4` -/

/-- The `n = 2` term is below `10⁻¹⁰`. -/
theorem primeSummand_two_six_fifths : primeSummand (6 / 5) 2 ≤ 1 / 10000000000 := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_two]
  have hlog2 : Real.log 2 ≤ 7 / 10 := by
    have h := log_two_mem.2
    linarith
  have harg : -100 * (Real.log 2 - 6 / 5) ^ 2 ≤ -25 := by nlinarith
  have hdec : Real.exp (-100 * (Real.log 2 - 6 / 5) ^ 2) ≤ Real.exp (-25) :=
    Real.exp_le_exp.mpr harg
  have hexp : Real.exp (-25 : ℝ) ≤ 1 / 10000000000 := by
    have hbig : (10000000000 : ℝ) ≤ Real.exp 1 ^ 25 := by
      have h1 : (10000000000 : ℝ) ≤ (27182818283 / 10000000000) ^ 25 := by norm_num
      have h2 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
        have h := Real.exp_one_gt_d9
        linarith
      have h3 : (0 : ℝ) ≤ 27182818283 / 10000000000 := by norm_num
      exact le_trans h1 (pow_le_pow_left₀ h3 h2 25)
    rw [show (-25 : ℝ) = -((25 : ℝ) * 1) by ring, Real.exp_neg,
      show (25 : ℝ) * 1 = ((25 : ℕ) : ℝ) * 1 by norm_num, Real.exp_nat_mul]
    rw [inv_le_iff_one_le_mul₀ (by positivity)]
    rw [show (1 / 10000000000 : ℝ) * Real.exp 1 ^ 25 = Real.exp 1 ^ 25 / 10000000000 by ring]
    rw [le_div_iff₀ (by norm_num)]
    linarith
  have hw : Real.log 2 / Real.sqrt 2 ≤ 1 := by
    rw [div_le_one (by positivity)]
    nlinarith [hlog2, sqrt_two_mem.1, Real.log_two_gt_d9]
  have hspi : Real.sqrt Real.pi / 20 ≤ 1 := le_trans sqrt_pi_div_twenty_le (by norm_num)
  have hb1 : Real.log 2 / Real.sqrt 2 ≤ 1 := hw
  have hb2 : Real.sqrt Real.pi / 20 ≤ 1 := hspi
  calc Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 6 / 5) ^ 2))
      ≤ 1 * (1 * Real.exp (-25)) := by
        apply mul_le_mul hb1 ?_ (by positivity) (by norm_num)
        apply mul_le_mul hb2 hdec (by positivity) (by norm_num)
    _ = Real.exp (-25) := by ring
    _ ≤ 1 / 10000000000 := hexp




/-- `−100(log 3 − 6/5)² ∈ [−1.02799321, −1.02779044]`. -/
theorem six_fifths_exponent_three :
    -100 * (Real.log 3 - 6 / 5) ^ 2 ∈
      Set.Icc (-(102799321 / 100000000) : ℝ) (-(25694761 / 25000000)) := by
  constructor <;> nlinarith [log_three_mem.1, log_three_mem.2]




/-- `primeSummand (6/5) 3 ∈ [0.020107, 0.020114]`. -/
theorem primeSummand_three_six_fifths : primeSummand (6 / 5) 3 ∈ Set.Icc (20107 / 1000000 : ℝ) (20114 / 1000000) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_three]
  push_cast
  have hlog := log_three_mem
  have hlogpos : (0 : ℝ) < Real.log 3 := Real.log_pos (by norm_num)
  have hinvlo : (100000 / 173206 : ℝ) ≤ 1 / Real.sqrt 3 := by
    rw [div_le_div_iff₀ (by norm_num) (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3))]
    nlinarith [sqrt_three_mem.2]
  have hinvhi : 1 / Real.sqrt 3 ≤ 100000 / 173205 := by
    rw [div_le_div_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3)) (by norm_num)]
    nlinarith [sqrt_three_mem.1]
  have he := six_fifths_exponent_three
  have helo : (71544822362489 / 200000000000000 : ℝ) ≤
      Real.exp (-100 * (Real.log 3 - 6 / 5) ^ 2) :=
    le_trans exp_sixE3hi_mem.1 (Real.exp_le_exp.mpr he.1)
  have hehi : Real.exp (-100 * (Real.log 3 - 6 / 5) ^ 2) ≤
      (89449166774391 / 250000000000000 : ℝ) :=
    le_trans (Real.exp_le_exp.mpr he.2) exp_sixE3lo_mem.2
  have hspi := sqrt_pi_mem
  have hspl : (17724 / 200000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by linarith [hspi.1]
  have hspu : Real.sqrt Real.pi / 20 ≤ 17725 / 200000 := by linarith [hspi.2]
  have hqlo : (634279 / 1000000 : ℝ) ≤ Real.log 3 / Real.sqrt 3 := by
    rw [div_eq_mul_one_div (Real.log 3) (Real.sqrt 3)]
    have h1 : (634279 / 1000000 : ℝ) ≤ (109861 / 100000) * (100000 / 173206) := by norm_num
    have h2 : (109861 / 100000 : ℝ) * (100000 / 173206) ≤ Real.log 3 * (1 / Real.sqrt 3) :=
      mul_le_mul hlog.1 hinvlo (by norm_num) (le_of_lt hlogpos)
    exact le_trans h1 h2
  have hqhi : Real.log 3 / Real.sqrt 3 ≤ (634289 / 1000000 : ℝ) := by
    rw [div_eq_mul_one_div (Real.log 3) (Real.sqrt 3)]
    refine le_trans (mul_le_mul hlog.2 hinvhi (by positivity) (by norm_num)) ?_
    norm_num
  have hblo : (31701 / 1000000 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 6 / 5) ^ 2) := by
    refine le_trans ?_ (mul_le_mul hspl helo (by norm_num) (by positivity))
    norm_num
  have hbhi : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 3 - 6 / 5) ^ 2) ≤
      (31710 / 1000000 : ℝ) := by
    refine le_trans (mul_le_mul hspu hehi (by positivity) (by norm_num)) ?_
    norm_num
  have hqpos : (0 : ℝ) ≤ Real.log 3 / Real.sqrt 3 := by positivity
  constructor
  · refine le_trans (by norm_num : (20107 / 1000000 : ℝ) ≤
        (634279 / 1000000) * (31701 / 1000000)) ?_
    exact mul_le_mul hqlo hblo (by norm_num) hqpos
  · refine le_trans (mul_le_mul hqhi hbhi (by positivity) (by norm_num)) ?_
    norm_num

/-- `−100(log 4 − 6/5)² ∈ [−3.4706199616, −3.4705454436]`. -/
theorem six_fifths_exponent_four :
    -100 * (Real.log 4 - 6 / 5) ^ 2 ∈
      Set.Icc (-(542284369 / 156250000) : ℝ) (-(8676363609 / 2500000000)) := by
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    ring
  rw [h4]
  have hl : (1862943 / 10000000 : ℝ) ≤ 2 * Real.log 2 - 6 / 5 := by linarith [log_two_mem.1]
  have hu : 2 * Real.log 2 - 6 / 5 ≤ 1862945 / 10000000 := by linarith [log_two_mem.2]
  have hy0 : (0 : ℝ) ≤ 2 * Real.log 2 - 6 / 5 := by linarith
  have hclo : (3470556621249 / 100000000000000 : ℝ) ≤ (2 * Real.log 2 - 6 / 5) ^ 2 := by
    have h := pow_le_pow_left₀ (show (0 : ℝ) ≤ 1862943 / 10000000 by norm_num) hl 2
    have he : (3470556621249 / 100000000000000 : ℝ) = (1862943 / 10000000 : ℝ) ^ 2 := by
      norm_num
    rw [he]
    exact h
  have hchi : (2 * Real.log 2 - 6 / 5) ^ 2 ≤ (3470564073025 / 100000000000000 : ℝ) := by
    have h := pow_le_pow_left₀ hy0 hu 2
    have he : (1862945 / 10000000 : ℝ) ^ 2 = (3470564073025 / 100000000000000 : ℝ) := by
      norm_num
    rw [he] at h
    exact h
  constructor
  · have hle : (100 : ℝ) * ((2 * Real.log 2 - 6 / 5) ^ 2) ≤
        100 * (3470564073025 / 100000000000000) :=
      mul_le_mul_of_nonneg_left hchi (by norm_num)
    have hnum : (100 : ℝ) * (3470564073025 / 100000000000000) ≤ 542284369 / 156250000 := by
      norm_num
    linarith
  · have hge : (100 : ℝ) * (3470556621249 / 100000000000000) ≤
        100 * ((2 * Real.log 2 - 6 / 5) ^ 2) :=
      mul_le_mul_of_nonneg_left hclo (by norm_num)
    have hnum : (8676363609 / 2500000000 : ℝ) ≤ 100 * (3470556621249 / 100000000000000) := by
      norm_num
    linarith

/-! ## The split at `n = 5` -/

/-- The prime sum at `c = 6/5` splits after `n = 4`. -/
theorem prime_sum_split_six_fifths :
    (∑' n : ℕ, primeSummand (6 / 5) n) =
      primeSummand (6 / 5) 2 + primeSummand (6 / 5) 3 + primeSummand (6 / 5) 4
        + ∑' n : ℕ, primeSummand (6 / 5) (n + 5) := by
  have htail : Summable (fun n : ℕ => primeSummand (6 / 5) (n + 5)) :=
    summable_of_sum_range_le (f := fun n : ℕ => primeSummand (6 / 5) (n + 5))
      (c := Real.sqrt Real.pi / 20 * (1 / 5120))
      (fun n => primeSummand_nonneg (6 / 5) (n + 5)) (fun N => by
      refine le_trans (Finset.sum_le_sum fun n _ => six_fifths_term_le n) ?_
      rw [← Finset.mul_sum]
      exact mul_le_mul_of_nonneg_left (sum_tail_inv_six_le N) (by positivity))
  have hsum : Summable (fun n : ℕ => primeSummand (6 / 5) n) :=
    (summable_nat_add_iff 5).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 5
  have h0 : primeSummand (6 / 5) 0 = 0 := by unfold primeSummand; simp
  have h1 : primeSummand (6 / 5) 1 = 0 := by unfold primeSummand; simp
  have hprefix : ∑ n ∈ Finset.range 5, primeSummand (6 / 5) n =
      primeSummand (6 / 5) 2 + primeSummand (6 / 5) 3 + primeSummand (6 / 5) 4 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hprefix] at hsplit
  linarith [hsplit]

/-- `Λ(4) = log 2`. -/
theorem vonMangoldt_four : ArithmeticFunction.vonMangoldt 4 = Real.log 2 := by
  have h : (4 : ℕ) = 2 ^ 2 := by norm_num
  rw [h, ArithmeticFunction.vonMangoldt_apply_pow (by norm_num : (2 : ℕ) ≠ 0), vonMangoldt_two]


/-- `primeSummand (6/5) 4 ∈ [0.000955, 0.000956]`. -/
theorem primeSummand_four_six_fifths :
    primeSummand (6 / 5) 4 ∈ Set.Icc (955 / 1000000 : ℝ) (956 / 1000000) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_four]
  have h4 : Real.sqrt ((4 : ℕ) : ℝ) = 2 := by
    rw [show ((4 : ℕ) : ℝ) = (2 : ℝ) ^ 2 by norm_num, Real.sqrt_sq (by norm_num)]
  rw [h4]
  push_cast
  have hlog := log_two_mem
  have he := six_fifths_exponent_four
  have helo : (7774436164253 / 250000000000000 : ℝ) ≤
      Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2) :=
    le_trans exp_sixE4lo_mem.1 (Real.exp_le_exp.mpr he.1)
  have hehi : Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2) ≤
      (3887507915263 / 125000000000000 : ℝ) :=
    le_trans (Real.exp_le_exp.mpr he.2) exp_sixE4hi_mem.2
  have hspi := sqrt_pi_mem
  have hspl : (17724 / 200000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by linarith [hspi.1]
  have hspu : Real.sqrt Real.pi / 20 ≤ 17725 / 200000 := by linarith [hspi.2]
  have hqlo : (346573 / 1000000 : ℝ) ≤ Real.log 2 / 2 := by
    rw [div_eq_mul_one_div (Real.log 2) 2]
    have h1 : (346573 / 1000000 : ℝ) ≤ (69314718 / 100000000) * (1 / 2) := by norm_num
    have h2 : (69314718 / 100000000 : ℝ) * (1 / 2) ≤ Real.log 2 * (1 / 2) :=
      mul_le_mul_of_nonneg_right hlog.1 (by norm_num)
    exact le_trans h1 h2
  have hqhi : Real.log 2 / 2 ≤ (346574 / 1000000 : ℝ) := by
    rw [div_eq_mul_one_div (Real.log 2) 2]
    have h1 : (69314719 / 100000000 : ℝ) * (1 / 2) ≤ 346574 / 1000000 := by norm_num
    have h2 : Real.log 2 * (1 / 2) ≤ (69314719 / 100000000 : ℝ) * (1 / 2) :=
      mul_le_mul_of_nonneg_right hlog.2 (by norm_num)
    exact le_trans h2 h1
  have hblo : (275580 / 100000000 : ℝ) ≤
      Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2) := by
    refine le_trans ?_ (mul_le_mul hspl helo (by norm_num) (by positivity))
    norm_num
  have hbhi : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2) ≤
      (275630 / 100000000 : ℝ) := by
    refine le_trans (mul_le_mul hspu hehi (by positivity) (by norm_num)) ?_
    norm_num
  have hqpos : (0 : ℝ) ≤ Real.log 2 / 2 := by positivity
  have hbpos : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2) := by
    positivity
  constructor
  · have h1 : (346573 / 1000000 : ℝ) * (275580 / 100000000) ≤
        (Real.log 2 / 2) * (275580 / 100000000) :=
      mul_le_mul_of_nonneg_right hqlo (by norm_num)
    have h2 : (Real.log 2 / 2 : ℝ) * (275580 / 100000000) ≤
        (Real.log 2 / 2) * (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_left hblo hqpos
    calc (955 / 1000000 : ℝ) ≤ (346573 / 1000000) * (275580 / 100000000) := by norm_num
      _ ≤ (Real.log 2 / 2) * (275580 / 100000000) := h1
      _ ≤ (Real.log 2 / 2) *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2)) := h2
  · have h1 : (Real.log 2 / 2 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2)) ≤
        (346574 / 1000000) * (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2)) :=
      mul_le_mul_of_nonneg_right hqhi hbpos
    have h2 : (346574 / 1000000 : ℝ) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2)) ≤
        (346574 / 1000000) * (275630 / 100000000) :=
      mul_le_mul_of_nonneg_left hbhi (by norm_num)
    calc (Real.log 2 / 2) *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 4 - 6 / 5) ^ 2))
        ≤ (346574 / 1000000) * (275630 / 100000000) := le_trans h1 h2
      _ ≤ (956 / 1000000 : ℝ) := by norm_num

/-- **The prime term at `c = 6/5`.** -/
theorem primeTerm_mem_six_fifths :
    primeTerm (6 / 5) (1 / 20) ∈ Set.Icc (-42181 / 1000000 : ℝ) (-42124 / 1000000) := by
  rw [primeTerm_eq_inv20]
  have hs := prime_sum_split_six_fifths
  have h2 := primeSummand_two_six_fifths
  have h3 := primeSummand_three_six_fifths
  have h4 := primeSummand_four_six_fifths
  have ht := six_fifths_tail_le
  have h2pos := primeSummand_nonneg (6 / 5) 2
  have h3pos := primeSummand_nonneg (6 / 5) 3
  have h4pos := primeSummand_nonneg (6 / 5) 4
  have htpos : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (6 / 5) (n + 5) :=
    tsum_nonneg (fun n => primeSummand_nonneg (6 / 5) (n + 5))
  rw [hs]
  constructor
  · nlinarith [h2, h3.2, h4.2, ht]
  · nlinarith [h3.1, h4.1, h4.2, h3.2, h2pos, h3pos, h4pos, htpos]


theorem exp_neg_144_le : Real.exp (-144 : ℝ) ≤ 1 / 1000000000 := by
  have h21 : (1000000000 : ℝ) ≤ Real.exp 1 ^ 21 := by
    have h1 : (1000000000 : ℝ) ≤ (27182818283 / 10000000000) ^ 21 := by norm_num
    have h2 : (27182818283 / 10000000000 : ℝ) ≤ Real.exp 1 := by
      have h := Real.exp_one_gt_d9; linarith
    have h3 : (0 : ℝ) ≤ 27182818283 / 10000000000 := by norm_num
    exact le_trans h1 (pow_le_pow_left₀ h3 h2 21)
  have h144 : (1000000000 : ℝ) ≤ Real.exp (144 : ℝ) := by
    have heq : Real.exp (144 : ℝ) = Real.exp 1 ^ 21 * Real.exp 123 := by
      rw [← Real.exp_nat_mul (x := (1 : ℝ)) (n := 21), ← Real.exp_add]; norm_num
    rw [heq]
    exact le_trans h21 (le_mul_of_one_le_right (by positivity) (Real.one_le_exp (by norm_num)))
  rw [Real.exp_neg, ← one_div]
  exact one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 1000000000) h144

theorem inv_sq_telescope (n : ℕ) :
    (((n : ℝ) + 2) ^ 2)⁻¹ ≤ (((n : ℝ) + 1)⁻¹ - ((n : ℝ) + 2)⁻¹) := by
  have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have h2 : (0 : ℝ) < (n : ℝ) + 2 := by positivity
  have hgoal : (((n : ℝ) + 1)⁻¹ - ((n : ℝ) + 2)⁻¹)
      = (((n : ℝ) + 1) * ((n : ℝ) + 2))⁻¹ := by
    field_simp
    ring
  rw [hgoal]
  exact (inv_le_inv₀ (by positivity) (by positivity)).mpr (by nlinarith)

theorem sum_inv_sq_le (N : ℕ) :
    ∑ n ∈ Finset.range N, (((n : ℝ) + 2) ^ 2)⁻¹ ≤ 1 := by
  refine le_trans (Finset.sum_le_sum fun n _ => inv_sq_telescope n) ?_
  have htel : ∑ n ∈ Finset.range N, (((n : ℝ) + 1)⁻¹ - ((n : ℝ) + 2)⁻¹)
      = (1 : ℝ) - (((N : ℝ) + 1)⁻¹) := by
    induction N with
    | zero => simp
    | succ M ih =>
      rw [Finset.sum_range_succ, ih]
      push_cast
      ring
  rw [htel]
  have hpos : (0 : ℝ) ≤ ((N : ℝ) + 1)⁻¹ := by positivity
  linarith

theorem neg_term_le (n : ℕ) :
    primeSummand (-(6 / 5)) (n + 1) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * (((n : ℝ) + 1) ^ 2)⁻¹ := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hcast : Real.sqrt (↑(n + 1) : ℝ) = Real.sqrt ((n : ℝ) + 1) := by
    push_cast
    ring_nf
  rw [hcast]
  push_cast
  have harg : (Real.log ((n : ℝ) + 1) - -(6 / 5)) = (Real.log ((n : ℝ) + 1) + 6 / 5) := by
    ring
  rw [harg]
  have hm : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have hlogpos : (0 : ℝ) ≤ Real.log ((n : ℝ) + 1) := Real.log_nonneg (by linarith)
  have hdom : -100 * (Real.log ((n : ℝ) + 1) + 6 / 5) ^ 2 ≤
      -3 * Real.log ((n : ℝ) + 1) - 144 := by
    nlinarith [hlogpos, sq_nonneg (Real.log ((n : ℝ) + 1))]
  have hsplitE : (-3 * Real.log ((n : ℝ) + 1) - 144 : ℝ) =
      (-3 * Real.log ((n : ℝ) + 1)) + (-144) := by ring
  have h3 : Real.exp (-3 * Real.log ((n : ℝ) + 1)) = (((n : ℝ) + 1) ^ 3)⁻¹ := by
    rw [show -3 * Real.log ((n : ℝ) + 1) = -(3 * Real.log ((n : ℝ) + 1)) by ring,
      Real.exp_neg, show (3 : ℝ) = ((3 : ℕ) : ℝ) by norm_num, Real.exp_nat_mul,
      Real.exp_log hm]
  have hdec : Real.exp (-100 * (Real.log ((n : ℝ) + 1) + 6 / 5) ^ 2) ≤
      (((n : ℝ) + 1) ^ 3)⁻¹ * (1 / 1000000000) := by
    refine le_trans (Real.exp_le_exp.mpr hdom) ?_
    rw [hsplitE, Real.exp_add, h3]
    exact mul_le_mul_of_nonneg_left exp_neg_144_le (by positivity)
  have hvm : ArithmeticFunction.vonMangoldt (n + 1) / Real.sqrt ((n : ℝ) + 1) ≤ (n : ℝ) + 1 := by
    have hle : ArithmeticFunction.vonMangoldt (n + 1) ≤ (n : ℝ) + 1 := by
      have hlt := ArithmeticFunction.vonMangoldt_le_log (n := n + 1)
      have hlogeq : Real.log ((n : ℝ) + 1) = Real.log (↑(n + 1) : ℝ) := by push_cast; ring_nf
      rw [← hlogeq] at hlt
      have hl := Real.log_le_sub_one_of_pos hm
      linarith
    have hge1 : (1 : ℝ) ≤ Real.sqrt ((n : ℝ) + 1) := by
      have h : Real.sqrt 1 ≤ Real.sqrt ((n : ℝ) + 1) :=
        Real.sqrt_le_sqrt (by linarith [Nat.cast_nonneg (α := ℝ) n])
      simpa using h
    have hinv1 : (Real.sqrt ((n : ℝ) + 1))⁻¹ ≤ 1 := by
      rw [← one_div, div_le_one (by positivity)]
      exact hge1
    calc ArithmeticFunction.vonMangoldt (n + 1) / Real.sqrt ((n : ℝ) + 1)
        = ArithmeticFunction.vonMangoldt (n + 1) * (Real.sqrt ((n : ℝ) + 1))⁻¹ := by ring
      _ ≤ ((n : ℝ) + 1) * (Real.sqrt ((n : ℝ) + 1))⁻¹ :=
          mul_le_mul_of_nonneg_right hle (by positivity)
      _ ≤ ((n : ℝ) + 1) * 1 := mul_le_mul_of_nonneg_left hinv1 (by linarith)
      _ = (n : ℝ) + 1 := by ring
  have hpi : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 := div_nonneg (Real.sqrt_nonneg _) (by norm_num)
  have hbump : Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 1) + 6 / 5) ^ 2) ≤
      Real.sqrt Real.pi / 20 * ((((n : ℝ) + 1) ^ 3)⁻¹ * (1 / 1000000000)) :=
    mul_le_mul_of_nonneg_left hdec hpi
  have hnn : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt (n + 1) / Real.sqrt ((n : ℝ) + 1) := by
    positivity
  have hmain : ArithmeticFunction.vonMangoldt (n + 1) / Real.sqrt ((n : ℝ) + 1) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 1) + 6 / 5) ^ 2))
      ≤ ((n : ℝ) + 1) * (Real.sqrt Real.pi / 20 * ((((n : ℝ) + 1) ^ 3)⁻¹ * (1 / 1000000000))) :=
    mul_le_mul hvm hbump (mul_nonneg hpi (by positivity)) (by linarith)
  calc ArithmeticFunction.vonMangoldt (n + 1) / Real.sqrt ((n : ℝ) + 1) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log ((n : ℝ) + 1) + 6 / 5) ^ 2))
      ≤ ((n : ℝ) + 1) * (Real.sqrt Real.pi / 20 * ((((n : ℝ) + 1) ^ 3)⁻¹ * (1 / 1000000000))) :=
        hmain
    _ = Real.sqrt Real.pi / 20 * (1 / 1000000000) * (((n : ℝ) + 1) ^ 2)⁻¹ := by
        field_simp

theorem sum_inv_sq_succ_le (N : ℕ) :
    ∑ n ∈ Finset.range N, (((n : ℝ) + 1) ^ 2)⁻¹ ≤ 2 := by
  rcases Nat.eq_zero_or_pos N with hN | hN
  · subst hN
    simp
  · obtain ⟨M, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hN)
    rw [Finset.sum_range_succ']
    have hpush : ∑ x ∈ Finset.range M, (((↑(x + 1) : ℝ) + 1) ^ 2)⁻¹
        = ∑ x ∈ Finset.range M, (((x : ℝ) + 2) ^ 2)⁻¹ := by
      apply Finset.sum_congr rfl
      intro x _
      push_cast
      ring_nf
    rw [hpush]
    have hf0 : ((((0 : ℕ) : ℝ) + 1) ^ 2)⁻¹ = 1 := by norm_num
    rw [hf0]
    have h := sum_inv_sq_le M
    linarith

theorem primeTerm_mem_neg_six_fifths :
    primeTerm (-(6 / 5)) (1 / 20) ∈ Set.Icc (-(1 / 100000) : ℝ) 0 := by
  rw [primeTerm_eq_inv20]
  have hC : (0 : ℝ) ≤ Real.sqrt Real.pi / 20 * (1 / 1000000000) := by positivity
  have hmaj : ∀ N : ℕ, ∑ n ∈ Finset.range N, primeSummand (-(6 / 5)) (n + 1) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * 2 := by
    intro N
    refine le_trans (Finset.sum_le_sum fun n _ => neg_term_le n) ?_
    rw [← Finset.mul_sum]
    exact mul_le_mul_of_nonneg_left (sum_inv_sq_succ_le N) hC
  have htail : Summable (fun n : ℕ => primeSummand (-(6 / 5)) (n + 1)) :=
    summable_of_sum_range_le (f := fun n : ℕ => primeSummand (-(6 / 5)) (n + 1))
      (c := Real.sqrt Real.pi / 20 * (1 / 1000000000) * 2)
      (fun n => primeSummand_nonneg _ _) hmaj
  have hsum : Summable (fun n : ℕ => primeSummand (-(6 / 5)) n) :=
    (summable_nat_add_iff 1).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 1
  have h0 : primeSummand (-(6 / 5)) 0 = 0 := by unfold primeSummand; simp
  have hpre : ∑ n ∈ Finset.range 1, primeSummand (-(6 / 5)) n = 0 := by simp [h0]
  rw [hpre, zero_add] at hsplit
  have htb : ∑' n : ℕ, primeSummand (-(6 / 5)) (n + 1) ≤
      Real.sqrt Real.pi / 20 * (1 / 1000000000) * 2 :=
    Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg _ (n + 1)) (fun N => hmaj N)
  rw [← hsplit]
  have hnn : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (-(6 / 5)) (n + 1) :=
    tsum_nonneg (fun n => primeSummand_nonneg _ (n + 1))
  have hpi := sqrt_pi_div_twenty_le
  have hC2 : Real.sqrt Real.pi / 20 * (1 / 1000000000) * 2 ≤ 1 / 100000 := by
    nlinarith [hpi]
  constructor <;> nlinarith [htb, hnn, hC2]

/-- **The symmetrised prime term at `c = 6/5`.** -/
theorem primeTerm_sym_mem_six_fifths :
    (primeTerm (6 / 5) (1 / 20) + primeTerm (-(6 / 5)) (1 / 20)) / 2 ∈
      Set.Icc (-21100000 / 1000000000 : ℝ) (-21030000 / 1000000000) := by
  have h1 := primeTerm_mem_six_fifths
  have h2 := primeTerm_mem_neg_six_fifths
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2]

end PrimeSpectrumTensor
