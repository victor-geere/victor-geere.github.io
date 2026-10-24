# Refuted — the slope formula p(L) = 2L − 10

**Kind:** Claim
**Status:** REFUTED (counterexample: `x = 1/π`, `L = 100`: 190 vs 104)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `p(L) = 2L − 10` on `12 ≤ L ≤ 593`
>
> counterexample: 1/π, `L = 100`: 190 vs 104.

## Hypotheses and notation

- `p(L)` is the number of distinct length-`L` factors of the greedy word `w(x)`.
- The proposed window is `12 ≤ L ≤ 593`; the witness is `x = 1/π`, `L = 100`: the formula gives `2·100 − 10 = 190`, the truth is `104`.

## Proof / evidence

The counterexample is displayed in the source's §5 table; no further proof is given.

Machine-checked as `DigitWord.refuted_slope_formula` (by `native_decide`).

## Dependencies and related results

- [Theorem 5 (C1 regime)](tpp-rh41-truths-theorem-5-c1-regime.md) — the linear-`L` law that does hold, but only for small `L` and with slope `1`, not `2`.
- [Refuted — the span formula](tpp-rh41-truths-refuted-span-formula.md) — the other linear-slope candidate.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose".
