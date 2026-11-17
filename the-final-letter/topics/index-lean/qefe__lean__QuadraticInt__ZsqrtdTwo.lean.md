# `qefe/lean/QuadraticInt/ZsqrtdTwo.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/QuadraticInt/ZsqrtdTwo.lean`](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean) — 13 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L39) | lemma | `nearest_spec` | $\forall\,q : \mathbb{Q},\ \vert{}q-(\mathrm{nearest}\ q:\mathbb{Q})\vert\le\ 1/2$ |
| [48](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L48) | lemma | `four_mul_sq_le` | $\forall\,A : \mathbb{Z},\ \forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ 4\cdot(A-\mathrm{nearest}((A:\mathbb{Q})/(N:\mathbb{Q}))\cdot(N:\mathbb{Z}))^{2}\le(N:\mathbb{Z})^{2}$ |
| [69](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L69) | lemma | `four_mul_sq_le_int` | $\forall\,A\,N : \mathbb{Z},\ \forall\,hN : 0<N,\ 4\cdot(A-\mathrm{nearest}((A:\mathbb{Q})/(N:\mathbb{Q}))\cdot\ N)^{2}\le\ N^{2}$ |
| [97](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L97) | lemma | `norm_pos'` | $\forall\,z : \mathrm{R2},\ \forall\,hz : z\ne\ 0,\ 0<z.\mathrm{norm}$ |
| [106](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L106) | lemma | `emod_fact` | $\forall\,x\,y : \mathrm{R2},\ \mathrm{emod}\ x\ y\cdot(y.\mathrm{norm}:\mathrm{R2})=y\cdot(\langle{}\mathrm{remRe}\ x\ y,\ \mathrm{remIm}\ x\ y\rangle:\mathrm{R2})$ |
| [125](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L125) | lemma | `rem_norm_eq` | $\forall\,x\,y : \mathrm{R2},\ (\langle{}\mathrm{remRe}\ x\ y,\ \mathrm{remIm}\ x\ y\rangle:\mathrm{R2}).\mathrm{norm}=(\mathrm{remRe}\ x\ y)^{2}+2\cdot(\mathrm{remIm}\ x\ y)^{2}$ |
| [130](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L130) | lemma | `emod_norm_lt` | $\forall\,x\,y : \mathrm{R2},\ \forall\,hy : y\ne\ 0,\ (\mathrm{emod}\ x\ y).\mathrm{norm.natAbs}<y.\mathrm{norm}.\mathrm{natAbs}$ |
| [156](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L156) | lemma | `norm_mul_le_natAbs` | $\forall\,a\,b : \mathrm{R2},\ \forall\,hb : b\ne\ 0,\ a.\mathrm{norm}.\mathrm{natAbs}\le(a\cdot\ b).\mathrm{norm.natAbs}$ |
| [163](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L163) | lemma | `ediv_zero` | $\forall\,a : \mathrm{R2},\ \mathrm{ediv}\ a\ 0=0$ |
| [189](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L189) | lemma | `unit_norm_eq_one` | $\forall\,u : \mathrm{R2}\text{ˣ},\ (u:\mathrm{R2}).\mathrm{norm}=1$ |
| [194](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L194) | lemma | `unit_eq_one_or_neg_one` | $\forall\,u : \mathrm{R2}\text{ˣ},\ (u:\mathrm{R2})=1\ \lor(u:\mathrm{R2})=-1$ |
| [216](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L216) | lemma | `sqrtdVec_linInd` | $:\mathrm{LinearIndependent}\ \mathbb{Z}\ \mathrm{sqrtdVec}$ |
| [228](../qefe/lean/QuadraticInt/ZsqrtdTwo.lean#L228) | lemma | `sqrtdVec_span` | $:\top\le\ \mathrm{Submodule.span}\ \mathbb{Z}(\mathrm{Set.range}\ \mathrm{sqrtdVec})$ |
