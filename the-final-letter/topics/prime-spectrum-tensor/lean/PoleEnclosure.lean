import Mathlib
import GaussianGram

/-!
# W3, first leaf — rigorous rational enclosures of the pole term

This file closes the *pole* part of the entrywise obligation of
[`../OMEGA-ROUTE.md`](../OMEGA-ROUTE.md) §4.  For the Gaussian basis of
`WEIL-GRAM.md` (`σ = 1/20`, centres `−0.3, −0.1, 0.1, 0.3`) the separation
takes the values `c ∈ {0, ±1/5, ±2/5, ±3/5}`, and the pole term is

```
poleTerm c (1/20) = (π/100) · exp(1/1600) · cosh(c/2).
```

`poleTerm_mem_c0 … poleTerm_mem_c3` enclose it in rational intervals of width
`2·10⁻⁶` for each of the four values of `|c|`.  The proof uses only

* `Real.pi_gt_d4` / `Real.pi_lt_d4` (`3.1415 < π < 3.1416`),
* `Real.exp_bound` (the Taylor bound `|exp x − Σ_{m<n} x^m/m!| ≤ |x|^n·(n+1)/(n!·n)`)
  for `exp (1/1600)`, `exp (±c/2)`,
* `Complex.two_cosh` transported to `ℝ` (`two_cosh_real`),

and exact rational arithmetic.  No floating point, no `sorry`.

## What is not here

The *density* and *prime* terms are not enclosed here.  The density term needs
quadrature; see `../OMEGA-ROUTE.md` §4 for the route and the existing Lean
infrastructure (`intersection-form-zeta/lean/DigammaEnclosure.lean`,
`PanelEnclosure.lean`, `Rh45/Archimedean.lean`).
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- `2 cosh x = exp x + exp (−x)` on the real line. -/
theorem two_cosh_real (x : ℝ) : 2 * Real.cosh x = Real.exp x + Real.exp (-x) := by
  have h := Complex.two_cosh (x : ℂ)
  rw [← Complex.ofReal_cosh, ← Complex.ofReal_exp, ← Complex.ofReal_neg,
    ← Complex.ofReal_exp] at h
  exact_mod_cast h

/-- The pole term at `σ = 1/20`, in the factored form used by the enclosures. -/
theorem poleTerm_eq_inv20 (c : ℝ) :
    poleTerm c (1 / 20) = (Real.pi / 100) * Real.exp (1 / 1600) * Real.cosh (c / 2) := by
  unfold poleTerm
  have h1 : ((1 : ℝ) / 20) ^ 2 = 1 / 400 := by norm_num
  rw [h1]
  have h2 : (1 : ℝ) / 400 / 4 = 1 / 1600 := by norm_num
  rw [h2]
  have h3 : (4 : ℝ) * Real.pi * (1 / 400) = Real.pi / 100 := by ring
  rw [h3]

/-- `π/100 ∈ [31415/10⁶, 31416/10⁶]`. -/
theorem pi_div_hundred_mem :
    (31415 / 1000000 : ℝ) ≤ Real.pi / 100 ∧ Real.pi / 100 ≤ 31416 / 1000000 := by
  constructor
  · linarith [Real.pi_gt_d4]
  · linarith [Real.pi_lt_d4]

/-- `exp(1/1600) ∈ [1 + 1/1600 − 10⁻⁶, 1 + 1/1600 + 10⁻⁶]`. -/
theorem exp_inv1600_mem :
    (1 + 1 / 1600 - 1 / 1000000 : ℝ) ≤ Real.exp (1 / 1600) ∧
      Real.exp (1 / 1600) ≤ 1 + 1 / 1600 + 1 / 1000000 := by
  have hx : |(1 / 1600 : ℝ)| ≤ 1 := by norm_num
  have h := Real.exp_bound hx (n := 2) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h
  norm_num at h
  rw [abs_le] at h
  constructor <;> linarith [h.1, h.2]

/-- `cosh(1/10) ∈ [10050041/10⁷, 10050042/10⁷]`. -/
theorem cosh_01_mem :
    (10050041 / 10000000 : ℝ) ≤ Real.cosh (1 / 10) ∧
      Real.cosh (1 / 10) ≤ 10050042 / 10000000 := by
  have hc := two_cosh_real (1 / 10)
  have h1 := Real.exp_bound (x := (1 / 10 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  have h2 := Real.exp_bound (x := -(1 / 10 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h1 h2
  norm_num at h1 h2
  rw [abs_le] at h1 h2
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2, hc]

/-- `cosh(1/5) ∈ [10200667/10⁷, 10200668/10⁷]`. -/
theorem cosh_02_mem :
    (10200667 / 10000000 : ℝ) ≤ Real.cosh (1 / 5) ∧
      Real.cosh (1 / 5) ≤ 10200668 / 10000000 := by
  have hc := two_cosh_real (1 / 5)
  have h1 := Real.exp_bound (x := (1 / 5 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  have h2 := Real.exp_bound (x := -(1 / 5 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h1 h2
  norm_num at h1 h2
  rw [abs_le] at h1 h2
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2, hc]

/-- `cosh(3/10) ∈ [10453385/10⁷, 10453386/10⁷]`. -/
theorem cosh_03_mem :
    (10453385 / 10000000 : ℝ) ≤ Real.cosh (3 / 10) ∧
      Real.cosh (3 / 10) ≤ 10453386 / 10000000 := by
  have hc := two_cosh_real (3 / 10)
  have h1 := Real.exp_bound (x := (3 / 10 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  have h2 := Real.exp_bound (x := -(3 / 10 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h1 h2
  norm_num at h1 h2
  rw [abs_le] at h1 h2
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2, hc]

/-- Interval multiplication for the pole term: given an enclosure of `cosh(c/2)`,
produce an enclosure of `poleTerm c (1/20)`. -/
theorem poleTerm_between (c : ℝ) {clo chi : ℝ}
    (h : clo ≤ Real.cosh (c / 2) ∧ Real.cosh (c / 2) ≤ chi) (hclo : 0 ≤ clo) :
    (31415 / 1000000 : ℝ) * (1 + 1 / 1600 - 1 / 1000000) * clo ≤ poleTerm c (1 / 20) ∧
      poleTerm c (1 / 20) ≤
        (31416 / 1000000 : ℝ) * (1 + 1 / 1600 + 1 / 1000000) * chi := by
  have hpi := pi_div_hundred_mem
  have hexp := exp_inv1600_mem
  rw [poleTerm_eq_inv20]
  constructor
  · have hb : (0 : ℝ) ≤ 1 + 1 / 1600 - 1 / 1000000 := by norm_num
    have h1 : (31415 / 1000000 : ℝ) * (1 + 1 / 1600 - 1 / 1000000) ≤
        (Real.pi / 100) * Real.exp (1 / 1600) :=
      mul_le_mul hpi.1 hexp.1 hb (by positivity)
    have hab : (0 : ℝ) ≤ (Real.pi / 100) * Real.exp (1 / 1600) := by positivity
    exact mul_le_mul h1 h.1 hclo hab
  · have h1 : (Real.pi / 100) * Real.exp (1 / 1600) ≤
        (31416 / 1000000 : ℝ) * (1 + 1 / 1600 + 1 / 1000000) :=
      mul_le_mul hpi.2 hexp.2 (by positivity) (by norm_num)
    have hch : (0 : ℝ) ≤ Real.cosh (c / 2) := (Real.cosh_pos (c / 2)).le
    exact mul_le_mul h1 h.2 hch (by positivity)

/-- The pole term is even in `c`. -/
theorem poleTerm_neg (c σ : ℝ) : poleTerm (-c) σ = poleTerm c σ := by
  unfold poleTerm
  rw [neg_div, Real.cosh_neg]

/-- `poleTerm 0 (1/20) ∈ [0.031434, 0.031436]`. -/
theorem poleTerm_mem_c0 :
    (31434 / 1000000 : ℝ) ≤ poleTerm 0 (1 / 20) ∧
      poleTerm 0 (1 / 20) ≤ 31436 / 1000000 := by
  have hcosh : (1 : ℝ) ≤ Real.cosh (0 / 2) ∧ Real.cosh (0 / 2) ≤ 1 := by
    rw [show (0 : ℝ) / 2 = 0 by norm_num, Real.cosh_zero]
    norm_num
  have h := poleTerm_between 0 hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]

/-- `poleTerm (1/5) (1/20) ∈ [0.031591, 0.031593]`. -/
theorem poleTerm_mem_c1 :
    (31591 / 1000000 : ℝ) ≤ poleTerm (1 / 5) (1 / 20) ∧
      poleTerm (1 / 5) (1 / 20) ≤ 31593 / 1000000 := by
  have hcosh : (10050041 / 10000000 : ℝ) ≤ Real.cosh ((1 / 5) / 2) ∧
      Real.cosh ((1 / 5) / 2) ≤ 10050042 / 10000000 := by
    rw [show (1 / 5 : ℝ) / 2 = 1 / 10 by norm_num]
    exact cosh_01_mem
  have h := poleTerm_between (1 / 5) hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]

/-- `poleTerm (2/5) (1/20) ∈ [0.032065, 0.032067]`. -/
theorem poleTerm_mem_c2 :
    (32065 / 1000000 : ℝ) ≤ poleTerm (2 / 5) (1 / 20) ∧
      poleTerm (2 / 5) (1 / 20) ≤ 32067 / 1000000 := by
  have hcosh : (10200667 / 10000000 : ℝ) ≤ Real.cosh ((2 / 5) / 2) ∧
      Real.cosh ((2 / 5) / 2) ≤ 10200668 / 10000000 := by
    rw [show (2 / 5 : ℝ) / 2 = 1 / 5 by norm_num]
    exact cosh_02_mem
  have h := poleTerm_between (2 / 5) hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]

/-- `poleTerm (3/5) (1/20) ∈ [0.032859, 0.032861]`. -/
theorem poleTerm_mem_c3 :
    (32859 / 1000000 : ℝ) ≤ poleTerm (3 / 5) (1 / 20) ∧
      poleTerm (3 / 5) (1 / 20) ≤ 32861 / 1000000 := by
  have hcosh : (10453385 / 10000000 : ℝ) ≤ Real.cosh ((3 / 5) / 2) ∧
      Real.cosh ((3 / 5) / 2) ≤ 10453386 / 10000000 := by
    rw [show (3 / 5 : ℝ) / 2 = 3 / 10 by norm_num]
    exact cosh_03_mem
  have h := poleTerm_between (3 / 5) hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]

/-- `cosh(2/5) ∈ [10810723/10⁷, 10810724/10⁷]`. -/
theorem cosh_04_mem :
    (10810723 / 10000000 : ℝ) ≤ Real.cosh (2 / 5) ∧
      Real.cosh (2 / 5) ≤ 10810724 / 10000000 := by
  have hc := two_cosh_real (2 / 5)
  have h1 := Real.exp_bound (x := (2 / 5 : ℝ)) (by norm_num) (n := 8) (by norm_num)
  have h2 := Real.exp_bound (x := (-(2 / 5) : ℝ)) (by norm_num) (n := 8) (by norm_num)
  simp only [Finset.sum_range_succ, Finset.sum_range_zero, zero_add] at h1 h2
  norm_num at h1 h2
  rw [abs_le] at h1 h2
  constructor <;> linarith [h1.1, h1.2, h2.1, h2.2, hc]

/-- `poleTerm (4/5) (1/20) ∈ [0.033982, 0.033985]`. -/
theorem poleTerm_mem_c4 :
    (33982 / 1000000 : ℝ) ≤ poleTerm (4 / 5) (1 / 20) ∧
      poleTerm (4 / 5) (1 / 20) ≤ 33985 / 1000000 := by
  have hcosh : (10810723 / 10000000 : ℝ) ≤ Real.cosh ((4 / 5) / 2) ∧
      Real.cosh ((4 / 5) / 2) ≤ 10810724 / 10000000 := by
    rw [show (4 / 5 : ℝ) / 2 = 2 / 5 by norm_num]
    exact cosh_04_mem
  have h := poleTerm_between (4 / 5) hcosh (by norm_num)
  norm_num at h ⊢
  constructor <;> linarith [h.1, h.2]

end PrimeSpectrumTensor
