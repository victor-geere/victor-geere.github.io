# `prime-spectrum-tensor/lean/GaussianGram6.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianGram6.lean`](../prime-spectrum-tensor/lean/GaussianGram6.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [36](../prime-spectrum-tensor/lean/GaussianGram6.lean#L36) | theorem | `gaussianGram6_symm` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 6,\ \mathrm{gaussianGram6}\ \sigma\ i\ j=\mathrm{gaussianGram6}\ \sigma\ j\ i$ |
| [130](../prime-spectrum-tensor/lean/GaussianGram6.lean#L130) | theorem | `D6_eq_diagonal` | $:\mathrm{D6}=\mathrm{Matrix.diagonal}\ ![(2019359/70000000:\mathbb{R}),(274520996756211/14135513000000000),(30936805201722536019/1601372481077897500000),(16633394932930007094114895103/866230545648231008532000000000),(72793928497768341955370502595722919/4366266169894126862205159964537500000),(7458489040992769784309983136193522865113/796183592944341240136864872140719426562500)]$ |
| [135](../prime-spectrum-tensor/lean/GaussianGram6.lean#L135) | theorem | `D6_posDef` | $:\mathrm{D6.PosDef}$ |
| [139](../prime-spectrum-tensor/lean/GaussianGram6.lean#L139) | theorem | `gramCentre6_factor` | $:\mathrm{gramCentre6}-\mathrm{gramMargin6}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 6)(\mathrm{Fin}\ 6)\ \mathbb{R})=\mathrm{L6}\cdot\ \mathrm{D6}\cdot\ \mathrm{L6}^{T}$ |
| [146](../prime-spectrum-tensor/lean/GaussianGram6.lean#L146) | theorem | `L6_transpose_det` | $:(\mathrm{L6}^{T}).\mathrm{det}=1$ |
| [155](../prime-spectrum-tensor/lean/GaussianGram6.lean#L155) | theorem | `gramCentre6_sub_posDef` | $:(\mathrm{gramCentre6}-\mathrm{gramMargin6}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 6)(\mathrm{Fin}\ 6)\ \mathbb{R})).\mathrm{PosDef}$ |
| [168](../prime-spectrum-tensor/lean/GaussianGram6.lean#L168) | theorem | `gaussianGram6_posDef_of_entry_bound` | $\forall\,G : \mathrm{Matrix}(\mathrm{Fin}\ 6)(\mathrm{Fin}\ 6)\ \mathbb{R},\ \forall\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-\mathrm{gramCentre6}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 6<\mathrm{gramMargin6},\ G.\mathrm{PosDef}$ |
| [178](../prime-spectrum-tensor/lean/GaussianGram6.lean#L178) | theorem | `gaussianGram5_submatrix_gaussianGram6` | $:(\mathrm{gaussianGram6}(1/20)).\mathrm{submatrix}(\lambda\ i:\mathrm{Fin}\ 5\Rightarrow\ \mathrm{Fin.castSucc}\ i)(\lambda\ i:\mathrm{Fin}\ 5\Rightarrow\ \mathrm{Fin.castSucc}\ i)=\mathrm{gaussianGram5}(1/20)$ |
