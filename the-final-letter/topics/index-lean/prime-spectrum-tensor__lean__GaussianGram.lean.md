# `prime-spectrum-tensor/lean/GaussianGram.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianGram.lean`](../prime-spectrum-tensor/lean/GaussianGram.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [103](../prime-spectrum-tensor/lean/GaussianGram.lean#L103) | theorem | `gaussianGramEntry_symm` | $\forall\,a\,b\,\sigma : \mathbb{R},\ \mathrm{gaussianGramEntry}\ a\ b\ \sigma=\mathrm{gaussianGramEntry}\ b\ a\ \sigma$ |
| [109](../prime-spectrum-tensor/lean/GaussianGram.lean#L109) | theorem | `gaussianGram4_symm` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 4,\ \mathrm{gaussianGram4}\ \sigma\ i\ j=\mathrm{gaussianGram4}\ \sigma\ j\ i$ |
| [122](../prime-spectrum-tensor/lean/GaussianGram.lean#L122) | theorem | `gaussianGram4_posDef_of_enclosure` | $\forall\,\sigma\,\varepsilon : \mathbb{R},\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}\mathrm{gaussianGram4}\ \sigma\ i\ j-\mathrm{gramCentre4}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 4<\mathrm{gramMargin},\ (\mathrm{gaussianGram4}\ \sigma).\mathrm{PosDef}$ |
