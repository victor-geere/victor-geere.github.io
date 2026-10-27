# Read at the level of the terms, the answer flips

**Kind:** Proposition
**Status:** REFUTED (strict term-level reading) — exact subset-sum defect `0.16996…` at `N = 6`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/README.md`](../../research/twin-prime-parity/rounds/rh43/README.md) — "**Read at the level of the terms, the answer flips.**"

## Statement

> **Read at the level of the terms, the answer flips.** If "two equal positive parts" means *the positive terms partition into two subsets of equal sum*, that is strictly stronger than `P = |M|` and it is **false** at the balance points: the first term `cos(t log 1) = 1` exceeds `P/2` whenever `P < 2` (true at the smallest positive root for every `N` tested), and an exhaustive subset-sum gives the exact defect `0.16996…` at `N = 6`. The numeric pieces `P/2, M/2` do pair up perfectly; the term-level partition does not. Both readings are recorded in [`truths.md`](../../research/twin-prime-parity/rounds/rh43/truths.md) §0.2/§3.

## Hypotheses and notation

- Term-level reading: the positive terms partition into two subsets of equal sum; strictly stronger than the numeric balance `P = |M|`.
- The first term `cos(t log 1) = 1` exceeds `P/2` whenever `P < 2`, which holds at the smallest positive root for every `N` tested.
- Exact subset-sum defect at `N = 6`: `0.16996…`.

## Proof / evidence

- The source states the failure and records that "an exhaustive subset-sum gives the exact defect `0.16996…` at `N = 6`"; the numeric pieces `P/2, M/2` do pair up perfectly.
- The full statement, with the structural cause and the positive-side/negative-side defects, is truths.md §3 Theorem 11′ (harvested as [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md)).

## Dependencies and related results

- Harvested truths counterparts: [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md), [T9′ ledger row](tpp-rh43-truths-term-level-split-defects-n6.md), [F7](tpp-rh43-truths-f7-balance-implies-term-split-refuted.md).
- Harvested handoff counterpart: [Term-level reading: strictly stronger than P = |M| and false at the balance points](tpp-rh43-handoff-term-level-reading-fails.md).
- Contrast [Answer: yes — for every N ≥ 2](tpp-rh43-readme-answer-yes-every-n.md).

## Notes

- The README references truths.md §0.2/§3 for both readings; the general question of whether a term-level split can ever succeed at some balance point is **OPEN** in truths.md §6.
