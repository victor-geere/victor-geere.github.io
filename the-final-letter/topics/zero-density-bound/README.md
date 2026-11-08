# The W4 zero-density entrywise bound — research programme

**Status:** initiated; the conditional 2×2 obstruction and the exact 2×2
PSD criterion are Lean-checked, the zero-density estimate supplying `B` is
**open**.
**Part of:** [weil-positivity](../weil-positivity/README.md) · [execution handoff](../weil-positivity/HANDOFF.md) · [O2 handoff](../angular-partition-method/HANDOFF-O2.md) · [topic index](../README.md).

## What the programme is

The off-line obstruction is unconditional for a single quadruple
(`offLineQuad_obstruction_all`).  For a full Gaussian Gram matrix one needs an
entrywise bound `B` on the contribution of all *other* zeros.  Given `B`, the
off-line growth forces the full 2×2 block to be indefinite.  The core proves
this with the exact scalar hypothesis `S(0) − |S(c)| + 2B < 0`, consistent with
the exact block criterion `|S(c)| ≤ S(0)` of the hub.

This programme isolates the missing estimate as a named tail input,
`TailEntryBound`, and proves the reduction from it to the full-block
obstruction.  It also proves the exact scalar criterion for the symmetric
diagonal block: `!![a, b; b, a]` is PSD **iff** `|b| ≤ a`.  That criterion is
what makes the obstruction checkable by a single real inequality.

The consumer is [weil-positivity](../weil-positivity/README.md); the programme order and acceptance criteria are in [its execution handoff](../weil-positivity/HANDOFF.md).

## Ledger

| ID | Kind | Statement | Lean |
|---|---|---|---|
| T1 | Theorem | `TailEntryBound` is the entrywise bound on the tail block. | `TailEntryBound` |
| T2 | Theorem | A tail bound gives `FullBlockWithin` for the total block. | `fullBlockWithin_of_tailBound` |
| T3 | Theorem | Tail bound + off-line domination ⇒ the full 2×2 block is not PSD. | `not_posSemidef_of_tailBound` |
| T4 | Theorem | Unconditional 2×2 obstruction for any `δ ≠ 0`. | `offLineQuad_obstruction_all` (harvested) |
| T5 | Theorem | A tail entry bound is monotone in its bound. | `tailEntryBound_mono` |
| T6 | Theorem | A tail entry bound forces `0 ≤ B`. | `tailEntryBound_nonneg` |
| T7 | Theorem | `TailEntryBound` is exactly `FullBlockWithin` for the total block. | `tailEntryBound_iff_fullBlockWithin` |
| T8 | Theorem | `!![a, b; b, a]` is PSD iff `|b| ≤ a`. | `twoByTwo_diag_posSemidef_iff` |
| T9 | Theorem | `b > a` breaks the symmetric diagonal block. | `twoByTwo_diag_not_posSemidef` |
| T10 | Theorem | The zero count satisfies `N(r) ≤ C r log(r+2) + D` (Riemann–von Mangoldt up to constants). | `zero_count_le_rlog` |
| T11 | Theorem | The tail predicate is equivalent to a single bound on the maximum absolute entry. | `tailEntryBound_iff_max_le` |
| T12 | Theorem | Perturbed 2×2 obstruction with the exact hypothesis `a − |b| + 2B < 0`. | `twoByTwo_perturbed_not_posSemidef_abs` |
| T13 | Theorem | Tail-bound obstruction with `S(0) − |S(c)| + 2B < 0`. | `not_posSemidef_of_tailBound_abs` |
| T14 | Theorem | For every tail bound `B ≥ 0` there is a separation with `S(0) − |S(c)| + 2B < 0`. | `exists_domination_abs` |
| T15 | Theorem | The Gaussian mass of zeros with `|γ n| ≥ R` tends to `0` as `R → ∞`. | `tendsto_gaussian_zero_mass_outside_radius` |
| T16 | Theorem | A termwise bound `‖f n‖ ≤ C w n` gives `‖∑ f‖ ≤ C ∑ w`. | `abs_tsum_le_mul_tsum` |
| T17 | Theorem | Four zero sums with termwise bounds satisfy `TailEntryBound` with `B = C ∑ w`; the entrywise W4 interface. | `tailEntryBound_of_complex_tail` |
| T18 | Theorem | On the critical strip, `‖H_c(z)‖ ≤ C exp(−σ²(Im z)²)` uniformly in `Re z`. | `exists_gaussianZeroTest_bound_strip` |
| T19 | Theorem | The Gaussian zero-side sum `∑ H_c(aₙ)` is summable whenever the Gaussian zero tail is. | `summable_gaussianZeroTest_of_strip` |
| T20 | Theorem | `‖∑ H_c(aₙ)‖ ≤ C ∑ exp(−σ²(Im aₙ)²)`: the Gaussian zero-side sum is bounded by the zero mass. | `norm_gaussianZeroTailEntry_le` |
| T21 | Theorem | The high-zero Gaussian tail satisfies `TailEntryBound` with `B = C ε` for every `ε > 0`, with the height `R` chosen accordingly. | `exists_tailEntryBound_gaussian_high` |
| T22 | Theorem | The full Gaussian zero-side block satisfies `TailEntryBound` with a single finite `B`; the entrywise W4 bound in the Gaussian model. | `exists_tailEntryBound_gaussian_all` |
| T23 | Theorem | A product `H_{c₁}H_{c₂}` has a uniform strip bound `C exp(−2σ²(Im z)²)`. | `exists_gaussianZeroTest_mul_bound_strip` |
| T24 | Theorem | The four product sums `∑ H_{cᵢⱼ,1}(aₙ)H_{cᵢⱼ,2}(aₙ)` satisfy `TailEntryBound` with a finite `B`; the Gram-entry product model. | `exists_tailEntryBound_gaussian_gram_all` |
| T25 | Theorem | The **actual on-line Gram entries** `∑ 2πσ² exp(−σ²γₙ²) cos((a−b)γₙ)` satisfy `TailEntryBound` with `B = 2πσ² ∑ exp(−σ²γₙ²)`. | `exists_tailEntryBound_onLineGram` |
| T26 | Theorem | The actual on-line Gram kernel is symmetric: `K(a,b) = K(b,a)`. | `onLineGramEntry_comm` |
| T27 | Theorem | The actual on-line Gram matrix is symmetric. | `onLineGramMatrix_isSymm` |
| T28 | Theorem | A single-frequency on-line Gram matrix is positive semidefinite. | `onLineGramMatrix_single_posSemidef` |
| T29 | Theorem | A finite weighted sum of single-frequency on-line Gram matrices is positive semidefinite. | `onLineGramMatrix_finset_posSemidef` |
| T30 | Theorem | The on-line Gaussian weights are nonnegative. | `onLineWeight_nonneg` |
| T31 | Theorem | The quadratic form of a finite weighted on-line Gram matrix is nonnegative. | `onLineGramMatrix_finset_quadraticForm_nonneg` |
| T32 | Theorem | A pointwise `tsum` of positive semidefinite matrices is positive semidefinite (given entrywise summability). | `posSemidef_tsum` |
| T33 | Theorem | **The actual on-line Gram matrix is positive semidefinite** (given entrywise summability of the Gaussian-weighted cosine series). | `onLineGramMatrix_posSemidef` |
| T34 | Theorem | **The on-line Gram matrix is PSD** whenever the Gaussian zero-weight series is summable. | `onLineGramMatrix_posSemidef_of_exp_summable` |
| T35 | Theorem | The on-line Gram matrix is PSD under the named `ZeroTailSummable` input. | `onLineGramMatrix_posSemidef_of_zeroTailSummable` |
| T36 | Theorem | The quadratic form of the actual on-line Gram matrix is nonnegative under `ZeroTailSummable`. | `onLineGramMatrix_quadraticForm_nonneg` |
| C1 | Computation | The off-line quadruple is even in `c` and `γ`. | `tests/test_programme.py` |
| C2 | Computation | The finite tail bound is positive and decreases with `σ`. | `tests/test_programme.py` |
| C3 | Computation | The domination gap becomes negative for large separation. | `tests/test_programme.py` |
| C4 | Computation | The tail predicate agrees with `FullBlockWithin`, and the eigenvalue test agrees with the scalar 2×2 criterion. | `tests/test_programme.py` |
| C5 | Computation | The Gaussian zero mass outside radius `R` is nonnegative, decreases with `R`, and vanishes past the largest ordinate. | `tests/test_programme.py` |

## Harvested proofs

| Theorem | Where | Use |
|---|---|---|
| `offLineQuad_obstruction_all` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | unconditional 2×2 obstruction |
| `offLineQuad_domination` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | produces the separation `c` |
| `FullBlockWithin` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | harvested named W4 input |
| `offLineQuad_fullBlock_not_posSemidef_of_within` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | conditional full-block obstruction |
| `zeroSideGramReal_posSemidef` | [`GaussianZeroSide.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__GaussianZeroSide.lean.md) | on-line PSD comparison |
| `xi₀_zero_count_bound` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | linear-growth zero-count input |
| `xi₀_zero_count_bound_of_log_le` | [`Hadamard.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__Hadamard.lean.md) | count from a sphere log-bound |
| `exists_bound_log_norm_xi₀` | [`ZetaStrip.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__ZetaStrip.lean.md) | unconditional `r log r` growth |
| `zero_sum_tail_bound` | [`TailBound.lean`](../index-lean/absolute-polarized-hodge-index-realization__lean__TailBound.lean.md) | finite-rectangle tail bound |

## Open items and plan

1. **Zero-density estimate.**  Bound the sum of the on-line/other zero
   contributions entrywise by a `B` uniform in the height.  In the Gaussian
   model this is now proved: T22 gives a finite `B` for the full block of
   four single sums, and T24 does the same for the **product** sums
   `∑ H_{cᵢⱼ,1}(aₙ)H_{cᵢⱼ,2}(aₙ)`, which is closer to the actual Gram
   entries.  The **actual on-line entries** are also covered: T25 bounds the
   genuine cosine entries `∑ 2πσ² exp(−σ²γₙ²) cos((a−b)γₙ)` by the Gaussian
   zero mass.  T28–T30 add on-line positivity: each
   single-frequency Gram matrix is PSD (T28), so every finite weighted sum is
   PSD (T29) with nonnegative weights (T30).  Since the explicit formula uses
   a finite truncation of the zeros, T29 already supplies the PSD property at
   every finite `N`; the countable `tsum` limit is needed only for the limiting
   statement.  What remains is the off-line/other-zero bookkeeping and the
   full explicit-formula identification.
2. **Counting input.**  Riemann–von Mangoldt or a zero-density theorem to
   make the tail small.
3. **Full-matrix extension.**  Replace the 2×2 block by a full Gaussian Gram
   matrix and prove indefiniteness from the dominant quadruple.
4. **Instantiate** T3 with the estimate from item 1.
5. **Countable on-line PSD — proved.**  T32 proves the pointwise-`tsum`
   PSD criterion, and T33 applies it: the actual on-line Gram matrix is
   positive semidefinite.  T34 discharges the summability hypothesis: it
   suffices that the Gaussian zero-weight series `∑ exp(−σ²γₙ²)` converges,
   which follows from the Gaussian decay and the growth of the ordinates.

## Objects and notation

The objects are the isolated off-line quadruple `{ρ, 1−ρ, conj ρ, 1−conj ρ}`, its closed-form contribution `S(c)`, the full zero-side Gram block `T`, and the tail block contributed by the other zeros.

## Python layer

`python/programme.py` provides `offline_quad`, `tail_entry_bound`, `domination_gap`, `full_block_within`, `gram_weight`, `tail_entry_bound_holds`, `diag_block`, `diag_block_psd_by_eigenvalues`, `diag_block_psd_criterion`, and `online_gram_quadratic_form`.  Run `python3 -m pytest the-final-letter/topics/zero-density-bound/tests -q`.

## Lean layer

`lean/Topic.lean` proves T1–T36 and harvests T4.  It does **not** prove the zero-density estimate supplying `B`, nor the full Gram-matrix extension; those are recorded as open.

## Provenance and source

- [O2 handoff](../angular-partition-method/HANDOFF-O2.md) — the reduction that consumes this programme.
- [`index-lean/index.md`](../index-lean/index.md) — the harvested proof pages.
- [`scraps.html`](../../scraps.html) — the site's claim inventory.
- [`topics/README.md`](../README.md) — all topic folders.

## Build and test

```bash
the-final-letter/topics/zero-density-bound/lean/check.sh
python3 -m pytest the-final-letter/topics/zero-density-bound/tests -q
```
