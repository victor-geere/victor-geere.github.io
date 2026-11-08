# `harmonic-categorical-hilbert-polya/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-categorical-hilbert-polya`](../harmonic-categorical-hilbert-polya/README.md)

### [`harmonic-categorical-hilbert-polya/lean/Topic.lean`](../harmonic-categorical-hilbert-polya/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L44) | theorem | `weight_pos` | $\forall\,\sigma : \mathbb{R},\ \forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ 0<\mathrm{weight}\ \sigma\ N$ |
| [54](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L54) | theorem | `entry_eq_zero_of_lt` | $\forall\,s : \mathbb{R},\ \forall\,N\,m\,n : \mathbb{N},\ \forall\,h : n<m,\ \mathrm{entry}\ s\ N\ m\ n=0$ |
| [58](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L58) | theorem | `A_upperTriangular` | $\forall\,s : \mathbb{R},\ \forall\,N\,k : \mathbb{N},\ (A\ s\ N\ k).\mathrm{IsUpperTriangular}$ |
| [64](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L64) | theorem | `A_diag` | $\forall\,s : \mathbb{R},\ \forall\,N\,k : \mathbb{N},\ \forall\,i : \mathrm{Fin}(k+1),\ A\ s\ N\ k\ i\ i=\mathrm{weight}(s+1)\ N$ |
| [74](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L74) | theorem | `det_A` | $\forall\,s : \mathbb{R},\ \forall\,N\,k : \mathbb{N},\ (A\ s\ N\ k).\mathrm{det}=(\mathrm{weight}(s+1)\ N)^{k+1}$ |
| [81](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L81) | theorem | `det_one_sub_A` | $\forall\,s : \mathbb{R},\ \forall\,N\,k : \mathbb{N},\ (1-A\ s\ N\ k).\mathrm{det}=(1-\mathrm{weight}(s+1)\ N)^{k+1}$ |
| [101](../harmonic-categorical-hilbert-polya/lean/Topic.lean#L101) | theorem | `hermitian2_charpoly_splits` | $\forall\,a\,b\,d : \mathbb{R},\ \exists\ l_{1}\ l_{2}:\mathbb{R},\ \forall\ x:\mathbb{R},(x-l_{1})\cdot(x-l_{2})=x^{2}-(a+d)\cdot\ x+(a\cdot\ d-b^{2})$ |
