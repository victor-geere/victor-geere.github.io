# `prime-spectrum-tensor/lean/LipSmall2.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/LipSmall2.lean`](../prime-spectrum-tensor/lean/LipSmall2.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [34](../prime-spectrum-tensor/lean/LipSmall2.lean#L34) | theorem | `sum_range_shifted_inv_le` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \forall\,N : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ N,(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le(a+2)/a^{2}+1/a$ |
| [71](../prime-spectrum-tensor/lean/LipSmall2.lean#L71) | theorem | `tsum_shifted_inv_le_six` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \sum'\ j:\mathbb{N},(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ 6/a$ |
| [84](../prime-spectrum-tensor/lean/LipSmall2.lean#L84) | theorem | `deriv_Omega_abs_le_six` | $\forall\,t : \mathbb{R},\ \forall\,ht : 1\le\ t,\ \vert{}\mathrm{deriv}\ \mathrm{IntersectionForm.Omega}\ t\vert\le\ 6/t$ |
