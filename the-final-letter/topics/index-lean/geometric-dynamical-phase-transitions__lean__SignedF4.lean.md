# `geometric-dynamical-phase-transitions/lean/SignedF4.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/SignedF4.lean`](../geometric-dynamical-phase-transitions/lean/SignedF4.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [33](../geometric-dynamical-phase-transitions/lean/SignedF4.lean#L33) | theorem | `matProdC_map_conj` | $\forall\,S\,Sinv : \mathrm{Matrix}\ \iota\ \iota\ \mathbb{k},\ \forall\,hS : S\cdot\ \mathrm{Sinv}=1,\ \forall\,hS' : \mathrm{Sinv}\cdot\ S=1,\ \forall\ L:\mathrm{List}(\mathrm{Matrix}\ \iota\ \iota\ \mathbb{k}),\ \mathrm{matProdC}(L.\mathrm{map}(\lambda\ A\Rightarrow\ \mathrm{Sinv}\cdot\ A\cdot\ S))=\mathrm{Sinv}\cdot\ \mathrm{matProdC}\ L\cdot\ S\ \vert[]\Rightarrow\ \mathrm{by}\ \mathrm{simp}[\mathrm{matProdC},\ \mathrm{hS'}]\ \vert\ A::\mathrm{As}\Rightarrow\ \mathrm{by}\ \mathrm{rw}[\mathrm{List.map}_{\mathrm{cons}},\ \mathrm{matProdC},\ \mathrm{matProdC}_{\mathrm{map}_{\mathrm{conj}}}\ S\ \mathrm{Sinv}\ \mathrm{hS}\ \mathrm{hS'}\ \mathrm{As}]\ \mathrm{change}(\mathrm{Sinv}\cdot\ A\cdot\ S)\cdot(\mathrm{Sinv}\cdot\ \mathrm{matProdC}\ \mathrm{As}\cdot\ S)=\mathrm{Sinv}\cdot(A\cdot\ \mathrm{matProdC}\ \mathrm{As})\cdot\ S\ \mathrm{calc}(\mathrm{Sinv}\cdot\ A\cdot\ S)\cdot(\mathrm{Sinv}\cdot\ \mathrm{matProdC}\ \mathrm{As}\cdot\ S)=\mathrm{Sinv}\cdot\ A\cdot(S\cdot\ \mathrm{Sinv})\cdot\ \mathrm{matProdC}\ \mathrm{As}\cdot\ S$ |
| [58](../geometric-dynamical-phase-transitions/lean/SignedF4.lean#L58) | theorem | `signedGauge_mul_inv` | $:\mathrm{signedGauge}\cdot\ \mathrm{signedGaugeInv}=1$ |
| [62](../geometric-dynamical-phase-transitions/lean/SignedF4.lean#L62) | theorem | `signedGauge_inv_mul` | $:\mathrm{signedGaugeInv}\cdot\ \mathrm{signedGauge}=1$ |
| [72](../geometric-dynamical-phase-transitions/lean/SignedF4.lean#L72) | theorem | `signedGauge_nonTriangular` | $:(\mathrm{signedGaugeInv}\cdot\ \mathrm{signedRegMat}\ 2\ 1\cdot\ \mathrm{signedGauge})\ 1\ 0=-1$ |
| [76](../geometric-dynamical-phase-transitions/lean/SignedF4.lean#L76) | theorem | `signedGauge_nonTriangular_ne_zero` | $:(\mathrm{signedGaugeInv}\cdot\ \mathrm{signedRegMat}\ 2\ 1\cdot\ \mathrm{signedGauge})\ 1\ 0\ne\ 0$ |
