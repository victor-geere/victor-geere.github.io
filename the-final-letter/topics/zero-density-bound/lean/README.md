# Lean formal core — the W4 zero-density entrywise bound

## Build

```bash
the-final-letter/topics/zero-density-bound/lean/check.sh
```

## What is proved

| Name | Statement |
|---|---|
| `TailEntryBound` | named entrywise bound on the tail block |
| `fullBlockWithin_of_tailBound` | tail bound ⇒ `FullBlockWithin` for the total block |
| `not_posSemidef_of_tailBound` | tail bound + off-line domination ⇒ the full 2×2 block is not PSD |
| `offLineQuad_obstruction_all` | harvested: unconditional 2×2 obstruction for any `δ ≠ 0` |
| `tailEntryBound_mono` | a tail entry bound is monotone in its bound |
| `tailEntryBound_nonneg` | a tail entry bound forces `0 ≤ B` |
| `tailEntryBound_iff_fullBlockWithin` | the tail predicate is exactly `FullBlockWithin` |
| `twoByTwo_diag_posSemidef_iff` | `!![a, b; b, a]` is PSD iff `|b| ≤ a` |
| `twoByTwo_diag_not_posSemidef` | `b > a` breaks the symmetric diagonal block |
| `zero_count_le_rlog` | `N(r) ≤ C r log(r+2) + D` from the unconditional log-growth bound |
| `tailEntryBound_iff_max_le` | normal form: the tail predicate is a bound on the maximum absolute entry |
| `twoByTwo_perturbed_not_posSemidef_abs` | perturbed 2×2 obstruction with `a − |b| + 2B < 0` |
| `not_posSemidef_of_tailBound_abs` | tail-bound obstruction with `S(0) − |S(c)| + 2B < 0` |
| `exists_domination_abs` | for every `B ≥ 0` a separation satisfies `S(0) − |S(c)| + 2B < 0` |
| `tendsto_gaussian_zero_mass_outside_radius` | the Gaussian mass of zeros above height `R` tends to `0` |
| `abs_tsum_le_mul_tsum` | termwise bound `‖f n‖ ≤ C w n` ⇒ `‖∑ f‖ ≤ C ∑ w` |
| `tailEntryBound_of_complex_tail` | four bounded zero sums give `TailEntryBound` with `B = C ∑ w` |
| `exists_gaussianZeroTest_bound_strip` | `‖H_c‖ ≤ C exp(−σ² Im²)` on the critical strip |
| `summable_gaussianZeroTest_of_strip` | summability of `∑ H_c(aₙ)` from the zero tail |
| `gaussianZeroTailEntry`, `norm_gaussianZeroTailEntry_le` | the Gaussian zero-side sum and its bound by the zero mass |
| `exists_tailEntryBound_gaussian_high` | the high-zero Gaussian tail satisfies `TailEntryBound` at any accuracy `C ε` |
| `exists_tailEntryBound_gaussian_all` | the full Gaussian zero-side block satisfies `TailEntryBound` with a finite `B` |
| `exists_gaussianZeroTest_mul_bound_strip` | `‖H_{c₁}H_{c₂}‖ ≤ C exp(−2σ² Im²)` on the strip |
| `gaussianZeroGramEntry`, `exists_tailEntryBound_gaussian_gram_all` | product-sum Gram model and its finite `B` |
| `onLineGramEntry`, `exists_tailEntryBound_onLineGram` | the actual on-line cosine Gram entries and their finite `B` |

No `sorry`, `axiom` or `admit`.

## What is open

- the **zero-density estimate** that supplies `B`: an entrywise bound on the
  contribution of the other zeros to the full block;
- the **density** input that makes the tail small uniformly in the height
  (Riemann–von Mangoldt up to constants is proved as `zero_count_le_rlog`);
- the extension from a 2×2 block to a full Gaussian Gram matrix.

[Back to the programme](../README.md) · [Topic index](../../README.md)
