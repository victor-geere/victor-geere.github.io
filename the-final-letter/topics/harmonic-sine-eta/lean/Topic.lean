import Mathlib

/-!
# Harmonic sine and the eta function — formal core

The archived fragment `harmonic-sine-eta-v2.html` defines the
non-greedy harmonic sine and cosine series

  `S_α(θ) = Σ (-1)^(n-1) n^(-α) sin(θ log n)`
  `C_α(θ) = Σ (-1)^(n-1) n^(-α) cos(θ log n)`

and identifies them with the imaginary and real parts of the Dirichlet
eta function `η(α + iθ)`.  This file formalises the finite, algebraic
part of that identification:

* the decaying weight `n ↦ n^(-α)` is positive and strictly decreasing;
* the alternating sign is 2-periodic;
* the finite eta partial sums pair adjacent terms;
* the even truncation satisfies the finite factorisation
  `A_(2N)(α) = H_(2N)(α) - 2^(1-α) H_N(α)`, with
  `H_N(α) = Σ_(n=1)^N n^(-α)`;
* even eta partial sums are positive.

The analytic continuation of `η`, the zero-free-region argument and the
claim that `α = 1/2` is the unique admissible exponent are *not*
formalised here; they are recorded as source claims and open items in
the programme dossier.
-/

noncomputable section

open Finset
open scoped BigOperators

namespace HarmonicEta

/-- The decaying weight `n^(-α)` at series index `n + 1`. -/
def weight (α : ℝ) (n : ℕ) : ℝ := ((n : ℝ) + 1) ^ (-α)

/-- The `n`-th alternating eta term `(-1)^n (n+1)^(-α)`, with `n` starting at `0`. -/
def etaTerm (α : ℝ) (n : ℕ) : ℝ := (-1 : ℝ) ^ n * weight α n

/-- The finite alternating (eta) partial sum over indices `0, …, N-1`, i.e. the
truncation of `Σ_(n≥1) (-1)^(n-1) n^(-α)` after `N` terms. -/
def etaPartial (α : ℝ) (N : ℕ) : ℝ := (range N).sum (fun n => etaTerm α n)

/-- The finite cosine partial sum `Σ_(n<N) (-1)^n (n+1)^(-α) cos(θ log(n+1))`. -/
def cosPartial (α θ : ℝ) (N : ℕ) : ℝ :=
  (range N).sum (fun n => (-1 : ℝ) ^ n * weight α n * Real.cos (θ * Real.log ((n : ℝ) + 1)))

/-- The finite sine partial sum `Σ_(n<N) (-1)^n (n+1)^(-α) sin(θ log(n+1))`. -/
def sinPartial (α θ : ℝ) (N : ℕ) : ℝ :=
  (range N).sum (fun n => (-1 : ℝ) ^ n * weight α n * Real.sin (θ * Real.log ((n : ℝ) + 1)))

/-- The weight is positive for every positive exponent. -/
theorem weight_pos {α : ℝ} (_hα : 0 < α) (n : ℕ) : 0 < weight α n := by
  unfold weight
  exact Real.rpow_pos_of_pos (by positivity) (-α)

/-- For a positive exponent the weight is strictly decreasing. -/
theorem weight_lt_succ {α : ℝ} (hα : 0 < α) (n : ℕ) :
    weight α (n + 1) < weight α n := by
  have h1 : (0 : ℝ) < (n : ℝ) + 1 := by positivity
  have h2 : (n : ℝ) + 1 < ((n + 1 : ℕ) : ℝ) + 1 := by
    push_cast
    linarith
  have hp1 : 0 < ((n : ℝ) + 1) ^ α := Real.rpow_pos_of_pos h1 α
  have hp2 : 0 < (((n + 1 : ℕ) : ℝ) + 1) ^ α :=
    Real.rpow_pos_of_pos (by positivity) α
  have hlt : ((n : ℝ) + 1) ^ α < (((n + 1 : ℕ) : ℝ) + 1) ^ α :=
    Real.rpow_lt_rpow (le_of_lt h1) h2 hα
  have hinv : ((((n + 1 : ℕ) : ℝ) + 1) ^ α)⁻¹ < (((n : ℝ) + 1) ^ α)⁻¹ :=
    (inv_lt_inv₀ hp2 hp1).2 hlt
  calc
    weight α (n + 1) = ((((n + 1 : ℕ) : ℝ) + 1) ^ α)⁻¹ := by
      rw [weight, Real.rpow_neg (by positivity)]
    _ < (((n : ℝ) + 1) ^ α)⁻¹ := hinv
    _ = weight α n := by
      rw [weight, Real.rpow_neg (by positivity)]

/-- The alternating sign `(-1)^n` is periodic of period two. -/
theorem sign_period_two (n : ℕ) : (-1 : ℝ) ^ (n + 2) = (-1 : ℝ) ^ n := by
  rw [pow_add, show (-1 : ℝ) ^ 2 = 1 by norm_num, mul_one]

/-- Splitting a finite sum over the first `2N` indices into adjacent pairs. -/
private theorem sum_range_pair (f : ℕ → ℝ) (N : ℕ) :
    (range (2 * N)).sum f = (range N).sum (fun k => f (2 * k) + f (2 * k + 1)) := by
  induction N with
  | zero => simp
  | succ N ih =>
    have h : 2 * (N + 1) = 2 * N + 1 + 1 := by ring
    rw [h]
    conv_lhs => rw [Finset.sum_range_succ, Finset.sum_range_succ]
    conv_rhs => rw [Finset.sum_range_succ]
    rw [ih]
    ring

/-- The odd-index weights are `2^(-α)` times the preceding weights. -/
private theorem sum_range_odd_weight (α : ℝ) (N : ℕ) :
    (range N).sum (fun k => weight α (2 * k + 1)) =
      2 ^ (-α) * (range N).sum (fun k => weight α k) := by
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro k _
  unfold weight
  have hcast : (((2 * k + 1 : ℕ) : ℝ) + 1) = 2 * ((k : ℝ) + 1) := by
    push_cast
    ring
  rw [hcast, Real.mul_rpow (by norm_num : (0 : ℝ) ≤ 2) (by positivity)]

/-- Pairing adjacent terms: the even truncation of the eta series is a sum of
adjacent differences of weights. -/
theorem etaPartial_two_mul (α : ℝ) (N : ℕ) :
    etaPartial α (2 * N) =
      (range N).sum (fun k => weight α (2 * k) - weight α (2 * k + 1)) := by
  unfold etaPartial
  rw [sum_range_pair]
  apply Finset.sum_congr rfl
  intro k _
  have h1 : (-1 : ℝ) ^ (2 * k) = 1 := by
    rw [pow_mul]
    norm_num
  have h2 : (-1 : ℝ) ^ (2 * k + 1) = -1 := by
    rw [pow_succ, h1]
    ring
  simp only [etaTerm]
  rw [h1, h2]
  ring

/-- Finite factorisation of the even eta truncation:
`A_(2N)(α) = H_(2N)(α) - 2^(1-α) H_N(α)`. -/
theorem etaPartial_even_factor (α : ℝ) (N : ℕ) :
    etaPartial α (2 * N) =
      (range (2 * N)).sum (fun n => weight α n) -
        2 ^ (1 - α) * (range N).sum (fun n => weight α n) := by
  have hpow : (2 : ℝ) ^ (1 - α) = 2 * 2 ^ (-α) := by
    rw [show (1 : ℝ) - α = 1 + (-α) by ring, Real.rpow_add (by norm_num)]
    norm_num
  rw [hpow, etaPartial_two_mul, Finset.sum_sub_distrib, sum_range_pair,
    Finset.sum_add_distrib, sum_range_odd_weight]
  ring

/-- Even truncations of the eta series are strictly positive for positive
exponent and at least one pair of terms. -/
theorem etaPartial_even_pos {α : ℝ} (hα : 0 < α) {N : ℕ} (hN : 0 < N) :
    0 < etaPartial α (2 * N) := by
  rw [etaPartial_two_mul]
  apply Finset.sum_pos
  · intro k _
    exact sub_pos.mpr (weight_lt_succ hα (2 * k))
  · exact ⟨0, by simpa using hN⟩

/-- At `θ = 0` the cosine series reduces to the eta series and the sine series
vanishes. -/
theorem cos_sin_at_zero (α : ℝ) (N : ℕ) :
    cosPartial α 0 N = etaPartial α N ∧ sinPartial α 0 N = 0 := by
  constructor
  · unfold cosPartial etaPartial etaTerm
    apply Finset.sum_congr rfl
    intro n _
    simp
  · unfold sinPartial
    simp

end HarmonicEta
