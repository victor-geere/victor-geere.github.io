# `subSums_cons_disjoint` — Theorem 10's doubling step

**Kind:** Lemma
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Reachable.lean — truths.md §3–§5`

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | Theorem 10, doubling step | `subSums_cons_disjoint` | the two pieces are disjoint, giving `2^{n_min−1}` components |

## Hypotheses and notation

- The two pieces are those of the recursion `S = S' ∪ (a + S')`: `S'` and its shift `a + S'`.
- `n_min` is the source's index for the point at which the recursion stops merging (`2^{n_min−1}` components).
- "Theorem 10" is the `truths.md` numbering of the round (the signed-word census / reachable-interval statement of `rh42/truths.md`).

## Proof / evidence

The evidence is the machine-checked declaration `subSums_cons_disjoint` in `Rh42/Reachable.lean`; the README gives no separate proof text. The header of the file row describes `Reachable.lean` as "Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy".

## Dependencies and related results

- Uses the subset-sum recursion (`subSums_cons`, `mem_subSums_cons`).
- Provides the component count used by the round's `truths.md` Theorem 10 (census of the reachable set) and by the HANDOFF's `#intervals` table (row T12's companions: `1, 2, 4, 16, 128`).

## Notes

- The README states the declaration's content in the notes column, reproduced verbatim.
- The pairing with `truths.md` "Theorem 10" is the README's own; `rh42/truths.md` Theorem 10 is separately harvested as the census of the reachable set.
