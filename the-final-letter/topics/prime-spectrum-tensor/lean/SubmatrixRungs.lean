import DensityCertificates
import DensityCertificates5

/-!
# All principal submatrices of the certified Gaussian Gram matrices are PSD

`gaussianGram4_posDef` and `gaussianGram5_posDef` imply, by `PosDef.submatrix`,
that every principal submatrix is positive definite (a fortiori positive
semidefinite).  This gives all lower rungs (1, 2, 3 centres) for free.
-/

noncomputable section
open scoped BigOperators

namespace PrimeSpectrumTensor

/-- Every principal submatrix of the certified 4×4 matrix is positive definite. -/
theorem gaussianGram4_submatrix_posDef {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 4) (he : Function.Injective e) :
    ((gaussianGram4 (1 / 20)).submatrix e e).PosDef :=
  gaussianGram4_posDef.submatrix he

/-- Every principal submatrix of the certified 4×4 matrix is PSD. -/
theorem gaussianGram4_submatrix_posSemidef {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 4) (he : Function.Injective e) :
    ((gaussianGram4 (1 / 20)).submatrix e e).PosSemidef :=
  (gaussianGram4_submatrix_posDef e he).posSemidef

/-- Every principal submatrix of the certified 5×5 matrix is positive definite. -/
theorem gaussianGram5_submatrix_posDef {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 5) (he : Function.Injective e) :
    ((gaussianGram5 (1 / 20)).submatrix e e).PosDef :=
  gaussianGram5_posDef.submatrix he

/-- Every principal submatrix of the certified 5×5 matrix is PSD. -/
theorem gaussianGram5_submatrix_posSemidef {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 5) (he : Function.Injective e) :
    ((gaussianGram5 (1 / 20)).submatrix e e).PosSemidef :=
  (gaussianGram5_submatrix_posDef e he).posSemidef

/-- Every principal minor of the certified 4×4 matrix is positive. -/
theorem gaussianGram4_principal_minor_pos {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 4) (he : Function.Injective e) :
    0 < ((gaussianGram4 (1 / 20)).submatrix e e).det :=
  (gaussianGram4_submatrix_posDef e he).det_pos

/-- Every principal minor of the certified 5×5 matrix is positive. -/
theorem gaussianGram5_principal_minor_pos {m : Type*} [Fintype m] [DecidableEq m]
    (e : m → Fin 5) (he : Function.Injective e) :
    0 < ((gaussianGram5 (1 / 20)).submatrix e e).det :=
  (gaussianGram5_submatrix_posDef e he).det_pos

end PrimeSpectrumTensor
