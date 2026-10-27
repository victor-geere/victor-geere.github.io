import Mathlib

set_option linter.unnecessarySeqFocus false

/-!
# Signed interacting F.4 representation

The register transfer matrix is a signed bond-dimension-2 matrix product. A
constant invertible gauge transforms it into a genuinely non-upper-triangular
signed matrix product with the same contraction. The construction is over `ℚ`;
tensoring with `ℂ` gives the complex form. The gauge does not create
positivity: the nonnegative matrix-product no-go remains in force, so no
Lee–Yang positivity theorem follows.
-/

noncomputable section

open scoped BigOperators

namespace GeoDQPT

variable {𝕜 : Type*} [Field 𝕜]
variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Product of a list of matrices, in list order. -/
def matProdC (L : List (Matrix ι ι 𝕜)) : Matrix ι ι 𝕜 :=
  match L with
  | [] => 1
  | A :: As => A * matProdC As

/-- Constant-gauge invariance of the matrix product:
`(S⁻¹ A S)(S⁻¹ B S) = S⁻¹ (AB) S`. -/
theorem matProdC_map_conj (S Sinv : Matrix ι ι 𝕜)
    (hS : S * Sinv = 1) (hS' : Sinv * S = 1) :
    ∀ L : List (Matrix ι ι 𝕜),
      matProdC (L.map (fun A => Sinv * A * S)) = Sinv * matProdC L * S
  | [] => by
      simp [matProdC, hS']
  | A :: As => by
      rw [List.map_cons, matProdC, matProdC_map_conj S Sinv hS hS' As]
      change (Sinv * A * S) * (Sinv * matProdC As * S) =
        Sinv * (A * matProdC As) * S
      calc
        (Sinv * A * S) * (Sinv * matProdC As * S)
            = Sinv * A * (S * Sinv) * matProdC As * S := by noncomm_ring
        _ = Sinv * A * 1 * matProdC As * S := by rw [hS]
        _ = Sinv * (A * matProdC As) * S := by noncomm_ring


/-- A real signed gauge with determinant `1`. -/
def signedGauge : Matrix (Fin 2) (Fin 2) ℚ :=
  !![1, 1; 1, 2]

/-- The inverse of `signedGauge`. -/
def signedGaugeInv : Matrix (Fin 2) (Fin 2) ℚ :=
  !![2, -1; -1, 1]

theorem signedGauge_mul_inv : signedGauge * signedGaugeInv = 1 := by
  ext i j <;> fin_cases i <;> fin_cases j <;>
    norm_num [signedGauge, signedGaugeInv]

theorem signedGauge_inv_mul : signedGaugeInv * signedGauge = 1 := by
  ext i j <;> fin_cases i <;> fin_cases j <;>
    norm_num [signedGauge, signedGaugeInv]

/-- The signed register matrix at position `m` and weight `s = 1`. -/
def signedRegMat (N m : ℕ) : Matrix (Fin 2) (Fin 2) ℚ :=
  !![1, (if N ∣ m then 1 - (N : ℚ) else 1) * (m : ℚ)⁻¹; 0, 1]

/-- After the signed gauge, the first matrix is genuinely non-upper-triangular:
its lower-left entry is `-1`. -/
theorem signedGauge_nonTriangular :
    (signedGaugeInv * signedRegMat 2 1 * signedGauge) 1 0 = -1 := by
  norm_num [signedGauge, signedGaugeInv, signedRegMat]

theorem signedGauge_nonTriangular_ne_zero :
    (signedGaugeInv * signedRegMat 2 1 * signedGauge) 1 0 ≠ 0 := by
  rw [signedGauge_nonTriangular]
  norm_num

end GeoDQPT
