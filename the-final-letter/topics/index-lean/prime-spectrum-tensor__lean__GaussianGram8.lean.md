# `prime-spectrum-tensor/lean/GaussianGram8.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianGram8.lean`](../prime-spectrum-tensor/lean/GaussianGram8.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [29](../prime-spectrum-tensor/lean/GaussianGram8.lean#L29) | theorem | `gaussianGram8_symm` | $\forall\,\sigma : \mathbb{R},\ \forall\,i\,j : \mathrm{Fin}\ 8,\ \mathrm{gaussianGram8}\ \sigma\ i\ j=\mathrm{gaussianGram8}\ \sigma\ j\ i$ |
| [69](../prime-spectrum-tensor/lean/GaussianGram8.lean#L69) | theorem | `D8_eq_diagonal` | $:\mathrm{D8}=\mathrm{Matrix.diagonal}\ ![(9362389/275000000:\mathbb{R}),(53673772661327/2059725580000000:\mathbb{R}),(1098951855072485299767/42172249948185500000000:\mathbb{R}),(125477939821141231451545549007/4835388162318935318974800000000:\mathbb{R}),(2346611882192366582168833698592337677/96618013662278748217690072735390000000:\mathbb{R}),(21418539641739884753391439527488841318613923/1032509228164641296154286827380628577880000000:\mathbb{R}),(25368839918990905459203455541292692241560356307079/1840655750462021345994576834393572300818384007812500:\mathbb{R}),(725584337308106229529783733422800415813960118548943808101/139528619554449980025619005477109807328581959688934500000000:\mathbb{R})]$ |
| [74](../prime-spectrum-tensor/lean/GaussianGram8.lean#L74) | theorem | `D8_posDef` | $:\mathrm{D8.PosDef}$ |
| [78](../prime-spectrum-tensor/lean/GaussianGram8.lean#L78) | theorem | `gramCentre8_factor` | $:\mathrm{gramCentre8}-\mathrm{gramMargin8}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 8)(\mathrm{Fin}\ 8)\ \mathbb{R})=\mathrm{L8}\cdot\ \mathrm{D8}\cdot\ \mathrm{L8}^{T}$ |
| [85](../prime-spectrum-tensor/lean/GaussianGram8.lean#L85) | theorem | `L8_transpose_det` | $:(\mathrm{L8}^{T}).\mathrm{det}=1$ |
| [94](../prime-spectrum-tensor/lean/GaussianGram8.lean#L94) | theorem | `gramCentre8_sub_posDef` | $:(\mathrm{gramCentre8}-\mathrm{gramMargin8}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 8)(\mathrm{Fin}\ 8)\ \mathbb{R})).\mathrm{PosDef}$ |
| [106](../prime-spectrum-tensor/lean/GaussianGram8.lean#L106) | theorem | `gaussianGram8_posDef_of_entry_bound` | $\forall\,G : \mathrm{Matrix}(\mathrm{Fin}\ 8)(\mathrm{Fin}\ 8)\ \mathbb{R},\ \forall\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-\mathrm{gramCentre8}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 8<\mathrm{gramMargin8},\ G.\mathrm{PosDef}$ |
| [116](../prime-spectrum-tensor/lean/GaussianGram8.lean#L116) | theorem | `gaussianGram7_submatrix_gaussianGram8` | $:(\mathrm{gaussianGram8}(1/20)).\mathrm{submatrix}(\lambda\ i:\mathrm{Fin}\ 7\Rightarrow\ \mathrm{Fin.castSucc}\ i)(\lambda\ i:\mathrm{Fin}\ 7\Rightarrow\ \mathrm{Fin.castSucc}\ i)=\mathrm{gaussianGram7}(1/20)$ |
