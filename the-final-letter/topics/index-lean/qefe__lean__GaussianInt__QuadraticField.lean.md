# `qefe/lean/GaussianInt/QuadraticField.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/GaussianInt/QuadraticField.lean`](../qefe/lean/GaussianInt/QuadraticField.lean) — 12 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../qefe/lean/GaussianInt/QuadraticField.lean#L30) | theorem | `irreducible_X_sq_add_one` | $:\mathrm{Irreducible}(X^{2}+1:\mathrm{Polynomial}\ \mathbb{Q})$ |
| [49](../qefe/lean/GaussianInt/QuadraticField.lean#L49) | lemma | `iRoot_sq_add_one` | $:\mathrm{iRoot}^{2}+1=0$ |
| [54](../qefe/lean/GaussianInt/QuadraticField.lean#L54) | lemma | `iRoot_mul_self` | $:\mathrm{iRoot}\cdot\ \mathrm{iRoot}=-1$ |
| [62](../qefe/lean/GaussianInt/QuadraticField.lean#L62) | lemma | `toQI_sqrtd` | $:\mathrm{toQI}\ \mathrm{Zsqrtd.sqrtd}=\mathrm{iRoot}$ |
| [67](../qefe/lean/GaussianInt/QuadraticField.lean#L67) | lemma | `toQI_injective` | $:\mathrm{Function.Injective}\ \mathrm{toQI}$ |
| [80](../qefe/lean/GaussianInt/QuadraticField.lean#L80) | lemma | `natDegree_f` | $:(X^{2}+1:\mathrm{Polynomial}\ \mathbb{Q}).\mathrm{natDegree}=2$ |
| [83](../qefe/lean/GaussianInt/QuadraticField.lean#L83) | lemma | `f_ne_zero` | $:(X^{2}+1:\mathrm{Polynomial}\ \mathbb{Q})\ne\ 0$ |
| [89](../qefe/lean/GaussianInt/QuadraticField.lean#L89) | lemma | `pb_dim` | $:(\mathrm{AdjoinRoot.powerBasis}(K:=\mathbb{Q})(f:=(X^{2}+1:\mathrm{Polynomial}\ \mathbb{Q}))\ f_{\mathrm{ne}_{\mathrm{zero}}}).\mathrm{dim}=2$ |
| [98](../qefe/lean/GaussianInt/QuadraticField.lean#L98) | lemma | `pb2_zero` | $:\mathrm{pb2}\ 0=1$ |
| [102](../qefe/lean/GaussianInt/QuadraticField.lean#L102) | lemma | `pb2_one` | $:\mathrm{pb2}\ 1=\mathrm{iRoot}$ |
| [107](../qefe/lean/GaussianInt/QuadraticField.lean#L107) | lemma | `coord_eq` | $\forall\,z : \mathrm{QI},\ z=\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QI}(\mathrm{pb2.repr}\ z\ 0)+\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QI}(\mathrm{pb2.repr}\ z\ 1)\cdot\ \mathrm{iRoot}$ |
| [116](../qefe/lean/GaussianInt/QuadraticField.lean#L116) | lemma | `finrank_QI` | $:\mathrm{Module.finrank}\ \mathbb{Q}\ \mathrm{QI}=2$ |
