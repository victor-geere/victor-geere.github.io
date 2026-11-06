import Mathlib
import MidpointRule

/-!
# The second-derivative bound for the panel weight

R2's panel estimate applies `midpoint_rule_bound` to the weight

```
w(t) = σ² · exp(−σ²t²) · cos(ct),      σ = 1/20,
```

so it needs `|w″| ≤ B` on a panel.  Writing `G = exp(−σ²t²)`,

```
w  = σ² · G · cos(ct),
w′ = σ² · (G′ cos(ct) − c G sin(ct)),
w″ = σ² · G · ((−2σ² + 4σ⁴t² − c²) cos(ct) + 4σ²ct sin(ct)),
```

so on `[0, 60]` with `|c| ≤ 3/5`

```
|w″| ≤ σ² (0.005 + 0.09 + 0.36 + 0.36) ≤ 1/100.
```

The bound is loose on purpose: the grid error `T·B·h²/4` is `3.8·10⁻⁴` at
`h = 0.05`, `T = 60`, far inside the density budget.
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The Gaussian panel weight at `σ = 1/20`. -/
noncomputable def weight (c : ℝ) : ℝ → ℝ :=
  fun t => (1 / 400 : ℝ) * (Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * Real.cos (c * t))

/-- The first derivative of the weight. -/
noncomputable def weight1 (c : ℝ) : ℝ → ℝ :=
  fun t => (1 / 400 : ℝ) *
    ((-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t) +
      Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t))))

/-- The second derivative of the weight. -/
noncomputable def weight2 (c : ℝ) : ℝ → ℝ :=
  fun t => (1 / 400 : ℝ) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2) *
    (((-1 / 200) + t ^ 2 / 40000 - c ^ 2) * Real.cos (c * t) +
      2 * (t / 200) * c * Real.sin (c * t))

/-- The Gaussian factor is its own derivative up to `−t/200`. -/
theorem hasDerivAt_gauss (x : ℝ) :
    HasDerivAt (fun t : ℝ => Real.exp (-((1 / 20 : ℝ) * t) ^ 2))
      (-(x / 200) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2)) x := by
  have h1 : HasDerivAt (fun t : ℝ => (1 / 20 : ℝ) * t) (1 / 20) x := by
    simpa using (hasDerivAt_id x).const_mul (1 / 20 : ℝ)
  have h2 : HasDerivAt (fun t : ℝ => -(((1 / 20 : ℝ) * t) ^ 2)) (-(2 * ((1 / 20 : ℝ) * x) * (1 / 20))) x := by
    have := (h1.pow 2).neg
    convert this using 1
    ring
  have h3 := h2.exp
  convert h3 using 1
  ring

theorem hasDerivAt_cos (c x : ℝ) :
    HasDerivAt (fun t : ℝ => Real.cos (c * t)) (-(c * Real.sin (c * x))) x := by
  have h1 : HasDerivAt (fun t : ℝ => c * t) c x := by
    simpa using (hasDerivAt_id x).const_mul c
  simpa [mul_comm] using h1.cos

theorem hasDerivAt_weight (c x : ℝ) : HasDerivAt (weight c) (weight1 c x) x := by
  unfold weight weight1
  have hG := hasDerivAt_gauss x
  have hC := hasDerivAt_cos c x
  have h := (hG.mul hC).const_mul (1 / 400 : ℝ)
  convert h using 1

/-- The second derivative of the weight is `weight2`. -/
theorem hasDerivAt_weight2 (c x : ℝ) : HasDerivAt (weight1 c) (weight2 c x) x := by
  have hG := hasDerivAt_gauss x
  have hdiv : HasDerivAt (fun t : ℝ => -(t / 200)) (-(1 / 200)) x :=
    ((hasDerivAt_id x).div_const 200).neg
  have hA : HasDerivAt (fun t : ℝ => -(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2))
      (-(1 / 200) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) +
        (-(x / 200)) * (-(x / 200) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2))) x :=
    hdiv.mul hG
  have hsin : HasDerivAt (fun t : ℝ => -(c * Real.sin (c * t))) (-(c * (c * Real.cos (c * x)))) x := by
    have h1 : HasDerivAt (fun t : ℝ => c * t) c x := by
      simpa using (hasDerivAt_id x).const_mul c
    have h2 : HasDerivAt (fun y : ℝ => Real.sin y) (Real.cos (c * x)) (c * x) := Real.hasDerivAt_sin _
    have h3 : HasDerivAt (fun t : ℝ => Real.sin (c * t)) (Real.cos (c * x) * c) x := h2.comp x h1
    have h4 : HasDerivAt (fun t : ℝ => c * Real.sin (c * t)) (c * (Real.cos (c * x) * c)) x :=
      h3.const_mul c
    exact h4.neg.congr_deriv (by ring)
  have hC := hasDerivAt_cos c x
  have hAC := hA.mul hC
  have hB := hG.mul hsin
  have hsum := hAC.add hB
  have hk := hsum.const_mul (1 / 400 : ℝ)
  have hfun : weight1 c = fun y : ℝ => (1 / 400 : ℝ) *
      ((((fun t => -(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * fun t => Real.cos (c * t)) +
        (fun t => Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * fun t => -(c * Real.sin (c * t))) y) := by
    funext t
    unfold weight1
    simp only [Pi.mul_apply, Pi.add_apply]
  rw [hfun]
  convert hk using 1
  unfold weight2
  ring

/-- **The second-derivative bound.** `|w″(t)| ≤ 1/400` on `[0, 60]` for `|c| ≤ 3/5`. -/
theorem abs_deriv2_weight_le {c : ℝ} (hc : |c| ≤ 3 / 5) {x : ℝ}
    (hx0 : 0 ≤ x) (hx60 : x ≤ 60) :
    |deriv (deriv (weight c)) x| ≤ 1 / 400 := by
  have h1 : deriv (weight c) = weight1 c := funext fun t => (hasDerivAt_weight c t).deriv
  have h2 : deriv (deriv (weight c)) = weight2 c := by
    rw [h1]
    funext t
    exact (hasDerivAt_weight2 c t).deriv
  rw [h2]
  unfold weight2
  have hG0 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) * x) ^ 2) := Real.exp_pos _
  have hG1 : Real.exp (-((1 / 20 : ℝ) * x) ^ 2) ≤ 1 := by
    rw [Real.exp_le_one_iff]
    nlinarith [sq_nonneg ((1 / 20 : ℝ) * x)]
  have hcos : |Real.cos (c * x)| ≤ 1 := Real.abs_cos_le_one _
  have hsin : |Real.sin (c * x)| ≤ 1 := Real.abs_sin_le_one _
  have hc2 : c ^ 2 ≤ 9 / 25 := by
    have h := abs_le.mp hc
    nlinarith [h.1, h.2]
  have hx2 : x ^ 2 / 40000 ≤ 9 / 100 := by nlinarith
  have hx200 : |x / 200| ≤ 60 / 200 := by
    rw [abs_of_nonneg (by linarith : (0 : ℝ) ≤ x / 200)]
    linarith
  set b : ℝ := ((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
    2 * (x / 200) * c * Real.sin (c * x) with hb_def
  have hbracket : |b| ≤ (1 / 200 + 9 / 100 + 9 / 25) + 2 * (60 / 200) * (3 / 5) := by
    have h1 : |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)|
        ≤ (1 / 200 + 9 / 100 + 9 / 25) := by
      rw [abs_mul]
      have hb1 : |(-1 / 200) + x ^ 2 / 40000 - c ^ 2| ≤ 1 / 200 + 9 / 100 + 9 / 25 := by
        rw [abs_le]
        constructor <;> nlinarith
      calc |(-1 / 200) + x ^ 2 / 40000 - c ^ 2| * |Real.cos (c * x)|
          ≤ (1 / 200 + 9 / 100 + 9 / 25) * 1 :=
            mul_le_mul hb1 hcos (abs_nonneg _) (by positivity)
        _ = (1 / 200 + 9 / 100 + 9 / 25) := by ring
    have h2 : |2 * (x / 200) * c * Real.sin (c * x)| ≤ 2 * (60 / 200) * (3 / 5) := by
      rw [abs_mul, abs_mul, abs_mul]
      have h2' : |(2 : ℝ)| = 2 := by norm_num
      rw [h2']
      calc 2 * |x / 200| * |c| * |Real.sin (c * x)| ≤ 2 * (60 / 200) * (3 / 5) * 1 := by
            apply mul_le_mul _ hsin (abs_nonneg _) (by positivity)
            apply mul_le_mul _ hc (abs_nonneg _) (by positivity)
            exact mul_le_mul_of_nonneg_left hx200 (by norm_num)
        _ = 2 * (60 / 200) * (3 / 5) := by ring
    rw [hb_def]
    calc |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
        2 * (x / 200) * c * Real.sin (c * x)|
        ≤ |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)| +
          |2 * (x / 200) * c * Real.sin (c * x)| := abs_add_le _ _
      _ ≤ (1 / 200 + 9 / 100 + 9 / 25) + 2 * (60 / 200) * (3 / 5) := by linarith
  calc |(1 / 400 : ℝ) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) * b|
      = (1 / 400) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) * |b| := by
        rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400), abs_of_pos hG0]
    _ ≤ (1 / 400) * 1 * ((1 / 200 + 9 / 100 + 9 / 25) + 2 * (60 / 200) * (3 / 5)) := by
        apply mul_le_mul (mul_le_mul (le_refl _) hG1 hG0.le (by norm_num)) hbracket
          (abs_nonneg _) (by positivity)
    _ ≤ 1 / 400 := by norm_num

/-- **The second-derivative bound at `c = ±4/5`.**  The same crude triangle
inequality gives

```
|w″| ≤ (1/400)·((1/200 + 9/100 + 16/25) + 2·(60/200)·(4/5)) = 0.0030375 ≤ 1/200,
```

which is the constant the `c = 4/5` density certificate needs. -/
theorem abs_deriv2_weight_le_four_fifths {c : ℝ} (hc : |c| ≤ 4 / 5) {x : ℝ}
    (hx0 : 0 ≤ x) (hx60 : x ≤ 60) :
    |deriv (deriv (weight c)) x| ≤ 1 / 200 := by
  have h1 : deriv (weight c) = weight1 c := funext fun t => (hasDerivAt_weight c t).deriv
  have h2 : deriv (deriv (weight c)) = weight2 c := by
    rw [h1]
    funext t
    exact (hasDerivAt_weight2 c t).deriv
  rw [h2]
  unfold weight2
  have hG0 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) * x) ^ 2) := Real.exp_pos _
  have hG1 : Real.exp (-((1 / 20 : ℝ) * x) ^ 2) ≤ 1 := by
    rw [Real.exp_le_one_iff]
    nlinarith [sq_nonneg ((1 / 20 : ℝ) * x)]
  have hcos : |Real.cos (c * x)| ≤ 1 := Real.abs_cos_le_one _
  have hsin : |Real.sin (c * x)| ≤ 1 := Real.abs_sin_le_one _
  have hc2 : c ^ 2 ≤ 16 / 25 := by
    have h := abs_le.mp hc
    nlinarith [h.1, h.2]
  have hx2 : x ^ 2 / 40000 ≤ 9 / 100 := by nlinarith
  have hx200 : |x / 200| ≤ 60 / 200 := by
    rw [abs_of_nonneg (by linarith : (0 : ℝ) ≤ x / 200)]
    linarith
  set b : ℝ := ((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
    2 * (x / 200) * c * Real.sin (c * x) with hb_def
  have hbracket : |b| ≤ (1 / 200 + 9 / 100 + 16 / 25) + 2 * (60 / 200) * (4 / 5) := by
    have h1 : |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)|
        ≤ (1 / 200 + 9 / 100 + 16 / 25) := by
      rw [abs_mul]
      have hb1 : |(-1 / 200) + x ^ 2 / 40000 - c ^ 2| ≤ 1 / 200 + 9 / 100 + 16 / 25 := by
        rw [abs_le]
        constructor <;> nlinarith
      calc |(-1 / 200) + x ^ 2 / 40000 - c ^ 2| * |Real.cos (c * x)|
          ≤ (1 / 200 + 9 / 100 + 16 / 25) * 1 :=
            mul_le_mul hb1 hcos (abs_nonneg _) (by positivity)
        _ = (1 / 200 + 9 / 100 + 16 / 25) := by ring
    have h2 : |2 * (x / 200) * c * Real.sin (c * x)| ≤ 2 * (60 / 200) * (4 / 5) := by
      rw [abs_mul, abs_mul, abs_mul]
      have h2' : |(2 : ℝ)| = 2 := by norm_num
      rw [h2']
      calc 2 * |x / 200| * |c| * |Real.sin (c * x)| ≤ 2 * (60 / 200) * (4 / 5) * 1 := by
            apply mul_le_mul _ hsin (abs_nonneg _) (by positivity)
            apply mul_le_mul _ hc (abs_nonneg _) (by positivity)
            exact mul_le_mul_of_nonneg_left hx200 (by norm_num)
        _ = 2 * (60 / 200) * (4 / 5) := by ring
    rw [hb_def]
    calc |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x) +
        2 * (x / 200) * c * Real.sin (c * x)|
        ≤ |((-1 / 200) + x ^ 2 / 40000 - c ^ 2) * Real.cos (c * x)| +
          |2 * (x / 200) * c * Real.sin (c * x)| := abs_add_le _ _
      _ ≤ (1 / 200 + 9 / 100 + 16 / 25) + 2 * (60 / 200) * (4 / 5) := by linarith
  calc |(1 / 400 : ℝ) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) * b|
      = (1 / 400) * Real.exp (-((1 / 20 : ℝ) * x) ^ 2) * |b| := by
        rw [abs_mul, abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400), abs_of_pos hG0]
    _ ≤ (1 / 400) * 1 * ((1 / 200 + 9 / 100 + 16 / 25) + 2 * (60 / 200) * (4 / 5)) := by
        apply mul_le_mul (mul_le_mul (le_refl _) hG1 hG0.le (by norm_num)) hbracket
          (abs_nonneg _) (by positivity)
    _ ≤ 1 / 200 := by norm_num

end PrimeSpectrumTensor
