# `harmonic-sine-greedy-harmonic-essays/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-sine-greedy-harmonic-essays`](../harmonic-sine-greedy-harmonic-essays/README.md)

### [`harmonic-sine-greedy-harmonic-essays/lean/Topic.lean`](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [49](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L49) | theorem | `alpha_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{alpha}\ n$ |
| [53](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L53) | theorem | `alpha_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{alpha}$ |
| [62](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L62) | theorem | `sum_alpha` | $\forall\,N : \mathbb{N},\ \sum\ n\ \in\ \mathrm{Finset.range}(N+1),\ \mathrm{alpha}\ n=\mathrm{Real.pi}\cdot((\mathrm{harmonic}(N+2):\mathbb{R})-1)$ |
| [87](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L87) | theorem | `greedy_nonneg` | $\forall\,\theta : \mathbb{R},\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{greedy}\ \theta\ N$ |
| [98](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L98) | theorem | `greedy_le_target` | $\forall\,\theta : \mathbb{R},\ \forall\,h\theta : 0\le\ \theta,\ \forall\,N : \mathbb{N},\ \mathrm{greedy}\ \theta\ N\le\ \theta$ |
| [109](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L109) | theorem | `greedy_eq_zero_of_forall` | $\forall\,\theta : \mathbb{R},\ \forall\,h\theta : 0\le\ \theta,\ \forall\ N:\mathbb{N},(\forall\ k<N,\ \theta<\mathrm{alpha}\ k)\to\ \mathrm{greedy}\ \theta\ N=0\ \vert\ 0,_{=}>\mathrm{by}\ \mathrm{simp}[\mathrm{greedy}]\ \vert\ N+1,\ h\Rightarrow\ \mathrm{by}\ \mathrm{have}\ \mathrm{hN}:\mathrm{greedy}\ \theta\ N=0$ |
| [124](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L124) | theorem | `greedy_alpha_self` | $\forall\,n : \mathbb{N},\ \mathrm{greedy}(\mathrm{alpha}\ n)\ n=0$ |
| [130](../harmonic-sine-greedy-harmonic-essays/lean/Topic.lean#L130) | theorem | `selected_own_angle` | $\forall\,n : \mathbb{N},\ \mathrm{selected}(\mathrm{alpha}\ n)\ n=\mathrm{true}$ |
