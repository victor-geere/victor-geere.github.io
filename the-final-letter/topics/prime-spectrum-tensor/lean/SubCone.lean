import Mathlib
import GaussianGram

/-!
# The sub-cone problem: what the pole term forbids

`HANDOFF-M0P-NEXT.md` §4.3(3) asks for a *sub-cone theorem*: positivity of the
Weil form on a structured closed subspace of the Gaussian Hilbert space rather
than on more and more basis elements.  This file isolates the first structural
obstruction any such theorem must confront.

The Weil kernel's pole part is not a decaying kernel.  In closed form

```
poleTerm c σ = 4πσ² e^{σ²/4} cosh(c/2),
```

which **grows** like `e^{|c|/2}` (`poleTerm_growth`, `poleTerm_unbounded`).  As a
quadratic form on a finite family of centres with weights `x_a` it is exactly
rank two:

```
Σ_{a,b} x_a x_b poleTerm (c_a − c_b) σ
  = 4πσ² e^{σ²/4} · (Σ_a x_a e^{c_a/2}) · (Σ_b x_b e^{−c_b/2}),
```

an indefinite form in the two exponential moments
`u = Σ x_a e^{c_a/2}`, `v = Σ x_a e^{−c_a/2}` (`sum_poleTerm_eq`).

Consequences:

* no decay or diagonal-dominance argument can apply to the Weil Gram matrix —
  its entries grow without bound in the separation;
* the natural pole-free subspace is `{u = 0}` or `{v = 0}` (codimension one
  each), on which the pole contributes nothing and the form reduces to the
  density and prime parts (`sum_poleTerm_eq_zero`).

These are structural facts, not a sub-cone theorem; the analysis is in
[`../SUB-CONE.md`](../SUB-CONE.md).
-/

noncomputable section

open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The pole term is a hyperbolic cosine in the separation. -/
theorem poleTerm_eq (c σ : ℝ) :
    poleTerm c σ = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2) := rfl

/-- **The pole term grows exponentially** in the separation. -/
theorem poleTerm_growth (c σ : ℝ) (hσ : 0 < σ) :
    4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) / 2 * Real.exp (c / 2) ≤ poleTerm c σ := by
  rw [poleTerm_eq]
  have hbase : (0 : ℝ) < 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) := by positivity
  have hcosh : Real.exp (c / 2) / 2 ≤ Real.cosh (c / 2) := by
    rw [Real.cosh_eq]
    have hpos : (0 : ℝ) < Real.exp (-(c / 2)) := Real.exp_pos _
    linarith
  calc 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) / 2 * Real.exp (c / 2)
      = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * (Real.exp (c / 2) / 2) := by ring
    _ ≤ 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) * Real.cosh (c / 2) := by
        exact mul_le_mul_of_nonneg_left hcosh hbase.le

/-- **The pole term is unbounded**: the Weil kernel is not a decaying kernel. -/
theorem poleTerm_unbounded (σ : ℝ) (hσ : 0 < σ) :
    ∀ M : ℝ, ∃ c : ℝ, M ≤ poleTerm c σ := by
  intro M
  set C : ℝ := 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) / 2 with hC
  have hCpos : 0 < C := by positivity
  have hx : (0 : ℝ) < max (M / C) 0 + 1 := by positivity
  obtain ⟨c, hc⟩ : ∃ c : ℝ, M / C ≤ Real.exp c := by
    refine ⟨Real.log (max (M / C) 0 + 1), ?_⟩
    rw [Real.exp_log hx]
    have hle : M / C ≤ max (M / C) 0 := le_max_left _ _
    linarith
  refine ⟨2 * c, ?_⟩
  have h := poleTerm_growth (2 * c) σ hσ
  have h2 : Real.exp (2 * c / 2) = Real.exp c := by ring_nf
  rw [h2] at h
  have hMC : M ≤ C * Real.exp c := by
    have : M = C * (M / C) := by field_simp
    rw [this]
    exact mul_le_mul_of_nonneg_left hc hCpos.le
  calc M ≤ C * Real.exp c := hMC
    _ ≤ poleTerm (2 * c) σ := h

/-- **The pole form is rank two.**

For any finite family of centres `c` with weights `x`,
`Σ_{a,b} x_a x_b poleTerm (c_a − c_b) σ = C · u · v`
with `C = 4πσ²e^{σ²/4}`, `u = Σ_a x_a e^{c_a/2}` and `v = Σ_b x_b e^{−c_b/2}`. -/
theorem sum_poleTerm_eq {ι : Type*} (s : Finset ι) (c x : ι → ℝ) (σ : ℝ) :
    ∑ a ∈ s, ∑ b ∈ s, x a * x b * poleTerm (c a - c b) σ
      = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) *
        ((∑ a ∈ s, x a * Real.exp (c a / 2)) * (∑ b ∈ s, x b * Real.exp (-(c b) / 2))) := by
  have hcosh : ∀ a b : ι, Real.cosh ((c a - c b) / 2)
      = (Real.exp (c a / 2) * Real.exp (-(c b) / 2)
          + Real.exp (-(c a) / 2) * Real.exp (c b / 2)) / 2 := by
    intro a b
    rw [Real.cosh_eq, ← Real.exp_add, ← Real.exp_add]
    ring_nf
  have hsplit : ∀ a b : ι, x a * x b * Real.cosh ((c a - c b) / 2)
      = (x a * Real.exp (c a / 2)) * (x b * Real.exp (-(c b) / 2)) / 2
        + (x a * Real.exp (-(c a) / 2)) * (x b * Real.exp (c b / 2)) / 2 := by
    intro a b
    rw [hcosh a b]
    ring
  have h1 : ∑ a ∈ s, ∑ b ∈ s, (x a * Real.exp (c a / 2)) * (x b * Real.exp (-(c b) / 2))
      = (∑ a ∈ s, x a * Real.exp (c a / 2)) * (∑ b ∈ s, x b * Real.exp (-(c b) / 2)) :=
    (Finset.sum_mul_sum _ _ _ _).symm
  have h2 : ∑ a ∈ s, ∑ b ∈ s, (x a * Real.exp (-(c a) / 2)) * (x b * Real.exp (c b / 2))
      = (∑ a ∈ s, x a * Real.exp (-(c a) / 2)) * (∑ b ∈ s, x b * Real.exp (c b / 2)) :=
    (Finset.sum_mul_sum _ _ _ _).symm
  have hcore : ∑ a ∈ s, ∑ b ∈ s, x a * x b * Real.cosh ((c a - c b) / 2)
      = (∑ a ∈ s, x a * Real.exp (c a / 2)) * (∑ b ∈ s, x b * Real.exp (-(c b) / 2)) := by
    calc ∑ a ∈ s, ∑ b ∈ s, x a * x b * Real.cosh ((c a - c b) / 2)
        = ∑ a ∈ s, ∑ b ∈ s, ((x a * Real.exp (c a / 2)) * (x b * Real.exp (-(c b) / 2)) / 2
            + (x a * Real.exp (-(c a) / 2)) * (x b * Real.exp (c b / 2)) / 2) := by
          exact Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun b _ => hsplit a b
      _ = (∑ a ∈ s, ∑ b ∈ s, (x a * Real.exp (c a / 2)) * (x b * Real.exp (-(c b) / 2))) / 2
            + (∑ a ∈ s, ∑ b ∈ s, (x a * Real.exp (-(c a) / 2)) * (x b * Real.exp (c b / 2))) / 2 := by
          simp_rw [Finset.sum_add_distrib, Finset.sum_div]
      _ = _ := by rw [h1, h2]; ring
  calc ∑ a ∈ s, ∑ b ∈ s, x a * x b * poleTerm (c a - c b) σ
      = 4 * Real.pi * σ ^ 2 * Real.exp (σ ^ 2 / 4) *
          (∑ a ∈ s, ∑ b ∈ s, x a * x b * Real.cosh ((c a - c b) / 2)) := by
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun a _ => ?_
        rw [Finset.mul_sum]
        refine Finset.sum_congr rfl fun b _ => ?_
        rw [poleTerm_eq]
        ring
    _ = _ := by rw [hcore]

/-- **The pole-free subspace.**  If the first exponential moment vanishes, the
pole part of the Weil quadratic form is zero: what remains is density plus
prime. -/
theorem sum_poleTerm_eq_zero {ι : Type*} (s : Finset ι) (c x : ι → ℝ) (σ : ℝ)
    (hu : ∑ a ∈ s, x a * Real.exp (c a / 2) = 0) :
    ∑ a ∈ s, ∑ b ∈ s, x a * x b * poleTerm (c a - c b) σ = 0 := by
  rw [sum_poleTerm_eq, hu, zero_mul, mul_zero]

end PrimeSpectrumTensor
