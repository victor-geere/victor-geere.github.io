import EMTaylorStep

/-!
# The certified zero is on the critical line, and simple

`EMTaylorStep.lean` closed the Krawczyk chain for `s14 = 1/2 + 14i` and produced a
zero in the closed `1/5`-ball.  That ball is two-dimensional, so by itself it only
brackets the real part to `[3/10, 7/10]`.  This file upgrades the certificate to

```
∃ z ∈ closedBall s14 (1/5), ζ z = 0 ∧ z.re = 1/2 ∧ deriv ζ z ≠ 0.
```

The two ingredients are already present in the finite-window-zeros build; the
partial-sum-plus-tail evaluator is **not** used (and could not be: its closed
rectangle enclosure is so far only for `Re s > 1`, and no amount of pointwise
evaluation can confine a zero to a line).

1. **Uniqueness.**  The Krawczyk inequality `‖1 − Yk·ζ′‖ ≤ 1/4` on the ball is a
   `1/4`-contraction of the Newton map `z ↦ z − Yk·ζ(z)`; `norm_newton_sub_le`
   (`Krawczyk.lean`) then gives `‖x − y‖ ≤ (1/4)‖x − y‖` for two zeros, so the
   zero in the ball is unique.
2. **Reflection.**  `riemannZeta_conj` and the functional equation
   `riemannZeta_one_sub` make the reflection in the critical line,
   `ρ(s) = 1 − conj s`, preserve zeros; the ball is `ρ`-invariant because it is
   centred on the line.  A unique zero fixed by `ρ` has `Re = 1/2`.

The same inequality also forces `Yk·ζ′(z) ≠ 0` at the zero, so the zero is simple.
This is one zero on the line, not a zero count and not a Riemann hypothesis claim.

No `sorry`, no `axiom`, no `admit`.
-/

noncomputable section

namespace FiniteWindowZeros

open Filter Topology

/-! ## 1. Uniqueness from the Krawczyk contraction -/

/-- **Uniqueness from the contraction.** If the Newton map `z ↦ z − Y f z` is a
`q`-contraction (`q < 1`) on the closed ball, a zero of `f` in that ball is unique. -/
theorem zero_unique_of_contraction {f f' : ℂ → ℂ} {x0 : ℂ} {r q : ℝ} {Y : ℂ}
    (hq1 : q < 1)
    (h : ∀ z ∈ Metric.closedBall x0 r, HasDerivAt f (f' z) z)
    (hC : ∀ z ∈ Metric.closedBall x0 r, ‖1 - Y * f' z‖ ≤ q)
    {x y : ℂ} (hx : x ∈ Metric.closedBall x0 r) (hy : y ∈ Metric.closedBall x0 r)
    (hfx : f x = 0) (hfy : f y = 0) : x = y := by
  have hseg : segment ℝ x y ⊆ Metric.closedBall x0 r :=
    (convex_closedBall x0 r).segment_subset hx hy
  have hderiv : ∀ z ∈ segment ℝ x y, HasDerivAt f (f' z) z := fun z hz => h z (hseg hz)
  have hbound : ∀ z ∈ segment ℝ x y, ‖1 - Y * f' z‖ ≤ q := fun z hz => hC z (hseg hz)
  have hlip := norm_newton_sub_le (x := x) (y := y) (Y := Y) (q := q) hderiv hbound
  have hd : ‖x - y‖ ≤ q * ‖x - y‖ := by
    simpa [hfx, hfy] using hlip
  have hd0 : ‖x - y‖ = 0 := by nlinarith [norm_nonneg (x - y)]
  exact sub_eq_zero.mp (norm_eq_zero.mp hd0)

/-- **The certified zero is unique in the closed `1/5`-ball** (contraction `1/4 < 1`). -/
theorem zeta_zero_unique {Y : ℂ}
    (hC : ∀ z ∈ Metric.closedBall s14 (1 / 5), ‖1 - Y * deriv riemannZeta z‖ ≤ (1 / 4 : ℝ))
    {x y : ℂ} (hx : x ∈ Metric.closedBall s14 (1 / 5))
    (hy : y ∈ Metric.closedBall s14 (1 / 5))
    (hfx : riemannZeta x = 0) (hfy : riemannZeta y = 0) : x = y :=
  zero_unique_of_contraction (by norm_num)
    (fun z hz => (differentiableAt_riemannZeta (fifth_ball_ne_one z hz)).hasDerivAt) hC hx hy hfx hfy

/-! ## 2. The reflection in the critical line preserves zeros -/

/-- **Zeros reflect through `s ↦ 1 − conj s`:** conjugation from the real coefficients,
`s ↦ 1 − s` from the functional equation.  Off the real axis the functional-equation
factor is harmless because only the implication `ζ s = 0 → ζ (1 − s) = 0` is used. -/
theorem zeta_zero_one_sub_conj {z : ℂ} (hz : riemannZeta z = 0) (him : z.im ≠ 0) :
    riemannZeta (1 - (starRingEnd ℂ) z) = 0 := by
  have hcz : riemannZeta ((starRingEnd ℂ) z) = 0 := by
    rw [riemannZeta_conj]
    simp [hz]
  have hne : ∀ n : ℕ, (starRingEnd ℂ) z ≠ -(n : ℂ) := by
    intro n h
    apply him
    have := congrArg Complex.im h
    simpa using this
  have hne1 : (starRingEnd ℂ) z ≠ 1 := by
    intro h
    apply him
    have := congrArg Complex.im h
    simpa using this
  rw [riemannZeta_one_sub hne hne1, hcz, mul_zero]

/-- The closed `1/5`-ball at `s14` is invariant under the reflection
`s ↦ 1 − conj s` in the critical line. -/
theorem mem_ball_one_sub_conj {z : ℂ} (hz : z ∈ Metric.closedBall s14 (1 / 5)) :
    (1 - (starRingEnd ℂ) z) ∈ Metric.closedBall s14 (1 / 5) := by
  rw [Metric.mem_closedBall, dist_eq_norm] at hz ⊢
  have h : 1 - (starRingEnd ℂ) z - s14 = -((starRingEnd ℂ) (z - s14)) := by
    refine Complex.ext ?_ ?_ <;> simp [s14] <;> ring
  rw [h, norm_neg, Complex.norm_conj]
  exact hz

/-- Inside the ball the imaginary part is at least `14 − 1/5`, hence nonzero. -/
theorem im_ne_zero_of_ball {z : ℂ} (hz : z ∈ Metric.closedBall s14 (1 / 5)) :
    z.im ≠ 0 := by
  have h1 : |z.im - 14| ≤ ‖z - s14‖ := by
    have := Complex.abs_im_le_norm (z - s14)
    simpa [s14] using this
  have h2 : ‖z - s14‖ ≤ (1 / 5 : ℝ) := by
    simpa [Metric.mem_closedBall, dist_eq_norm] using hz
  have h3 : |z.im - 14| ≤ (1 / 5 : ℝ) := h1.trans h2
  intro h
  rw [h] at h3
  norm_num at h3

/-! ## 3. The zero on the line, and simple -/

/-- **A simple zero on the critical line.**  The Krawczyk contraction makes the zero
unique in a ball that `s ↦ 1 − conj s` preserves, and the functional equation makes that
reflection preserve zeros, so the zero is fixed by it: `Re = 1/2`.  The same inequality
gives `ζ′(z) ≠ 0`, so the zero is simple. -/
theorem zeta_zero_14_on_line_simple :
    ∃ z ∈ Metric.closedBall s14 (1 / 5), riemannZeta z = 0 ∧ z.re = (1 / 2 : ℝ) ∧
      deriv riemannZeta z ≠ 0 := by
  obtain ⟨z, hz, hzero⟩ := zeta_zero_14
  have hC := hC_of_bounds h1_deriv h2_deriv
  have him : z.im ≠ 0 := im_ne_zero_of_ball hz
  have hconj : riemannZeta (1 - (starRingEnd ℂ) z) = 0 := zeta_zero_one_sub_conj hzero him
  have hmem : (1 - (starRingEnd ℂ) z) ∈ Metric.closedBall s14 (1 / 5) :=
    mem_ball_one_sub_conj hz
  have heq : 1 - (starRingEnd ℂ) z = z := zeta_zero_unique hC hmem hz hconj hzero
  have hre : 1 - z.re = z.re := by
    have := congrArg Complex.re heq
    simpa using this
  have hd : deriv riemannZeta z ≠ 0 := by
    intro hd0
    have hb := hC z hz
    rw [hd0, mul_zero, sub_zero] at hb
    norm_num at hb
  exact ⟨z, hz, hzero, by linarith, hd⟩

/-- **The certified zero is on the critical line:** `Re z = 1/2`. -/
theorem zeta_zero_14_on_line :
    ∃ z ∈ Metric.closedBall s14 (1 / 5), riemannZeta z = 0 ∧ z.re = (1 / 2 : ℝ) := by
  obtain ⟨z, hz, hzero, hre, _⟩ := zeta_zero_14_on_line_simple
  exact ⟨z, hz, hzero, hre⟩

/-- **The certified zero is simple:** `ζ′(z) ≠ 0`. -/
theorem zeta_zero_14_simple :
    ∃ z ∈ Metric.closedBall s14 (1 / 5), riemannZeta z = 0 ∧ deriv riemannZeta z ≠ 0 := by
  obtain ⟨z, hz, hzero, _, hd⟩ := zeta_zero_14_on_line_simple
  exact ⟨z, hz, hzero, hd⟩

end FiniteWindowZeros
