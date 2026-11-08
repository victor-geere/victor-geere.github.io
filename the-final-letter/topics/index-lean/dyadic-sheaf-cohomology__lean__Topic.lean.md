# `dyadic-sheaf-cohomology/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`dyadic-sheaf-cohomology`](../dyadic-sheaf-cohomology/README.md)

### [`dyadic-sheaf-cohomology/lean/Topic.lean`](../dyadic-sheaf-cohomology/lean/Topic.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [47](../dyadic-sheaf-cohomology/lean/Topic.lean#L47) | theorem | `dyadicRadius_pos` | $\forall\,k : \mathbb{N},\ 0<\mathrm{dyadicRadius}\ k$ |
| [53](../dyadic-sheaf-cohomology/lean/Topic.lean#L53) | theorem | `dyadicRadius_succ` | $\forall\,k : \mathbb{N},\ \mathrm{dyadicRadius}(k+1)=\mathrm{dyadicRadius}\ k/2$ |
| [58](../dyadic-sheaf-cohomology/lean/Topic.lean#L58) | theorem | `dyadicRadius_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{dyadicRadius}$ |
| [65](../dyadic-sheaf-cohomology/lean/Topic.lean#L65) | theorem | `dyadicRadius_tendsto_zero` | $:\mathrm{Tendsto}\ \mathrm{dyadicRadius}\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [71](../dyadic-sheaf-cohomology/lean/Topic.lean#L71) | theorem | `energy_nonneg` | $\forall\,t\,x : \mathbb{R},\ 0\le\ \mathrm{energy}\ t\ x$ |
| [79](../dyadic-sheaf-cohomology/lean/Topic.lean#L79) | theorem | `energy_eq_zero_iff` | $\forall\,t\,x : \mathbb{R},\ \mathrm{energy}\ t\ x=0\leftrightarrow\ \mathrm{Real.cos}(2\cdot\ \mathrm{Real.pi}\cdot\ t/x)=1\ \land\ \mathrm{Real.cos}(2\cdot\ \mathrm{Real.pi}\cdot\ x)=1$ |
| [101](../dyadic-sheaf-cohomology/lean/Topic.lean#L101) | theorem | `energy_symm` | $\forall\,t\,x : \mathbb{R},\ \forall\,ht : t\ne\ 0,\ \forall\,hx : x\ne\ 0,\ \mathrm{energy}\ t\ x=\mathrm{energy}\ t(t/x)$ |
| [113](../dyadic-sheaf-cohomology/lean/Topic.lean#L113) | theorem | `energy_vanishes_of_dvd` | $\forall\,p\,x : \mathbb{N},\ \forall\,hx : 0<x,\ \forall\,h : x\ \mid\ p,\ \mathrm{energy}(p:\mathbb{R})(x:\mathbb{R})=0$ |
