import Mathlib
import GaussianGram

/-!
# W3 — the prime term at `σ = 1/20`

This file encloses the prime term

```
primeTerm c (1/20) = −2 Σ_{n} Λ(n)/√n · √π/20 · exp(−100 (log n − c)²)
```

in rational intervals. At `σ = 1/20` the sum is carried by `n = 2`; for `n ≥ 3`
the Gaussian factor is below `exp(−14 log n)`, so the summand is dominated by
`(√π/20)·n⁻¹³` and the whole tail is below `2.51·10⁻⁷`.

## Proved

* `gaussianBump_inv20` — the bump at `σ = 1/20`;
* `primeSummand`, `primeTerm_eq_inv20` — the summand and the definition;
* `log_ge_one_of_three_le`, `exp_decay_le` — `exp(−100(x−c)²) ≤ exp(−14x)` for
  `x ≥ 1`, `c ≤ 3/5`;
* `exp_neg_log_pow`, `primeSummand_le` — `primeSummand c n ≤ (√π/20)·n⁻¹³`;
* `tele2`, `tele2_sub`, `sum_tele2`, `primeSummand_le_tail`,
  `prime_sum_range_tail_le`, `sum_tail_le`, `sum_tail_le_rat` — the tail bound
  `Σ_{n≥3} primeSummand c n ≤ (√π/20)·3⁻¹¹/2 ≤ 2.51·10⁻⁷`;
* `vonMangoldt_two`, `log_two_mem`, `sqrt_two_mem`, `sqrt_pi_mem`,
  `primeSummand_two`, `prime_sum_split` — the `n = 2` term and the split of the
  full sum;
* `primeTerm_mem_small` — for `c ≤ 2/5`,
  `−2.2·10⁻⁵ ≤ primeTerm c (1/20) ≤ 0`;
* `primeTerm_mem_three_fifths` — at `c = 3/5`,
  `−0.036490 ≤ primeTerm (3/5) (1/20) ≤ −0.03646`
  (the true value is `−0.036481…`).

Everything is rational arithmetic plus `Real.exp_bound`, `Real.log_le_log`,
`Real.log_le_sub_one_of_pos`, `vonMangoldt_le_log`, `Real.tsum_le_of_sum_range_le`
and monotonicity of `exp`.

## Not here

The **density** term — the archimedean integral `(1/400)∫ exp(−t²/400)cos(ct)Ω`
— is not enclosed. It is R2 of [`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4 and
is the only remaining obstruction to O4.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-! ## The summand -/

/-- The Gaussian bump at `σ = 1/20`: `√π/20 · exp(−100 (v − c)²)`. -/
theorem gaussianBump_inv20 (c v : ℝ) :
    gaussianBump c (1 / 20) v = Real.sqrt Real.pi / 20 * Real.exp (-100 * (v - c) ^ 2) := by
  unfold gaussianBump
  have h4 : (4 : ℝ) * (1 / 20) ^ 2 = 1 / 100 := by norm_num
  rw [h4]
  have harg : -((v - c) ^ 2) / (1 / 100 : ℝ) = -100 * (v - c) ^ 2 := by ring
  rw [harg]
  ring

/-- The `n`-th summand of the prime term at `σ = 1/20`. -/
def primeSummand (c : ℝ) (n : ℕ) : ℝ :=
  ArithmeticFunction.vonMangoldt n / Real.sqrt n * gaussianBump c (1 / 20) (Real.log n)

theorem primeTerm_eq_inv20 (c : ℝ) :
    primeTerm c (1 / 20) = -2 * ∑' n : ℕ, primeSummand c n := rfl

/-! ## Elementary estimates -/

/-- `1 ≤ log n` for `n ≥ 3`. -/
theorem log_ge_one_of_three_le {n : ℕ} (hn : 3 ≤ n) : 1 ≤ Real.log n := by
  have h3 : (1 : ℝ) ≤ Real.log 3 := by
    rw [Real.le_log_iff_exp_le (by norm_num : (0 : ℝ) < 3)]
    exact le_of_lt Real.exp_one_lt_three
  refine h3.trans (Real.log_le_log (by norm_num) ?_)
  exact_mod_cast hn

/-- For `x ≥ 1` and `|c| ≤ 3/5`, `exp(−100 (x − c)²) ≤ exp(−14 x)`. -/
theorem exp_decay_le {x c : ℝ} (hx1 : 1 ≤ x) (hc : c ≤ 3 / 5) :
    Real.exp (-100 * (x - c) ^ 2) ≤ Real.exp (-14 * x) := by
  have hc' : c ≤ 3 / 5 := hc
  have hsq : (x - 3 / 5) ^ 2 ≤ (x - c) ^ 2 := by
    have h0 : 0 ≤ x - 3 / 5 := by linarith
    nlinarith [h0]
  have hkey : 14 * x ^ 2 ≤ 100 * (x - 3 / 5) ^ 2 := by
    nlinarith [sq_nonneg (x - 1), hx1]
  have hxx : x ≤ x ^ 2 := by nlinarith [hx1]
  have harg : -100 * (x - c) ^ 2 ≤ -14 * x := by nlinarith [hsq, hkey, hxx]
  exact Real.exp_le_exp.mpr harg

/-- `exp(−14 log n) = ((n)¹⁴)⁻¹` for `n > 0`. -/
theorem exp_neg_log_pow (n : ℕ) (hn : 0 < (n : ℝ)) :
    Real.exp (-14 * Real.log n) = (((n : ℝ) ^ 14)⁻¹) := by
  have h1 : Real.exp (-14 * Real.log n) = (n : ℝ) ^ (-14 : ℝ) := by
    rw [Real.rpow_def_of_pos hn]
    congr 1
    ring
  rw [h1, show (-14 : ℝ) = -((14 : ℕ) : ℝ) by norm_num, Real.rpow_neg (le_of_lt hn),
    Real.rpow_natCast]

/-- The pointwise bound `Λ(n)/√n · bump ≤ (√π/20)·n⁻¹³` for `n ≥ 3`, `|c| ≤ 3/5`. -/
theorem primeSummand_le (c : ℝ) (hc : c ≤ 3 / 5) {n : ℕ} (hn : 3 ≤ n) :
    primeSummand c n ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 13)⁻¹) := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hnpos : (0 : ℝ) < n := by
    have : (3 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hΛ0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n :=
    ArithmeticFunction.vonMangoldt_nonneg
  have hΛle : ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
    ArithmeticFunction.vonMangoldt_le_log
  have hlog1 : 1 ≤ Real.log n := log_ge_one_of_three_le hn
  have hsqrt1 : (1 : ℝ) ≤ Real.sqrt n := by
    rw [show (1 : ℝ) = Real.sqrt 1 by simp]
    exact Real.sqrt_le_sqrt (by exact_mod_cast hn.trans' (by norm_num : (1:ℕ) ≤ 3))
  have hcoef : ArithmeticFunction.vonMangoldt n / Real.sqrt n ≤ Real.log n := by
    rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt n)]
    have hb : Real.log n ≤ Real.log n * Real.sqrt n := by
      calc Real.log n = Real.log n * 1 := by ring
        _ ≤ Real.log n * Real.sqrt n :=
            mul_le_mul_of_nonneg_left hsqrt1 (by linarith)
    linarith [hΛle, hb]
  have hexp : Real.exp (-100 * (Real.log n - c) ^ 2) ≤ (((n : ℝ) ^ 14)⁻¹) := by
    have h := exp_decay_le hlog1 hc
    rwa [exp_neg_log_pow n hnpos] at h
  have hS0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n / Real.sqrt n :=
    div_nonneg hΛ0 (by positivity)
  have hlog14 : Real.log n * (((n : ℝ) ^ 14)⁻¹) ≤ (((n : ℝ) ^ 13)⁻¹) := by
    have hkey : (n : ℝ) * (((n : ℝ) ^ 14)⁻¹) = (((n : ℝ) ^ 13)⁻¹) := by
      field_simp
    have hlogle : Real.log n ≤ (n : ℝ) := by
      have h := Real.log_le_sub_one_of_pos hnpos
      linarith
    calc Real.log n * (((n : ℝ) ^ 14)⁻¹)
        ≤ (n : ℝ) * (((n : ℝ) ^ 14)⁻¹) := by
          apply mul_le_mul_of_nonneg_right hlogle (by positivity)
      _ = (((n : ℝ) ^ 13)⁻¹) := hkey
  have h14 : (0 : ℝ) ≤ (((n : ℝ) ^ 14)⁻¹) := by positivity
  calc ArithmeticFunction.vonMangoldt n / Real.sqrt n *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log n - c) ^ 2))
      = (ArithmeticFunction.vonMangoldt n / Real.sqrt n) *
          (Real.sqrt Real.pi / 20) * Real.exp (-100 * (Real.log n - c) ^ 2) := by ring
    _ ≤ Real.log n * (Real.sqrt Real.pi / 20) * (((n : ℝ) ^ 14)⁻¹) := by
        apply mul_le_mul (mul_le_mul hcoef (le_refl _) (by positivity) (by linarith)) hexp
          (by positivity) (by positivity)
    _ = Real.sqrt Real.pi / 20 * (Real.log n * (((n : ℝ) ^ 14)⁻¹)) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 13)⁻¹) := by
        apply mul_le_mul_of_nonneg_left hlog14 (by positivity)

/-! ## The tail bound -/

/-- The telescoping sequence `1/(n+2)`, used to sum the `n⁻²`-dominated tail. -/
def tele2 (n : ℕ) : ℝ := 1 / ((n : ℝ) + 2)

theorem tele2_sub (n : ℕ) :
    tele2 n - tele2 (n + 1) = 1 / (((n : ℝ) + 2) * ((n : ℝ) + 3)) := by
  unfold tele2
  push_cast
  field_simp
  ring

theorem sum_tele2 (N : ℕ) :
    ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) = tele2 0 - tele2 N := by
  induction N with
  | zero => simp
  | succ N ih => rw [Finset.sum_range_succ, ih]; ring

theorem tele2_nonneg (n : ℕ) : 0 ≤ tele2 n := by
  unfold tele2
  positivity

/-- The summand dominates its own `n⁻²`-normalised tail term.

For `m = n + 3 ≥ 3`, `m⁻¹³ = m⁻¹¹·m⁻² ≤ 3⁻¹¹·m⁻² ≤ 3⁻¹¹·(1/((m−1)m))`, and the
last factor telescopes. -/
theorem primeSummand_le_tail (c : ℝ) (hc : c ≤ 3 / 5) (n : ℕ) :
    primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
  have h1 : primeSummand c (n + 3) ≤ Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 13)⁻¹) := by
    have h := primeSummand_le c hc (n := n + 3) (by omega)
    simpa using h
  have hm : (3 : ℝ) ≤ (n : ℝ) + 3 := by
    have : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have h3 : ((((n : ℝ) + 3) ^ 11)⁻¹) ≤ ((3 : ℝ) ^ 11)⁻¹ := by
    rw [inv_eq_one_div, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (pow_le_pow_left₀ (by norm_num) hm 11)
  have hm13 : ((((n : ℝ) + 3) ^ 13)⁻¹) =
      ((((n : ℝ) + 3) ^ 11)⁻¹) * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [← mul_inv]
    congr 1
    ring
  have h2 : ((((n : ℝ) + 3) ^ 13)⁻¹) ≤
      ((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [hm13]
    exact mul_le_mul_of_nonneg_right h3 (by positivity)
  have h4 : ((((n : ℝ) + 3) ^ 2)⁻¹) ≤ tele2 n - tele2 (n + 1) := by
    rw [tele2_sub, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (by nlinarith)
  calc primeSummand c (n + 3) ≤ Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 13)⁻¹) := h1
    _ ≤ Real.sqrt Real.pi / 20 * (((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹)) :=
        mul_le_mul_of_nonneg_left h2 (by positivity)
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) :=
        mul_le_mul_of_nonneg_left h4 (by positivity)

theorem primeSummand_nonneg (c : ℝ) (n : ℕ) : 0 ≤ primeSummand c n := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have h1 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n := ArithmeticFunction.vonMangoldt_nonneg
  have h2 : (0 : ℝ) ≤ Real.sqrt n := Real.sqrt_nonneg n
  have h3 : (0 : ℝ) < Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log n - c) ^ 2) := by
    positivity
  exact mul_nonneg (div_nonneg h1 h2) h3.le

/-- **The prime tail is below `(√π/20)·3⁻¹¹/2 ≈ 8.3·10⁻⁸`.** -/
theorem sum_tail_le (c : ℝ) (hc : c ≤ 3 / 5) :
    ∑' n : ℕ, primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
  refine Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg c (n + 3)) (fun N => ?_)
  calc ∑ n ∈ Finset.range N, primeSummand c (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail c hc n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-! ## The `n = 2` term and the prime-term enclosures -/

theorem vonMangoldt_two : ArithmeticFunction.vonMangoldt 2 = Real.log 2 :=
  ArithmeticFunction.vonMangoldt_apply_prime (by norm_num)

theorem log_two_mem :
    (69314718 / 100000000 : ℝ) ≤ Real.log 2 ∧ Real.log 2 ≤ 69314719 / 100000000 := by
  constructor
  · linarith [Real.log_two_gt_d9]
  · linarith [Real.log_two_lt_d9]

/-- `Real.log 3` in a tight rational interval (via `exp` bounds). -/
theorem log_three_mem :
    (109861 / 100000 : ℝ) ≤ Real.log 3 ∧ Real.log 3 ≤ 109862 / 100000 := by
  have h9861 : Real.exp (9861 / 100000 : ℝ) < 1103637 / 1000000 := by
    have hx : |(9861 / 100000 : ℝ)| ≤ 1 := by norm_num
    have h := Real.exp_bound hx (n := 12) (by norm_num)
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
    norm_num at h
    rw [abs_le] at h
    linarith [h.2]
  have h9862 : (1103645 / 1000000 : ℝ) < Real.exp (9862 / 100000 : ℝ) := by
    have hx : |(9862 / 100000 : ℝ)| ≤ 1 := by norm_num
    have h := Real.exp_bound hx (n := 12) (by norm_num)
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
    norm_num at h
    rw [abs_le] at h
    linarith [h.1]
  have hprod_lo : Real.exp 1 * Real.exp (9861 / 100000 : ℝ) < 3 := by
    have h1 : Real.exp 1 * Real.exp (9861 / 100000 : ℝ) ≤
        (2.7182818286 : ℝ) * Real.exp (9861 / 100000 : ℝ) :=
      mul_le_mul_of_nonneg_right (le_of_lt Real.exp_one_lt_d9) (by positivity)
    have h2 : (2.7182818286 : ℝ) * Real.exp (9861 / 100000 : ℝ) <
        (2.7182818286 : ℝ) * (1103637 / 1000000) :=
      mul_lt_mul_of_pos_left h9861 (by norm_num)
    calc Real.exp 1 * Real.exp (9861 / 100000 : ℝ)
        ≤ (2.7182818286 : ℝ) * Real.exp (9861 / 100000 : ℝ) := h1
      _ < (2.7182818286 : ℝ) * (1103637 / 1000000) := h2
      _ < 3 := by norm_num
  have hprod_hi : (3 : ℝ) < Real.exp 1 * Real.exp (9862 / 100000 : ℝ) := by
    have h1 : (2.7182818283 : ℝ) * Real.exp (9862 / 100000 : ℝ) ≤
        Real.exp 1 * Real.exp (9862 / 100000 : ℝ) :=
      mul_le_mul_of_nonneg_right (le_of_lt Real.exp_one_gt_d9) (by positivity)
    have h2 : (2.7182818283 : ℝ) * (1103645 / 1000000) <
        (2.7182818283 : ℝ) * Real.exp (9862 / 100000 : ℝ) :=
      mul_lt_mul_of_pos_left h9862 (by norm_num)
    calc (3 : ℝ) < (2.7182818283 : ℝ) * (1103645 / 1000000) := by norm_num
      _ < (2.7182818283 : ℝ) * Real.exp (9862 / 100000 : ℝ) := h2
      _ ≤ Real.exp 1 * Real.exp (9862 / 100000 : ℝ) := h1
  constructor
  · rw [Real.le_log_iff_exp_le (by norm_num : (0 : ℝ) < 3)]
    calc Real.exp (109861 / 100000 : ℝ) = Real.exp 1 * Real.exp (9861 / 100000 : ℝ) := by
          rw [show (109861 / 100000 : ℝ) = 1 + 9861 / 100000 by norm_num, Real.exp_add]
      _ ≤ 3 := le_of_lt hprod_lo
  · rw [Real.log_le_iff_le_exp (by norm_num : (0 : ℝ) < 3)]
    calc (3 : ℝ) ≤ Real.exp 1 * Real.exp (9862 / 100000 : ℝ) := le_of_lt hprod_hi
      _ = Real.exp (109862 / 100000 : ℝ) := by
          rw [show (109862 / 100000 : ℝ) = 1 + 9862 / 100000 by norm_num, Real.exp_add]

theorem sqrt_two_mem : (14142 / 10000 : ℝ) ≤ Real.sqrt 2 ∧ Real.sqrt 2 ≤ 14143 / 10000 := by
  have h2 : Real.sqrt 2 ^ 2 = 2 := Real.sq_sqrt (by norm_num)
  have hnn : (0 : ℝ) ≤ Real.sqrt 2 := Real.sqrt_nonneg 2
  constructor <;> nlinarith [h2, hnn]

theorem sqrt_pi_mem :
    (17724 / 10000 : ℝ) ≤ Real.sqrt Real.pi ∧ Real.sqrt Real.pi ≤ 17725 / 10000 := by
  have h2 : Real.sqrt Real.pi ^ 2 = Real.pi := Real.sq_sqrt Real.pi_pos.le
  have hnn : (0 : ℝ) ≤ Real.sqrt Real.pi := Real.sqrt_nonneg _
  constructor <;> nlinarith [h2, hnn, Real.pi_gt_d4, Real.pi_lt_d4]

theorem primeSummand_two (c : ℝ) :
    primeSummand c 2 =
      Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - c) ^ 2)) := by
  unfold primeSummand
  rw [gaussianBump_inv20, vonMangoldt_two]
  norm_num

theorem prime_sum_range_tail_le (c : ℝ) (hc : c ≤ 3 / 5) (N : ℕ) :
    ∑ n ∈ Finset.range N, primeSummand c (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
  calc ∑ n ∈ Finset.range N, primeSummand c (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail c hc n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-- The split of the full prime sum into the finite prefix and the tail. -/
theorem prime_sum_split (c : ℝ) (hc : c ≤ 3 / 5) :
    (∑' n : ℕ, primeSummand c n) =
      primeSummand c 2 + ∑' n : ℕ, primeSummand c (n + 3) := by
  have htail : Summable (fun n : ℕ => primeSummand c (n + 3)) :=
    summable_of_sum_range_le (fun n => primeSummand_nonneg c (n + 3))
      (fun N => prime_sum_range_tail_le c hc N)
  have hsum : Summable (fun n : ℕ => primeSummand c n) :=
    (summable_nat_add_iff 3).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 3
  have h0 : primeSummand c 0 = 0 := by
    unfold primeSummand
    simp
  have h1 : primeSummand c 1 = 0 := by
    unfold primeSummand
    simp
  have hprefix : ∑ n ∈ Finset.range 3, primeSummand c n = primeSummand c 2 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hprefix] at hsplit
  linarith [hsplit]

/-- `√π/20 ≤ 8863/10⁵`. -/
theorem sqrt_pi_div_twenty_le : Real.sqrt Real.pi / 20 ≤ 8863 / 100000 := by
  have h := sqrt_pi_mem.2
  linarith

/-- The tail is below `2.51·10⁻⁷`. -/
theorem sum_tail_le_rat (c : ℝ) (hc : c ≤ 3 / 5) :
    ∑' n : ℕ, primeSummand c (n + 3) ≤ 251 / 1000000000 := by
  refine le_trans (sum_tail_le c hc) ?_
  have hB := sqrt_pi_div_twenty_le
  have h1 : Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) ≤
      (8863 / 100000 : ℝ) * ((3 : ℝ) ^ 11)⁻¹ * (1 / 2) := by
    apply mul_le_mul_of_nonneg_right _ (by norm_num)
    exact mul_le_mul_of_nonneg_right hB (by positivity)
  refine le_trans h1 ?_
  norm_num

/-- Case `c ≤ 2/5`: the `n = 2` term is below `1.061·10⁻⁵`, so the prime term is
in `[−2.2·10⁻⁵, 0]`. -/
theorem primeTerm_mem_small {c : ℝ} (hc : c ≤ 2 / 5) :
    (-22 / 1000000 : ℝ) ≤ primeTerm c (1 / 20) ∧ primeTerm c (1 / 20) ≤ 0 := by
  have hc3 : c ≤ 3 / 5 := by linarith
  have hsplit := prime_sum_split c hc3
  have htail := sum_tail_le_rat c hc3
  have hnn : 0 ≤ ∑' n : ℕ, primeSummand c n :=
    tsum_nonneg (fun n => primeSummand_nonneg c n)
  -- the Gaussian factor at `n = 2`
  have hE : Real.exp (-100 * (Real.log 2 - c) ^ 2) ≤ 1 / 4096 := by
    have hl := log_two_mem.1
    have hx : (29314718 / 100000000 : ℝ) ≤ Real.log 2 - c := by linarith
    have hx0 : (0 : ℝ) ≤ 29314718 / 100000000 := by norm_num
    have hsq : (29314718 / 100000000 : ℝ) ^ 2 ≤ (Real.log 2 - c) ^ 2 := by
      nlinarith [hx, hx0]
    have he : (8593 / 1000 : ℝ) ≤ 100 * (Real.log 2 - c) ^ 2 := by nlinarith
    have h1 : Real.exp (-100 * (Real.log 2 - c) ^ 2) ≤ Real.exp (-(8593 / 1000)) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : Real.exp (-(8593 / 1000) : ℝ) ≤ 1 / 4096 := by
      have hlog := log_two_mem.2
      have h3 : Real.exp (12 * Real.log 2) ≤ Real.exp (8593 / 1000) :=
        Real.exp_le_exp.mpr (by nlinarith)
      have h4 : Real.exp (12 * Real.log 2) = 4096 := by
        rw [show (12 : ℝ) * Real.log 2 = Real.log 2 * 12 by ring]
        rw [← Real.rpow_def_of_pos (by norm_num : (0 : ℝ) < 2) (12 : ℝ)]
        norm_num
      rw [Real.exp_neg, ← one_div]
      exact one_div_le_one_div_of_le (by positivity) (by linarith [h3, h4])
    linarith [h1, h2]
  have hf2 : primeSummand c 2 ≤ 1061 / 100000000 := by
    rw [primeSummand_two]
    have hA : Real.log 2 / Real.sqrt 2 ≤ 4902 / 10000 := by
      have hl := log_two_mem.2
      have hs := sqrt_two_mem.1
      rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt 2)]
      nlinarith [hl, hs]
    have hA0 : (0 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
      apply div_nonneg (by linarith [log_two_mem.1]) (by positivity)
    have hB := sqrt_pi_div_twenty_le
    calc Real.log 2 / Real.sqrt 2 *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - c) ^ 2))
        ≤ (4902 / 10000 : ℝ) * ((8863 / 100000 : ℝ) * (1 / 4096)) := by
          apply mul_le_mul hA ?_ (by positivity) (by linarith)
          exact mul_le_mul hB hE (by positivity) (by positivity)
      _ ≤ 1061 / 100000000 := by norm_num
  have hbound : ∑' n : ℕ, primeSummand c n ≤ 11 / 1000000 := by
    rw [hsplit]
    linarith [hf2, htail]
  have hrw : primeTerm c (1 / 20) = -2 * ∑' n : ℕ, primeSummand c n := primeTerm_eq_inv20 c
  constructor
  · rw [hrw]; linarith [hbound]
  · rw [hrw]; linarith [hnn]

theorem sqrt_pi_div_twenty_le_close : Real.sqrt Real.pi / 20 ≤ 88625 / 1000000 := by
  have h := sqrt_pi_mem.2
  linarith

theorem sqrt_pi_div_twenty_ge : (8862 / 100000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by
  have h := sqrt_pi_mem.1
  linarith

/-- Case `c = 3/5`: the `n = 2` term is the whole sum. -/
theorem primeTerm_mem_three_fifths :
    (-36490 / 1000000 : ℝ) ≤ primeTerm (3 / 5) (1 / 20) ∧
      primeTerm (3 / 5) (1 / 20) ≤ -3646 / 100000 := by
  have hc : (3 / 5 : ℝ) ≤ 3 / 5 := le_rfl
  have hsplit := prime_sum_split (3 / 5) hc
  have htail := sum_tail_le_rat (3 / 5) hc
  -- exponent range
  have hxlo : (9314718 / 100000000 : ℝ) ≤ Real.log 2 - 3 / 5 := by
    linarith [log_two_mem.1]
  have hxhi : Real.log 2 - 3 / 5 ≤ 9314719 / 100000000 := by
    linarith [log_two_mem.2]
  have hx0 : (0 : ℝ) ≤ 9314718 / 100000000 := by norm_num
  have hpos : (0 : ℝ) ≤ Real.log 2 - 3 / 5 := by linarith [hxlo]
  have hsqlo : (9314718 / 100000000 : ℝ) ^ 2 ≤ (Real.log 2 - 3 / 5) ^ 2 := by
    rw [pow_two, pow_two]
    exact mul_self_le_mul_self hx0 hxlo
  have hsqhi : (Real.log 2 - 3 / 5) ^ 2 ≤ (9314719 / 100000000 : ℝ) ^ 2 := by
    rw [pow_two, pow_two]
    exact mul_self_le_mul_self hpos hxhi
  have helo : (8676397 / 10000000 : ℝ) ≤ 100 * (Real.log 2 - 3 / 5) ^ 2 := by
    nlinarith [hsqlo]
  have hehi : 100 * (Real.log 2 - 3 / 5) ^ 2 ≤ 86763991 / 100000000 := by
    nlinarith [hsqhi]
  -- exp bounds from the Taylor remainder
  have hexplo : (4199414 / 10000000 : ℝ) ≤ Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) := by
    have h1 : Real.exp (-(86763991 / 100000000 : ℝ)) ≤
        Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : (4199414 / 10000000 : ℝ) ≤ Real.exp (-(86763991 / 100000000 : ℝ)) := by
      have hx : |(-(86763991 / 100000000 : ℝ))| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      linarith [h.1]
    exact le_trans h2 h1
  have hexphi : Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) ≤ (4199417 / 10000000 : ℝ) := by
    have h1 : Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2) ≤
        Real.exp (-(8676397 / 10000000 : ℝ)) :=
      Real.exp_le_exp.mpr (by linarith)
    have h2 : Real.exp (-(8676397 / 10000000 : ℝ)) ≤ (4199417 / 10000000 : ℝ) := by
      have hx : |(-(8676397 / 10000000 : ℝ))| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      linarith [h.2]
    exact le_trans h1 h2
  -- the `n = 2` term
  have hAlo : (4900 / 10000 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [le_div_iff₀ hs]
    have hp : (4900 / 10000 : ℝ) * Real.sqrt 2 ≤ (4900 / 10000) * (14143 / 10000) :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.2 (by norm_num)
    nlinarith [hp, log_two_mem.1]
  have hAhi : Real.log 2 / Real.sqrt 2 ≤ 4902 / 10000 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [div_le_iff₀ hs]
    have hp : (4902 / 10000 : ℝ) * (14142 / 10000) ≤ (4902 / 10000) * Real.sqrt 2 :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.1 (by norm_num)
    nlinarith [hp, log_two_mem.2]
  have hf2lo : (18235 / 1000000 : ℝ) ≤ primeSummand (3 / 5) 2 := by
    rw [primeSummand_two]
    calc (18235 / 1000000 : ℝ) ≤
          (4900 / 10000 : ℝ) * ((8862 / 100000 : ℝ) * (4199414 / 10000000)) := by norm_num
      _ ≤ Real.log 2 / Real.sqrt 2 *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2)) := by
          apply mul_le_mul hAlo ?_ (by norm_num) (by linarith)
          exact mul_le_mul sqrt_pi_div_twenty_ge hexplo (by norm_num) (by positivity)
  have hf2hi : primeSummand (3 / 5) 2 ≤ 18244 / 1000000 := by
    rw [primeSummand_two]
    calc Real.log 2 / Real.sqrt 2 *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 3 / 5) ^ 2))
        ≤ (4902 / 10000 : ℝ) * ((88625 / 1000000 : ℝ) * (4199417 / 10000000)) := by
          apply mul_le_mul hAhi ?_ (by positivity) (by norm_num)
          exact mul_le_mul sqrt_pi_div_twenty_le_close hexphi (by positivity) (by positivity)
      _ ≤ 18244 / 1000000 := by norm_num
  have htail0 : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (3 / 5) (n + 3) :=
    tsum_nonneg (fun n => primeSummand_nonneg (3 / 5) (n + 3))
  have hupper : ∑' n : ℕ, primeSummand (3 / 5) n ≤
      18244 / 1000000 + 251 / 1000000000 := by
    rw [hsplit]
    linarith [hf2hi, htail]
  have hlower : (18235 / 1000000 : ℝ) ≤ ∑' n : ℕ, primeSummand (3 / 5) n := by
    rw [hsplit]
    linarith [hf2lo, htail0]
  have hrw := primeTerm_eq_inv20 (3 / 5)
  constructor
  · rw [hrw]; linarith [hupper]
  · rw [hrw]; linarith [hlower]

/-! ## The fifth separation `c = 4/5`

For `x ≥ log 3` the domination `exp(−100(x−c)²) ≤ exp(−14x)` fails at
`c = 4/5`; the replacement is `exp(−100(x−4/5)²) ≤ exp(−8x)`, which is the
polynomial inequality `25x² − 42x + 16 ≥ 0` on `[1.0962, ∞)`.  The tail is then
dominated by `Σ n⁻⁷` and the `n = 2` term is evaluated by a two-step squaring
chain: `exp(−y) = (exp(−y/4))⁴` with `y = 100(log 2 − 4/5)² ≈ 1.14175`. -/

/-- For `x ≥ log 3`, `exp(−100 (x − 4/5)²) ≤ exp(−8 x)`. -/
theorem exp_decay_le_four_fifths {x : ℝ} (hx : Real.log 3 ≤ x) :
    Real.exp (-100 * (x - 4 / 5) ^ 2) ≤ Real.exp (-8 * x) := by
  have hx' : (10962 / 10000 : ℝ) ≤ x := by
    have h3 : (1.0986122885 : ℝ) < Real.log 3 := Real.log_three_gt_d9
    linarith
  have hfac : 25 * x ^ 2 - 42 * x + 16
      = 25 * (x - 10962 / 10000) * (x + 10962 / 10000)
        - 42 * (x - 10962 / 10000)
        + (25 * (10962 / 10000) ^ 2 - 42 * (10962 / 10000) + 16) := by ring
  have hpoly : 0 ≤ 25 * x ^ 2 - 42 * x + 16 := by
    rw [hfac]
    have h1 : (0 : ℝ) ≤ x - 10962 / 10000 := by linarith
    have h2 : (0 : ℝ) ≤ 25 * (x + 10962 / 10000) - 42 := by nlinarith
    have h3 : (0 : ℝ) ≤ 25 * (10962 / 10000) ^ 2 - 42 * (10962 / 10000) + 16 := by
      norm_num
    nlinarith [mul_nonneg h1 h2]
  have harg : -100 * (x - 4 / 5) ^ 2 ≤ -8 * x := by nlinarith
  exact Real.exp_le_exp.mpr harg

/-- `exp(−8 log n) = ((n)⁸)⁻¹` for `n > 0`. -/
theorem exp_neg_log_eight (n : ℕ) (hn : 0 < (n : ℝ)) :
    Real.exp (-8 * Real.log n) = (((n : ℝ) ^ 8)⁻¹) := by
  have h1 : Real.exp (-8 * Real.log n) = (n : ℝ) ^ (-8 : ℝ) := by
    rw [Real.rpow_def_of_pos hn]
    congr 1
    ring
  rw [h1, show (-8 : ℝ) = -((8 : ℕ) : ℝ) by norm_num, Real.rpow_neg (le_of_lt hn),
    Real.rpow_natCast]

/-- The pointwise bound `Λ(n)/√n · bump ≤ (√π/20)·n⁻⁷` for `n ≥ 3` at `c = 4/5`. -/
theorem primeSummand_le_four_fifths {n : ℕ} (hn : 3 ≤ n) :
    primeSummand (4 / 5) n ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 7)⁻¹) := by
  unfold primeSummand
  rw [gaussianBump_inv20]
  have hnpos : (0 : ℝ) < n := by
    have : (3 : ℝ) ≤ n := by exact_mod_cast hn
    linarith
  have hΛ0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n :=
    ArithmeticFunction.vonMangoldt_nonneg
  have hΛle : ArithmeticFunction.vonMangoldt n ≤ Real.log n :=
    ArithmeticFunction.vonMangoldt_le_log
  have hlog1 : 1 ≤ Real.log n := log_ge_one_of_three_le hn
  have hlog3 : Real.log 3 ≤ Real.log n :=
    Real.log_le_log (by norm_num) (by exact_mod_cast hn)
  have hsqrt1 : (1 : ℝ) ≤ Real.sqrt n := by
    rw [show (1 : ℝ) = Real.sqrt 1 by simp]
    exact Real.sqrt_le_sqrt (by exact_mod_cast hn.trans' (by norm_num : (1:ℕ) ≤ 3))
  have hcoef : ArithmeticFunction.vonMangoldt n / Real.sqrt n ≤ Real.log n := by
    rw [div_le_iff₀ (by linarith : (0 : ℝ) < Real.sqrt n)]
    have hb : Real.log n ≤ Real.log n * Real.sqrt n := by
      calc Real.log n = Real.log n * 1 := by ring
        _ ≤ Real.log n * Real.sqrt n :=
            mul_le_mul_of_nonneg_left hsqrt1 (by linarith)
    linarith [hΛle, hb]
  have hexp : Real.exp (-100 * (Real.log n - 4 / 5) ^ 2) ≤ (((n : ℝ) ^ 8)⁻¹) := by
    have h := exp_decay_le_four_fifths hlog3
    rwa [exp_neg_log_eight n hnpos] at h
  have hS0 : (0 : ℝ) ≤ ArithmeticFunction.vonMangoldt n / Real.sqrt n :=
    div_nonneg hΛ0 (by positivity)
  have hlog8 : Real.log n * (((n : ℝ) ^ 8)⁻¹) ≤ (((n : ℝ) ^ 7)⁻¹) := by
    have hkey : (n : ℝ) * (((n : ℝ) ^ 8)⁻¹) = (((n : ℝ) ^ 7)⁻¹) := by
      field_simp
    have hlogle : Real.log n ≤ (n : ℝ) := by
      have h := Real.log_le_sub_one_of_pos hnpos
      linarith
    calc Real.log n * (((n : ℝ) ^ 8)⁻¹)
        ≤ (n : ℝ) * (((n : ℝ) ^ 8)⁻¹) := by
          apply mul_le_mul_of_nonneg_right hlogle (by positivity)
      _ = (((n : ℝ) ^ 7)⁻¹) := hkey
  have h8 : (0 : ℝ) ≤ (((n : ℝ) ^ 8)⁻¹) := by positivity
  calc ArithmeticFunction.vonMangoldt n / Real.sqrt n *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log n - 4 / 5) ^ 2))
      = (ArithmeticFunction.vonMangoldt n / Real.sqrt n) *
          (Real.sqrt Real.pi / 20) * Real.exp (-100 * (Real.log n - 4 / 5) ^ 2) := by ring
    _ ≤ Real.log n * (Real.sqrt Real.pi / 20) * (((n : ℝ) ^ 8)⁻¹) := by
        apply mul_le_mul (mul_le_mul hcoef (le_refl _) (by positivity) (by linarith)) hexp
          (by positivity) (by positivity)
    _ = Real.sqrt Real.pi / 20 * (Real.log n * (((n : ℝ) ^ 8)⁻¹)) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 7)⁻¹) := by
        apply mul_le_mul_of_nonneg_left hlog8 (by positivity)

/-- The tail summand comparison at `c = 4/5`. -/
theorem primeSummand_le_tail_four_fifths (n : ℕ) :
    primeSummand (4 / 5) (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 n - tele2 (n + 1)) := by
  have h1 : primeSummand (4 / 5) (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 7)⁻¹) := by
    have h := primeSummand_le_four_fifths (n := n + 3) (by omega)
    simpa using h
  have hm : (3 : ℝ) ≤ (n : ℝ) + 3 := by
    have : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  have h3 : ((((n : ℝ) + 3) ^ 5)⁻¹) ≤ ((3 : ℝ) ^ 5)⁻¹ := by
    rw [inv_eq_one_div, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (pow_le_pow_left₀ (by norm_num) hm 5)
  have hm7 : ((((n : ℝ) + 3) ^ 7)⁻¹) =
      ((((n : ℝ) + 3) ^ 5)⁻¹) * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [← mul_inv]
    congr 1
    ring
  have h2 : ((((n : ℝ) + 3) ^ 7)⁻¹) ≤
      ((3 : ℝ) ^ 5)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by
    rw [hm7]
    exact mul_le_mul_of_nonneg_right h3 (by positivity)
  have h4 : ((((n : ℝ) + 3) ^ 2)⁻¹) ≤ tele2 n - tele2 (n + 1) := by
    rw [tele2_sub, inv_eq_one_div]
    exact one_div_le_one_div_of_le (by positivity) (by nlinarith)
  calc primeSummand (4 / 5) (n + 3)
      ≤ Real.sqrt Real.pi / 20 * ((((n : ℝ) + 3) ^ 7)⁻¹) := h1
    _ ≤ Real.sqrt Real.pi / 20 * (((3 : ℝ) ^ 5)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹)) :=
        mul_le_mul_of_nonneg_left h2 (by positivity)
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * ((((n : ℝ) + 3) ^ 2)⁻¹) := by ring
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 n - tele2 (n + 1)) :=
        mul_le_mul_of_nonneg_left h4 (by positivity)

/-- **The prime tail at `c = 4/5` is below `(√π/20)·3⁻⁵/2 ≈ 1.83·10⁻⁴`.** -/
theorem sum_tail_le_four_fifths :
    ∑' n : ℕ, primeSummand (4 / 5) (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) := by
  refine Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg (4 / 5) (n + 3)) (fun N => ?_)
  calc ∑ n ∈ Finset.range N, primeSummand (4 / 5) (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail_four_fifths n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-- The tail is below `1.83·10⁻⁴`. -/
theorem sum_tail_le_rat_four_fifths :
    ∑' n : ℕ, primeSummand (4 / 5) (n + 3) ≤ 183 / 1000000 := by
  refine le_trans sum_tail_le_four_fifths ?_
  have hB := sqrt_pi_div_twenty_le
  have h1 : Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) ≤
      (8863 / 100000 : ℝ) * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) := by
    apply mul_le_mul_of_nonneg_right _ (by norm_num)
    exact mul_le_mul_of_nonneg_right hB (by positivity)
  refine le_trans h1 ?_
  norm_num

/-- The finite-range tail bound at `c = 4/5`. -/
theorem prime_sum_range_tail_le_four_fifths (N : ℕ) :
    ∑ n ∈ Finset.range N, primeSummand (4 / 5) (n + 3) ≤
      Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) := by
  calc ∑ n ∈ Finset.range N, primeSummand (4 / 5) (n + 3)
      ≤ ∑ n ∈ Finset.range N,
          Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 n - tele2 (n + 1)) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail_four_fifths n
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ *
          ∑ n ∈ Finset.range N, (tele2 n - tele2 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (tele2 0 - tele2 N) := by
        rw [sum_tele2]
    _ ≤ Real.sqrt Real.pi / 20 * ((3 : ℝ) ^ 5)⁻¹ * (1 / 2) := by
        have hN : 0 ≤ tele2 N := tele2_nonneg N
        have h0 : tele2 0 = 1 / 2 := by unfold tele2; norm_num
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

/-- The split of the prime sum at `c = 4/5`. -/
theorem prime_sum_split_four_fifths :
    (∑' n : ℕ, primeSummand (4 / 5) n) =
      primeSummand (4 / 5) 2 + ∑' n : ℕ, primeSummand (4 / 5) (n + 3) := by
  have htail : Summable (fun n : ℕ => primeSummand (4 / 5) (n + 3)) :=
    summable_of_sum_range_le (fun n => primeSummand_nonneg (4 / 5) (n + 3))
      (fun N => prime_sum_range_tail_le_four_fifths N)
  have hsum : Summable (fun n : ℕ => primeSummand (4 / 5) n) :=
    (summable_nat_add_iff 3).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 3
  have h0 : primeSummand (4 / 5) 0 = 0 := by unfold primeSummand; simp
  have h1 : primeSummand (4 / 5) 1 = 0 := by unfold primeSummand; simp
  have hprefix : ∑ n ∈ Finset.range 3, primeSummand (4 / 5) n = primeSummand (4 / 5) 2 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hprefix] at hsplit
  linarith [hsplit]

/-! ### The `n = 2` term: `exp(−1.14175…)` by two squarings -/

/-- `exp(−11417523/10⁷) ∈ [0.319259080, 0.319259098]`. -/
theorem exp_neg_11417523_mem :
    Real.exp (-(11417523 / 10000000 : ℝ)) ∈
      Set.Icc (319259080 / 1000000000 : ℝ) (319259098 / 1000000000) := by
  have hbase : Real.exp (-(11417523 / 40000000 : ℝ)) ∈
      Set.Icc (75168488 / 100000000 : ℝ) (75168489 / 100000000) := by
    have hb := Real.exp_bound (x := (-(11417523 / 40000000 : ℝ)))
      (by norm_num) (n := 10) (by norm_num)
    have heps0 : |(-(11417523 / 40000000 : ℝ))| ^ 10 *
        ((↑(Nat.succ 10) : ℝ) / ((Nat.factorial 10 : ℝ) * (↑10))) ≤ (1 : ℝ) / (10 ^ 9 : ℝ) := by
      norm_num [Nat.factorial]
    have h1 : (75168488 / 100000000 : ℝ) ≤
        (∑ k ∈ Finset.range 10, (-(11417523 / 40000000 : ℝ)) ^ k / (k.factorial : ℝ)) -
          (1 : ℝ) / (10 ^ 9 : ℝ) := by
      norm_num [Finset.sum_range_succ, Nat.factorial]
    have h2 : (∑ k ∈ Finset.range 10, (-(11417523 / 40000000 : ℝ)) ^ k / (k.factorial : ℝ)) +
        (1 : ℝ) / (10 ^ 9 : ℝ) ≤ (75168489 / 100000000 : ℝ) := by
      norm_num [Finset.sum_range_succ, Nat.factorial]
    rw [abs_le] at hb
    constructor <;> linarith [hb.1, hb.2, heps0, h1, h2]
  have hpow : Real.exp (-(11417523 / 10000000 : ℝ)) =
      (Real.exp (-(11417523 / 40000000 : ℝ))) ^ 4 := by
    rw [show -(11417523 / 10000000 : ℝ) = ((4 : ℕ) : ℝ) * (-(11417523 / 40000000 : ℝ)) by
      norm_num]
    rw [Real.exp_nat_mul]
  rw [hpow]
  obtain ⟨h1, h2⟩ := hbase
  have hs2 : (Real.exp (-(11417523 / 40000000 : ℝ))) ^ 2 ∈
      Set.Icc ((75168488 / 100000000 : ℝ) ^ 2) ((75168489 / 100000000 : ℝ) ^ 2) := by
    constructor
    · exact pow_le_pow_left₀ (by norm_num) h1 2
    · exact pow_le_pow_left₀ (by positivity) h2 2
  obtain ⟨h3, h4⟩ := hs2
  have hs4 : ((Real.exp (-(11417523 / 40000000 : ℝ))) ^ 2) ^ 2 ∈
      Set.Icc (((75168488 / 100000000 : ℝ) ^ 2) ^ 2)
        (((75168489 / 100000000 : ℝ) ^ 2) ^ 2) := by
    constructor
    · exact pow_le_pow_left₀ (by positivity) h3 2
    · exact pow_le_pow_left₀ (by positivity) h4 2
  obtain ⟨h5, h6⟩ := hs4
  constructor
  · have h7 : (319259080 / 1000000000 : ℝ) ≤
        ((75168488 / 100000000 : ℝ) ^ 2) ^ 2 := by norm_num
    linarith
  · have h7 : ((75168489 / 100000000 : ℝ) ^ 2) ^ 2 ≤
        (319259098 / 1000000000 : ℝ) := by norm_num
    linarith

/-- `exp(−11417526/10⁷) ∈ [0.319258978, 0.319259030]`. -/
theorem exp_neg_11417526_mem :
    Real.exp (-(11417526 / 10000000 : ℝ)) ∈
      Set.Icc (319258978 / 1000000000 : ℝ) (319259030 / 1000000000) := by
  have hbase : Real.exp (-(11417526 / 40000000 : ℝ)) ∈
      Set.Icc (75168482 / 100000000 : ℝ) (75168485 / 100000000) := by
    have hb := Real.exp_bound (x := (-(11417526 / 40000000 : ℝ)))
      (by norm_num) (n := 10) (by norm_num)
    have heps0 : |(-(11417526 / 40000000 : ℝ))| ^ 10 *
        ((↑(Nat.succ 10) : ℝ) / ((Nat.factorial 10 : ℝ) * (↑10))) ≤ (1 : ℝ) / (10 ^ 9 : ℝ) := by
      norm_num [Nat.factorial]
    have h1 : (75168482 / 100000000 : ℝ) ≤
        (∑ k ∈ Finset.range 10, (-(11417526 / 40000000 : ℝ)) ^ k / (k.factorial : ℝ)) -
          (1 : ℝ) / (10 ^ 9 : ℝ) := by
      norm_num [Finset.sum_range_succ, Nat.factorial]
    have h2 : (∑ k ∈ Finset.range 10, (-(11417526 / 40000000 : ℝ)) ^ k / (k.factorial : ℝ)) +
        (1 : ℝ) / (10 ^ 9 : ℝ) ≤ (75168485 / 100000000 : ℝ) := by
      norm_num [Finset.sum_range_succ, Nat.factorial]
    rw [abs_le] at hb
    constructor <;> linarith [hb.1, hb.2, heps0, h1, h2]
  have hpow : Real.exp (-(11417526 / 10000000 : ℝ)) =
      (Real.exp (-(11417526 / 40000000 : ℝ))) ^ 4 := by
    rw [show -(11417526 / 10000000 : ℝ) = ((4 : ℕ) : ℝ) * (-(11417526 / 40000000 : ℝ)) by
      norm_num]
    rw [Real.exp_nat_mul]
  rw [hpow]
  obtain ⟨h1, h2⟩ := hbase
  have hs2 : (Real.exp (-(11417526 / 40000000 : ℝ))) ^ 2 ∈
      Set.Icc ((75168482 / 100000000 : ℝ) ^ 2) ((75168485 / 100000000 : ℝ) ^ 2) := by
    constructor
    · exact pow_le_pow_left₀ (by norm_num) h1 2
    · exact pow_le_pow_left₀ (by positivity) h2 2
  obtain ⟨h3, h4⟩ := hs2
  have hs4 : ((Real.exp (-(11417526 / 40000000 : ℝ))) ^ 2) ^ 2 ∈
      Set.Icc (((75168482 / 100000000 : ℝ) ^ 2) ^ 2)
        (((75168485 / 100000000 : ℝ) ^ 2) ^ 2) := by
    constructor
    · exact pow_le_pow_left₀ (by positivity) h3 2
    · exact pow_le_pow_left₀ (by positivity) h4 2
  obtain ⟨h5, h6⟩ := hs4
  constructor
  · have h7 : (319258978 / 1000000000 : ℝ) ≤
        ((75168482 / 100000000 : ℝ) ^ 2) ^ 2 := by norm_num
    linarith
  · have h7 : ((75168485 / 100000000 : ℝ) ^ 2) ^ 2 ≤
        (319259030 / 1000000000 : ℝ) := by norm_num
    linarith

/-- `100 (log 2 − 4/5)² ∈ [11417523/10⁷, 11417526/10⁷]`. -/
theorem y_mem_four_fifths :
    (11417523 / 10000000 : ℝ) ≤ 100 * (Real.log 2 - 4 / 5) ^ 2 ∧
      100 * (Real.log 2 - 4 / 5) ^ 2 ≤ 11417526 / 10000000 := by
  have hxlo : (-10685282 / 100000000 : ℝ) ≤ Real.log 2 - 4 / 5 := by
    linarith [log_two_mem.1]
  have hxhi : Real.log 2 - 4 / 5 ≤ -10685281 / 100000000 := by
    linarith [log_two_mem.2]
  have hxneg : Real.log 2 - 4 / 5 < 0 := by linarith
  have habs : |Real.log 2 - 4 / 5| ∈
      Set.Icc (10685281 / 100000000 : ℝ) (10685282 / 100000000) := by
    rw [abs_of_neg hxneg]
    constructor <;> linarith
  have hsqlo : (10685281 / 100000000 : ℝ) ^ 2 ≤ (Real.log 2 - 4 / 5) ^ 2 := by
    have h := pow_le_pow_left₀ (by norm_num) habs.1 2
    simpa [sq_abs] using h
  have hsqhi : (Real.log 2 - 4 / 5) ^ 2 ≤ (10685282 / 100000000 : ℝ) ^ 2 := by
    have h := pow_le_pow_left₀ (by norm_num) habs.2 2
    simpa [sq_abs] using h
  constructor <;> nlinarith

/-- `exp(−100 (log 2 − 4/5)²) ∈ [0.319258978, 0.319259098]`. -/
theorem exp_two_four_fifths :
    Real.exp (-100 * (Real.log 2 - 4 / 5) ^ 2) ∈
      Set.Icc (319258978 / 1000000000 : ℝ) (319259098 / 1000000000) := by
  obtain ⟨hy1, hy2⟩ := y_mem_four_fifths
  constructor
  · have h : Real.exp (-(11417526 / 10000000 : ℝ)) ≤
        Real.exp (-100 * (Real.log 2 - 4 / 5) ^ 2) :=
      Real.exp_le_exp.mpr (by linarith)
    exact le_trans exp_neg_11417526_mem.1 h
  · have h : Real.exp (-100 * (Real.log 2 - 4 / 5) ^ 2) ≤
        Real.exp (-(11417523 / 10000000 : ℝ)) :=
      Real.exp_le_exp.mpr (by linarith)
    exact le_trans h exp_neg_11417523_mem.2

/-- The `n = 2` summand at `c = 4/5` lies in `[0.013863, 0.013870]`. -/
theorem primeSummand_two_four_fifths :
    (13863 / 1000000 : ℝ) ≤ primeSummand (4 / 5) 2 ∧
      primeSummand (4 / 5) 2 ≤ 13870 / 1000000 := by
  have hAlo : (49 / 100 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [le_div_iff₀ hs]
    have hp : (49 / 100 : ℝ) * Real.sqrt 2 ≤ (49 / 100) * (14143 / 10000) :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.2 (by norm_num)
    nlinarith [hp, log_two_mem.1]
  have hAhi : Real.log 2 / Real.sqrt 2 ≤ 4902 / 10000 := by
    have hs : (0 : ℝ) < Real.sqrt 2 := by linarith [sqrt_two_mem.1]
    rw [div_le_iff₀ hs]
    have hp : (4902 / 10000 : ℝ) * (14142 / 10000) ≤ (4902 / 10000) * Real.sqrt 2 :=
      mul_le_mul_of_nonneg_left sqrt_two_mem.1 (by norm_num)
    nlinarith [hp, log_two_mem.2]
  rw [primeSummand_two]
  constructor
  · calc (13863 / 1000000 : ℝ) ≤
        (49 / 100 : ℝ) * ((8862 / 100000 : ℝ) * (319258978 / 1000000000)) := by norm_num
      _ ≤ Real.log 2 / Real.sqrt 2 *
            (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 4 / 5) ^ 2)) := by
          apply mul_le_mul hAlo ?_ (by norm_num) (by linarith)
          exact mul_le_mul sqrt_pi_div_twenty_ge exp_two_four_fifths.1 (by norm_num)
            (by positivity)
  · calc Real.log 2 / Real.sqrt 2 *
          (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log 2 - 4 / 5) ^ 2))
        ≤ (4902 / 10000 : ℝ) * ((88625 / 1000000 : ℝ) * (319259098 / 1000000000)) := by
          apply mul_le_mul hAhi ?_ (by positivity) (by norm_num)
          exact mul_le_mul sqrt_pi_div_twenty_le_close exp_two_four_fifths.2 (by positivity)
            (by positivity)
      _ ≤ 13870 / 1000000 := by norm_num

/-- **The prime term at `c = 4/5`.**  The true value is `−0.0277501`; the
interval is ample for the `3.4·10⁻³` entry budget. -/
theorem primeTerm_mem_four_fifths :
    (-2811 / 100000 : ℝ) ≤ primeTerm (4 / 5) (1 / 20) ∧
      primeTerm (4 / 5) (1 / 20) ≤ -27726 / 1000000 := by
  have hsplit := prime_sum_split_four_fifths
  have htail := sum_tail_le_rat_four_fifths
  have hs2 := primeSummand_two_four_fifths
  have hnn : (0 : ℝ) ≤ ∑' n : ℕ, primeSummand (4 / 5) (n + 3) :=
    tsum_nonneg (fun n => primeSummand_nonneg (4 / 5) (n + 3))
  have hrw := primeTerm_eq_inv20 (4 / 5)
  constructor
  · rw [hrw, hsplit]; linarith [hs2.2, htail]
  · rw [hrw, hsplit]; linarith [hs2.1, hnn]

/-- `exp(−10 log n) = (n¹⁰)⁻¹`. -/
theorem exp_neg_ten_log (n : ℕ) (hn : 1 ≤ n) :
    Real.exp (-10 * Real.log (n : ℝ)) = ((n : ℝ) ^ 10)⁻¹ := by
  have hpos : (0 : ℝ) < n := by exact_mod_cast hn
  have h1 : Real.exp (-10 * Real.log (n : ℝ)) = (Real.exp (10 * Real.log (n : ℝ)))⁻¹ := by
    rw [show -10 * Real.log (n:ℝ) = -(10 * Real.log (n:ℝ)) by ring, Real.exp_neg]
  rw [h1, show (10 : ℝ) * Real.log (n:ℝ) = (10 : ℕ) * Real.log (n:ℝ) by norm_num,
    Real.exp_nat_mul, Real.exp_log hpos]

end PrimeSpectrumTensor

namespace PrimeSpectrumTensor

/-- `log 4 = 2 log 2` lower bound. -/
theorem log_four_ge : (138629436 / 100000000 : ℝ) ≤ Real.log 4 := by
  have h4 : Real.log 4 = 2 * Real.log 2 := by
    rw [show (4 : ℝ) = 2 * 2 by norm_num, Real.log_mul (by norm_num) (by norm_num)]
    ring
  rw [h4]
  linarith [log_two_mem.1]

/-- The `c = 1` Gaussian decay: for `x ≥ log 4`,
`exp(−100(x−1)²) ≤ exp(−10 x)`. -/
theorem exp_decay_c1 {x : ℝ} (hx : (138629436 / 100000000 : ℝ) ≤ x) :
    Real.exp (-100 * (x - 1) ^ 2) ≤ Real.exp (-10 * x) := by
  have hbase : (0 : ℝ) ≤ 100 * ((138629436 / 100000000 : ℝ) - 1) ^ 2 -
      10 * (138629436 / 100000000 : ℝ) := by norm_num
  have hfac : 0 ≤ (x - (138629436 / 100000000 : ℝ)) *
      (100 * (x + (138629436 / 100000000 : ℝ) - 2) - 10) := by
    apply mul_nonneg (by linarith)
    linarith
  have hineq : -100 * (x - 1) ^ 2 ≤ -10 * x := by
    nlinarith [hbase, hfac]
  exact Real.exp_le_exp.mpr hineq

theorem primeSummand_le_c1 (n : ℕ) (hn : 4 ≤ n) :
    primeSummand 1 n ≤ Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 9)⁻¹) := by
  have hn1 : 1 ≤ n := by omega
  have hpos : (0 : ℝ) < n := by exact_mod_cast hn1
  have hn0 : (0 : ℝ) ≤ n := le_of_lt hpos
  have hsqrt1 : (1 : ℝ) ≤ Real.sqrt (n : ℝ) := Real.one_le_sqrt.mpr (by exact_mod_cast hn1)
  have hspos : (0 : ℝ) < Real.sqrt (n : ℝ) := Real.sqrt_pos.mpr hpos
  have hlog : (138629436 / 100000000 : ℝ) ≤ Real.log (n : ℝ) := by
    have h4 : (4 : ℝ) ≤ n := by exact_mod_cast hn
    exact le_trans log_four_ge (Real.log_le_log (by norm_num) h4)
  have hexp : Real.exp (-100 * (Real.log (n : ℝ) - 1) ^ 2) ≤ ((n : ℝ) ^ 10)⁻¹ := by
    rw [← exp_neg_ten_log n hn1]
    exact exp_decay_c1 hlog
  have hΛ : (ArithmeticFunction.vonMangoldt n : ℝ) ≤ Real.log (n : ℝ) :=
    ArithmeticFunction.vonMangoldt_le_log
  have hΛn : (ArithmeticFunction.vonMangoldt n : ℝ) ≤ n := by
    calc (ArithmeticFunction.vonMangoldt n : ℝ) ≤ Real.log (n : ℝ) := hΛ
      _ ≤ n := by
          rw [Real.log_le_iff_le_exp (by exact_mod_cast hn1 : (0:ℝ) < n)]
          linarith [Real.add_one_le_exp (n : ℝ)]
  have hdiv : (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt (n : ℝ) ≤ n := by
    rw [div_le_iff₀ hspos]
    calc (ArithmeticFunction.vonMangoldt n : ℝ) ≤ n := hΛn
      _ ≤ n * Real.sqrt (n : ℝ) := by nlinarith
  have hexp10 : (0 : ℝ) ≤ ((n : ℝ) ^ 10)⁻¹ := by positivity
  have hmain : (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt (n : ℝ) *
      (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log (n : ℝ) - 1) ^ 2))
      ≤ n * (Real.sqrt Real.pi / 20 * ((n : ℝ) ^ 10)⁻¹) := by
    apply mul_le_mul
    · exact hdiv
    · exact mul_le_mul_of_nonneg_left hexp (by positivity)
    · positivity
    · positivity
  have hpow : n * ((n : ℝ) ^ 10)⁻¹ = (((n : ℝ) ^ 9)⁻¹) := by
    field_simp
  rw [primeSummand, gaussianBump_inv20]
  calc (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt (n : ℝ) *
        (Real.sqrt Real.pi / 20 * Real.exp (-100 * (Real.log (n : ℝ) - 1) ^ 2))
      ≤ n * (Real.sqrt Real.pi / 20 * ((n : ℝ) ^ 10)⁻¹) := hmain
    _ = Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 9)⁻¹) := by
        calc n * (Real.sqrt Real.pi / 20 * ((n : ℝ) ^ 10)⁻¹)
            = Real.sqrt Real.pi / 20 * (n * ((n : ℝ) ^ 10)⁻¹) := by ring
          _ = Real.sqrt Real.pi / 20 * (((n : ℝ) ^ 9)⁻¹) := by rw [hpow]

def tele3 (n : ℕ) : ℝ := 1 / ((n : ℝ) + 3)

theorem tele3_sub (n : ℕ) :
    tele3 n - tele3 (n + 1) = 1 / (((n : ℝ) + 3) * ((n : ℝ) + 4)) := by
  unfold tele3
  push_cast
  field_simp
  ring

theorem sum_tele3 (N : ℕ) :
    ∑ n ∈ Finset.range N, (tele3 n - tele3 (n + 1)) = tele3 0 - tele3 N := by
  induction N with
  | zero => simp
  | succ N ih => rw [Finset.sum_range_succ, ih]; ring

theorem tele3_nonneg (n : ℕ) : 0 ≤ tele3 n := by unfold tele3; positivity

theorem primeSummand_le_tail_c1 (n : ℕ) :
    primeSummand 1 (n + 4) ≤
      Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (tele3 n - tele3 (n + 1)) := by
  have hnn : (0 : ℝ) ≤ (n : ℝ) := Nat.cast_nonneg n
  have hm : (4 : ℝ) ≤ (n : ℝ) + 4 := by linarith
  have hpos : (0 : ℝ) < (n : ℝ) + 4 := by linarith
  have h1 : primeSummand 1 (n + 4) ≤ Real.sqrt Real.pi / 20 * (1 / ((n : ℝ) + 4) ^ 9) := by
    have := primeSummand_le_c1 (n + 4) (by omega)
    simpa [one_div] using this
  have h2 : 1 / ((n : ℝ) + 4) ^ 9 ≤ (1 / (4 : ℝ) ^ 7) * (1 / ((n : ℝ) + 4) ^ 2) := by
    rw [show (1 / (4 : ℝ) ^ 7) * (1 / ((n : ℝ) + 4) ^ 2) =
        1 / ((4 : ℝ) ^ 7 * ((n : ℝ) + 4) ^ 2) by field_simp]
    apply one_div_le_one_div_of_le (by positivity)
    have h7 : (4 : ℝ) ^ 7 ≤ ((n : ℝ) + 4) ^ 7 := pow_le_pow_left₀ (by positivity) hm 7
    calc (4 : ℝ) ^ 7 * ((n : ℝ) + 4) ^ 2 ≤ ((n : ℝ) + 4) ^ 7 * ((n : ℝ) + 4) ^ 2 :=
          mul_le_mul_of_nonneg_right h7 (by positivity)
      _ = ((n : ℝ) + 4) ^ 9 := by ring
  have h3 : 1 / ((n : ℝ) + 4) ^ 2 ≤ 1 / (((n : ℝ) + 3) * ((n : ℝ) + 4)) := by
    apply one_div_le_one_div_of_le (by positivity)
    nlinarith
  have h4 : (1 / (4 : ℝ) ^ 7) * (1 / ((n : ℝ) + 4) ^ 2) ≤
      (1 / (4 : ℝ) ^ 7) * (1 / (((n : ℝ) + 3) * ((n : ℝ) + 4))) :=
    mul_le_mul_of_nonneg_left h3 (by positivity)
  rw [tele3_sub]
  calc primeSummand 1 (n + 4)
      ≤ Real.sqrt Real.pi / 20 * (1 / ((n : ℝ) + 4) ^ 9) := h1
    _ ≤ Real.sqrt Real.pi / 20 * ((1 / (4 : ℝ) ^ 7) * (1 / ((n : ℝ) + 4) ^ 2)) :=
        mul_le_mul_of_nonneg_left h2 (by positivity)
    _ ≤ Real.sqrt Real.pi / 20 * ((1 / (4 : ℝ) ^ 7) * (1 / (((n : ℝ) + 3) * ((n : ℝ) + 4)))) :=
        mul_le_mul_of_nonneg_left h4 (by positivity)
    _ = Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (1 / (((n : ℝ) + 3) * ((n : ℝ) + 4))) := by ring

theorem prime_sum_range_tail_le_c1 (N : ℕ) :
    ∑ n ∈ Finset.range N, primeSummand 1 (n + 4) ≤
      Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (1 / 3) := by
  calc ∑ n ∈ Finset.range N, primeSummand 1 (n + 4)
      ≤ ∑ n ∈ Finset.range N,
          (Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (tele3 n - tele3 (n + 1))) := by
        refine Finset.sum_le_sum fun n _ => ?_
        exact primeSummand_le_tail_c1 n
    _ = Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) *
          ∑ n ∈ Finset.range N, (tele3 n - tele3 (n + 1)) := by
        rw [Finset.mul_sum]
    _ = Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (tele3 0 - tele3 N) := by
        rw [sum_tele3]
    _ ≤ Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (1 / 3) := by
        have h0 : tele3 0 = 1 / 3 := by norm_num [tele3]
        have hN : 0 ≤ tele3 N := tele3_nonneg N
        apply mul_le_mul_of_nonneg_left _ (by positivity)
        rw [h0]
        linarith

theorem sum_tail_c1_le :
    ∑' n : ℕ, primeSummand 1 (n + 4) ≤
      Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (1 / 3) := by
  refine Real.tsum_le_of_sum_range_le (fun n => primeSummand_nonneg 1 (n + 4)) fun N => ?_
  exact prime_sum_range_tail_le_c1 N

theorem sqrt_three_mem :
    (173205 / 100000 : ℝ) ≤ Real.sqrt 3 ∧ Real.sqrt 3 ≤ 173206 / 100000 := by
  have h2 : Real.sqrt 3 ^ 2 = 3 := Real.sq_sqrt (by norm_num)
  have hnn : (0 : ℝ) ≤ Real.sqrt 3 := Real.sqrt_nonneg 3
  constructor <;> nlinarith [h2, hnn]

theorem vonMangoldt_three : ArithmeticFunction.vonMangoldt 3 = Real.log 3 :=
  ArithmeticFunction.vonMangoldt_apply_prime (by norm_num)

theorem primeSummand_three_c1_mem :
    (21230 / 1000000 : ℝ) ≤ primeSummand 1 3 ∧
      primeSummand 1 3 ≤ 21320 / 1000000 := by
  have hlog := log_three_mem
  have hs3 := sqrt_three_mem
  have hu_lo : (9861 / 100000 : ℝ) ≤ Real.log 3 - 1 := by linarith [hlog.1]
  have hu_hi : Real.log 3 - 1 ≤ 9862 / 100000 := by linarith [hlog.2]
  have hu0 : (0 : ℝ) ≤ Real.log 3 - 1 := by linarith [hlog.1]
  have hsq_lo : (9861 / 100000 : ℝ) ^ 2 ≤ (Real.log 3 - 1) ^ 2 := by
    rw [pow_two, pow_two]; exact mul_self_le_mul_self (by norm_num) hu_lo
  have hsq_hi : (Real.log 3 - 1) ^ 2 ≤ (9862 / 100000 : ℝ) ^ 2 := by
    rw [pow_two, pow_two]; exact mul_self_le_mul_self hu0 hu_hi
  have he_lo : (3780 / 10000 : ℝ) ≤ Real.exp (-(100 * (Real.log 3 - 1) ^ 2)) := by
    have h1 : Real.exp (-(9726 / 10000 : ℝ)) ≤ Real.exp (-(100 * (Real.log 3 - 1) ^ 2)) := by
      apply Real.exp_le_exp.mpr
      nlinarith [hsq_hi, (by norm_num : (9862 / 100000 : ℝ) ^ 2 * 100 < 9726 / 10000)]
    have h2 : (3780 / 10000 : ℝ) ≤ Real.exp (-(9726 / 10000 : ℝ)) := by
      have hx : |(-(9726 / 10000) : ℝ)| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      linarith [h.1]
    exact le_trans h2 h1
  have he_hi : Real.exp (-(100 * (Real.log 3 - 1) ^ 2)) ≤ (3783 / 10000 : ℝ) := by
    have h1 : Real.exp (-(100 * (Real.log 3 - 1) ^ 2)) ≤ Real.exp (-(9723 / 10000 : ℝ)) := by
      apply Real.exp_le_exp.mpr
      nlinarith [hsq_lo, (by norm_num : (9723 / 10000 : ℝ) < (9861 / 100000 : ℝ) ^ 2 * 100)]
    have h2 : Real.exp (-(9723 / 10000 : ℝ)) ≤ (3783 / 10000 : ℝ) := by
      have hx : |(-(9723 / 10000) : ℝ)| ≤ 1 := by norm_num
      have h := Real.exp_bound hx (n := 12) (by norm_num)
      simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
      norm_num at h
      rw [abs_le] at h
      have hle : Real.exp (-(9723 / 10000 : ℝ)) ≤
          2662613519357716543899263415319152046691609101019 / 7040000000000000000000000000000000000000000000000 +
          1818533111433947366215719554910588462098125491 / 1126400000000000000000000000000000000000000000000000000 := by
        linarith [h.2]
      calc Real.exp (-(9723 / 10000 : ℝ))
          ≤ 2662613519357716543899263415319152046691609101019 / 7040000000000000000000000000000000000000000000000 +
            1818533111433947366215719554910588462098125491 / 1126400000000000000000000000000000000000000000000000000 := hle
        _ ≤ 3783 / 10000 := by norm_num
    exact le_trans h1 h2
  have hpi_lo : (8862 / 100000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by
    have := sqrt_pi_mem.1; linarith
  have hpi_hi : Real.sqrt Real.pi / 20 ≤ (8863 / 100000 : ℝ) := by
    have := sqrt_pi_mem.2; linarith
  have hq_lo : (634 / 1000 : ℝ) ≤ Real.log 3 / Real.sqrt 3 := by
    rw [le_div_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3))]
    nlinarith [hlog.1, hs3.2]
  have hq_hi : Real.log 3 / Real.sqrt 3 ≤ (635 / 1000 : ℝ) := by
    rw [div_le_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 3))]
    nlinarith [hlog.2, hs3.1]
  have ht_lo : (21230 / 1000000 : ℝ) ≤
      Real.log 3 / Real.sqrt 3 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 3 - 1) ^ 2))) := by
    calc (21230 / 1000000 : ℝ) ≤ (634 / 1000) * ((8862 / 100000) * (3780 / 10000)) := by norm_num
      _ ≤ Real.log 3 / Real.sqrt 3 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 3 - 1) ^ 2))) := by
          gcongr
  have ht_hi : Real.log 3 / Real.sqrt 3 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 3 - 1) ^ 2))) ≤
      (21320 / 1000000 : ℝ) := by
    calc Real.log 3 / Real.sqrt 3 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 3 - 1) ^ 2)))
        ≤ (635 / 1000) * ((8863 / 100000) * (3783 / 10000)) := by
          gcongr
      _ ≤ (21320 / 1000000 : ℝ) := by norm_num
  rw [primeSummand, gaussianBump_inv20, vonMangoldt_three]
  constructor
  · simpa using ht_lo
  · simpa using ht_hi

theorem prime_sum_split_c1 :
    (∑' n : ℕ, primeSummand 1 n) =
      primeSummand 1 2 + primeSummand 1 3 + ∑' n : ℕ, primeSummand 1 (n + 4) := by
  have htail : Summable (fun n : ℕ => primeSummand 1 (n + 4)) :=
    summable_of_sum_range_le (fun n => primeSummand_nonneg 1 (n + 4))
      (fun N => prime_sum_range_tail_le_c1 N)
  have hsum : Summable (fun n : ℕ => primeSummand 1 n) := (summable_nat_add_iff 4).mp htail
  have hsplit := hsum.sum_add_tsum_nat_add 4
  have h0 : primeSummand 1 0 = 0 := by unfold primeSummand; simp
  have h1 : primeSummand 1 1 = 0 := by unfold primeSummand; simp
  have hprefix : ∑ n ∈ Finset.range 4, primeSummand 1 n =
      primeSummand 1 2 + primeSummand 1 3 := by
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, h0, h1]
    ring
  rw [hprefix] at hsplit
  linarith [hsplit]

theorem exp_nine_eq : Real.exp (9 : ℝ) = (Real.exp 1) ^ 9 := by
  rw [show (9 : ℝ) = (9 : ℕ) * 1 by norm_num, Real.exp_nat_mul]

theorem exp_neg_nine_le_c1 : Real.exp (-9 : ℝ) ≤ 1 / 8000 := by
  have he9 : (8000 : ℝ) ≤ (Real.exp 1) ^ 9 := by
    calc (8000 : ℝ) ≤ (2.7182818283 : ℝ) ^ 9 := by norm_num
      _ ≤ (Real.exp 1) ^ 9 := pow_le_pow_left₀ (by norm_num) (le_of_lt Real.exp_one_gt_d9) 9
  have hexp9 : Real.exp (-9 : ℝ) = ((Real.exp 1) ^ 9)⁻¹ := by
    rw [show (-9 : ℝ) = -(9 : ℝ) by norm_num, Real.exp_neg, exp_nine_eq]
  rw [hexp9, inv_eq_one_div]
  exact one_div_le_one_div_of_le (by norm_num) he9

theorem exp_neg_nine_half_ge_c1 : (1 / 14000 : ℝ) ≤ Real.exp (-(9.5) : ℝ) := by
  have he9 : (Real.exp 1) ^ 9 ≤ (2.7182818286 : ℝ) ^ 9 :=
    pow_le_pow_left₀ (by positivity) (le_of_lt Real.exp_one_lt_d9) 9
  have he9num : (2.7182818286 : ℝ) ^ 9 ≤ 8200 := by norm_num
  have hhalf : Real.exp (0.5 : ℝ) ≤ 1.65 := by
    have hx : |(0.5 : ℝ)| ≤ 1 := by norm_num
    have h := Real.exp_bound hx (n := 12) (by norm_num)
    simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
    norm_num at h
    rw [abs_le] at h
    linarith [h.2]
  have hexp95 : Real.exp (9.5 : ℝ) = Real.exp 9 * Real.exp 0.5 := by
    rw [show (9.5 : ℝ) = 9 + 0.5 by norm_num, Real.exp_add]
  have hle : Real.exp (9.5 : ℝ) ≤ 14000 := by
    rw [hexp95, exp_nine_eq]
    calc (Real.exp 1) ^ 9 * Real.exp 0.5 ≤ (2.7182818286 : ℝ) ^ 9 * 1.65 :=
          mul_le_mul he9 hhalf (by positivity) (by norm_num)
      _ ≤ 8200 * 1.65 := mul_le_mul_of_nonneg_right he9num (by norm_num)
      _ ≤ 14000 := by norm_num
  have hinv : Real.exp (-(9.5) : ℝ) = (Real.exp (9.5 : ℝ))⁻¹ := by
    rw [show (-(9.5) : ℝ) = -(9.5) by ring, Real.exp_neg]
  rw [hinv, inv_eq_one_div]
  exact one_div_le_one_div_of_le (Real.exp_pos _) hle

theorem primeSummand_two_c1_mem :
    (3 / 1000000 : ℝ) ≤ primeSummand 1 2 ∧
      primeSummand 1 2 ≤ 6 / 1000000 := by
  have hlog := log_two_mem
  have hs2 := sqrt_two_mem
  have hu_neg : Real.log 2 - 1 < 0 := by linarith [hlog.2]
  have habs_lo : (30685281 / 100000000 : ℝ) ≤ |Real.log 2 - 1| := by
    rw [abs_of_neg hu_neg]
    linarith [hlog.2]
  have habs_hi : |Real.log 2 - 1| ≤ (30685282 / 100000000 : ℝ) := by
    rw [abs_of_neg hu_neg]
    linarith [hlog.1]
  have hsq_lo : (94157 / 1000000 : ℝ) ≤ (Real.log 2 - 1) ^ 2 := by
    rw [← sq_abs]
    calc (94157 / 1000000 : ℝ) ≤ (30685281 / 100000000 : ℝ) ^ 2 := by norm_num
      _ ≤ |Real.log 2 - 1| ^ 2 := pow_le_pow_left₀ (by norm_num) habs_lo 2
  have hsq_hi : (Real.log 2 - 1) ^ 2 ≤ (94160 / 1000000 : ℝ) := by
    rw [← sq_abs]
    calc |Real.log 2 - 1| ^ 2 ≤ (30685282 / 100000000 : ℝ) ^ 2 :=
          pow_le_pow_left₀ (abs_nonneg _) habs_hi 2
      _ ≤ (94160 / 1000000 : ℝ) := by norm_num
  have h100_lo : (94157 / 10000 : ℝ) ≤ 100 * (Real.log 2 - 1) ^ 2 := by nlinarith [hsq_lo]
  have h100_hi : 100 * (Real.log 2 - 1) ^ 2 ≤ (94160 / 10000 : ℝ) := by nlinarith [hsq_hi]
  have hexp_hi : Real.exp (-(100 * (Real.log 2 - 1) ^ 2)) ≤ 1 / 8000 := by
    have h1 : Real.exp (-(100 * (Real.log 2 - 1) ^ 2)) ≤ Real.exp (-9 : ℝ) := by
      apply Real.exp_le_exp.mpr
      nlinarith [h100_lo]
    exact le_trans h1 exp_neg_nine_le_c1
  have hexp_lo : (1 / 14000 : ℝ) ≤ Real.exp (-(100 * (Real.log 2 - 1) ^ 2)) := by
    have h1 : Real.exp (-(9.5) : ℝ) ≤ Real.exp (-(100 * (Real.log 2 - 1) ^ 2)) := by
      apply Real.exp_le_exp.mpr
      nlinarith [h100_hi]
    exact le_trans exp_neg_nine_half_ge_c1 h1
  have hq_lo : (49 / 100 : ℝ) ≤ Real.log 2 / Real.sqrt 2 := by
    rw [le_div_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 2))]
    nlinarith [hlog.1, hs2.2]
  have hq_hi : Real.log 2 / Real.sqrt 2 ≤ (50 / 100 : ℝ) := by
    rw [div_le_iff₀ (Real.sqrt_pos.mpr (by norm_num : (0 : ℝ) < 2))]
    nlinarith [hlog.2, hs2.1]
  have hpi_lo : (8862 / 100000 : ℝ) ≤ Real.sqrt Real.pi / 20 := by
    have := sqrt_pi_mem.1; linarith
  have hpi_hi : Real.sqrt Real.pi / 20 ≤ (8863 / 100000 : ℝ) := by
    have := sqrt_pi_mem.2; linarith
  have ht_lo : (3 / 1000000 : ℝ) ≤
      Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 2 - 1) ^ 2))) := by
    calc (3 / 1000000 : ℝ) ≤ (49 / 100) * ((8862 / 100000) * (1 / 14000)) := by norm_num
      _ ≤ Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 2 - 1) ^ 2))) := by
          gcongr
  have ht_hi : Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 2 - 1) ^ 2))) ≤
      (6 / 1000000 : ℝ) := by
    calc Real.log 2 / Real.sqrt 2 * (Real.sqrt Real.pi / 20 * Real.exp (-(100 * (Real.log 2 - 1) ^ 2)))
        ≤ (50 / 100) * ((8863 / 100000) * (1 / 8000)) := by
          gcongr
      _ ≤ (6 / 1000000 : ℝ) := by norm_num
  rw [primeSummand, gaussianBump_inv20, vonMangoldt_two]
  constructor
  · simpa using ht_lo
  · simpa using ht_hi

theorem primeTerm_c1_mem :
    (-42660 / 1000000 : ℝ) ≤ primeTerm 1 (1 / 20) ∧
      primeTerm 1 (1 / 20) ≤ -42460 / 1000000 := by
  have h2 := primeSummand_two_c1_mem
  have h3 := primeSummand_three_c1_mem
  have htail_le : (∑' n : ℕ, primeSummand 1 (n + 4)) ≤ (1811 / 1000000000 : ℝ) := by
    refine le_trans sum_tail_c1_le ?_
    have hB := sqrt_pi_div_twenty_le
    have h1 : Real.sqrt Real.pi / 20 * (1 / (4 : ℝ) ^ 7) * (1 / 3) ≤
        (8863 / 100000 : ℝ) * (1 / (4 : ℝ) ^ 7) * (1 / 3) := by
      apply mul_le_mul_of_nonneg_right _ (by norm_num)
      exact mul_le_mul_of_nonneg_right hB (by positivity)
    refine le_trans h1 ?_
    norm_num
  have htail_nonneg : 0 ≤ ∑' n : ℕ, primeSummand 1 (n + 4) :=
    tsum_nonneg (fun n => primeSummand_nonneg 1 (n + 4))
  have hlo : (21233 / 1000000 : ℝ) ≤
      primeSummand 1 2 + primeSummand 1 3 + ∑' n : ℕ, primeSummand 1 (n + 4) := by
    linarith [h2.1, h3.1, htail_nonneg]
  have hhi : primeSummand 1 2 + primeSummand 1 3 + ∑' n : ℕ, primeSummand 1 (n + 4) ≤
      (21328 / 1000000 : ℝ) := by
    linarith [h2.2, h3.2, htail_le]
  rw [primeTerm_eq_inv20, prime_sum_split_c1]
  constructor <;> linarith [hlo, hhi]

/-- The prime term is non-positive for `σ > 0`. -/
theorem primeTerm_nonpos {σ : ℝ} (hσ : 0 < σ) (c : ℝ) : primeTerm c σ ≤ 0 := by
  unfold primeTerm
  have h : 0 ≤ ∑' n : ℕ,
      ArithmeticFunction.vonMangoldt n / Real.sqrt (n : ℝ) * gaussianBump c σ (Real.log n) := by
    apply tsum_nonneg
    intro n
    have hΛ : 0 ≤ (ArithmeticFunction.vonMangoldt n : ℝ) :=
      ArithmeticFunction.vonMangoldt_nonneg
    have hb : 0 ≤ gaussianBump c σ (Real.log n) := by
      unfold gaussianBump
      positivity
    positivity
  linarith

end PrimeSpectrumTensor
