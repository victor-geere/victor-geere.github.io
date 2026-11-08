# `prime-spectrum-tensor/lean/DensityWeight.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityWeight.lean`](../prime-spectrum-tensor/lean/DensityWeight.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [15](../prime-spectrum-tensor/lean/DensityWeight.lean#L15) | theorem | `abs_densityWeight_le` | $\forall\,c : \mathbb{R},\ \forall\,t : \mathbb{R},\ \vert{}\mathrm{IntersectionForm.densityWeight}(1/20)\ c\ t\vert\le\ 1/400$ |
| [30](../prime-spectrum-tensor/lean/DensityWeight.lean#L30) | theorem | `continuous_densityWeight` | $\forall\,c : \mathbb{R},\ \mathrm{Continuous}(\lambda\ t\Rightarrow\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ t)$ |
| [35](../prime-spectrum-tensor/lean/DensityWeight.lean#L35) | theorem | `densityWeight_nonneg` | $\forall\,c : \mathbb{R},\ \forall\,t : \mathbb{R},\ \forall\,ht : \mathrm{Real.cos}(c\cdot\ t)\ge\ 0,\ 0\le\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ t$ |
