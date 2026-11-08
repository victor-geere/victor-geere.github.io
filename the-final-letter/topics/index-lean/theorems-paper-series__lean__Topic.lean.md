# `theorems-paper-series/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`theorems-paper-series`](../theorems-paper-series/README.md)

### [`theorems-paper-series/lean/Topic.lean`](../theorems-paper-series/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [56](../theorems-paper-series/lean/Topic.lean#L56) | theorem | `alpha_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{alpha}\ n$ |
| [61](../theorems-paper-series/lean/Topic.lean#L61) | theorem | `alpha_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{alpha}$ |
| [71](../theorems-paper-series/lean/Topic.lean#L71) | theorem | `run_le_self` | $\forall\,x : \mathbb{Q},\ \forall\,N : \mathbb{N},\ \mathrm{run}\ x\ N\le\ x$ |
| [83](../theorems-paper-series/lean/Topic.lean#L83) | theorem | `run_nonneg` | $\forall\,x : \mathbb{Q},\ \forall\,hx : 0\le\ x,\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{run}\ x\ N$ |
| [95](../theorems-paper-series/lean/Topic.lean#L95) | theorem | `run_eq_sub_selected` | $\forall\,x : \mathbb{Q},\ \forall\,N : \mathbb{N},\ \mathrm{run}\ x\ N=x-\mathrm{selectedWeight}\ \mathrm{alpha}\ x\ N$ |
| [118](../theorems-paper-series/lean/Topic.lean#L118) | theorem | `selected_add_rejected` | $\forall\,w : \mathbb{N}\to\ \mathbb{Q},\ \forall\,x : \mathbb{Q},\ \forall\,N : \mathbb{N},\ \mathrm{selectedWeight}\ w\ x\ N+\mathrm{rejectedWeight}\ w\ x\ N=\mathrm{totalWeight}\ w\ N$ |
| [127](../theorems-paper-series/lean/Topic.lean#L127) | theorem | `gdst_pi_example` | $:\mathrm{run}\ 1\ 5=0\ \land\ \mathrm{selectedWeight}\ \mathrm{alpha}\ 1\ 5=1$ |
