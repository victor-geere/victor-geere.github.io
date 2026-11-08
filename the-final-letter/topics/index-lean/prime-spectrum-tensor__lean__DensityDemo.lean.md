# `prime-spectrum-tensor/lean/DensityDemo.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityDemo.lean`](../prime-spectrum-tensor/lean/DensityDemo.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [27](../prime-spectrum-tensor/lean/DensityDemo.lean#L27) | theorem | `weight_eq_densityWeight` | $\forall\,c\,t : \mathbb{R},\ \mathrm{weight}\ c\ t=\mathrm{IntersectionForm.densityWeight}(1/20)\ c\ t$ |
| [33](../prime-spectrum-tensor/lean/DensityDemo.lean#L33) | theorem | `omega_mem_thirty` | $:((\mathrm{IntersectionForm.omegaLo}\ 30\ 1\ 1000:\mathbb{Q}):\mathbb{R})\le\ \mathrm{IntersectionForm.Omega}\ 30\ \land\ \mathrm{IntersectionForm.Omega}\ 30\le((\mathrm{IntersectionForm.omegaHi}\ 30\ 1\ 1000:\mathbb{Q}):\mathbb{R})$ |
| [41](../prime-spectrum-tensor/lean/DensityDemo.lean#L41) | theorem | `density_one_panel` | $\forall\,qmid\,E : \mathbb{R},\ \forall\,hpanel : \vert(\int\ x\ \text{in}(0:\mathbb{R})..60,\ \mathrm{IntersectionForm.densityWeight}(1/20)\ 0\ x\cdot\ \mathrm{IntersectionForm.Omega}\ x)-\mathrm{qmid}\cdot(60\cdot\ \mathrm{IntersectionForm.densityWeight}(1/20)\ 0\ 30)\vert\le\ E,\ \vert{}\mathrm{IntersectionForm.density}(1/20)\ 0-\mathrm{qmid}\cdot(60\cdot\ \mathrm{IntersectionForm.densityWeight}(1/20)\ 0\ 30)\vert\le\ E+1/10000$ |
