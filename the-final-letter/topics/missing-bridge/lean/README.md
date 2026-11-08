# Lean formal core — the missing bridge

## Build

```bash
the-final-letter/topics/missing-bridge/lean/check.sh
```

The wrapper puts the analysis library
(`absolute-polarized-hodge-index-realization/lean`), the finite-window
certificates and the O4 transfer library (`prime-spectrum-tensor/lean`) on
`LEAN_EXTRA_PATH`.  It imports `GaussianZeroSide`, `ZeroTail` and `Transfer`.

## What is proved

| Name | Statement |
|---|---|
| `onLineQuad` | the on-line Gaussian quadratic form `Σ_ij c_i c_j K(a_i − a_j)` at one frequency |
| `onLineQuad_eq_sum_sq` | the form equals `(Σ c_i cos_i)² + (Σ c_i sin_i)²` — the manifest sum of squares |
| `onLineQuad_nonneg` | the on-line form is nonnegative |
| `offLineBlock_not_psd` | an off-line quadruple has a separation whose isolated block is not PSD (harvested `offLineQuad_obstruction_all`) |
| `not_all_offLine_blocks_psd` | uniform block positivity fails for every off-line quadruple |
| `offLine_growth` | the off-line contribution is unbounded in the separation |
| `posSemidef_convexCombination` | the PSD cone is convex (straight-line homotopy) |
| `posSemidef_add_smul` | a nonnegative one-parameter deformation of a PSD matrix is PSD |
| `strict_margin_transfer` | `C − t·I` positive definite plus an entrywise `ε`-bound and `ε·n < t` implies `G` positive definite (harvested `posDef_of_entry_bound`) |
| `centre_sub_margin_posDef` | the rational 4×4 Gaussian centre minus its margin is positive definite (harvested) |
| `centre_certificate_satisfiable` | the rational 4×4 Gaussian centre is positive definite (the finite certificate is not vacuous) |
| `posSemidef_sandwich` | congruence `A ↦ S A Sᵀ` preserves positive semidefiniteness |
| `linear_path_posSemidef_iff` | `A + t•B` is PSD for all `t ≥ 0` iff `A` and `B` are PSD |
| `gaussianWeight` | the on-line weight `2πσ² exp(−σ²γ²)` |
| `hasDerivAt_gaussianWeight` | its σ-derivative is `4πσ exp(−σ²γ²)(1 − σ²γ²)` |
| `gaussianWeight_deriv_pos` | the derivative is positive at `σ = 1/(2γ)` |
| `gaussianWeight_deriv_neg` | the derivative is negative at `σ = 2/γ` |
| `gaussianWeight_not_monotone` | the on-line weight is neither monotone nor antitone in σ |
| `no_uniform_bound_of_offLine_quadruple` | an off-line quadruple in the "other" block defeats every uniform bound |
| `realRankOne_posSemidef` | a real rank-one matrix `u uᵀ` is PSD |
| `finiteWeilGramReal_posSemidef_of_onLine` | if every zero in `S` is on the critical line, the real part of the finite zero-side Gram matrix is PSD |
| `rh_implies_finiteWeilPositivity` | RH implies `FiniteWeilPositivity` |
| `primeMainTerm`, `poleTerm` | the smooth PNT main term and the pole contribution |
| `poleTerm_eq_primeMainTerm_add` | `pole(c) = P_main(c) + P_main(−c)` |
| `poleTerm_sub_primeSums_eq` | the residual is exactly the sum of the two PNT errors |
| `primeMainTerm_eq_re_gaussianZeroTest_zero` | `P_main(c) = Re H_c(0)` |
| `primeMainTerm_neg_eq_re_gaussianZeroTest_one` | `P_main(−c) = Re H_c(1)` |
| `poleTerm_eq_re_gaussianZeroTest_pole_sum` | `pole(c) = Re (H_c(0)+H_c(1))` |
| `arithmeticResidual`, `arithmeticResidual_eq` | `K(c) = PNT errors + arch` |
| `primeWindow`, `gaussianPrimeSide` | the Gaussian window and the truncated prime side |
| `primeWindow_pos`, `gaussianPrimeSide_nonneg` | the window is positive and the prime side is a sum of nonnegative terms |
| `gaussianPrimeSide_term_nonneg`, `gaussianPrimeSide_mono` | termwise nonnegativity and monotonicity of the truncation |
| `primeWindow_neg_neg` | window symmetry `(c,u) ↦ (−c,−u)` |
| `primeMainTerm_pos`, `poleTerm_pos` | positivity of the main and pole terms for `σ > 0` |
| `poleTerm_neg` | the pole term is even in the centre |
| `exp_quadratic_re`, `integral_exp_half_primeWindow` | the completing-the-square identity and `∫ e^{u/2} h_c(u) = P_main(c,σ)` |
| `poleTerm_eq_integral_add` | the pole term is the sum of the two Gaussian integrals |
| `arithmeticResidualKernel`, `arithmeticResidualKernel_neg` | the residual kernel and its evenness |
| `arithmeticGramMatrix`, `arithmeticGramMatrix_isSymm` | the arithmetic Gram matrix and its symmetry |

No `sorry`, `axiom` or `admit`.

## What is *not* proved

Nothing here is a bridge theorem.  In particular:

- `onLineQuad_eq_sum_sq` is the **on-line** sum of squares.  It does not extend
  off the critical line: `not_all_offLine_blocks_psd` is the obstruction, and
  `offLine_growth` says the obstruction grows without bound.
- `posSemidef_convexCombination` and `posSemidef_add_smul` are the elementary
  half of a continuation argument.  They do not supply a deformation that
  preserves positivity *and* connects the Weil form to a manifest square.
- `strict_margin_transfer` and `centre_certificate_satisfiable` are a finite
  4×4 statement.  The admissible entrywise margin is `t/n`, which tends to `0`
  as the dimension grows; nothing here scales to the infinite Weil form.
- `linear_path_posSemidef_iff` is a *negative* result about O2: it shows the
  linear deformation has exactly as much content as positivity at the
  endpoint.  It does not produce a positivity-preserving deformation.
- `gaussianWeight_not_monotone` kills the Gaussian-width flow on the on-line
  part; C10 shows the full 4×4 arithmetic Gram is not monotone either.  These
  are negative results about O2, not a deformation theorem.
- `FiniteWeilPositivity` is the finite-zero-set real-part form.  Only the easy
  direction `RH → FiniteWeilPositivity` is proved; the hard direction
  `FiniteWeilPositivity → RH` (O4) is open, and the infinite/cone version is not
  formalised.

The three objectives recorded in the dossier are open and are not formalised as
theorems.

## Harvested imports

- `GaussianZeroSide.lean` — `gaussianCosMode`, `gaussianSinMode`,
  `zeroSideGramReal_term`, `gaussianZeroTest_eq_mode_mul`, `offLineQuad`,
  `offLineQuad_obstruction_all`, `exists_offLineQuad_gt_all`.
- `Transfer.lean` — `posDef_of_entry_bound`, `gramCentre4`,
  `gramCentre4_sub_posDef`, `gaussianGram4_posDef_of_entry_bound`,
  `gramCentre4_symm`.

[Back to the programme](../README.md) · [Topic index](../../README.md)
