# Splitting the real part: `realPartial N t = posRe N t + negRe N t`

**Kind:** Theorem
**Status:** PROVED (Lean, no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) — §2 "The positive and negative parts of the real part", lines 146–165

## Statement

> **Splitting the real part.** `realPartial N t = posRe N t + negRe N t`.

That is, for every `N : ℕ` and `t : ℝ`,

```lean
theorem realPartial_eq_posRe_add_negRe (N : ℕ) (t : ℝ) :
    realPartial N t = posRe N t + negRe N t
```

where

```
realPartial N t = ∑_{k<N} cos (t log (k+1))
posRe N t      = ∑_{0 < cos (t log (k+1))} cos (t log (k+1))     (≥ 0)
negRe N t      = ∑_{cos (t log (k+1)) < 0} cos (t log (k+1))     (≤ 0)
```

Indices with `cos = 0` belong to neither sum.

The same splitting read off the complex partial sum is stated as `zetaPartial_re_eq_posRe_add_negRe`:

> `(zetaPartial N t).re = posRe N t + negRe N t`.

## Hypotheses and notation

- `N : ℕ` and `t : ℝ` are arbitrary; `zetaPartial N t = ∑_{k<N} (k+1)^{-it} = ∑_{k<N} exp(-i t log (k+1))` is an ordinary finite sum — no analytic continuation is involved anywhere in the file.
- `realPartial N t` is its real part written directly as a real sum: `∑_{k<N} cos (t log (k+1))`.
- `posRe N t` is the total of the summands with `0 < cos (t log (k+1))`; `negRe N t` is the total of the summands with `cos (t log (k+1)) < 0`.
- Terms with `cos = 0` contribute `0` and are excluded from both filters; this is harmless for the real parts but is exactly why the naive complex identity `posPart + negPart = zetaPartial` is *not* stated (a term with `cos = 0` has a non-zero imaginary part and is in neither filter).

## Proof / evidence

- **PROVED** in Lean, with no `sorry`: declaration `realPartial_eq_posRe_add_negRe` in [`Rh43/Balance.lean`](../../research/twin-prime-parity/rounds/rh43/lean/Rh43/Balance.lean) (lines 155–160), obtained by unfolding `realPartial`, `posRe`, `negRe` and applying the generic filter splitting `sum_split` (line 148), whose input `sum_filter_not_pos_eq_sum_filter_neg` (line 121) removes the `cos = 0` terms.
- The companion statement from the complex side, `zetaPartial_re_eq_posRe_add_negRe` (line 163), composes this with `zetaPartial_re` (line 84): `(zetaPartial N t).re = realPartial N t`.

## Dependencies and related results

- Definitions `zetaPartial`, `realPartial`, `posRe`, `negRe` (§1–2 of the source).
- [Accounting theorem: `balanced N t ↔ realPartial N t = 0`](lean-rh43-balance-accounting-theorem-balanced-iff-real-part-zero.md) — the equivalent reformulation of balance used everywhere below.
- Harvested counterpart from the round's README: [`realPartial_eq_posRe_add_negRe` — the real part is the sum of the positive and negative parts](../tpp/tpp-rh43-lean-readme-realpartial-split-identity.md).

## Notes

- The source deliberately works at the level of real parts: it records that the complex split `posPart + negPart = zetaPartial` is false because of the `cos = 0` terms, so no such complex statement is made or harvested.
