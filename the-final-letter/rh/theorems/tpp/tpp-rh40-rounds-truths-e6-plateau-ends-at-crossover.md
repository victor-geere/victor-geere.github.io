# E6 — the p(L) = a_m + 2 plateau ends at exactly L = N − a_m − 1

**Kind:** Claim
**Status:** PROVED (paper argument; the indicator in Theorem A flips there)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/truths.md`](../../research/twin-prime-parity/rounds/rh40/rounds/truths.md) — §E "Saturation: value and range", register row E6

## Statement

> The `p(L) = a_m + 2` plateau **ends** at exactly `L = N − a_m − 1`

## Hypotheses and notation

- `N` = truncation length; `a_m` = last support position.
- The plateau is the range on which `p(L) = a_m + 2` (register rows E1, E2).

## Proof / evidence

Register row E6's evidence cell reads: "1/π hi=792, log 2 hi=6930, √2−1 hi=1748, (10,20,40,80) hi=419, true e−2 hi=1946"; the status cell reads "**`PROVED`** (the indicator in Theorem A flips there)".

## Dependencies and related results

- [Theorem A (the large-`L` regime)](tpp-rh40-k1-theorem-a-large-l-regime.md).
- Register rows D2, D3, D5, E1, E2, E5, G4.

## Notes

- The measured plateau ranges (e.g. `[605, 792]` for 1/π) start *earlier* than the proved plateau; the source keeps the onset as open problem K2/row E8 and does **not** claim it here.
