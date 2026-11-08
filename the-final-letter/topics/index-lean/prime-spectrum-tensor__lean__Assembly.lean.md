# `prime-spectrum-tensor/lean/Assembly.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/Assembly.lean`](../prime-spectrum-tensor/lean/Assembly.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [38](../prime-spectrum-tensor/lean/Assembly.lean#L38) | theorem | `densityTerm_neg` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{densityTerm}(-c)\ \sigma=\mathrm{densityTerm}\ c\ \sigma$ |
| [45](../prime-spectrum-tensor/lean/Assembly.lean#L45) | theorem | `gaussianGram4_apply` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 4,\ \mathrm{gaussianGram4}\ \sigma\ i\ j=\mathrm{poleTerm}(\mathrm{centre4}\ i-\mathrm{centre4}\ j)\ \sigma+\mathrm{densityTerm}(\mathrm{centre4}\ i-\mathrm{centre4}\ j)\ \sigma+(\mathrm{primeTerm}(\mathrm{centre4}\ i-\mathrm{centre4}\ j)\ \sigma+\mathrm{primeTerm}(\mathrm{centre4}\ j-\mathrm{centre4}\ i)\ \sigma)/2$ |
| [59](../prime-spectrum-tensor/lean/Assembly.lean#L59) | theorem | `gaussianGram4_posDef_of_density_enclosure` | $\forall\,hd_{0} : (107/10000:\mathbb{R})\le\ \mathrm{densityTerm}\ 0(1/20)\ \land\ \mathrm{densityTerm}\ 0(1/20)\le\ 127/10000,\ \forall\,hd_{1} : (-491/10000:\mathbb{R})\le\ \mathrm{densityTerm}(1/5)(1/20)\ \land\ \mathrm{densityTerm}(1/5)(1/20)\le-471/10000,\ \forall\,hd_{2} : (-251/10000:\mathbb{R})\le\ \mathrm{densityTerm}(2/5)(1/20)\ \land\ \mathrm{densityTerm}(2/5)(1/20)\le-231/10000,\ \forall\,hd_{3} : (-179/10000:\mathbb{R})\le\ \mathrm{densityTerm}(3/5)(1/20)\ \land\ \mathrm{densityTerm}(3/5)(1/20)\le-159/10000,\ (\mathrm{gaussianGram4}(1/20)).\mathrm{PosDef}$ |
| [106](../prime-spectrum-tensor/lean/Assembly.lean#L106) | theorem | `gaussianGram4_posDef_of_density_enclosure_loose` | $\forall\,hd_{0} : (82/10000:\mathbb{R})\le\ \mathrm{densityTerm}\ 0(1/20)\ \land\ \mathrm{densityTerm}\ 0(1/20)\le\ 152/10000,\ \forall\,hd_{1} : (-5158/100000:\mathbb{R})\le\ \mathrm{densityTerm}(1/5)(1/20)\ \land\ \mathrm{densityTerm}(1/5)(1/20)\le-4458/100000,\ \forall\,hd_{2} : (-2754/100000:\mathbb{R})\le\ \mathrm{densityTerm}(2/5)(1/20)\ \land\ \mathrm{densityTerm}(2/5)(1/20)\le-2054/100000,\ \forall\,hd_{3} : (-2034/100000:\mathbb{R})\le\ \mathrm{densityTerm}(3/5)(1/20)\ \land\ \mathrm{densityTerm}(3/5)(1/20)\le-1334/100000,\ (\mathrm{gaussianGram4}(1/20)).\mathrm{PosDef}$ |
