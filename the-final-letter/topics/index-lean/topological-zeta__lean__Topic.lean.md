# `topological-zeta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`topological-zeta`](../topological-zeta/README.md)

### [`topological-zeta/lean/Topic.lean`](../topological-zeta/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [43](../topological-zeta/lean/Topic.lean#L43) | theorem | `egyptian_identity` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,d_{2} : \iota\to\ \mathbb{R},\ \forall\,hD : (\sum\ i,\ \mathrm{d2}\ i)\ne\ 0,\ \sum\ i,\ \mathrm{d2}\ i/(\sum\ j,\ \mathrm{d2}\ j)=1$ |
| [54](../topological-zeta/lean/Topic.lean#L54) | theorem | `egyptian_nonunit` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,[\mathrm{DecidableEq}\ \iota],\ \forall\,d_{2} : \iota\to\ \mathbb{R},\ \forall\,i_{0} : \iota,\ \forall\,h_{0} : \mathrm{d2}\ \mathrm{i0}=1,\ \forall\,hD : (\sum\ i,\ \mathrm{d2}\ i)\ne\ 0,\ \sum\ i\ \in\ \mathrm{Finset.univ.erase}\ \mathrm{i0},\ \mathrm{d2}\ i/(\sum\ j,\ \mathrm{d2}\ j)=1-1/(\sum\ j,\ \mathrm{d2}\ j)$ |
| [78](../topological-zeta/lean/Topic.lean#L78) | theorem | `isingS_symm` | $:\mathrm{isingS}^{T}=\mathrm{isingS}$ |
| [87](../topological-zeta/lean/Topic.lean#L87) | theorem | `isingS_mul_self` | $:\mathrm{isingS}\cdot\ \mathrm{isingS}=1$ |
| [100](../topological-zeta/lean/Topic.lean#L100) | theorem | `isingPsi_factor` | $\forall\,s : \mathbb{R},\ \mathrm{isingPsi}\ s=(2:\mathbb{R})^{-s}\cdot((2:\mathbb{R})^{1-s}-1)$ |
| [119](../topological-zeta/lean/Topic.lean#L119) | theorem | `isingPsi_one` | $:\mathrm{isingPsi}\ 1=0$ |
| [130](../topological-zeta/lean/Topic.lean#L130) | theorem | `su2_4_egyptian` | $:(1:\mathbb{R})/12+1/4+1/3+1/4+1/12=1$ |
