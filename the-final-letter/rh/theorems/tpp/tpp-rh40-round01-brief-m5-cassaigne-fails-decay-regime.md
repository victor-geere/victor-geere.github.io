# M5 — Cassaigne's identity fails in the decay regime, and only there

**Kind:** Claim
**Status:** REFUTED (numerical; the identity fails for all 608 values L ∈ [792, 1399] and the naive left-special correction fails there too, 0 of 608; the mediator's loss hypothesis is stated as NOT verified)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M5** (lines 81–90)

## Statement

> **M5 — Cassaigne's identity fails in the decay regime, and only there.** For x = 1/π, N = 1400: `p(L+1) − p(L) = #right-special(L)` holds for **every** L ≤ 604 and fails for all 608 values L ∈ [792, 1399] (the slope −1 region), where the right-special count is 0 but the true difference is −1. The finite-word form `p(L+1) − p(L) = RS(L) − LS(L+1)` was tested and **also fails** there (0 of 608 matched). Something other than a left-special correction accounts for the loss; the mediator's hypothesis is that the loss is exactly the factors whose only occurrence has window start t = N − L (windows dropping off the right edge), but this has **not** been verified. **This is the sharpest open item in the round** and is put to B directly.

## Hypotheses and notation

- `p(L)` is the factor complexity of the truncation `w_N`; `RS(L)` is the number of right-special factors of length `L`; `LS(L+1)` the number of left-special factors of length `L+1`.
- Data are for `x = 1/π`, `N = 1400`, support `{2, 13, 607}`; the "slope −1 region" is `L ∈ [792, 1399]`.
- The mediator's hypothesis identifies the loss with "the factors whose only occurrence has window start `t = N − L` (windows dropping off the right edge)"; the brief marks it **not verified**.

## Proof / evidence

The source states this as a record of exact recomputation; the failure counts (608 values; 0 of 608 for the naive form) are the certificate. The hypothesis for the loss is explicitly left unverified and handed to Agent B as the round's task (a). The repair was supplied in round 1 and is harvested as [the exact finite first-difference identity p(L+1) − p(L) = RS(L) − Z(L)](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — Agent B's `[TESTED]` (a) confirms "The mediator's hypothesis is right" and sharpens it to the `Z(L) ∈ {0,1}` indicator.

## Dependencies and related results

- [Agent B (a) — the exact first-difference identity](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — the repair, and the confirmation of the hypothesis.
- [README M5 — Cassaigne's identity fails exactly in the decay regime](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md) — the README's version of the same failure.
- [README M5 — the corrected finite-word identity](tpp-rh40-readme-m5-corrected-first-difference-identity.md) — the README's record of the repair.
- [Cassaigne's first-difference method for an extendable language](tpp-rh40-round01-agentb-cassaigne-extendable-language.md) — the theorem whose extendability hypothesis fails here.

## Notes

- **Restatement.** M5 is also the README's M5 (harvested as [tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md](tpp-rh40-readme-m5-cassaigne-identity-fails-decay.md)); both restate the same round-1 computation. The brief's version is the one that records the loss hypothesis as **open**; the README, written after round 1, records the verified repair.
- The brief's phrase "and only there" is the source's own scope claim for the failure.
