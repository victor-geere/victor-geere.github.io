# Lean layer — zeta-functional-equation

`FunctionalEquation.lean` (namespace `ZetaFunctionalEquation`) is imported by
the thin `Topic.lean`; the file name is unique so other topics can
`import FunctionalEquation` without the duplicate-`Topic` clash.

The theta-layer files `Theta.lean`, `Mellin.lean` and `Zeta.lean` — and the
V-ledger documentation below — **moved** to
[`../../zeta-from-theta/lean`](../../zeta-from-theta/lean) in HANDOFF M0.  They
are imported here through `ThetaLayer.lean` (in the same directory on
`LEAN_EXTRA_PATH`), so the V-ledger is kept here for continuity; the canonical
home is the sibling topic.

## Re-exported from Mathlib

T1–T3 (functional equations for `Λ`, `Λ₀`, `ζ`), T6–T8 (entirety of `Λ₀`,
differentiability of `Λ` and of `ζ`), T10 (no zeros for `Re s > 1`), T11
(`ζ = Λ/Gammaℝ`), T16–T21 (special values, trivial zeros, residue).

## Proved here

* T4/T5 — zero symmetry `Λ(s) = 0 ↔ Λ(1 − s) = 0`, from T1;
* T9 — `analyticAt_zeta`, via
  `Complex.analyticAt_iff_eventually_differentiableAt` and the neighbourhood
  `{1}ᶜ`;
* T12 — `Gammaℝ s ≠ 0` for `s ∉ {−2n}`, from `Complex.cpow_ne_zero_iff` and
  `Complex.Gamma_ne_zero`;
* T13 — the zero correspondence between `ζ` and `Λ`, from T11/T12;
* T14/T15 — **`ζ′/ζ` is analytic/differentiable away from `1` and the zeros**:
  `AnalyticAt.deriv` on `analyticAt_zeta`, then `AnalyticAt.div` with the
  nonvanishing hypothesis.

* T22–T25 — the zero symmetries: `riemannZeta_conj` gives conjugation
  symmetry; the functional equation (T3) gives closure under `s ↦ 1 − s`; and
  combining them gives the fourfold symmetry of the nontrivial zeros.

* T26 — the left half-plane zeros: `Gammaℝ` vanishes exactly at the negative
  even integers (`Gammaℝ_eq_zero_iff`), and `Λ(1−s) = Λ(s) ≠ 0` for
  `Re s < 0`, so `ζ(s) = 0` there exactly at `s = −2m`, `m ≥ 1`;
* T27 — the residue at a simple zero, via `HasDerivAt.tendsto_slope` and the
  continuity of `deriv ζ`; simplicity is a hypothesis, never asserted;
* T28/T29 — `logDeriv_prod` on `∏ (z − ρ)` and the resulting residue
  decomposition `ζ′/ζ = Σ 1/(s−ρ) + g′/g`.

* T30 — `not_summable_vonMangoldt_div_sqrt`: the prime sum at `Re s = 1/2`
  diverges, by comparison on primes with `not_summable_one_div_on_primes` and
  `vonMangoldt_apply_prime`.

* T31/T32 — `boundaryIntegral` and the two rectangle Cauchy identities it
  re-expresses (`differentiableOn`, and `off_countable`);
* `stripZeros`, `RectangleResidueTheorem`, `ContourShiftStatement` — **O3a is a
  Lean statement**, not only prose: the rectangle residue theorem for
  `H·ζ′/ζ` and the concrete contour shift on `[1/2, 2] × [−T, T]`;
* T33 — `verticalDifference_eq_of_boundary`: the residue theorem implies the
  vertical-integral difference equals the residue sum minus the horizontal
  terms (proved by `abel`).

* T34 — `circleIntegral_residue`: the residue theorem on a circle at a single
  simple pole, via
  `circleIntegral_eq_zero_of_differentiable_on_off_countable` and
  `circleIntegral_sub_inv_smul_of_differentiable_on_off_countable` (the Cauchy
  kernel `∮(z−ρ)⁻¹ = 2πi`);
* D3/T35/T36 — `CircleResidueTheorem` as a `Prop`, the theorem that it holds,
  and its instance at a simple zero of `ζ`.

* T37 — `circleIntegral_residue_sum`: the finite-sum circle residue theorem,
  by induction over the `Finset` using `continuousOn_finsetSum` and
  `circleIntegral.integral_add`; T38 — `circleIntegral_inv_sub`, the kernel
  integral `∮(z−ρ)⁻¹ = 2πi`.

* T39 — `logDeriv_zeta_eq_neg_tsum`: on `Re s > 1`,
  `ζ′/ζ = −Σ' Λ(n)/n^s`, from
  `ArithmeticFunction.LSeries_vonMangoldt_eq_deriv_riemannZeta_div` and
  `LSeries_def₀`;
* T40 — `summable_vonMangoldt_div_rpow`: the M-test bound `Σ Λ(n)/n^σ < ∞` for
  `σ > 1`, by comparison with `LSeriesSummable_vonMangoldt`;
* T41/T42 — `intervalIntegral_tsum` and `circleIntegral_tsum`: termwise
  integration of a uniformly dominated series over an interval and over a
  circle (dominated convergence on the partial sums, with the interval
  converted to `volume.restrict (Ioc a b)`);
* T43 — `norm_term_le_circle`: the pointwise majorant on the circle,
  `‖H·Λ(n)/n^z‖ ≤ K·Λ(n)/n^(Re c − R)`, using
  `Complex.norm_natCast_cpow_of_pos` and
  `Real.rpow_le_rpow_of_exponent_le`;
* T44/T45 — `intervalIntegral_tsum_Icc` and `circleIntegral_tsum_sphere`: the
  termwise-integration theorems with **local** bounds (interval-local in `θ`,
  sphere-local in `z`), needed because `H` is only bounded on the circle;
* T46 — `primeSideCircleFormula_holds`: **the prime-side explicit formula on a
  circle in `Re s > 1`**, by combining T39, T43, T45 and the constant-pull-out
  identity;
* D4 — `PrimeSideCircleFormula`, now a theorem (T46): the prime-side explicit formula on a circle in
  `Re s > 1`, stated as a `Prop` (proof reduced to O3d/O3e).

* T47/T48 — `boundaryIntegral_inv_sub_of_not_mem`,
  `circleIntegral_inv_sub_of_gt`: the kernel integral `(s−ρ)⁻¹` vanishes when
  `ρ` is outside the rectangle / disc, from the off-countable Cauchy identities
  T32 and the circle version.

* T49/T50 — `tendsto_residue_mul`, `tendsto_subtracted_mul`: the residue of
  `H·ζ′/ζ` at a simple zero is `H(ρ)`, and the subtracted function
  `H·ζ′/ζ − H(ρ)/(s−ρ)` has at most a simple singularity (its `(s−ρ)`-multiple
  tends to `0`).

* T51–T55 — `analyticAt_deriv_zeta`, `differentiableAt_deriv_zeta`,
  `continuousAt_deriv_zeta`, `differentiableAt_deriv2_zeta`,
  `continuousAt_deriv2_zeta`: the `C²` regularity of `ζ` away from `1`, from
  `AnalyticAt.deriv`.

* T56/T57 — `differentiableAt_mul_logDeriv` (the integrand is holomorphic off
  the zeros) and `tendsto_subtracted_mul_sq` (the subtracted function is
  `o(1/(s−ρ))`).

* T58–T68 — the corner arguments `arg(1−i) = −π/4`, `arg(1+i) = π/4`,
  `arg(−1+i) = 3π/4`, `arg(−1−i) = −3π/4`, via `Complex.arg_of_re_nonneg`,
  `arg_of_re_neg_of_im_nonneg`, `arg_of_re_neg_of_im_neg` and `Real.arcsin`
  injectivity, with norm computations `‖1 ± i‖ = ‖−1 ± i‖ = √2`.

* T69/T70 — `hasDerivAt_log_sub` (chain rule for `x ↦ log (x − ρ)` over ℝ,
  via `HasFDerivAt.restrictScalars` and `comp_hasDerivAt`) and `integral_bottom`
  (`∫_{-1}^{1}(x−i)⁻¹dx = iπ/2`) via
  `intervalIntegral.integral_eq_sub_of_hasDerivAt`.

* D5/T71–T82 — `logShift z = log(−z) + iπ` with derivative `z⁻¹` and the branch
  values at `±1 ± i`; the top, right and left side integrals of the unit square
  (`integral_top`, `integral_right`, `integral_left`); and
  `boundaryIntegral_inv_unit_square`: **the interior kernel integral
  `∮ s⁻¹ = 2πi` on `[−1,1]²`**.

* T85 — `zeta_taylor_eventually`: `AnalyticAt.hasFPowerSeriesAt` plus
  `HasFPowerSeriesAt.eventually_hasSum_sub` give the Taylor series of `ζ` about
  `ρ ≠ 1`, with coefficients `ζ^{(n)}(ρ)/n!` (`FormalMultilinearSeries.ofScalars`).

* T86 — `zeta_peano_second_order`: `ζ(ρ+h) = ζ′(ρ)h + h²·Σ_n
  ζ^{(n+2)}(ρ)/(n+2)!·h^n` near `h = 0`, by splitting the Taylor series
  (`hasSum_nat_add_iff'`) and pulling out `h²` (`tsum_mul_left`).

* T87 — `tendsto_tail_zeta`: `Σ_n ζ^{(n+2)}(ρ)/(n+2)!·h^n → ζ″(ρ)/2` as `h → 0`,
  by `tendsto_tsum_of_dominated_convergence` with the geometric majorant.
  The summability of the majorant (from
  `FormalMultilinearSeries.summable_norm_mul_pow`) is the remaining input.

* T88 — `hasDerivAt_deriv_zeta`: `HasDerivAt (deriv ζ) (deriv (deriv ζ) ρ) ρ` away
  from `1`, from `DifferentiableAt.hasDerivAt` and T54.

* T89/T90 — `summable_tail_majorant` (summability of `‖ζ^{(n+2)}(ρ)/(n+2)!‖·s^n`,
  from `FormalMultilinearSeries.summable_norm_apply`) and `tendsto_tail_zeta'`
  (the unconditional tail limit `→ ζ″(ρ)/2`).

* T91 — `tendsto_zeta_div`: `ζ(ρ+h)/h → ζ′(ρ)` at a zero, by dividing the
  Peano decomposition by `h` and using T90.

* T92/T93 — `div_sub_one_div_eq` (the quotient algebra) and
  `tendsto_logDeriv_sub`: **the finite O3c limit**
  `ζ′/ζ − 1/(s−ρ) → ζ″(ρ)/(2ζ′(ρ))` at a simple zero, from the Peano expansion,
  the tail limit, `ζ(ρ+h)/h → ζ′(ρ)` and `Tendsto.div`.

* T94 — `tendsto_subtracted_H`: the subtracted integrand
  `H·ζ′/ζ − H/(s−ρ)` has the finite limit `H(ρ)·ζ″(ρ)/(2ζ′(ρ))` for continuous
  `H`, by composing T93 with `s ↦ s − ρ` and multiplying.

* T95/T96 — `circleMap_preimage_countable` (the preimage of a point under
  `circleMap c R` is countable for `R ≠ 0`) and
  `circleIntegral_congr_off_singleton` (changing a function at one point does not
  change its circle integral). These repair the T34/D3 hypothesis.

* T97 — `tendsto_subtracted_Hρ`: the limit
  `H·ζ′/ζ − H(ρ)/(s−ρ) → H(ρ)·ζ″(ρ)/(2ζ′(ρ)) + H′(ρ)` at a simple zero (T94 plus
  the slope of `H`), the value needed for the extended integrand.

* T98 — `circleIntegral_logDeriv_centred`: **the residue theorem at a simple
  zero on the circle centred at the zero**, `∮_{C(ρ,r)} H·ζ′/ζ = 2πi·H(ρ)`, from
  Mathlib's removable-singularity Cauchy formula applied to
  `f z = (z−ρ)·H z·ζ′z/ζz`.

* T99 — `circleIntegral_congr_off_finset`: changing a function on a finite set
  does not change its circle integral (the finite-set analogue of T96, needed for
  the multi-zero extension).

* T100 — `tendsto_subtracted_finset`: the limit of
  `H·ζ′/ζ − Σ_{ρ'∈F} H(ρ')/(z−ρ')` at `ρ ∈ F`, the value of the extended integrand
  for the multi-zero residue theorem (T97 plus continuity of the other terms).

* T101 — `circleIntegral_residue_sum_ext`: the finite-sum residue theorem for
  the *extended* integrand, `∮_{C(c,R)} H·ζ′/ζ = 2πi Σ_{ρ∈F} H(ρ)`, proved by the
  Cauchy theorem on `G` and the finite-set transfer T99.

* T102 — `continuousWithinAt_update`: a punctured limit plus the assigned value
  makes `if z = ρ then L z else g z` continuous within any set at `ρ`. The
  decomposition `𝓝 ρ = 𝓝[≠] ρ ⊔ pure ρ` + `Tendsto.sup`, and `if_true` for the
  value.

* T103/T104 — continuity and differentiability of a finite sum of simple poles
  off the poles (by `Finset.induction_on`), replacing the missing
  `continuousAt_finsetSum`-style lemmas.
* T105 — `circleIntegral_logDeriv_zeros`: **the unconditional multi-zero residue
  theorem**, built on T100 (limit values), T102 (continuity at the update),
  T103/T104 (regularity off the zeros) and T101.

## Theta.lean (moved to `zeta-from-theta/lean`; namespace `ZetaTheta`)

* V1 `summable_theta` — summability of `θ(t) = Σ'_{n:ℤ} exp(−π n² t)` for `t > 0`
  (comparison with a geometric series over ℤ via
  `summable_int_iff_summable_nat_and_neg`).
* V2 `theta_pos` — positivity (`Summable.tsum_pos`).
* V3 `theta_one_div` — the theta functional equation `θ(1/t) = √t · θ(t)`, from
  `Real.tsum_exp_neg_mul_int_sq`.
* V4 `theta_eq_one_add_two_tsum` — the ℤ-series split at `n = 0`
  (`tsum_int_eq_zero_add_two_mul_tsum_pnat`).
* V5 `psi`/`psi_eq_tsum` — the theta kernel `ψ(t) = (θ(t)−1)/2` as a `ℂ`-valued
  series over `ℕ+`, the input to the Mellin transform.

## Mellin.lean (moved; namespace `ZetaTheta`, continued)

* V6a `summable_pi_mul_sq_rpow` — summability of `Σ 1/(π n²)^{σ/2}` for `σ > 1`
  (`Real.summable_one_div_nat_rpow` plus `Real.rpow` algebra).
* V6 `hasSum_mellin_psi` — **the Mellin transform of the theta kernel**:
  `HasSum (fun n : ℕ+ => Γ(s/2)/(π n²)^{s/2}) (mellin ψ (s/2))` for `Re s > 1`,
  from Mathlib's generic `hasSum_mellin`.

## Zeta.lean (moved; namespace `ZetaTheta`, continued)

* V7a `cpow_sq_half` — `((n:ℝ)² : ℂ)^{s/2} = ((n:ℝ):ℂ)^s`, via `Complex.cpow_def_of_ne_zero`
  and `Real.log_pow`.
* V7b `hasSum_mellin_psi_dirichlet` — the Dirichlet-series form
  `HasSum (fun n : ℕ+ => π^{−s/2}Γ(s/2)/n^s) (mellin ψ (s/2))`, from
  `hasSum_mellin_pi_mul`.

* V7c `hasSum_pnat_one_div_cpow` — `ζ(s)` as a series over `ℕ+`
  (`tsum_pnat_eq_tsum_succ`, `Summable.tsum_eq_zero_add`).
* V7d `mellin_psi_eq` — `mellin ψ(s/2) = π^{−s/2}Γ(s/2)ζ(s)` by uniqueness of sums.
* **V8 `mellin_psi_eq_completed`** — **the Mellin representation**
  `Λ(s) = ∫_0^∞ t^{s/2−1}ψ(t)dt` for `Re s > 1`.

* V9 `psi_one_div` — `ψ(1/t) = √t·ψ(t) + (√t−1)/2`, the theta functional
  equation in kernel form.
* V10 `integral_Ioi_cpow_neg_sub_one` — `∫_1^∞ t^{−a−1}dt = 1/a` for `Re a > 0`
  (`integral_Ioi_cpow_of_lt`).

* V11a `image_inv_Ioi_one`, V11b `inv_cpow_eq` — the image of `(1,∞)` under
  `t ↦ 1/t` and the cpow identity `((1/u):ℂ)^a = u^{-a}`.
* **V11 `integral_Ioc_psi_eq`** — the change of variables
  `∫_{(0,1)}ψ(t)t^{s/2-1}dt = ∫_{(1,∞)}ψ(1/u)u^{-s/2-1}du`, via
  `MeasureTheory.integral_image_eq_integral_abs_deriv_smul`.

* V12 `tsum_theta_pos`, V13 `psi_pos` — positivity of the theta tail and of the
  kernel `ψ` (for `t > 0`), the input to the integrability estimates needed for
  the split of the Mellin integral.

* V14–V16 `tsum_theta_le_geometric`, `tsum_geometric_pnat`, `norm_psi_le` — the
  geometric comparison, the geometric tail sum, and **the exponential decay
  bound `‖ψ(t)‖ ≤ e^{−πt}/(1−e^{−πt})`**, the input to integrability on `(1,∞)`.

* V17–V19 `measurable_psi`, `norm_psi_le_Ioi`, `integrableOn_psi_cpow_Ioi` — the
  measurability of `θ`/`ψ`, the decay bound on `[1,∞)`, and **integrability of
  `ψ(t)t^{s/2−1}` on `(1,∞)`** (comparison with `t^{Re c}e^{−πt}` via
  `integrableOn_rpow_mul_exp_neg_mul_rpow` and `Integrable.mono'`).

* V20–V22 `norm_psi_le_inv_sqrt`, `integrableOn_rpow_Ioo`,
  `integrableOn_psi_cpow_Ioo` — the near-zero bound `‖ψ(t)‖ ≤ …/√t`, integrability
  of `t^a` on `(0,1)`, and **integrability of `ψ(t)t^{s/2−1}` on `(0,1)`**.  Both
  pieces of the Mellin integral are now integrable.

* V23 `mellin_psi_split` — the split
  `mellin ψ(s/2) = ∫_{(0,1)}ψ(t)t^{s/2−1}dt + ∫_{(1,∞)}ψ(t)t^{s/2−1}dt`, via
  `setIntegral_union` on `(0,1) ∪ [1,∞)`, with explicit `∂volume` annotations to
  make the terms match.

* V24 `psi_one_div_mul_cpow` — the pointwise identity
  `ψ(1/u)u^{−s/2−1} = ψ(u)u^{(1−s)/2−1} + ½(u^{(1−s)/2−1} − u^{−s/2−1})`, obtained
  from V9, the cpow identity `√u·u^{−s/2−1} = u^{(1−s)/2−1}` (`Complex.cpow_add`)
  and `Complex.ofReal_cpow`.

* V25 `integrableOn_psi_cpow_Ioi'` — `ψ(t)t^c` is integrable on `(1,∞)` for every
  exponent `c : ℂ` (two cases: `Re c > −1` by rpow-exponential comparison,
  `Re c ≤ −1` by the boundedness of `t^{Re c}` on `(1,∞)`).

* V26 `integral_Ioi_psi_one_div` — the `(1,∞)` evaluation, from V24 + V10
  (`integral_Ioi_cpow_neg_sub_one`) via `integral_add`, `integral_const_mul` and
  `integral_sub`.

* V27/V28 `completedRiemannZeta_eq_symmetric_integral`, `LambdaTilde`,
  `LambdaTilde_one_sub` — the symmetric integral form of `Λ` (valid for `Re s > 1`)
  and the invariance `Λ̃(1−s) = Λ̃(s)` of the expression.

* V29 `hasDerivAt_cpow_affine` — `HasDerivAt (fun s => t^{cs+d}) (t^{cs+d}·c·log t) s`,
  the building block for differentiating `Λ̃` under the integral sign
  (`HasDerivAt.cpow` with the slit-plane membership of `t > 0`).

* V30 `integrableOn_log_mul_rpow_mul_exp` — `t ↦ log t · t^a · e^{−πt}` is
  integrable on `(1,∞)` (`Real.log_le_rpow_div` with a small `ε`), the domination
  bound for differentiating `Λ̃` under the integral sign.

* V32–V34 `isBigO_indicator_psi_top`, `isBigO_indicator_psi_zero`,
  `locallyIntegrableOn_indicator_psi` — the three hypotheses of
  `mellin_differentiableAt_of_isBigO_rpow_exp` for `g = 1_{(1,∞)}·ψ`.

* V35–V37 `differentiableAt_mellin_indicator`, `LambdaTilde_eq_mellin`,
  `differentiableAt_LambdaTilde` — `mellin g` is entire, `Λ̃` is expressed through it,
  and `Λ̃` is differentiable (hence analytic) off `{0,1}`.

* **V38–V40** `completedRiemannZeta_eq_LambdaTilde_all`,
  `completedRiemannZeta_one_sub_theta`, `riemannZeta_one_sub_theta` — **the identity
  theorem, the functional equation `Λ(1−s) = Λ(s)` proved from theta, and its
  classical `ζ` form** (the last under `Gammaℝ (1−s) ≠ 0`).

## Notes

`logDeriv` is `deriv f / f`; the rewrite to `AnalyticAt` of the division is by
`funext` and `logDeriv_apply`, since `logDeriv` is not reducible by `simp`
inside the `AnalyticAt` argument.
