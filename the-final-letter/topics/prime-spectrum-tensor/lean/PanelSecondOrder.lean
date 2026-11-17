import Mathlib
import SecondDeriv
import PanelCertificate
import PanelDecay
import OmegaPanel

/-!
# The second-order panel certificate

The first-order panel certificate of [`PanelDecay.lean`](PanelDecay.lean) splits
the panel error into

* the midpoint rule for the weight alone (`h³`), and
* the variation of `Ω` across the panel (`h²`, through `|Ω′| ≤ lip`).

The second term is the `h²` term that throttles the whole ladder.  Here it is
replaced: `midpoint_rule_bound` is applied to the *product* `w·Ω`, whose second
derivative is

```
(wΩ)″ = w″·Ω + 2·w′·Ω′ + w·Ω″,
```

so with panel bounds `W, W₁, W₂` for `|w|, |w′|, |w″|` and the pointwise bounds
of [`SecondDeriv.lean`](SecondDeriv.lean) for `Ω, Ω′, Ω″`,

```
|(wΩ)″| ≤ B := W₂·|Ω| + 2·W₁·|Ω′| + W·|Ω″|,
```

and the per-panel error is `B·h³/4` — `h³` instead of `h²`.

## The weight derivative bound

`w′ = (1/400) e^{−t²/400} (−(t/200) cos(ct) − c sin(ct))`, so

```
|w′(t)| ≤ (1/400)·(|t|/200 + |c|),
```

proved below as `abs_weight1_le`.
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- **The first-derivative weight bound.**  `|w′(t)| ≤ (1/400)(|t|/200 + |c|)`. -/
theorem abs_weight1_le (c t : ℝ) :
    |deriv (weight c) t| ≤ (1 / 400 : ℝ) * (|t| / 200 + |c|) := by
  have hderiv : deriv (weight c) = weight1 c := funext fun x => (hasDerivAt_weight c x).deriv
  rw [hderiv]
  unfold weight1
  have hexp0 : (0 : ℝ) < Real.exp (-((1 / 20 : ℝ) * t) ^ 2) := Real.exp_pos _
  have he1 : Real.exp (-((1 / 20 : ℝ) * t) ^ 2) ≤ 1 := by
    rw [Real.exp_le_one_iff]
    nlinarith [sq_nonneg ((1 / 20 : ℝ) * t)]
  have hcos : |Real.cos (c * t)| ≤ 1 := Real.abs_cos_le_one _
  have hsin : |Real.sin (c * t)| ≤ 1 := Real.abs_sin_le_one _
  have h1 : |(-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)|
      ≤ |t / 200| := by
    rw [abs_mul, abs_mul, abs_neg, abs_of_pos hexp0]
    calc |t / 200| * Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * |Real.cos (c * t)|
        ≤ |t / 200| * Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * 1 := by
          exact mul_le_mul_of_nonneg_left hcos
            (mul_nonneg (abs_nonneg _) (le_of_lt hexp0))
      _ ≤ |t / 200| * 1 * 1 := by
          refine mul_le_mul_of_nonneg_right ?_ (by norm_num)
          exact mul_le_mul_of_nonneg_left he1 (abs_nonneg _)
      _ = |t / 200| := by ring
  have h2 : |Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t)))| ≤ |c| := by
    rw [abs_mul, abs_neg, abs_mul, abs_of_pos hexp0]
    calc Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (|c| * |Real.sin (c * t)|)
        ≤ 1 * (|c| * 1) := by
          refine mul_le_mul he1 ?_ (mul_nonneg (abs_nonneg _) (abs_nonneg _)) (by norm_num)
          exact mul_le_mul_of_nonneg_left hsin (abs_nonneg _)
      _ = |c| := by ring
  have h3 : |(-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)
      + Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t)))|
      ≤ |t / 200| + |c| := by
    calc |(-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)
          + Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t)))|
        ≤ |(-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)|
          + |Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t)))| := abs_add_le _ _
      _ ≤ |t / 200| + |c| := by linarith
  calc |(1 / 400 : ℝ) * ((-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)
        + Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t))))|
      = (1 / 400) * |(-(t / 200) * Real.exp (-((1 / 20 : ℝ) * t) ^ 2)) * Real.cos (c * t)
        + Real.exp (-((1 / 20 : ℝ) * t) ^ 2) * (-(c * Real.sin (c * t)))| := by
        rw [abs_mul, abs_of_pos (by norm_num : (0 : ℝ) < 1 / 400)]
    _ ≤ (1 / 400) * (|t / 200| + |c|) := by
        exact mul_le_mul_of_nonneg_left h3 (by norm_num)
    _ = (1 / 400) * (|t| / 200 + |c|) := by
        rw [abs_div, abs_of_pos (by norm_num : (0 : ℝ) < 200)]

/-- `iteratedDeriv 1 Ψ` is everywhere differentiable. -/
theorem differentiable_iteratedDeriv_one :
    Differentiable ℝ (iteratedDeriv 1 Rh45.Psi) :=
  fun t => differentiableAt_iteratedDeriv_one t

/-- `deriv Ω` is differentiable. -/
theorem differentiable_deriv_Omega : Differentiable ℝ (deriv IntersectionForm.Omega) := by
  have hfun : deriv IntersectionForm.Omega =
      fun u => (iteratedDeriv 1 Rh45.Psi u).re := funext IntersectionForm.deriv_Omega_eq
  rw [hfun]
  intro t
  have hf : HasFDerivAt (iteratedDeriv 1 Rh45.Psi)
      (fderiv ℝ (iteratedDeriv 1 Rh45.Psi) t) t :=
    (differentiableAt_iteratedDeriv_one t).hasFDerivAt
  exact (Complex.reCLM.hasFDerivAt.comp t hf).differentiableAt

/-- **The second derivative of `w·Ω`.** -/
theorem deriv2_weight_mul (c : ℝ) (x : ℝ) :
    deriv (deriv (fun y => weight c y * IntersectionForm.Omega y)) x =
      weight2 c x * IntersectionForm.Omega x
        + 2 * (weight1 c x * deriv IntersectionForm.Omega x)
        + weight c x * deriv (deriv IntersectionForm.Omega) x := by
  have hderiv : ∀ y : ℝ, HasDerivAt (fun z => weight c z * IntersectionForm.Omega z)
      (weight1 c y * IntersectionForm.Omega y + weight c y * deriv IntersectionForm.Omega y) y := by
    intro y
    exact (hasDerivAt_weight c y).mul (differentiable_Omega.differentiableAt.hasDerivAt)
  have hderiv_eq : deriv (fun y => weight c y * IntersectionForm.Omega y)
      = fun y => weight1 c y * IntersectionForm.Omega y
          + weight c y * deriv IntersectionForm.Omega y :=
    funext fun y => (hderiv y).deriv
  have hderiv2 : HasDerivAt
      (fun y => weight1 c y * IntersectionForm.Omega y
        + weight c y * deriv IntersectionForm.Omega y)
      (weight2 c x * IntersectionForm.Omega x + weight1 c x * deriv IntersectionForm.Omega x
        + (weight1 c x * deriv IntersectionForm.Omega x
            + weight c x * deriv (deriv IntersectionForm.Omega) x)) x :=
    ((hasDerivAt_weight2 c x).mul
        (differentiable_Omega.differentiableAt.hasDerivAt)).add
      ((hasDerivAt_weight c x).mul
        (differentiable_deriv_Omega.differentiableAt.hasDerivAt))
  rw [hderiv_eq]
  rw [hderiv2.deriv]
  ring

/-- **The second-derivative bound for the panel integrand.** -/
theorem abs_deriv2_weight_mul_le {c : ℝ} {a b W W1 W2 Om L S : ℝ}
    (hW : ∀ t ∈ Set.Icc a b, |weight c t| ≤ W)
    (hW1 : ∀ t ∈ Set.Icc a b, |weight1 c t| ≤ W1)
    (hW2 : ∀ t ∈ Set.Icc a b, |weight2 c t| ≤ W2)
    (hOm : ∀ t ∈ Set.Icc a b, |IntersectionForm.Omega t| ≤ Om)
    (hL : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ L)
    (hS : ∀ t ∈ Set.Icc a b, |deriv (deriv IntersectionForm.Omega) t| ≤ S) :
    ∀ x ∈ Set.Icc a b, |deriv (deriv (fun y => weight c y * IntersectionForm.Omega y)) x|
      ≤ W2 * Om + 2 * (W1 * L) + W * S := by
  intro x hx
  rw [deriv2_weight_mul]
  have hmul : ∀ p q P Q : ℝ, |p| ≤ P → |q| ≤ Q → |p * q| ≤ P * Q := by
    intro p q P Q hp hq
    rw [abs_mul]
    exact mul_le_mul hp hq (abs_nonneg q) (le_trans (abs_nonneg p) hp)
  have h1 : |weight2 c x * IntersectionForm.Omega x| ≤ W2 * Om :=
    hmul _ _ _ _ (hW2 x hx) (hOm x hx)
  have h2 : |2 * (weight1 c x * deriv IntersectionForm.Omega x)| ≤ 2 * (W1 * L) := by
    rw [abs_mul, show |(2 : ℝ)| = 2 by norm_num]
    exact mul_le_mul_of_nonneg_left (hmul _ _ _ _ (hW1 x hx) (hL x hx)) (by norm_num)
  have h3 : |weight c x * deriv (deriv IntersectionForm.Omega) x| ≤ W * S :=
    hmul _ _ _ _ (hW x hx) (hS x hx)
  calc |weight2 c x * IntersectionForm.Omega x
        + 2 * (weight1 c x * deriv IntersectionForm.Omega x)
        + weight c x * deriv (deriv IntersectionForm.Omega) x|
      ≤ |weight2 c x * IntersectionForm.Omega x
          + 2 * (weight1 c x * deriv IntersectionForm.Omega x)|
        + |weight c x * deriv (deriv IntersectionForm.Omega) x| := abs_add_le _ _
    _ ≤ (|weight2 c x * IntersectionForm.Omega x|
        + |2 * (weight1 c x * deriv IntersectionForm.Omega x)|) + W * S := by
        have := abs_add_le (weight2 c x * IntersectionForm.Omega x)
          (2 * (weight1 c x * deriv IntersectionForm.Omega x))
        linarith
    _ ≤ W2 * Om + 2 * (W1 * L) + W * S := by linarith

/-- **The second-order panel certificate.**  With `B` a bound for `|(wΩ)″|` on
`[a,b]`, the midpoint rule for `w·Ω` costs `B·h³/4` — there is no `h²` term. -/
theorem panel_certificate_second_order {c : ℝ} {a b B : ℝ} (hab : a ≤ b)
    (hB : ∀ x ∈ Set.Icc a b,
      |deriv (deriv (fun y => weight c y * IntersectionForm.Omega y)) x| ≤ B) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
        (b - a) * (weight c ((a + b) / 2) * IntersectionForm.Omega ((a + b) / 2))| ≤
      B * (b - a) ^ 3 / 4 := by
  have hcont : Continuous (fun x => weight c x * IntersectionForm.Omega x) := by
    have h := (continuous_densityWeight c).mul continuous_Omega
    convert h using 1
    funext x
    simp only [Pi.mul_apply, weight_eq_densityWeight]
  have hderiv : ∀ y : ℝ, HasDerivAt (fun z => weight c z * IntersectionForm.Omega z)
      (weight1 c y * IntersectionForm.Omega y + weight c y * deriv IntersectionForm.Omega y) y := by
    intro y
    exact (hasDerivAt_weight c y).mul (differentiable_Omega.differentiableAt.hasDerivAt)
  have hderiv_eq : deriv (fun y => weight c y * IntersectionForm.Omega y)
      = fun y => weight1 c y * IntersectionForm.Omega y
          + weight c y * deriv IntersectionForm.Omega y :=
    funext fun y => (hderiv y).deriv
  have hderiv2 : ∀ x : ℝ, HasDerivAt
      (fun y => weight1 c y * IntersectionForm.Omega y
        + weight c y * deriv IntersectionForm.Omega y)
      (weight2 c x * IntersectionForm.Omega x + weight1 c x * deriv IntersectionForm.Omega x
        + (weight1 c x * deriv IntersectionForm.Omega x
            + weight c x * deriv (deriv IntersectionForm.Omega) x)) x := by
    intro x
    exact ((hasDerivAt_weight2 c x).mul
        (differentiable_Omega.differentiableAt.hasDerivAt)).add
      ((hasDerivAt_weight c x).mul
        (differentiable_deriv_Omega.differentiableAt.hasDerivAt))
  refine midpoint_rule_bound hab ?_ ?_ hB hcont
  · intro x _
    rw [hderiv_eq]
    exact hderiv x
  · intro x _
    have hd : deriv (deriv (fun y => weight c y * IntersectionForm.Omega y)) x
        = weight2 c x * IntersectionForm.Omega x
          + weight1 c x * deriv IntersectionForm.Omega x
          + (weight1 c x * deriv IntersectionForm.Omega x
              + weight c x * deriv (deriv IntersectionForm.Omega) x) := by
      rw [deriv2_weight_mul]
      ring
    rw [hd, hderiv_eq]
    exact hderiv2 x

/-- The second-order certificate with the panel bounds named separately (the
form the generator emits). -/
theorem panel_certificate_second_order_bounds {c : ℝ} {a b W W1 W2 Om L S : ℝ}
    (hab : a ≤ b)
    (hW : ∀ t ∈ Set.Icc a b, |weight c t| ≤ W)
    (hW1 : ∀ t ∈ Set.Icc a b, |weight1 c t| ≤ W1)
    (hW2 : ∀ t ∈ Set.Icc a b, |weight2 c t| ≤ W2)
    (hOm : ∀ t ∈ Set.Icc a b, |IntersectionForm.Omega t| ≤ Om)
    (hL : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ L)
    (hS : ∀ t ∈ Set.Icc a b, |deriv (deriv IntersectionForm.Omega) t| ≤ S) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
        (b - a) * (weight c ((a + b) / 2) * IntersectionForm.Omega ((a + b) / 2))| ≤
      (W2 * Om + 2 * (W1 * L) + W * S) * (b - a) ^ 3 / 4 := by
  refine panel_certificate_second_order hab ?_
  exact fun x hx => abs_deriv2_weight_mul_le hW hW1 hW2 hOm hL hS x hx

/-- **The emitted second-order panel certificate.**

Everything the generator knows about a panel is passed in: the `Ω` bracket at the
midpoint (`qlo, qhi`), the rational node value `w0` with its error `eps`, the six
panel bounds `W, W1, W2, Om, L, S`, and the two rational budget checks `hE1`,
`hE`.  The conclusion is the panel enclosure in the `R = qmid·(h·w0)` form the
cumulative chain consumes. -/
theorem panel_second_order_certificate {c : ℝ} {a b qlo qhi w0 eps W W1 W2 Om L S E1 E : ℝ}
    (hab : a ≤ b) (ha0 : 0 ≤ a)
    (hq : qlo ≤ IntersectionForm.Omega ((a + b) / 2) ∧
      IntersectionForm.Omega ((a + b) / 2) ≤ qhi)
    (hW : ∀ t ∈ Set.Icc a b, |weight c t| ≤ W)
    (hW1 : ∀ t ∈ Set.Icc a b, |deriv (weight c) t| ≤ W1)
    (hW2 : ∀ t ∈ Set.Icc a b, |deriv (deriv (weight c)) t| ≤ W2)
    (hOm : ∀ t ∈ Set.Icc a b, |IntersectionForm.Omega t| ≤ Om)
    (hL : ∀ t ∈ Set.Icc a b, |deriv IntersectionForm.Omega t| ≤ L)
    (hS : ∀ t ∈ Set.Icc a b, |deriv (deriv IntersectionForm.Omega) t| ≤ S)
    (hW0 : |weight c ((a + b) / 2) - w0| ≤ eps)
    (hE1 : (W2 * Om + 2 * (W1 * L) + W * S) * (b - a) ^ 3 / 4
      + (qhi - qlo) / 2 * (b - a) * (|w0| + eps) ≤ E1)
    (hE : E1 + |(qlo + qhi) / 2| * (b - a) * eps ≤ E) :
    |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qlo + qhi) / 2) * ((b - a) * w0)| ≤ E := by
  have hq1 := hq.1
  have hq2 := hq.2
  -- second derivatives: `deriv (deriv weight)` is `weight2`
  have hW1' : ∀ t ∈ Set.Icc a b, |weight1 c t| ≤ W1 := by
    intro t ht
    rw [← (hasDerivAt_weight c t).deriv]
    exact hW1 t ht
  have hW2' : ∀ t ∈ Set.Icc a b, |weight2 c t| ≤ W2 := by
    intro t ht
    have h2 : deriv (deriv (weight c)) = weight2 c := by
      have h1 : deriv (weight c) = weight1 c := funext fun y => (hasDerivAt_weight c y).deriv
      rw [h1]
      funext y
      exact (hasDerivAt_weight2 c y).deriv
    rw [← h2]
    exact hW2 t ht
  have hcert := panel_certificate_second_order_bounds (c := c) hab hW hW1' hW2' hOm hL hS
  set m : ℝ := (a + b) / 2 with hm
  have hm_mem : m ∈ Set.Icc a b := by
    constructor <;> simp only [hm] <;> linarith
  have hwm : |weight c m| ≤ |w0| + eps := by
    have h1 : |weight c m| ≤ |weight c m - w0| + |w0| := by
      have := abs_add_le (weight c m - w0) w0
      simpa using this
    linarith [abs_le.mp hW0]
  have hd : |IntersectionForm.Omega m - (qlo + qhi) / 2| ≤ (qhi - qlo) / 2 := by
    rw [abs_le]
    constructor <;> linarith
  -- replace `m` by `(a+b)/2` in the certificate
  have hcert' : |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      (b - a) * (weight c m * IntersectionForm.Omega m)| ≤
      (W2 * Om + 2 * (W1 * L) + W * S) * (b - a) ^ 3 / 4 := hcert
  -- split off the rational part of `Ω(m)`
  have hsplit : |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
      ((qlo + qhi) / 2) * ((b - a) * weight c m)| ≤ E1 := by
    have hdecomp : (∫ x in a..b, weight c x * IntersectionForm.Omega x) -
        ((qlo + qhi) / 2) * ((b - a) * weight c m) =
        ((∫ x in a..b, weight c x * IntersectionForm.Omega x) -
          (b - a) * (weight c m * IntersectionForm.Omega m)) +
        (IntersectionForm.Omega m - (qlo + qhi) / 2) * ((b - a) * weight c m) := by
      ring
    rw [hdecomp]
    have h1 : |(IntersectionForm.Omega m - (qlo + qhi) / 2) * ((b - a) * weight c m)|
        ≤ (qhi - qlo) / 2 * ((b - a) * (|w0| + eps)) := by
      rw [abs_mul, abs_mul, abs_of_nonneg (by linarith : (0 : ℝ) ≤ b - a)]
      have hstep : |IntersectionForm.Omega m - (qlo + qhi) / 2| * |weight c m|
          ≤ (qhi - qlo) / 2 * (|w0| + eps) :=
        mul_le_mul hd hwm (abs_nonneg _) (by linarith)
      calc |IntersectionForm.Omega m - (qlo + qhi) / 2| * ((b - a) * |weight c m|)
          = (|IntersectionForm.Omega m - (qlo + qhi) / 2| * |weight c m|) * (b - a) := by ring
        _ ≤ ((qhi - qlo) / 2 * (|w0| + eps)) * (b - a) :=
            mul_le_mul_of_nonneg_right hstep (by linarith)
        _ = (qhi - qlo) / 2 * ((b - a) * (|w0| + eps)) := by ring
    calc |((∫ x in a..b, weight c x * IntersectionForm.Omega x) -
          (b - a) * (weight c m * IntersectionForm.Omega m)) +
        (IntersectionForm.Omega m - (qlo + qhi) / 2) * ((b - a) * weight c m)|
        ≤ |(∫ x in a..b, weight c x * IntersectionForm.Omega x) -
            (b - a) * (weight c m * IntersectionForm.Omega m)| +
          |(IntersectionForm.Omega m - (qlo + qhi) / 2) * ((b - a) * weight c m)| :=
          abs_add_le _ _
      _ ≤ (W2 * Om + 2 * (W1 * L) + W * S) * (b - a) ^ 3 / 4
            + (qhi - qlo) / 2 * ((b - a) * (|w0| + eps)) := by linarith
      _ ≤ E1 := by linarith [hE1]
  have hglue := panel_glue (c := c) (a := a) (b := b) (qmlo := qlo) (qmhi := qhi)
    (E1 := E1) (w0 := w0) (eps := eps) hab ?_ hW0
  · have : E1 + |((qlo + qhi) / 2)| * (b - a) * eps ≤ E := hE
    linarith [hglue, this]
  · simpa only [hm] using hsplit

end PrimeSpectrumTensor
