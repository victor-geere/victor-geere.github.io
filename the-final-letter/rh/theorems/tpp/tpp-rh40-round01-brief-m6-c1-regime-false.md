# M6 — C1 as stated in HANDOFF.md §4 is false

**Kind:** Claim
**Status:** REFUTED (numerical; fails on the first L strictly greater than the smallest gap, for all four dialogue words; the correct boundary rule is stated as OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M6** (lines 92–115)

## Statement

> **M6 — C1 as stated in HANDOFF.md §4 is false.** The §4 claim `p(L) = L + 1 + #{i : L > d_i}` for `0 < L ≤ min_j d_j` fails on the very first L strictly greater than the smallest gap, for all four dialogue words:
>
> | word | gaps | C1 holds for | first failure | C1 predicts | exact |
> |---|---|---|---|---|---|
> | 1/π | (11, 594) | L ≤ 12 | L = 13 | 15 | **16** |
> | log 2 | (4, 32, 6033) | L ≤ 33 | L = 34 | 37 | **38** |
> | √2−1 | (10, 240) | L ≤ 11 | L = 12 | 14 | **15** |
> | e−2 | (10, 20, 40) | L ≤ 11 | L = 12 | 14 | **15** |
>
> So C1 in the form §4 asserts it (`0 < L ≤ min_j d_j`) is true but badly understates its validity: C1 actually holds all the way to the **second** boundary, which is not the smallest gap. For 1/π that boundary is 13 = d_1 + 2; for √2−1 and e−2 it is 12 = d_1 + 2; for log 2 it is 34 = d_2 + 2. In each case the C1 regime ends at `(the first gap that is ≥ ... )` — the mediator does not have the rule yet.
>
> The critical structural fact is that the C1 regime ends **strictly below** the next gap (13 < 594, 34 < 6033, 12 < 240, 12 < 20 and 40). So there is an entire intermediate regime — call it the **saturation-onset regime**, between the end of C1 and the start of the plateau — in which the handoff has no law at all, and it is exactly where the slope does its unexplained 2 → 1 decrease (M2). **Locating that boundary exactly is the concrete sub-target for A (a).**

## Hypotheses and notation

- C1 is sub-target **C1** of `HANDOFF.md` §4, asserted there as `p(L) = L + 1 + #{i : L > d_i}` for `0 < L ≤ min_j d_j` (the "prefix (linear) regime").
- `d_i = a_{i+1} − a_i` are the gaps of the support; the table's "gaps" column lists them for each dialogue word.
- "First failure" is the smallest `L` at which the C1 expression differs from the exact `p(L)`; "C1 predicts" and "exact" give the two values there.
- The "saturation-onset regime" is the interval between the end of C1 and the start of the plateau, where the handoff "has no law at all".

## Proof / evidence

The source states this as a record of exact recomputation; the "first failure" column is the certificate. The brief marks the correct boundary as not yet known ("the mediator does not have the rule yet") and makes locating it Agent A's sub-target (a). The README's §4 repeats the finding and adds the mediator's refutations of two candidate rules (the unified `min` candidate and Agent A's `L_max` rule), both harvested separately; the later proved, narrower regime is [Theorem D](tpp-rh40-k-remaining-theorem-d-c1-regime.md).

## Dependencies and related results

- [README M6 — C1 as stated in §4 is false, and the real boundary is not the min gap](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) — the README's version of the same finding.
- [Refuted: the unified candidate p(L) = min(L + 1 + #{d_i < L}, N − L + 1)](tpp-rh40-readme-refuted-unified-min-candidate.md) — one failed boundary proposal.
- [Refuted: Agent A's round-1 boundary rule L_max](tpp-rh40-readme-refuted-agent-a-boundary-rule.md) — the other failed boundary proposal.
- [Theorem D (the C1 regime, proved)](tpp-rh40-k-remaining-theorem-d-c1-regime.md) — the later proved regime `L ≤ min(min_j d_j, a_0, N − a_0 − 1)`.
- [M2 — the five-piece slope structure](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md) — the `2 → 1` decrease the onset regime contains.

## Notes

- **Restatement.** M6 is also M6 of the README §4 (harvested as [tpp-rh40-readme-m6-c1-regime-boundary-refuted.md](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md)); both restate the same round-1 computation.
- The brief's table row labelled `e−2` inherits the mislabel flagged by Agent B: the support `(10,20,40)` is not the greedy word for `e−2` (the true one at `N = 2000` is `(0,3,53)`); see [tpp-rh40-round01-agentb-e-minus-2-mislabel.md](tpp-rh40-round01-agentb-e-minus-2-mislabel.md).
