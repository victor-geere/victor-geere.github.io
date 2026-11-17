import Mathlib
import GaussianGram6

/-!
# The `7 × 7` Gaussian Weil Gram matrix

The `n = 7` rung of the ladder: seven centres `0, 1/5, …, 6/5`.  Only the
`c = 6/5` separation is new, so the only new analytic inputs are the density
chain `DensityG6` and the prime enclosure `primeTerm (6/5) (1/20)`.  The
rational matrix `gramCentre7` rounds the exact entries to eight decimals and the
margin is `1/100`, below `λ_min(gramCentre7) ≈ 0.012438` and above the entry
budget `7·ε`.

See [`../HANDOFF-M0P-NEXT.md`](../HANDOFF-M0P-NEXT.md) §4.1.
-/

set_option maxHeartbeats 1200000

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- The seven centres `0, 1/5, …, 6/5`. -/
def centre7 : Fin 7 → ℝ :=
  ![(0 / 5 : ℝ), (1 / 5 : ℝ), (2 / 5 : ℝ), (3 / 5 : ℝ), (4 / 5 : ℝ), (5 / 5 : ℝ), (6 / 5 : ℝ)]

/-- The exact `7 × 7` Gaussian Weil Gram matrix at width `σ`. -/
def gaussianGram7 (σ : ℝ) : Matrix (Fin 7) (Fin 7) ℝ :=
  Matrix.of fun i j => gaussianGramEntry (centre7 i) (centre7 j) σ

theorem gaussianGram7_symm (σ : ℝ) (i j : Fin 7) :
    gaussianGram7 σ i j = gaussianGram7 σ j i :=
  gaussianGramEntry_symm _ _ _

/-- The finite margin `t = 1/100`. -/
def gramMargin7 : ℝ := 1 / 100

/-- The rational centre matrix (Toeplitz, eight decimals). -/
def gramCentre7 : Matrix (Fin 7) (Fin 7) ℝ :=
  !![(1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ),
     (802313/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (683903/100000000 : ℝ),
     (312959/100000000 : ℝ),
     (334911/50000000 : ℝ);
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ),
     (802313/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (683903/100000000 : ℝ),
     (312959/100000000 : ℝ);
     (802313/100000000 : ℝ),
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ),
     (802313/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (683903/100000000 : ℝ);
     (-55511/25000000 : ℝ),
     (802313/100000000 : ℝ),
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ),
     (802313/100000000 : ℝ),
     (-55511/25000000 : ℝ);
     (683903/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (802313/100000000 : ℝ),
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ),
     (802313/100000000 : ℝ);
     (312959/100000000 : ℝ),
     (683903/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (802313/100000000 : ℝ),
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ),
     (-824463/50000000 : ℝ);
     (334911/50000000 : ℝ),
     (312959/100000000 : ℝ),
     (683903/100000000 : ℝ),
     (-55511/25000000 : ℝ),
     (802313/100000000 : ℝ),
     (-824463/50000000 : ℝ),
     (1078399/25000000 : ℝ)]

/-- The unit lower-triangular factor. -/
def L7 : Matrix (Fin 7) (Fin 7) ℝ :=
  !![(1 : ℝ),
     0,
     0,
     0,
     0,
     0,
     0;
     (-274821/552266 : ℝ),
     (1 : ℝ),
     0,
     0,
     0,
     0,
     0;
     (802313/3313596 : ℝ),
     (-230051101781/458942305430 : ℝ),
     (1 : ℝ),
     0,
     0,
     0,
     0;
     (-55511/828399 : ℝ),
     (191033918567/688413458145 : ℝ),
     (-1718802558769325653/3432315164428452466 : ℝ),
     (1 : ℝ),
     0,
     0,
     0;
     (62173/301236 : ℝ),
     (65323554659/1376826916290 : ℝ),
     (479144079155696921/1716157582214226233 : ℝ),
     (-26512134803973884766866716/51105516410353979455940089 : ℝ),
     (1 : ℝ),
     0,
     0;
     (312959/3313596 : ℝ),
     (463704079537/1376826916290 : ℝ),
     (169433038551200461/3432315164428452466 : ℝ),
     (13425376605999678412120609/51105516410353979455940089 : ℝ),
     (-14815692779009016070383333966229/23556076135316922827601737748654 : ℝ),
     (1 : ℝ),
     0;
     (111637/552266 : ℝ),
     (178458883478/688413458145 : ℝ),
     (1164350386144703943/3432315164428452466 : ℝ),
     (1379568166246421964241369/51105516410353979455940089 : ℝ),
     (11039979003816780600210704243003/58890190338292307069004344371635 : ℝ),
     (-40456539624771383154542147367197360558/45044909474444771950304539158703544215 : ℝ),
     (1 : ℝ)]

/-- The diagonal factor. -/
def D7 : Matrix (Fin 7) (Fin 7) ℝ :=
  !![(828399/25000000 : ℝ),
     0,
     0,
     0,
     0,
     0,
     0;
     0,
     (137682691629/5522660000000 : ℝ),
     0,
     0,
     0,
     0,
     0;
     0,
     0,
     (1716157582214226233/68841345814500000000 : ℝ),
     0,
     0,
     0,
     0;
     0,
     0,
     0,
     (51105516410353979455940089/2059389098657071479600000000 : ℝ),
     0,
     0,
     0;
     0,
     0,
     0,
     0,
     (11778038067658461413800868874327/511055164103539794559400890000000 : ℝ),
     0,
     0;
     0,
     0,
     0,
     0,
     0,
     (9008981894888954390060907831740708843/471121522706338456552034754973080000000 : ℝ),
     0;
     0,
     0,
     0,
     0,
     0,
     0,
     (386563957161806241905613087444898105018687/35191335526909978086175421217737143917968750 : ℝ)]

theorem D7_eq_diagonal :
    D7 = Matrix.diagonal ![(828399/25000000 : ℝ), (137682691629/5522660000000 : ℝ), (1716157582214226233/68841345814500000000 : ℝ), (51105516410353979455940089/2059389098657071479600000000 : ℝ), (11778038067658461413800868874327/511055164103539794559400890000000 : ℝ), (9008981894888954390060907831740708843/471121522706338456552034754973080000000 : ℝ), (386563957161806241905613087444898105018687/35191335526909978086175421217737143917968750 : ℝ)] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [D7]

theorem D7_posDef : D7.PosDef := by
  rw [D7_eq_diagonal]
  exact Matrix.PosDef.diagonal fun i => by fin_cases i <;> norm_num

theorem gramCentre7_factor :
    gramCentre7 - gramMargin7 • (1 : Matrix (Fin 7) (Fin 7) ℝ) = L7 * D7 * L7ᵀ := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [gramCentre7, gramMargin7, L7, D7, Matrix.mul_apply, Fin.sum_univ_succ] <;>
    norm_num

theorem L7_transpose_det : (L7ᵀ).det = 1 := by
  rw [Matrix.det_of_isUpperTriangular]
  · apply Finset.prod_eq_one
    intro i _
    fin_cases i <;> simp [L7]
  · intro i j hij
    simp only [Matrix.transpose_apply, L7]
    fin_cases i <;> fin_cases j <;> simp_all

theorem gramCentre7_sub_posDef :
    (gramCentre7 - gramMargin7 • (1 : Matrix (Fin 7) (Fin 7) ℝ)).PosDef := by
  rw [gramCentre7_factor]
  have hD : D7.PosDef := D7_posDef
  have hinj : Function.Injective (L7ᵀ).mulVec := by
    refine Matrix.mulVec_injective_iff_isUnit.mpr ?_
    rw [Matrix.isUnit_iff_isUnit_det, L7_transpose_det]
    exact isUnit_one
  have h := hD.conjTranspose_mul_mul_same (B := L7ᵀ) hinj
  rw [Matrix.conjTranspose_eq_transpose_of_trivial] at h
  simpa only [Matrix.transpose_transpose] using h

/-- **The `7 × 7` entrywise obligation.** -/
theorem gaussianGram7_posDef_of_entry_bound {G : Matrix (Fin 7) (Fin 7) ℝ} {ε : ℝ}
    (hGsym : ∀ i j, G i j = G j i)
    (hε : ∀ i j, |G i j - gramCentre7 i j| ≤ ε)
    (hε0 : 0 ≤ ε)
    (hdim : ε * 7 < gramMargin7) :
    G.PosDef := by
  refine posDef_of_entry_bound hGsym gramCentre7_sub_posDef hε0 hε ?_
  simpa using hdim

/-- The certified 6×6 matrix is a principal submatrix of the 7×7 matrix. -/
theorem gaussianGram6_submatrix_gaussianGram7 :
    (gaussianGram7 (1 / 20)).submatrix (fun i : Fin 6 => Fin.castSucc i)
        (fun i : Fin 6 => Fin.castSucc i) = gaussianGram6 (1 / 20) := by
  ext i j
  simp only [Matrix.submatrix_apply, gaussianGram7, gaussianGram6, Matrix.of_apply]
  have hi : centre7 (Fin.castSucc i) = centre6 i := by
    fin_cases i <;> norm_num [centre7, centre6]
  have hj : centre7 (Fin.castSucc j) = centre6 j := by
    fin_cases j <;> norm_num [centre7, centre6]
  rw [hi, hj]

end PrimeSpectrumTensor
