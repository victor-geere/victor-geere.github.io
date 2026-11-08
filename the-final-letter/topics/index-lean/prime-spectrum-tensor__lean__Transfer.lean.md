# `prime-spectrum-tensor/lean/Transfer.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/Transfer.lean`](../prime-spectrum-tensor/lean/Transfer.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [79](../prime-spectrum-tensor/lean/Transfer.lean#L79) | theorem | `posDef_of_entry_bound` | $\forall\,n : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ n],\ \forall\,[\mathrm{DecidableEq}\ n],\ \forall\,C\,G : \mathrm{Matrix}\ n\ n\ \mathbb{R},\ \forall\,t\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,hC : (C-t\ \bullet(1:\mathrm{Matrix}\ n\ n\ \mathbb{R})).\mathrm{PosDef},\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-C\ i\ j\vert\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot(\mathrm{Fintype.card}\ n:\mathbb{R})<t,\ G.\mathrm{PosDef}$ |
| [202](../prime-spectrum-tensor/lean/Transfer.lean#L202) | theorem | `gramCentre4_symm` | $\forall\,i\,j : \mathrm{Fin}\ 4,\ \mathrm{gramCentre4}\ i\ j=\mathrm{gramCentre4}\ j\ i$ |
| [205](../prime-spectrum-tensor/lean/Transfer.lean#L205) | theorem | `D4_eq_diagonal` | $:\mathrm{D4}=\mathrm{diagonal}(![510899/25000000,\ 72866382887/10217980000000,\ 117293281231856199/36433191443500000000,\ 5088006962541167940089/46917312492742479600000000]:\mathrm{Fin}\ 4\to\ \mathbb{R})$ |
| [212](../prime-spectrum-tensor/lean/Transfer.lean#L212) | theorem | `D4_posDef` | $:\mathrm{D4.PosDef}$ |
| [216](../prime-spectrum-tensor/lean/Transfer.lean#L216) | theorem | `gramCentre4_factor` | $:\mathrm{gramCentre4}-\mathrm{gramMargin}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R})=\mathrm{L4}\cdot\ \mathrm{D4}\cdot\ \mathrm{L4}^{T}$ |
| [224](../prime-spectrum-tensor/lean/Transfer.lean#L224) | theorem | `L4_transpose_det` | $:(\mathrm{L4}^{T}).\mathrm{det}=1$ |
| [235](../prime-spectrum-tensor/lean/Transfer.lean#L235) | theorem | `gramCentre4_sub_posDef` | $:(\mathrm{gramCentre4}-\mathrm{gramMargin}\ \bullet(1:\mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R})).\mathrm{PosDef}$ |
| [255](../prime-spectrum-tensor/lean/Transfer.lean#L255) | theorem | `gaussianGram4_posDef_of_entry_bound` | $\forall\,G : \mathrm{Matrix}(\mathrm{Fin}\ 4)(\mathrm{Fin}\ 4)\ \mathbb{R},\ \forall\,\varepsilon : \mathbb{R},\ \forall\,hGsym : \forall\ i\ j,\ G\ i\ j=G\ j\ i,\ \forall\,h\varepsilon : \forall\ i\ j,\ \vert{}G\ i\ j-\mathrm{gramCentre4}\ i\ j\vert\le\ \varepsilon,\ \forall\,h\varepsilon_{0} : 0\le\ \varepsilon,\ \forall\,hdim : \varepsilon\cdot\ 4<\mathrm{gramMargin},\ G.\mathrm{PosDef}$ |
