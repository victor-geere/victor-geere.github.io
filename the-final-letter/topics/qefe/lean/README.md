# Lean formal core — Quantum–Egyptian functional equation

## Build

```bash
cd the-final-letter/topics/qefe
./lean/check.sh
```

The wrapper calls the shared [`tools/check-lean.sh`](../../tools/check-lean.sh),
which uses the local Mathlib installation at `~/lean/mathlib4` (Lean
`v4.35.0-rc2`). `BUILD.log` is a local artefact and is not published; the last
local build of `Topic.lean` reports `[check] OK`.

## Extracted module tree — `GaussianInt/`

The Gaussian-integer/ideal-count development is also available as a
Mathlib-only tree that does **not** import `Topic.lean`. This is the upstream
candidate; `Topic.lean` keeps the originals in `namespace QEFE` so the
declaration ledger is unchanged.

| File | Contents | Capstones |
|---|---|---|
| [`GaussianInt/Norm.lean`](GaussianInt/Norm.lean) | basis `{1, i}`, `Algebra.norm`, `Ideal.absNorm` of `(z)`, unit classification and count, free unit action, the 4-to-1 element/ideal correspondence | `normElements_card_eq_four_mul_idealCount` |
| [`GaussianInt/IdealCount.lean`](GaussianInt/IdealCount.lean) | `χ₄`, `divisorSumChi4`, `IdealCountFormula`, splitting at split/inert/ramified primes, local counts, multiplicativity, the `ArithmeticFunction` assembly | `idealCountFormula` (T198) |
| [`GaussianInt/TwoSquares.lean`](GaussianInt/TwoSquares.lean) | `r2`, `TwoSquaresFormula`, T136/T137, T199 | `twoSquaresFormula` |
| [`GaussianInt/QuadraticField.lean`](GaussianInt/QuadraticField.lean) | `ℚ(i) = AdjoinRoot (X²+1)`, irreducibility, `ℤ[i] ↪ ℚ(i)` and injectivity, coordinates `z = a + b·i`, `finrank_ℚ ℚ(i) = 2` | `coord_eq`, `finrank_QI` |
| [`GaussianInt/RingOfIntegers.lean`](GaussianInt/RingOfIntegers.lean) | `ℚ(i)` is the fraction field of `ℤ[i]`, `ℤ[i]` is integrally closed in `ℚ(i)`, hence the bridge | `ringOfIntegersEquiv : 𝓞 (ℚ(i)) ≃+* ℤ[i]` |
| [`GaussianInt/Audit.lean`](GaussianInt/Audit.lean) | `#print axioms` for the capstones | expected `[propext, Classical.choice, Quot.sound]` |

`ringOfIntegersEquiv` is the gate for the class number formula for `ℚ(i)`: see
[`../CLASS-NUMBER-QI.md`](../CLASS-NUMBER-QI.md) for the remaining obligations
(ideal transport, Dedekind zeta identification, the invariants of `ℚ(i)`, and
the `s = 1` residue comparison) and
[`../GENERALISATION-QI.md`](../GENERALISATION-QI.md) for the quadratic plan.

## Quadratic extension tree — `QuadraticInt/`

The `d = 2` and `d = 3` developments (Phase 3). Both ring-type gates are done;
the counting development is not.

| File | Contents | Capstones |
|---|---|---|
| [`QuadraticInt/ZsqrtdTwo.lean`](QuadraticInt/ZsqrtdTwo.lean) | `ℤ[√−2]` is norm-Euclidean (rounding division), hence a UFD and integrally closed; `ℤ`-basis `{1, √−2}`; units `±1` (`w = 2`) | `instEuclideanDomain`, `instIsIntegrallyClosed`, `unit_eq_one_or_neg_one` |
| [`QuadraticInt/RingOfIntegersTwo.lean`](QuadraticInt/RingOfIntegersTwo.lean) | `ℚ(√−2)` as `AdjoinRoot (X²+2)`, rational coordinates, `IsFractionRing`, `IsIntegralClosure`, the bridge | `ringOfIntegersEquiv_two : 𝓞 (ℚ(√−2)) ≃+* ℤ[√−2]` |
| [`QuadraticInt/Eisenstein.lean`](QuadraticInt/Eisenstein.lean) | the new ring `ℤ[ω]` (`ω² = −1 − ω`), norm `a² − ab + b²`, `w = 6` units, hexagonal-lattice Euclidean division | `instCommRing`, `normE_mul`, `units_card_six`, `instEuclideanDomain`, `instIsIntegrallyClosed` |
| [`QuadraticInt/RingOfIntegersThree.lean`](QuadraticInt/RingOfIntegersThree.lean) | `ℚ(ω)` as `AdjoinRoot (X²+X+1)`, the embedding `ℤ[ω] ↪ ℚ(ω)`, fraction field and integral closure, the bridge | `ringOfIntegersEquiv_three : 𝓞 (ℚ(√−3)) ≃+* ℤ[ω]` |
| [`QuadraticInt/SplitTwo.lean`](QuadraticInt/SplitTwo.lean) | `−2` is a square mod `p ≡ 1,3 (mod 8)` (Legendre symbol + Euler), hence `p = a² + 2b²` | `prime_sq_add_two_sq` |
| [`QuadraticInt/SplitThree.lean`](QuadraticInt/SplitThree.lean) | a cube root of unity mod `p ≡ 1 (mod 3)` (Cauchy's theorem), hence `p = a² − ab + b²` | `prime_normE` |
| [`QuadraticInt/IdealCountTwo.lean`](QuadraticInt/IdealCountTwo.lean) | algebra norm, principal-ideal norm, `w = 2` unit count, the `2`-to-`1` correspondence, split factorisation | `absNorm_span_two`, `normElementsTwo_card_eq_two_mul_idealCount`, `split_prime_ne_two` |
| [`QuadraticInt/SplitCountTwo.lean`](QuadraticInt/SplitCountTwo.lean) | split local ideal count `k+1` for `p ≡ 1,3 (mod 8)` | `split_ideal_count_two` |
| [`QuadraticInt/LocalTwo.lean`](QuadraticInt/LocalTwo.lean) | inert (`p ≡ 5,7 mod 8`) and ramified (`p = 2`) local counts | `inert_ideal_count_even_two`, `ramified_ideal_count_two` |
| [`QuadraticInt/MultTwo.lean`](QuadraticInt/MultTwo.lean) | multiplicativity over coprime norms | `idealCountTwo_mul` |
| [`QuadraticInt/FormulaTwo.lean`](QuadraticInt/FormulaTwo.lean) | `χ₈'` divisor sums, ideal-count and representation formulas | `idealCountTwoFormula`, `rTwo_formula` |
| [`QuadraticInt/IdealCountThree.lean`](QuadraticInt/IdealCountThree.lean) | `ℤ[ω]` algebra norm, principal-ideal norm, `6`-to-`1` correspondence, split factorisation | `normElementsThree_card_eq_six_mul_idealCount` |
| [`QuadraticInt/SplitCountThree.lean`](QuadraticInt/SplitCountThree.lean) | split factors distinct for `p ≡ 1 (mod 3)` | `split_span_ne_three` |
| [`QuadraticInt/SplitCountThreeFull.lean`](QuadraticInt/SplitCountThreeFull.lean) | split local ideal count `k+1` | `split_ideal_count_three` |
| [`QuadraticInt/LocalThree.lean`](QuadraticInt/LocalThree.lean) | inert (`p ≡ 2 mod 3`) and ramified (`p = 3`) local counts | `inert_ideal_count_even_three`, `ramified_ideal_count_three` |
| [`QuadraticInt/MultThree.lean`](QuadraticInt/MultThree.lean) | multiplicativity | `idealCountThree_mul` |
| [`QuadraticInt/FormulaThree.lean`](QuadraticInt/FormulaThree.lean) | `χ₃` divisor sums, ideal-count and representation formulas | `idealCountThreeFormula`, `rThree_formula` |
| [`GaussianInt/ClosedForm.lean`](GaussianInt/ClosedForm.lean) | the `d = 1` closed form `r2 n = 4 Σ_{d\|n} χ₄(d)` | `r2_closed` |
| [`QuadraticInt/Audit.lean`](QuadraticInt/Audit.lean) | `#print axioms` for the Phase 3 capstones | expected `[propext, Classical.choice, Quot.sound]` |

Both fields are complete, and the capstones are single closed-form arithmetic
identities in `n`: `idealCountTwo_closed`, `rTwo_closed`,
`idealCountThree_closed`, `rThree_closed`, with `GaussianInt.r2_closed` for
`d = 1`. See [`../GENERALISATION-QI.md`](../GENERALISATION-QI.md). `d = 7, 11, …`
are not attempted.

## What is proved

[`Topic.lean`](Topic.lean) imports Mathlib and defines, in the `QEFE` namespace:

| Definition | Meaning |
|---|---|
| `egyptianDenom D2 d2` | `D² / d²`, the Egyptian denominator |
| `egyptianUnit D2` | `1 - 1/D²`, the non-unit Egyptian mass |
| `gammaRatio a s` | `Γ((1-s+a)/2) / Γ((s+a)/2)` |
| `qefePrefactor D2 a s` | `(D²/π)^(s-1/2) * gammaRatio a s` |
| `thetaL a τ` | `Σ_{n∈ℤ} exp(-π a² τ n²)`, the rank-one lattice theta |
| `theta2 τ` | `thetaL 1 τ ^ 2`, the square-lattice theta |
| `isingS r`, `isingEps` | normalized Ising `S`-matrix and signs `(1,-1,1)` |
| `su2S r` | normalized `SU(2)₄` `S`-matrix with `r = √3` |
| `finiteTheta n chi dsq τ` | `Σ_i χ_i exp(-π τ / d_i²)` |
| `categoricalPsi n chi dsq D2 s` | `Σ_i χ_i (D²/d_i²)^(-s)` |
| `isingDsq`, `su2Dsq` | squared quantum dimensions `(1,2,1)`, `(1,3,4,3,1)` |
| `isingTheta` | Ising `T`-eigenvalues `(1, e^{πi/8}, -1)` |
| `chi4` | the primitive quadratic character modulo `4`, with complex values |
| `chi4Int` | `χ₄` on the integers |
| `twistedTheta4` | `θ_χ(τ) = Σ_n χ₄(n)n e^(-πn²τ)` (named-input object) |
| `charKernel` | `(n−b)e^(-a(n−b)²)` |
| `thetaPlus`, `thetaMinus` | the two characteristic thetas at shifts `±1/4` |
| `mellinThetaPlus`, `mellinThetaMinus` | their Mellin transforms |
| `scalarTerm s i` | `χ₄(i) sign(i) / |i|^s`, the scalar character summand |
| `plusCharTerm s i`, `minusCharTerm s i` | the `thetaPlus`/`thetaMinus` character summands |
| `completedBeta s` | `2^s ∫_0^∞ t^((s-1)/2) θ_χ(t) dt`, the completed beta |
| `LambdaZ2 s` | `completedRiemannZeta s * completedBeta s`, the completed ℤ² series |
| `r2 n` | the number of ordered integer pairs `(x,y)` with `x²+y²=n` |
| `divisorSumChi4 n` | `Σ_{d|n} χ₄(d)` |
| `TwoSquaresFormula` | theorem (T199): `r2 n = 4 Σ_{d|n} χ₄(d)` for `n ≥ 1` |
| `phasePsi n chi m σ t` | `Σ_i χ_i m_i^(-σ) e^(-it log m_i)` |
| `su2Theta` | `SU(2)₄` `T`-eigenvalues `(1, e^{πi/4}, e^{2πi/3}, e^{5πi/4}, 1)` |

It proves:

| Name | Statement |
|---|---|
| `egyptianDenom_pos` | `0 < D²/d²` when `0 < D²` and `0 < d²` |
| `inv_egyptianDenom` | `(D²/d²)⁻¹ = d²/D²` for non-zero `D²`, `d²` |
| `egyptianUnit_pos` | `0 < 1 - 1/D²` when `1 < D²` |
| `egyptian_total` | `Σ_i 1/m_i = 1` for finite positive `d_i²` summing to `D²` |
| `egyptian_fraction_identity` | Lemma 2.2: with `d_0² = 1`, `Σ_{i≠0} 1/m_i = 1 - 1/D²` |
| `gammaRatio_center` | `gammaRatio a (1/2) = 1` for `a ≥ 0` |
| `qefePrefactor_center` | `qefePrefactor D2 a (1/2) = 1` for `D² > 0`, `a ≥ 0` |
| `Gamma_neg_one` | Mathlib's value of `Γ(-1)` at the pole is `0` |
| `gammaRatio_ising_pole` | `gammaRatio 0 3 = 0` |
| `qefe_fails_ising` | `isingPsi 3 ≠ qefeRhs 4 0 1 isingPsi 3` |
| `gammaRatio_su2_pole` | `gammaRatio 1 4 = 0` |
| `qefe_fails_su2` | `su2Psi 4 ≠ qefeRhs 12 1 1 su2Psi 4` |
| `Real.tendsto_self_mul_Gamma_nhds_zero` | `x * Γ(x) → 1` as `x → 0` |
| `tendsto_norm_Gamma_nhdsGT_neg_one` | `‖Γ(x)‖ → ∞` as `x → −1⁺` |
| `tendsto_norm_gammaRatio_zero_nhdsLT_three` | `‖gammaRatio 0 s‖ → ∞` as `s → 3⁻` |
| `tendsto_norm_qefeRhs_ising_nhdsLT_three` | `‖qefeRhs 4 0 1 isingPsi s‖ → ∞` as `s → 3⁻` |
| `tendsto_norm_sub_atTop_of_eventually_le` | unbounded difference lemma |
| `isingPsi_eventually_bounded_nhdsLT_three` | `isingPsi` locally bounded near `3` |
| `qefeResidual` | `Ψ(s) − RHS(s)` |
| `tendsto_norm_qefeResidual_ising_nhdsLT_three` | Ising residual unbounded near `s = 3` |
| `tendsto_norm_gammaRatio_one_nhdsLT_four` | `‖gammaRatio 1 s‖ → ∞` as `s → 4⁻` |
| `tendsto_norm_qefeRhs_su2_nhdsLT_four` | `‖qefeRhs 12 1 1 su2Psi s‖ → ∞` as `s → 4⁻` |
| `su2Psi_eventually_bounded_nhdsLT_four` | `su2Psi` locally bounded near `4` |
| `tendsto_norm_qefeResidual_su2_nhdsLT_four` | `SU(2)₄` residual unbounded near `s = 4` |
| `finiteThetaSum` | finite exponential sum `Σ cᵢ exp(−λᵢ τ)` |
| `finiteThetaSum_not_modular_of_sum_ne_zero` | non-zero total blocks every modular relation |
| `LatticeThetaMellinChi4` | the former named input, as a `Prop` |
| `latticeThetaMellinChi4` | `LatticeThetaMellinChi4` holds, by T120 |
| `thetaL_one_div` | `Θ_{aℤ}(1/τ) = (√τ / a) Θ_{(1/a)ℤ}(τ)` |
| `theta2_one_div` | `Θ_{ℤ²}(1/τ) = τ Θ_{ℤ²}(τ)` |
| `thetaZn_one_div` | `Θ_{ℤⁿ}(1/τ) = τ^(n/2) Θ_{ℤⁿ}(τ)` |
| `ising_galois` | `S(-r)_{ij} = ε_i ε_j S(r)_{ij}` for `ε = (1,-1,1)` and every `r` |
| `su2_no_signs` | the nontrivial `√3` conjugation of `SU(2)₄` admits no real sign/permutation datum |
| `lattice_realisation_pointed` | a lattice-coset realisation with `n = Σ d_i²` forces every `d_i² = 1` |
| `egyptian_examples` | the Egyptian sums for Ising and `SU(2)₄` |
| `ising_psi_zero_one`, `su2_psi_zero_one` | the two polynomials at `s = 0, 1` |
| `finiteTheta_mellin` | `∫_0^∞ τ^(s-1) Θ(τ) dτ = Γ(s) π^(-s) Σ_i χ_i d_i^(2s)` for `Re s > 0` |
| `D2_rpow_mul_categoricalPsi` | `D^(2s) Ψ(s) = Σ_i χ_i d_i^(2s)` |
| `finiteTheta_mellin_categorical` | `∫_0^∞ τ^(s-1) Θ(τ) dτ = Γ(s) π^(-s) D^(2s) Ψ(s)` |
| `ising_root_number` | the Ising normalized Gauss root number is `e^{πi/8}` |
| `su2_root_number` | the `SU(2)₄` normalized Gauss root number is `i` |
| `chi4_neg_one` | `χ₄(-1) = -1` |
| `chi4Int_add_four` | `χ₄(n+4) = χ₄(n)` |
| `chi4Int_neg` | `χ₄(-n) = -χ₄(n)` |
| `chi4Int_eq_sin` | `χ₄(n) = sin(πn/2)` |
| `jacobiTheta2'_term_diff` | pointwise Jacobi-term identity |
| `twistedTheta4_eq_jacobi` | `twistedTheta4` as a Jacobi-theta derivative |
| `jacobiTheta2'_term_thetaPlus` | pointwise `thetaPlus` Jacobi combination |
| `charKernel_eq_exp` | characteristic-kernel factorization |
| `thetaPlus_eq_jacobi` | `thetaPlus` Jacobi assembly |
| `jacobiTheta2'_term_thetaMinus` | pointwise `thetaMinus` combination |
| `charKernel_minus_eq_exp` | `thetaMinus` kernel factorization |
| `thetaMinus_eq_jacobi` | `thetaMinus` Jacobi assembly |
| `jacobiTheta₂_arg_quarter` | quarter-point argument normalisation |
| `jacobiTheta₂'_arg_quarter` | prime quarter-point argument normalisation |
| `jacobiTheta2''_quarter_minus` | `J''(1/4,i/a)=thetaMinus(1/a)` |
| `jacobiTheta2''_quarter_plus` | `J''(-1/4,i/a)=thetaPlus(1/a)` |
| `twistedTheta4_vector_modular` | vector modular relation |
| `hasSum_mellin_thetaPlus` | `thetaPlus` Mellin HasSum identity |
| `thetaMinus_eq_tsum_plus` | `thetaMinus` summand rewritten with `n+1/4` |
| `hasSum_mellin_thetaMinus` | `thetaMinus` Mellin HasSum identity |
| `oddIndex` | parity reindexing of odd denominators |
| `abs_oddIndex_sub_quarter` | `|oddIndex k - 1/4| = (2k+1)/4` |
| `sign_oddIndex_sub_quarter` | `sign(oddIndex k - 1/4) = (-1)^(k+1)` |
| `oddIndex_injective` | `oddIndex` injective |
| `oddIndex_surjective` | `oddIndex` surjective |
| `oddIndexEquiv` | `ℕ ≃ ℤ` |
| `sign_oddIndex_cast` | cast sign formula |
| `betaSeries_reindex` | reindex signed odd series along `oddIndex` |
| `cpow_quarter` | quarter-denominator cpow factor |
| `betaSeriesStatement` | signed odd series = `-4^s β(s)` |
| `twistedTheta4_summand_even` | evenness of the `twistedTheta4` summand |
| `hasSum_mellin_twistedTheta4` | scalar Mellin HasSum for `twistedTheta4` |
| `chi4Int_two_mul_add_one` | `χ₄(2k+1)=(-1)^k` |
| `jacobiTheta₂_arg_quarter_neg` | negative argument normalisation |
| `jacobiTheta₂'_arg_quarter_neg` | negative prime argument normalisation |
| `summable_nat_mul_exp_neg_sq` | `Σ n exp(-a n²)` is summable for `a > 0` |
| `summable_thetaKernel_int` | `Σ_{n∈ℤ} n exp(-a n²)` is summable for `a > 0` |
| `norm_chi4Int_le_one` | `‖χ₄(n)‖ ≤ 1` |
| `summable_norm_thetaKernel_int` | `Σ ‖n exp(-a n²)‖` is summable |
| `summable_twistedTheta4` | `twistedTheta4 τ` is summable for `τ > 0` |
| `norm_thetaKernel` | `‖n exp(-a n²)‖ = |n| exp(-a n²)` |
| `thetaKernel_neg` | `thetaKernel a (-n) = -thetaKernel a n` |
| `gaussSumChi4_eq` | `Σ χ₄(a)e^(2πia/4) = 2i` |
| `rootNumberChi4_eq` | normalized root number `= i` |
| `norm_charKernel` | `‖charKernel a b n‖ = |n−b|e^(-a(n−b)²)` |
| `summable_gaussian_int` | Gaussian summable on `ℤ` |
| `summable_charKernel` | `charKernel a b` summable for `a > 0` |
| `summable_thetaPlus`, `summable_thetaMinus` | characteristic theta sums summable for `τ > 0` |
| `chi4_conductor` | the conductor of `χ₄` is `4` |
| `chi4_primitive` | `χ₄` is primitive |
| `chi4_completedLFunction_one_sub` | the completed `L`-function functional equation for `χ₄` |
| `phasePsi_conj` | `Ψ(σ,-t) = conj Ψ(σ,t)` |
| `phasePsi_norm_le` | `‖Ψ(σ,t)‖ ≤ Σ_i |χ_i| exp(-σ log m_i)` |
| `su2_psiR_half` | `Ψ_SU2(1/2) = 2/√3 - 1` |
| `su2_psi_two_three` | `Ψ_SU2(2) = 0`, `Ψ_SU2(3) = 1/144` |
| `scalarTerm_zero` | `scalarTerm s 0 = 0` |
| `scalarTerm_neg` | `scalarTerm s (-i) = scalarTerm s i` |
| `chi4Int_even` | `χ₄(2k) = 0` |
| `scalarTerm_two_mul` | `scalarTerm s (2k) = 0` |
| `norm_scalarTerm_le` | `‖scalarTerm s i‖ ≤ 1/|i|^(Re s)` |
| `summable_scalarTerm` | scalar character series summable for `Re s > 1` |
| `support_scalarTerm_nat` | the `ℕ`-restricted support is contained in the odd integers |
| `scalarTerm_odd` | `scalarTerm s (2k+1) = (-1)^k/(2k+1)^s` |
| `tsum_nat_odd` | `Σ_n scalarTerm s n = Σ_k scalarTerm s (2k+1)` |
| `scalarBetaStatement` | `ScalarBetaStatement`: `Σ_i χ₄(i)sign(i)/|i|^s = 2β(s)` |
| `plusCharTerm_neg` | `plusCharTerm s (-i) = -minusCharTerm s i` |
| `tsum_plus_eq_neg_tsum_minus` | `Σ_i plusCharTerm = -Σ_i minusCharTerm` |
| `tsum_minusCharTerm` | `Σ_i minusCharTerm = 4^s β(s)` |
| `charKernel_quarter_neg` | `charKernel a (1/4) (-n) = -charKernel a (-1/4) n` |
| `thetaPlus_eq_neg_thetaMinus` | `thetaPlus τ = -thetaMinus τ` |
| `twistedTheta4_eq_cpow_inv` | `twistedTheta4 a = a^(-3/2) thetaMinus(1/a)` |
| `mellin_twistedTheta4_eq` | `mellin twistedTheta4 ((s+1)/2) = mellinThetaMinus (1-s/2)` |
| `mellin_twistedTheta4_eq_gamma_beta` | `mellin twistedTheta4 ((s+1)/2) = Γℝ(s+1)·2β(s)` |
| `mellin_twistedTheta4_eq_gamma_beta_dual` | `mellin twistedTheta4 ((2-s)/2) = Γℝ(s+1)·4^sβ(s)` |
| `completedBeta_eq_gamma_beta` | `completedBeta s = 2^(s+1)Γℝ(s+1)β(s)` |
| `completedBeta_functional_equation` | `completedBeta s = completedBeta (1-s)` |
| `chi4_natCast` | `χ₄(n) = chi4Int n` for `n : ℕ` |
| `chi4_two_mul` | `χ₄(2m) = 0` |
| `support_chi4_LSeries` | the `χ₄` Dirichlet summand on `ℕ` is supported on odd integers |
| `LSeries_chi4` | the naive Dirichlet series of `χ₄` is `β(s)` |
| `chi4_isQuadratic` | `χ₄` is quadratic |
| `chi4_inv_eq_self` | `χ₄⁻¹ = χ₄` |
| `gaussSum_chi4_eq_std` | Mathlib's Gauss sum of `χ₄` equals `gaussSumChi4` |
| `rootNumber_chi4_eq_one` | the root number of `χ₄` is `1` |
| `completedLFunction_chi4_eq` | `completedLFunction χ₄ s = Γℝ(s+1)·β(s)` for `Re s > 1` |
| `completedBeta_eq_two_cpow_completedLFunction` | `completedBeta s = 2^(s+1)·completedLFunction χ₄ s` for `Re s > 1` |
| `thetaMinus_eq_oddKernel` | `thetaMinus` is `oddKernel` at shift `1/4` |
| `twistedTheta4_eq_sinKernel` | `twistedTheta4` is `sinKernel` at shift `1/4` |
| `continuousOn_twistedTheta4` | continuity on `(0,∞)` |
| `isBigO_twistedTheta4_atTop` | exponential decay at `+∞` |
| `isBigO_twistedTheta4_zero` | `O(t^(−b))` at `0` for every `b` |
| `locallyIntegrableOn_twistedTheta4` | local integrability on `(0,∞)` |
| `mellin_twistedTheta4_differentiableAt` | the Mellin transform is entire |
| `differentiable_mellin_twistedTheta4` | the Mellin transform is differentiable |
| `differentiable_completedBeta` | `completedBeta` is entire |
| `completedBeta_functional_equation_all` | `completedBeta s = completedBeta (1-s)` for all `s` |
| `completedBeta_eq_two_cpow_completedLFunction_all` | the all-`s` bridge to `completedLFunction χ₄` |
| `chi4_completedLFunction_one_sub_theta` | T24 re-derived from the theta route |
| `gammaR_duplication` | `2^(s+1)Γℝ(s)Γℝ(s+1) = 4π^(−s)Γ(s)` |
| `lambdaZ2_self_dual` | P1: `Λ_ℤ²(s) = Λ_ℤ²(1-s)` |
| `lambdaZ2_product` | P1: `Λ_ℤ²(s) = 4π^(−s)Γ(s)ζ(s)β(s)` for `Re s > 1` |
| `LSeries_divisorSumChi4` | the divisor-sum L-series is `ζ(s)β(s)` |
| `epstein_series_eq_four_zeta_beta` | the Epstein reduction `LSeries r₂ = 4ζβ` |
| `r2_eq_zero_iff` | `r2 n = 0` iff there is no integer representation `x²+y²=n` |
| `algebra_norm_gaussian` | `Algebra.norm ℤ z = z.norm` for Gaussian integers |
| `absNorm_span_gaussian` | `Ideal.absNorm (span {z}) = z.norm.natAbs` |
| `gaussian_unit_classification` | every Gaussian unit is `1, -1, i` or `-i` |
| `gaussianUnits_card_four` | `Nat.card GaussianIntˣ = 4` |
| `r2_eq_natCard_gaussian` | `r2 n = Nat.card {z : ℤ[i] // z.norm.natAbs = n}` |
| `absNorm_span_gaussian_of_norm` | a norm-`n` Gaussian integer generates an ideal of norm `n` |
| `gaussian_span_eq_iff_associated` | `span {x} = span {y}` iff `x` and `y` are associates |
| `normElements_smul_eq_self_iff` | the unit action on norm-`n` Gaussian integers is free for `n > 0` |
| `normElements_card_eq_four_mul_orbits` | Burnside: `|NormElements n| = 4 · #orbits` |
| `orbitsEquivIdeals` | orbit quotient ↔ ideals of norm `n` |
| `normElements_card_eq_four_mul_idealCount` | `|NormElements n| = 4 · #ideals` |
| `r2_eq_four_mul_idealCount` | `r2 n = 4 · # {I // absNorm I = n}` |
| `IdealCountFormula` | theorem (T198): `# {I // absNorm I = n} = Σ_{d|n}χ₄(d)` |
| `twoSquaresFormula_of_idealCount` | `TwoSquaresFormula` from `IdealCountFormula` |
| `gaussian_split_prime` | `p ≡ 1 mod 4` splits as `π * star π` in `ℤ[i]` |
| `gaussian_span_prime_factorization` | `(p) = (π)(star π)` for split primes |
| `gaussian_absNorm_span_natCast` | `absNorm (n) = n²` in `ℤ[i]` |
| `gaussian_inert_prime` | inert primes `p ≡ 3 mod 4` |
| `gaussian_prime_one_add_I` | `1 + i` is prime |
| `gaussian_ramified_two` | `(2) = (1+i)²` |
| `gaussian_inert_span_prime` | `(p)` prime for inert `p ≡ 3 mod 4` |
| `gaussian_ramified_span_prime` | `(1+i)` prime |
| `gaussian_inert_unique_prime` | unique maximal ideal above inert `p` |
| `gaussian_inert_ideal_eq_span_pow` | inert ideals of norm `p^(2e)` are `(p)^e` |
| `gaussian_inert_ideal_count_even` | inert even-exponent count is `1` |
| `gaussian_inert_no_ideal_norm_prime` | no ideal of norm `p` for inert `p` |
| `gaussian_inert_no_ideal_norm_odd` | no ideal of odd-exponent norm |
| `gaussian_inert_ideal_count_odd` | inert odd-exponent count is `0` |
| `gaussian_ramified_unique_prime` | unique maximal ideal above `2` |
| `gaussian_ramified_ideal_eq_span_pow` | ideals of norm `2^k` are `(1+i)^k` |
| `gaussian_ramified_ideal_count` | ramified count is `1` |
| `gaussian_ideal_dvd_span_absNorm` | `I ∣ (absNorm I)` |
| `gaussian_ideal_dvd_span_pow_of_absNorm` | `absNorm I = p^k → I ∣ (p)^k` |
| `gaussian_split_maximal_eq` | maximal ideals above split `p` are `(π)` or `(star π)` |
| `gaussian_prime_of_norm_natAbs` | prime norm implies prime element |
| `gaussian_split_prime_star` | both `π` and `star π` prime |
| `gaussian_split_maximal_eq'` | unconditional split maximal classification |
| `gaussian_split_norm` | split factor has norm `p` |
| `gaussian_split_span_norm` | both split prime ideals have norm `p` |
| `gaussian_split_span_ne` | the two split primes are distinct |
| `gaussian_split_nonzero_data` | split representation has nonzero coordinates |
| `gaussian_split_prime_star_ne` | split factorization with distinct primes |
| `gaussian_isMaximal_of_absNorm_prime` | prime norm implies maximal |
| `gaussian_split_ideal_eq_of_absNorm` | norm-`p` ideals are `(π)` or `(star π)` |
| `gaussian_split_ideal_count_one` | exactly two ideals of norm `p` |
| `gaussian_split_pow_norm` | norm of `(π)^a (star π)^b` is `p^(a+b)` |
| `gaussian_split_pow_norm_of_add` | norm is `p^k` when `a+b=k` |
| `gaussian_split_isCoprime` | the two split primes are coprime |
| `gaussian_split_isCoprime_pow` | powers of the split primes are coprime |
| `gaussian_split_pow_ne` | `P^k ≠ Q^k` for split primes |
| `gaussian_split_pow_inj` | the `k+1` candidate ideals are distinct |
| `gaussian_split_ideal_count_of_exhaustive` | split count from exhaustiveness |
| `gaussian_split_peel` | peel a split prime from norm `p^(k+1)` |
| `gaussian_split_exhaustive` | every norm-`p^k` ideal is a candidate |
| `gaussian_split_ideal_count` | split count is `k+1` |
| `gaussian_isCoprime_span_nat` | `(m)` and `(n)` coprime for coprime naturals |
| `gaussian_coprime_dvd_decompose` | coprime divisor decomposition of `(a)(b)` |
| `chi4Int_mul` | `chi4Int` is multiplicative |
| `ideal_coprime_dvd_decompose` | coprime ideal divisor decomposition |
| `divisorSumChi4_prime_pow_one` | `Σ χ₄(p^j) = k+1` for split `p` |
| `chi4_mul` | raw `χ₄` is multiplicative on `ℤ` |
| `chi4_pow_three` | `χ₄(p^j) = (-1)^j` for inert `p` |
| `divisorSumChi4_prime_pow_three` | inert divisor sum is `1` or `0` |
| `divisorSumChi4_prime_pow_two` | ramified divisor sum is `1` |
| `divisorSumChi4_mul` | divisor sum is multiplicative |
| `nat_eq_of_dvd_sq_mul` | coprime square-divisor norm split |
| `gaussian_sup_mul_span_eq` | `(K1 K2) ⊔ (m) = K1` for coprime norms |
| `gaussian_sup_span_absNorm_left` | left norm component is `m` |
| `gaussian_sup_span_absNorm_right` | right norm component is `n` |
| `gaussianIdealCountEquiv` | ideal-count product equivalence |
| `gaussian_idealCount_mul` | ideal count is multiplicative |
| `idealCountFun_isMultiplicative` | ideal count arithmetic function is multiplicative |
| `divisorSumFun_isMultiplicative` | divisor sum arithmetic function is multiplicative |
| `idealCount_prime_pow_eq` | ideal count equals divisor sum on prime powers |
| `idealCountFormula` | `# {I // absNorm I = n} = Σ_{d|n}χ₄(d)` |
| `twoSquaresFormula` | `r₂(n) = 4Σ_{d|n}χ₄(d)` |

The finite core uses finitely supported sums over `Fin (n+1)` and does not assume
any categorical axioms. The theta theorems are derived from Mathlib's Gaussian
Poisson summation (`Real.tsum_exp_neg_mul_int_sq`). The Mellin theorem T15 uses
Mathlib's Gamma integral (`Real.integral_rpow_mul_exp_neg_mul_Ioi`). The Galois
theorems are finite matrix identities over `ℝ`; the `SU(2)₄` theorem compares the
`(1,1)` entry and uses `r² = 3`.

## What is not formalised

These are the named analytic and categorical inputs, not gaps in the finite
core:

- **General rank-`n` lattice theta.** The rank-one and square-lattice cases are
  proved; the general even-lattice Poisson step is the standard textbook input
  (Cassels; Conway–Sloane).
- **The general Bantay sign identity.** The Ising datum is verified and the
  `SU(2)₄` `√3` case is settled negatively; the general equivariance theorem is
  cited.
- **The half-spectrum zeta limit.** `Σ_{j≤k/2} d_j^{-2s} → ζ(2s)` (and the
  signed analogue `→ η(2s)`) is a paper theorem with an mpmath certificate; it
  is not a finite Lean identity.
- **MTC existence and integrality.** `egyptian_total` and
  `egyptian_fraction_identity` take a finite list of positive squared quantum
  dimensions summing to `D²` as a hypothesis; they do not construct an MTC.
- **The root numbers.** `W = D^{-1} Σ d_i² θ_i` is computed for the two examples
  in Python; formalising the `T`-matrix data is not needed for the finite core.
- **The two-squares formula — proved.** `TwoSquaresFormula`
  (`r2 n = 4 Σ_{d|n} χ₄(d)`) is T199, via the Gaussian-integer element/ideal
  count (T129–T136) and the ideal-count formula (T178–T198). T122/T123 are
  unconditional.
- **The class number formula for `ℚ(i)` — not formalised.** The ring-of-integers
  bridge `𝓞 (ℚ(i)) ≃+* ℤ[i]` is proved in
  [`GaussianInt/RingOfIntegers.lean`](GaussianInt/RingOfIntegers.lean), but the
  residue comparison at `s = 1` and `β(1) = π/4` are not; the plan is
  [`../CLASS-NUMBER-QI.md`](../CLASS-NUMBER-QI.md). In particular no theorem
  named `classNumber_gaussianInt` or `L_one_chi4_ne_zero` exists.
- **The T24 replacement.** The β-part of the χ₄ `L`-series is theta-proved
  (T84, T92–T95), the bridge to Mathlib's `completedLFunction chi4` is T104–T116,
  and the T24 statement is re-derived from the theta route as T117. The original
  `chi4_completedLFunction_one_sub` (T24) is retained for compatibility but is
  no longer the critical route.

## Honesty note

No declaration in `Topic.lean` is a restatement of the QEFE. The file proves the
finite Egyptian algebra, the rank-one and square-lattice theta transformations,
the two finite Galois statements, the pointed-lattice counting theorem, and the
two-squares count (T199). It also **refutes** the displayed QEFE for the Ising
and `SU(2)₄` data at the gamma pole (T200–T204). It does not prove the general
QEFE, and it does not prove or suggest the Riemann hypothesis, GRH, twin primes,
Chowla, Sarnak, or Elliott.

[Back to the programme](../README.md) · [Topic index](../../README.md)
