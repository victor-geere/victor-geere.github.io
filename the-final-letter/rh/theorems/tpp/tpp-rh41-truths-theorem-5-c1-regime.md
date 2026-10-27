# Theorem 5 (C1 regime)

**Kind:** Theorem
**Status:** PROVED (paper argument; Lean, no sorry)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh41/TRUTHS.md`](../../research/twin-prime-parity/rounds/rh41/TRUTHS.md) — §1 "The complexity function"

## Statement

> **Theorem 5 (C1 regime).** For `L ≤ min( min_j d_j , a_0 , N − a_0 − 1 )`,
>
> ```
> p(L) = L + 1.
> ```
>
> Each of the three bounds is necessary. This is the C1 law `p(L) = L + 1 + #{j : d_j < L}` in the range where `#{j : d_j < L} = 0`.

## Hypotheses and notation

- Same objects as [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md): support `0 ≤ a_0 < … < a_m`, `d_j = a_j − a_{j−1}` the consecutive gaps, truncation length `N`, `p(L)` the number of distinct length-`L` factors.
- The three bounds are `min_j d_j` (all gaps), `a_0` (position of the first support point) and `N − a_0 − 1` (the hedge against the right end).

## Proof / evidence

The source states the theorem; it gives no proof text for Theorem 5 (it presents the result together with the C1 law and the necessity of each bound).

Machine-checked as `DigitWord.complexity_c1` in `Rh41/DigitWord.lean` (no `sorry`), with the three necessity counterexamples `c1_bound_a0_necessary`, `c1_bound_gap_necessary`, `c1_bound_hedge_necessary` (the gap bound via `native_decide`). Cross-checked against the Python ground truth `p_ref` over 117 011 cases.

## Dependencies and related results

- [Theorem 1 (main)](tpp-rh41-truths-theorem-1-complexity-main.md) — the large-`L` companion law.
- The large-`L` analogue in the signed round: [The C1 regime of a signed word](tpp-rh42-truths-c1-regime-signed-word.md).

## Notes

- The source explicitly states that **each of the three bounds is necessary**, but does not spell the counterexamples out in `TRUTHS.md`; the round's Lean development carries them as the three declarations named above.
- The general C1 law `p(L) = L + 1 + #{j : d_j < L}` is quoted by the source only as the law whose correction-free range Theorem 5 describes; the round's Lean README says only that correction-free regime is formalised.
