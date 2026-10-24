# The round's object and question

**Kind:** Proposition
**Status:** PROVED (paper argument; the readings R1, R2 are equivalent, R2′ and R3 are different questions)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh43/HANDOFF.md`](../../research/twin-prime-parity/rounds/rh43/HANDOFF.md) — §2.1 "The object", §2.2 "The question and its readings"

## Statement

> "Can the partial sum be separated into two equal positive parts and two equal negative parts, using only the positive parts and the negative parts with normal summation?" The readings, and their fates:
>
> | reading | statement | answer |
> |---|---|---|
> | **R1** the split balances | `P_N(t) = |M_N(t)|` | **yes, every `N ≥ 2`** (T3–T8) |
> | **R2** all four pieces equal | `P/2 = |M|/2` | same as R1 (the equality is automatic once `P = |M|`) |
> | **R2′** the positive *terms* split into two equal sub-sums | strictly stronger than R1 | **no** at the certified balance points: the exact subset-sum misses `P/2` (defect `0.16996…` at `N = 6`), structurally because `cos(t log 1) = 1` exceeds `P/2` whenever `P < 2` (T11′) |
> | **R3** the complex partial sum vanishes | `S_N(t) = 0` | different question: `N = 2` yes (exactly), `N = 3` provably no, `N ≥ 4` open (T10–T11) |

## Hypotheses and notation

- Readings of the round's question: R1 (`P_N(t) = |M_N(t)|`), R2 (`P/2 = |M|/2`), R2′ (positive terms partition into two subsets of equal sum) and R3 (`S_N(t) = 0`).
- `P`, `M` are the positive and negative real-part totals of §2.1; `T3–T8`, `T10–T11`, `T11′` are the ledger ids of truths.md.

## Proof / evidence

- The source states the case table without a separate proof; each row refers to the corresponding ledger item of the round (T3–T8, T10–T11, T11′).
- The equivalence R2 = R1 (the equality is automatic once `P = |M|`) is stated as part of the table; the strictness of R2′ over R1 and the difference of R3 are stated in the "answer" column.

## Dependencies and related results

- Related: [The reduction: `P_N + M_N = Re S_N`](tpp-rh43-handoff-reduction-to-real-equation.md); [Term-level reading: strictly stronger than P = |M| and false at the balance points](tpp-rh43-handoff-term-level-reading-fails.md).
- Harvested truths counterparts: [T2](tpp-rh43-truths-split-identity-and-balance-equation.md), [T11](tpp-rh43-truths-term-level-split-fails.md).

## Notes

- This table is a classification of the readings of the round's question; only the R1/R2 reading is answered affirmatively.
- The source's §2.2 is the handoff's version of truths.md §0.2.
