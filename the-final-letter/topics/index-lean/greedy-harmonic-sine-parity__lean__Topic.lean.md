# `greedy-harmonic-sine-parity/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`greedy-harmonic-sine-parity`](../greedy-harmonic-sine-parity/README.md)

### [`greedy-harmonic-sine-parity/lean/Topic.lean`](../greedy-harmonic-sine-parity/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [55](../greedy-harmonic-sine-parity/lean/Topic.lean#L55) | theorem | `liouville_sq` | $\forall\,n : \mathbb{N},\ \mathrm{liouville}\ n^{2}=1$ |
| [63](../greedy-harmonic-sine-parity/lean/Topic.lean#L63) | theorem | `corr_abs_le` | $\forall\,h\,N : \mathbb{N},\ \vert{}\mathrm{corr}\ h\ N\vert\le(N:\mathbb{Z})$ |
| [86](../greedy-harmonic-sine-parity/lean/Topic.lean#L86) | theorem | `corr_zero` | $\forall\,N : \mathbb{N},\ \mathrm{corr}\ 0\ N=(N:\mathbb{Z})$ |
| [97](../greedy-harmonic-sine-parity/lean/Topic.lean#L97) | theorem | `slice_agree` | $\forall\,a\,n : \mathbb{N},\ \forall\,hn : n<a,\ \mathrm{liouvilleSlice}\ a\ n=\mathrm{liouville}\ n$ |
| [104](../greedy-harmonic-sine-parity/lean/Topic.lean#L104) | theorem | `corrSlice_eq_corr_of_lt` | $\forall\,h\,a\,N : \mathbb{N},\ \forall\,hN : N+h<a,\ \mathrm{corrSlice}\ h\ a\ N=\mathrm{corr}\ h\ N$ |
| [117](../greedy-harmonic-sine-parity/lean/Topic.lean#L117) | theorem | `corrSliceSqSub` | $\forall\,a\,N : \mathbb{N},\ \forall\,ha : 1\le\ a,\ \forall\,haN : a\le\ N,\ \sum\ n\ \in\ \mathrm{Finset.Icc}\ 1\ N,(\mathrm{liouvilleSlice}\ a\ n-\mathrm{liouville}\ n)^{2}=4$ |
| [139](../greedy-harmonic-sine-parity/lean/Topic.lean#L139) | theorem | `shiftProd_two_five` | $:\mathrm{shiftProd}\ 2(5\cdot\ 5)\ne\ \mathrm{shiftProd}\ 2\ 5\cdot\ \mathrm{shiftProd}\ 2\ 5$ |
