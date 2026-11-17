import Mathlib
import GaussianGram5
import Transfer

/-!
# M0′ at 6×6 — the exact Gaussian Weil Gram matrix and the rational transfer

This file is the 6×6 rung of the finite Gaussian Weil–Gram programme.  It
extends [`GaussianGram5.lean`](GaussianGram5.lean) to the six centres

```
0, 1/5, 2/5, 3/5, 4/5, 1.
```

The separations are `0, 1/5, 2/5, 3/5, 4/5, 1`; the first five are already
certified for the 4×4/5×5 bases, so only `c = 1` is new.  The rational centre is
the numerical matrix rounded to eight decimals; the margin `1/70` is below the
numerical smallest eigenvalue `0.016704…`.

Nothing here asserts the infinite Weil cone or the Riemann hypothesis.
-/

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- The six centres `0, 0.2, 0.4, 0.6, 0.8, 1`. -/
def centre6 : Fin 6 → ℝ := ![(0 / 5 : ℝ), (1 / 5 : ℝ), (2 / 5 : ℝ), (3 / 5 : ℝ), (4 / 5 : ℝ), (5 / 5 : ℝ)]

/-- The exact `6 × 6` Gaussian Weil Gram matrix at width `σ`. -/
def gaussianGram6 (σ : ℝ) : Matrix (Fin 6) (Fin 6) ℝ :=
  Matrix.of fun i j => gaussianGramEntry (centre6 i) (centre6 j) σ

theorem gaussianGram6_symm (σ : ℝ) (i j : Fin 6) :
    gaussianGram6 σ i j = gaussianGram6 σ j i :=
  gaussianGramEntry_symm _ _ _

/-- The finite margin `t = 1/70`. -/
def gramMargin6 : ℝ := 1 / 70

/-- The rational centre matrix (Toeplitz, rounded to eight decimals). -/
def gramCentre6 : Matrix (Fin 6) (Fin 6) ℝ :=
  !![(431337 / 10000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-222131 / 100000000 : ℝ),
     (341931 / 50000000 : ℝ),
     (312957 / 100000000 : ℝ);
     (-1649119 / 100000000 : ℝ),
     (431337 / 10000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-222131 / 100000000 : ℝ),
     (341931 / 50000000 : ℝ);
     (32087 / 4000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (431337 / 10000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-222131 / 100000000 : ℝ);
     (-222131 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (431337 / 10000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ);
     (341931 / 50000000 : ℝ),
     (-222131 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (431337 / 10000000 : ℝ),
     (-1649119 / 100000000 : ℝ);
     (312957 / 100000000 : ℝ),
     (341931 / 50000000 : ℝ),
     (-222131 / 100000000 : ℝ),
     (32087 / 4000000 : ℝ),
     (-1649119 / 100000000 : ℝ),
     (431337 / 10000000 : ℝ)]

/-- The unit lower-triangular factor. -/
def L6 : Matrix (Fin 6) (Fin 6) ℝ :=
  !![1,
     0,
     0,
     0,
     0,
     0;
     (-11543833 / 20193590 : ℝ),
     1,
     0,
     0,
     0,
     0;
     (1123045 / 4038718 : ℝ),
     (-56096736991015 / 91506998918737 : ℝ),
     1,
     0,
     0,
     0;
     (-1554917 / 20193590 : ℝ),
     (95441849230889 / 274520996756211 : ℝ),
     (-751643685008420109367 / 1237472208068901440760 : ℝ),
     1,
     0,
     0;
     (2393517 / 10096795 : ℝ),
     (23861364679292 / 274520996756211 : ℝ),
     (39866944372670422 / 107643720256515435 : ℝ),
     (-10572818223859488974579110608 / 16633394932930007094114895103 : ℝ),
     1,
     0;
     (2190699 / 20193590 : ℝ),
     (40652155107109 / 91506998918737 : ℝ),
     (35189963627295378517 / 309368052017225360190 : ℝ),
     (5715332891240362245915956428 / 16633394932930007094114895103 : ℝ),
     (-63760396707176985655748677822896269 / 72793928497768341955370502595722919 : ℝ),
     1]

/-- The diagonal factor. -/
def D6 : Matrix (Fin 6) (Fin 6) ℝ :=
  !![(2019359 / 70000000 : ℝ), 0, 0, 0, 0, 0;
     0, (274520996756211 / 14135513000000000 : ℝ), 0, 0, 0, 0;
     0, 0, (30936805201722536019 / 1601372481077897500000 : ℝ), 0, 0, 0;
     0, 0, 0, (16633394932930007094114895103 / 866230545648231008532000000000 : ℝ), 0, 0;
     0, 0, 0, 0, (72793928497768341955370502595722919 / 4366266169894126862205159964537500000 : ℝ), 0;
     0, 0, 0, 0, 0, (7458489040992769784309983136193522865113 / 796183592944341240136864872140719426562500 : ℝ)]

theorem D6_eq_diagonal :
    D6 = Matrix.diagonal ![(2019359 / 70000000 : ℝ), (274520996756211 / 14135513000000000), (30936805201722536019 / 1601372481077897500000), (16633394932930007094114895103 / 866230545648231008532000000000), (72793928497768341955370502595722919 / 4366266169894126862205159964537500000), (7458489040992769784309983136193522865113 / 796183592944341240136864872140719426562500)] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [D6]

theorem D6_posDef : D6.PosDef := by
  rw [D6_eq_diagonal]
  exact Matrix.PosDef.diagonal fun i => by fin_cases i <;> norm_num

theorem gramCentre6_factor :
    gramCentre6 - gramMargin6 • (1 : Matrix (Fin 6) (Fin 6) ℝ) = L6 * D6 * L6ᵀ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gramCentre6, gramMargin6, L6, D6, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    norm_num

theorem L6_transpose_det : (L6ᵀ).det = 1 := by
  rw [Matrix.det_of_isUpperTriangular]
  · apply Finset.prod_eq_one
    intro i _
    fin_cases i <;> simp [L6]
  · intro i j hij
    simp only [Matrix.transpose_apply, L6]
    fin_cases i <;> fin_cases j <;> simp_all

theorem gramCentre6_sub_posDef :
    (gramCentre6 - gramMargin6 • (1 : Matrix (Fin 6) (Fin 6) ℝ)).PosDef := by
  rw [gramCentre6_factor]
  have hD : D6.PosDef := D6_posDef
  have hinj : Function.Injective (L6ᵀ).mulVec := by
    refine Matrix.mulVec_injective_iff_isUnit.mpr ?_
    rw [Matrix.isUnit_iff_isUnit_det, L6_transpose_det]
    exact isUnit_one
  have h := hD.conjTranspose_mul_mul_same (B := L6ᵀ) hinj
  rw [Matrix.conjTranspose_eq_transpose_of_trivial] at h
  simpa only [Matrix.transpose_transpose] using h

/-- **The 6×6 entrywise obligation.** -/
theorem gaussianGram6_posDef_of_entry_bound {G : Matrix (Fin 6) (Fin 6) ℝ} {ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hε : ∀ i j, |G i j - gramCentre6 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 6 < gramMargin6) :
    G.PosDef := by
  refine posDef_of_entry_bound hGsym gramCentre6_sub_posDef hε0 hε ?_
  simpa using hdim

/-- The certified 5×5 matrix is a principal submatrix of the 6×6 matrix. -/
theorem gaussianGram5_submatrix_gaussianGram6 :
    (gaussianGram6 (1 / 20)).submatrix (fun i : Fin 5 => Fin.castSucc i)
        (fun i : Fin 5 => Fin.castSucc i) = gaussianGram5 (1 / 20) := by
  ext i j
  simp only [Matrix.submatrix_apply, gaussianGram6, gaussianGram5, Matrix.of_apply]
  have hi : centre6 (Fin.castSucc i) = centre5 i + 2 / 5 := by
    fin_cases i <;> norm_num [centre6, centre5]
  have hj : centre6 (Fin.castSucc j) = centre5 j + 2 / 5 := by
    fin_cases j <;> norm_num [centre6, centre5]
  rw [hi, hj, gaussianGramEntry_translate]

end PrimeSpectrumTensor
