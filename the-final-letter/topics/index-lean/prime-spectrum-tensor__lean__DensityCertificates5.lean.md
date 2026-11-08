# `prime-spectrum-tensor/lean/DensityCertificates5.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityCertificates5.lean`](../prime-spectrum-tensor/lean/DensityCertificates5.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../prime-spectrum-tensor/lean/DensityCertificates5.lean#L39) | theorem | `densityTerm_mem_c4` | $:\mathrm{densityTerm}(4/5)(1/20)\ \in\ \mathrm{Set.Icc}(-16443/1000000:\mathbb{R})(-10097/1000000)$ |
| [49](../prime-spectrum-tensor/lean/DensityCertificates5.lean#L49) | theorem | `gaussianGram5_apply` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 5,\ \mathrm{gaussianGram5}\ \sigma\ i\ j=\mathrm{poleTerm}(\mathrm{centre5}\ i-\mathrm{centre5}\ j)\ \sigma+\mathrm{densityTerm}(\mathrm{centre5}\ i-\mathrm{centre5}\ j)\ \sigma+(\mathrm{primeTerm}(\mathrm{centre5}\ i-\mathrm{centre5}\ j)\ \sigma+\mathrm{primeTerm}(\mathrm{centre5}\ j-\mathrm{centre5}\ i)\ \sigma)/2$ |
| [63](../prime-spectrum-tensor/lean/DensityCertificates5.lean#L63) | theorem | `gaussianGram5_posDef_of_density_enclosure_loose` | $\forall\,hd_{0} : (82/10000:\mathbb{R})\le\ \mathrm{densityTerm}\ 0(1/20)\ \land\ \mathrm{densityTerm}\ 0(1/20)\le\ 152/10000,\ \forall\,hd_{1} : (-5158/100000:\mathbb{R})\le\ \mathrm{densityTerm}(1/5)(1/20)\ \land\ \mathrm{densityTerm}(1/5)(1/20)\le-4458/100000,\ \forall\,hd_{2} : (-2754/100000:\mathbb{R})\le\ \mathrm{densityTerm}(2/5)(1/20)\ \land\ \mathrm{densityTerm}(2/5)(1/20)\le-2054/100000,\ \forall\,hd_{3} : (-2034/100000:\mathbb{R})\le\ \mathrm{densityTerm}(3/5)(1/20)\ \land\ \mathrm{densityTerm}(3/5)(1/20)\le-1334/100000,\ \forall\,hd_{4} : (-16443/1000000:\mathbb{R})\le\ \mathrm{densityTerm}(4/5)(1/20)\ \land\ \mathrm{densityTerm}(4/5)(1/20)\le-10097/1000000,\ (\mathrm{gaussianGram5}(1/20)).\mathrm{PosDef}$ |
| [106](../prime-spectrum-tensor/lean/DensityCertificates5.lean#L106) | theorem | `gaussianGram5_posDef` | $:(\mathrm{gaussianGram5}(1/20)).\mathrm{PosDef}$ |
