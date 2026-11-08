# `prime-spectrum-tensor/lean/DensityPanel.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityPanel.lean`](../prime-spectrum-tensor/lean/DensityPanel.lean) — 6 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [36](../prime-spectrum-tensor/lean/DensityPanel.lean#L36) | theorem | `deriv_Omega_abs_le_tsum` | $\forall\,t : \mathbb{R},\ \vert{}\mathrm{deriv}\ \mathrm{IntersectionForm.Omega}\ t\vert\le(1/2)\cdot\ \sum'\ j:\mathbb{N},(((j:\mathbb{R})+1/4)^{2}+(t/2)^{2})^{-1}$ |
| [55](../prime-spectrum-tensor/lean/DensityPanel.lean#L55) | theorem | `sum_range_head_le` | $\forall\,a : \mathbb{R},\ \forall\,ha : 0<a,\ \forall\,K : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ K,(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ K/a^{2}$ |
| [67](../prime-spectrum-tensor/lean/DensityPanel.lean#L67) | theorem | `tail_step` | $\forall\,K : \mathbb{N},\ \forall\,hK : 2\le\ K,\ \forall\,m : \mathbb{N},\ ((((m+K:\mathbb{N}):\mathbb{R}))^{2})^{-1}\le\ 1/((m:\mathbb{R})+K-1)-1/((m:\mathbb{R})+K)$ |
| [80](../prime-spectrum-tensor/lean/DensityPanel.lean#L80) | theorem | `sum_range_tail_le` | $\forall\,K : \mathbb{N},\ \forall\,hK : 2\le\ K,\ \forall\,m : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ m,((((j+K:\mathbb{N}):\mathbb{R}))^{2})^{-1}\le\ 1/((K:\mathbb{R})-1)$ |
| [105](../prime-spectrum-tensor/lean/DensityPanel.lean#L105) | theorem | `tsum_shifted_inv_le` | $\forall\,a : \mathbb{R},\ \forall\,ha : 2\le\ a,\ \sum'\ j:\mathbb{N},(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ 6/a$ |
| [151](../prime-spectrum-tensor/lean/DensityPanel.lean#L151) | theorem | `deriv_Omega_abs_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 4\le\ t,\ \vert{}\mathrm{deriv}\ \mathrm{IntersectionForm.Omega}\ t\vert\le\ 6/t$ |
