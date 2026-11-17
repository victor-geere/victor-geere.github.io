import DensityCertificates
import DensityCertificates5

noncomputable section
open scoped BigOperators

namespace PrimeSpectrumTensor

/-- The certified 4×4 Gaussian Gram determinant is positive. -/
theorem gaussianGram4_det_pos : 0 < (gaussianGram4 (1 / 20)).det :=
  gaussianGram4_posDef.det_pos

/-- The certified 5×5 Gaussian Gram determinant is positive. -/
theorem gaussianGram5_det_pos : 0 < (gaussianGram5 (1 / 20)).det :=
  gaussianGram5_posDef.det_pos

/-- The certified 4×4 determinant is nonzero. -/
theorem gaussianGram4_det_ne_zero : (gaussianGram4 (1 / 20)).det ≠ 0 :=
  gaussianGram4_det_pos.ne'

/-- The certified 5×5 determinant is nonzero. -/
theorem gaussianGram5_det_ne_zero : (gaussianGram5 (1 / 20)).det ≠ 0 :=
  gaussianGram5_det_pos.ne'

end PrimeSpectrumTensor
