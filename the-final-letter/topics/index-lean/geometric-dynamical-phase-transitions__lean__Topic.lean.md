# `geometric-dynamical-phase-transitions/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/Topic.lean`](../geometric-dynamical-phase-transitions/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../geometric-dynamical-phase-transitions/lean/Topic.lean#L33) | theorem | `quadratic_link` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ N^{2}/N=N$ |
| [37](../geometric-dynamical-phase-transitions/lean/Topic.lean#L37) | theorem | `filterCoeff_of_not_dvd` | $\forall\,N\,m : \mathbb{N},\ \forall\,h : \neg\ N\ \mid\ m,\ \mathrm{filterCoeff}\ N\ m=1$ |
| [43](../geometric-dynamical-phase-transitions/lean/Topic.lean#L43) | theorem | `filterCoeff_of_dvd` | $\forall\,N\,m : \mathbb{N},\ \forall\,h : N\ \mid\ m,\ \mathrm{filterCoeff}\ N\ m=1-(N:\mathbb{Z})$ |
| [49](../geometric-dynamical-phase-transitions/lean/Topic.lean#L49) | theorem | `filterCoeff_block_sum_zero` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \sum\ k\ \in\ \mathrm{Finset.range}\ N,\ \mathrm{filterCoeff}\ N(k+1)=0$ |
| [84](../geometric-dynamical-phase-transitions/lean/Topic.lean#L84) | theorem | `temperedWeight_pos` | $\forall\,t : \mathbb{R},\ 0<(1+t^{2})^{-1}$ |
| [89](../geometric-dynamical-phase-transitions/lean/Topic.lean#L89) | theorem | `temperedWeight_le_one` | $\forall\,t : \mathbb{R},\ (1+t^{2})^{-1}\le\ 1$ |
| [102](../geometric-dynamical-phase-transitions/lean/Topic.lean#L102) | theorem | `atomicMass_le_card` | $\forall\,S : \mathrm{Finset}\ \mathbb{C},\ \mathrm{atomicMass}\ S\le(S.\mathrm{card}:\mathbb{R})$ |
