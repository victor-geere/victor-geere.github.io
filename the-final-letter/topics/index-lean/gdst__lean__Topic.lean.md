# `gdst/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`gdst`](../gdst/README.md)

### [`gdst/lean/Topic.lean`](../gdst/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [73](../gdst/lean/Topic.lean#L73) | theorem | `delta_zero_or_one` | $\forall\,x : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{delta}\ x\ n=0\ \lor\ \mathrm{delta}\ x\ n=1$ |
| [83](../gdst/lean/Topic.lean#L83) | theorem | `rem_nonneg` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ \forall\,n : \mathbb{N},\ 0\le\ \mathrm{rem}\ x\ n$ |
| [101](../gdst/lean/Topic.lean#L101) | theorem | `rem_bound` | $\forall\,x : \mathbb{R},\ \forall\,hx_{1} : x\le\ 1,\ \forall\,n : \mathbb{N},\ \mathrm{rem}\ x\ n\le((n:\mathbb{R})+2)^{-1}$ |
| [140](../gdst/lean/Topic.lean#L140) | theorem | `finite_identity` | $\forall\,x : \mathbb{R},\ \forall\,N : \mathbb{N},\ x=(\sum\ k\ \in\ \mathrm{Finset.range}(N+1),(\mathrm{delta}\ x\ k:\mathbb{R})/((k:\mathbb{R})+2))+\mathrm{rem}\ x\ N$ |
| [164](../gdst/lean/Topic.lean#L164) | theorem | `rem_after_selection` | $\forall\,x : \mathbb{R},\ \forall\,hx_{1} : x\le\ 1,\ \forall\,n : \mathbb{N},\ \forall\,hsel : \mathrm{delta}\ x(n+1)=1,\ \mathrm{rem}\ x(n+1)\le(((n:\mathbb{R})+2)\cdot((n:\mathbb{R})+3))^{-1}$ |
| [183](../gdst/lean/Topic.lean#L183) | theorem | `selected_add_rejected` | $\forall\,x : \mathbb{R},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{selectedWeight}\ x\ s\ N+\mathrm{rejectedWeight}\ x\ s\ N=\mathrm{dirichletPrefix}\ s\ N$ |
| [192](../gdst/lean/Topic.lean#L192) | theorem | `selected_rejected_nonneg` | $\forall\,x : \mathbb{R},\ \forall\,s : \mathbb{R},\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{selectedWeight}\ x\ s\ N\ \land\ 0\le\ \mathrm{rejectedWeight}\ x\ s\ N$ |
