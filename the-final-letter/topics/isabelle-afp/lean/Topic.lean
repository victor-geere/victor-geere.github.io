import Mathlib

/-!
# Isabelle/AFP corpus — formal core of the Hadamard gate

The archived AFP entry `Isabelle_Marries_Dirac` defines the Pauli
matrices and the Hadamard gate as `2 × 2` complex matrices in
`Quantum.thy`:

* `X` (line 1096), `Z` (line 1138), `H` (line 1158);
* `X_inv` (line 1109), `Z_inv` (line 1145);
* `dagger_of_H` (line 1165), `H_inv` (line 1169), `HXH_is_Z` (line 1235).

This file translates that finite gate algebra into Lean 4 / Mathlib.
It proves the involution and self-adjointness facts for `H`, `X`, `Z`,
and the conjugation identity `H * X * H = Z`.  It does **not** formalise
the source's vector-space predicates (`state`, `unitary`, `gate`), its
matrix dimensions, the Bell-state entanglement lemmas, the no-cloning
theorem, or any other theorem of the 972-entry AFP corpus.

The auxiliary matrix `H2 = [[1,1],[1,-1]]` and the scalar
`c = sqrt 2 / 2` expose the normalisation argument: `H2 * H2 = 2 • 1`
and `c * c = 1/2`, hence `H * H = 1`.
-/

noncomputable section

open Matrix
open scoped Matrix

namespace AFP

/-- The Pauli `X` gate: `[[0,1],[1,0]]` (source `X`, `Quantum.thy:1096`). -/
def X : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- The Pauli `Z` gate: `[[1,0],[0,-1]]` (source `Z`, `Quantum.thy:1138`). -/
def Z : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- The unnormalised Hadamard matrix `[[1,1],[1,-1]]`. -/
def H2 : Matrix (Fin 2) (Fin 2) ℂ := !![1, 1; 1, -1]

/-- The Hadamard normalisation `1 / sqrt 2`, written as `sqrt 2 / 2`. -/
def c : ℂ := ((Real.sqrt 2 / 2 : ℝ) : ℂ)

/-- The Hadamard gate `H = c • H2` (source `H`, `Quantum.thy:1158`). -/
def H : Matrix (Fin 2) (Fin 2) ℂ := c • H2

/-- `X` is an involution (source `X_inv`, `Quantum.thy:1109`). -/
theorem X_mul_self : X * X = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [X, Matrix.mul_apply, Fin.sum_univ_two]

/-- `Z` is an involution (source `Z_inv`, `Quantum.thy:1145`). -/
theorem Z_mul_self : Z * Z = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Z, Matrix.mul_apply, Fin.sum_univ_two]

/-- The unnormalised Hadamard matrix squares to `2 • 1`. -/
theorem H2_mul_self : H2 * H2 = (2 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [H2, Matrix.mul_apply, Fin.sum_univ_two]

/-- The normalisation constant squared is the exact rational `1/2`. -/
theorem c_sq : c * c = (1 / 2 : ℂ) := by
  unfold c
  simp only [Complex.ofReal_div, Complex.ofReal_ofNat]
  have hr : Real.sqrt 2 * Real.sqrt 2 = 2 := by
    rw [← sq, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 2)]
  have h2 : ((Real.sqrt 2 : ℂ) * (Real.sqrt 2 : ℂ)) = 2 := by
    rw [← Complex.ofReal_mul, hr]
    norm_num
  calc
    (Real.sqrt 2 : ℂ) / 2 * ((Real.sqrt 2 : ℂ) / 2)
        = ((Real.sqrt 2 : ℂ) * (Real.sqrt 2 : ℂ)) / 4 := by ring
    _ = 2 / 4 := by rw [h2]
    _ = 1 / 2 := by norm_num

/-- The Hadamard gate is an involution (source `H_inv`, `Quantum.thy:1169`). -/
theorem H_mul_self : H * H = 1 := by
  unfold H
  rw [smul_mul_smul, H2_mul_self, smul_smul, c_sq]
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num

/-- The Hadamard gate is self-adjoint (source `dagger_of_H`, `Quantum.thy:1165`). -/
theorem H_conjTranspose : Hᴴ = H := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [H, H2, c, Matrix.conjTranspose_apply]

/-- Hadamard conjugation sends `X` to `Z` (source `HXH_is_Z`, `Quantum.thy:1235`). -/
theorem HXH_eq_Z : H * X * H = Z := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [H, X, Z, H2, c_sq, Matrix.mul_apply, Fin.sum_univ_two] <;> norm_num

end AFP
