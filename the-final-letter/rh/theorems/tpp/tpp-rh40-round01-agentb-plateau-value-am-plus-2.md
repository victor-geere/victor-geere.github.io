# On the plateau p(L) = a_m+2, and max p = a_m+2 for every support with N ≥ 2a_m+3

**Kind:** Claim
**Status:** VERIFIED (numerical; 255/255 N = 20 words and 744/744 random supports, zero counterexamples; the source records that the a_m+2 form still lacks a proof)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md`](../../research/twin-prime-parity/rounds/rh40/rounds/round01_agentB.md) — §"[CHARITABLE]" (iii), §"[TESTED]" (c), §"[VERDICT]", §"[OPEN]", lines 19–25, 61–65, 79–89

## Statement

> (iii) On the plateau p(L)=a_m+2, fixed by the last one alone (so §3.3's "609=605+4 and also 607+2" is the second reading), and p is not eventually constant at fixed N.
>
> …
>
> Positive law: max p = a_m+2 for every support with N>=2a_m+3 - 255/255 N=20 words and 744/744 random supports (N<=300), zero counterexamples - giving 609, 6071, 253, 82, 55. So the plateau value is a_m+2, a function of a_m alone (equivalently, of the gaps together with a_0).
>
> …
>
> STANDING: the corrected identity p(L+1)-p(L)=RS(L)-Z(L) and the plateau/decay laws p=a_m+2 and p=N-L+1 are exactly verified (the a_m+2 form still lacks a proof) …
>
> Ask A to prove that on the plateau the map (first-1 index, offset) -> factor is injective and all a_m+1 non-empty pairs realise, hence p(L)=a_m+2 whenever N>=2a_m+3 - or to exhibit the smallest support (with N>=2a_m+3) where it fails; my 999 tested supports found none.

## Hypotheses and notation

- `w_N` is a finitely supported word with ones `a_0 < … < a_m < N`; `p(L)` is its number of distinct length-`L` factors; the plateau is the interval on which `p` is constant at its maximum.
- The positive verification is for supports satisfying `N >= 2a_m + 3`; the values `609, 6071, 253, 82, 55` are the plateau values of the five test words of §"[TESTED]" (a) (with the fifth, `55`, for the true `e-2` word `(0,3,53)` at `N = 2000`, where `a_m + 2 = 55`).
- "`p` is not eventually constant at fixed `N`" is part of the same repair: the README's five-piece structure shows `p` decaying on the right edge rather than sticking at its maximum.

## Proof / evidence

The source states this as exact enumeration: "255/255 N=20 words and 744/744 random supports (N<=300), zero counterexamples". It does **not** prove the general form; its `[VERDICT]` says "the `a_m+2` form still lacks a proof", and its `[OPEN]` asks A to prove the injectivity of the map (first-1 index, offset) → factor and the realisation of all `a_m+1` non-empty pairs, noting "my 999 tested supports found none" failing. The proof of the form for the large-`L` regime is supplied later in `K1_plateau_theorem.md` (harvested as [Theorem B](tpp-rh40-k1-theorem-b-plateau.md)).

## Dependencies and related results

- [The (i,x) repair of the window starts](tpp-rh40-round01-agentb-i-x-repair-realisable-window-starts.md) — the structural statement whose injectivity `[OPEN]` asks for.
- [The plateau value is not determined by (m, span, N)](tpp-rh40-round01-agentb-plateau-not-determined-by-m-span-n.md) — the companion non-determinacy result.
- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the README's statement of the same law.
- [Theorem B (the plateau, = C2a)](tpp-rh40-k1-theorem-b-plateau.md) — the later proof for `max(span, a_m+1) ≤ L ≤ N−a_m−1`.

## Notes

- The source's own `[VERDICT]` is quoted in full in the Statement so that the "still lacks a proof" hedge cannot be lost.
- The parenthetical "(so §3.3's '609=605+4 and also 607+2' is the second reading)" records which of the handoff's two readings of 609 is the correct one: `a_m + 2 = 607 + 2`.
