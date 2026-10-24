# Term-level reading: strictly stronger than P = |M| and false at the balance points

**Kind:** Proposition
**Status:** REFUTED (strict reading) — the exact subset-sum defect is `0.16996…` at `N = 6`
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.5 "The term-level reading, and why it fails"

## Statement

> The question can also be read at the level of the *terms*: "two equal positive parts" = the positive terms partition into two subsets of equal sum. That is strictly stronger than `P = |M|` and it is **false** at the balance points: `cos(t log 1) = 1` is the first positive term and it exceeds `P/2` whenever `P < 2`, which holds at the smallest positive root for every `N` tested (`P = 1.00, 1.28, 1.48, 1.66, 2.02, 2.40, 2.74` for `N = 3,4,5,6,8,10,12`), and an exhaustive subset-sum confirms the defect. At `N = 3` it is starkest: the positive side is the single term `{1}`, which cannot be split at all, while the *numbers* `P/2 = 1/2` and `M/2 = -1/2` pair up perfectly. So the two readings of the round's question have opposite answers, and [truths.md](../../research/twin-prime-parity/rounds/rh43/truths.md) §3/§5 records both (`T9`, `T9′`, `F7`).

The one-paragraph version in the header states:

> (Read at the level of the *terms* — can the positive terms be partitioned into two equal halves? — the answer is no at the balance points, and this is a different question; the exact subset-sum defect is `0.16996…` at `N = 6`. See §2.5.)

## Hypotheses and notation

- Term-level reading: the positive terms partition into two subsets of equal sum (and likewise the negative terms); strictly stronger than `P = |M|` (reading R1).
- `cos(t log 1) = 1` is always the first positive term and the largest; `P` values at the smallest positive roots: `1.00, 1.28, 1.48, 1.66, 2.02, 2.40, 2.74` for `N = 3,4,5,6,8,10,12`.
- The exact subset-sum defect at `N = 6` is `0.16996…`; `T9`, `T9′`, `F7` are truths.md ledger ids.

## Proof / evidence

- The source states the failure with the structural cause (`cos(t log 1) = 1` exceeds `P/2` whenever `P < 2`) and records that "an exhaustive subset-sum confirms the defect".
- The round's ledger records this as **T9′**, "**REFUTED** (strict reading) + **VERIFIED**", with the `N = 6` defect `0.169962576…` (truths.md §3).

## Dependencies and related results

- Harvested truths counterparts: [Theorem 11′ (the term-level split fails)](tpp-rh43-truths-term-level-split-fails.md), ledger row [T9′](tpp-rh43-truths-term-level-split-defects-n6.md), refuted statement [F7](tpp-rh43-truths-f7-balance-implies-term-split-refuted.md).
- Contrast [The reduction: `P_N + M_N = Re S_N`](tpp-rh43-handoff-reduction-to-real-equation.md) — the numeric reading balances.

## Notes

- The source stresses that "the two readings of the round's question have opposite answers"; this harvested statement is the *false* term-level reading, marked REFUTED.
- The general question — whether the term-level split can ever succeed at some balance point of some `N` — is **OPEN** in truths.md §6.
