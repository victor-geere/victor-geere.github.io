import Mathlib

/-!
# p-adic and stochastic zeta — formal core

The archived source (`archive/essays/p-adic.html`) is an expository essay
on p-adic numbers, finite p-adic encodings, and the Kubota–Leopoldt
interpolation formula.  It contains no stochastic-process construction and
no proof of the Kubota–Leopoldt theorem.  What is formalised here is the
elementary local arithmetic that the essay actually defines: the p-adic
norm on `ℚ`, the finite base-`p` encoding of a digit string, the local
Euler factor `1 - p⁻¹`, and the rational value predicted by the
interpolation formula at `s = -1` (`k = 2`).

The Kubota–Leopoldt existence and interpolation theorem, the p-adic
continuity/analyticity assertions, and the stochastic and spectral
bridges are recorded as source claims or open items in the programme
dossier, not as theorems below.
-/

noncomputable section

open scoped BigOperators

namespace PadicStoch

/-- The p-adic norm on `ℚ`, as defined in Mathlib (`padicNorm`). -/
def pNorm (p : ℕ) (q : ℚ) : ℚ := padicNorm p q

/-- A finite base-`p` digit string, read little-endian as in the source:
`s₀ + s₁ p + s₂ p² + ⋯`. -/
def encode (p : ℕ) (s : List ℕ) : ℕ := Nat.ofDigits p s

/-- The local Euler factor at `s = 1`: `1 - p⁻¹`. -/
def eulerFactor (p : ℕ) : ℚ := 1 - (p : ℚ)⁻¹

/-- The Kubota–Leopoldt interpolation factor `1 - p^(k-1)`. -/
def klFactor (p k : ℕ) : ℚ := 1 - (p : ℚ) ^ (k - 1)

/-- The value at `s = 1 - k` obtained from the source's interpolation
formula, using `ζ(1-k) = -B_k/k`; `klValue` is the special case `k = 2`,
where `ζ(-1) = -1/12`. -/
def klValue (p : ℕ) : ℚ := klFactor p 2 * (-(1 / 12))

/-- The p-adic norm of `p^n` is exactly `p^{-n}`. -/
theorem pNorm_p_pow (p : ℕ) [Fact p.Prime] (n : ℕ) :
    pNorm p ((p : ℚ) ^ n) = (p : ℚ) ^ (-(n : ℤ)) := by
  unfold pNorm
  have hp : p.Prime := Fact.out
  rw [padicNorm.eq_zpow_of_nonzero]
  · rw [padicValRat.pow, padicValRat.self hp.one_lt]
    simp
  · exact pow_ne_zero n (by exact_mod_cast hp.ne_zero)

/-- Higher powers of `p` are strictly smaller in the p-adic norm. -/
theorem pNorm_p_pow_strictAnti (p : ℕ) [Fact p.Prime] :
    StrictAnti (fun n : ℕ => pNorm p ((p : ℚ) ^ n)) := by
  intro a b hab
  change pNorm p ((p : ℚ) ^ b) < pNorm p ((p : ℚ) ^ a)
  rw [pNorm_p_pow, pNorm_p_pow]
  have hp : (1 : ℚ) < (p : ℚ) := by exact_mod_cast (Fact.out : p.Prime).one_lt
  exact (zpow_lt_zpow_iff_right₀ hp).2 (by omega)

/-- The p-adic norm is non-archimedean (the ultrametric inequality). -/
theorem pNorm_nonarchimedean (p : ℕ) [Fact p.Prime] (q r : ℚ) :
    pNorm p (q + r) ≤ max (pNorm p q) (pNorm p r) := by
  simpa [pNorm] using padicNorm.nonarchimedean (p := p) (q := q) (r := r)

/-- The source's worked encoding example: base `3`, digits `[2, 1, 0]`,
gives `2 + 1·3 + 0·3² = 5`. -/
theorem encode_example : encode 3 [2, 1, 0] = 5 := by
  decide

/-- The finite Euler-factor telescoping identity:
`(1 - p⁻¹) (1 + p⁻¹ + ⋯ + p^{-(N-1)}) = 1 - p^{-N}`. -/
theorem eulerFactor_telescope (p N : ℕ) :
    eulerFactor p * (∑ k ∈ Finset.range N, ((p : ℚ)⁻¹) ^ k) =
      1 - ((p : ℚ)⁻¹) ^ N := by
  unfold eulerFactor
  induction N with
  | zero => simp
  | succ N ih =>
      rw [Finset.sum_range_succ, mul_add, ih, pow_succ]
      ring

/-- At `k = 2` the interpolation factor is `1 - p`, so the predicted value
is `-(1 - p)/12 = (p - 1)/12`. -/
theorem klValue_eq (p : ℕ) : klValue p = ((p : ℚ) - 1) / 12 := by
  unfold klValue klFactor
  norm_num
  ring

/-- For every prime `p`, the reconstructed value at `s = -1` is positive. -/
theorem klValue_pos {p : ℕ} (hp : 1 < p) : 0 < klValue p := by
  rw [klValue_eq]
  have hp' : (1 : ℚ) < (p : ℚ) := by exact_mod_cast hp
  have hnum : 0 < (p : ℚ) - 1 := by linarith
  exact div_pos hnum (by norm_num)

end PadicStoch
