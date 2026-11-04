# Lean layer — angular partition method

**Status:** exact core checked; no `sorry`, `axiom` or `admit`.

`Topic.lean` is the annular/coil core. `Mellin.lean` is the exact
Mellin/Laplace layer for zeta. `CriticalStrip.lean` is the finite-part
regularization and the pole-residue / explicit-formula connection.
`RegularizedIntegral.lean` contains the comparison bounds, cutoff splitting and
the critical-strip identity. `Continuation.lean` continues the method beyond
the critical strip: the sharp bound `0 ≤ h(t) ≤ t/12` and the second-order
bound `‖h₂(t)‖ ≤ t³/720`, Mellin convergence and holomorphy on `−1 < re s`
and `−3 < re s`, the extended integral identities, the equality
`completedMellinPart s = completedRiemannZeta₀ s` with its `s ↦ 1 − s`
symmetry, the explicit `−1/(12(s+1))` pole from the second subtraction and
its cancellation at `s = −1`. `EulerProduct.lean` contains the Euler
product-to-sum identity and the annular/coil representation of the Euler
log-series. `VectorArea.lean` contains the vector-valued area field.
`ExplicitFormula.lean` contains the pole-term contour connection.
`BostConnes.lean` contains the single-prime and all-prime Bost–Connes angular
sums, the prime-log commensurability obstruction, and the continuation beyond
the convergence domain: the single-prime meromorphic continuation with poles at
`s log p = 2πik` (T83–T84) and the all-prime continuation to `ζ` (T85).
`Gram.lean` contains the finite Gram positivity certificate. `ContinuousCoil.lean` contains the shifted
Hurwitz-zeta integral representation, the continuous coil, the closed-form
power-law coil `Z_c(x)=x^(1−σ)/(σ−1)` with `∫_1^∞ x^(−σ)dx=1/(σ−1)` (T81), and
the complex self-similarity `Z_c(e^(2π/|t|)x)=e^(−2π(σ−1)/|t|)Z_c(x)` (T82).
`GeneralSubtraction.lean` develops O8: the kernel `1/(e^z−1)−1/z` has a
removable singularity at `0` and is analytic there (T86); its power-series
remainder is `O(‖z‖^n)` (T87); the partial sums are the polynomials
`Σ p.coeff k · z^k` (T88); the real subtracted kernel is `O(t^n)` at `0`
(T89); the cutoff transform is computed (T90); and the finite-part identity
`mellin K_n = Γζ − 1/(s−1) − Σ c_k/(s+k)` is proved on `Re s > 1` (T91), with
convergence and holomorphy on `Re s > −n` (T92–T93). `BernoulliZeta.lean`
contains the formal Bernoulli reciprocal identity `B(X)·(e^X−1)/X = 1` and the
coefficient form `(B−1)/X` (T94), the algebraic half of the residue relation.

`Topic.lean` formalises the exact algebraic, finite-measure, finite-annular and
infinite-annular part of the method for summable nonnegative sequences, plus
the phase-carrying tail coil. It does not formalise a phase-valued area
integral or any part of the Riemann hypothesis; the zeta Mellin layer is in
`Mellin.lean`.

## What is formalised

| Name | Content |
|---|---|
| `AngularPartition.geom_sector_sum` | \(\sum_{k<n} a r^k = a(1-r^n)/(1-r)\) for \(r\ne1\). |
| `AngularPartition.self_similar_total` | If \(S=a+rS\) and \(r\ne1\), then \(S=a/(1-r)\). |
| `AngularPartition.sector_angle_hasSum` | \(\sum_{n\ge0}\pi(1/2)^n=2\pi\). |
| `AngularPartition.sector_angle_tsum` | The same identity as a `tsum`. |
| `AngularPartition.half_turn_sector_hasSum` / `half_turn_sector_tsum` | The normalized halving total is `1`. |
| `AngularPartition.not_summable_inv_nat_succ` | The shifted harmonic series is not summable. |
| `AngularPartition.geometric_hasSum_complex` / `geometric_tsum_complex` | Complex geometric series for `‖z‖ < 1`. |
| `AngularPartition.layer_cake` | Layer-cake identity for nonnegative sequences. |
| `AngularPartition.inv_nat_not_geometric` | The reciprocal weights \(1/(n+1)\) are not constant-ratio. |
| `AngularPartition.finite_partition_total` | Finite head plus complementary sectors equals the whole. |
| `AngularPartition.measure_partition_finset` | General finite measurable partition: \(\mu(\bigcup_i X_i)=\sum_i\mu(X_i)\). |
| `AngularPartition.annular_telescope` | \(\sum_{k<n}(r_k^2-r_{k+1}^2)=r_0^2-r_n^2\) for arbitrary radii. |
| `AngularPartition.annular_weight_sum` | Any finite weights given by squared-radius differences sum to the disk area. |
| `AngularPartition.tail` / `tailRadius` | The tail sum and its square root. |
| `AngularPartition.tail_eq_add` | `tail n = a n + tail (n+1)`. |
| `AngularPartition.tail_nonneg` | Every tail of a nonnegative sequence is nonnegative. |
| `AngularPartition.annular_representation` | **Infinite annular representation:** for summable nonnegative `a`, `a n = R_n^2 - R_{n+1}^2` and `R_0^2 = ∑' n, a n`. |
| `AngularPartition.ctail` / `coilRadius` / `coilAngle` | Complex tail, coil radius and coil angle. |
| `AngularPartition.phase_carrying_coil` | **Phase-carrying tail coil:** `c n = Z_n - Z_{n+1}`, `Z_n = r_n e^{iθ_n}`, `Z_n → 0`. |
| `AngularPartition.ctail_telescope` | The exact chord identity `∑_{k<n} c k = Z_0 - Z_n`. |
| `AngularPartition.unitCoil_zero` / `unitCoil_tendsto_zero` | The unit coil starts at `1` and tends to `0`. |
| `AngularPartition.finite_eulerProduct_exp_log` | Finite Euler product-to-sum. |
| `AngularPartition.eulerLogSeries_summable` | Prime log-series summability. |
| `AngularPartition.riemannZeta_eulerProduct_exp_log` | Euler product-to-sum for `ζ`. |
| `AngularPartition.nthPrime` / `nthPrime_injective` | Prime enumeration by `Nat.nth`. |
| `AngularPartition.eulerLogSeries_summable_nth` | Summability of the prime-enumerated log-series. |
| `AngularPartition.eulerLogSeries_coil` | Annular/coil representation of the Euler log-series. |
| `AngularPartition.vectorArea` | Vector-valued area field as a vector measure on `ℕ`. |
| `AngularPartition.areaWeight` / `phaseWeight` | Annulus area and phase vector. |
| `AngularPartition.phaseWeight_eq` | `phaseWeight c n = c n`. |
| `AngularPartition.vectorArea_apply` | Evaluation as `∑' n : A, c n`. |
| `AngularPartition.vectorArea_iUnion` | Countable additivity. |
| `AngularPartition.vectorArea_univ` | Total vector area is `∑' n, c n`. |
| `AngularPartition.vectorArea_univ_eq_ctail` | Total vector area equals `ctail c 0`. |
| `AngularPartition.norm_vectorArea_univ_le` | Total-area bound. |
| `AngularPartition.vectorArea_eq_phase_sum` | Phase decomposition of the area field. |
| `AngularPartition.poleKernel` | The two-pole kernel `(z(z−1))⁻¹`. |
| `AngularPartition.explicitFormula_poleContour` | Pole-term contour identity. |
| `AngularPartition.explicitFormula_poleContour_residue_form` | Residue-form contour identity. |
| `AngularPartition.bostConnes_single_prime_angular` / `_tsum` | Single-prime Bost–Connes angular sum. |
| `AngularPartition.bostConnes_all_primes_product` / `_tprod` | All-prime Euler product. |
| `AngularPartition.log_primes_not_commensurable` | Prime logs have no common positive period. |
| `AngularPartition.bostConnesSinglePrime` | Continued single-prime sum `1/(1−p^(−s))`. |
| `AngularPartition.bostConnes_single_prime_continuation` | **T83:** meromorphic continuation of the single-prime sum, agreeing with the series on `Re s > 0`. |
| `AngularPartition.bostConnesSinglePrime_pole_iff` | **T84:** `p^(−s) = 1 ↔ ∃ k, s log p = 2πik`. |
| `AngularPartition.bostConnes_all_primes_continuation` | **T85:** all-prime product continues to `ζ`, holomorphic away from `s = 1`. |
| `AngularPartition.gramQuad_eq_norm_sq` | Gram quadratic form as a squared norm. |
| `AngularPartition.gramQuad_nonneg` | Finite Gram positivity. |
| `AngularPartition.gramMatrix_posSemidef` | Finite Gram matrix PSD. |
| `AngularPartition.gramMatrix_quadForm_nonneg` | Matrix quadratic form nonnegative. |
| `AngularPartition.shiftedZetaKernel` / `shiftedTail` / `continuousCoil` | Shifted kernel, continuous tail and continuous coil. |
| `AngularPartition.hasSum_shiftedZetaKernel` | Geometric series for the shifted kernel. |
| `AngularPartition.hasSum_mellin_shiftedZetaKernel` | Shifted Mellin series. |
| `AngularPartition.mellin_shiftedZetaKernel_eq` | Hurwitz-zeta integral representation. |
| `AngularPartition.continuousCoil_eq_integral` | Continuous coil as a normalized integral. |
| `AngularPartition.continuousIntegralCoil` | Power-law continuous coil `x^(1−σ)/(σ−1)`. |
| `AngularPartition.integral_Ioi_rpow_neg_eq_inv_sub_one` | **Continuous integral closed form:** `∫_1^∞ x^(−σ) dx = 1/(σ−1)` for `σ > 1`. |
| `AngularPartition.integral_Ioi_rpow_neg_eq_continuousIntegralCoil` | The coil is the tail integral: `∫_x^∞ t^(−σ) dt = x^(1−σ)/(σ−1)`. |
| `AngularPartition.hasDerivAt_continuousIntegralCoil` | `−Z_c′(x) = x^(−σ)`. |
| `AngularPartition.continuousComplexCoil` | Complex power-law coil `x^(1−s)/(s−1)`. |
| `AngularPartition.cpow_selfSimilar_factor` | `(e^(2π/|t|))^(1−s) = e^(−2π(σ−1)/|t|)`. |
| `AngularPartition.continuousComplexCoil_selfSimilar` | **T82:** `Z_c(e^(2π/|t|)x) = e^(−2π(σ−1)/|t|) Z_c(x)`. |
| `AngularPartition.generalKernelC` | The kernel `1/(e^z−1)−1/z`. |
| `AngularPartition.norm_exp_sub_one_ge` | `‖z‖/2 ≤ ‖e^z−1‖` for `‖z‖ ≤ 1/2`. |
| `AngularPartition.norm_generalKernelC_le` | `‖1/(e^z−1)−1/z‖ ≤ 2` on `0 < ‖z‖ ≤ 1/2`. |
| `AngularPartition.analyticAt_generalKernelC_zero` | **T86:** removable singularity at `0`; analytic extension at `0`. |
| `AngularPartition.exists_taylorRemainder` | **T87:** power-series remainder `O(‖z‖^n)` for every `n`. |
| `AngularPartition.partialSum_eq_sum_coeff` | **T88:** `p.partialSum n z = Σ_{k<n} p.coeff k · z^k`. |
| `AngularPartition.subtractedKernel_isBigO_zero` | **T89:** the `n`-th subtracted real kernel is `O(t^n)` at `0`. |
| `AngularPartition.hasMellin_cutoffN` | **T90:** cutoff transform `1/(s−1) + Σ c_k/(s+k)` for `Re s > 1`. |
| `AngularPartition.hasMellin_finset_sum` | Finite sums of Mellin transforms. |
| `AngularPartition.mellin_subtractedKernel_eq` | **T91:** finite-part identity on `Re s > 1`. |
| `AngularPartition.mellinConvergent_subtractedKernel` | **T92:** convergence on `Re s > −n`. |
| `AngularPartition.mellin_differentiableAt_subtractedKernel` | **T93:** holomorphy on `Re s > −n`. |
| `AngularPartition.X_mul_expm1DivX` | **T94:** `X · (e^X−1)/X = e^X−1`. |
| `AngularPartition.bernoulliPowerSeries_mul_expm1DivX` | **T94:** `B(X) · (e^X−1)/X = 1`. |
| `AngularPartition.gSeries_coeff` | **T94:** `(B−1)/X` has coefficients `bernoulli (k+1)/(k+1)!`. |
| `AngularPartition.kernel_mul_identity` | **T95:** `z(e^z−1)g(z) = z−(e^z−1)`. |
| `AngularPartition.X_mul_exp_sub_one_mul_gSeries` | **T95:** formal counterpart `X(e^X−1)gSeries = X−(e^X−1)`. |
| `AngularPartition.hasSum_mul_range` | **T96:** Cauchy product of absolutely summable scalar series. |
| `AngularPartition.hasFPowerSeriesAt_mul_ofScalars` | **T97:** product of scalar power series (the missing `HasFPowerSeriesAt.mul`). |
| `AngularPartition.hasFPowerSeriesAt_mul_ofScalars` | **T97:** product of scalar power series (the missing `HasFPowerSeriesAt.mul`). |
| `AngularPartition.hasSum_mul_range` | **T96:** Cauchy product of absolutely summable scalar series. |
| `AngularPartition.kernel_mul_identity` | **T95:** `z(e^z−1)g(z) = z−(e^z−1)`. |
| `AngularPartition.X_mul_exp_sub_one_mul_gSeries` | **T95:** formal counterpart `X(e^X−1)gSeries = X−(e^X−1)`. |

### Mellin layer (`Mellin.lean`)

| Name | Content |
|---|---|
| `AngularPartition.zetaKernel` | The kernel `1/(e^t - 1)`. |
| `AngularPartition.hasSum_zetaKernel` | The geometric exponential sum equals the kernel. |
| `AngularPartition.hasSum_mellin_zetaKernel` | The Mellin HasSum for `Γ(s)` times the Dirichlet series. |
| `AngularPartition.mellin_zetaKernel_eq_Gamma_mul_zeta` | `mellin kernel s = Γ(s) ζ(s)` for `re s > 1`. |
| `AngularPartition.completedRiemannZeta_eq_GammaR_mul_zeta` | `Λ(s) = Γ_ℝ(s) ζ(s)` for `re s > 1`. |
| `AngularPartition.completedRiemannZeta_functional_equation` | `Λ(1 - s) = Λ(s)`. |
| `AngularPartition.mellin_zetaKernel_norm_le` | Vertical-strip growth bound `‖Γ(s)ζ(s)‖ ≤ ‖Γ(s)‖ ∑ 1/(n+1)^(re s)`. |

### Critical-strip layer (`CriticalStrip.lean`)

| Name | Content |
|---|---|
| `AngularPartition.regularizedMellin` | `M_reg(s) = Γ(s)ζ(s) − 1/(s−1) + 1/(2s)`. |
| `AngularPartition.regularizedMellin_eq_mellin_sub_poles` | On `re s > 1`, `M_reg` is the Mellin total minus the two poles. |
| `AngularPartition.regularizedMellin_differentiableAt` | `M_reg` is differentiable in `0 < re s < 1`. |
| `AngularPartition.regularizedMellin_differentiableAt_of_ne` | `M_reg` is differentiable for `0 < re s` and `s ≠ 1`. |
| `AngularPartition.regularizedMellin_residue_one` | The residue at `1` is `1`. |
| `AngularPartition.regularizedMellin_residue_zero` | The residue at `0` is `−1/2`. |
| `AngularPartition.completedRiemannZeta_finite_part` | `Λ(s) = Λ₀(s) − 1/s − 1/(1−s)`. |
| `AngularPartition.completedRiemannZeta₀_functional_equation` | `Λ₀(1−s) = Λ₀(s)`. |

### Regularized-integral layer (`RegularizedIntegral.lean`)

| Name | Content |
|---|---|
| `AngularPartition.regularizedKernel` | The piecewise subtracted kernel. |
| `AngularPartition.abs_regularized_real_le` | `|1/(e^t−1) − 1/t| ≤ 1` for `0<t<1`. |
| `AngularPartition.norm_regularizedKernel_le` | `‖h(t)‖ ≤ 3/2` for `0<t<1`. |
| `AngularPartition.norm_zetaKernel_le_two_div` | `‖1/(e^t−1)‖ ≤ 2/t` for `t≥1`. |
| `AngularPartition.measurable_regularizedKernel` | Measurability of the piecewise kernel. |
| `AngularPartition.integrableOn_regularizedKernel_Ioo` | Mellin integrability on `(0,1)` for `0 < re s`. |
| `AngularPartition.integrableOn_regularizedKernel_Ioi` | Mellin integrability on `(1,∞)` for `re s < 1`. |
| `AngularPartition.mellinConvergent_regularizedKernel` | `MellinConvergent regularizedKernel s` for `0 < re s < 1`. |
| `AngularPartition.mellinConvergent_regularizedKernel_of_pos` | `MellinConvergent regularizedKernel s` for `0 < re s`. |
| `AngularPartition.cutoff` | The compactly supported correction `-1/t+1/2` below `1`. |
| `AngularPartition.regularizedKernel_eq_zetaKernel_add_cutoff` | `h = zetaKernel + cutoff`. |
| `AngularPartition.mellin_add` | Linearity of Mellin for two convergent pieces. |
| `AngularPartition.locallyIntegrableOn_zetaKernel` | Local integrability of the zeta kernel. |
| `AngularPartition.mellinConvergent_zetaKernel` | `MellinConvergent zetaKernel s` for `1 < re s`. |
| `AngularPartition.locallyIntegrableOn_cutoff` | Local integrability of the cutoff. |
| `AngularPartition.mellinConvergent_cutoff` | `MellinConvergent cutoff s` for `1 < re s`. |
| `AngularPartition.mellin_cutoff_eq` | `mellin cutoff s = −1/(s−1)+1/(2s)` for `1 < re s`. |
| `AngularPartition.mellin_regularizedKernel_eq_of_one_lt_re` | The integral identity on `re s > 1`. |
| `AngularPartition.mellin_regularizedKernel_eqOn_upper` | Identity on the upper half-strip. |
| `AngularPartition.mellin_regularizedKernel_eqOn_lower` | Identity on the lower half-strip. |
| `AngularPartition.mellin_regularizedKernel_eq_of_re_pos_of_lt_one` | Identity on the full critical strip. |
| `AngularPartition.finite_eulerProduct_exp_log` | Finite Euler product-to-sum. |
| `AngularPartition.eulerLogSeries_summable` | Prime log-series summability. |
| `AngularPartition.riemannZeta_eulerProduct_exp_log` | Euler product-to-sum for `ζ`. |
| `AngularPartition.riemannZeta_eulerProduct_product_to_sum` | Combined summability and product-to-sum. |
| `AngularPartition.nthPrime` / `nthPrime_injective` | Prime enumeration by `Nat.nth`. |
| `AngularPartition.eulerLogSeries_summable_nth` | Summability of the prime-enumerated log-series. |
| `AngularPartition.eulerLogSeries_coil` | Annular/coil representation of the Euler log-series. |
| `AngularPartition.vectorArea` | Vector-valued area field as a vector measure on `ℕ`. |
| `AngularPartition.areaWeight` / `phaseWeight` | Annulus area and phase vector. |
| `AngularPartition.phaseWeight_eq` | `phaseWeight c n = c n`. |
| `AngularPartition.vectorArea_apply` | Evaluation as `∑' n : A, c n`. |
| `AngularPartition.vectorArea_iUnion` | Countable additivity. |
| `AngularPartition.vectorArea_univ` | Total vector area is `∑' n, c n`. |
| `AngularPartition.vectorArea_univ_eq_ctail` | Total vector area equals `ctail c 0`. |
| `AngularPartition.norm_vectorArea_univ_le` | Total-area bound. |
| `AngularPartition.vectorArea_eq_phase_sum` | Phase decomposition of the area field. |
| `AngularPartition.poleKernel` | The two-pole kernel `(z(z−1))⁻¹`. |
| `AngularPartition.explicitFormula_poleContour` | Pole-term contour identity. |
| `AngularPartition.explicitFormula_poleContour_residue_form` | Residue-form contour identity. |
| `AngularPartition.bostConnes_single_prime_angular` / `_tsum` | Single-prime Bost–Connes angular sum. |
| `AngularPartition.bostConnes_all_primes_product` / `_tprod` | All-prime Euler product. |
| `AngularPartition.log_primes_not_commensurable` | Prime logs have no common positive period. |
| `AngularPartition.bostConnesSinglePrime` | Continued single-prime sum `1/(1−p^(−s))`. |
| `AngularPartition.bostConnes_single_prime_continuation` | **T83:** meromorphic continuation of the single-prime sum, agreeing with the series on `Re s > 0`. |
| `AngularPartition.bostConnesSinglePrime_pole_iff` | **T84:** `p^(−s) = 1 ↔ ∃ k, s log p = 2πik`. |
| `AngularPartition.bostConnes_all_primes_continuation` | **T85:** all-prime product continues to `ζ`, holomorphic away from `s = 1`. |
| `AngularPartition.gramQuad_eq_norm_sq` | Gram quadratic form as a squared norm. |
| `AngularPartition.gramQuad_nonneg` | Finite Gram positivity. |
| `AngularPartition.gramMatrix_posSemidef` | Finite Gram matrix PSD. |
| `AngularPartition.gramMatrix_quadForm_nonneg` | Matrix quadratic form nonnegative. |
| `AngularPartition.shiftedZetaKernel` / `shiftedTail` / `continuousCoil` | Shifted kernel, continuous tail and continuous coil. |
| `AngularPartition.hasSum_shiftedZetaKernel` | Geometric series for the shifted kernel. |
| `AngularPartition.hasSum_mellin_shiftedZetaKernel` | Shifted Mellin series. |
| `AngularPartition.mellin_shiftedZetaKernel_eq` | Hurwitz-zeta integral representation. |
| `AngularPartition.continuousCoil_eq_integral` | Continuous coil as a normalized integral. |
| `AngularPartition.continuousIntegralCoil` | Power-law continuous coil `x^(1−σ)/(σ−1)`. |
| `AngularPartition.integral_Ioi_rpow_neg_eq_inv_sub_one` | **Continuous integral closed form:** `∫_1^∞ x^(−σ) dx = 1/(σ−1)` for `σ > 1`. |
| `AngularPartition.integral_Ioi_rpow_neg_eq_continuousIntegralCoil` | The coil is the tail integral: `∫_x^∞ t^(−σ) dt = x^(1−σ)/(σ−1)`. |
| `AngularPartition.hasDerivAt_continuousIntegralCoil` | `−Z_c′(x) = x^(−σ)`. |
| `AngularPartition.continuousComplexCoil` | Complex power-law coil `x^(1−s)/(s−1)`. |
| `AngularPartition.cpow_selfSimilar_factor` | `(e^(2π/|t|))^(1−s) = e^(−2π(σ−1)/|t|)`. |
| `AngularPartition.continuousComplexCoil_selfSimilar` | **T82:** `Z_c(e^(2π/|t|)x) = e^(−2π(σ−1)/|t|) Z_c(x)`. |
| `AngularPartition.generalKernelC` | The kernel `1/(e^z−1)−1/z`. |
| `AngularPartition.norm_exp_sub_one_ge` | `‖z‖/2 ≤ ‖e^z−1‖` for `‖z‖ ≤ 1/2`. |
| `AngularPartition.norm_generalKernelC_le` | `‖1/(e^z−1)−1/z‖ ≤ 2` on `0 < ‖z‖ ≤ 1/2`. |
| `AngularPartition.analyticAt_generalKernelC_zero` | **T86:** removable singularity at `0`; analytic extension at `0`. |
| `AngularPartition.exists_taylorRemainder` | **T87:** power-series remainder `O(‖z‖^n)` for every `n`. |
| `AngularPartition.partialSum_eq_sum_coeff` | **T88:** `p.partialSum n z = Σ_{k<n} p.coeff k · z^k`. |
| `AngularPartition.subtractedKernel_isBigO_zero` | **T89:** the `n`-th subtracted real kernel is `O(t^n)` at `0`. |
| `AngularPartition.hasMellin_cutoffN` | **T90:** cutoff transform `1/(s−1) + Σ c_k/(s+k)` for `Re s > 1`. |
| `AngularPartition.hasMellin_finset_sum` | Finite sums of Mellin transforms. |
| `AngularPartition.mellin_subtractedKernel_eq` | **T91:** finite-part identity on `Re s > 1`. |
| `AngularPartition.mellinConvergent_subtractedKernel` | **T92:** convergence on `Re s > −n`. |
| `AngularPartition.mellin_differentiableAt_subtractedKernel` | **T93:** holomorphy on `Re s > −n`. |
| `AngularPartition.X_mul_expm1DivX` | **T94:** `X · (e^X−1)/X = e^X−1`. |
| `AngularPartition.bernoulliPowerSeries_mul_expm1DivX` | **T94:** `B(X) · (e^X−1)/X = 1`. |
| `AngularPartition.gSeries_coeff` | **T94:** `(B−1)/X` has coefficients `bernoulli (k+1)/(k+1)!`. |
| `AngularPartition.locallyIntegrableOn_regularizedKernel` | Local integrability on `(0,∞)`. |
| `AngularPartition.norm_zetaKernel_le_two_exp_neg` | `‖1/(e^t−1)‖ ≤ 2e^(−t)` for `t ≥ 1`. |
| `AngularPartition.regularizedKernel_isBigO_exp` | `h = O(e^(−t))` at infinity. |
| `AngularPartition.regularizedKernel_isBigO_one` | `h = O(1)` near zero. |
| `AngularPartition.differentiableAt_mellin_regularizedKernel` | `mellin h` is holomorphic for `0 < re s`. |

### Continuation layer (`Continuation.lean`)

| Name | Content |
|---|---|
| `AngularPartition.regularizedReal_nonneg` | `0 ≤ h(t)` for `0 < t`. |
| `AngularPartition.regularizedReal_le_div_twelve` | `h(t) ≤ t/12` for `0 < t` (sharp, since `B₂/2 = 1/12`). |
| `AngularPartition.norm_regularizedKernel_le_div_twelve` | `‖h(t)‖ ≤ t/12`. |
| `AngularPartition.regularizedKernel_isBigO_rpow_one` | `h = O(t)` near zero. |
| `AngularPartition.mellinConvergent_regularizedKernel_of_neg_one_lt` | `MellinConvergent regularizedKernel s` for `−1 < re s`. |
| `AngularPartition.differentiableAt_mellin_regularizedKernel_of_neg_one_lt` | `mellin h` is holomorphic for `−1 < re s`. |
| `AngularPartition.mellin_regularizedKernel_eq_of_neg_one_lt_re` | Extended integral identity on `−1 < re s`, `s ∉ {0, 1}`. |
| `AngularPartition.completedMellinPart` | The completed Mellin part `Γ(s)ζ(s) − 1/(s−1) + 1/(2s)`. |
| `AngularPartition.completedMellinPart_eq_completedRiemannZeta₀` | `completedMellinPart s = Λ₀(s)`: the functional equation as an integral identity. |
| `AngularPartition.completedMellinPart_one_sub` | `completedMellinPart (1−s) = completedMellinPart s`. |
| `AngularPartition.linCutoff` | The second cutoff `−t/12` below `1`. |
| `AngularPartition.hasMellin_linCutoff` | The second cutoff has Mellin transform `−1/(12(s+1))`. |
| `AngularPartition.regularizedKernel₂` | The twice-subtracted kernel `h₂ = h + (t/12)·𝟙_{(0,1]}`. |
| `AngularPartition.norm_regularizedKernel₂_le` | `‖h₂(t)‖ ≤ t³/720` (the `−B₄/4!` bound). |
| `AngularPartition.mellinConvergent_regularizedKernel₂` | `MellinConvergent regularizedKernel₂ s` for `−3 < re s`. |
| `AngularPartition.differentiableAt_mellin_regularizedKernel₂` | `mellin h₂` is holomorphic for `−3 < re s`. |
| `AngularPartition.mellin_regularizedKernel₂_eq_of_neg_three_lt_re` | Second extended integral identity on `−3 < re s`, `s ∉ {0, 1, −1}`. |
| `AngularPartition.mellin_regularizedKernel₂_sub` | Overlap identity: `mellin h₂ − mellin h = −1/(12(s+1))` where both converge. |
| `AngularPartition.regularizedMellin₂_residue_neg_one` | The pole at `s = −1` cancels: `(s+1)·regularizedMellin₂ s → 0` as `s → −1`. |

## What is not formalised

- A vector-valued **area integral** on the disk, as opposed to the phase-carrying tail coil. The tail coil itself is formalised.
- The identity on the critical strip is formalised; convergence, bounds,
  finite part, holomorphy, pole residues and completed functional equation are
  formalised.
- The Euler-product product-to-sum layer.
- The general Bernoulli subtraction scheme (the `k`-th cutoff for arbitrary
  `k`) and the full-plane Hadamard finite part: the first two steps
  (`k = 1, 2`) are Lean-checked in `Continuation.lean`, but the induction
  over all Bernoulli terms remains text-level/open.
- Any statement about the zeros of \(\zeta\) or RH.
- The structural obstruction for \(\zeta\). The Lean file proves only the toy
  obstruction that \(1/(n+1)\) is not geometric; the real obstruction is
  summability, phase bookkeeping, and the absence of a closed evaluation, as
  described in README §7.

## Build

```bash
./check.sh
```

The wrapper calls `../../tools/check-lean.sh` with all eight files:
`Topic.lean`, `Mellin.lean`, `CriticalStrip.lean`, `RegularizedIntegral.lean`,
`Continuation.lean`, `EulerProduct.lean`, `VectorArea.lean` and
`ExplicitFormula.lean`.
