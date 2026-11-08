# `geometric-dynamical-phase-transitions/lean/LeeYang.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/LeeYang.lean`](../geometric-dynamical-phase-transitions/lean/LeeYang.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [25](../geometric-dynamical-phase-transitions/lean/LeeYang.lean#L25) | theorem | `quadratic_no_real_root` | $\forall\,a\,b\,x : \mathbb{R},\ \forall\,ha : 0<a,\ \forall\,hb_{0} : 0<b,\ \forall\,hb : b<2\cdot\ a,\ a\cdot\ x^{2}+b\cdot\ x+a\ne\ 0$ |
| [40](../geometric-dynamical-phase-transitions/lean/LeeYang.lean#L40) | theorem | `quadratic_root_normSq_one` | $\forall\,a\,b : \mathbb{R},\ \forall\,ha : 0<a,\ \forall\,hb_{0} : 0<b,\ \forall\,hb_{2} : b<2\cdot\ a,\ \forall\,z : \mathbb{C},\ \forall\,hz : a\cdot\ z^{2}+b\cdot\ z+a=0,\ \mathrm{Complex.normSq}\ z=1$ |
| [74](../geometric-dynamical-phase-transitions/lean/LeeYang.lean#L74) | theorem | `ising2_lee_yang` | $\forall\,K : \mathbb{R},\ \forall\,hK : 0<K,\ \forall\,z : \mathbb{C},\ \forall\,hz : \mathrm{ising2Partition}\ K\ z=0,\ \mathrm{Complex.normSq}\ z=1$ |
| [89](../geometric-dynamical-phase-transitions/lean/LeeYang.lean#L89) | theorem | `eta2_zero` | $:\mathrm{eta2}\ 0=0$ |
| [93](../geometric-dynamical-phase-transitions/lean/LeeYang.lean#L93) | theorem | `eta2_zero_off_critical` | $:(0:\mathbb{C}).\mathrm{re}\ne\ 1/2$ |
