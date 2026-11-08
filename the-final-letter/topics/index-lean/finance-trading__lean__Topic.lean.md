# `finance-trading/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`finance-trading`](../finance-trading/README.md)

### [`finance-trading/lean/Topic.lean`](../finance-trading/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../finance-trading/lean/Topic.lean#L42) | theorem | `binomWeight_nonneg` | $\forall\,p : \mathbb{R},\ \forall\,hp_{0} : 0\le\ p,\ \forall\,hp_{1} : p\le\ 1,\ \forall\,k\,j : \mathbb{N},\ 0\le\ \mathrm{binomWeight}\ p\ k\ j$ |
| [51](../finance-trading/lean/Topic.lean#L51) | theorem | `sum_binomialWeight` | $\forall\,p : \mathbb{R},\ \forall\,k : \mathbb{N},\ \sum\ j\ \in\ \mathrm{range}(k+1),\ \mathrm{binomWeight}\ p\ k\ j=1$ |
| [58](../finance-trading/lean/Topic.lean#L58) | theorem | `nodeValue_pos` | $\forall\,S_{0}\,u\,d : \mathbb{R},\ \forall\,hS : 0<S_{0},\ \forall\,hu : 0<u,\ \forall\,hd : 0<d,\ \forall\,k\,j : \mathbb{N},\ 0<\mathrm{nodeValue}\ S_{0}\ u\ d\ k\ j$ |
| [64](../finance-trading/lean/Topic.lean#L64) | theorem | `action_eq_inv` | $\forall\,S\,\varepsilon : \mathbb{R},\ \forall\,hS : S\ne\ 0,\ \forall\,h\varepsilon : \varepsilon\ne\ 0,\ \mathrm{action}\ S\ \varepsilon=1/\varepsilon$ |
| [70](../finance-trading/lean/Topic.lean#L70) | theorem | `sum_lattice_action` | $\forall\,S_{0}\,u\,d\,\varepsilon\,p : \mathbb{R},\ \forall\,k : \mathbb{N},\ \forall\,hS : 0<S_{0},\ \forall\,hu : 0<u,\ \forall\,hd : 0<d,\ \forall\,h\varepsilon : \varepsilon\ne\ 0,\ \sum\ j\ \in\ \mathrm{range}(k+1),\ \mathrm{binomWeight}\ p\ k\ j\cdot\ \mathrm{action}(\mathrm{nodeValue}\ S_{0}\ u\ d\ k\ j)\ \varepsilon=1/\varepsilon$ |
| [89](../finance-trading/lean/Topic.lean#L89) | theorem | `total_action_sum` | $\forall\,\varepsilon : \mathbb{R},\ \forall\,n : \mathbb{N},\ \sum_{k}\ \in\ \mathrm{range}(n+1),(1/\varepsilon)=((n:\mathbb{R})+1)/\varepsilon$ |
| [97](../finance-trading/lean/Topic.lean#L97) | theorem | `log_two_point_growth_lt` | $\forall\,r : \mathbb{R},\ \forall\,h_{0} : 0<r,\ \forall\,h_{1} : r<1,\ (1/2:\mathbb{R})\cdot\ \mathrm{Real.log}(1-r^{2})<-(r^{2})/2$ |
