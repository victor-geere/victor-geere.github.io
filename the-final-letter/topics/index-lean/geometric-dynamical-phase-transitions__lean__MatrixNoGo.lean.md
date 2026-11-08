# `geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean`](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean#L26) | theorem | `matProd_nonneg` | $\forall\,L : \mathrm{List}(\mathrm{Matrix}\ \iota\ \iota\ \mathbb{R}),\ \forall\,h : \forall\ A\ \in\ L,\ \forall\ i\ j,\ 0\le\ A\ i\ j,\ \forall\ i\ j,\ 0\le\ \mathrm{matProd}\ L\ i\ j$ |
| [47](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean#L47) | theorem | `contraction_nonneg` | $\forall\,L : \mathrm{List}(\mathrm{Matrix}\ \iota\ \iota\ \mathbb{R}),\ \forall\,u\,w : \iota\to\ \mathbb{R},\ \forall\,hL : \forall\ A\ \in\ L,\ \forall\ i\ j,\ 0\le\ A\ i\ j,\ \forall\,hu : \forall\ i,\ 0\le\ u\ i,\ \forall\,hw : \forall\ j,\ 0\le\ w\ j,\ 0\le\ \mathrm{contraction}\ u\ w(\mathrm{matProd}\ L)$ |
| [57](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean#L57) | theorem | `no_nonneg_matrix_product_rep_of_neg` | $\forall\,v : \mathbb{R},\ \forall\,hv : v<0,\ \neg\ \exists(L:\mathrm{List}(\mathrm{Matrix}\ \iota\ \iota\ \mathbb{R}))(u\ w:\iota\to\ \mathbb{R}),(\forall\ A\ \in\ L,\ \forall\ i\ j,\ 0\le\ A\ i\ j)\ \land(\forall\ i,\ 0\le\ u\ i)\ \land(\forall\ j,\ 0\le\ w\ j)\ \land\ \mathrm{contraction}\ u\ w(\mathrm{matProd}\ L)=v$ |
| [71](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean#L71) | theorem | `etaTwoNegOne_eq` | $:\mathrm{etaTwoNegOne}=-2$ |
| [77](../geometric-dynamical-phase-transitions/lean/MatrixNoGo.lean#L77) | theorem | `no_nonneg_matrix_product_rep_eta_two` | $:\neg\ \exists(L:\mathrm{List}(\mathrm{Matrix}\ \iota\ \iota\ \mathbb{R}))(u\ w:\iota\to\ \mathbb{R}),(\forall\ A\ \in\ L,\ \forall\ i\ j,\ 0\le\ A\ i\ j)\ \land(\forall\ i,\ 0\le\ u\ i)\ \land(\forall\ j,\ 0\le\ w\ j)\ \land\ \mathrm{contraction}\ u\ w(\mathrm{matProd}\ L)=\mathrm{etaTwoNegOne}$ |
