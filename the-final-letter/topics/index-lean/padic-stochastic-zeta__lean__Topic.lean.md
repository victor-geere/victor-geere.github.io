# `padic-stochastic-zeta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`padic-stochastic-zeta`](../padic-stochastic-zeta/README.md)

### [`padic-stochastic-zeta/lean/Topic.lean`](../padic-stochastic-zeta/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [46](../padic-stochastic-zeta/lean/Topic.lean#L46) | theorem | `pNorm_p_pow` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,n : \mathbb{N},\ \mathrm{pNorm}\ p((p:\mathbb{Q})^{n})=(p:\mathbb{Q})^{-(n:\mathbb{Z})}$ |
| [56](../padic-stochastic-zeta/lean/Topic.lean#L56) | theorem | `pNorm_p_pow_strictAnti` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \mathrm{StrictAnti}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{pNorm}\ p((p:\mathbb{Q})^{n}))$ |
| [65](../padic-stochastic-zeta/lean/Topic.lean#L65) | theorem | `pNorm_nonarchimedean` | $\forall\,p : \mathbb{N},\ \forall\,[\mathrm{Fact}\ p.\mathrm{Prime}],\ \forall\,q\,r : \mathbb{Q},\ \mathrm{pNorm}\ p(q+r)\le\ \mathrm{max}(\mathrm{pNorm}\ p\ q)(\mathrm{pNorm}\ p\ r)$ |
| [71](../padic-stochastic-zeta/lean/Topic.lean#L71) | theorem | `encode_example` | $:\mathrm{encode}\ 3[2,\ 1,\ 0]=5$ |
| [76](../padic-stochastic-zeta/lean/Topic.lean#L76) | theorem | `eulerFactor_telescope` | $\forall\,p\,N : \mathbb{N},\ \mathrm{eulerFactor}\ p\cdot(\sum\ k\ \in\ \mathrm{Finset.range}\ N,((p:\mathbb{Q})^{-1})^{k})=1-((p:\mathbb{Q})^{-1})^{N}$ |
| [88](../padic-stochastic-zeta/lean/Topic.lean#L88) | theorem | `klValue_eq` | $\forall\,p : \mathbb{N},\ \mathrm{klValue}\ p=((p:\mathbb{Q})-1)/12$ |
| [94](../padic-stochastic-zeta/lean/Topic.lean#L94) | theorem | `klValue_pos` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ 0<\mathrm{klValue}\ p$ |
