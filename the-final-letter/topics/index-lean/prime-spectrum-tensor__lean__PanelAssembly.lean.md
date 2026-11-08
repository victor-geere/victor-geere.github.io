# `prime-spectrum-tensor/lean/PanelAssembly.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PanelAssembly.lean`](../prime-spectrum-tensor/lean/PanelAssembly.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../prime-spectrum-tensor/lean/PanelAssembly.lean#L30) | theorem | `panel_mem` | $\forall\,w\,\Omega : \mathbb{R}\to\ \mathbb{R},\ \forall\,a\,b\,Bw\,Sw\,qlo\,qhi\,qmid : \mathbb{R},\ \forall\,hab : a\le\ b,\ \forall\,hwcont : \mathrm{Continuous}\ w,\ \forall\,h\Omega{}cont : \mathrm{Continuous}\ \Omega,\ \forall\,hqlo : \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \mathrm{qlo}\le\ \Omega\ t,\ \forall\,hqhi : \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \Omega\ t\le\ \mathrm{qhi},\ \forall\,hsw : \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \vert{}w\ t\vert\le\ \mathrm{Sw},\ \forall\,hsw_{0} : 0\le\ \mathrm{Sw},\ \forall\,hmid : \vert(\int\ x\ \text{in}\ a..b,\ w\ x)-(b-a)\cdot\ w((a+b)/2)\vert\le\ \mathrm{Bw}\cdot(b-a)^{3}/4,\ \vert(\int\ x\ \text{in}\ a..b,\ w\ x\cdot\ \Omega\ x)-\mathrm{qmid}\cdot((b-a)\cdot\ w((a+b)/2))\vert\le\ \vert{}\mathrm{qmid}\vert\cdot(\mathrm{Bw}\cdot(b-a)^{3}/4)+\mathrm{max}(\mathrm{qmid}-\mathrm{qlo})(\mathrm{qhi}-\mathrm{qmid})\cdot((b-a)\cdot\ \mathrm{Sw})$ |
