import Mathlib

/-!
# Greedy harmonic zeta — formal core

The archived source proposes a greedy condition on the partial sums of the
Dirichlet eta function and claims an equivalence with the Riemann
Hypothesis.  The equivalence and the analytic argument are *not* formalised
here.  This file proves only the finite elementary layer that the source
actually defines:

* the terms `term σ n = (n+1)^{-σ}` and their positivity/monotonicity;
* the finite eta--zeta identity for an even number of terms;
* the value of the alternating partial sums at `σ = 0`;
* the quadratic identity behind the greedy step and the resulting
  "adding is closer than subtracting" comparison.

Every declaration below is fully proved.
-/

noncomputable section

open scoped BigOperators

namespace GreedyZeta

/-- The `n`-th magnitude `(n+1)^{-σ}` of the eta/Dirichlet series. -/
def term (σ : ℝ) (n : ℕ) : ℝ := ((n : ℝ) + 1) ^ (-σ)

/-- The finite Dirichlet (zeta) partial sum `∑_{n=1}^{N} n^{-σ}`. -/
def zetaPartial (σ : ℝ) (N : ℕ) : ℝ :=
  (Finset.range N).sum (fun n => term σ n)

/-- The finite eta partial sum `∑_{n=1}^{N} (-1)^{n-1} n^{-σ}`. -/
def etaPartial (σ : ℝ) (N : ℕ) : ℝ :=
  (Finset.range N).sum (fun n => (-1 : ℝ) ^ n * term σ n)

/-- The real correlation `Re(conj S * w)` driving the greedy step. -/
def corr (S w : ℂ) : ℝ := (S * starRingEnd ℂ w).re

/-- Every term of the eta series is strictly positive. -/
theorem term_pos (σ : ℝ) (n : ℕ) : 0 < term σ n := by
  unfold term
  positivity

/-- For a positive exponent, the magnitudes decrease strictly in `n`. -/
theorem term_strictAnti {σ : ℝ} (hσ : 0 < σ) : StrictAnti (term σ) := by
  intro a b hab
  unfold term
  have hlt : ((a : ℝ) + 1) < ((b : ℝ) + 1) := by
    exact_mod_cast Nat.add_lt_add_right hab 1
  exact Real.rpow_lt_rpow_of_neg (by positivity) hlt (neg_neg_of_pos hσ)

/-- The finite eta--zeta identity for an even number of terms:
`η_N = Z_N - 2 · 2^{-σ} · Z_{N/2}` with `N = 2m`.  This is the finite
form of `η(s) = (1 - 2^{1-s}) ζ(s)`. -/
theorem eta_zeta_even (σ : ℝ) (m : ℕ) :
    etaPartial σ (2 * m) =
      zetaPartial σ (2 * m) - 2 * (2 : ℝ) ^ (-σ) * zetaPartial σ m := by
  induction m with
  | zero => simp [etaPartial, zetaPartial]
  | succ m ih =>
      have hsplit : 2 * (m + 1) = 2 * m + 1 + 1 := by ring
      have hterm : (2 : ℝ) ^ (-σ) * term σ m = term σ (2 * m + 1) := by
        unfold term
        rw [show ((2 * m + 1 : ℕ) : ℝ) + 1 = 2 * ((m : ℝ) + 1) by
          push_cast
          ring]
        rw [Real.mul_rpow (by norm_num) (by positivity)]
      have h1 : (-1 : ℝ) ^ (2 * m) = 1 :=
        Even.neg_one_pow ⟨m, by ring⟩
      have h2 : (-1 : ℝ) ^ (2 * m + 1) = -1 :=
        Odd.neg_one_pow ⟨m, rfl⟩
      have heta :
          etaPartial σ (2 * m + 1 + 1) =
            etaPartial σ (2 * m) + term σ (2 * m) - term σ (2 * m + 1) := by
        unfold etaPartial
        rw [Finset.sum_range_succ, Finset.sum_range_succ]
        simp only [h1, h2, one_mul, neg_one_mul]
        ring
      have hzeta :
          zetaPartial σ (2 * m + 1 + 1) =
            zetaPartial σ (2 * m) + term σ (2 * m) + term σ (2 * m + 1) := by
        unfold zetaPartial
        rw [Finset.sum_range_succ, Finset.sum_range_succ]
      have hz : zetaPartial σ (m + 1) = zetaPartial σ m + term σ m := by
        unfold zetaPartial
        rw [Finset.sum_range_succ]
      rw [hsplit, heta, ih, hzeta, hz, hterm.symm]
      ring

/-- At `σ = 0` the even alternating partial sums vanish. -/
theorem eta_zero_even (m : ℕ) : etaPartial 0 (2 * m) = 0 := by
  have hz : ∀ N : ℕ, zetaPartial 0 N = (N : ℝ) := by
    intro N
    simp [zetaPartial, term]
  rw [eta_zeta_even, hz, hz]
  have h2 : (2 : ℝ) ^ (-(0 : ℝ)) = 1 := by norm_num
  rw [h2]
  push_cast
  ring

/-- At `σ = 0` the odd alternating partial sums equal `1`. -/
theorem eta_zero_odd (m : ℕ) : etaPartial 0 (2 * m + 1) = 1 := by
  have h1 : (-1 : ℝ) ^ (2 * m) = 1 := Even.neg_one_pow ⟨m, by ring⟩
  have hstep :
      etaPartial 0 (2 * m + 1) = etaPartial 0 (2 * m) + term 0 (2 * m) := by
    unfold etaPartial
    rw [Finset.sum_range_succ]
    simp only [h1, one_mul]
  rw [hstep, eta_zero_even]
  simp [term]

/-- The quadratic identity behind the greedy step:
`|S + w|² = |S|² + |w|² + 2 Re(conj S w)`. -/
theorem normSq_add_corr (S w : ℂ) :
    Complex.normSq (S + w) =
      Complex.normSq S + Complex.normSq w + 2 * corr S w := by
  rw [Complex.normSq_add]
  rfl

/-- If the correlation is non-positive, adding `w` is closer to the origin
than subtracting it.  This is the genuine content behind the source's
greedy comparison, stated without the source's sign slip. -/
theorem greedy_closer {S w : ℂ} (h : corr S w ≤ 0) :
    Complex.normSq (S + w) ≤ Complex.normSq (S - w) := by
  rw [normSq_add_corr, Complex.normSq_sub]
  rw [show (S * starRingEnd ℂ w).re = corr S w from rfl]
  linarith

end GreedyZeta
