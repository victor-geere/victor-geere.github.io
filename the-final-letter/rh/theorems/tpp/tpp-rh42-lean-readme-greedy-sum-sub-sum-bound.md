# `greedySum` — the greedy's total is a sub-sum that never overshoots

**Kind:** Lemma
**Status:** PROVED (Lean, machine-checked; no `sorry`)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh42/lean/README.md`](../../research/twin-prime-parity/rounds/rh42/lean/README.md) — `### Rh42/Reachable.lean — truths.md §3–§5`, final row

## Statement

> | `truths.md` | Lean | notes |
> |---|---|---|
> | the greedy on a list | `greedySum`, `greedySum_cons`, `greedySum_mem_subSums`, `greedySum_le` | the greedy's total is a sub-sum that never overshoots |

## Hypotheses and notation

- `greedySum` is the Lean operator running the greedy over a list of terms.
- `greedySum_mem_subSums` says the greedy's total is a sub-sum of the list; `greedySum_le` says it never overshoots the target (it is `≤` the target it is set against).
- The round's object is the greedy sub-sum selection on a non-increasing positive list.

## Proof / evidence

The evidence is the machine-checked Lean file `Rh42/Reachable.lean` (the README's file table lists it as "Brown's criterion one-step lemmas, sub-sums, gap lemma, greedy"); the README gives no separate proof text.

## Dependencies and related results

- Uses `subSums` and its membership lemmas (previous harvested entry).
- Complements the finite gap lemma (`gap_lemma`) of the same file.
- The round's HANDOFF §7 R1(d) flags the related statement that is *not* covered here: "the exactness of the stall residual `x − max{s ∈ S : s ≤ x}` (verified here; needs the statement that the greedy is optimal, not just feasible)".

## Notes

- The Lean names and the notes column are quoted; the README compresses the declaration statements into the notes shown.
- The HANDOFF's §5.5 uses the greedy as a witness of completeness/attainment; this lemma is the formal feasibility content.
