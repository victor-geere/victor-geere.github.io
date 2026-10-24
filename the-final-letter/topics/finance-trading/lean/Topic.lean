import Mathlib

/-!
# Finance / trading ebooks — formal core

The archived source is an index of finance ebooks.  Its one genuinely finite
computation is the binomial-lattice action sum of `continuous-lattice.html`
§3–§4: with exposure `a = 1 / (S * ε)`, the action `f(S, a) = S * a` is the
constant `1 / ε`, so the probability-weighted sum over the `k`-th lattice
level is `1 / ε`, and the total over `n` levels is `(n + 1) / ε`.

The second object is the two-point lattice behind the volatility-drag
approximation: gross returns `1 + r` and `1 - r`, arithmetic mean `1`,
variance `r ^ 2`.  The exact log growth is `log (1 - r ^ 2) / 2`, which is
strictly below the approximation `-r ^ 2 / 2`.

Nothing here is a statement about market returns, and no archived performance
claim is asserted.  The analytic convergence and the Kelly optimisation are
recorded as source claims in the programme dossier, not proved here.
-/

noncomputable section

open Finset
open scoped BigOperators

namespace FinanceLattice

/-- Binomial weight of `j` up moves in `k` steps: `C(k,j) p^j (1-p)^(k-j)`. -/
def binomWeight (p : ℝ) (k j : ℕ) : ℝ :=
  p ^ j * (1 - p) ^ (k - j) * (k.choose j : ℝ)

/-- Lattice node value after `j` up moves and `k - j` down moves. -/
def nodeValue (S₀ u d : ℝ) (k j : ℕ) : ℝ :=
  S₀ * u ^ j * d ^ (k - j)

/-- The source's exposure action: `a = 1 / (S * ε)` and `f(S, a) = S * a`. -/
def action (S ε : ℝ) : ℝ :=
  S * (1 / (S * ε))

/-- Binomial weights are non-negative for a probability `0 ≤ p ≤ 1`. -/
theorem binomWeight_nonneg {p : ℝ} (hp0 : 0 ≤ p) (hp1 : p ≤ 1) (k j : ℕ) :
    0 ≤ binomWeight p k j := by
  unfold binomWeight
  have h1 : 0 ≤ p ^ j := pow_nonneg hp0 j
  have h2 : 0 ≤ (1 - p) ^ (k - j) := pow_nonneg (by linarith) (k - j)
  have h3 : (0 : ℝ) ≤ (k.choose j : ℝ) := Nat.cast_nonneg (k.choose j)
  exact mul_nonneg (mul_nonneg h1 h2) h3

/-- The binomial theorem: the probability weights on one lattice level sum to one. -/
theorem sum_binomialWeight (p : ℝ) (k : ℕ) :
    ∑ j ∈ range (k + 1), binomWeight p k j = 1 := by
  have h := add_pow p (1 - p) k
  rw [show p + (1 - p) = 1 by ring, one_pow] at h
  simpa [binomWeight] using h.symm

/-- Every node value is positive when the initial value and both factors are. -/
theorem nodeValue_pos {S₀ u d : ℝ} (hS : 0 < S₀) (hu : 0 < u) (hd : 0 < d)
    (k j : ℕ) : 0 < nodeValue S₀ u d k j := by
  unfold nodeValue
  exact mul_pos (mul_pos hS (pow_pos hu j)) (pow_pos hd (k - j))

/-- The exposure action is the constant `1 / ε` whenever `S` and `ε` are non-zero. -/
theorem action_eq_inv {S ε : ℝ} (hS : S ≠ 0) (hε : ε ≠ 0) :
    action S ε = 1 / ε := by
  unfold action
  field_simp [hS, hε]

/-- The probability-weighted action sum on the `k`-th lattice level is `1 / ε`. -/
theorem sum_lattice_action (S₀ u d ε p : ℝ) (k : ℕ)
    (hS : 0 < S₀) (hu : 0 < u) (hd : 0 < d) (hε : ε ≠ 0) :
    ∑ j ∈ range (k + 1),
        binomWeight p k j * action (nodeValue S₀ u d k j) ε = 1 / ε := by
  have hterm : ∀ j ∈ range (k + 1),
      binomWeight p k j * action (nodeValue S₀ u d k j) ε
        = binomWeight p k j * (1 / ε) := by
    intro j _
    rw [action_eq_inv (ne_of_gt (nodeValue_pos hS hu hd k j)) hε]
  calc
    ∑ j ∈ range (k + 1), binomWeight p k j * action (nodeValue S₀ u d k j) ε
        = ∑ j ∈ range (k + 1), binomWeight p k j * (1 / ε) :=
          sum_congr rfl hterm
    _ = (∑ j ∈ range (k + 1), binomWeight p k j) * (1 / ε) := by
          rw [sum_mul]
    _ = 1 * (1 / ε) := by rw [sum_binomialWeight]
    _ = 1 / ε := one_mul _

/-- Summing the constant level contribution over `n + 1` levels gives `(n + 1) / ε`. -/
theorem total_action_sum (ε : ℝ) (n : ℕ) :
    ∑ _k ∈ range (n + 1), (1 / ε) = ((n : ℝ) + 1) / ε := by
  rw [sum_const, card_range, nsmul_eq_mul, div_eq_mul_inv]
  push_cast
  ring

/-- Two-point volatility drag: the exact log growth of `+r` / `-r` is strictly
below the `-σ²/2` approximation with `σ² = r²`. -/
theorem log_two_point_growth_lt {r : ℝ} (h0 : 0 < r) (h1 : r < 1) :
    (1 / 2 : ℝ) * Real.log (1 - r ^ 2) < -(r ^ 2) / 2 := by
  have hxpos : 0 < 1 - r ^ 2 := by nlinarith
  have hxne : 1 - r ^ 2 ≠ 1 := by
    intro h
    have hr2 : r ^ 2 = 0 := by linarith
    nlinarith
  have hlog : Real.log (1 - r ^ 2) < (1 - r ^ 2) - 1 :=
    Real.log_lt_sub_one_of_pos hxpos hxne
  nlinarith

end FinanceLattice
