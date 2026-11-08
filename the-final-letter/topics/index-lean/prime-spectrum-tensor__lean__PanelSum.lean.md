# `prime-spectrum-tensor/lean/PanelSum.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PanelSum.lean`](../prime-spectrum-tensor/lean/PanelSum.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [21](../prime-spectrum-tensor/lean/PanelSum.lean#L21) | theorem | `panel_sum_error` | $\forall\,w\,\Omega : \mathbb{R}\to\ \mathbb{R},\ \forall\,P : \mathbb{N},\ \forall\,a : \mathbb{N}\to\ \mathbb{R},\ \forall\,qmid\,E : \mathbb{N}\to\ \mathbb{R},\ \forall\,hint : \forall\ p<P,\ \mathrm{IntervalIntegrable}(\lambda\ x\Rightarrow\ w\ x\cdot\ \Omega\ x)\ \mathrm{MeasureTheory.volume}(a\ p)(a(p+1)),\ \forall\,hpanel : \forall\ p<P,\ \vert(\int\ x\ \text{in}\ a\ p..a(p+1),\ w\ x\cdot\ \Omega\ x)-\mathrm{qmid}\ p\cdot((a(p+1)-a\ p)\cdot\ w((a\ p+a(p+1))/2))\vert\le\ E\ p,\ \vert(\int\ x\ \text{in}\ a\ 0..a\ P,\ w\ x\cdot\ \Omega\ x)-\sum\ p\ \in\ \mathrm{Finset.range}\ P,\ \mathrm{qmid}\ p\cdot((a(p+1)-a\ p)\cdot\ w((a\ p+a(p+1))/2))\vert\le\ \sum\ p\ \in\ \mathrm{Finset.range}\ P,\ E\ p$ |
| [49](../prime-spectrum-tensor/lean/PanelSum.lean#L49) | theorem | `integral_Ioi_split` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,T : \mathbb{R},\ \forall\,hT : 0\le\ T,\ \forall\,hint_{1} : \mathrm{MeasureTheory.IntegrableOn}\ f(\mathrm{Set.Ioc}\ 0\ T),\ \forall\,hint_{2} : \mathrm{MeasureTheory.IntegrableOn}\ f(\mathrm{Set.Ioi}\ T),\ \int\ x\ \text{in}\ \mathrm{Set.Ioi}\ 0,\ f\ x=(\int\ x\ \text{in}(0)..T,\ f\ x)+\int\ x\ \text{in}\ \mathrm{Set.Ioi}\ T,\ f\ x$ |
