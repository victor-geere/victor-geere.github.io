import Mathlib

/-!
# GDST twin series — formal core

The archived GDST programme splits the shifted zeta prefix into a
*selected* series `E` and a *rejected* series `Ω`, according to the greedy
harmonic digits `δ_n(θ) ∈ {0,1}`.  The source sums are infinite and are
claimed to converge on `Re s > 0`; that analytic statement is a source
claim in the programme dossier, not a theorem here.

This file formalises only the finite prefix of the decomposition.  For an
arbitrary binary selection word `δ`, it defines

* the weight `term n s = (n+2)^(-s)`;
* `selected δ s N = Σ_{n<N, δ n} term n s`;
* `rejected δ s N = Σ_{n<N, not (δ n)} term n s`;
* `partialZeta s N = Σ_{n<N} term n s`;

and proves that the two complementary prefixes add to the full prefix,
that each is non-negative, and that the selected prefix is bounded by the
full prefix.  The complement identity is the finite form of the source's
`E(θ,s) + Ω(θ,s) = ζ(s) - 1`.  The limit, the zeta function, the balance
angles and the source's RH characterisation are left to the dossier.
-/

noncomputable section

open scoped BigOperators

namespace GDSTTwin

/-- The Dirichlet weight `(n + 2)^(-s)` of the GDST series. -/
def term (n : ℕ) (s : ℝ) : ℝ := ((n : ℝ) + 2) ^ (-s)

/-- The full shifted zeta prefix `Σ_{n<N} (n+2)^(-s)`. -/
def partialZeta (s : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range N, term n s

/-- The selected prefix `E_N(s) = Σ_{n<N, δ_n=1} (n+2)^(-s)`. -/
def selected (δ : ℕ → Bool) (s : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range N, if δ n then term n s else 0

/-- The rejected prefix `Ω_N(s) = Σ_{n<N, δ_n=0} (n+2)^(-s)`. -/
def rejected (δ : ℕ → Bool) (s : ℝ) (N : ℕ) : ℝ :=
  ∑ n ∈ Finset.range N, if δ n then 0 else term n s

/-- T1: every Dirichlet weight is strictly positive. -/
theorem term_pos (n : ℕ) (s : ℝ) : 0 < term n s := by
  unfold term
  exact Real.rpow_pos_of_pos (by positivity) _

/-- T2: the selected prefix is non-negative. -/
theorem selected_nonneg (δ : ℕ → Bool) (s : ℝ) (N : ℕ) :
    0 ≤ selected δ s N := by
  unfold selected
  refine Finset.sum_nonneg ?_
  intro n _
  split
  · exact le_of_lt (term_pos n s)
  · exact le_rfl

/-- T3: the rejected prefix is non-negative. -/
theorem rejected_nonneg (δ : ℕ → Bool) (s : ℝ) (N : ℕ) :
    0 ≤ rejected δ s N := by
  unfold rejected
  refine Finset.sum_nonneg ?_
  intro n _
  split
  · exact le_rfl
  · exact le_of_lt (term_pos n s)

/-- T4: the finite complement identity
`E_N(s) + Ω_N(s) = Σ_{n<N} (n+2)^(-s)`. -/
theorem selected_add_rejected (δ : ℕ → Bool) (s : ℝ) (N : ℕ) :
    selected δ s N + rejected δ s N = partialZeta s N := by
  unfold selected rejected partialZeta
  rw [← Finset.sum_add_distrib]
  refine Finset.sum_congr rfl ?_
  intro n _
  cases δ n <;> simp

/-- T5: the selected prefix is bounded by the full prefix. -/
theorem selected_le_partialZeta (δ : ℕ → Bool) (s : ℝ) (N : ℕ) :
    selected δ s N ≤ partialZeta s N := by
  have h := selected_add_rejected δ s N
  have hr := rejected_nonneg δ s N
  linarith

/-- T6: at `s = 0` every weight is `1`, so the prefix has value `N`. -/
theorem partialZeta_zero (N : ℕ) : partialZeta 0 N = (N : ℝ) := by
  unfold partialZeta term
  simp [Real.rpow_zero]

end GDSTTwin
