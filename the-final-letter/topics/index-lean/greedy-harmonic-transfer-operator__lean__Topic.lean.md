# `greedy-harmonic-transfer-operator/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`greedy-harmonic-transfer-operator`](../greedy-harmonic-transfer-operator/README.md)

### [`greedy-harmonic-transfer-operator/lean/Topic.lean`](../greedy-harmonic-transfer-operator/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [55](../greedy-harmonic-transfer-operator/lean/Topic.lean#L55) | theorem | `weight_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{weight}\ n$ |
| [60](../greedy-harmonic-transfer-operator/lean/Topic.lean#L60) | theorem | `weight_le_half` | $\forall\,n : \mathbb{N},\ \mathrm{weight}\ n\le\ 1/2$ |
| [68](../greedy-harmonic-transfer-operator/lean/Topic.lean#L68) | theorem | `weight_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{weight}$ |
| [76](../greedy-harmonic-transfer-operator/lean/Topic.lean#L76) | theorem | `transfer_nonneg` | $\forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,ha : \forall\ n,\ 0\le\ a\ n,\ \forall\,n : \mathbb{N},\ 0\le\ \mathrm{transfer}\ a\ n$ |
| [82](../greedy-harmonic-transfer-operator/lean/Topic.lean#L82) | theorem | `transfer_mono` | $\forall\,a\,b : \mathbb{N}\to\ \mathbb{R},\ \forall\,h : \forall\ n,\ a\ n\le\ b\ n,\ \mathrm{transfer}\ a\le\ \mathrm{transfer}\ b$ |
| [89](../greedy-harmonic-transfer-operator/lean/Topic.lean#L89) | theorem | `transferIter_nonneg` | $\forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,ha : \forall\ n,\ 0\le\ a\ n,\ \forall(k\ n:\mathbb{N}),\ 0\le\ \mathrm{transferIter}\ k\ a\ n\ \vert\ 0,\ n\Rightarrow\ \mathrm{ha}\ n\ \vert\ k+1,\ n\Rightarrow\ \mathrm{transfer}_{\mathrm{nonneg}}(\lambda\ m\Rightarrow\ \mathrm{transferIter}_{\mathrm{nonneg}}\ \mathrm{ha}\ k\ m)\ n\ \mathrm{theorem}\ \mathrm{totalWeight}_{\mathrm{two}}:\mathrm{totalWeight}\ 2=5/6$ |
| [95](../greedy-harmonic-transfer-operator/lean/Topic.lean#L95) | theorem | `totalWeight_two` | $:\mathrm{totalWeight}\ 2=5/6$ |
