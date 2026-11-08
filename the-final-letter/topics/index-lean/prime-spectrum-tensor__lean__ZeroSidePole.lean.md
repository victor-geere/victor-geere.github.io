# `prime-spectrum-tensor/lean/ZeroSidePole.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/ZeroSidePole.lean`](../prime-spectrum-tensor/lean/ZeroSidePole.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [36](../prime-spectrum-tensor/lean/ZeroSidePole.lean#L36) | theorem | `zeroSideGaussian_zero` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{zeroSideGaussian}\ c\ \sigma\ 0=((2\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}:\mathbb{R}):\mathbb{C})\cdot\ \mathrm{Complex.exp}(((\sigma^{2}:\mathbb{R}):\mathbb{C})/4)\cdot\ \mathrm{Complex.exp}(((c:\mathbb{R}):\mathbb{C})/2)$ |
| [45](../prime-spectrum-tensor/lean/ZeroSidePole.lean#L45) | theorem | `zeroSideGaussian_one` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{zeroSideGaussian}\ c\ \sigma\ 1=((2\cdot\ \mathrm{Real.pi}\cdot\ \sigma^{2}:\mathbb{R}):\mathbb{C})\cdot\ \mathrm{Complex.exp}(((\sigma^{2}:\mathbb{R}):\mathbb{C})/4)\cdot\ \mathrm{Complex.exp}(-((c:\mathbb{R}):\mathbb{C})/2)$ |
| [55](../prime-spectrum-tensor/lean/ZeroSidePole.lean#L55) | theorem | `poleTerm_eq_zeroSideGaussian_pole` | $\forall\,c\,\sigma : \mathbb{R},\ ((\mathrm{poleTerm}\ c\ \sigma:\mathbb{R}):\mathbb{C})=\mathrm{zeroSideGaussian}\ c\ \sigma\ 0+\mathrm{zeroSideGaussian}\ c\ \sigma\ 1$ |
| [82](../prime-spectrum-tensor/lean/ZeroSidePole.lean#L82) | theorem | `poleTerm_eq_zeroSideGaussian_pole_re` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{poleTerm}\ c\ \sigma=(\mathrm{zeroSideGaussian}\ c\ \sigma\ 0+\mathrm{zeroSideGaussian}\ c\ \sigma\ 1).\mathrm{re}$ |
