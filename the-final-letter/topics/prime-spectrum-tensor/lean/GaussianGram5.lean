import Mathlib
import GaussianGram
import Transfer

/-!
# M0′ at 5×5 — the exact Gaussian Weil Gram matrix and the rational transfer

This file is the 5×5 rung of the finite Gaussian Weil–Gram programme.  It
extends [`GaussianGram.lean`](GaussianGram.lean) and [`Transfer.lean`](Transfer.lean)
from the closed 4×4 certificate
([`DensityCertificates.lean`](DensityCertificates.lean)) to the five centres

```
−2/5, −1/5, 0, 1/5, 2/5.
```

The separations are `0, ±1/5, ±2/5, ±3/5, ±4/5`; the first four values are the
ones already certified for the 4×4 basis, so only `c = ±4/5` is new.  The
scoping document is [`../HANDOFF-M0P-5X5.md`](../HANDOFF-M0P-5X5.md).

## What is defined

* `centre5` and `gaussianGram5`, the exact 5×5 matrix of the symmetrised Weil
  entries `(W(a−b) + W(b−a))/2`;
* `gramCentre5`, the rational centre obtained by rounding the numerical matrix
  to eight decimals (symmetric Toeplitz with first row
  `4313596, −1648926, 802313, −222044, 683903` over `10⁸`);
* `gramMargin5 = 1/50`, `L5`, `D5`, and the exact identity
  `gramCentre5 − (1/50)·I = L5 · D5 · L5ᵀ` with all five pivots positive.

## What is proved

* `gaussianGram5_symm` — the exact matrix is symmetric;
* `gramCentre5_sub_posDef` — the rational centre minus `1/50·I` is positive
  definite, by exact `norm_num` arithmetic (no analysis);
* `gaussianGram5_posDef_of_entry_bound` — if every entry of a symmetric `G` is
  within `ε` of `gramCentre5` and `5ε < 1/50`, then `G.PosDef`.

The entrywise enclosure of the *exact* matrix is supplied by the pole, prime
and density enclosures in the assembly file.  Nothing here asserts the
infinite Weil cone or the Riemann hypothesis.
-/

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-! ## The five centres and the exact matrix -/

/-- The five centres `−0.4, −0.2, 0, 0.2, 0.4`. -/
def centre5 : Fin 5 → ℝ := ![-2 / 5, -1 / 5, 0, 1 / 5, 2 / 5]

/-- The exact `5 × 5` Gaussian Weil Gram matrix at width `σ`. -/
def gaussianGram5 (σ : ℝ) : Matrix (Fin 5) (Fin 5) ℝ :=
  Matrix.of fun i j => gaussianGramEntry (centre5 i) (centre5 j) σ

theorem gaussianGram5_symm (σ : ℝ) (i j : Fin 5) :
    gaussianGram5 σ i j = gaussianGram5 σ j i :=
  gaussianGramEntry_symm _ _ _

/-! ## The rational centre and its exact `L D Lᵀ` certificate -/

/-- The finite margin `t = 1/50`.  It is strictly below the numerical smallest
eigenvalue `0.021423782…` of the true 5×5 matrix, so `gramCentre5 − t·I`
stays positive definite. -/
def gramMargin5 : ℝ := 1 / 50

/-- The rational centre matrix: the numerical 5×5 Gaussian Weil Gram matrix
rounded to eight decimals.  Symmetric Toeplitz with first row
`a = 0.04313596`, `b = −0.01648926`, `c = 0.00802313`, `d = −0.00222044`,
`e = 0.00683903`. -/
def gramCentre5 : Matrix (Fin 5) (Fin 5) ℝ :=
  !![4313596 / 100000000, -1648926 / 100000000, 802313 / 100000000,
       -222044 / 100000000, 683903 / 100000000;
     -1648926 / 100000000, 4313596 / 100000000, -1648926 / 100000000,
       802313 / 100000000, -222044 / 100000000;
     802313 / 100000000, -1648926 / 100000000, 4313596 / 100000000,
       -1648926 / 100000000, 802313 / 100000000;
     -222044 / 100000000, 802313 / 100000000, -1648926 / 100000000,
       4313596 / 100000000, -1648926 / 100000000;
     683903 / 100000000, -222044 / 100000000, 802313 / 100000000,
       -1648926 / 100000000, 4313596 / 100000000]

/-- The unit lower-triangular factor of the exact `L D Lᵀ` decomposition of
`gramCentre5 − (1/50)·I`. -/
def L5 : Matrix (Fin 5) (Fin 5) ℝ :=
  !![1, 0, 0, 0, 0;
     -824463 / 1156798, 1, 0, 0, 0;
     802313 / 2313596, -1245996916029 / 1316884748870, 1, 0, 0;
     -55511 / 578399, 372523505701 / 658442374435,
       -1267547855216976959 / 1338271844921857398, 1, 0;
     683903 / 2313596, 306992663977 / 1316884748870,
       25592833894706703 / 31863615355282319,
       -2570352585012238190866716 / 2719988083579585055940089, 1]

/-- The diagonal pivot matrix of the exact `L D Lᵀ` decomposition.  All five
pivots are positive rationals; see `D5_posDef`. -/
def D5 : Matrix (Fin 5) (Fin 5) ℝ :=
  !![578399 / 25000000, 0, 0, 0, 0;
     0, 131688474887 / 11567980000000, 0, 0, 0;
     0, 0, 669135922460928699 / 65844237443500000000, 0, 0;
     0, 0, 0, 2719988083579585055940089 / 267654368984371479600000000, 0;
     0, 0, 0, 0,
       132318221028802992579779774327 / 27199880835795850559400890000000]

theorem gramCentre5_symm (i j : Fin 5) : gramCentre5 i j = gramCentre5 j i := by
  fin_cases i <;> fin_cases j <;> norm_num [gramCentre5]

theorem D5_eq_diagonal :
    D5 = diagonal (![578399 / 25000000,
      131688474887 / 11567980000000,
      669135922460928699 / 65844237443500000000,
      2719988083579585055940089 / 267654368984371479600000000,
      132318221028802992579779774327 / 27199880835795850559400890000000] :
        Fin 5 → ℝ) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [D5]

theorem D5_posDef : D5.PosDef := by
  rw [D5_eq_diagonal]
  exact Matrix.PosDef.diagonal fun i => by fin_cases i <;> norm_num

theorem gramCentre5_factor :
    gramCentre5 - gramMargin5 • (1 : Matrix (Fin 5) (Fin 5) ℝ) = L5 * D5 * L5ᵀ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gramCentre5, gramMargin5, L5, D5, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    norm_num

/-- `L5ᵀ` is unit upper triangular, so its determinant is one. -/
theorem L5_transpose_det : (L5ᵀ).det = 1 := by
  rw [Matrix.det_of_isUpperTriangular]
  · apply Finset.prod_eq_one
    intro i _
    fin_cases i <;> simp [L5]
  · intro i j hij
    simp only [Matrix.transpose_apply, L5]
    fin_cases i <;> fin_cases j <;> simp_all

/-- **Exact rational certificate.**  `gramCentre5 − (1/50)·I` is positive
definite, by exact rational arithmetic. -/
theorem gramCentre5_sub_posDef :
    (gramCentre5 - gramMargin5 • (1 : Matrix (Fin 5) (Fin 5) ℝ)).PosDef := by
  rw [gramCentre5_factor]
  have hD : D5.PosDef := D5_posDef
  have hinj : Function.Injective (L5ᵀ).mulVec := by
    refine Matrix.mulVec_injective_iff_isUnit.mpr ?_
    rw [Matrix.isUnit_iff_isUnit_det, L5_transpose_det]
    exact isUnit_one
  have h := hD.conjTranspose_mul_mul_same (B := L5ᵀ) hinj
  rw [Matrix.conjTranspose_eq_transpose_of_trivial] at h
  simpa only [Matrix.transpose_transpose] using h

/-! ## The transfer corollary at dimension five -/

/-- **The 5×5 entrywise obligation, in the correct norm.**

If the exact Gaussian Gram matrix `G` is symmetric and every entry is within
`ε` of `gramCentre5`, with `5ε < 1/50`, then `G` is positive definite. -/
theorem gaussianGram5_posDef_of_entry_bound {G : Matrix (Fin 5) (Fin 5) ℝ} {ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hε : ∀ i j, |G i j - gramCentre5 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 5 < gramMargin5) :
    G.PosDef := by
  refine posDef_of_entry_bound hGsym gramCentre5_sub_posDef hε0 hε ?_
  simpa using hdim

end PrimeSpectrumTensor
