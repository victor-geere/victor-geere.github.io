# Refuted — the gap-deficit formula

**Kind:** Claim
**Status:** REFUTED (counterexample: `x = 1/π`, `L = 20`: 30 vs 24)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §5 "Refuted — do not re-propose"

## Statement

> `p(L) = L + 1 + Σ min(L−d_j, 0)`
>
> counterexample: 1/π, `L = 20`: 30 vs 24.

## Hypotheses and notation

- `p(L)` is the number of distinct length-`L` factors of the greedy word `w(x)`; `d_j = a_j − a_{j−1}` are the consecutive gaps of the support, as in [Theorem 5](tpp-rh41-truths-theorem-5-c1-regime.md)'s C1 law.
- The candidate adds the gap-deficit sum `Σ min(L−d_j, 0)` to `L + 1`.
- The witness is the target `x = 1/π` at `L = 20`: the candidate gives `30`, the truth is `24`.

## Proof / evidence

The counterexample is displayed in the source's §5 table; no further proof is given.

Machine-checked as `DigitWord.refuted_gap_deficit_formula` (by `native_decide`).

## Dependencies and related results

- [The C1 regime](tpp-rh41-truths-theorem-5-c1-regime.md) — the correct `L + 1` regime, in which the correction `#{j : d_j < L}` vanishes.
- [Refuted — the pair-count formula](tpp-rh41-truths-refuted-pair-count-formula.md), [Refuted — the distinct-distance formula](tpp-rh41-truths-refuted-distinct-distance-formula.md).

## Notes

- **Formatting discrepancy between the round's two documents:** `TRUTHS.md` prints the correction as `Σ min(L−d_j, 0)` (verbatim above), while the round's Lean README writes the same row as `Σ max(0, L−d_j)` (`DigitWord.refuted_gap_deficit_formula`). The printed form is preserved here; the Lean form is the non-trivial one (a deficit sum would be `≤ 0`).
- The source adds the row under the heading "Refuted — do not re-propose".
