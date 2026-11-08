# `finite-window-zeros/lean/EtaEM.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/EtaEM.lean`](../finite-window-zeros/lean/EtaEM.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../finite-window-zeros/lean/EtaEM.lean#L23) | theorem | `altSum_delta` | $\forall\,a : \mathbb{N}\to\ \mathbb{C},\ \forall\,N : \mathbb{N},\ \mathrm{altSum}(\mathrm{delta}\ a)\ N=2\cdot\ \mathrm{altSum}\ a\ N-a\ 0+(-1:\mathbb{C})^{N}\cdot\ a\ N$ |
| [38](../finite-window-zeros/lean/EtaEM.lean#L38) | theorem | `altSum_eq` | $\forall\,a : \mathbb{N}\to\ \mathbb{C},\ \forall\,N : \mathbb{N},\ \mathrm{altSum}\ a\ N=a\ 0/2+(1/2)\cdot\ \mathrm{altSum}(\mathrm{delta}\ a)\ N-((-1:\mathbb{C})^{N})\cdot\ a\ N/2$ |
| [50](../finite-window-zeros/lean/EtaEM.lean#L50) | theorem | `altSum_euler` | $\forall\,K\,N : \mathbb{N},\ \forall\,a : \mathbb{N}\to\ \mathbb{C},\ \mathrm{altSum}\ a\ N=(\sum\ k\ \in\ \mathrm{range}\ K,(1/2:\mathbb{C})^{k+1}\cdot\ \mathrm{deltaN}\ k\ a\ 0)+(1/2:\mathbb{C})^{K}\cdot\ \mathrm{altSum}(\mathrm{deltaN}\ K\ a)\ N-(-1:\mathbb{C})^{N}\cdot(\sum\ k\ \in\ \mathrm{range}\ K,(1/2:\mathbb{C})^{k+1}\cdot\ \mathrm{deltaN}\ k\ a\ N)$ |
