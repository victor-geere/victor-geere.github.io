import Mathlib
import GaussianGram

/-!
# The zero-side pole term, on the Gram side of the bridge

The finite certificate of [`GaussianGram.lean`](GaussianGram.lean) splits each
entry into `poleTerm + densityTerm + primeTerm`.  The zero-side explicit formula
of [`../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean`](../../absolute-polarized-hodge-index-realization/lean/GaussianZeroSide.lean)
uses the test function

```
H_c(s) = 2π σ² exp(σ²(s − 1/2)²) exp(−c(s − 1/2)).
```

This file records the first concrete identity between the two sides: the pole
term of the finite certificate is exactly `H_c(0) + H_c(1)`.

It is a small step, not the bridge: the archimedean and prime terms are not
identified here, and the infinite zero sum is not taken.
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The zero-side Gaussian test function `H_c(s)`, defined on the Gram side so
that the pole identity can be stated without importing the explicit-formula
topic. -/
def zeroSideGaussian (c σ : ℝ) (s : ℂ) : ℂ :=
  ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) *
    Complex.exp (((σ ^ 2 : ℝ) : ℂ) * (s - 1 / 2) ^ 2) *
      Complex.exp (-((c : ℝ) : ℂ) * (s - 1 / 2))

/-- `H_c(0) = 2πσ² exp(σ²/4) exp(c/2)`. -/
theorem zeroSideGaussian_zero (c σ : ℝ) :
    zeroSideGaussian c σ 0 =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (((c : ℝ) : ℂ) / 2) := by
  unfold zeroSideGaussian
  norm_num
  ring

/-- `H_c(1) = 2πσ² exp(σ²/4) exp(−c/2)`. -/
theorem zeroSideGaussian_one (c σ : ℝ) :
    zeroSideGaussian c σ 1 =
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (-((c : ℝ) : ℂ) / 2) := by
  unfold zeroSideGaussian
  norm_num
  ring

/-- **The pole term is the zero-side pole contribution.**
`poleTerm c σ = H_c(0) + H_c(1)`. -/
theorem poleTerm_eq_zeroSideGaussian_pole (c σ : ℝ) :
    ((poleTerm c σ : ℝ) : ℂ) = zeroSideGaussian c σ 0 + zeroSideGaussian c σ 1 := by
  rw [zeroSideGaussian_zero, zeroSideGaussian_one]
  have hx : ((c : ℝ) : ℂ) / 2 = ((c / 2 : ℝ) : ℂ) := by push_cast; ring
  have hx' : -(((c : ℝ) : ℂ)) / 2 = -(((c / 2 : ℝ) : ℂ)) := by push_cast; ring
  have hcosh : Complex.exp (((c / 2 : ℝ) : ℂ)) + Complex.exp (-(((c / 2 : ℝ) : ℂ))) =
      2 * ((Real.cosh (c / 2) : ℝ) : ℂ) := by
    have h := (Complex.two_cosh (x := ((c / 2 : ℝ) : ℂ))).symm
    rw [← Complex.ofReal_cosh] at h
    exact h
  symm
  calc ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (((c : ℝ) : ℂ) / 2) +
      ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
        Complex.exp (-((c : ℝ) : ℂ) / 2)
        = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
            (Complex.exp (((c : ℝ) : ℂ) / 2) + Complex.exp (-((c : ℝ) : ℂ) / 2)) := by
          ring
    _ = ((2 * Real.pi * σ ^ 2 : ℝ) : ℂ) * Complex.exp (((σ ^ 2 : ℝ) : ℂ) / 4) *
            (2 * ((Real.cosh (c / 2) : ℝ) : ℂ)) := by
          rw [hx, hx', hcosh]
    _ = ((poleTerm c σ : ℝ) : ℂ) := by
          unfold poleTerm
          push_cast
          ring

/-- The real form of the pole identity, for the finite Gram entry. -/
theorem poleTerm_eq_zeroSideGaussian_pole_re (c σ : ℝ) :
    poleTerm c σ = (zeroSideGaussian c σ 0 + zeroSideGaussian c σ 1).re := by
  have h := poleTerm_eq_zeroSideGaussian_pole c σ
  rw [← h]
  simp

end PrimeSpectrumTensor
