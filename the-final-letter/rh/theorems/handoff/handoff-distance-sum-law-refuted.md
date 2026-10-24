# Refuted: p(L) = L + 1 + Σ_i (L − d_i)<sub>+</sub>

**Kind:** Theorem
**Status:** REFUTED (exact enumeration)
**Area:** workspace
**Source:** [`HANDOFF.md`](../../research/various/HANDOFF.md) — §5 "Already disproved — do not re-derive", line 181

## Statement

> | Claimed law | Status | Counterexample |
> |---|---|---|
> | Main agent: p(L) = L + 1 + Σ_i (L − d_i)_+ | **DISPROVEN** | 1/π, L = 20: predicts 30, truth 24 |

The source states the claim and its refutation: the gap-sum formula for the factor complexity p(L) of the greedy digit word is disproven by exact enumeration on the recorded word and length.

## Hypotheses and notation

- p(L) := #{ distinct factors of length L occurring in w } (§2), counted in the truncation w_N; the source reports N with every number.
- The word is 1/π at N = 1400; its consecutive gaps are d₁ = 11 and d₂ = 594 (§3.1).
- (L − d_i)<sub>+</sub> is the positive part; Σ_i runs over the consecutive gaps d_i.

## Proof / evidence

Refuted by exact enumeration: 1/π at L = 20 predicts 30 against truth 24. §3.2 explains why the naive count fails: "offsets (0,) through (10,) come from **two** windows each — this is why the naive 'L + 1 + Σ(L − d_j)' count fails (it predicts 30 at L = 20)." §8.2 item 5 makes the failure a required regression test.

## Dependencies and related results

- [handoff-offset-tuple-characterisation](handoff-offset-tuple-characterisation.md) — the exact enumeration, and the source of the L = 20 decomposition (24 factors) that refutes this law.
- [handoff-pair-count-law-refuted](handoff-pair-count-law-refuted.md), [handoff-distinct-distance-law-refuted](handoff-distinct-distance-law-refuted.md) — the other pair/distance-based laws in the same table.
- §4 C1 states the *correct* prefix-regime law, p(L) = L + 1 + #{i in [1, n] : L > d_i}, which is an open sub-target, not this refuted formula.

## Notes

- The source's warning attached to §5: "**Do not** propose a formula solely in {L, number of pairs, number of distinct distances}. A formula must be a function of the **full gap sequence** (and of N)."
- Status REFUTED records the source's own verdict word ("DISPROVEN"), established by the recorded counterexample.
