import Mathlib

/-!
# Partial-sum + tail harvesting

This file ports the Route C truncation logic from `~/workspace/rh`
(`Rh45/Routes.lean`, `Generic.lean`, `DirichletExplicitWiring2.lean`) into the
geometric-DQPT programme. It is stated for `ℝ` and `ℂ` simultaneously via
`RCLike`, so it applies to real truncations and complex Dirichlet sums.

* a finite partial sum plus the tail is the total sum;
* the residual is bounded by the norm of the tail;
* the three-tail and arbitrary-finite-family forms.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

variable {𝕜 : Type*} [RCLike 𝕜]

/-- A finite partial sum plus the shifted tail is the total sum. -/
theorem tsum_eq_finite_add_tail {f : ℕ → 𝕜} (hf : Summable f) (K : ℕ) :
    ∑' n, f n = ∑ n ∈ Finset.range K, f n + ∑' n, f (n + K) :=
  (hf.sum_add_tsum_nat_add K).symm

/-- The truncation residual is bounded by the norm of the shifted tail. -/
theorem truncation_residual_le_tail_norm {f : ℕ → 𝕜} (hf : Summable f) (K : ℕ) :
    ‖(∑' n, f n) - ∑ n ∈ Finset.range K, f n‖ ≤ ∑' n, ‖f (n + K)‖ := by
  rw [tsum_eq_finite_add_tail hf K]
  rw [add_sub_cancel_left]
  have hnorm : Summable fun n : ℕ => ‖f (n + K)‖ := by
    exact (summable_nat_add_iff K).2 hf.norm
  exact norm_tsum_le_tsum_norm hnorm

/-- The arbitrary finite-family tail bound: if the total splits as the computed
partial sum plus a finite family of tails, the residual is bounded by the sum of
the tail norms. -/
theorem truncation_residual_le_finset_tail_norm {ι : Type*} [DecidableEq ι]
    (s : Finset ι) (tail : ι → 𝕜) {lhs computed : 𝕜}
    (hsplit : lhs = computed + ∑ i ∈ s, tail i) :
    ‖lhs - computed‖ ≤ ∑ i ∈ s, ‖tail i‖ := by
  have h : lhs - computed = ∑ i ∈ s, tail i := by
    rw [hsplit]
    abel
  rw [h]
  clear hsplit h
  induction s using Finset.induction_on with
  | empty => simp
  | insert a s ha ih =>
      rw [Finset.sum_insert ha]
      calc
        ‖tail a + ∑ i ∈ s, tail i‖ ≤ ‖tail a‖ + ‖∑ i ∈ s, tail i‖ := norm_add_le _ _
        _ ≤ ‖tail a‖ + ∑ i ∈ s, ‖tail i‖ := by linarith [ih]
        _ = ∑ i ∈ insert a s, ‖tail i‖ := by rw [Finset.sum_insert ha]

/-- The three-tail form, the exact shape of the Route C residual bound. -/
theorem truncation_residual_le_three_tails
    {lhs rhsTrue rhsComputed zeroTail primeTail archTail : 𝕜}
    (hlhs : lhs = rhsTrue)
    (hsplit : rhsTrue = rhsComputed + (zeroTail + primeTail + archTail)) :
    ‖lhs - rhsComputed‖ ≤ ‖zeroTail‖ + ‖primeTail‖ + ‖archTail‖ := by
  have h : lhs - rhsComputed = zeroTail + primeTail + archTail := by
    rw [hlhs, hsplit]
    abel
  rw [h]
  calc
    ‖zeroTail + primeTail + archTail‖
        ≤ ‖zeroTail + primeTail‖ + ‖archTail‖ := norm_add_le _ _
    _ ≤ (‖zeroTail‖ + ‖primeTail‖) + ‖archTail‖ := by
          linarith [norm_add_le zeroTail primeTail]
    _ = ‖zeroTail‖ + ‖primeTail‖ + ‖archTail‖ := by ring

end GeoDQPT
