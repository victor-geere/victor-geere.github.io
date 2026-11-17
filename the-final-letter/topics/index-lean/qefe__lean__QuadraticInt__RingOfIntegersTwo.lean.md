# `qefe/lean/QuadraticInt/RingOfIntegersTwo.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/RingOfIntegersTwo.lean`](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean) — 15 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [31](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L31) | theorem | `irreducible_X_sq_add_two` | $:\mathrm{Irreducible}(X^{2}+2:\mathrm{Polynomial}\ \mathbb{Q})$ |
| [50](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L50) | lemma | `sqrt2_sq_add_two` | $:\mathrm{sqrt2}^{2}+2=0$ |
| [54](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L54) | lemma | `sqrt2_mul_self` | $:\mathrm{sqrt2}\cdot\ \mathrm{sqrt2}=-2$ |
| [57](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L57) | lemma | `natDegree_f2` | $:(X^{2}+2:\mathrm{Polynomial}\ \mathbb{Q}).\mathrm{natDegree}=2$ |
| [61](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L61) | lemma | `f2_ne_zero` | $:(X^{2}+2:\mathrm{Polynomial}\ \mathbb{Q})\ne\ 0$ |
| [67](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L67) | lemma | `pb_dim2` | $:(\mathrm{AdjoinRoot.powerBasis}(K:=\mathbb{Q})(f:=(X^{2}+2:\mathrm{Polynomial}\ \mathbb{Q}))\ \mathrm{f2}_{\mathrm{ne}_{\mathrm{zero}}}).\mathrm{dim}=2$ |
| [76](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L76) | lemma | `pb2b_zero` | $:\mathrm{pb2b}\ 0=1$ |
| [80](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L80) | lemma | `pb2b_one` | $:\mathrm{pb2b}\ 1=\mathrm{sqrt2}$ |
| [85](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L85) | lemma | `coord_eq2` | $\forall\,z : \mathrm{QS2},\ z=\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QS2}(\mathrm{pb2b.repr}\ z\ 0)+\mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QS2}(\mathrm{pb2b.repr}\ z\ 1)\cdot\ \mathrm{sqrt2}$ |
| [94](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L94) | lemma | `finrank_QS2` | $:\mathrm{Module.finrank}\ \mathbb{Q}\ \mathrm{QS2}=2$ |
| [105](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L105) | lemma | `toQS2_mk` | $\forall\,m\,n : \mathbb{Z},\ \mathrm{toQS2}(\langle{}m,\ n\rangle:\mathrm{R2})=(m:\mathrm{QS2})+(n:\mathrm{QS2})\cdot\ \mathrm{sqrt2}$ |
| [108](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L108) | lemma | `toQS2_injective` | $:\mathrm{Function.Injective}\ \mathrm{toQS2}$ |
| [115](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L115) | lemma | `algebraMap_QS2_eq_toQS2` | $:(\mathrm{algebraMap}\ \mathrm{R2}\ \mathrm{QS2})=\mathrm{toQS2}$ |
| [125](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L125) | lemma | `algebraMap_eq_div_den2` | $\forall\,q : \mathbb{Q},\ \mathrm{algebraMap}\ \mathbb{Q}\ \mathrm{QS2}\ q=((q.\mathrm{num}:\mathbb{Z}):\mathrm{QS2})/((q.\mathrm{den}:\mathbb{Z}):\mathrm{QS2})$ |
| [132](../qefe/lean/QuadraticInt/RingOfIntegersTwo.lean#L132) | lemma | `exists_div2` | $\forall\,z : \mathrm{QS2},\ \exists\ x\ y:\mathrm{R2},\ z=\mathrm{toQS2}\ x/\mathrm{toQS2}\ y$ |
