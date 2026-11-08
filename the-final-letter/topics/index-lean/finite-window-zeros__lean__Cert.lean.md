# `finite-window-zeros/lean/Cert.lean`

[Back to the split index](index.md) · Topic: [`finite-window-zeros`](../finite-window-zeros/README.md)

### [`finite-window-zeros/lean/Cert.lean`](../finite-window-zeros/lean/Cert.lean) — 9 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [55](../finite-window-zeros/lean/Cert.lean#L55) | theorem | `CpowConditions_of_OK` | $\forall\,N\,k\,kI\,n : \mathbb{N},\ \forall\,b : \mathbb{N},\ \forall\,S : \mathrm{Cx},\ \forall\,h : \mathrm{CpowOK}\ N\ k\ \mathrm{kI}\ n\ b\ S=\mathrm{true},\ \mathrm{CpowConditions}\ N\ k\ \mathrm{kI}\ n\ b\ S$ |
| [70](../finite-window-zeros/lean/Cert.lean#L70) | theorem | `PairConditions_of_OK` | $\forall\,p : \mathrm{CpowPair},\ \forall\,S : \mathrm{Cx},\ \forall\,h : \mathrm{PairOK}\ p\ S=\mathrm{true},\ \mathrm{PairConditions}\ p\ S$ |
| [79](../finite-window-zeros/lean/Cert.lean#L79) | theorem | `allOK_conditions` | $\forall\,ps : \mathrm{List}\ \mathrm{CpowPair},\ \forall\,S : \mathrm{Cx},\ \forall\,h : \mathrm{allOK}\ \mathrm{ps}\ S=\mathrm{true},\ \forall\ p\ \in\ \mathrm{ps},\ \mathrm{PairConditions}\ p\ S$ |
| [94](../finite-window-zeros/lean/Cert.lean#L94) | theorem | `pairBox_mem` | $\forall\,p : \mathrm{CpowPair},\ \forall\,S : \mathrm{Cx},\ \forall\,s : \mathbb{C},\ \forall\,hs : \mathrm{Cx.mem}\ s\ S,\ \forall\,h : \mathrm{PairConditions}\ p\ S,\ \mathrm{Cx.mem}(\mathrm{pairValue}\ p\ s)(\mathrm{pairBox}\ p\ S)$ |
| [112](../finite-window-zeros/lean/Cert.lean#L112) | theorem | `sumBox_mem` | $\forall\,ps : \mathrm{List}\ \mathrm{CpowPair},\ \forall\,S : \mathrm{Cx},\ \forall\,s : \mathbb{C},\ \forall\,hs : \mathrm{Cx.mem}\ s\ S,\ \forall\,h : \forall\ p\ \in\ \mathrm{ps},\ \mathrm{PairConditions}\ p\ S,\ \mathrm{Cx.mem}(\mathrm{sumValue}\ \mathrm{ps}\ s)(\mathrm{sumBox}\ \mathrm{ps}\ S)$ |
| [134](../finite-window-zeros/lean/Cert.lean#L134) | theorem | `sumValue_params` | $\forall\,M : \mathbb{N},\ \forall\,s : \mathbb{C},\ \mathrm{sumValue}(\mathrm{params}\ M)\ s=\sum\ m\ \in\ \mathrm{Finset.range}\ M,\ \mathrm{pairTerm}\ s\ m$ |
| [180](../finite-window-zeros/lean/Cert.lean#L180) | lemma | `tail_bound_main` | $:\Vert\sum'\ m:\mathbb{N},\ \mathrm{pairTerm}((1/2:\mathbb{C})+5\cdot\ \mathrm{Complex}.I)(m+100)\Vert\le(1:\mathbb{R})$ |
| [255](../finite-window-zeros/lean/Cert.lean#L255) | theorem | `containsZero_iff` | $\forall\,Z : \mathrm{Cx},\ \mathrm{containsZero}\ Z=\mathrm{true}\leftrightarrow\ \mathrm{Cx.mem}(0:\mathbb{C})\ Z$ |
| [272](../finite-window-zeros/lean/Cert.lean#L272) | theorem | `zeta_half_plus_five_ne_zero` | $:\mathrm{riemannZeta}((1/2:\mathbb{C})+5\cdot\ \mathrm{Complex}.I)\ne\ 0$ |
