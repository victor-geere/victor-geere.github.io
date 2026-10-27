# `subSums` — `0` and the total are sub-sums, and sub-sums lie in `[0, sum]`

**Kind:** Lemma
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Reachable.lean — truths.md §3–§5`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | the sub-sum operator | `subSums`, `subSums_cons`, `mem_subSums_cons` | the recursion `S = S' ∪ (a + S')` |
> | `0` and the total are sub-sums | `zero_mem_subSums`, `sum_mem_subSums` | |
> | sub-sums lie in `[0, sum]` | `subSums_nonneg`, `subSums_le_sum` | |

## Hypotheses and notation

- "sub-sum" of a list/sequence of terms: a sum of a sub-multiset of its entries; `subSums` is the Lean operator returning the set of sub-sums.
- `sum` is the total of the list.
- The recursion `S = S' ∪ (a + S')` is the source's own reading of `subSums_cons` (`S'` the sub-sums of the tail, `a` the head).

## Proof / evidence

The README lists the declarations under `Rh42/Reachable.lean` (header: "Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy"); it gives no separate proof text, the evidence being the machine-checked Lean file itself and the build contract (`./check.sh --all`, no `sorry`).

## Dependencies and related results

- Used by the finite gap lemma, the doubling step (`subSums_cons_disjoint`) and the greedy (`greedySum_mem_subSums`) of the same file.
- The operator corresponds to the subset-sum sets `S(...)` of the round's HANDOFF §5.5 (harvested there as the subset-sum recursion and gap entry).

## Notes

- The Lean names and the notes column are quoted; the mathematical content is stated by the README in the compressed form reproduced above.
- The Lean development is the rh42 round's (`truths.md` §3–§5); the README gives no per-declaration statement beyond these notes.
