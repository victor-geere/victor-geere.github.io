# The plateau/decay boundary is L = N−a_m−1, not N/2 (and the two off-by-one corrections)

**Kind:** Claim
**Status:** VERIFIED (numerical; exact ranges for 1/pi, N = 1400)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[CHARITABLE]" (ii) and §"[TESTED]" (b), lines 17–19 and 54–57

## Statement

> (ii) The plateau/decay boundary is L=N-a_m-1, not "N/2": for sqrt2-1 the plateau reaches L=1748=0.874N.
>
> …
>
> (b) p(L)=609 on exactly L in [605,792] (188 values), nowhere else; p(L)=N-L+1 on exactly L in [792,1400] (609 values): 792->609, 793->608, 799->602, 800->601, 1399->2. The brief's [605,791] misses L=792, and "decay begins at N-a_m=792" is off by one: N-a_m=793=1400-607, while 792=N-a_m-1.

## Hypotheses and notation

- `w_N` is the finitely supported word with ones `a_0 < … < a_m < N`; here `1/pi (2,13,607)`, `N = 1400`, `a_m = 607`.
- `p(L)` is the number of distinct length-`L` factors; the decay law is `p(L) = N − L + 1`.
- The correction has two parts: (1) the plateau ends at `L = N − a_m − 1` (so the brief's closed interval `[605,791]` should be `[605,792]`, 188 values, not 187); (2) "decay begins at `N−a_m`" is off by one — `N − a_m = 793` while the boundary is `792 = N − a_m − 1`.
- The `sqrt2-1` instance: "for sqrt2-1 the plateau reaches `L=1748=0.874N`" (support `(1,11,251)`, `N = 2000`).

## Proof / evidence

The source states this as an exact computation from `rh40/code/digitword.py`, with the boundary values `792->609, 793->608, 799->602, 800->601, 1399->2` printed as the certificate. The README independently records the corrected boundary `L = N − a_m − 1 = 792` and the decay law on the closed range `L ∈ [792, N − 1]` for all four dialogue words (harvested as [tpp-rh40-readme-m3-plateau-and-decay-boundary.md](tpp-rh40-readme-m3-plateau-and-decay-boundary.md)). The round-1 brief's original wording is harvested as [tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md](tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md) (status REFUTED).

## Dependencies and related results

- [M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the README's corrected statement.
- [round01-brief M3 — the saturation plateau boundary is exactly L = N − a_m](tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md) — the statement this file corrects.
- [Agent A (b) — the slope structure](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) — the same `L = N − a_m` mislabel.
- [Corollary 3 (decay)](tpp-rh41-truths-corollary-3-decay.md) — the later proof of the decay law on `[N − a_m − 1, N − 1]`.

## Notes

- Both corrections are off-by-one in the direction of *extending* the plateau and *starting* the decay one step earlier; they were first recorded by Agent B against the brief (M3) and the README's earlier text.
- The statement "the plateau reaches `L=1748=0.874N`" is the source's own evidence that the boundary is not `N/2`.
