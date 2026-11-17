import Assembly
import DensityCertificates
import GaussianGram6

/-!
# Positivity of the Gaussian Gram diagonal at `σ = 1/20`

The diagonal entry of the Gaussian Gram matrix is strictly positive: the pole
band (`≈ 0.0314`), the density band (`[0.0082, 0.0152]`) and the small negative
prime term (`≥ −2.2·10⁻⁵`) leave a margin of about `0.0396`.
-/

noncomputable section
open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The diagonal of the Gaussian Gram matrix is strictly positive at `σ = 1/20`. -/
theorem gaussianGramEntry_diag_pos_at_inv20 (a : ℝ) :
    0 < gaussianGramEntry a a (1 / 20) := by
  rw [gaussianGramEntry_diag]
  have hp := poleTerm_mem_c0
  have hd := densityTerm_mem_c0
  have hq := primeTerm_mem_small (c := 0) (by norm_num)
  linarith [hp.1, hp.2, hd.1, hd.2, hq.1, hq.2]

/-- The diagonal of the 4×4 matrix is positive. -/
theorem gaussianGram4_diag_pos (i : Fin 4) : 0 < gaussianGram4 (1 / 20) i i := by
  simp only [gaussianGram4, Matrix.of_apply]
  exact gaussianGramEntry_diag_pos_at_inv20 _

/-- The diagonal of the 5×5 matrix is positive. -/
theorem gaussianGram5_diag_pos (i : Fin 5) : 0 < gaussianGram5 (1 / 20) i i := by
  simp only [gaussianGram5, Matrix.of_apply]
  exact gaussianGramEntry_diag_pos_at_inv20 _

/-- The diagonal of the 6×6 matrix is positive. -/
theorem gaussianGram6_diag_pos (i : Fin 6) : 0 < gaussianGram6 (1 / 20) i i := by
  simp only [gaussianGram6, Matrix.of_apply]
  exact gaussianGramEntry_diag_pos_at_inv20 _

end PrimeSpectrumTensor
