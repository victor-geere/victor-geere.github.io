# `geometric-dynamical-phase-transitions/lean/TransferNoGo.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/TransferNoGo.lean`](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean) — 11 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [32](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L32) | theorem | `regProd_diag` | $\forall\,N\,M : \mathbb{N},\ \forall\,s : \mathbb{R},\ (\mathrm{regProd}\ N\ s\ M)\ 0\ 0=1$ |
| [40](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L40) | theorem | `regProd_topright` | $\forall\,N\,M : \mathbb{N},\ \forall\,s : \mathbb{R},\ (\mathrm{regProd}\ N\ s\ M)\ 0\ 1=\sum\ k\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{regCoeff}\ N(k+1)\cdot((k+1:\mathbb{N}):\mathbb{R})^{-s}$ |
| [53](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L53) | theorem | `regCoeff_at_period` | $\forall\,N : \mathbb{N},\ \mathrm{regCoeff}\ N\ N=1-(N:\mathbb{R})$ |
| [58](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L58) | theorem | `regCoeff_at_period_neg` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \mathrm{regCoeff}\ N\ N<0$ |
| [64](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L64) | theorem | `regMat_coupling_neg` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,s : \mathbb{R},\ (\mathrm{regMat}\ N\ s\ N)\ 0\ 1<0$ |
| [75](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L75) | theorem | `register_not_ferromagnetic` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,s : \mathbb{R},\ \neg(\forall\ m:\mathbb{N},\ 0\le(\mathrm{regMat}\ N\ s\ m)\ 0\ 1)$ |
| [83](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L83) | theorem | `regProd_topright_polygon` | $\forall\,N : \mathbb{N},\ \forall\,s : \mathbb{R},\ (\mathrm{regProd}\ N\ s(N\cdot\ N))\ 0\ 1=\sum\ k\ \in\ \mathrm{Finset.range}(N\cdot\ N),\ \mathrm{regCoeff}\ N(k+1)\cdot((k+1:\mathbb{N}):\mathbb{R})^{-s}$ |
| [118](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L118) | theorem | `prod_b_nonneg` | $\forall\,xs : \mathrm{List}\ \mathrm{UpperTriNN},\ 0\le(\mathrm{prod}\ \mathrm{xs}).b$ |
| [128](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L128) | theorem | `etaAtNegOne_two` | $:\mathrm{etaAtNegOne}\ 2=-2$ |
| [134](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L134) | theorem | `no_upperTriNN_rep_of_neg` | $\forall\,v : \mathbb{R},\ \forall\,hv : v<0,\ \neg\ \exists\ \mathrm{xs}:\mathrm{List}\ \mathrm{UpperTriNN},(\mathrm{UpperTriNN.prod}\ \mathrm{xs}).b=v$ |
| [142](../geometric-dynamical-phase-transitions/lean/TransferNoGo.lean#L142) | theorem | `upperTriNN_cannot_represent_eta_two` | $:\neg\ \exists\ \mathrm{xs}:\mathrm{List}\ \mathrm{UpperTriNN},(\mathrm{UpperTriNN.prod}\ \mathrm{xs}).b=\mathrm{etaAtNegOne}\ 2$ |
