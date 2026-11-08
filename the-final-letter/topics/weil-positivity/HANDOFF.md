# Handoff — Weil positivity as the hub of O2

> **Updated (2026-11-06).** The
> [missing-bridge](../missing-bridge/README.md) investigation is concluded at
> the non-RH-strength level.  It corrects the bridge reading of this hub and
> redirects the remaining work to the arithmetic side.  The three upstream
> programmes remain as recorded.

**Status:** **O4 proved.**  `FiniteWeilPositivity → RH` is now Lean-proved
(missing-bridge T57), completing the hard direction of the classical Weil
criterion; T20 gives the easy direction, so `RH ↔ FiniteWeilPositivity` is
formalised for the finite zero-side Gram matrix.  RH remains open because
`FiniteWeilPositivity` itself is not proved — it is the arithmetic-side
condition.

**Scope audit (missing-bridge README, “O4 audit”).**  `FiniteWeilPositivity` is
the finite, zero-side, **Gaussian-window** form: it quantifies over all finite
nontrivial-zero sets and real Gaussian families but not over arbitrary test
functions, and it contains no archimedean/prime terms.  T57 is therefore the
hard direction for the Gaussian-restricted criterion, which is a strengthening
of the full implication, not the full arbitrary-test-function statement.  The
real-zero pair `{ρ, 1−ρ}` uses `completedZeta_one_sub` with hypotheses that all
follow from `0 < ρ < 1`; that check is clean.

**Status: active on the arithmetic quadratic-form inequality (user-selected
option 3).**  The arithmetic Weil quadratic form has been decomposed exactly
(missing-bridge T71):

`Q_arith = Q_PNT(c) + Q_PNT(−c) + Q_arch`,

the pole cancelling by `poleTerm_eq_primeMainTerm_add`.  The programme is now to
control the PNT-error quadratic forms and the archimedean form and prove their
sum nonnegative.  This is the classical Weil positivity argument and is
RH-strength; no claim of RH or unconditional positivity is made.  The four
precisely recorded inputs are: zero simplicity/multiplicity, PNT
(`SmoothWindowPNTError`), the archimedean treatment (not pointwise positive:
`Re ψ(1/4) − log π ≈ −5.372`), and the contour limits.

**Arithmetic-side remaining inputs** (missing-bridge README, “Remaining inputs
for the arithmetic side”): (1) zero simplicity `hF_simple`, with a multiplicity
obstruction for the divisor formula; (2) `SmoothWindowPNTError`; (3) the **full
three-term Gaussian Gram positivity** `Q_pole + Q_prime + Q_density ≥ 0`, with
the concrete archimedean kernel `densityTerm c σ = σ² ∫ e^{−σ²t²} cos(ct) Ω(t) dt`
(bridge T86); (4) `HorizontalLogDerivBound` and the
`hbottom`/`htop`/`hright`/`hleft` contour limits.  The archimedean-dominance
condition of T75/T78 is **not** the right final input: `densityTerm 0 σ < 0`,
so archimedean positivity alone fails and the true positivity is a three-term
cancellation.  The mechanical reduction is
complete: T58 (quadratic-form interface), T59–T60 (matrix assembly), T61
(Gaussian rectangle identity), T62–T63 (Hermitian half), T64 (scalar necessary
condition).  Nonnegativity of the arithmetic quadratic form is the remaining
analytic content.  Earlier status: **goal re-oriented to O4.**  The isolated-block implication is
**not** the bridge: `not_offLineBlockPSD_of_offLine` makes the hypothesis
`∀ c σ δ γ, δ ≠ 0 → OffLineBlockPSD c σ δ γ` false, so
`no_offLine_of_all_blocks_psd` is vacuous.  The meaningful statement is
**`FiniteWeilPositivity`** for the full zero-side Gram matrix.  The easy
direction `RH → FiniteWeilPositivity` is proved (missing-bridge T20); the hard
direction `FiniteWeilPositivity → RH` is **O4**, and that is the active target.
Wave 1 infrastructure (infinitude, zero tail, on-line PSD, log-derivative
growth) is in place to support it.
**Hub:** [weil-positivity](README.md) · **O2 dossier:** [angular-partition-method](../angular-partition-method/README.md) · **Formal core:** [absolute-polarized-hodge-index-realization](../absolute-polarized-hodge-index-realization/README.md).

## 0. The honesty constraint

Objective O2 — Weil positivity for the zero side of the Gaussian explicit
formula — is **RH-equivalent**.  Nothing in this handoff closes O2, and no
unconditional positivity is claimed.  The plan orders work on the three
upstream inputs so that the formalisable assembly can be completed first, while
the genuinely analytic inputs are attacked in dependency order.

## 1. The hub and its three inputs

Weil positivity needs three analytic inputs, each now a programme of its own:

| Programme | Input it supplies | Lean interface | Feeds |
|---|---|---|---|
| [zero-infinitude](../zero-infinitude/README.md) | **infinitude alone**; `Denumerable`, ordinate growth and log growth are proved from it | `exists_enumeration_and_zeroTailSummable_of_infinite`, `nontrivialZeros_denumerable_iff_infinite` | zero sum / `ZeroTailSummable` |
| [log-derivative-growth](../log-derivative-growth/README.md) | polynomial `‖(Z'/Z)(x+iy)‖ ≤ M(1+|y|)^k`; measurability proved | `verticalLogDerivIntegrable_of_polynomial_bound'` | vertical side limits |
| [zero-density-bound](../zero-density-bound/README.md) | entrywise tail bound `B` on the other zeros; the `r log r` count is proved | `FullBlockWithin`, `zero_count_le_rlog`, `not_posSemidef_of_tailBound` | off-line full-block obstruction |

The hub itself proves:

- `weilPositivity` — finite critical-line PSD (harvested, unconditional);
- `not_offLineBlockPSD_of_offLine` — an off-line zero breaks the isolated
  block (harvested obstruction);
- `no_offLine_of_all_blocks_psd` — **universal block positivity ⇒ RH**, but
  this is **vacuous as a bridge**: its antecedent is refuted by
  `not_offLineBlockPSD_of_offLine` (see §5b).

## 2. Order of execution

### Wave 1 — parallel foundations

1. **zero-infinitude** (critical path).  Prove infinitude.  Everything else is
   proved: infinitude gives `[Denumerable]` (T6 of the programme), the
   enumeration (T7), and `ZeroTailSummable` (T5, T8).  Ordinate growth is
   derived from inverse-square summability (T4) and the linear log-growth
   hypothesis is replaced by the unconditional `exists_bound_log_norm_xi₀`.
2. **log-derivative-growth** (parallel).  Prove the upper bound on `Z'`
   (Stirling/Cauchy), the lower bound on `Z` (zero-free region or Jensen),
   assemble a polynomial bound.  This is independent of zero-infinitude.  The
   core now proves that any polynomial bound `‖Z'/Z‖ ≤ M(1+|y|)^k` suffices, so
   no linear refinement is needed, and it proves the measurability of `Z'/Z`
   and of the vertical product.

*Why parallel:* the two programmes share no hypotheses.  The first is
zero-set bookkeeping; the second is one-variable complex analysis.

### Wave 2 — the tail estimate

3. **zero-density-bound**.  This needs the enumeration and the zero-counting
   order from Wave 1 (the tail is indexed by the zeros), so it starts after
   zero-infinitude has produced the enumeration.  Supply the entrywise bound
   `B`, then invoke `not_posSemidef_of_tailBound`.

*Critical path:* zero-infinitude → zero-density-bound → off-line full-block
obstruction.

### Wave 3 — assembly in the hub

4. **Contour assembly.**  Combine `ZeroTailSummable` (Wave 1) with
   `VerticalLogDerivIntegrable` (Wave 1, parallel) to pass to the limit in the
   explicit formula.  This is the `weil-positivity` assembly step.
5. **Off-line obstruction.**  Combine the assembled explicit formula with
   `FullBlockWithin` (Wave 2) to obtain the full-block non-PSD statement.
6. **Positivity statement.**  Package the finite on-line PSD theorem
   (`weilPositivity`) with the obstruction into the named O2 statement.
   Unconditional closure still requires the analytic inputs; do not mark O2
   closed before then.

**Correction from missing-bridge.**  Passing to the limit in the explicit
formula gives the **identity**, not a sign.  The `ZeroTailSummable` +
`VerticalLogDerivIntegrable` + `FullBlockWithin` assembly is an identity plus a
zero-side domination step; it is not by itself a positivity proof.  The
arithmetic side (pole + prime + archimedean) is the classical route;
missing-bridge reduces its Gram entry to `K = PNT errors + arch` and leaves a
uniform PNT-error + archimedean bound as the open input.  The `FullBlockWithin`
route needs a strict maximal-`|δ|` zero, which is not known.

## 3. Mutual reliance

| Topic | Responsibility | Must link back |
|---|---|---|
| [weil-positivity](README.md) | hub, Lean interface, execution plan | O2 dossier and formal core |
| [angular-partition-method](../angular-partition-method/README.md) | O2 dossier, status row, ledger, this handoff's acceptance | hub and formal core |
| [absolute-polarized-hodge-index-realization](../absolute-polarized-hodge-index-realization/README.md) | hosts `GaussianZeroSide.lean`, `ZeroTail.lean`, the harvested proofs | hub and O2 dossier |

The three upstream programmes link to the hub as their consumer.  The hub
links to the O2 dossier for status and to the formal core for proofs.  The O2
dossier and the formal core link back to the hub so a reader can find the
execution plan from either side.

## 4. Acceptance criteria

A programme is **done** when:

- its Lean core builds with no `sorry`/`axiom`/`admit`;
- its Python tests pass and cover every Computation row;
- its README and `index.html` carry the same ledger and the harvested-proof
  table;
- the handoff status below is updated, and the O2 row in
  `angular-partition-method` reflects the new state.

The hub is **assembled** when `ZeroTailSummable`, `VerticalLogDerivIntegrable`
and `FullBlockWithin` are all available and the assembly theorem is
Lean-checked.  It is **not closed** until the three inputs are unconditional
and the full Gram-matrix extension is proved.

## 5. Status board

| Item | State | Next action |
|---|---|---|
| **programme** | **goal re-oriented to O4** — the isolated-block route is vacuous; `FiniteWeilPositivity → RH` is the target, with `RH → FiniteWeilPositivity` proved (missing-bridge T20); the arithmetic-side algebra and first estimates remain supporting work | show an off-line zero makes a finite zero-side Gram block non-PSD (single-zero growth + 2×2 criterion) |
| zero-infinitude | **done** — the finite-zero machinery, the strip property and the final contradiction are proved; `infinite_nontrivialZeros` (T42) and the unconditional zero tail (T43) are proved | none for the zero-set side |
| log-derivative-growth | **done** — both lines `2` and `−1` unconditional | none for the vertical input |
| zero-density-bound | **on-line PSD proved** (T28–T35); tail algebra and 2×2 criterion proved; **finite-tail capstone proved** in weil-positivity (T19–T39): one off-line quadruple plus any finite on-line tail fails PSD, and the infinite Gaussian tail also cannot rescue it | T45 instantiates the explicit formula; T47–T48 give the bottom/top Gaussian decay and uniform bound; `HorizontalLogDerivBound` (T49) names the horizontal `logDeriv` growth input; remaining: prove that bound, the left/right limits, and the arithmetic `SmoothWindowPNTError` + archimedean evaluation |
| weil-positivity hub | **O4 proved** — `RH ↔ FiniteWeilPositivity` is formalised (missing-bridge T20 + T57); the isolated-block implication is vacuous and retired | prove `FiniteWeilPositivity` itself (arithmetic side, RH-equivalent) |
| O2 (angular partition method) | Partial — advanced | keep the O2 row current; do not claim closure |

## 5a. Progress recorded in this revision

| Programme | New theorems | Effect |
|---|---|---|
| zero-infinitude | `...`, `xi₀_zero_re_pos`, `xi₀_zero_re_lt_one`, `exists_finiteZeroProduct_norm_ge_one`, `infinite_nontrivialZeros`, `exists_enumeration_and_zeroTailSummable` | infinitude of the nontrivial zeros is proved (T42) and the zero tail is unconditional (T43); `ZeroTailSummable` is monotone in the width, and the zeros are unbounded in ordinate |
| log-derivative-growth | `integrable_abs_pow_mul_exp_neg_mul_sq`, `integrable_one_add_abs_pow_mul_exp_neg_sq`, `verticalLogDerivIntegrable_of_polynomial_bound`, `verticalLogDerivIntegrable_of_linear_bound'`, `measurable_logDeriv_completedZeta`, `aestronglyMeasurable_logDeriv_mul_gaussian`, `verticalLogDerivIntegrable_of_polynomial_bound'`, `verticalLogDerivIntegrable_of_linear_bound''`, `norm_logDeriv_le_of_sphere_bound`, `norm_logDeriv_completedZeta_le_of_sphere`, `verticalLogDerivIntegrable_of_exp_bound`, `verticalLogDerivIntegrable_of_exp_bound'`, `exists_circle_growth_completedZeta_right`, `verticalLogDerivIntegrable_of_right_growth_lower`, `exists_positive_verticalLogDerivIntegrable_of_right_lower`, `exists_zeta_lower_bound_right`, `verticalLogDerivIntegrable_left_of_right`, `GammaRLowerBound`, `exists_verticalLogDerivIntegrable_right_of_gammaR_lower`, `Gamma_lower_reflection`, `gammaR_lower_bound` | the Gamma lower bound is **proved** (`gammaR_lower_bound`), so both vertical lines are unconditional; T22 closes the right line and T21 transfers to the left |
| zero-density-bound | `tailEntryBound_mono`, `tailEntryBound_nonneg`, `tailEntryBound_iff_fullBlockWithin`, `twoByTwo_diag_posSemidef_iff`, `twoByTwo_diag_not_posSemidef`, `tailEntryBound_iff_max_le`, `twoByTwo_perturbed_not_posSemidef_abs`, `not_posSemidef_of_tailBound_abs`, `exists_domination_abs`, `zero_count_le_rlog`, `tendsto_gaussian_zero_mass_outside_radius`, `abs_tsum_le_mul_tsum`, `tailEntryBound_of_complex_tail`, `exists_gaussianZeroTest_bound_strip`, `summable_gaussianZeroTest_of_strip`, `norm_gaussianZeroTailEntry_le`, `exists_tailEntryBound_gaussian_high`, `exists_tailEntryBound_gaussian_all`, `exists_gaussianZeroTest_mul_bound_strip`, `exists_tailEntryBound_gaussian_gram_all`, `exists_tailEntryBound_onLineGram`, `posSemidef_tsum`, `onLineGramMatrix_posSemidef`, `onLineGramMatrix_posSemidef_of_exp_summable`, `onLineGramMatrix_posSemidef_of_zeroTailSummable`, `onLineGramMatrix_single_posSemidef`, `onLineGramMatrix_finset_posSemidef`, `onLineGramMatrix_finset_quadraticForm_nonneg`, `onLineWeight_nonneg` | tail predicate algebra and normal form, exact 2×2 criterion, the `S(0) − |S(c)| + 2B < 0` obstruction available for every `B`, the Riemann–von Mangoldt-type count, the vanishing height tail, the entrywise total-mass interface, the Gaussian zero-side summability/mass bound, the high-zero `C ε` bound, the finite-`B` single-sum block, the product-sum Gram model, and the finite-`B` **actual on-line** Gram entries |
| weil-positivity hub | `twoByTwo_diag_posSemidef_iff`, `offLineBlockPSD_iff`, `not_offLineBlockPSD_of_abs_lt`, `not_offLineBlockPSD_iff`, `exists_abs_offLineQuad_gt_of_offLine`, `all_blocks_psd_iff_scalar`, `no_offLine_of_all_abs_le`, `exists_abs_offLineQuad_gt_of_not_RH`, `exists_abs_offLineQuad_gt_any`, `offLineBlockPSD_iff_abs_le`, `exists_offLineBlock_not_psd`, `not_posSemidef_add_of_abs_gt`, `exists_offLineBlock_add_tail_not_psd`, `abs_gaussianTailEntry_le`, `exists_offLineBlock_add_modelTail_not_psd`, `gaussianTailBound_nonneg`, `gaussianTailBound_mono`, `abs_sum_mul_cos_le`, `abs_tsum_mul_cos_le`, `actualGaussianTailEntry`, `abs_actualGaussianTailEntry_le`, `actualTail`, `exists_offLineBlock_add_actualTail_not_psd`, `not_posSemidef_fullBlock_of_margin`, `not_posSemidef_of_eq_fullBlock`, `zeroSideSum`, `zeroSideSum_eq_isolated_add_tail`, `offLineQuadruple`, `zeroSideSumM`, `zeroSideSumM_add`, `zeroSideSumM_offLineQuadruple`, `zeroSideBlockM`, `zeroSideBlockM_add`, `zeroSideBlockM_offLineQuadruple`, `exists_multiset_fullBlock_not_psd`, `gaussianZeroTest_onLine_re`, `gaussianZeroTest_onLine_im`, `onLineOrds`, `zeroSideSumM_onLineOrds`, `abs_zeroSideBlockM_onLineOrds_le`, `exists_onLineMultiset_fullBlock_not_psd`, `norm_gaussianZeroTest_onLine`, `summable_gaussianZeroTest_onLine`, `tendsto_sum_gaussianZeroTest_onLine`, `tendsto_image_range_gaussianZeroTest`, `tendsto_sum_image_range_sub`, `tsum_norm_gaussianZeroTest_onLine`, `explicit_formula_gaussianZeroTest_of_enumeration`, `bottomLine_sq`, `norm_gaussianZeroTest_bottom`, `norm_gaussianZeroTest_bottom_le`, `HorizontalLogDerivBound`, `tendsto_abs_pow_mul_exp_neg_sq`, `tendsto_one_add_abs_pow_mul_exp_neg_sq`, `tendsto_bottom_integral_zero`, `topLine_sq`, `norm_gaussianZeroTest_top`, `norm_gaussianZeroTest_top_le`, `HorizontalLogDerivBoundTop`, `tendsto_top_integral_zero`, `explicit_formula_gaussianZeroTest_of_enumeration` | the obstruction is the scalar inequality `S(0) < |S(c)|`, its failure is exactly ¬RH, and `|S(c)|` is unbounded |

Consequences for the ordering above:

- Wave 1, item 1 no longer needs a separate ordinate-growth or log-growth step.
  Only infinitude remains.
- Wave 1, item 2 is now **unconditional on the right line**: the Gamma lower
  bound is proved, and `exists_verticalLogDerivIntegrable_right` gives a width
  `σ` with `VerticalLogDerivIntegrable` on `Re s = 21/10`; T31–T32 transfer it
  to `Re s = −11/10`.  The argument was repeated at `Re s = 2` (T33–T35) and
  transferred to `−1` (T36), so **both vertical sides are proved on the
  library contour `(−1, 2)`**.
- Wave 2 is unchanged: the entrywise bound `B` is still the schedule risk.
- Wave 3 steps 5–6 now have a scalar target.  They are still conditional and
  do **not** close O2.

## 5b. Missing-bridge findings (2026-11-06)

| Finding | Consequence for this handoff |
|---|---|
| `no_offLine_of_all_blocks_psd` has a refutable antecedent (`not_offLineBlockPSD_of_offLine`) | the isolated-block implication is vacuous; the non-vacuous easy direction is `rh_implies_finiteWeilPositivity` (missing-bridge T20) |
| `no_uniform_bound_of_offLine_quadruple`: an off-line quadruple in the "other" block defeats every uniform bound | the `FullBlockWithin` route needs a strict maximal-distance zero; not known (T17) |
| `K(c) = [P_main − P](c) + [P_main − P](−c) + arch(c)` | the pole cancels exactly; the arithmetic side is the PNT error plus the archimedean term (C15).  The exact identity `pole = P_main(c) + P_main(−c)`, the residual form, and their identification with `Re H_c(0)`, `Re H_c(1)`, `Re (H_c(0)+H_c(1))` and `K = PNT errors + arch` are Lean-proved in missing-bridge (T21–T26) |
| The Gaussian prime side is a sum of nonnegative terms in the Gaussian window | the window, the truncated prime side, its nonnegativity and its monotonicity are Lean-proved (T27–T30), together with the window symmetry, positivity of the main/pole terms, the evenness of the pole, and the Gaussian-integral evaluation `∫ e^{u/2} h_c = P_main` (T31–T37) |
| The PNT-error Gram and archimedean Gram are individually indefinite but jointly positive; the gap collapses under refinement | the remaining analytic input is a uniform joint PNT + archimedean bound, not a termwise prime estimate (C16–C17) |
| The APM does not retire the tail bound | `ZeroTailSummable`/`FullBlockWithin` remain zero-side inputs, not substitutes for the arithmetic side |

## 6. Risks and blockers

- **Infinitude is proved** (`infinite_nontrivialZeros`, T42) and the tail
  enumeration is unconditional (T43); the remaining zero-set risk is the
  off-line/other-zero bookkeeping and the countable on-line `tsum` PSD.
- **Stirling/zero-free estimates** are the largest analysis block; they are
  independent of the zero-set work and can proceed in parallel.
- **Zero-density** is downstream of the enumeration and is the schedule risk.
- **RH-equivalence** means any claim of unconditional O2 closure is a claim of
  RH; review every status update against that constraint.
- **Vacuous isolated-block bridge.**  The antecedent of
  `no_offLine_of_all_blocks_psd` is refutable; do not present it as the
  `Weil positivity ⇒ RH` direction.
- **Maximal-`|δ|` precondition.**  The full-block route needs a strict
  maximal-`|δ|` zero; no such zero is known unconditionally.  The condition is
  a named object `MaximalDistanceZero` in zero-infinitude; T45 proves RH
  implies it, and T47 proves the on-line-witness form is **equivalent to RH**.
  It therefore cannot be assumed as an independent input without circularity.
- **Arithmetic side.**  The classical route reduces to a uniform PNT-error +
  archimedean bound; the finite-family gap collapses (missing-bridge C17).

[Back to the hub](README.md) · [O2 dossier](../angular-partition-method/README.md) · [Topic index](../README.md)
