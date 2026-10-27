# M2 — the true slope structure for x = 1/π, N = 1400 is five-piece

**Kind:** Claim
**Status:** VERIFIED (numerical; exact enumeration, with two later-corrected boundary details)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M2** (lines 53–66)

## Statement

> **M2 — the true slope structure for x = 1/π, N = 1400 is five-piece, and the maximum is attained on a plateau, not at a point:**
>
> ```
> p(L+1) - p(L) = 1   for 1 <= L <= 10      (p(L) = L + 1   on 1 <= L <= 11)
> p(L+1) - p(L) = 2   for 11 <= L <= 13     (p(12) = 14, p(13) = 16, p(14) = 18)
> p(L+1) - p(L) = 1   for 14 <= L <= 604    (p(15) = 19 ... p(605) = 609)
> p(L+1) - p(L) = 0   for 605 <= L <= 791   (p(L) = 609, the saturation plateau)
> p(L+1) - p(L) = -1  for 792 <= L <= 1399  (the right-edge decay)
> ```
>
> Note the **non-monotone slope**: 1 → 2 → **back to 1** → 0 → −1. There is no range where the slope is 3. The plateau runs over the 187 values L ∈ [605, 791], and the decay begins at exactly L = N − a_m = 792.

## Hypotheses and notation

- The word is the greedy harmonic digit word at `x = 1/π`, `N = 1400`, support `{2, 13, 607}`, so `a_m = 607`.
- `p(L)` is the number of distinct length-`L` factors of the truncation; the blocks list `p(L+1) − p(L)` over each range of `L`.
- The stated instance values are `p(12) = 14`, `p(13) = 16`, `p(14) = 18`, `p(15) = 19`, `p(605) = 609`.

## Proof / evidence

The source states this as exact recomputation by the mediator ("with exact integer arithmetic (`rh40/code/digitword.py`, `rh40/verify/probes.py`)"). The README reproduces the same five-piece structure (harvested as [tpp-rh40-readme-m2-m3-five-piece-slope-structure.md](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md)), and Agent A's `slopes((2,13,607),1400)` returns the matching run list `[(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,−1)]` (harvested as [tpp-rh40-round01-agenta-slope-structure-1-over-pi.md](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md)).

## Dependencies and related results

- [README M2/M3 — the true five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the README's version, with the corrected plateau interval.
- [M3 — the saturation plateau boundary is exactly L = N − a_m](tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md) — the companion boundary claim, later refuted.
- [Agent B (b) — the plateau and the decay crossover](tpp-rh40-round01-agentb-plateau-decay-boundary.md) — the corrections in detail.
- [Agent A (b) — the slope structure](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) — the same run list.

## Notes

- **Restatement.** M2 is also the README's M2/M3 (harvested as [tpp-rh40-readme-m2-m3-five-piece-slope-structure.md](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md)); both restate the same round-1 computation.
- **Later corrections to two details of the last sentence.** (1) The plateau is the 188 values `L ∈ [605, 792]`, not the 187 values `[605, 791]` — the brief itself records the decay as beginning at `792`, so `792` is on the plateau. (2) The label `L = N − a_m = 792` is off by one: `N − a_m = 793`, while the boundary is `N − a_m − 1 = 792`. See the README's M2/M3 and Agent B's `[TESTED]` (b). The slope values themselves stand.
