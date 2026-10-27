# The (i,x) repair: exactly which window starts realise (i, x) as the first 1 of the factor

**Kind:** Proposition
**Status:** **SETTLED with corrections (2026-10-11 attack; components Lean; OP-37).** (a) realisability **PROVED**: realised `(i,x)` = `max(0,a_i−(N−L)) ≤ x ≤ min(d_{i−1}−1,a_i,L−1)`; (b) the source's all-zero criterion `L ≤ N−a_m−1` is **REFUTED** by `((0,4),N=6,L=3)`, corrected form `L ≤ max(a_0, max_j(d_j−1), N−1−a_m)` **PROVED** (source wrong on 24 337/95 826 cases); (c) the source's injectivity claim is **REFUTED** by `((12,20),N=26,L=12)`, corrected form `p(L) ≥ a_m+2 ⟹ injective` **PROVED with no `N`-hypothesis**, machine-checked as `Rh40.injOn_of_card_ge` (`rounds/rh40/lean/Rh40/Plateau.lean`, 2/2 green). The plateau *value* `max p = a_m+2` stays unproved. See `research/attacks/OP-34-36-37-35.md`.
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[CHARITABLE]", lines 20–25

## Statement

> The (i,x) repair of §7.2: for L>span the factor whose first 1 is a_i at offset x=a_i-t is the tail {x+(a_j-a_i): j>=i}, and the realisable pairs are exactly those with 0<=x<=min(d_{i-1}-1,a_i,L-1) (convention d_{-1}=infinity) and a_i-x<=N-L; the all-zero factor occurs iff L<=N-a_m-1. On the plateau these tails are distinct, which is why p=a_m+2.

## Hypotheses and notation

- `w_N` is a finitely supported word with ones `a_0 < … < a_m < N` (`m >= 1`); `d_i = a_{i+1} − a_i` are the gaps, with the convention `d_{-1} = infinity`; `span = a_m − a_0`.
- The classification is by the index `i` of the **first 1** of the factor and its offset `x` from the window start `t`: `x = a_i − t`.
- "For `L > span`" is the regime in which the source states the tail description.
- The claimed realisability conditions are `0 <= x <= min(d_{i-1} − 1, a_i, L − 1)` together with `a_i − x <= N − L`; the three bounds come from the window's left edge (no earlier 1 in the window), the window start being non-negative, and the window length.
- The final sentence — "On the plateau these tails are distinct, which is why `p=a_m+2`" — is the injectivity statement that `[OPEN]` asks A to prove.

## Proof / evidence

The source presents this as the precise repair of the structural characterisation (`[CHARITABLE]`: "Repaired C2, precisely"), with the realisability constraints stated as exact. It does **not** supply a separate written derivation or a numerical certificate for the `(i, x)` statement itself; the numerical verification in `[TESTED]` (c) covers the consequence `max p = a_m+2` for supports with `N>=2a_m+3`, and `[OPEN]` explicitly leaves the injectivity half unproved: "Ask A to prove that on the plateau the map (first-1 index, offset) -> factor is injective and all a_m+1 non-empty pairs realise".

## Dependencies and related results

- [On the plateau p(L) = a_m+2](tpp-rh40-round01-agentb-plateau-value-am-plus-2.md) — the consequence and its 999-support verification.
- [The exact finite first-difference identity](tpp-rh40-round01-agentb-exact-first-difference-identity.md) — the other half of the same `[CHARITABLE]` repair.
- [Agent A — the window-class sum conjecture](tpp-rh40-round01-agenta-window-class-sum-conjecture.md) — the claim this repairs.
- [The exact structural characterisation of the greedy digit word](../handoff/handoff-offset-tuple-characterisation.md) — the offset-tuple ground truth that `x = a_i − t` uses.

## Notes

- **Status corrected, 2025-10-06 (session 003, audit repair 1/5).** This document carried `PROVED (paper argument)` although its own source does not prove it: `rounds/rh40/rounds/round01_agentB.md:80` reads *"the a_m+2 form still lacks a proof"* and :84 asks A to prove precisely the plateau injectivity used here; the passage is marked `[CHARITABLE]` (a charitable restatement of Agent A's claim, not a derivation). Demoted to `OPEN`. The realisability constraints and the all-zero-factor criterion remain *stated* by the source; what is missing is the injectivity half, hence `p = a_m+2` on the plateau.
- The statement is given in the source's `[CHARITABLE]` role, i.e. as the strongest precise form of Agent A's claim after repair; the source records no machine check of this `(i, x)` statement in isolation.
