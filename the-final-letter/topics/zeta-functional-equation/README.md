# The zeta functional equation and the continuation of `ζ′/ζ`

**Status:** the functional equation, the analytic continuation of `ζ` away from
`1`, the zero correspondence between `ζ` and `Λ`, and the analyticity of
`ζ′/ζ` away from the zeros are proved. Nothing here proves the Riemann
hypothesis.

This is **direction 1** of the two repairs identified in
[`archimedean-prime-evaluation`](../archimedean-prime-evaluation/README.md) as
O3: the explicit formula's prime side needs the logarithmic derivative of `ζ`
on the critical line, which in turn needs the functional equation and the
continuation. See also [`zero-sum-convergence`](../zero-sum-convergence/README.md)
(direction 2, O4).

## Provenance

Everything is proved from Mathlib's Riemann-zeta development:

* `completedRiemannZeta_one_sub` — the functional equation `Λ(1 − s) = Λ(s)`;
* `riemannZeta_one_sub` — the functional equation for `ζ` itself;
* `differentiableAt_riemannZeta (s ≠ 1)` — the analytic continuation;
* `riemannZeta_def_of_ne_zero` — `ζ(s) = Λ(s)/Gammaℝ(s)`;
* `riemannZeta_neg_two_mul_nat_add_one` — the trivial zeros.

No new analysis is assumed for the T-ledger; the work there is the organisation of these
facts into the exact statements the explicit formula needs, plus the logarithmic
derivative results, which Mathlib does not state.

*Theta programme.*  Separately from the T-ledger, the V-ledger below re-derives the
functional equation from the Jacobi theta series: `θ` is defined in-repo, its
functional equation is proved from Mathlib's Poisson summation
(`Real.tsum_exp_neg_mul_int_sq`), the Mellin representation is established, and the
symmetric integral form is obtained.  The layer now lives in the sibling topic
[`zeta-from-theta`](../zeta-from-theta/lean/README.md); its records are
`../zeta-from-theta/lean/Theta.lean`, `Mellin.lean` and `Zeta.lean`, re-exported
by `ThetaLayer.lean` and imported here by `Topic.lean`.

**Provenance (I1).**  T1–T3 below now have an in-repo construction behind them:
[`zeta-from-theta`](../zeta-from-theta/README.md) defines `zetaTheta` from the
theta side and proves its functional equation with a dependency cone that a
constant-level audit ([`AUDIT.md`](../zeta-from-theta/lean/AUDIT.md)) shows
contains none of Mathlib's `*_one_sub` lemmas.  This topic's own V-ledger and
its Mathlib-based T-ledger are unchanged; the theta layer is simply imported
through `ThetaLayer`.

## Objects

* `Λ(s) = completedRiemannZeta s`, `Λ₀(s) = completedRiemannZeta₀ s`;
* `Gammaℝ s = π^{−s/2} Γ(s/2)`;
* `logDeriv riemannZeta s = ζ′(s)/ζ(s)`.

## Theorem ledger

| Kind | Item | Statement | Lean |
|---|---|---|---|
| Theorem | T1 | **Functional equation for `Λ`:** `Λ(1 − s) = Λ(s)`. *Re-exported from Mathlib* (`completedRiemannZeta_one_sub`), not reproved here. | `completedZeta_one_sub` |
| Theorem | T2 | Functional equation for `Λ₀`. *Re-exported from Mathlib.* | `completedZeta₀_one_sub` |
| Theorem | T3 | Functional equation for `ζ`, `ζ(1 − s) = 2(2π)^{−s}Γ(s)cos(πs/2)ζ(s)` (for `1 − s ∉ ℕ`, `s ≠ 1`). *Re-exported from Mathlib* (`riemannZeta_one_sub`). | `zeta_one_sub` |
| Theorem | T4 | **Zero symmetry of `Λ`:** `Λ(s) = 0 ↔ Λ(1 − s) = 0`. | `completedZeta_zero_iff_one_sub` |
| Theorem | T5 | Zero symmetry of `Λ₀`. | `completedZeta₀_zero_iff_one_sub` |
| Theorem | T6 | `Λ₀` is entire. | `completedZeta₀_entire` |
| Theorem | T7 | `Λ` differentiable away from `0`, `1`. | `completedZeta_differentiableAt` |
| Theorem | T8 | **Continuation:** `ζ` differentiable away from `1`. | `differentiableAt_zeta` |
| Theorem | T9 | **Continuation, analytic form:** `ζ` analytic away from `1`. | `analyticAt_zeta` |
| Theorem | T10 | `ζ` has no zeros on `Re s > 1`. | `zeta_ne_zero_of_one_lt_re` |
| Theorem | T11 | `ζ(s) = Λ(s)/Gammaℝ(s)` for `s ≠ 0`. | `zeta_eq_completed_div` |
| Theorem | T12 | **`Gammaℝ` never vanishes** away from `s = −2n`. | `Gammaℝ_ne_zero` |
| Theorem | T12b | `Gammaℝ s = 0 ↔ ∃ n, s = −2n`. | `Gammaℝ_eq_zero_iff` |
| Theorem | T13 | **Zero correspondence:** for `s ≠ 0, 1` and `s ∉ {−2n}`, `ζ(s) = 0 ↔ Λ(s) = 0`. | `zeta_zero_iff_completed_zero` |
| Theorem | T14 | **`ζ′/ζ` analytic** away from `1` and the zeros. | `analyticAt_logDeriv_zeta` |
| Theorem | T15 | **`ζ′/ζ` differentiable** away from `1` and the zeros. | `differentiableAt_logDeriv_zeta` |
| Theorem | T16 | `ζ(0) = −1/2`. | `zeta_zero` |
| Theorem | T17 | `ζ(2) = π²/6`. | `zeta_two` |
| Theorem | T18 | `ζ(2) ≠ 0`. | `zeta_two_ne_zero` |
| Theorem | T19 | Trivial zeros: `ζ(−2(n+1)) = 0`. | `zeta_neg_two_mul_nat_add_one` |
| Theorem | T20 | Residue of `Λ` at `1` is `1`. | `completedZeta_residue_one` |
| Theorem | T21 | `Λ(1) = (γ − log 4π)/2`. | `completedZeta_one` |
| Theorem | T22 | Conjugation symmetry of `ζ`. | `zeta_conj` |
| Theorem | T23 | **Zeros are closed under conjugation.** | `zeta_zero_conj` |
| Theorem | T24 | **Zeros are closed under `s ↦ 1 − s`** (off the `Γ` poles). | `zeta_zero_one_sub` |
| Theorem | T25 | **The fourfold symmetry** of the nontrivial zeros. | `zeta_zero_quadruple` |
| Theorem | T26 | **Zeros with `Re s < 0` are exactly the negative even integers.** | `zeta_zero_of_re_neg` |
| Theorem | T27 | **Residue of `ζ′/ζ` at a simple zero is `1`**: `(s − ρ)·ζ′(s)/ζ(s) → 1` (simplicity hypothesised). | `tendsto_logDeriv_zero` |
| Theorem | T28 | Logarithmic derivative of a finite product: `logDeriv ∏(z−ρ) = Σ 1/(s−ρ)`. | `logDeriv_prod_linear` |
| Theorem | T29 | **Residue decomposition** `ζ′/ζ = Σ_ρ 1/(s−ρ) + g′/g` given the local factorisation through simple zeros. | `logDeriv_zeta_eq_sum_add` |
| Theorem | T30 | **The prime sum at `Re s = 1/2` is not absolutely convergent:** `Σ Λ(n)/√n = ∞`. | `not_summable_vonMangoldt_div_sqrt` |
| Theorem | T31 | Rectangle Cauchy identity, in terms of `boundaryIntegral`. | `boundaryIntegral_eq_zero_of_differentiableOn` |
| Theorem | T32 | Cauchy identity off a countable set (the shape the argument principle needs). | `boundaryIntegral_eq_zero_of_off_countable` |
| Theorem | T33 | **Contour-shift reduction:** the vertical-integral difference equals the residue sum minus the horizontal terms. | `verticalDifference_eq_of_boundary` |
| Definition | D1 | **O3a stated in Lean:** `RectangleResidueTheorem F H z w`, the rectangle residue theorem for `H·ζ′/ζ`. | `RectangleResidueTheorem` |
| Definition | D2 | **O3a stated in Lean:** `ContourShiftStatement H`, the concrete contour shift on `[1/2, 2] × [−T, T]` with the strip zeros and the pole at `1`. | `ContourShiftStatement` |
| Theorem | T34 | **Circle residue theorem (single simple pole):** `∮_{C(c,R)} H·f′/f = 2πi·H(ρ)` given the subtracted singular part continuous on the disc and holomorphic off `ρ`. | `circleIntegral_residue` |
| Definition | D3 | **O3's circle residue theorem as a `Prop`.** | `CircleResidueTheorem` |
| Theorem | T35 | **`CircleResidueTheorem` holds** — it is a theorem, not an assumption. | `circleResidueTheorem_holds` |
| Theorem | T36 | The circle residue theorem at a simple zero of `ζ`. | `circleResidueTheorem_zeta` |
| Theorem | T37 | **Circle residue theorem, finite sum of simple poles:** `∮_{C(c,R)} H·f′/f = 2πi·Σ_ρ H(ρ)`. | `circleIntegral_residue_sum` |
| Theorem | T38 | The kernel integral `∮_{C(c,R)}(z−ρ)⁻¹ = 2πi` for `ρ` inside. | `circleIntegral_inv_sub` |
| Theorem | T39 | **The prime side on `Re s > 1`:** `ζ′(s)/ζ(s) = −Σ'_n Λ(n)/n^s`. | `logDeriv_zeta_eq_neg_tsum` |
| Theorem | D4 | **Prime-side explicit formula on a circle in `Re s > 1`** (D4 is proved by T46). | `primeSideCircleFormula_holds` |
| Theorem | T40 | **O3d, the M-test bound:** `Σ_n Λ(n)/n^σ` is summable for `σ > 1`. | `summable_vonMangoldt_div_rpow` |
| Theorem | T41 | **Termwise integration over an interval** for a uniformly dominated series. | `intervalIntegral_tsum` |
| Theorem | T42 | **O3e, termwise integration on a circle:** `∮_{C} Σ' = Σ' ∮_{C}`. | `circleIntegral_tsum` |
| Theorem | T43 | **O3f, the pointwise majorant:** on the circle, `‖H·Λ(n)/n^z‖ ≤ K·Λ(n)/n^(Re c − R)`. | `norm_term_le_circle` |
| Theorem | T44 | Termwise integration with an **interval-local** bound. | `intervalIntegral_tsum_Icc` |
| Theorem | T45 | Termwise integration on a circle with a **sphere-local** bound. | `circleIntegral_tsum_sphere` |
| Theorem | T46 | **D4 proved: the prime-side explicit formula on a circle in `Re s > 1`.** | `primeSideCircleFormula_holds` |
| Theorem | T47 | **Kernel integral vanishes outside the rectangle:** `ρ ∉ rect` implies `∮_{rect}(s−ρ)⁻¹ = 0`. | `boundaryIntegral_inv_sub_of_not_mem` |
| Theorem | T48 | **Circle kernel integral vanishes outside the disc:** `‖ρ−c‖ > R` implies `∮_{C(c,R)}(z−ρ)⁻¹ = 0`. | `circleIntegral_inv_sub_of_gt` |
| Theorem | T58–T68 | **The corner arguments for the unit square:** `arg(1−i) = −π/4`, `arg(1+i) = π/4`, `arg(−1+i) = 3π/4`, `arg(−1−i) = −3π/4`, with the supporting `arcsin` and norm lemmas. | `arg_one_sub_I`, `arg_one_add_I`, `arg_neg_one_add_I`, `arg_neg_one_sub_I` |
| Theorem | T69–T70 | **The bottom side of the unit square:** `∫_{-1}^{1}(x−i)⁻¹dx = iπ/2`, via the chain-rule lemma `hasDerivAt_log_sub` and the fundamental theorem of calculus. | `integral_bottom` |
| Definition | D5 | `logShift z = log(−z) + iπ` — the logarithm with the cut on the positive axis. | `logShift` |
| Theorem | T71–T78 | `logShift` derivatives and the branch values at `±1 ± i`. | `hasDerivAt_logShift` |
| Theorem | T79–T81 | **The top, right and left side integrals** of the unit square: `−iπ/2`, `π/2`, `−π/2`. | `integral_top`, `integral_right`, `integral_left` |
| Theorem | T82 | **The interior kernel integral for the unit square:** `∮_{[−1,1]²} s⁻¹ ds = 2πi`. | `boundaryIntegral_inv_unit_square` |
| Open | O3b | **General rectangles.** The unit-square computation is complete; extending it to an arbitrary rectangle `∏[a,b]×[c,d]` needs either the affine rescaling `s ↦ ρ + h(s − ρ)` (a square) or the slit-plane logarithm for a general aspect ratio. Recorded as the remaining step. | — |
| Theorem | T49 | **O3c: the residue of `H·ζ′/ζ` at a simple zero is `H(ρ)`:** `(s−ρ)·H·ζ′/ζ → H(ρ)`. | `tendsto_residue_mul` |
| Theorem | T50 | **The subtracted function has at most a simple singularity:** `(s−ρ)·(H·ζ′/ζ − H(ρ)/(s−ρ)) → 0`. | `tendsto_subtracted_mul` |
| Theorem | T51–T53 | **`ζ′` is analytic/differentiable/continuous away from `1`** (so `ζ` is `C¹`). | `analyticAt_deriv_zeta` |
| Theorem | T54–T55 | **`ζ″` exists and is continuous away from `1`** (so `ζ` is `C²`). | `continuousAt_deriv2_zeta` |
| Theorem | T56 | `H·ζ′/ζ` is differentiable away from `1` and the zeros. | `differentiableAt_mul_logDeriv` |
| Theorem | T57 | **The subtracted function is `o(1/(s−ρ))`:** `(s−ρ)²·(H·ζ′/ζ − H(ρ)/(s−ρ)) → 0`. | `tendsto_subtracted_mul_sq` |
| Theorem | T85 | **The Taylor series of `ζ` about `ρ ≠ 1` converges to `ζ` near `ρ`**, with coefficients `ζ^{(n)}(ρ)/n!`. | `zeta_taylor_eventually` |
| Theorem | T86 | **The Peano second-order decomposition at a zero:** `ζ(ρ+h) = ζ′(ρ)h + h²·Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n`. | `zeta_peano_second_order` |
| Theorem | T87 | **The tail limit:** `Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n → ζ″(ρ)/2` as `h → 0` (given summability of the majorant). | `tendsto_tail_zeta` |
| Theorem | T88 | `ζ′` has derivative `ζ″` away from `1`. | `hasDerivAt_deriv_zeta` |
| Theorem | T89 | **Summability of the tail majorant** `‖ζ^{(n+2)}(ρ)/(n+2)!‖·s^n`. | `summable_tail_majorant` |
| Theorem | T90 | **The unconditional tail limit** `Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n → ζ″(ρ)/2`. | `tendsto_tail_zeta'` |
| Theorem | T91 | **`ζ(ρ+h)/h → ζ′(ρ)`** at a zero. | `tendsto_zeta_div` |
| Theorem | T92 | The quotient algebra behind the limit. | `div_sub_one_div_eq` |
| Theorem | T93 | **The finite O3c limit:** `ζ′/ζ − 1/(s−ρ) → ζ″(ρ)/(2ζ′(ρ))` at a simple zero. | `tendsto_logDeriv_sub` |
| Theorem | T93 | **The finite limit is now proved:** `ζ′/ζ − 1/(s−ρ) → ζ″(ρ)/(2ζ′(ρ))` at a simple zero, from the Peano expansion (T86), the tail limit (T90), the quotient limit (T91) and the algebra lemma (T92). | `tendsto_logDeriv_sub` |
| Theorem | T94 | **Multiplying by `H`:** for `H` continuous at `ρ`, `H·ζ′/ζ − H/(s−ρ) → H(ρ)·ζ″(ρ)/(2ζ′(ρ))`. | `tendsto_subtracted_H` |
| Correction | — | **T34/T36/D3 (circle residue theorem) cannot be applied at a zero of `f` as stated.** In Lean, `g ρ = H ρ · logDeriv f ρ − H ρ/(ρ−ρ)` evaluates to `0` (both divisions are by zero), whereas the true limit is `H(ρ)·ζ″(ρ)/(2ζ′(ρ)) + H′(ρ)`. Hence `ContinuousOn g (closedBall c R)` fails at every zero. The residue theorem must be applied to the **extended** function `G z = if z = ρ then L else g z`, which differs from `g` only at `ρ` (a null set), so the circle integrals agree. | — |
| Theorem | T95 | **The preimage of a point under `circleMap c R` is countable** (`R ≠ 0`), via `Complex.exp_eq_exp_iff_exists_int`. | `circleMap_preimage_countable` |
| Theorem | T96 | **Changing a function at one point does not change its circle integral** — the a.e. transfer `∮ g = ∮ G`. | `circleIntegral_congr_off_singleton` |
| Theorem | T97 | **The limit of the `H(ρ)`-subtracted integrand:** `H·ζ′/ζ − H(ρ)/(s−ρ) → H(ρ)·ζ″(ρ)/(2ζ′(ρ)) + H′(ρ)`. | `tendsto_subtracted_Hρ` |
| Theorem | T98 | **The residue theorem at a simple zero, on the circle centred at the zero:** `∮_{C(ρ,r)} H·ζ′/ζ = 2πi·H(ρ)`, assuming `H` continuous at `ρ` and differentiable on the punctured closed disc, the disc avoiding `1` and all other zeros. | `circleIntegral_logDeriv_centred` |
| Theorem | T99 | **Changing a function on a finite set does not change its circle integral** (generalises T96). | `circleIntegral_congr_off_finset` |
| Theorem | T100 | **The limit of the finitely-subtracted integrand at a zero:** `H·ζ′/ζ − Σ_{ρ'∈F} H(ρ')/(z−ρ') → H(ρ)·ζ″(ρ)/(2ζ′(ρ)) + H′(ρ) − Σ_{ρ'∈F.erase ρ} H(ρ')/(ρ−ρ')`. | `tendsto_subtracted_finset` |
| Theorem | T101 | **The finite-sum residue theorem applied to the extended integrand:** if `G` agrees with `H·ζ′/ζ − Σ_{ρ∈F} H(ρ)/(z−ρ)` off `F` and is continuous on the closed disc and holomorphic off `F`, then `∮_{C(c,R)} H·ζ′/ζ = 2πi Σ_{ρ∈F} H(ρ)`. | `circleIntegral_residue_sum_ext` |
| Theorem | T102 | **Continuity of the piecewise extension at the update point:** a punctured limit plus the value gives `ContinuousWithinAt` of `if z = ρ then L z else g z`. | `continuousWithinAt_update` |
| Theorem | T103–T104 | **Regularity of finite sums of simple poles** off the poles: continuity and differentiability by induction on the `Finset`. | `continuousAt_finset_sum_pole`, `differentiableAt_finset_sum_pole` |
| Theorem | T105 | **The multi-zero residue theorem (unconditional):** for a finite set `F` containing every zero of `ζ` in the closed disc (simple, and the disc avoiding `1`), and `H` differentiable on the closed disc, `∮_{C(c,R)} H·ζ′/ζ = 2πi Σ_{ρ∈F} H(ρ)`. | `circleIntegral_logDeriv_zeros` |

## Theta programme

A self-contained re-derivation of the functional equation from the Jacobi theta
series `θ(t) = Σ'_{n : ℤ} exp(−π n² t)`, in
[`../zeta-from-theta/lean/Theta.lean`](../zeta-from-theta/lean/Theta.lean),
`Mellin.lean` and `Zeta.lean` (namespace `ZetaTheta`; imported here through
`ThetaLayer.lean`).

| Item | Statement | Lean |
|---|---|---|
| V1 | Summability of `θ(t)` for `t > 0`. | `summable_theta` |
| V2 | Positivity of `θ`. | `theta_pos` |
| V3 | **The theta functional equation:** `θ(1/t) = √t · θ(t)` (from Mathlib's Poisson summation). | `theta_one_div` |
| V4 | `θ(t) = 1 + 2 Σ_{n≥1} exp(−π n² t)`. | `theta_eq_one_add_two_tsum` |
| V5 | The kernel `ψ(t) = (θ(t)−1)/2` as a series. | `psi`, `psi_eq_tsum` |
| V6 | **Mellin transform of the kernel:** `Σ_{n≥1} Γ(s/2)/(π n²)^{s/2} = ∫_0^∞ t^{s/2−1}ψ(t)dt` (`HasSum`). | `summable_pi_mul_sq_rpow`, `hasSum_mellin_psi` |
| V7 | Dirichlet-series form, `ζ` as a `ℕ+`-series, `mellin ψ(s/2) = π^{−s/2}Γ(s/2)ζ(s)`. | `cpow_sq_half`, `hasSum_mellin_psi_dirichlet`, `hasSum_pnat_one_div_cpow`, `mellin_psi_eq` |
| **V8** | **The Mellin representation:** `Λ(s) = ∫_0^∞ t^{s/2−1}ψ(t)dt` for `Re s > 1`. | `mellin_psi_eq_completed` |
| V9 | Kernel functional equation: `ψ(1/t) = √t·ψ(t) + (√t−1)/2`. | `psi_one_div` |
| V10 | Tail integral: `∫_1^∞ t^{−a−1}dt = 1/a` for `Re a > 0`. | `integral_Ioi_cpow_neg_sub_one` |
| V11 | Change of variables `t ↦ 1/t`: `∫_{(0,1)} = ∫_{(1,∞)} ψ(1/u)u^{−s/2−1}du`. | `image_inv_Ioi_one`, `inv_cpow_eq`, `integral_Ioc_psi_eq` |
| V12–V13 | Positivity of the theta tail and of `ψ`. | `tsum_theta_pos`, `psi_pos` |
| V14–V16 | Geometric comparison and **exponential decay** `‖ψ(t)‖ ≤ e^{−πt}/(1−e^{−πt})`. | `tsum_theta_le_geometric`, `tsum_geometric_pnat`, `norm_psi_le` |
| V17–V19 | Measurability, decay on `[1,∞)`, **integrability on `(1,∞)`**. | `measurable_psi`, `norm_psi_le_Ioi`, `integrableOn_psi_cpow_Ioi` |
| V20–V22 | Near-zero bound `‖ψ(t)‖ ≤ …/√t`, `t^a` integrable on `(0,1)`, **integrability on `(0,1)`**. | `norm_psi_le_inv_sqrt`, `integrableOn_rpow_Ioo`, `integrableOn_psi_cpow_Ioo` |
| **V23** | **Split of the Mellin integral** at `t = 1`. | `mellin_psi_split` |
| V24–V26 | Pointwise V9 evaluation, **integrability for every exponent**, the `(1,∞)` evaluation. | `psi_one_div_mul_cpow`, `integrableOn_psi_cpow_Ioi'`, `integral_Ioi_psi_one_div` |
| **V27** | **Symmetric integral form:** `Λ(s) = ∫_{(1,∞)}ψ(t)(t^{s/2−1}+t^{(1−s)/2−1})dt + 1/(s−1) − 1/s` for `Re s > 1`. | `completedRiemannZeta_eq_symmetric_integral` |
| **V28** | The symmetric expression `Λ̃` and its invariance `Λ̃(1−s) = Λ̃(s)`. | `LambdaTilde`, `LambdaTilde_one_sub` |
| V29–V31 | Summand derivative, log-domination, and the `(1,∞)` integral as a Mellin transform. | `hasDerivAt_cpow_affine`, `integrableOn_log_mul_rpow_mul_exp`, `mellin_indicator_Ioi_psi` |
| V32–V34 | `isBigO` facts at `atTop` and at `0` for the indicator `g = 1_{(1,∞)}·ψ`, and its local integrability on `(0,∞)` — the three hypotheses of Mathlib's Mellin differentiability theorem. | `isBigO_indicator_psi_top`, `isBigO_indicator_psi_zero`, `locallyIntegrableOn_indicator_psi` |
| V35–V37 | `mellin g` is differentiable everywhere (Mathlib's `mellin_differentiableAt_of_isBigO_rpow_exp`); `Λ̃ = mellin g(s/2) + mellin g((1−s)/2) + 1/(s−1) − 1/s`; hence **`Λ̃` is differentiable off `{0,1}`**. | `differentiableAt_mellin_indicator`, `LambdaTilde_eq_mellin`, `differentiableAt_LambdaTilde` |
| **V38** | **`Λ = Λ̃` everywhere** (identity theorem on the preconnected `ℂ ∖ {0,1}`). | `completedRiemannZeta_eq_LambdaTilde_all` |
| **V39** | **The functional equation `Λ(1−s) = Λ(s)`, proved from theta** (for `s ∉ {0,1}`). | `completedRiemannZeta_one_sub_theta` |
| **V40** | **The classical form** `ζ(1−s) = 2(2π)^{−s}Γ(s)cos(πs/2)ζ(s)` for `s ∉ {1, 0, −1, −2, …}`, from V39 and Mathlib's `Gammaℝ_div_Gammaℝ_one_sub` (the degenerate cases `s = 1+2n` are handled by trivial zeros and `cos(πs/2) = 0`). | `riemannZeta_one_sub_theta`, `riemannZeta_one_sub_theta'` |

### Status: complete

The theta-based derivation of the functional equation is **complete**:

* (A) `θ` is defined in-repo, summable and positive for `t > 0` (V1, V2, V12–V13);
* (B) the theta functional equation `θ(1/t) = √t·θ(t)` is proved from Mathlib's
  Poisson summation (V3);
* (C) the Mellin representation `Λ(s) = ∫_0^∞ (θ(t)−1)/2 · t^{s/2−1} dt` is proved for
  `Re s > 1` (V8), both halves are shown integrable (V19, V22), the integral is split
  at `1` (V23), and the continuation `Λ = Λ̃` holds on all of `ℂ ∖ {0,1}` via the
  identity theorem (V38), `Λ̃` being analytic there (V37);
* (D) `Λ(1−s) = Λ(s)` for `s ∉ {0,1}` is proved from theta (V39), and the classical
  form `ζ(1−s) = 2(2π)^{−s}Γ(s)cos(πs/2)ζ(s)` follows (V40).

Nothing here re-exports Mathlib's `riemannZeta_one_sub`; the only Mathlib inputs are
Poisson summation, the Mellin transform library, `Gammaℝ_div_Gammaℝ_one_sub` (used
for the final un-completing), and the standard differentiability of `Λ`.

## Computations

| Kind | Item | Statement | Test |
|---|---|---|---|
| Computation | C1 | `Λ(1 − s) = Λ(s)` numerically (25 digits). | `test_functional_equation_residual_small` |
| Computation | C2 | `Λ(2) = π/6`. | `test_completed_zeta_value_at_two` |
| Computation | C3 | The first nontrivial zero lies on `Re s = 1/2`. | `test_critical_line_zeros_are_zeros` |
| Computation | C4 | `ζ′/ζ` is finite at `1/2 + 3i`. | `test_log_deriv_finite_on_critical_line` |
| Computation | C5 | `ζ(−2n) = 0` for `n = 1, 2, 3`. | `test_trivial_zeros_vanish` |

## What this does and does not give

The analytic prerequisites for O3 are now proved: the continuation (T8/T9),
`ζ′/ζ` on the critical line away from zeros (T14/T15), the classification of the
left half-plane zeros (T26), the residue `1` at a simple zero (T27), the
residue decomposition `ζ′/ζ = Σ 1/(s−ρ) + g′/g` (T28/T29), and the fact that
the prime sum at `Re s = 1/2` is **not** absolutely convergent (T30), so no
termwise integration of the Dirichlet series can work there.

**The prime side of the explicit formula is now proved on circles in the
half-plane of convergence** (T39–T46): `ζ′/ζ = −Σ′ Λ(n)/n^s` on `Re s > 1`, the
M-test domination, termwise integration on intervals and circles (with local
bounds), and the resulting
`∮_{C(c,R)} H·ζ′/ζ = −Σ′_n Λ(n)·∮_{C(c,R)} H/n^s` for `Re c − R > 1`.

**The circle case of O3's residue theorem is now proved** (T34–T36, D3): on a
circle, the residue theorem for `H·f′/f` at a single simple pole follows from
Mathlib's off-countable circle Cauchy theorem and its Cauchy kernel integral
`∮(z−ρ)⁻¹ = 2πi`.  The rectangle statement (D1/D2, T33) is formalised but not
proved: two ingredients are missing — O3b, a Cauchy/homology theorem for the
rectangle with small discs removed, and O3c, the removable-singularity
continuity of `H·ζ′/ζ − H(ρ)/(s−ρ)` at a simple zero of `ζ`.  Both are
library-level gaps, not gaps specific to this project.  Nothing here asserts the Riemann
hypothesis, the simplicity of all zeros, or any location of the nontrivial
zeros beyond the functional-equation symmetries.

## Reproduce

```bash
cd topics/zeta-functional-equation/lean && ./check.sh FunctionalEquation.lean
cd topics/zeta-functional-equation && python3 -m pytest -q tests
```
