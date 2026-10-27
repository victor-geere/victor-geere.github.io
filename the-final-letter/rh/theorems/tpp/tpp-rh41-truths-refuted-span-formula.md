# Refuted — the span formula

**Kind:** Claim
**Status:** REFUTED (counterexample: `{139,151}`, `N=172`, `L=13`: 25 vs 15)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `p(L) = min(L + span, N − L + 1)`
>
> counterexample: `{139,151}`, `N=172`, `L=13`: 25 vs 15.

## Hypotheses and notation

- `p(L)` is the number of distinct length-`L` factors of the greedy word; `span = a_m − a_0` and `N` is the truncation length, as in [Theorem 1](tpp-rh41-truths-theorem-1-complexity-main.md).
- The witness is the support `{139,151}` (so `span = 12`), `N = 172`, `L = 13`: the candidate gives `min(13 + 12, 172 − 13 + 1) = min(25, 160) = 25`, the truth is `15`.

## Proof / evidence

The counterexample is displayed in the source's §5 table; no further proof is given.

Machine-checked as `DigitWord.refuted_span_formula` (by `native_decide`).

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the correct law in the large-`L` range.
- [Refuted — the slope formula p(L) = 2L − 10](tpp-rh41-truths-refuted-slope-formula-2l-minus-10.md) — the other linear candidate.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose".
