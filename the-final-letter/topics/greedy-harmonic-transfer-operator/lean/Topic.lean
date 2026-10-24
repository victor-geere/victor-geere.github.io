import Mathlib

/-!
# Greedy harmonic transfer operator — reconstruction core

The archived source directory
`archive/maths/rh/research/greedy-harmonic-transfer-operator/` is empty:
it contains no paper, note, prompt, or definition.  Consequently this
file does **not** recover a source definition.  It fixes a small,
explicit reconstruction of a "greedy harmonic transfer operator" so that
the topic has a checkable formal core rather than an unqualified claim.

Reconstruction choices:

* `weight n = 1 / (n + 2)` is the normalised greedy harmonic angle
  `α_n / π`, with `α_n = π / (n + 2)`.
* `transfer` is the weighted shift `(T a) n = weight n * a (n + 1)` on
  real sequences.  It is the simplest positive transfer step compatible
  with the normalised harmonic weights.
* `transferIter k` is its `k`-fold iterate.
* `remainder θ n = θ - weight n` is the normalised greedy remainder
  after a single transfer step.
* `totalWeight N = Σ_{n < N} weight n` is the finite transferred mass.

The theorems below are elementary positivity, monotonicity, bound, and
exact-rational facts about these definitions.  No spectral, Hilbert–Pólya,
RH, or GRH statement is asserted or proved here.
-/

noncomputable section

open scoped BigOperators

namespace GreedyHarmonicTransfer

/-- The normalised harmonic weight `w_n = 1 / (n + 2) = α_n / π`. -/
def weight (n : ℕ) : ℝ := 1 / ((n : ℝ) + 2)

/-- One step of the reconstructed greedy harmonic transfer operator:
the weighted shift `(T a) n = w_n * a (n + 1)`. -/
def transfer (a : ℕ → ℝ) : ℕ → ℝ := fun n => weight n * a (n + 1)

/-- The `k`-fold iterate of the transfer operator. -/
def transferIter : ℕ → (ℕ → ℝ) → ℕ → ℝ
  | 0, a => a
  | k + 1, a => transfer (transferIter k a)

/-- The normalised greedy remainder after one step at index `n`. -/
def remainder (θ : ℝ) (n : ℕ) : ℝ := θ - weight n

/-- The finite transferred mass `W_N = Σ_{n < N} w_n`. -/
def totalWeight (N : ℕ) : ℝ := (Finset.range N).sum weight

/-- **T1.** Every normalised harmonic weight is positive. -/
theorem weight_pos (n : ℕ) : 0 < weight n := by
  unfold weight
  positivity

/-- **T2.** The weights are bounded above by `1 / 2`, the value at `n = 0`. -/
theorem weight_le_half (n : ℕ) : weight n ≤ 1 / 2 := by
  unfold weight
  have h2 : (2 : ℝ) ≤ (n : ℝ) + 2 := by
    have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
    linarith
  exact one_div_le_one_div_of_le (by norm_num : (0 : ℝ) < 2) h2

/-- **T3.** The weight sequence is strictly antitone. -/
theorem weight_strictAnti : StrictAnti weight := by
  intro a b hab
  unfold weight
  have h : ((a : ℝ) + 2) < ((b : ℝ) + 2) := by
    exact_mod_cast Nat.add_lt_add_right hab 2
  exact one_div_lt_one_div_of_lt (by positivity) h

/-- **T4.** The transfer operator preserves pointwise non-negativity. -/
theorem transfer_nonneg {a : ℕ → ℝ} (ha : ∀ n, 0 ≤ a n) (n : ℕ) :
    0 ≤ transfer a n := by
  unfold transfer
  exact mul_nonneg (le_of_lt (weight_pos n)) (ha (n + 1))

/-- **T5.** The transfer operator is pointwise monotone. -/
theorem transfer_mono {a b : ℕ → ℝ} (h : ∀ n, a n ≤ b n) :
    transfer a ≤ transfer b := by
  intro n
  unfold transfer
  exact mul_le_mul_of_nonneg_left (h (n + 1)) (le_of_lt (weight_pos n))

/-- **T6.** Every iterate of the transfer operator preserves non-negativity. -/
theorem transferIter_nonneg {a : ℕ → ℝ} (ha : ∀ n, 0 ≤ a n) :
    ∀ (k n : ℕ), 0 ≤ transferIter k a n
  | 0, n => ha n
  | k + 1, n => transfer_nonneg (fun m => transferIter_nonneg ha k m) n

/-- **T7.** The first two weights transfer exactly `5 / 6` of mass. -/
theorem totalWeight_two : totalWeight 2 = 5 / 6 := by
  norm_num [totalWeight, weight, Finset.sum_range_succ]

end GreedyHarmonicTransfer
