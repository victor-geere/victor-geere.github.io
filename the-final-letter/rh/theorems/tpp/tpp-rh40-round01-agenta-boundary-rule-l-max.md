# (a) Boundary: p(L) = L+1+#{d_i<L} holds for L ≤ L_max with L_max = min(1+min_j d_j, 1+min_j(d_j+d_{j+1}))

**Kind:** Claim
**Status:** REFUTED (in general; the source's own tag is `[DREAM]`, exact only "on all four dialogue words plus 5 new ones")
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[COMPUTABLE]", item (a), lines 48–55

## Statement

> **(a) Boundary.** `p(L) = L+1+#{d_i<L}` holds for `L ≤ L_max`, `L_max = min( 1+min_j d_j, 1+min_j(d_j+d_{j+1}) )`, and fails first at `L_max+1`. For the four mediator words this gives 12 (1/π), 33 (log 2, `d_2+2=34` — the *chain* term, not `d_1`), 11 (√2−1), 11 (e−2): exactly M6's table. Test: `next(L for L in range(1,N) if p_offset(list(ones),N,L) != L+1+sum(1 for x in gaps(ones) if x<L))`; this succeeds on 40/50 of my words and fails on 10 (e.g. `{13,244}`, `N=253`, rule 233 vs true 24) — so the rule is **[DREAM]** in general, exact on all four dialogue words plus 5 new ones.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the truncation `w_N`; `d_i = a_{i+1} − a_i` are the gaps; `p(L)` is the factor complexity.
- `L_max = min(1 + min_j d_j, 1 + min_j(d_j + d_{j+1}))` is the proposed end of the C1 regime (the minimum is over all gaps and over all adjacent gap sums).
- The test predicate `p_offset(list(ones),N,L) != L+1+sum(1 for x in gaps(ones) if x<L)` is the source's own falsifier; the counterexample is the support `{13,244}` at `N = 253`.
- "M6's table" is the round-1 brief's M6 table of first failures: 1/π `L = 13`, log 2 `L = 34`, √2−1 `L = 12`, e−2 `L = 12`.

## Proof / evidence

The source states this **without proof** and reports its own failure: "this succeeds on 40/50 of my words and fails on 10 (e.g. `{13,244}`, `N=253`, rule 233 vs true 24) — so the rule is **[DREAM]** in general, exact on all four dialogue words plus 5 new ones." The mediator's independent sweep is reported in the README: "on 17 375 random words satisfying N ≥ 2a_m + 3 it fails *inside* its own claimed range in 4 903 cases, and is too early in 449", and the same README notes that A's cited counterexample `{13,244}`, `N = 253` lies "**outside** the regime where C1 has any content at all" (harvested as [the refutation](tpp-rh40-readme-refuted-agent-a-boundary-rule.md)).

## Dependencies and related results

- [M6 — C1 as stated is false, and the real boundary is not the min gap](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) — the finding this rule was proposed to answer.
- [Refuted: Agent A's round-1 boundary rule L_max](tpp-rh40-readme-refuted-agent-a-boundary-rule.md) — the mediator's refutation.
- [round01-brief M6 — C1 as stated is false](tpp-rh40-round01-brief-m6-c1-regime-false.md) — the brief's table this rule reproduces.
- [Theorem D (the C1 regime, proved)](tpp-rh40-k-remaining-theorem-d-c1-regime.md) — the later, narrower proved regime.

## Notes

- The `log 2` value in the statement is the source's own parenthetical: it says the rule "gives ... 33 (log 2, `d_2+2=34` — the *chain* term, not `d_1`)" — the rule's `L_max` is 33 while `d_2 + 2 = 34` is named as the chain quantity involved. Both numbers are preserved verbatim.
- Status is REFUTED because the rule is false in general by the source's own test and by the mediator's sweep; the rule is exact on the four dialogue words and five further words, which is recorded but does not make the general statement true.
