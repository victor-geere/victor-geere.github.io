import Mathlib

/-!
# Topological zeta — formal core

The archived programme proposes to read the Riemann zeta function as a
limit of Reshetikhin–Turaev invariants and to locate the critical line as
a symmetry axis of braid closures.  That analytic/topological realisation
is **not** formalised here: it is recorded as a source claim (and, in the
source itself, as conditional or speculative).

What the source does define rigorously, and what this file reconstructs,
is the finite algebra of the modular data:

* squared quantum dimensions `dᵢ²`, the total `D² = ∑ dᵢ²`, and the
  Egyptian denominators `mᵢ = D²/dᵢ²`;
* the Egyptian identity `∑ᵢ dᵢ²/D² = 1` and its non-unit form
  `∑_{i≠0} 1/mᵢ = 1 − 1/D²`;
* the Ising `S`-matrix, which is symmetric and squares to the identity
  (the finite, non-degenerate modular data of the simplest non-abelian
  MTC);
* the Ising Dirichlet polynomial `Ψ(s) = 2·4^{-s} − 2^{-s}`, its
  factorisation, and its zero at `s = 1`;
* the exact `SU(2)₄` Egyptian identity.

Every declaration below is proved.  There is no `sorry`, `axiom`, or
`admit`.
-/

noncomputable section

open scoped BigOperators Matrix

namespace TopologicalZeta

/-! ## 1. Quantum dimensions and Egyptian denominators -/

/-- The Egyptian identity for a finite-rank MTC.

If `d2 i = dᵢ²` are the squared quantum dimensions and `D² = ∑ᵢ dᵢ²`,
then `∑ᵢ dᵢ²/D² = 1`.  This is the algebraic content of
`∑ᵢ 1/mᵢ = 1` for `mᵢ = D²/dᵢ²`. -/
theorem egyptian_identity {ι : Type*} [Fintype ι] (d2 : ι → ℝ)
    (hD : (∑ i, d2 i) ≠ 0) :
    ∑ i, d2 i / (∑ j, d2 j) = 1 := by
  rw [← Finset.sum_div]
  exact div_self hD

/-- The non-unit form of the Egyptian identity.

The unit object has `d₀² = 1`, hence `m₀ = D²`.  Summing only over the
non-unit simple objects gives `∑_{i≠0} 1/mᵢ = 1 − 1/D²`, which is the
form stated in the source.  (The full sum over all objects is `1`.) -/
theorem egyptian_nonunit {ι : Type*} [Fintype ι] [DecidableEq ι]
    (d2 : ι → ℝ) (i0 : ι) (h0 : d2 i0 = 1)
    (hD : (∑ i, d2 i) ≠ 0) :
    ∑ i ∈ Finset.univ.erase i0, d2 i / (∑ j, d2 j)
      = 1 - 1 / (∑ j, d2 j) := by
  have hsplit : (∑ i, d2 i) = d2 i0 + ∑ i ∈ Finset.univ.erase i0, d2 i := by
    rw [Finset.sum_erase_eq_sub (Finset.mem_univ i0)]
    simp
  have hsum : ∑ i ∈ Finset.univ.erase i0, d2 i = (∑ i, d2 i) - 1 := by
    rw [hsplit, h0]
    ring
  rw [← Finset.sum_div, hsum]
  field_simp [hD]

/-! ## 2. The Ising modular data -/

/-- The Ising `S`-matrix, normalised as in the source:
`S = ½ [[1, √2, 1], [√2, 0, −√2], [1, −√2, 1]]`. -/
def isingS : Matrix (Fin 3) (Fin 3) ℝ :=
  !![1 / 2, Real.sqrt 2 / 2, 1 / 2;
     Real.sqrt 2 / 2, 0, -Real.sqrt 2 / 2;
     1 / 2, -Real.sqrt 2 / 2, 1 / 2]

/-- The Ising `S`-matrix is symmetric, as required of modular data. -/
theorem isingS_symm : isingSᵀ = isingS := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [isingS]

/-- The Ising `S`-matrix is an involution: `S * S = 1`.

Since `S` is real and symmetric, this is exactly the unitarity
`S S† = 1` of the modular data, and hence the non-degeneracy of the
braiding in the Ising category. -/
theorem isingS_mul_self : isingS * isingS = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [isingS, Matrix.mul_apply, Fin.sum_univ_three] <;>
    nlinarith [Real.sq_sqrt (show (0 : ℝ) ≤ 2 by norm_num)]

/-- The Ising Dirichlet polynomial with the non-trivial Galois character
`χ = (1, −1, 1)` on denominators `(4, 2, 4)`:
`Ψ(s) = 2·4^{-s} − 2^{-s}`. -/
def isingPsi (s : ℝ) : ℝ := 2 * (4 : ℝ) ^ (-s) - (2 : ℝ) ^ (-s)

/-- Factorisation of the Ising Dirichlet polynomial:
`Ψ(s) = 2^{-s} (2^{1-s} − 1)`. -/
theorem isingPsi_factor (s : ℝ) :
    isingPsi s = (2 : ℝ) ^ (-s) * ((2 : ℝ) ^ (1 - s) - 1) := by
  unfold isingPsi
  have hpow : (4 : ℝ) ^ (-s) = ((2 : ℝ) ^ (-s)) ^ 2 := by
    rw [show (4 : ℝ) = (2 : ℝ) ^ (2 : ℕ) by norm_num,
      ← Real.rpow_natCast (2 : ℝ) 2,
      ← Real.rpow_mul (by norm_num : (0 : ℝ) ≤ 2)]
    rw [show ((2 : ℕ) : ℝ) * (-s) = -s + -s by push_cast; ring,
      Real.rpow_add (by norm_num : (0 : ℝ) < 2)]
    ring
  have h2 : (2 : ℝ) ^ (1 - s) = 2 * (2 : ℝ) ^ (-s) := by
    have h := Real.rpow_add (by norm_num : (0 : ℝ) < 2) (1 : ℝ) (-s)
    rw [show (1 : ℝ) + (-s) = 1 - s by ring, Real.rpow_one] at h
    exact h
  rw [hpow, h2]
  ring

/-- The Ising Dirichlet polynomial vanishes at `s = 1`, the boundary
point of the critical strip: `Ψ(1) = 2/4 − 1/2 = 0`. -/
theorem isingPsi_one : isingPsi 1 = 0 := by
  unfold isingPsi
  rw [show (-(1 : ℝ)) = -(1 : ℝ) by rfl]
  rw [Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 4),
    Real.rpow_neg (by norm_num : (0 : ℝ) ≤ 2)]
  norm_num

/-! ## 3. The `SU(2)₄` Egyptian identity -/

/-- The `SU(2)₄` denominators `(12, 4, 3, 4, 12)` satisfy
`1/12 + 1/4 + 1/3 + 1/4 + 1/12 = 1` exactly. -/
theorem su2_4_egyptian :
    (1 : ℝ) / 12 + 1 / 4 + 1 / 3 + 1 / 4 + 1 / 12 = 1 := by
  norm_num

end TopologicalZeta
