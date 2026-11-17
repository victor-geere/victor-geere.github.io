# `qefe/lean/QuadraticInt/RingOfIntegersThree.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/RingOfIntegersThree.lean`](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean) — 16 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L30) | theorem | `irreducible_X_sq_add_X_add_one` | $:\mathrm{Irreducible}(X^{2}+X+1:\mathrm{Polynomial}\ \mathbb{Q})$ |
| [47](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L47) | lemma | `omegaK_sq_add` | $:\mathrm{omegaK}^{2}+\mathrm{omegaK}+1=0$ |
| [51](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L51) | lemma | `omegaK_sq` | $:\mathrm{omegaK}^{2}=-1-\mathrm{omegaK}$ |
| [54](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L54) | lemma | `natDegree_g` | $:(X^{2}+X+1:\mathrm{Polynomial}\ \mathbb{Q}).\mathrm{natDegree}=2$ |
| [57](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L57) | lemma | `g_ne_zero` | $:(X^{2}+X+1:\mathrm{Polynomial}\ \mathbb{Q})\ne\ 0$ |
| [63](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L63) | lemma | `pb_dim3` | $:(\mathrm{AdjoinRoot.powerBasis}(K:=\mathbb{Q})(f:=(X^{2}+X+1:\mathrm{Polynomial}\ \mathbb{Q}))\ g_{\mathrm{ne}_{\mathrm{zero}}}).\mathrm{dim}=2$ |
| [72](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L72) | lemma | `pb3_zero` | $:\mathrm{pb3}\ 0=1$ |
| [76](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L76) | lemma | `pb3_one` | $:\mathrm{pb3}\ 1=\mathrm{omegaK}$ |
| [81](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L81) | lemma | `coord_eq3` | $\forall\,z : \mathrm{QW},\ z=\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QW}(\mathrm{pb3.repr}\ z\ 0)+\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QW}(\mathrm{pb3.repr}\ z\ 1)\cdot\ \mathrm{omegaK}$ |
| [90](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L90) | lemma | `finrank_QW` | $:\mathrm{Module.finrank}\ \mathbb{Q}\ \mathrm{QW}=2$ |
| [110](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L110) | lemma | `linearIndependent_pb3` | $:\mathrm{LinearIndependent}\ \mathbb{Q}(![(1:\mathrm{QW}),\ \mathrm{omegaK}]:\mathrm{Fin}\ 2\to\ \mathrm{QW})$ |
| [116](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L116) | lemma | `toK_injective` | $:\mathrm{Function.Injective}\ \mathrm{toK}$ |
| [130](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L130) | lemma | `algebraMap_QW_eq_toK` | $:(\mathrm{algebraMap}\ \mathrm{EisensteinInt}\ \mathrm{QW})=\mathrm{toK}$ |
| [140](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L140) | lemma | `algebraMap_eq_div_den3` | $\forall\,q : \mathbb{Q},\ \mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QW}\ q=((q.\mathrm{num}:\mathbb{Z}):\mathrm{QW})/((q.\mathrm{den}:\mathbb{Z}):\mathrm{QW})$ |
| [147](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L147) | lemma | `toK_mk` | $\forall\,m\,n : \mathbb{Z},\ \mathrm{toK}(\langle{}m,\ n\rangle:\mathrm{EisensteinInt})=(m:\mathrm{QW})+(n:\mathrm{QW})\cdot\ \mathrm{omegaK}$ |
| [149](../qefe/lean/QuadraticInt/RingOfIntegersThree.lean#L149) | lemma | `exists_div3` | $\forall\,z : \mathrm{QW},\ \exists\ x\ y:\mathrm{EisensteinInt},\ z=\mathrm{toK}\ x/\mathrm{toK}\ y$ |
