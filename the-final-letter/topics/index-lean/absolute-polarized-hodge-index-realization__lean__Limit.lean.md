# `absolute-polarized-hodge-index-realization/lean/Limit.lean`

[Back to the split index](index.md) · Topic: [`absolute-polarized-hodge-index-realization`](../absolute-polarized-hodge-index-realization/README.md)

### [`absolute-polarized-hodge-index-realization/lean/Limit.lean`](../absolute-polarized-hodge-index-realization/lean/Limit.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [21](../absolute-polarized-hodge-index-realization/lean/Limit.lean#L21) | theorem | `limit_well_defined` | $\forall\,hmono : \forall\ n\ m:\mathbb{N},\ n\le\ m\to\ V\ n\le\ V\ m,\ \forall\,hcompat : \forall(n\ m:\mathbb{N})(h:n\le\ m)(v:V\ n),\ Q\ m\ \langle{}v.\mathrm{1},\ \mathrm{hmono}\ n\ m\ h\ v.\mathrm{2}\rangle=Q\ n\ v,\ \forall\,n\,m : \mathbb{N},\ \forall\,v : V\ n,\ \forall\,w : V\ m,\ \forall\,h : v.\mathrm{1}=w.\mathrm{1},\ Q\ n\ v=Q\ m\ w$ |
| [38](../absolute-polarized-hodge-index-realization/lean/Limit.lean#L38) | theorem | `limit_nonpos` | $\forall\,hnsd : \forall\ n\ v,\ Q\ n\ v\le\ 0,\ \forall\,n : \mathbb{N},\ \forall\,v : V\ n,\ Q\ n\ v\le\ 0$ |
| [57](../absolute-polarized-hodge-index-realization/lean/Limit.lean#L57) | theorem | `limitForm_eq_level` | $\forall\,Q : (n:\mathbb{N})\to\ V\ n\to\ \mathbb{R},\ \forall\,hcompat : \forall(n\ m:\mathbb{N})(h:n\le\ m)(v:V\ n),\ Q\ m\ \langle{}v.\mathrm{1},\ V.\mathrm{monotone}\ h\ v.\mathrm{2}\rangle=Q\ n\ v,\ \forall\,v : \uparrow(\bigsqcup\ n,\ V\ n),\ \forall\,n : \mathbb{N},\ \forall\,hv : v.\mathrm{1}\ \in\ V\ n,\ \mathrm{limitForm}\ Q\ v=Q\ n\ \langle{}v.\mathrm{1},\ \mathrm{hv}\rangle$ |
| [71](../absolute-polarized-hodge-index-realization/lean/Limit.lean#L71) | theorem | `limitForm_nonpos` | $\forall\,Q : (n:\mathbb{N})\to\ V\ n\to\ \mathbb{R},\ \forall\,hnsd : \forall\ n\ v,\ Q\ n\ v\le\ 0,\ \forall\,v : \uparrow(\bigsqcup\ n,\ V\ n),\ \mathrm{limitForm}\ Q\ v\le\ 0$ |
| [82](../absolute-polarized-hodge-index-realization/lean/Limit.lean#L82) | theorem | `limitForm_nonneg` | $\forall\,Q : (n:\mathbb{N})\to\ V\ n\to\ \mathbb{R},\ \forall\,hnn : \forall\ n\ v,\ 0\le\ Q\ n\ v,\ \forall\,v : \uparrow(\bigsqcup\ n,\ V\ n),\ 0\le\ \mathrm{limitForm}\ Q\ v$ |
