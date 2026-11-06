import DensityCertificates

/-!
# The first rung of the Weil ladder: the single Gaussian

[`WEIL-POSITIVITY.md`](../WEIL-POSITIVITY.md) §6 recommends the single Gaussian
`f_σ(u) = exp(−u²/(2σ²))` as the first certified instance of Weil positivity.
For `f = f_σ` the reflected convolution `g = f * f̌` is the bump
`h_0(v) = √π σ exp(−v²/(4σ²))`, and the Weil value is exactly `gaussianW 0 σ`.

This file extracts the resulting statement from the already-proved entry bands:

```lean
0.0396 < gaussianW 0 (1/20) < 0.0467.
```

The lower bound `0.0396` is the numerical margin `≈ 0.043` of the note.  This is
a finite, unconditional theorem about one test function.  It is **not** Weil
positivity on the cone, not a statement about all zeros, and not RH.
-/

noncomputable section

namespace PrimeSpectrumTensor

/-- The single-Gaussian Weil value at `σ = 1/20`, enclosed by the three entry
bands already proved for `c = 0`. -/
theorem gaussianW_zero_mem :
    gaussianW 0 (1 / 20) ∈ Set.Icc (0.0396 : ℝ) 0.0467 := by
  have hp := poleTerm_mem_c0
  have hd := densityTerm_mem_c0
  have hq := primeTerm_mem_small (c := 0) (by norm_num)
  rw [gaussianW, Set.mem_Icc]
  constructor <;> linarith [hp.1, hp.2, hd.1, hd.2, hq.1, hq.2]

/-- **The first rung of the Weil ladder.**  The single Gaussian at `σ = 1/20`
has strictly positive Weil value, with the explicit lower bound `0.0396`. -/
theorem gaussianW_zero_pos : 0 < gaussianW 0 (1 / 20) := by
  have h := gaussianW_zero_mem
  rw [Set.mem_Icc] at h
  linarith [h.1]

/-- The Gram entry at coincidence is the single-Gaussian value. -/
theorem gaussianGramEntry_zero_zero (σ : ℝ) :
    gaussianGramEntry 0 0 σ = gaussianW 0 σ := by
  unfold gaussianGramEntry
  ring_nf

/-- The `(0,0)` entry of the 4×4 matrix is the first-rung value. -/
theorem gaussianGram4_zero_zero :
    gaussianGram4 (1 / 20) 0 0 = gaussianW 0 (1 / 20) := by
  simp [gaussianGram4, gaussianGramEntry, centre4]

/-- The diagonal entry certified in the 4×4 matrix is positive with the same
explicit lower bound. -/
theorem gaussianGram4_zero_zero_pos : 0 < gaussianGram4 (1 / 20) 0 0 := by
  rw [gaussianGram4_zero_zero]
  exact gaussianW_zero_pos

end PrimeSpectrumTensor
