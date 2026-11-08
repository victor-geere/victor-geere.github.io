# `prime-spectrum-tensor/lean/DensityAssembly.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityAssembly.lean`](../prime-spectrum-tensor/lean/DensityAssembly.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [20](../prime-spectrum-tensor/lean/DensityAssembly.lean#L20) | theorem | `continuous_densityWeight_mul_Omega` | $\forall\,c : \mathbb{R},\ \mathrm{Continuous}(\lambda\ x\Rightarrow\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x)$ |
| [25](../prime-spectrum-tensor/lean/DensityAssembly.lean#L25) | theorem | `density_approx_error` | $\forall\,c : \mathbb{R},\ \forall\,P : \mathbb{N},\ \forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,qmid\,E : \mathbb{N}\to\ \mathbb{R},\ \forall\,h_{0} : a\ 0=0,\ \forall\,hT : a\ P=60,\ \forall\,hpanel : \forall\ p<P,\ \vert(\int\ x\ \text{in}\ a\ p..a(p+1),\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x)-\mathrm{qmid}\ p\cdot((a(p+1)-a\ p)\cdot\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c((a\ p+a(p+1))/2))\vert\le\ E\ p,\ \vert{}\mathrm{IntersectionForm.density}(1/20)\ c-\sum\ p\ \in\ \mathrm{Finset.range}\ P,\ \mathrm{qmid}\ p\cdot((a(p+1)-a\ p)\cdot\ \mathrm{IntersectionForm.densityWeight}(1/20)\ c((a\ p+a(p+1))/2))\vert\le(\sum\ p\ \in\ \mathrm{Finset.range}\ P,\ E\ p)+1/10000$ |
