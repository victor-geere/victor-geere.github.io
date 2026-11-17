# `prime-spectrum-tensor/lean/GaussianGram7.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianGram7.lean`](../prime-spectrum-tensor/lean/GaussianGram7.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../prime-spectrum-tensor/lean/GaussianGram7.lean#L33) | theorem | `gaussianGram7_symm` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 7,\ \mathrm{gaussianGram7}\ \sigma\ i\ j=\mathrm{gaussianGram7}\ \sigma\ j\ i$ |
| [196](../prime-spectrum-tensor/lean/GaussianGram7.lean#L196) | theorem | `D7_eq_diagonal` | $:\mathrm{D7}=\mathrm{Matrix.diagonal}\ ![(828399/25000000:\mathbb{R}),(137682691629/5522660000000:\mathbb{R}),(1716157582214226233/68841345814500000000:\mathbb{R}),(51105516410353979455940089/2059389098657071479600000000:\mathbb{R}),(11778038067658461413800868874327/511055164103539794559400890000000:\mathbb{R}),(9008981894888954390060907831740708843/471121522706338456552034754973080000000:\mathbb{R}),(386563957161806241905613087444898105018687/35191335526909978086175421217737143917968750:\mathbb{R})]$ |
| [201](../prime-spectrum-tensor/lean/GaussianGram7.lean#L201) | theorem | `D7_posDef` | $:\mathrm{D7.PosDef}$ |
| [205](../prime-spectrum-tensor/lean/GaussianGram7.lean#L205) | theorem | `gramCentre7_factor` | $:\mathrm{gramCentre7}-\mathrm{gramMargin7}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 7)(\mathrm{Fin}\ 7)\ \mathbb{R})=\mathrm{L7}\cdot\ \mathrm{D7}\cdot\ \mathrm{L7}^{T}$ |
| [212](../prime-spectrum-tensor/lean/GaussianGram7.lean#L212) | theorem | `L7_transpose_det` | $:(\mathrm{L7}^{T}).\mathrm{det}=1$ |
| [221](../prime-spectrum-tensor/lean/GaussianGram7.lean#L221) | theorem | `gramCentre7_sub_posDef` | $:(\mathrm{gramCentre7}-\mathrm{gramMargin7}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 7)(\mathrm{Fin}\ 7)\ \mathbb{R})).\mathrm{PosDef}$ |
| [234](../prime-spectrum-tensor/lean/GaussianGram7.lean#L234) | theorem | `gaussianGram7_posDef_of_entry_bound` | $\forall\,G : \mathrm{Matrix}(\mathrm{Fin}\ 7)(\mathrm{Fin}\ 7)\ \mathbb{R},\ \forall\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-\mathrm{gramCentre7}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 7<\mathrm{gramMargin7},\ G.\mathrm{PosDef}$ |
| [244](../prime-spectrum-tensor/lean/GaussianGram7.lean#L244) | theorem | `gaussianGram6_submatrix_gaussianGram7` | $:(\mathrm{gaussianGram7}(1/20)).\mathrm{submatrix}(\lambda\ i:\mathrm{Fin}\ 6\Rightarrow\ \mathrm{Fin.castSucc}\ i)(\lambda\ i:\mathrm{Fin}\ 6\Rightarrow\ \mathrm{Fin.castSucc}\ i)=\mathrm{gaussianGram6}(1/20)$ |
