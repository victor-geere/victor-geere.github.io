# `absolute-polarized-hodge-index-realization/lean/Weil.lean`

[Back to the split index](index.md) · Topic: [`absolute-polarized-hodge-index-realization`](../absolute-polarized-hodge-index-realization/README.md)

### [`absolute-polarized-hodge-index-realization/lean/Weil.lean`](../absolute-polarized-hodge-index-realization/lean/Weil.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [16](../absolute-polarized-hodge-index-realization/lean/Weil.lean#L16) | theorem | `pole_term_nonneg` | $\forall\,h : \mathbb{R}\to\ \mathbb{R},\ \forall\,hh : \forall\ x,\ 0\le\ h\ x,\ 0\le\ \int\ x\ \text{in}(-2)..2,\ h\ x\cdot\ \mathrm{Real.cosh}(x/2)$ |
| [23](../absolute-polarized-hodge-index-realization/lean/Weil.lean#L23) | theorem | `prime_term_nonpos` | $\forall\,h : \mathbb{R}\to\ \mathbb{R},\ \forall\,hh : \forall\ x,\ 0\le\ h\ x,\ \forall\,N : \mathbb{N},\ (\sum\ n\ \in\ \mathrm{Finset.range}\ N,-(2\cdot(\mathrm{ArithmeticFunction.vonMangoldt}\ n:\mathbb{R})/\mathrm{Real.sqrt}\ n)\cdot\ h(\mathrm{Real.log}\ n))\le\ 0$ |
