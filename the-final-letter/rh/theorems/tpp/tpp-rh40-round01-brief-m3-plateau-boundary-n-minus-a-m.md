# M3 — the saturation plateau boundary is exactly L = N − a_m

**Kind:** Claim
**Status:** REFUTED (numerical; off by one — the boundary is L = N − a_m − 1, as Agent B's round-1 audit records)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_brief.md) — §1 "Mediator's own findings from this session (recomputed, standing)", item **M3** (lines 68–74)

## Statement

> **M3 — the saturation plateau boundary is exactly L = N − a_m.** For L ≥ N − a_m every window start t satisfies t + L − 1 ≥ N − 1 ≥ a_m, so every window contains the last 1, the first 1 in the window is some a_i with no further 1 after it inside the window only if i = m — and the left-special/right-special balance flips. Plateau start = N − a_m; decay start = N − a_m + 1 is where windows lose the last 1 entirely. Verified for all four dialogue words (M2 plus `probes.py` probe 1).

## Hypotheses and notation

- `w_N` is the finitely supported word with ones `a_0 < … < a_m < N`; `p(L)` is its number of distinct length-`L` factors; window starts `t` satisfy `0 ≤ t ≤ N − L`.
- The claim asserts that the saturation plateau boundary — explicitly "Plateau start" — is `L = N − a_m`, and that decay starts at `N − a_m + 1`.
- The four dialogue words are `1/π {2,13,607} N = 1400`, `log 2 {0,4,36,6069} N = 13000`, `√2−1 {1,11,251} N = 2000`, and the word labelled `e−2 (10,20,40,80) N = 500`.

## Proof / evidence

The source offers the sketched argument quoted above ("every window contains the last 1 … the left-special/right-special balance flips") and reports it "Verified for all four dialogue words (M2 plus `probes.py` probe 1)". The correction is recorded by Agent B in round 1: "The brief's [605,791] misses L=792, and 'decay begins at N-a_m=792' is off by one: N-a_m=793=1400-607, while 792=N-a_m-1" (harvested as [tpp-rh40-round01-agentb-plateau-decay-boundary.md](tpp-rh40-round01-agentb-plateau-decay-boundary.md)), and the README's §4 states the boundary as `L = N − a_m − 1` (harvested as [tpp-rh40-readme-m3-plateau-and-decay-boundary.md](tpp-rh40-readme-m3-plateau-and-decay-boundary.md)).

## Dependencies and related results

- [README M3 — the plateau and the decay boundary](tpp-rh40-readme-m3-plateau-and-decay-boundary.md) — the corrected statement.
- [Agent B (b) — the plateau and the decay crossover](tpp-rh40-round01-agentb-plateau-decay-boundary.md) — the correction with the exact ranges.
- [M2 — the five-piece slope structure](tpp-rh40-round01-brief-m2-five-piece-slope-structure.md) — the slope structure this boundary belongs to.
- [Agent A (b) — the slope structure](tpp-rh40-round01-agenta-slope-structure-1-over-pi.md) — Agent A repeats the same `L = N − a_m` mislabel.

## Notes

- Status REFUTED is recorded for the boundary *identification* as printed: for `{2,13,607}`, `N = 1400`, the plateau is `L ∈ [605, 792]` (188 values) and the decay begins at `792 = N − a_m − 1`, not at `N − a_m = 793`. The qualitative mechanism the source sketches (every window contains the last 1 for large `L`; the special-factor balance flips) is not itself refuted.
- The brief's M3 is superseded within the same round; the README's §4 prints the corrected `N − a_m − 1` form.
