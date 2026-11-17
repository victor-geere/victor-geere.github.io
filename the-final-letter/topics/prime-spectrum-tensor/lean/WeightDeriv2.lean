import Mathlib
import WeightBound

/-!
# A decaying bound for `w″`

`WeightBound.abs_deriv2_weight_le` proves the crude global bound `|w″| ≤ 1/400`
on `[0,60]`.  The true second derivative carries the Gaussian factor:

```
w″(t) = (1/400)·e^{−t²/400}·((−1/200 + t²/40000 − c²)·cos(ct) + 2(t/200)c·sin(ct)),
```

so

```
|w″(t)| ≤ (1/400)·e^{−t²/400}·(1/200 + t²/40000 + c² + 2(t/200)|c|).
```

On a panel `[a,b] ⊂ [0,∞)` this gives the *panel-local* bound

```
|w″(t)| ≤ (1/400)·e^{−a²/400}·(1/200 + b²/40000 + c² + 2(b/200)|c|),
```

which decays like `e^{−a²/400}`.  The global `1/400` is almost tight at `a = 0`
but four orders of magnitude too large at `a = 60`, and it is the dominant term
of the second-order panel constant.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **The decaying second-derivative bound.** -/
theorem abs_deriv2_weight_le_decay {c x : ℝ} (hx0 : 0 ≤ x) :
    |deriv (deriv (weight c)) x| ≤ (1 / 400 : ℝ) * Real.exp (-(x ^ 2 / 400)) *
      (1 / 200 + x ^ 2 / 40000 + c ^ 2 + 2 * (x / 200) * |c|) := by
  have h1 : deriv (weight c) = weight1 c := funext fun t => (hasDerivAt_weight c t).deriv
  have h2 : deriv (deriv (weight c)) = weight2 c := by
    rw [h1]
    funext t
    exact (hasDerivAt_weight2 c t).deriv
  rw [h2]
  unfold weight2
  have hexp : Real.exp (-((1 / 20 : ℝ) * x) ^ 2) = Real.exp (-(x ^ 2 / 400)) := by
    rw [show -((1 / 20 : ℝ) * x) ^ 2 = -(x ^ 2 / 400) by ring]
  have hG0 : (0 : ℝ) < Real.exp (-(x ^ 2 / 400)) := Real.exp_pos _
  have hcos : |Real.cos (c * x)| ≤ 1 := Real.abs_cos_le_one _
  have hsin : |Real.sin (c * x)| ≤ 1 := Real.abs_sin_le_one _
  have hc0 : (0 : ℝ) ≤ |c| := abs_nonneg _
  have hx200 : (0 : ℝ) ≤ x / 200 := by linarith
  have hb1 : |(-1 / 200) + x ^ 2 / 40000 - c ^ 2| ≤ 1 / 200 + x ^ 2 / 40000 + c ^ 2 := by
    rw [abs_le]
    constructor <;> nlinarith [sq_nonneg c, sq_nonneg x]
  have hb2 : |2 * (x / 200) * c * Real.sin (c * x)| ≤ 2 * (x / 200) * |c| := by
    rw [abs_mul, abs_mul, abs_mul, show |(2 : ℝ)| = 2 by norm_num,
      abs_of_nonneg hx200]
    calc 2 * (x / 200) * |c| * |Real.sin (c * x)| ≤ 2 * (x / 200) * |c| * 1 :=
          mul_le_mul_of_nonneg_left hsin (by positivity)
      _ = 2 * (x / 200) * |c| := by ring
  have hbracket : |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
      2 * (x / 200) * c * Real.sin (c * x)|
      ≤ (1 / 200 + x ^ 2 / 40000 + c ^ 2) + 2 * (x / 200) * |c| := by
    calc |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
        2 * (x / 200) * c * Real.sin (c * x)|
        ≤ |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)| +
          |2 * (x / 200) * c * Real.sin (c * x)| := abs_add_le _ _
      _ ≤ (1 / 200 + x ^ 2 / 40000 + c ^ 2) * 1 + 2 * (x / 200) * |c| := by
          have h3 : |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)|
              ≤ (1 / 200 + x ^ 2 / 40000 + c ^ 2) * 1 := by
            rw [abs_mul]
            exact mul_le_mul hb1 hcos (abs_nonneg _) (by positivity)
          linarith
      _ = (1 / 200 + x ^ 2 / 40000 + c ^ 2) + 2 * (x / 200) * |c| := by ring
  calc |(1 / 400 : ℝ) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) *
        (((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
          2 * (x / 200) * c * Real.sin (c * x))|
      = (1 / 400) * Real.exp (-(x ^ 2 / 400)) *
          |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
            2 * (x / 200) * c * Real.sin (c * x)| := by
        rw [hexp]
        simp only [abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400), abs_of_pos hG0]
    _ ≤ (1 / 400) * Real.exp (-(x ^ 2 / 400)) *
          ((1 / 200 + x ^ 2 / 40000 + c ^ 2) + 2 * (x / 200) * |c|) := by
        exact mul_le_mul_of_nonneg_left hbracket
          (mul_nonneg (by norm_num) (le_of_lt hG0))
    _ = (1 / 400) * Real.exp (-(x ^ 2 / 400)) *
          (1 / 200 + x ^ 2 / 40000 + c ^ 2 + 2 * (x / 200) * |c|) := by ring

/-- **The panel-local decaying bound.**  For `0 ≤ a ≤ t ≤ b`,

```
|w″(t)| ≤ (1/400)·e^{−a²/400}·(1/200 + b²/40000 + c² + 2(b/200)|c|).
```
-/
theorem abs_deriv2_weight_le_div {c : ℝ} {a b t : ℝ} (ha : 0 ≤ a) (hat : a ≤ t)
    (htb : t ≤ b) :
    |deriv (deriv (weight c)) t| ≤ (1 / 400 : ℝ) * Real.exp (-(a ^ 2 / 400)) *
      (1 / 200 + b ^ 2 / 40000 + c ^ 2 + 2 * (b / 200) * |c|) := by
  have ht0 : (0 : ℝ) ≤ t := le_trans ha hat
  have h1 := abs_deriv2_weight_le_decay (c := c) ht0
  have hexp : Real.exp (-(t ^ 2 / 400)) ≤ Real.exp (-(a ^ 2 / 400)) := by
    apply Real.exp_le_exp.mpr
    nlinarith
  have hpoly : (1 / 200 + t ^ 2 / 40000 + c ^ 2 + 2 * (t / 200) * |c|)
      ≤ (1 / 200 + b ^ 2 / 40000 + c ^ 2 + 2 * (b / 200) * |c|) := by
    have hc0 : (0 : ℝ) ≤ |c| := abs_nonneg _
    nlinarith
  have hnn : (0 : ℝ) ≤ 1 / 400 * Real.exp (-(a ^ 2 / 400)) := by positivity
  calc |deriv (deriv (weight c)) t|
      ≤ (1 / 400) * Real.exp (-(t ^ 2 / 400)) *
          (1 / 200 + t ^ 2 / 40000 + c ^ 2 + 2 * (t / 200) * |c|) := h1
    _ ≤ (1 / 400) * Real.exp (-(a ^ 2 / 400)) *
          (1 / 200 + b ^ 2 / 40000 + c ^ 2 + 2 * (b / 200) * |c|) := by
        refine mul_le_mul ?_ hpoly (by positivity) hnn
        exact mul_le_mul_of_nonneg_left hexp (by norm_num)

end PrimeSpectrumTensor
