# (c) Decay law p(L) = N−L+1 for L ≥ N−a_m, and the plateau value a_m+2

**Kind:** Claim
**Status:** VERIFIED (numerical; 607 values L = 792..1399, 0 violations, for {2,13,607}, N = 1400)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentA.md) — §"[COMPUTABLE]", item (c), lines 62–65

## Statement

> **(c)** Decay law, exact: `p(L) = N−L+1` for all `L ≥ N−a_m`. Verified for
> `{2,13,607},N=1400`: `L=792..1399`, **607 values, 0 violations**. Plateau value:
> **`a_m+2`** — `p(605)=p(606)=p(791)=p(792)=609 = 607+2`; `{0,4,36,6069}`:
> 6069+2 = 6071 ✓.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the truncation `w_N`; `p(L)` is the number of distinct length-`L` factors.
- The decay law is stated for `L ≥ N − a_m`; the verification range actually printed is `L = 792..1399` for `N = 1400`, `a_m = 607` (and `792 = N − a_m − 1`).
- The plateau value is `a_m + 2`; the printed instances are `p(605) = p(606) = p(791) = p(792) = 609 = 607 + 2` and `6069 + 2 = 6071` for the support `{0,4,36,6069}`.

## Proof / evidence

The source states this as an exact computation (`p_offset`) over the listed ranges; no proof is given, and the statement is a numerical verification. The README records the same laws with the corrected decay boundary `L = N − a_m − 1` on the closed range `[N − a_m − 1, N − 1]` for all four dialogue words (harvested as [tpp-rh40-readme-m3-plateau-and-decay-boundary.md](tpp-rh40-readme-m3-plateau-and-decay-boundary.md)), and Agent B confirms `p(L) = 609` on exactly `L ∈ [605, 792]` (188 values) and `p(L) = N − L + 1` on exactly `L ∈ [792, 1400]` (609 values) (harvested as [tpp-rh40-round01-agentb-plateau-decay-boundary.md](tpp-rh40-round01-agentb-plateau-decay-boundary.md)). The `a_m + 2` plateau value is proved for the large-`L` regime in `K1_plateau_theorem.md` (harvested as [Theorem B](tpp-rh40-k1-theorem-b-plateau.md)); at the time of this agent file it was verified only.

## Dependencies and related results

- [M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the README's corrected statement of both laws.
- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the README's statement of the plateau value.
- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) and [Corollary 3 (decay)](tpp-rh41-truths-corollary-3-decay.md) — the proofs.
- [Agent A (b) — the slope structure](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) — the run list in which these ranges appear.

## Notes


- The plateau instances `p(605) = p(606) = p(791) = p(792) = 609` are the source's own; `609 = 607 + 2` with `a_m = 607`.
- The verification range `L = 792..1399` begins one below the stated hypothesis `L ≥ N − a_m = 793`; both the hypothesis and the printed range are preserved verbatim.
- **Correction to a correction (session-003 audit, 2025-10-06).** The `evidence absent` qualifier that briefly stood here was **false** and has been reversed: a committed artefact does compute the numbers above — `research/twin-prime-parity/rounds/rh40/verify/verify_agentB.output.txt`. The qualifier was assigned by a mechanical rule that looked only at this document and at the source it was harvested from, and only for artefact names, so it missed evaluators kept elsewhere in the tree. The original label is restored, unqualified. See `AUDIT-verification-labels-002.md` §6.
