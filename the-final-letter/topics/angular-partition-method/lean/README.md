# Lean layer — angular partition method

**Status:** exact core checked; no `sorry`, `axiom` or `admit`.

`Topic.lean` is the annular/coil core. `Mellin.lean` is the exact
Mellin/Laplace layer for zeta. `CriticalStrip.lean` is the finite-part
regularization and the pole-residue / explicit-formula connection.
`RegularizedIntegral.lean` contains the comparison bounds for the subtracted
kernel.

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
| `AngularPartition.locallyIntegrableOn_regularizedKernel` | Local integrability on `(0,∞)`. |
| `AngularPartition.norm_zetaKernel_le_two_exp_neg` | `‖1/(e^t−1)‖ ≤ 2e^(−t)` for `t ≥ 1`. |
| `AngularPartition.regularizedKernel_isBigO_exp` | `h = O(e^(−t))` at infinity. |
| `AngularPartition.regularizedKernel_isBigO_one` | `h = O(1)` near zero. |
| `AngularPartition.differentiableAt_mellin_regularizedKernel` | `mellin h` is holomorphic for `0 < re s`. |

## What is not formalised

- A vector-valued **area integral** on the disk, as opposed to the phase-carrying tail coil. The tail coil itself is formalised.
- The identity on the critical strip is formalised; convergence, bounds,
  finite part, holomorphy, pole residues and completed functional equation are
  formalised.
- The Euler-product product-to-sum layer.
- Any statement about the zeros of \(\zeta\) or RH.
- The structural obstruction for \(\zeta\). The Lean file proves only the toy
  obstruction that \(1/(n+1)\) is not geometric; the real obstruction is
  summability, phase bookkeeping, and the absence of a closed evaluation, as
  described in README §7.

## Build

```bash
./check.sh
```

The wrapper calls `../../tools/check-lean.sh` with `Topic.lean`, `Mellin.lean`,
`CriticalStrip.lean` and `RegularizedIntegral.lean`.
