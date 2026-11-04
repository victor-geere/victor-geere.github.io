import Mathlib

/-!
# W1 — rational transfer for the finite Gaussian Weil Gram certificate

This file is the first, purely algebraic step of
[`../../../angular-partition-method/HANDOFF-O4.md`](../../../angular-partition-method/HANDOFF-O4.md)
(work item **W1**).  It contains no analysis: no `Ω`, no digamma, no
quadrature.  It records two things.

## 1. The correct norm for the centre/error step

The numerical certificate in
[`../../WEIL-GRAM.md`](../../WEIL-GRAM.md) §3.3–3.6 uses an *entrywise*
margin `t` and then forms `centre − t·I`.  That step is only valid with a
matrix-norm bound: if `|G i j − centre i j| ≤ ε` for every entry, then the
Loewner error is bounded by `n · ε`, not by `ε`.  The theorem
`posDef_of_entry_bound` below makes the correction explicit:

`(centre − t·I).PosDef`, `ε · n < t`, and `|G i j − centre i j| ≤ ε`
together imply `G.PosDef`.

Nothing here is numerical: `ε`, `t`, `C`, `G` are arbitrary.

## 2. The exact rational certificate

`gramCentre4` is the matrix obtained by rounding the numerical 4×4 Gaussian
Gram matrix of `WEIL-GRAM.md` (σ = 0.05, centres −0.3, −0.1, 0.1, 0.3) to
eight decimal places.  Its entries are

```
  a  b  c  d
  b  a  b  c
  c  b  a  b
  d  c  b  a
```

with `a = 0.04313596`, `b = −0.01648926`, `c = 0.00802313`,
`d = −0.00222044`.  `gramCentre4_sub_posDef` proves, by exact arithmetic,
that `gramCentre4 − (227/10000)·I` is positive definite.  The proof is an
exact `L D Lᵀ` factorisation: `L4` is unit lower triangular, `D4` is diagonal
with positive rational entries, and the identity
`gramCentre4 − t·I = L4 · D4 · L4ᵀ` is checked entry by entry with
`norm_num`.  Every scalar below is a rational literal; no floating point and
no analytic constant (π, exp, log, digamma) occurs anywhere in this file.

## What is *not* here

There is no analytic input.  In particular the entrywise enclosure of the
exact transcendental matrix

`G a b = (W (a−b) + W (b−a)) / 2`

is **not** proved here, and the theorem `gaussianGram4_posDef` is **not**
proved here.  Work items W2 (an interval enclosure of `Ω`), W3 (rigorous
quadrature) and W4 (the assembly) remain open.  See the header of
`GaussianGram.lean` for the precise remaining obligation, and §4 of the
handoff for why this file has to come first.
-/

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-! ## 1.  The entrywise-to-`PosDef` transfer -/

/-- **Entrywise transfer with the correct norm.**

Let `C` be a centre matrix with `C − t·I` positive definite, and let `G` be
symmetric with every entry within `ε` of the corresponding entry of `C`.
If `ε · n < t`, where `n` is the dimension, then `G` is positive definite.

The dimension factor cannot be removed: entrywise closeness controls the
`ℓ¹`/Frobenius geometry, while positive definiteness is spectral, and the two
differ by a factor of the dimension.  This is the correction recorded in §4
of `HANDOFF-O4.md`. -/
theorem posDef_of_entry_bound {n : Type*} [Fintype n] [DecidableEq n]
    {C G : Matrix n n ℝ} {t ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hC : (C - t • (1 : Matrix n n ℝ)).PosDef)
    (hε0 : 0 ≤ ε)
    (hε : ∀ i j, |G i j - C i j| ≤ ε)
    (hdim : ε * (Fintype.card n : ℝ) < t) :
    G.PosDef := by
  have hherm : G.IsHermitian := by
    ext i j
    simp [Matrix.conjTranspose_apply, hGsym j i]
  refine Matrix.PosDef.of_dotProduct_mulVec_pos hherm fun x hx => ?_
  have hxs : star x = x := by
    funext i
    simp
  rw [hxs]
  -- Split `G = (C − t·I) + t·I + (G − C)`.
  have hsplit : x ⬝ᵥ (G *ᵥ x)
      = x ⬝ᵥ ((C - t • (1 : Matrix n n ℝ)) *ᵥ x) + t * (x ⬝ᵥ x)
        + x ⬝ᵥ ((G - C) *ᵥ x) := by
    have hG : G = (C - t • (1 : Matrix n n ℝ)) + t • (1 : Matrix n n ℝ) + (G - C) := by
      abel
    conv_lhs => rw [hG]
    rw [add_mulVec, add_mulVec, dotProduct_add, dotProduct_add]
    have hone : (t • (1 : Matrix n n ℝ)) *ᵥ x = t • x := by
      rw [smul_mulVec, one_mulVec]
    rw [hone]
    have hsm : x ⬝ᵥ (t • x) = t * (x ⬝ᵥ x) := by
      simp only [dotProduct, Pi.smul_apply, smul_eq_mul, Finset.mul_sum, Finset.sum_mul]
      exact Finset.sum_congr rfl fun i _ => by ring
    rw [hsm]
  -- The centre part is non-negative.
  have hCnn : 0 ≤ x ⬝ᵥ ((C - t • (1 : Matrix n n ℝ)) *ᵥ x) := by
    have := hC.posSemidef.dotProduct_mulVec_nonneg x
    simpa [hxs] using this
  -- The error part is bounded by `ε · (Σ |x i|)^2`.
  have herr : |x ⬝ᵥ ((G - C) *ᵥ x)| ≤ ε * (∑ i, |x i|) ^ 2 := by
    have hexp : x ⬝ᵥ ((G - C) *ᵥ x) = ∑ i, ∑ j, x i * (G i j - C i j) * x j := by
      simp only [dotProduct, mulVec, Matrix.sub_apply, Finset.mul_sum, Finset.sum_mul,
        mul_assoc]
    rw [hexp]
    calc |∑ i, ∑ j, x i * (G i j - C i j) * x j|
        ≤ ∑ i, |∑ j, x i * (G i j - C i j) * x j| := Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ i, ∑ j, |x i * (G i j - C i j) * x j| := by
          refine Finset.sum_le_sum fun i _ => Finset.abs_sum_le_sum_abs _ _
      _ ≤ ∑ i, ∑ j, ε * (|x i| * |x j|) := by
          refine Finset.sum_le_sum fun i _ => Finset.sum_le_sum fun j _ => ?_
          rw [abs_mul, abs_mul]
          have h1 : |G i j - C i j| ≤ ε := hε i j
          have hxi : (0 : ℝ) ≤ |x i| := abs_nonneg _
          have hxj : (0 : ℝ) ≤ |x j| := abs_nonneg _
          nlinarith [mul_nonneg hxi hxj]
      _ = ε * (∑ i, |x i|) ^ 2 := by
          rw [sq, Finset.sum_mul_sum]
          rw [Finset.mul_sum]
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [Finset.mul_sum]
  -- Cauchy–Schwarz: `(Σ |x i|)^2 ≤ n · Σ x i ^ 2`.
  have hsq : (∑ i, |x i|) ^ 2 ≤ (Fintype.card n : ℝ) * ∑ i, x i ^ 2 := by
    have h := sq_sum_le_card_mul_sum_sq (s := (Finset.univ : Finset n)) (f := fun i => |x i|)
    rw [Finset.card_univ] at h
    simpa [sq_abs] using h
  -- `x ⬝ᵥ x = Σ x i ^ 2`.
  have hxx : x ⬝ᵥ x = ∑ i, x i ^ 2 := by
    simp [dotProduct, sq]
  have hxxpos : 0 < x ⬝ᵥ x := by
    have hpos : 0 < star x ⬝ᵥ x := Matrix.dotProduct_star_self_pos_iff.mpr hx
    simpa [hxs] using hpos
  -- Assemble.
  have hbound : x ⬝ᵥ ((G - C) *ᵥ x) ≥ -(ε * (Fintype.card n : ℝ)) * (x ⬝ᵥ x) := by
    have h1 : -(ε * (∑ i, |x i|) ^ 2) ≤ x ⬝ᵥ ((G - C) *ᵥ x) := neg_le_of_abs_le herr
    have h2 : ε * (∑ i, |x i|) ^ 2 ≤ ε * ((Fintype.card n : ℝ) * ∑ i, x i ^ 2) :=
      mul_le_mul_of_nonneg_left hsq hε0
    have h3 : ε * ((Fintype.card n : ℝ) * ∑ i, x i ^ 2)
        = (ε * (Fintype.card n : ℝ)) * (x ⬝ᵥ x) := by
      rw [hxx]; ring
    linarith
  rw [hsplit]
  have hkey : 0 < (t - ε * (Fintype.card n : ℝ)) * (x ⬝ᵥ x) :=
    mul_pos (by linarith) hxxpos
  nlinarith [hCnn, hbound, hkey]

/-! ## 2.  The exact rational certificate

The centre matrix and its exact `L D Lᵀ` certificate.  All scalars are
rational literals and all arithmetic below is exact.
-/

/-- The unit lower-triangular factor of the exact `L D Lᵀ` decomposition of
`gramCentre4 − (227/10000)·I`.  It is the rational Cholesky factor of the
rounded Gaussian Gram matrix, with `D` left diagonal. -/
def L4 : Matrix (Fin 4) (Fin 4) ℝ :=
  !![1, 0, 0, 0;
     -824463 / 1021798, 1, 0, 0;
     802313 / 2043596, -1023391906029 / 728663828870, 1, 0;
     -55511 / 510899, 318367378201 / 364331914435,
       -500264066222406959 / 234586562463712398, 1]

/-- The diagonal pivot matrix of the exact `L D Lᵀ` decomposition.  All four
pivots are positive rationals; see `D4_posDef`. -/
def D4 : Matrix (Fin 4) (Fin 4) ℝ :=
  !![510899 / 25000000, 0, 0, 0;
     0, 72866382887 / 10217980000000, 0, 0;
     0, 0, 117293281231856199 / 36433191443500000000, 0;
     0, 0, 0, 5088006962541167940089 / 46917312492742479600000000]

/-- The rational centre matrix: the numerical Gaussian Weil Gram matrix of
`WEIL-GRAM.md` rounded to eight decimals.  It is a symmetric Toeplitz matrix
with `a = 0.04313596`, `b = −0.01648926`, `c = 0.00802313`, `d = −0.00222044`. -/
def gramCentre4 : Matrix (Fin 4) (Fin 4) ℝ :=
  !![4313596 / 100000000, -1648926 / 100000000, 802313 / 100000000,
       -222044 / 100000000;
     -1648926 / 100000000, 4313596 / 100000000, -1648926 / 100000000,
       802313 / 100000000;
     802313 / 100000000, -1648926 / 100000000, 4313596 / 100000000,
       -1648926 / 100000000;
     -222044 / 100000000, 802313 / 100000000, -1648926 / 100000000,
       4313596 / 100000000]

/-- The finite margin `t = 0.0227`.  It is strictly below the numerical
smallest eigenvalue `0.0227097…` of the true matrix, so `gramCentre4 − t·I`
stays positive definite. -/
def gramMargin : ℝ := 227 / 10000

theorem gramCentre4_symm (i j : Fin 4) : gramCentre4 i j = gramCentre4 j i := by
  fin_cases i <;> fin_cases j <;> norm_num [gramCentre4]

theorem D4_eq_diagonal :
    D4 = diagonal (![510899 / 25000000, 72866382887 / 10217980000000,
      117293281231856199 / 36433191443500000000,
      5088006962541167940089 / 46917312492742479600000000] : Fin 4 → ℝ) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [D4]

theorem D4_posDef : D4.PosDef := by
  rw [D4_eq_diagonal]
  exact Matrix.PosDef.diagonal fun i => by fin_cases i <;> norm_num

theorem gramCentre4_factor :
    gramCentre4 - gramMargin • (1 : Matrix (Fin 4) (Fin 4) ℝ) = L4 * D4 * L4ᵀ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gramCentre4, gramMargin, L4, D4, Matrix.mul_apply, Fin.sum_univ_four] <;>
    norm_num

/-- `L4ᵀ` is unit upper triangular, so its determinant is one. -/
theorem L4_transpose_det : (L4ᵀ).det = 1 := by
  rw [Matrix.det_of_isUpperTriangular]
  · apply Finset.prod_eq_one
    intro i _
    fin_cases i <;> simp [L4]
  · intro i j hij
    simp only [Matrix.transpose_apply, L4]
    fin_cases i <;> fin_cases j <;> simp_all

/-- **Exact rational certificate.**  `gramCentre4 − (227/10000)·I` is positive
definite, by exact rational arithmetic. -/
theorem gramCentre4_sub_posDef :
    (gramCentre4 - gramMargin • (1 : Matrix (Fin 4) (Fin 4) ℝ)).PosDef := by
  rw [gramCentre4_factor]
  have hD : D4.PosDef := D4_posDef
  have hinj : Function.Injective (L4ᵀ).mulVec := by
    refine Matrix.mulVec_injective_iff_isUnit.mpr ?_
    rw [Matrix.isUnit_iff_isUnit_det, L4_transpose_det]
    exact isUnit_one
  have h := hD.conjTranspose_mul_mul_same (B := L4ᵀ) hinj
  rw [Matrix.conjTranspose_eq_transpose_of_trivial] at h
  simpa only [Matrix.transpose_transpose] using h

/-! ## 3.  The transfer corollary at the certificate's dimension -/

/-- **The O4 entrywise obligation, in the correct norm.**

If the exact Gaussian Gram matrix `G` is symmetric and every entry is within
`ε ≤ 0.005675` of `gramCentre4`, then `G` is positive definite.  This is the
precise shape of the remaining analytic obligation (W2–W4): one entrywise
enclosure with margin `ε · 4 < 0.0227`. -/
theorem gaussianGram4_posDef_of_entry_bound {G : Matrix (Fin 4) (Fin 4) ℝ} {ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hε : ∀ i j, |G i j - gramCentre4 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 4 < gramMargin) :
    G.PosDef := by
  refine posDef_of_entry_bound hGsym gramCentre4_sub_posDef hε0 hε ?_
  simpa using hdim

end PrimeSpectrumTensor
