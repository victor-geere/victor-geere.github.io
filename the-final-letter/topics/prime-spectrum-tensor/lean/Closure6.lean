import DensityBands6
import Assembly6

/-!
# M0′ at 6×6 — closed

The six density-term bands of [`DensityBands6.lean`](DensityBands6.lean) feed
the assembly of [`Assembly6.lean`](Assembly6.lean), giving the unconditional
finite certificate

```lean
theorem gaussianGram6_posDef : (gaussianGram6 (1/20)).PosDef
```

and its vector-level form.  The certificate is:

* six generated density enclosures, one per separation
  `0, 1/5, 2/5, 3/5, 4/5, 1`, at the 1878-panel error-equalising partition of
  `gen/build_edges_opt.py`, with the `Ω` brackets proved once for all six in the
  shared module `DensitySO` (`norm_num`, no `native_decide`) and the panel
  certificates of `PanelDecay.lean`;
* the pole enclosures of `PoleEnclosure.lean`;
* the prime enclosures of `PrimeEnclosure.lean`;
* the exact rational `LDLᵀ` transfer of `GaussianGram6.lean`.

**Scope.**  This is the `6 × 6` rung of the finite Gaussian Weil–Gram
programme: positive definiteness of the Gram matrix of six Gaussian test
functions at `σ = 1/20`.  It is *not* a statement about the infinite Weil cone,
not a sub-cone theorem, and not a proof of the Riemann hypothesis.  A negative
eigenvalue with a rigorous enclosure would refute this specific finite claim.
-/

set_option maxHeartbeats 2000000

noncomputable section

namespace PrimeSpectrumTensor

open Matrix

/-- **M0′ at 6×6, closed.**  The exact `6 × 6` Gaussian Weil Gram matrix at
`σ = 1/20`, with centres `0, 1/5, …, 1`, is positive definite. -/
theorem gaussianGram6_posDef : (gaussianGram6 (1 / 20)).PosDef :=
  gaussianGram6_posDef_of_density_bands
    densityTerm_mem6_c0 densityTerm_mem6_c1 densityTerm_mem6_c2
    densityTerm_mem6_c3 densityTerm_mem6_c4 densityTerm_mem6_c5

/-- **The 6×6 Weil quadratic form is nonnegative** on the span of the six
Gaussian test functions. -/
theorem gaussianGram6_quadraticForm_nonneg (x : Fin 6 → ℝ) :
    0 ≤ ∑ i, ∑ j, x i * x j *
      gaussianGramEntry (centre6 i) (centre6 j) (1 / 20) :=
  gaussianGram6_quadraticForm_nonneg_of_density_bands
    densityTerm_mem6_c0 densityTerm_mem6_c1 densityTerm_mem6_c2
    densityTerm_mem6_c3 densityTerm_mem6_c4 densityTerm_mem6_c5 x

end PrimeSpectrumTensor
