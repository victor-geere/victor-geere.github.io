# `prime-spectrum-tensor/lean/GaussianTail.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/GaussianTail.lean`](../prime-spectrum-tensor/lean/GaussianTail.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [18](../prime-spectrum-tensor/lean/GaussianTail.lean#L18) | theorem | `tendsto_gauss_neg` | $\forall\,b : \mathbb{R},\ \forall\,hb : 0<b,\ \mathrm{Tendsto}(\lambda\ y:\mathbb{R}\Rightarrow\ \mathrm{Real.exp}(-(b\cdot\ y^{2})))\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [27](../prime-spectrum-tensor/lean/GaussianTail.lean#L27) | theorem | `integral_Ioi_gaussian_moment` | $\forall\,T : \mathbb{R},\ \int\ x\ \text{in}\ \mathrm{Set.Ioi}\ T,(1/400:\mathbb{R})\cdot\ x\cdot\ \mathrm{Real.exp}(-(x^{2}/400))=\mathrm{Real.exp}(-(T^{2}/400))/2$ |
