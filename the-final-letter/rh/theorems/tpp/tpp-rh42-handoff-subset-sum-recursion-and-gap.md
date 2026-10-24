# The subset-sum recursion `S = S(tail) ∪ (a_1 + S(tail))` and the gap `(total − a_1, a_1)`

**Kind:** Proposition
**Status:** PROVED (paper argument, stated in §5.5)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh42/HANDOFF.md) — §5.5 "The budget is *not* sufficient: the reachable set and its gaps"

## Statement

> Otherwise
>
> ```
> S(subset sums) = S(tail)  ∪  (a_1 + S(tail)),      S(tail) ⊆ [0, total − a_1],
> ```
>
> so incompleteness produces a gap `(total − a_1, a_1)` whenever `a_1 > total − a_1`, and the
> construction recurses on the tail.

## Hypotheses and notation

- `a_1 ≥ a_2 ≥ …` a non-increasing positive sequence with total `total`; `tail` is the sequence with `a_1` removed.
- `S(...)` denotes the set of subset sums of the sequence in its argument.
- The condition complementary to Brown's criterion: the first term exceeds the sum of the rest.
- The source's application: `a_k = (2k)^{−p}` for the positive half, so `a_1 = 2^{−p}` and `total = P(p)`.

## Proof / evidence

The source states the recursion in §5.5 as part of the incompleteness argument and says "the construction recurses on the tail". It is used to predict the `p = 2` gap `(0.161233516712, 0.25)` (row T11) and the four `p = 3` intervals (row T12), and is listed as an ingredient to be written out in §7 R1(c): "the recursion `S = S(tail) ∪ (a_1 + S(tail))` and the exact interval structure as a function of `p`".

## Dependencies and related results

- Companion of Brown's criterion (previous harvested entry); the "otherwise" branch.
- Produces the gap structure quantified by T11 (`p = 2`), T12 (`p = 3`) and the `#intervals` table of §5.5.
- The refuted single-condition row R3 of `truths.md` shows that `a_1 ≤ total − a_1` alone does not give completeness.

## Notes

- The recursion is written out in the source with its inclusion `S(tail) ⊆ [0, total − a_1]` and the gap condition; no separate proof paragraph is given beyond the displayed relation.
- The gap `(total − a_1, a_1)` is stated under the hypothesis `a_1 > total − a_1`.
