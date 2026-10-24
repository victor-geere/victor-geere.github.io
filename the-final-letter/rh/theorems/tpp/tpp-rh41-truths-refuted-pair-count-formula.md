# Refuted — the pair-count formula

**Kind:** Claim
**Status:** REFUTED (counterexample: `x = 1/π`, `L = 11`: 13 vs 12)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `p(L) = L + 1 + #{pairs at distance ≤ L}`
>
> counterexample: 1/π, `L = 11`: 13 vs 12.

## Hypotheses and notation

- `p(L)` is the number of distinct length-`L` factors of the greedy word `w(x)`; the candidate formula adds `L + 1` to the number of **pairs** of support points at distance `≤ L`.
- The witness is the target `x = 1/π` at `L = 11`: the candidate gives `13`, the truth is `12`.

## Proof / evidence

The counterexample is displayed in the source's §5 table; no further proof is given.

Machine-checked as `DigitWord.refuted_pair_count_formula` (by `native_decide`).

## Dependencies and related results

- [Refuted — the distinct-distance formula](tpp-rh41-truths-refuted-distinct-distance-formula.md) — the sibling candidate with the same witness.
- [Refuted — the gap-deficit formula](tpp-rh41-truths-refuted-gap-deficit-formula.md).
- [The C1 regime](tpp-rh41-truths-theorem-5-c1-regime.md) — the genuine `L + 1` regime; these rows show pair counts do not extend it.

## Notes

- The source adds the row under the heading "Refuted — do not re-propose".
