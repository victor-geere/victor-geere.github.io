import Mathlib

/-!
# Harmonic–Geometric Unified Theory — formal core

The archived source (`archive/maths/research-programme.html`) is a research
*plan*, not a proof: it names objects (the greedy harmonic expansion of
angles, the Greedy–Egyptian categories, the transfer operator) but does not
define them precisely or prove anything about them.  This file therefore
formalises only the elementary harmonic/Egyptian arithmetic that the plan
presupposes:

* the Egyptian unit weight `1/(n+1)`, which is the weight of the `n`-th
  greedy Egyptian summand;
* the greedy harmonic angle `π/(n+2)`;
* the finite harmonic partial sum `Σ_{n<N} 1/(n+1)`.

The seven declarations below are genuine, source-relevant facts about these
objects.  None of the source's conjectures (Spectral RH, GRH, the
monotonicity inequality, the Fredholm determinant identity) is asserted
here; they are recorded as open items in the programme dossier.
-/

noncomputable section

open Filter Topology
open scoped BigOperators

namespace HGU

/-- The Egyptian unit weight of index `n`: `1/(n+1)`. -/
def egyptWeight (n : ℕ) : ℝ := 1 / ((n : ℝ) + 1)

/-- The greedy harmonic angle of index `n`: `π/(n+2)`. -/
def harmonicAngle (n : ℕ) : ℝ := Real.pi / ((n : ℝ) + 2)

/-- The finite harmonic sum `H_N = Σ_{n<N} 1/(n+1)`. -/
def harmonicSum (N : ℕ) : ℝ := ∑ n ∈ Finset.range N, egyptWeight n

/-- T1: every Egyptian unit weight is positive. -/
theorem egyptWeight_pos (n : ℕ) : 0 < egyptWeight n := by
  unfold egyptWeight
  positivity

/-- T2: the Egyptian weights are strictly decreasing in the index. -/
theorem egyptWeight_strictAnti : StrictAnti egyptWeight := by
  intro a b hab
  unfold egyptWeight
  have h : (a : ℝ) + 1 < (b : ℝ) + 1 := by
    exact_mod_cast Nat.add_lt_add_right hab 1
  exact one_div_lt_one_div_of_lt (by positivity) h

/-- T3: the Egyptian weights tend to zero (so the greedy remainder can
always be made small). -/
theorem egyptWeight_tendsto_zero : Tendsto egyptWeight atTop (𝓝 0) := by
  have h := tendsto_const_div_atTop_nhds_zero_nat (𝕜 := ℝ) (1 : ℝ)
  have h2 : Tendsto (fun n : ℕ => (1 : ℝ) / (((n + 1 : ℕ) : ℝ))) atTop (𝓝 0) :=
    h.comp (tendsto_add_atTop_nat 1)
  have h3 : Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1)) atTop (𝓝 0) := by
    simpa [Nat.cast_add, Nat.cast_one] using h2
  change Tendsto (fun n : ℕ => (1 : ℝ) / ((n : ℝ) + 1)) atTop (𝓝 0)
  exact h3

/-- T4: the rescaled greedy harmonic angle is exactly `1/(n+2)`; equivalently
`(n+2) α_n = π`. -/
theorem harmonicAngle_scaled (n : ℕ) :
    ((n : ℝ) + 2) * harmonicAngle n = Real.pi := by
  unfold harmonicAngle
  have h : ((n : ℝ) + 2) ≠ 0 := by positivity
  field_simp

/-- T5: the harmonic partial sums satisfy the defining successor identity. -/
theorem harmonicSum_succ (N : ℕ) :
    harmonicSum (N + 1) = harmonicSum N + egyptWeight N := by
  unfold harmonicSum
  rw [Finset.sum_range_succ]

/-- T6: the harmonic partial sums are monotone. -/
theorem harmonicSum_mono : Monotone harmonicSum := by
  intro a b hab
  unfold harmonicSum
  apply Finset.sum_le_sum_of_subset_of_nonneg
  · exact Finset.range_subset_range.mpr hab
  · intro x _ hx
    exact le_of_lt (egyptWeight_pos x)

/-- T7: the exact value `H_4 = 1 + 1/2 + 1/3 + 1/4 = 25/12`. -/
theorem harmonicSum_four : harmonicSum 4 = 25 / 12 := by
  norm_num [harmonicSum, egyptWeight, Finset.sum_range_succ]

end HGU
