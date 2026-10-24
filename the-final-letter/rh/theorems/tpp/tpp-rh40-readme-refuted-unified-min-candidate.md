# Refuted: the unified candidate p(L) = min(L + 1 + #{d_i < L}, N − L + 1)

**Kind:** Claim
**Status:** REFUTED (numerical; fails in the saturation-onset regime, 16 vs 18 at L = 14 for 1/π)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M6** (lines 124–127)

## Statement

> The unified candidate `p(L) = min(L + 1 + #{d_i < L}, N − L + 1)` was tested and **fails** in precisely that regime (16 vs 18 at L = 14 for 1/π), so the onset is not a simple `min`.

## Hypotheses and notation

- `d_i = a_{i+1} − a_i` are the gaps of the support `0 ≤ a_0 < … < a_m < N`; `p(L)` is the factor complexity of the truncation `w_N`.
- The candidate combines the C1 linear expression `L + 1 + #{d_i < L}` with the right-edge decay expression `N − L + 1` by a pointwise minimum; the README names it "the unified candidate".
- "That regime" is the saturation-onset regime of M6, which the candidate was intended to cover.
- The witness is `x = 1/π`, support `{2, 13, 607}`, `N = 1400`, at `L = 14`: the candidate gives 16, the exact value is 18. (For this word the exact `p` is `p(12) = 14`, `p(13) = 16`, `p(14) = 18`.)

## Proof / evidence

The source states this without proof: the refutation is the single exact-enumeration witness above. No proof of failure in general is offered; the README uses the witness only to conclude "the onset is not a simple `min`".

## Dependencies and related results

- [M6 — C1 as stated is false, and the real boundary is not the min gap](tpp-rh40-readme-m6-c1-regime-boundary-refuted.md) — the finding this candidate was proposed against.
- [M2/M3 — five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the exact slope values in the onset regime.
- [Refuted: Agent A's round-1 boundary rule L_max](tpp-rh40-readme-refuted-agent-a-boundary-rule.md) — the other failed boundary proposal.

## Notes

- The candidate is a `min` of the two regimes known at the time (prefix/linear and right-edge decay); its failure is the README's evidence that the middle regime is genuinely unmodelled by the handoff.
