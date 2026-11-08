# `research-programme-iii/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`research-programme-iii`](../research-programme-iii/README.md)

### [`research-programme-iii/lean/Topic.lean`](../research-programme-iii/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [38](../research-programme-iii/lean/Topic.lean#L38) | theorem | `qdim_symm` | $\forall\,N\,n : \mathbb{R},\ \forall\,hN : N\ne\ 0,\ \mathrm{qdim}\ N(N-n)=\mathrm{qdim}\ N\ n$ |
| [46](../research-programme-iii/lean/Topic.lean#L46) | theorem | `egyptianDenom_symm` | $\forall\,N\,n : \mathbb{R},\ \forall\,hN : N\ne\ 0,\ \mathrm{egyptianDenom}\ N(N-n)=\mathrm{egyptianDenom}\ N\ n$ |
| [54](../research-programme-iii/lean/Topic.lean#L54) | theorem | `egyptianDenom_pos` | $\forall\,N\,n : \mathbb{R},\ \forall\,hN : 0<N,\ \forall\,hn_{0} : 0<n,\ \forall\,hnN : n<N,\ 0<\mathrm{egyptianDenom}\ N\ n$ |
| [66](../research-programme-iii/lean/Topic.lean#L66) | theorem | `egyptianDenom_mid` | $\forall\,N : \mathbb{R},\ \forall\,hN : N\ne\ 0,\ \mathrm{egyptianDenom}\ N(N/2)=N/4$ |
| [76](../research-programme-iii/lean/Topic.lean#L76) | theorem | `psi_abs_le` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,S : \mathrm{Finset}\ \iota,\ \forall\,s : \mathbb{R},\ \forall\,m\,\chi : \iota\to\ \mathbb{R},\ \forall\,hm : \forall\ i\ \in\ S,\ 0<m\ i,\ \forall\,h\chi : \forall\ i\ \in\ S,\ \vert{}\chi\ i\vert=1,\ \vert{}\mathrm{psi}\ S\ s\ m\ \chi\vert\le\ \sum\ i\ \in\ S,(m\ i)^{-s}$ |
| [95](../research-programme-iii/lean/Topic.lean#L95) | theorem | `zero_reflection` | $\forall\,\Lambda : \mathbb{C}\to\ \mathbb{C},\ \forall\,\varepsilon : \mathbb{C},\ \forall\,h\varepsilon : \varepsilon=1\ \lor\ \varepsilon=-1,\ \forall\,hFE : \forall\ s:\mathbb{C},\ \Lambda\ s=\varepsilon\cdot\ \mathrm{star}(\Lambda(1-s)),\ \forall\,hreal : \forall\ s:\mathbb{C},\ \Lambda(\mathrm{star}\ s)=\mathrm{star}(\Lambda\ s),\ \forall\,\rho : \mathbb{C},\ \forall\,h\rho : \Lambda\ \rho=0,\ \Lambda(1-\mathrm{star}\ \rho)=0$ |
| [113](../research-programme-iii/lean/Topic.lean#L113) | theorem | `log_weight_pos` | $\forall\,m : \mathbb{R},\ \forall\,hm : 1<m,\ 0<\mathrm{Real.log}\ m/\mathrm{Real.sqrt}\ m$ |
