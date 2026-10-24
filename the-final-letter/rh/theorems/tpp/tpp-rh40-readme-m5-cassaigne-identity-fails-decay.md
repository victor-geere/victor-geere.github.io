# M5 — Cassaigne's identity fails exactly in the decay regime

**Kind:** Claim
**Status:** REFUTED (numerical; the identity holds for every L ≤ 604 and fails for all 608 values L ∈ [792, 1399] at N = 1400; the mediator's naive finite-word fix fails too, 0 of 608)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M5** (lines 137–143)

## Statement

> **M5 — Cassaigne's identity fails exactly in the decay regime — and the mediator's proposed correction was wrong.** For 1/π, N=1400, `p(L+1) − p(L) = #right-special(L)` holds for every L ≤ 604 and fails for all 608 values L ∈ [792, 1399], where the right-special count is 0 but the true difference is −1. The mediator's naive finite-word fix `p(L+1) − p(L) = RS(L) − LS(L+1)` was tested and **also fails** (0 of 608).

## Hypotheses and notation

- `p(L)` is the factor complexity of the truncation `w_N`; `RS(L)` is the number of right-special factors of length `L` (those with both a `0`- and a `1`-extension inside `w_N`), and `LS(L+1)` the number of left-special factors of length `L+1`.
- The classical statement is Cassaigne's first-difference identity `p(L+1) − p(L) = #right-special(L)`, valid for an extendable (uniformly recurrent / one-sided extendable) language; `HANDOFF.md` §3.4 carries it as a theorem for the greedy digit word.
- Data are for `x = 1/π`, `N = 1400`, support `{2, 13, 607}`.

## Proof / evidence

The source states this without proof: it is a record of exact enumeration. The round-1 brief states the same failure and adds that the mediator's hypothesis for the loss — "factors whose only occurrence has window start `t = N − L`" — was, at the time of the brief, **not** verified (harvested as [tpp-rh40-round01-brief-m5-cassaigne-fails-decay-regime.md](tpp-rh40-round01-brief-m5-cassaigne-fails-decay-regime.md)). The repair was supplied by Agent B in round 1 and is harvested as [the exact first-difference identity p(L+1) − p(L) = RS(L) − Z(L)](tpp-rh40-readme-m5-corrected-first-difference-identity.md).

## Dependencies and related results

- [M5 — the corrected first-difference identity](tpp-rh40-readme-m5-corrected-first-difference-identity.md) — the repair of this failure.
- [Agent B (a) — the exact first-difference identity](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — B's own statement and its 18895/18895 verification.
- [Cassaigne's first-difference identity for the greedy digit word](../handoff/handoff-cassaigne-first-difference.md) — the classical identity as stated in `HANDOFF.md` §3.4.
- [Cassaigne's first-difference method for an extendable language](tpp-rh40-round01-agentb-cassaigne-extendable-language.md) — the hypothesis under which the classical form is correct.

## Notes

- **Restatement.** M5 is also stated in `round01_brief.md` §1 (harvested as [tpp-rh40-round01-brief-m5-cassaigne-fails-decay-regime.md](tpp-rh40-round01-brief-m5-cassaigne-fails-decay-regime.md)); the brief's version records the loss hypothesis as **open**, while the README records the later round-1 repair.
- The finite-word violation is expected in the source's own reading: "finitely-supported truncations are not uniformly recurrent" (Agent A's `[RECALL]`).
