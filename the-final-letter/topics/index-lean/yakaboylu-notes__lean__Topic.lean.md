# `yakaboylu-notes/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`yakaboylu-notes`](../yakaboylu-notes/README.md)

### [`yakaboylu-notes/lean/Topic.lean`](../yakaboylu-notes/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [47](../yakaboylu-notes/lean/Topic.lean#L47) | theorem | `abs_R_le_S` | $\forall\,\sigma\,t : \mathbb{R},\ \forall\,N : \mathbb{N},\ \vert{}R\ \sigma\ t\ N\vert\le\ S\ \sigma\ N$ |
| [67](../yakaboylu-notes/lean/Topic.lean#L67) | theorem | `R_ne_one_of_S_lt_one` | $\forall\,\sigma\,t : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,h : S\ \sigma\ N<1,\ R\ \sigma\ t\ N\ne\ 1$ |
| [76](../yakaboylu-notes/lean/Topic.lean#L76) | theorem | `S_lt_S` | $\forall\,\sigma_{1}\,\sigma_{2} : \mathbb{R},\ \forall\,h : \sigma_{1}<\sigma_{2},\ \forall\,N : \mathbb{N},\ \forall\,hN : 2\le\ N,\ S\ \sigma_{2}\ N<S\ \sigma_{1}\ N$ |
| [91](../yakaboylu-notes/lean/Topic.lean#L91) | theorem | `S_pos` | $\forall\,N : \mathbb{N},\ \forall\,hN : 2\le\ N,\ \forall\,\sigma : \mathbb{R},\ 0<S\ \sigma\ N$ |
| [104](../yakaboylu-notes/lean/Topic.lean#L104) | theorem | `S_zero` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ S\ 0\ N=(N:\mathbb{R})-1$ |
| [115](../yakaboylu-notes/lean/Topic.lean#L115) | theorem | `weight_odd` | $\forall\,t : \mathbb{R},\ \mathrm{weight}(-t)=-\mathrm{weight}\ t$ |
| [123](../yakaboylu-notes/lean/Topic.lean#L123) | theorem | `weight_pos` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ 0<\mathrm{weight}\ t$ |
