import Mathlib
import GaussianGram

/-!
# The pole quadratic form as a product of linear forms

For centres `a` and weights `x`,

```
∑ i, ∑ j, x i * x j * poleTerm (a i - a j) σ
  = 4πσ² e^{σ²/4} · (∑ i, x i e^{a i/2}) · (∑ i, x i e^{-a i/2}).
```

So the pole term alone is an indefinite rank-one-type form; positivity of the
Gram matrix requires the prime and density terms, i.e. the full three-term
cancellation.
-/

noncomputable section

namespace PrimeSpectrumTensor

theorem cosh_quadratic_form {ι : Type*} [Fintype ι] (a x : ι → ℝ) :
    ∑ i, ∑ j, x i * x j * Real.cosh ((a i - a j) / 2)
      = (∑ i, x i * Real.exp (a i / 2)) * (∑ i, x i * Real.exp (-(a i) / 2)) := by
  have hS1 : (∑ i, ∑ j, x i * x j * Real.exp ((a i - a j) / 2))
      = (∑ i, x i * Real.exp (a i / 2)) * (∑ j, x j * Real.exp (-(a j) / 2)) := by
    rw [Finset.sum_mul_sum]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    have : x i * Real.exp (a i / 2) * (x j * Real.exp (-(a j) / 2))
        = x i * x j * (Real.exp (a i / 2) * Real.exp (-(a j) / 2)) := by ring
    rw [this, ← Real.exp_add]
    congr 1
    ring
  have hS2 : (∑ i, ∑ j, x i * x j * Real.exp (-((a i - a j) / 2)))
      = (∑ i, x i * Real.exp (-(a i) / 2)) * (∑ j, x j * Real.exp (a j / 2)) := by
    rw [Finset.sum_mul_sum]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    have : x i * Real.exp (-(a i) / 2) * (x j * Real.exp (a j / 2))
        = x i * x j * (Real.exp (-(a i) / 2) * Real.exp (a j / 2)) := by ring
    rw [this, ← Real.exp_add]
    congr 1
    ring
  calc ∑ i, ∑ j, x i * x j * Real.cosh ((a i - a j) / 2)
      = ∑ i, ∑ j, ((x i * x j * Real.exp ((a i - a j) / 2)) / 2 +
            (x i * x j * Real.exp (-((a i - a j) / 2))) / 2) := by
        refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
        rw [Real.cosh_eq]
        ring
    _ = (∑ i, ∑ j, x i * x j * Real.exp ((a i - a j) / 2)) / 2 +
          (∑ i, ∑ j, x i * x j * Real.exp (-((a i - a j) / 2))) / 2 := by
        have hinner : ∀ i, (∑ j, (x i * x j * Real.exp ((a i - a j) / 2) / 2 +
              x i * x j * Real.exp (-((a i - a j) / 2)) / 2))
            = (∑ j, x i * x j * Real.exp ((a i - a j) / 2)) / 2 +
              (∑ j, x i * x j * Real.exp (-((a i - a j) / 2))) / 2 := by
          intro i
          rw [Finset.sum_add_distrib, Finset.sum_div, Finset.sum_div]
        calc ∑ i, ∑ j, (x i * x j * Real.exp ((a i - a j) / 2) / 2 +
              x i * x j * Real.exp (-((a i - a j) / 2)) / 2)
            = ∑ i, ((∑ j, x i * x j * Real.exp ((a i - a j) / 2)) / 2 +
                (∑ j, x i * x j * Real.exp (-((a i - a j) / 2))) / 2) := by
              refine Finset.sum_congr rfl fun i _ => hinner i
          _ = (∑ i, ∑ j, x i * x j * Real.exp ((a i - a j) / 2)) / 2 +
                (∑ i, ∑ j, x i * x j * Real.exp (-((a i - a j) / 2))) / 2 := by
              rw [Finset.sum_add_distrib, Finset.sum_div, Finset.sum_div]
    _ = _ := by
        rw [hS1, hS2]
        ring

end PrimeSpectrumTensor
