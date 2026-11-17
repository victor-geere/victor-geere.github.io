# `prime-spectrum-tensor/lean/SubCone.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/SubCone.lean`](../prime-spectrum-tensor/lean/SubCone.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [49](../prime-spectrum-tensor/lean/SubCone.lean#L49) | theorem | `poleTerm_eq` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{poleTerm}\ c\ \sigma=4\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}\cdot\ \mathrm{Real.exp}(\sigma^{2}/4)\cdot\ \mathrm{Real.cosh}(c/2)$ |
| [53](../prime-spectrum-tensor/lean/SubCone.lean#L53) | theorem | `poleTerm_growth` | $\forall\,c\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ 4\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}\cdot\ \mathrm{Real.exp}(\sigma^{2}/4)/2\cdot\ \mathrm{Real.exp}(c/2)\le\ \mathrm{poleTerm}\ c\ \sigma$ |
| [67](../prime-spectrum-tensor/lean/SubCone.lean#L67) | theorem | `poleTerm_unbounded` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \forall\ M:\mathbb{R},\ \exists\ c:\mathbb{R},\ M\le\ \mathrm{poleTerm}\ c\ \sigma$ |
| [94](../prime-spectrum-tensor/lean/SubCone.lean#L94) | theorem | `sum_poleTerm_eq` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,s : \mathrm{Finset}\ \iota,\ \forall\,c\,x : \iota\to\ \mathbb{R},\ \forall\,\sigma : \mathbb{R},\ \sum\ a\ \in\ s,\ \sum\ b\ \in\ s,\ x\ a\cdot\ x\ b\cdot\ \mathrm{poleTerm}(c\ a-c\ b)\ \sigma=4\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}\cdot\ \mathrm{Real.exp}(\sigma^{2}/4)\cdot((\sum\ a\ \in\ s,\ x\ a\cdot\ \mathrm{Real.exp}(c\ a/2))\cdot(\sum\ b\ \in\ s,\ x\ b\cdot\ \mathrm{Real.exp}(-(c\ b)/2)))$ |
| [140](../prime-spectrum-tensor/lean/SubCone.lean#L140) | theorem | `sum_poleTerm_eq_zero` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,s : \mathrm{Finset}\ \iota,\ \forall\,c\,x : \iota\to\ \mathbb{R},\ \forall\,\sigma : \mathbb{R},\ \forall\,hu : \sum\ a\ \in\ s,\ x\ a\cdot\ \mathrm{Real.exp}(c\ a/2)=0,\ \sum\ a\ \in\ s,\ \sum\ b\ \in\ s,\ x\ a\cdot\ x\ b\cdot\ \mathrm{poleTerm}(c\ a-c\ b)\ \sigma=0$ |
