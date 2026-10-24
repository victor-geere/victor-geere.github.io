# Refuted: Agent A's round-1 boundary rule L_max = 1 + min(min_j d_j, min_j(d_j + d_{j+1}))

**Kind:** Claim
**Status:** REFUTED (numerical; on 17 375 random words satisfying N ≥ 2a_m + 3 it fails inside its own claimed range in 4 903 cases and is too early in 449; the correct boundary is OPEN)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M6** (lines 129–135)

## Statement

> Agent A's round-1 boundary rule — `L_max = 1 + min(min_j d_j, min_j(d_j + d_{j+1}))` — was tested by the mediator and is **also false**: on 17 375 random words satisfying N ≥ 2a_m + 3 it fails *inside* its own claimed range in 4 903 cases, and is too early in 449. A's own counterexample {13,244}, N = 253 is **outside** the regime where C1 has any content at all (there N − a_m − 1 = 8, so the linear regime is L ≤ 8). The correct boundary remains **open**; the mediator reduced it to a single exact statement in `rounds/round01.md`.

## Hypotheses and notation

- `d_i = a_{i+1} − a_i` are the gaps of the support `0 ≤ a_0 < … < a_m < N`; `p(L)` is the factor complexity of the truncation `w_N`.
- The rule claims that `p(L) = L + 1 + #{d_i < L}` holds for `L ≤ L_max` with `L_max = 1 + min(min_j d_j, min_j(d_j + d_{j+1}))`, and fails first at `L_max + 1`.
- The test corpus is 17 375 random words satisfying the eligibility condition `N ≥ 2a_m + 3`.

## Proof / evidence

The source states this without proof: the refutation is the mediator's exact enumeration over the stated corpus. Agent A's own round-1 report gives a different (non-random) test and its own counterexample `{13,244}`, `N = 253`, "rule 233 vs true 24", concluding the rule is `[DREAM]` in general and "exact on all four dialogue words plus 5 new ones" (harvested as [tpp-rh40-round01-agenta-boundary-rule-l-max.md](tpp-rh40-round01-agenta-boundary-rule-l-max.md)).

## Dependencies and related results

- [M6 — C1 as stated is false, and the real boundary is not the min gap](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) — the finding this rule was proposed against.
- [Agent A (a) — the boundary rule L_max](tpp-rh40-round01-agenta-boundary-rule-l-max.md) — A's own statement of the rule and his test.
- [Refuted: the unified candidate p(L) = min(L + 1 + #{d_i < L}, N − L + 1)](tpp-rh40-readme-refuted-unified-min-candidate.md) — the other failed boundary proposal.

## Notes

- The README records that A's cited counterexample `{13,244}`, `N = 253` is **outside** the regime where C1 has content at all (`N − a_m − 1 = 8`), so it does not by itself establish the rule's failure — the mediator's random-word sweep does.
- The correct boundary is stated as **open** here; the later round proved the narrower regime `L ≤ min(min_j d_j, a_0, N − a_0 − 1)` (harvested as [Theorem D](tpp-rh40-k-remaining-theorem-d-c1-regime.md)).
