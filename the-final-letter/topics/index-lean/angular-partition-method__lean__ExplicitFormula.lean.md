# `angular-partition-method/lean/ExplicitFormula.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/ExplicitFormula.lean`](../angular-partition-method/lean/ExplicitFormula.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [28](../angular-partition-method/lean/ExplicitFormula.lean#L28) | theorem | `explicitFormula_poleContour` | $\forall\,h : \mathbb{C}\to\ \mathbb{C},\ \forall\,c : \mathbb{C},\ \forall\,R : \mathbb{R},\ \forall\,h_{0} : (0:\mathbb{C})\ \in\ \mathrm{ball}\ c\ R,\ \forall\,h_{1} : (1:\mathbb{C})\ \in\ \mathrm{ball}\ c\ R,\ \forall\,hd : \mathrm{DiffContOnCl}\ \mathbb{C}\ h(\mathrm{ball}\ c\ R),\ (\oint\ z\ \text{in}\ C(c,\ R),\ \mathrm{poleKernel}\ z\cdot\ h\ z)=(2\cdot(\mathrm{Real.pi}:\mathbb{C})\cdot\ I)\cdot(h\ 1-h\ 0)$ |
| [81](../angular-partition-method/lean/ExplicitFormula.lean#L81) | theorem | `explicitFormula_poleContour_residue_form` | $\forall\,h : \mathbb{C}\to\ \mathbb{C},\ \forall\,c : \mathbb{C},\ \forall\,R : \mathbb{R},\ \forall\,h_{0} : (0:\mathbb{C})\ \in\ \mathrm{ball}\ c\ R,\ \forall\,h_{1} : (1:\mathbb{C})\ \in\ \mathrm{ball}\ c\ R,\ \forall\,hd : \mathrm{DiffContOnCl}\ \mathbb{C}\ h(\mathrm{ball}\ c\ R),\ (\oint\ z\ \text{in}\ C(c,\ R),\ \mathrm{poleKernel}\ z\cdot\ h\ z)=(2\cdot(\mathrm{Real.pi}:\mathbb{C})\cdot\ I)\cdot\ h\ 1+(2\cdot(\mathrm{Real.pi}:\mathbb{C})\cdot\ I)\cdot(-h\ 0)$ |
