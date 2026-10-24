# M6 — C1 as stated in §4 is false, and the real boundary is not the min gap

**Kind:** Claim
**Status:** REFUTED (numerical; C1 fails on the first L greater than the smallest gap, for all four dialogue words; the correct boundary is left OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M6** (lines 112–135)

## Statement

> **M6 — C1 as stated in §4 is false, and the real boundary is not the min gap.** `p(L) = L + 1 + #{d_i < L}` actually holds far beyond `L ≤ min_j d_j`:
>
> | word | gaps | C1 holds for | first failure |
> |---|---|---|---|
> | 1/π | (11, 594) | L ≤ 12 | L = 13 → 16 (C1 says 15) |
> | log 2 | (4, 32, 6033) | L ≤ 33 | L = 34 → 38 (C1 says 37) |
> | √2−1 | (10, 240) | L ≤ 11 | L = 12 → 15 (C1 says 14) |
> | e−2 | (10, 20, 40) | L ≤ 11 | L = 12 → 15 (C1 says 14) |
>
> In every case the C1 regime ends **strictly below the next gap**, so there is an unmodelled *saturation-onset* regime between the end of C1 and the plateau — and that is exactly where the unexplained 2 → 1 decrease happens. The unified candidate `p(L) = min(L + 1 + #{d_i < L}, N − L + 1)` was tested and **fails** in precisely that regime (16 vs 18 at L = 14 for 1/π), so the onset is not a simple `min`.

## Hypotheses and notation

- C1 is sub-target **C1** of `HANDOFF.md` §4: "the prefix (linear) regime", asserted there as `p(L) = L + 1 + #{i : L > d_i}` for `0 < L ≤ min_j d_j`.
- `d_i = a_{i+1} − a_i` are the gaps of the support `0 ≤ a_0 < … < a_m < N`; the "gaps" column of the table lists them.
- `p(L)` is the factor complexity of the truncation `w_N`.
- The "saturation-onset regime" runs from the end of C1 to the start of the plateau; the README records it as exactly where the slope does its unexplained `2 → 1` decrease.

## Proof / evidence

The source states this without proof: the refutation is exact enumeration ("first failure" values in the table), regression-locked by `tests/test_complexity.py`. The README adds that "the correct boundary remains **open**; the mediator reduced it to a single exact statement in `rounds/round01.md`". Two proposed boundary rules are separately refuted (and harvested separately): the unified `min` candidate and Agent A's `L_max = 1 + min(min_j d_j, min_j(d_j + d_{j+1}))`.

## Dependencies and related results

- [Refuted: the unified candidate p(L) = min(L + 1 + #{d_i < L}, N − L + 1)](tpp-rh40-readme-refuted-unified-min-candidate.md) — the failed `min` repair.
- [Refuted: Agent A's round-1 boundary rule L_max](tpp-rh40-readme-refuted-agent-a-boundary-rule.md) — the failed `d_j + d_{j+1}` rule.
- [Theorem D (the C1 regime, proved)](tpp-rh40-k-remaining-theorem-d-c1-regime.md) — the later proved regime `L ≤ min(min_j d_j, a_0, N − a_0 − 1)`.
- [round01-brief M6 — C1 as stated is false](tpp-rh40-round01-brief-m6-c1-regime-false.md) — the same correction in the brief.
- [Agent A (a) — the boundary rule L_max and its refutation](tpp-rh40-round01-agenta-boundary-rule-l-max.md) — A's own statement, with his counterexample.

## Notes

- **Restatement.** M6 is also M6 of `round01_brief.md` (harvested as [tpp-rh40-round01-brief-m6-c1-regime-false.md](tpp-rh40-round01-brief-m6-c1-regime-false.md)).
- The README's table row labelled "e−2" inherits Agent B's mislabel flag: the support `(10,20,40)` is not the greedy word for `e−2` (the true one at `N = 2000` is `(0,3,53)`); see [tpp-rh40-round01-agentb-e-minus-2-mislabel.md](tpp-rh40-round01-agentb-e-minus-2-mislabel.md).
