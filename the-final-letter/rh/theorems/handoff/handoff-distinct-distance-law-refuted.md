# Refuted: p(L) = L + 1 + #{distinct distances ≤ L}

**Kind:** Theorem
**Status:** REFUTED (exact enumeration)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §5 "Already disproved — do not re-derive", line 180

## Statement

> | Claimed law | Status | Counterexample |
> |---|---|---|
> | Main agent: p(L) = L + 1 + #{distinct distances ≤ L} | **DISPROVEN** | 1/π, L = 12: predicts 13, truth 14 |

The source states the claim and its refutation: the distinct-distance formula for the factor complexity p(L) of the greedy digit word is disproven by exact enumeration on the recorded word and length.

## Hypotheses and notation

- p(L) := #{ distinct factors of length L occurring in w } (§2), counted in the truncation w_N; the source reports N with every number.
- The word is 1/π at N = 1400 (per §2's convention list).
- "#{distinct distances ≤ L}" counts the set of distinct differences b − a ≤ L between support positions.

## Proof / evidence

Refuted by exact enumeration: 1/π at L = 12 predicts 13 against truth 14. §8.2 item 5 makes this a required regression test: "each law in HANDOFF.md §5 must **fail** on its recorded counterexample."

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the exact enumeration that is the ground truth for every such check.
- [handoff-pair-count-law-refuted](handoff-pair-count-law-refuted.md) — the companion pair-count law, also disproven.
- [handoff-distance-sum-law-refuted](handoff-distance-sum-law-refuted.md) — the third pair/distance-based law in the same table.

## Notes

- The source's warning attached to §5: "**Do not** propose a formula solely in {L, number of pairs, number of distinct distances}. A formula must be a function of the **full gap sequence** (and of N)."
- Status REFUTED records the source's own verdict word ("DISPROVEN"), established by the recorded counterexample.
