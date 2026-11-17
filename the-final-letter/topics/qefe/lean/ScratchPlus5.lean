import Mathlib
noncomputable section
namespace QEFEPlus5
open Complex

example (c : ℝ) (n : ℤ) :
    (1/(2*Real.pi*I)) * jacobiTheta₂'_term n (-I*c/4) (I*c) -
      (1/4) * jacobiTheta₂_term n (-I*c/4) (I*c)
      = ((n:ℂ) - 1/4) * cexp (-Real.pi*c*n^2 + Real.pi*c*n/2) := by
  unfold jacobiTheta₂'_term jacobiTheta₂_term
  have hE : cexp (2 * Real.pi * I * (n:ℂ) * (-I * (c:ℂ) / 4) +
      Real.pi * I * (n:ℂ)^2 * (I * (c:ℂ)))
      = cexp (-Real.pi*c*(n:ℝ)^2 + Real.pi*c*(n:ℝ)/2) := by
    congr 1
    push_cast
    ring_nf
    rw [pow_two, Complex.I_mul_I]
    ring
  rw [hE]
  norm_num
  field_simp
  norm_num
end QEFEPlus5
