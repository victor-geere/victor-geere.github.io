# `prime-spectrum-tensor/lean/GaussianGram5.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianGram5.lean`](../prime-spectrum-tensor/lean/GaussianGram5.lean) — 9 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [59](../prime-spectrum-tensor/lean/GaussianGram5.lean#L59) | theorem | `gaussianGram5_symm` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 5,\ \mathrm{gaussianGram5}\ \sigma\ i\ j=\mathrm{gaussianGram5}\ \sigma\ j\ i$ |
| [108](../prime-spectrum-tensor/lean/GaussianGram5.lean#L108) | theorem | `gramCentre5_symm` | $\forall\,i\,j : \mathrm{Fin}\ 5,\ \mathrm{gramCentre5}\ i\ j=\mathrm{gramCentre5}\ j\ i$ |
| [111](../prime-spectrum-tensor/lean/GaussianGram5.lean#L111) | theorem | `D5_eq_diagonal` | $:\mathrm{D5}=\mathrm{diagonal}(![578399/25000000,\ 131688474887/11567980000000,\ 669135922460928699/65844237443500000000,\ 2719988083579585055940089/267654368984371479600000000,\ 132318221028802992579779774327/27199880835795850559400890000000]:\mathrm{Fin}\ 5\to\ \mathbb{R})$ |
| [121](../prime-spectrum-tensor/lean/GaussianGram5.lean#L121) | theorem | `D5_posDef` | $:\mathrm{D5.PosDef}$ |
| [125](../prime-spectrum-tensor/lean/GaussianGram5.lean#L125) | theorem | `gramCentre5_factor` | $:\mathrm{gramCentre5}-\mathrm{gramMargin5}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 5)(\mathrm{Fin}\ 5)\ \mathbb{R})=\mathrm{L5}\cdot\ \mathrm{D5}\cdot\ \mathrm{L5}^{T}$ |
| [133](../prime-spectrum-tensor/lean/GaussianGram5.lean#L133) | theorem | `L5_transpose_det` | $:(\mathrm{L5}^{T}).\mathrm{det}=1$ |
| [144](../prime-spectrum-tensor/lean/GaussianGram5.lean#L144) | theorem | `gramCentre5_sub_posDef` | $:(\mathrm{gramCentre5}-\mathrm{gramMargin5}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 5)(\mathrm{Fin}\ 5)\ \mathbb{R})).\mathrm{PosDef}$ |
| [162](../prime-spectrum-tensor/lean/GaussianGram5.lean#L162) | theorem | `gaussianGram5_posDef_of_entry_bound` | $\forall\,G : \mathrm{Matrix}(\mathrm{Fin}\ 5)(\mathrm{Fin}\ 5)\ \mathbb{R},\ \forall\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-\mathrm{gramCentre5}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 5<\mathrm{gramMargin5},\ G.\mathrm{PosDef}$ |
| [173](../prime-spectrum-tensor/lean/GaussianGram5.lean#L173) | theorem | `gaussianGram4_submatrix_gaussianGram5` | $:(\mathrm{gaussianGram5}(1/20)).\mathrm{submatrix}(\lambda\ i:\mathrm{Fin}\ 4\Rightarrow\ \mathrm{Fin.succ}\ i)(\lambda\ i:\mathrm{Fin}\ 4\Rightarrow\ \mathrm{Fin.succ}\ i)=\mathrm{gaussianGram4}(1/20)$ |
