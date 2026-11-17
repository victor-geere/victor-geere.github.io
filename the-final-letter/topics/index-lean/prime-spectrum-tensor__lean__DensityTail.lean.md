# `prime-spectrum-tensor/lean/DensityTail.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityTail.lean`](../prime-spectrum-tensor/lean/DensityTail.lean) — 9 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [18](../prime-spectrum-tensor/lean/DensityTail.lean#L18) | theorem | `log_add_two_le` | $\forall\,x : \mathbb{R},\ \forall\,hx : 60\le\ x,\ \mathrm{Real.log}(x+2)+24\le\ x$ |
| [29](../prime-spectrum-tensor/lean/DensityTail.lean#L29) | theorem | `exp_neg_nine_le` | $:\mathrm{Real.exp}(-9)\le\ 1/5000$ |
| [37](../prime-spectrum-tensor/lean/DensityTail.lean#L37) | theorem | `abs_densityWeight_le_exp` | $\forall\,c\,x : \mathbb{R},\ \vert{}\mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\vert\le(1/400:\mathbb{R})\cdot\ \mathrm{Real.exp}(-(x^{2}/400))$ |
| [52](../prime-spectrum-tensor/lean/DensityTail.lean#L52) | theorem | `abs_densityWeight_mul_Omega_le` | $\forall\,c\,x : \mathbb{R},\ \forall\,hx : 60\le\ x,\ \vert{}\mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x\vert\le(1/400:\mathbb{R})\cdot\ x\cdot\ \mathrm{Real.exp}(-(x^{2}/400))$ |
| [68](../prime-spectrum-tensor/lean/DensityTail.lean#L68) | theorem | `integrableOn_gaussian_moment` | $\forall\,T : \mathbb{R},\ \mathrm{MeasureTheory.IntegrableOn}(\lambda\ x:\mathbb{R}\Rightarrow(1/400:\mathbb{R})\cdot\ x\cdot\ \mathrm{Real.exp}(-(x^{2}/400)))(\mathrm{Set.Ioi}\ T)$ |
| [77](../prime-spectrum-tensor/lean/DensityTail.lean#L77) | theorem | `density_tail_le` | $\forall\,c : \mathbb{R},\ \vert\int\ x\ \text{in}\ \mathrm{Set.Ioi}(60:\mathbb{R}),\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x\vert\le\ 1/10000$ |
| [115](../prime-spectrum-tensor/lean/DensityTail.lean#L115) | theorem | `density_tail_le_of` | $\forall\,c : \mathbb{R},\ \forall\,T : \mathbb{R},\ \forall\,hT : 60\le\ T,\ \vert\int\ x\ \text{in}\ \mathrm{Set.Ioi}\ T,\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x\vert\le\ \mathrm{Real.exp}(-(T^{2}/400))/2$ |
| [146](../prime-spectrum-tensor/lean/DensityTail.lean#L146) | theorem | `exp_sixteen_large` | $:(5000000:\mathbb{R})\le\ \mathrm{Real.exp}\ 16$ |
| [159](../prime-spectrum-tensor/lean/DensityTail.lean#L159) | theorem | `density_tail_le_eighty` | $\forall\,c : \mathbb{R},\ \vert\int\ x\ \text{in}\ \mathrm{Set.Ioi}(80:\mathbb{R}),\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x\vert\le\ 1/10000000$ |
