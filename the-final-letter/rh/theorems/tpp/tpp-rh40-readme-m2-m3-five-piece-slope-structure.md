# M2/M3 — the true structure is five-piece with a non-monotone slope

**Kind:** Claim
**Status:** VERIFIED (numerical; exact enumeration at N = 1400)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M2/M3** (lines 79–95)

## Statement

> **M2/M3 — the true structure is five-piece with a non-monotone slope.** For x = 1/π, N = 1400:
>
> ```
> p(L+1) − p(L) =  1   for L ∈ [1, 10]      (p(L) = L + 1 on 1 ≤ L ≤ 11)
>               =  2   for L ∈ [11, 13]
>               =  1   for L ∈ [14, 604]    <-- the slope DECREASES back to 1
>               =  0   for L ∈ [605, 791]   <-- the plateau: p(L) = 609
>               = −1   for L ∈ [792, 1399]  <-- the right-edge decay
> ```
>
> There is **no** range with slope 3, and the slope is not monotone.

The same item also records the two boundary corrections: "the saturation plateau is exactly the 188 values **L ∈ [605, 792]** on which p(L) = 609, and the decay begins at exactly **L = N − a_m − 1 = 792**".

## Hypotheses and notation

- `p(L)` is the factor complexity of the greedy harmonic digit word at truncation length `N`; here `x = 1/π`, `N = 1400`, support `{2, 13, 607}`, so `a_m = 607`.
- `p(L+1) − p(L)` is the first difference (the "slope"); the source computes it from the exact offset-tuple enumeration in `rh40/code/digitword.py` (`slopes`).
- `L` ranges over `1 ≤ L ≤ N − 1`.

## Proof / evidence

The source states this without proof: it is a record of exact enumeration. The README's §5 "Reproduced exactly in this session" list confirms that the same run reproduces the §3.1 table and the four plateau values; the round-1 brief states the identical five-piece structure (harvested as [tpp-rh40-round01-brief-m2-five-piece-slope-structure.md](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md)), and Agent A's `slopes((2,13,607),1400)` output is the run list `[(1,10,1),(11,13,2),(14,604,1),(605,791,0),(792,1399,−1)]` (see [tpp-rh40-round01-agenta-slope-structure-1-over-pi.md](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md)).

## Dependencies and related results

- [M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the exact ranges and the four-word verification.
- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the value 609 read off the plateau.
- [M1 — HANDOFF.md §3.1's closed forms are false](tpp-rh40-readme-m1-piecewise-closed-forms-refuted.md) — the law this structure replaces.
- [Theorem A (the large-L regime)](tpp-rh40-k1-theorem-a-large-l-regime.md) and [Theorem B (the plateau)](tpp-rh40-k1-theorem-b-plateau.md) — the later proof covering the large-`L` part of this picture.

## Notes

- **Restatement.** The five-piece structure is also M2 of `round01_brief.md` (harvested as [tpp-rh40-round01-brief-m2-five-piece-slope-structure.md](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md)). The brief's own numbering of the plateau interval (`[605, 791]`, 187 values) is corrected by Agent B and by this README to `[605, 792]` (188 values); see [tpp-rh40-round01-agentb-plateau-decay-boundary.md](tpp-rh40-round01-agentb-plateau-decay-boundary.md).
- The source's §4 preamble warns that the handoff's §3.1 law "had already [been] recorded ... as 'partly true, over-extrapolated'", while §3.1 "nevertheless prints it as *the* law".
