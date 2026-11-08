# Weil positivity — research programme

**Status:** **updated in the light of the [missing-bridge](../missing-bridge/README.md)
investigation.**  The finite on-line positivity and the exact isolated-block
criterion are Lean-checked.  The isolated-block `blocks ⇒ RH` implication is
**vacuous as a bridge** (its antecedent is refutable by
`not_offLineBlockPSD_of_offLine`), and the full-block route has an unproven
maximal-`|δ|` precondition.  The classical route is the arithmetic side, now
reduced in missing-bridge to the exact identity `K = PNT errors + arch`.
**Unconditional Weil positivity is open and RH-equivalent.**  **O4 is now
proved:** the hard direction `FiniteWeilPositivity → RH` is missing-bridge T57,
and the easy direction `RH → FiniteWeilPositivity` is T20, so
`RH ↔ FiniteWeilPositivity` is formalised.  RH is not claimed: the remaining
input is `FiniteWeilPositivity` itself (the arithmetic side).
**Part of:** [O2 handoff](../angular-partition-method/HANDOFF-O2.md) ·
[execution plan](HANDOFF.md) · [topic index](../README.md).

## What the programme is

Weil positivity (objective O2) is the statement that the zero-side Gram
matrices of the Gaussian test family are positive semidefinite.  It is the
hub of the three upstream programmes:

- [zero-infinitude](../zero-infinitude/README.md) supplies an enumeration and
  the Gaussian zero tail.  Its ordinate-growth and log-growth inputs are now
  discharged; `ZeroTailSummable` follows from infinitude alone.
- [log-derivative-growth](../log-derivative-growth/README.md) supplies the
  `Z'/Z` growth bound; its Gaussian upper half is proved, measurability is
  proved, and any polynomial or sub-Gaussian `exp(A y²)` bound suffices for
  `VerticalLogDerivIntegrable`.  Only the Gamma lower bound remains.
- [zero-density-bound](../zero-density-bound/README.md) supplies the entrywise
  tail bound `B`, hence the off-line full-block obstruction; its count, exact
  obstruction and height-tail estimates are proved.

The assembly plan, the order of execution and the acceptance criteria are in
[`HANDOFF.md`](HANDOFF.md).  The formal core in this folder proves the finite
critical-line positivity (harvested) and the **`Weil positivity ⇒ RH`
direction** for the isolated off-line 2×2 blocks.  The isolated block is
`[[S(0), S(c)], [S(c), S(0)]]`, and the core proves the exact scalar criterion

`OffLineBlockPSD c σ δ γ ↔ |S(c)| ≤ S(0)`.

The obstruction therefore reads: an off-line zero forces some separation `c`
with `|S(c)| > S(0)`.  The converse assembly is not claimed.

**Correction from missing-bridge.**  This isolated-block implication is not the
bridge.  `not_offLineBlockPSD_of_offLine` proves that every off-line quadruple
has a separation with a non-PSD block, so the antecedent
`∀ c σ δ γ, δ ≠ 0 → OffLineBlockPSD c σ δ γ` is false and
`no_offLine_of_all_blocks_psd` is vacuously true.  The meaningful objects are
the full Gram matrix and `FiniteWeilPositivity`; the easy direction
`RH → FiniteWeilPositivity` is proved in missing-bridge (T20), and the hard
direction is O4.

## Objects and notation

| Object | Definition |
|---|---|
| `ξ₀` | Hadamard's entire form of the completed zeta |
| `Z` | the completed zeta |
| `H_c` | the Gaussian test family |
| Zero-side Gram matrix | `G_{ij} = Σ_ρ H_c(ρ_i) conj(H_c(ρ_j))` over the zeros |
| `WeilPositivity` | every finite critical-line family gives a PSD Gram matrix |
| `OffLineBlock c σ δ γ` | `[[S(0), S(c)], [S(c), S(0)]]` for the isolated quadruple |
| `RiemannHypothesis` (RH) | every zero in the critical strip has `Re ρ = 1/2` |

## Ledger

| ID | Kind | Statement | Lean |
|---|---|---|---|
| T1 | Theorem | `WeilPositivity` names the finite critical-line positivity statement. | `WeilPositivity` |
| T2 | Theorem | Every finite critical-line family has a PSD Gram matrix. | `weilPositivity` (harvested) |
| T3 | Theorem | An off-line zero produces a separation whose isolated block is not PSD. | `not_offLineBlockPSD_of_offLine` |
| T4 | Theorem | If every isolated off-line block were PSD, RH would hold. | `no_offLine_of_all_blocks_psd` |
| T5 | Theorem | `!![a, b; b, a]` is PSD iff `|b| ≤ a`. | `twoByTwo_diag_posSemidef_iff` |
| T6 | Theorem | The isolated block is PSD iff `|S(c)| ≤ S(0)`. | `offLineBlockPSD_iff` |
| T7 | Theorem | `S(0) < |S(c)|` breaks the isolated block. | `not_offLineBlockPSD_of_abs_lt` |
| T8 | Theorem | Block failure is exactly `S(0) < |S(c)|`. | `not_offLineBlockPSD_iff` |
| T9 | Theorem | An off-line zero forces some `c` with `S(0) < |S(c)|`. | `exists_abs_offLineQuad_gt_of_offLine` |
| T10 | Theorem | Universal block positivity is equivalent to the scalar inequality for every `c, σ, δ, γ`. | `all_blocks_psd_iff_scalar` |
| T11 | Theorem | The scalar bound `|S(c)| ≤ S(0)` for all parameters implies RH. | `no_offLine_of_all_abs_le` |
| T12 | Theorem | Failure of RH produces `c, σ, δ, γ` with `δ ≠ 0` and `S(0) < |S(c)|`. | `exists_abs_offLineQuad_gt_of_not_RH` |
| T13 | Theorem | The off-line contribution is unbounded in modulus: for every `K` some `c` has `K < |S(c)|`. | `exists_abs_offLineQuad_gt_any` |
| T14 | Theorem | The isolated off-line block is even in the separation `c`. | `offLineBlock_neg` |
| T15 | Theorem | `OffLineBlockPSD` is even in the separation `c`. | `offLineBlockPSD_neg` |
| T16 | Theorem | The isolated off-line block is a symmetric matrix. | `offLineBlock_isSymm` |
| T17 | Theorem | The isolated off-line block is PSD iff `|Re S(c)| ≤ Re S(0)`. | `offLineBlockPSD_iff_abs_le` |
| T18 | Theorem | For `σ > 0` and `δ ≠ 0`, some separation makes the isolated off-line block fail PSD. | `exists_offLineBlock_not_psd` |
| T19 | Theorem | If `a + 4B < |b|`, adding any tail with entries bounded by `B` leaves `!![a,b;b,a]` non-PSD. | `not_posSemidef_add_of_abs_gt` |
| T20 | Theorem | A bounded tail cannot rescue an off-line block: some `c` makes `OffLineBlock c σ δ γ + E` non-PSD. | `exists_offLineBlock_add_tail_not_psd` |
| T21 | Theorem | The finite Gaussian tail entries are bounded by the total Gaussian tail mass. | `abs_gaussianTailEntry_le` |
| T22 | Theorem | A finite Gaussian model tail cannot rescue an off-line block. | `exists_offLineBlock_add_modelTail_not_psd` |
| T23 | Theorem | The Gaussian model tail mass is nonnegative. | `gaussianTailBound_nonneg` |
| T24 | Theorem | The Gaussian model tail mass is monotone in the zero set. | `gaussianTailBound_mono` |
| T25 | Theorem | A finite weighted cosine sum is bounded by the total weight. | `abs_sum_mul_cos_le` |
| T26 | Theorem | A summable weighted cosine series is bounded by the total weight. | `abs_tsum_mul_cos_le` |
| T27 | Theorem | The actual Gaussian tail entry is bounded by the total Gaussian mass. | `actualGaussianTailEntry`, `abs_actualGaussianTailEntry_le` |
| T28 | Theorem | The actual Gaussian tail block cannot rescue an off-line block. | `actualTail`, `exists_offLineBlock_add_actualTail_not_psd` |
| T29 | Theorem | Explicit margin: if the off-line obstruction exceeds `B = 2πσ²∑exp` by the T19 margin, the full block is not PSD. | `not_posSemidef_fullBlock_of_margin` |
| T30 | Theorem | Decomposition interface: any block equal to `OffLineBlock + actualTail` fails PSD for some separation. | `fullBlock`, `not_posSemidef_of_eq_fullBlock` |
| T31 | Theorem | Finite decomposition of the zero-side sum into an isolated part and its complement. | `zeroSideSum`, `zeroSideSum_eq_isolated_add_tail` |
| T32 | Theorem | The multiset zero-side sum of the off-line quadruple is exactly `offLineQuad`, and it splits additively. | `offLineQuadruple`, `zeroSideSumM`, `zeroSideSumM_add`, `zeroSideSumM_offLineQuadruple` |
| T33 | Theorem | The 2×2 block of a multiset zero-side sum splits additively, and the quadruple block is exactly `OffLineBlock`. | `zeroSideBlockM`, `zeroSideBlockM_add`, `zeroSideBlockM_offLineQuadruple` |
| T34 | Theorem | If the remaining-zero block is uniformly bounded by `B`, the decomposed multiset full block fails PSD. | `exists_multiset_fullBlock_not_psd` |
| T35 | Theorem | On the critical line, `Re gaussianZeroTest c σ (1/2+iγ) = 2πσ² e^{−σ²γ²} cos(cγ)`. | `gaussianZeroTest_onLine_re` |
| T36 | Theorem | On the critical line, `Im gaussianZeroTest c σ (1/2+iγ) = −2πσ² e^{−σ²γ²} sin(cγ)`. | `gaussianZeroTest_onLine_im` |
| T37 | Theorem | The on-line ordinate multiset sum has real part equal to the finite Gaussian cosine sum. | `onLineOrds`, `zeroSideSumM_onLineOrds` |
| T38 | Theorem | The on-line multiset tail block is entrywise bounded by the finite Gaussian tail mass. | `abs_zeroSideBlockM_onLineOrds_le` |
| T39 | Theorem | **A finite on-line tail plus one off-line quadruple fails PSD.** | `exists_onLineMultiset_fullBlock_not_psd` |
| T40 | Theorem | On the critical line, `‖gaussianZeroTest c σ (1/2+iγ)‖ = 2πσ² e^{−σ²γ²}`. | `norm_gaussianZeroTest_onLine` |
| T41 | Theorem | The on-line `gaussianZeroTest` sequence is summable under `ZeroTailSummable`. | `summable_gaussianZeroTest_onLine` |
| T42 | Theorem | The partial sums of the on-line `gaussianZeroTest` converge to the `tsum` (the `hsum` ingredient). | `tendsto_sum_gaussianZeroTest_onLine` |
| T43 | Theorem | The image of the first `⌊T⌋₊` ordinates converges to the zero-side `tsum`, with or without the pole terms. | `tendsto_image_range_gaussianZeroTest`, `tendsto_sum_image_range_sub` |
| T44 | Theorem | The total on-line norm mass is `2πσ²` times the Gaussian zero mass. | `tsum_norm_gaussianZeroTest_onLine` |
| T45 | Theorem | **Gaussian explicit formula from the zero enumeration**: the zero-side `tsum` identity, conditional on the contour/limit data. | `explicit_formula_gaussianZeroTest_of_enumeration` |
| T46 | Theorem | Bottom-line square identity `((x−iT)−1/2)² = ((x−1/2)²−T²) + (−2(x−1/2)T)i`. | `bottomLine_sq` |
| T47 | Theorem | **Bottom-line Gaussian norm**: `‖gaussianZeroTest c σ (x−iT)‖ = 2πσ² e^{σ²((x−1/2)²−T²)} e^{−c(x−1/2)}`. | `norm_gaussianZeroTest_bottom` |
| T48 | Theorem | Uniform bottom-line bound on `x ∈ [−1,2]`: `≤ 2πσ² e^{σ²(25/4−T²)} e^{(3/2)|c|}`. | `norm_gaussianZeroTest_bottom_le` |
| T49 | Theorem | Named horizontal-line `logDeriv` growth input and its application. | `HorizontalLogDerivBound`, `horizontalLogDerivBound_apply` |
| T50 | Theorem | Polynomial times Gaussian decay: `|T|^k e^{−σ²T²} → 0`. | `tendsto_abs_pow_mul_exp_neg_sq` |
| T51 | Theorem | `(1+|T|)^k e^{−σ²T²} → 0`. | `tendsto_one_add_abs_pow_mul_exp_neg_sq` |
| T52 | Theorem | **The bottom contour integral vanishes** under `HorizontalLogDerivBound`. | `tendsto_bottom_integral_zero` |
| T53 | Theorem | Top-line square identity `((x+iT)−1/2)² = ((x−1/2)²−T²) + (2(x−1/2)T)i`. | `topLine_sq` |
| T54 | Theorem | **Top-line Gaussian norm** equals the bottom-line norm formula. | `norm_gaussianZeroTest_top` |
| T55 | Theorem | Uniform top-line bound on `x ∈ [−1,2]`: `≤ 2πσ² e^{σ²(25/4−T²)} e^{(3/2)|c|}`. | `norm_gaussianZeroTest_top_le` |
| T56 | Theorem | **The top contour integral vanishes** under `HorizontalLogDerivBoundTop`. | `tendsto_top_integral_zero` |
| C1 | Computation | The on-line block (`δ = 0`) is PSD. | `tests/test_programme.py`; also Lean-proved for the actual on-line Gram matrix in [zero-density-bound](../zero-density-bound/README.md) (T28–T35) |
| C2 | Computation | An off-line block eventually fails PSD. | `tests/test_programme.py` |
| C3 | Computation | `S(c)` is even in `c` and the block is symmetric. | `tests/test_programme.py` |
| C4 | Computation | The scalar criterion `|S(c)| ≤ S(0)` agrees with the block PSD test, and the obstruction margin is negative exactly at a failure. | `tests/test_programme.py` |

## Harvested proofs

From [`index-lean/index.md`](../index-lean/index.md) and the topic pages:

| Theorem | Where | Use |
|---|---|---|
| `zeroSideWeilPositivity` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | finite on-line PSD |
| `offLineQuad_obstruction_all` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | isolated off-line obstruction |
| `offLineQuad_domination` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | produces the separation |
| `FullBlockWithin` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | W4 tail input |
| `zeroSideGramReal_posSemidef` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | real on-line Gram PSD |

The on-line PSD side is now also proved locally in
[zero-density-bound](../zero-density-bound/README.md): T28 (single
frequency), T29 (finite weighted sums), T32 (pointwise `tsum` criterion),
T33 (actual on-line Gram matrix) and T34 (from Gaussian summability).  The
remaining W4 input is the off-line/other-zero bookkeeping.
| `zeroTailSummable_of_nontrivial_xi₀_enumeration` | [`ZeroTail.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZeroTail.lean.md) | zero-tail input |
| `verticalLogDerivIntegrable_of_linear_bound` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | vertical-side input |
| `exists_nontrivial_xi₀_enumeration` | [`ZeroTail.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZeroTail.lean.md) | enumeration input |

## Python layer

`python/programme.py` provides `perturbed_block_psd`, `offline_quad`, `offline_block`,
`is_psd_2x2`, `eigenvalues_2x2`, `find_obstruction`, `obstruction_margin`, and
`block_psd_criterion`.

```bash
python3 -m pytest the-final-letter/topics/weil-positivity/tests -q
```

## Lean layer

`lean/Topic.lean` proves T1–T16 and harvests T2.  It does **not** prove
unconditional Weil positivity, the assembly from the three upstream
programmes, or the full Gram-matrix extension of the off-line obstruction.
T4, T10 and T11 are true but the "bridge" reading is vacuous as noted above;
the non-vacuous easy direction lives in
[`missing-bridge`](../missing-bridge/README.md) (T20).  Those are the open
items in [`HANDOFF.md`](HANDOFF.md).

## Corrections and dependencies from missing-bridge

The [missing-bridge](../missing-bridge/README.md) investigation changes the
reading of this hub in four places.

- **The isolated-block bridge is vacuous.**  `no_offLine_of_all_blocks_psd`
  has the antecedent `∀ c σ δ γ, δ ≠ 0 → OffLineBlockPSD c σ δ γ`, which is
  refuted by `not_offLineBlockPSD_of_offLine`.  The theorem is true but it is
  `False → RH`; it is not the `Weil positivity ⇒ RH` direction in any
  non-vacuous sense.
- **The full statement is `FiniteWeilPositivity`.**  The hub's
  `WeilPositivity` is the on-line kernel identity for arbitrary real
  frequencies; the classical object is the full zero-side Gram matrix.
  Missing-bridge proves `rh_implies_finiteWeilPositivity` (the easy direction)
  and leaves the hard direction `FiniteWeilPositivity → RH` as O4.
- **The full-block route needs a strict maximal-`|δ|` zero.**
  `no_uniform_bound_of_offLine_quadruple` shows that an off-line quadruple in
  the "other" block defeats every uniform bound; the domination argument
  therefore requires the chosen quadruple to have strictly larger `|δ|` than
  every other zero.  No such zero is known.
- **The arithmetic side is the classical route.**  Missing-bridge reduces the
  arithmetic Gram entry to
  `K(c) = [P_main − P](c) + [P_main − P](−c) + arch(c)`: the pole cancels
  exactly, and the PNT error and archimedean term are individually indefinite
  but jointly positive (C15–C17).  The APM does not retire the tail bound.
  The remaining analytic input is a uniform PNT-error + archimedean bound.

**What should change here.**  The ledger rows T1–T13 remain true as formal
statements, but the hub should not present the isolated-block implication as
the bridge.  The bridge is O4 (the classical Weil criterion) on the arithmetic
side; the zero-side domination route is not viable as stated.

## Open items and known gaps

1. **Unconditional Weil positivity.**  RH-equivalent; no unconditional proof
   is claimed.
2. **Assembly.**  Combine `ZeroTailSummable`, `VerticalLogDerivIntegrable` and
   `FullBlockWithin` into the full zero-side positivity statement.  The inputs
   are now sharply reduced: `ZeroTailSummable` follows from infinitude alone
   ([zero-infinitude](../zero-infinitude/README.md)); `VerticalLogDerivIntegrable`
   follows from a sub-Gaussian `Z'/Z` bound plus the Gamma lower bound, with
   the upper half and measurability proved
   ([log-derivative-growth](../log-derivative-growth/README.md)); the
   zero-density entrywise reduction is the remaining step
   ([zero-density-bound](../zero-density-bound/README.md)).
3. **Full Gram matrix and the hard direction.**  The finite easy direction is
   proved in missing-bridge (`rh_implies_finiteWeilPositivity`); the hard
   direction `FiniteWeilPositivity → RH` is O4 and is RH-strength.
4. **Maximal-`|δ|` precondition.**  The full-block domination route requires a
   strict maximal-`|δ|` zero; no such zero is known
   ([missing-bridge](../missing-bridge/README.md), T17).
5. **Arithmetic side.**  The classical route is the explicit formula evaluated
   on pole + prime + archimedean terms; missing-bridge has the exact identity
   and the cancellation, and the open input is a uniform PNT-error +
   archimedean bound.  This is the recommended route.
6. **Mutual reliance.**  The O2 dossier
   ([`angular-partition-method`](../angular-partition-method/README.md)) owns
   the status and ledger; the Lean core lives in
   [`absolute-polarized-hodge-index-realization`](../absolute-polarized-hodge-index-realization/README.md).
   Keep both links current when this programme moves.

## Provenance and source

- [O2 handoff](../angular-partition-method/HANDOFF-O2.md) — the underlying
  reduction.
- [Execution handoff](HANDOFF.md) — the plan that orders the three upstream
  programmes.
- [`absolute-polarized-hodge-index-realization`](../absolute-polarized-hodge-index-realization/README.md)
  — the formal core this topic imports.
- [`angular-partition-method`](../angular-partition-method/README.md) — the
  O2 dossier and ledger.
- [`index-lean/index.md`](../index-lean/index.md) — the harvested proof pages.
- [`scraps.html`](../../scraps.html) — the site's claim inventory.
- [`topics/README.md`](../README.md) — all topic folders.

## Build and test

```bash
the-final-letter/topics/weil-positivity/lean/check.sh
python3 -m pytest the-final-letter/topics/weil-positivity/tests -q
```
