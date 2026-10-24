# M3 — the saturation plateau and the decay boundary

**Kind:** Claim
**Status:** VERIFIED (numerical; all four dialogue words, exact enumeration)
**Area:** twin-prime-parity
**Source:** [`research/twin-prime-parity/rounds/rh40/README.md`](../../research/twin-prime-parity/rounds/rh40/README.md) — §4 "Corrections established at programme open", item **M2/M3** (lines 90–103)

## Statement

> The saturation plateau is exactly the 188 values **L ∈ [605, 792]** on which p(L) = 609, and the decay begins at exactly **L = N − a_m − 1 = 792**, where p(L) = N − L + 1 = 609 — so the decay law holds on the closed range **L ∈ [792, N − 1]**, verified for every one of the four dialogue words:
>
> | word | N | a_m | `p(L) = N − L + 1` holds on | begins at L = N − a_m − 1 |
> |---|---|---|---|---|
> | 1/π, {2,13,607} | 1400 | 607 | [792, 1399] | 792 |
> | log 2, {0,4,36,6069} | 13000 | 6069 | [6930, 12999] | 6930 |
> | √2−1, {1,11,251} | 2000 | 251 | [1748, 1999] | 1748 |
> | e−2, {10,20,40,80} | 500 | 80 | [419, 499] | 419 |
>
> and it holds contiguously all the way to L = N − 1, where p = 2.

## Hypotheses and notation

- `0 ≤ a_0 < … < a_m < N` is the support of the truncation `w_N`; `p(L)` is its number of distinct length-`L` factors.
- `N` is the truncation length and `L` the factor length, `1 ≤ L ≤ N − 1`.
- The four "dialogue words" are the supports listed in the table, computed from `x = 1/π`, `log 2`, `√2−1` and the word labelled `e−2`. **The last of these is a mislabel**: Agent B's round-1 misattribution flag records that `(10,20,40,80)`, `N = 500` is "not e-2 — the true greedy word for e-2 at N=2000 is (0,3,53)" (see [tpp-rh40-round01-agentb-e-minus-2-mislabel.md](tpp-rh40-round01-agentb-e-minus-2-mislabel.md)). This file reproduces the README's table under the README's own label.
- `N − a_m − 1` is the decay boundary; the README's earlier text in §4 mislabels the onset in one place, and the round-1 brief's M3 states it as `N − a_m` (later corrected; see Notes).

## Proof / evidence

The source states this without proof: it is an exact-enumeration record. The README attributes the plateau end and the decay law to the round-1 verification and to Agent B's audit; the same law is proved for the large-`L` regime in `rh40/K1_plateau_theorem.md` (harvested as [Theorem A](tpp-rh40-k1-theorem-a-large-l-regime.md) and [Theorem B](tpp-rh40-k1-theorem-b-plateau.md)), which gives `p(L) = N − L + 1` on `[N − a_m − 1, N − 1]` (sub-target **C2b**).

## Dependencies and related results

- [Plateau value = a_m + 2](tpp-rh40-readme-plateau-value-am-plus-2.md) — the value held on the plateau.
- [M2/M3 — five-piece slope structure](tpp-rh40-readme-m2-m3-five-piece-slope-structure.md) — the slope list this boundary sits in.
- [Theorem A (the large-L regime)](tpp-rh40-k1-theorem-a-large-l-regime.md), [Theorem B (the plateau)](tpp-rh40-k1-theorem-b-plateau.md), [Corollary 3 (decay)](tpp-rh41-truths-corollary-3-decay.md) — the proofs and the later restatement.
- [Agent B (b) — plateau and decay crossover](tpp-rh40-round01-agentb-plateau-decay-boundary.md) — the off-by-one corrections in detail.

## Notes

- **Restatement.** The brief's M3 states "the saturation plateau boundary is exactly L = N − a_m" and "decay start = N − a_m + 1"; Agent B's round-1 audit corrects this: for `{2,13,607}`, `N = 1400`, `N − a_m = 793`, while the boundary is `N − a_m − 1 = 792`. The README's §4 text uses the corrected form. See [tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md](tpp-rh40-round01-brief-m3-plateau-boundary-n-minus-a-m.md) (status REFUTED) and [tpp-rh40-round01-agentb-plateau-decay-boundary.md](tpp-rh40-round01-agentb-plateau-decay-boundary.md).
- The README's table labels the fourth word "e−2"; per Agent B this word is a mislabel for the support `(10,20,40,80)`, `N = 500`. The numbers are the ones actually measured on that support and are preserved verbatim.
