# `self-adjoint-ccm/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`self-adjoint-ccm`](../self-adjoint-ccm/README.md)

### [`self-adjoint-ccm/lean/Topic.lean`](../self-adjoint-ccm/lean/Topic.lean) — 13 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [38](../self-adjoint-ccm/lean/Topic.lean#L38) | theorem | `helix_on_unit_cylinder` | $\forall\,\varphi : \mathbb{R}\to\ \mathbb{R},\ \forall\,t : \mathbb{R},\ (\mathrm{helix}\ \varphi\ t).1^{2}+(\mathrm{helix}\ \varphi\ t).2.1^{2}=1$ |
| [50](../self-adjoint-ccm/lean/Topic.lean#L50) | theorem | `torsion_denom_pos` | $\forall\,p\,q : \mathbb{R},\ \forall\,hp : 0<p,\ 0<p^{6}+p^{4}+q^{2}$ |
| [58](../self-adjoint-ccm/lean/Topic.lean#L58) | theorem | `torsion_const_phase` | $\forall\,p : \mathbb{R},\ \forall\,hp : 0<p,\ \mathrm{torsionFormula}\ p\ 0\ 0=p/(1+p^{2})$ |
| [67](../self-adjoint-ccm/lean/Topic.lean#L67) | theorem | `torsion_const_phase_pos` | $\forall\,p : \mathbb{R},\ \forall\,hp : 0<p,\ 0<\mathrm{torsionFormula}\ p\ 0\ 0$ |
| [81](../self-adjoint-ccm/lean/Topic.lean#L81) | theorem | `matching_unitary` | $\forall\,c : \mathbb{R},\ \Vert{}\mathrm{matchingCoeff}\ c\Vert=1$ |
| [92](../self-adjoint-ccm/lean/Topic.lean#L92) | theorem | `frequency_symmetry` | $\forall\,L : \mathbb{R},\ \forall\,k : \mathbb{Z},\ \mathrm{frequency}\ L(-k-1)=-\mathrm{frequency}\ L\ k$ |
| [102](../self-adjoint-ccm/lean/Topic.lean#L102) | theorem | `prime_power_cutoff_iff` | $\forall\,p\,lam : \mathbb{R},\ \forall\,hp : 1<p,\ \forall\,hlam : 0<\mathrm{lam},\ \forall\,m : \mathbb{N},\ p^{m}\le\ \mathrm{lam}^{2}\leftrightarrow(m:\mathbb{R})\cdot\ \mathrm{Real.log}\ p\le\ 2\cdot\ \mathrm{Real.log}\ \mathrm{lam}$ |
| [130](../self-adjoint-ccm/lean/Topic.lean#L130) | theorem | `rankOne_isHermitian` | $\forall\,\kappa : \mathrm{Type}\cdot,\ \forall\,v : \kappa\to\ \mathbb{C},\ (\mathrm{rankOne}\ v).\mathrm{IsHermitian}$ |
| [147](../self-adjoint-ccm/lean/Topic.lean#L147) | theorem | `ccmMatrix_isHermitian` | $\forall\,\iota\,\kappa : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,[\mathrm{DecidableEq}\ \kappa],\ \forall\,\mu : \kappa\to\ \mathbb{R},\ \forall\,\alpha : \iota\to\ \mathbb{R},\ \forall\,x : \iota\to\ \mathbb{R},\ \forall\,L : \mathbb{R},\ (\mathrm{ccmMatrix}\ \mu\ \alpha\ x\ L).\mathrm{IsHermitian}$ |
| [167](../self-adjoint-ccm/lean/Topic.lean#L167) | lemma | `rankOne_exp_diag` | $\forall\,\kappa : \mathrm{Type}\cdot,\ \forall\,\mu : \kappa\to\ \mathbb{R},\ \forall\,r : \mathbb{R},\ \forall\,k : \kappa,\ \mathrm{rankOne}(\lambda\ k\Rightarrow\ \mathrm{Complex.exp}(\mathrm{Complex}.I\cdot((\mu\ k:\mathbb{C})\cdot(r:\mathbb{C}))))\ k\ k=1$ |
| [171](../self-adjoint-ccm/lean/Topic.lean#L171) | theorem | `ccmMatrix_diag` | $\forall\,\iota\,\kappa : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,[\mathrm{DecidableEq}\ \kappa],\ \forall\,\mu : \kappa\to\ \mathbb{R},\ \forall\,\alpha : \iota\to\ \mathbb{R},\ \forall\,x : \iota\to\ \mathbb{R},\ \forall\,L : \mathbb{R},\ \forall\,k : \kappa,\ \mathrm{ccmMatrix}\ \mu\ \alpha\ x\ L\ k\ k=(\mu\ k:\mathbb{C})+(((\sum\ j,\ \alpha\ j)/L:\mathbb{R}):\mathbb{C})$ |
| [186](../self-adjoint-ccm/lean/Topic.lean#L186) | theorem | `deltaForm_nonneg` | $\forall\,\iota\,\kappa : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,[\mathrm{Fintype}\ \kappa],\ \forall\,\alpha : \iota\to\ \mathbb{R},\ \forall\,\mu : \kappa\to\ \mathbb{R},\ \forall\,x : \iota\to\ \mathbb{R},\ \forall\,z : \kappa\to\ \mathbb{C},\ \forall\,h\alpha : \forall\ j,\ 0\le\ \alpha\ j,\ 0\le\ \mathrm{deltaForm}\ \alpha\ \mu\ x\ z$ |
| [196](../self-adjoint-ccm/lean/Topic.lean#L196) | theorem | `matchingProduct_unitary` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,\alpha : \iota\to\ \mathbb{R},\ \Vert{}\mathrm{matchingProduct}\ \alpha\Vert=1$ |
