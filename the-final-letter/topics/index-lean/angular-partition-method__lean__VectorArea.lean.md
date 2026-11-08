# `angular-partition-method/lean/VectorArea.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/VectorArea.lean`](../angular-partition-method/lean/VectorArea.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [34](../angular-partition-method/lean/VectorArea.lean#L34) | theorem | `phaseWeight_eq` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,n : \mathbb{N},\ \mathrm{phaseWeight}\ c\ n=c\ n$ |
| [39](../angular-partition-method/lean/VectorArea.lean#L39) | theorem | `vectorArea_apply` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,hsum : \mathrm{Summable}\ c,\ \forall\,A : \mathrm{Set}\ \mathbb{N},\ \forall\,hA : \mathrm{MeasurableSet}\ A,\ \mathrm{vectorArea}\ c\ A=\sum'\ n:A,\ c\ n$ |
| [50](../angular-partition-method/lean/VectorArea.lean#L50) | theorem | `vectorArea_iUnion` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,A : \mathbb{N}\to\ \mathrm{Set}\ \mathbb{N},\ \forall\,hA : \forall\ i,\ \mathrm{MeasurableSet}(A\ i),\ \forall\,hdisj : \mathrm{Pairwise}(\mathrm{Disjoint}\ \mathrm{on}\ A),\ \mathrm{HasSum}(\lambda\ i\Rightarrow\ \mathrm{vectorArea}\ c(A\ i))(\mathrm{vectorArea}\ c(⋃\ i,\ A\ i))$ |
| [56](../angular-partition-method/lean/VectorArea.lean#L56) | theorem | `vectorArea_univ` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,hsum : \mathrm{Summable}\ c,\ \mathrm{vectorArea}\ c\ \mathrm{Set.univ}=\sum'\ n,\ c\ n$ |
| [62](../angular-partition-method/lean/VectorArea.lean#L62) | theorem | `vectorArea_univ_eq_ctail` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,hsum : \mathrm{Summable}\ c,\ \mathrm{vectorArea}\ c\ \mathrm{Set.univ}=\mathrm{ctail}\ c\ 0$ |
| [69](../angular-partition-method/lean/VectorArea.lean#L69) | theorem | `norm_vectorArea_univ_le` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,hsum : \mathrm{Summable}\ c,\ \Vert{}\mathrm{vectorArea}\ c\ \mathrm{Set.univ}\Vert\le\ \sum'\ n,\ \Vert{}c\ n\Vert$ |
| [75](../angular-partition-method/lean/VectorArea.lean#L75) | theorem | `vectorArea_eq_phase_sum` | $\forall\,c : \mathbb{N}\to\ \mathbb{C},\ \forall\,hsum : \mathrm{Summable}\ c,\ \forall\,A : \mathrm{Set}\ \mathbb{N},\ \forall\,hA : \mathrm{MeasurableSet}\ A,\ \mathrm{vectorArea}\ c\ A=\sum'\ n:A,\ \mathrm{phaseWeight}\ c\ n$ |
