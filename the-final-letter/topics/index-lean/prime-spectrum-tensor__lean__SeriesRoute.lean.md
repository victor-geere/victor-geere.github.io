# `prime-spectrum-tensor/lean/SeriesRoute.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/SeriesRoute.lean`](../prime-spectrum-tensor/lean/SeriesRoute.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [45](../prime-spectrum-tensor/lean/SeriesRoute.lean#L45) | theorem | `omegaTerm_nonneg` | $\forall\,k : \mathbb{N},\ \forall\,t : \mathbb{R},\ 0\le\ \mathrm{omegaTerm}\ k\ t$ |
| [54](../prime-spectrum-tensor/lean/SeriesRoute.lean#L54) | theorem | `omegaTerm_le` | $\forall\,k : \mathbb{N},\ \forall\,t : \mathbb{R},\ \mathrm{omegaTerm}\ k\ t\le\ t^{2}/(4\cdot((k:\mathbb{R})+1/4)^{3})$ |
| [66](../prime-spectrum-tensor/lean/SeriesRoute.lean#L66) | theorem | `inv_cube_le` | $\forall\,a : \mathbb{R},\ \forall\,ha : 2\le\ a,\ 1/a^{3}\le\ 1/a^{2}-1/(a+1)^{2}$ |
| [77](../prime-spectrum-tensor/lean/SeriesRoute.lean#L77) | theorem | `sum_telescope` | $\forall\,N\,M : \mathbb{N},\ \sum\ k\ \in\ \mathrm{Finset.range}\ M,(1/((k:\mathbb{R})+N+1/4)^{2}-1/((k:\mathbb{R})+N+1+1/4)^{2})=1/((N:\mathbb{R})+1/4)^{2}-1/((M:\mathbb{R})+N+1/4)^{2}$ |
| [90](../prime-spectrum-tensor/lean/SeriesRoute.lean#L90) | theorem | `sum_omegaTerm_tail_le` | $\forall\,t : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,hN : 2\le\ N,\ \sum'\ k:\mathbb{N},\ \mathrm{omegaTerm}(k+N)\ t\le\ t^{2}/4\cdot(1/((N:\mathbb{R})+1/4)^{2})$ |
