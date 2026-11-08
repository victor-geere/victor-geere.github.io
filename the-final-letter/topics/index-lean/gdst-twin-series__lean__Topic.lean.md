# `gdst-twin-series/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`gdst-twin-series`](../gdst-twin-series/README.md)

### [`gdst-twin-series/lean/Topic.lean`](../gdst-twin-series/lean/Topic.lean) — 6 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [49](../gdst-twin-series/lean/Topic.lean#L49) | theorem | `term_pos` | $\forall\,n : \mathbb{N},\ \forall\,s : \mathbb{R},\ 0<\mathrm{term}\ n\ s$ |
| [54](../gdst-twin-series/lean/Topic.lean#L54) | theorem | `selected_nonneg` | $\forall\,\delta : \mathbb{N}\to\ \mathrm{Bool},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{selected}\ \delta\ s\ N$ |
| [64](../gdst-twin-series/lean/Topic.lean#L64) | theorem | `rejected_nonneg` | $\forall\,\delta : \mathbb{N}\to\ \mathrm{Bool},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{rejected}\ \delta\ s\ N$ |
| [75](../gdst-twin-series/lean/Topic.lean#L75) | theorem | `selected_add_rejected` | $\forall\,\delta : \mathbb{N}\to\ \mathrm{Bool},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{selected}\ \delta\ s\ N+\mathrm{rejected}\ \delta\ s\ N=\mathrm{partialZeta}\ s\ N$ |
| [84](../gdst-twin-series/lean/Topic.lean#L84) | theorem | `selected_le_partialZeta` | $\forall\,\delta : \mathbb{N}\to\ \mathrm{Bool},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{selected}\ \delta\ s\ N\le\ \mathrm{partialZeta}\ s\ N$ |
| [91](../gdst-twin-series/lean/Topic.lean#L91) | theorem | `partialZeta_zero` | $\forall\,N : \mathbb{N},\ \mathrm{partialZeta}\ 0\ N=(N:\mathbb{R})$ |
