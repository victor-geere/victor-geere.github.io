# Refuted: p(L) = L + 1 + #{pairs of 1s at distance ≤ L}

**Kind:** Theorem
**Status:** REFUTED (exact enumeration)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §5 "Already disproved — do not re-derive", line 179

## Statement

> | Claimed law | Status | Counterexample |
> |---|---|---|
> | A: p(L) = L + 1 + #{pairs of 1s at distance ≤ L} | **DISPROVEN** | 1/π, L = 11: predicts 13, truth 12; L = 13: predicts 15, truth 16; log 2, L = 6: 9 vs 8 |

The source states the claim and its refutation: the pair-count formula for the factor complexity p(L) of the greedy digit word is disproven by exact enumeration on the recorded words and lengths.

## Hypotheses and notation

- p(L) := #{ distinct factors of length L occurring in w } (§2), counted in the truncation w_N; the source reports N with every number.
- The words and truncations: 1/π at N = 1400, log 2 at N = 13000 (per §2's convention list).
- "#{pairs of 1s at distance ≤ L}" counts unordered pairs of support positions a < b with b − a ≤ L.

## Proof / evidence

Refuted by exact enumeration: 1/π at L = 11 predicts 13 against truth 12; at L = 13 predicts 15 against truth 16; log 2 at L = 6 gives 9 against 8. §8.2 item 5 makes this a required regression test: "`test_disproven_formulas_fail` — each law in HANDOFF.md §5 must **fail** on its recorded counterexample. These are regression tests against re-deriving dead ends."

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the exact enumeration that is the ground truth for every such check.
- [handoff-saturation-candidate-d-refuted](handoff-saturation-candidate-d-refuted.md) — model D, the other tested-and-failing candidate law.

## Notes

- The source's warning attached to §5: "**Do not** propose a formula solely in {L, number of pairs, number of distinct distances}. A formula must be a function of the **full gap sequence** (and of N)."
- Status REFUTED records the source's own verdict word ("DISPROVEN"), established by the recorded counterexamples.
