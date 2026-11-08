# `padic-greedy-sine/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`padic-greedy-sine`](../padic-greedy-sine/README.md)

### [`padic-greedy-sine/lean/Topic.lean`](../padic-greedy-sine/lean/Topic.lean) — 6 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [34](../padic-greedy-sine/lean/Topic.lean#L34) | theorem | `trunc_eq_mod` | $\forall\,p\,x\,N : \mathbb{N},\ \forall\,hp : 2\le\ p,\ \mathrm{trunc}\ p\ x\ N=x\ \%\ p^{N}$ |
| [40](../padic-greedy-sine/lean/Topic.lean#L40) | theorem | `trunc_lt` | $\forall\,p\,x\,N : \mathbb{N},\ \forall\,hp : 2\le\ p,\ \mathrm{trunc}\ p\ x\ N<p^{N}$ |
| [45](../padic-greedy-sine/lean/Topic.lean#L45) | theorem | `trunc_add` | $\forall\,p\,x\,N : \mathbb{N},\ \forall\,hp : 2\le\ p,\ \mathrm{trunc}\ p\ x\ N+p^{N}\cdot(x/p^{N})=x$ |
| [51](../padic-greedy-sine/lean/Topic.lean#L51) | theorem | `pNorm_p_pow` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,n : \mathbb{N},\ \mathrm{pNorm}\ p((p:\mathbb{Q})^{n})=(p:\mathbb{Q})^{-(n:\mathbb{Z})}$ |
| [61](../padic-greedy-sine/lean/Topic.lean#L61) | theorem | `pNorm_p_neg_pow` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,n : \mathbb{N},\ \mathrm{pNorm}\ p((p:\mathbb{Q})^{-(n:\mathbb{Z})})=(p:\mathbb{Q})^{n}$ |
| [72](../padic-greedy-sine/lean/Topic.lean#L72) | theorem | `pNorm_p_pow_strictAnti` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \mathrm{StrictAnti}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{pNorm}\ p((p:\mathbb{Q})^{n}))$ |
