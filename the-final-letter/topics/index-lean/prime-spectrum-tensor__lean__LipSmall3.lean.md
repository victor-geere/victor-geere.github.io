# `prime-spectrum-tensor/lean/LipSmall3.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/LipSmall3.lean`](../prime-spectrum-tensor/lean/LipSmall3.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [52](../prime-spectrum-tensor/lean/LipSmall3.lean#L52) | theorem | `headFour_eq_sum` | $\forall\,a : \mathbb{R},\ \sum\ j\ \in\ \mathrm{Finset.range}\ 4,(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}=\mathrm{headFour}\ a$ |
| [57](../prime-spectrum-tensor/lean/LipSmall3.lean#L57) | theorem | `headFour_antitone` | $\forall\,u\,a : \mathbb{R},\ \forall\,hu : 0\le\ u,\ \forall\,hau : u\le\ a,\ \mathrm{headFour}\ a\le\ \mathrm{headFour}\ u$ |
| [70](../prime-spectrum-tensor/lean/LipSmall3.lean#L70) | theorem | `headFour_le_of_interval` | $\forall\,u\,v\,a : \mathbb{R},\ \forall\,hu : 0<u,\ \forall\,hchk : \mathrm{headFour}\ u+1/3\le\ 5/(2\cdot\ v),\ \forall\,hau : u\le\ a,\ \forall\,hav : a\le\ v,\ \mathrm{headFour}\ a+1/3\le\ 5/(2\cdot\ a)$ |
| [83](../prime-spectrum-tensor/lean/LipSmall3.lean#L83) | theorem | `headFour_add_le` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \forall\,h_{4} : a\le\ 4,\ \mathrm{headFour}\ a+1/3\le\ 5/(2\cdot\ a)$ |
| [135](../prime-spectrum-tensor/lean/LipSmall3.lean#L135) | theorem | `sum_range_le_headFour` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \forall\,N : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ N,(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ \mathrm{headFour}\ a+1/3$ |
| [159](../prime-spectrum-tensor/lean/LipSmall3.lean#L159) | theorem | `sum_range_shifted_inv_le_five_halves` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \forall\,N : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ N,(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ 5/(2\cdot\ a)$ |
| [177](../prime-spectrum-tensor/lean/LipSmall3.lean#L177) | theorem | `tsum_shifted_inv_le_five_halves` | $\forall\,a : \mathbb{R},\ \forall\,ha : 1/2\le\ a,\ \sum'\ j:\mathbb{N},(((j:\mathbb{R})+1/4)^{2}+a^{2})^{-1}\le\ 5/(2\cdot\ a)$ |
| [183](../prime-spectrum-tensor/lean/LipSmall3.lean#L183) | theorem | `deriv_Omega_abs_le_five_halves` | $\forall\,t : \mathbb{R},\ \forall\,ht : 1\le\ t,\ \vert{}\mathrm{deriv}\ \mathrm{IntersectionForm.Omega}\ t\vert\le\ 5/(2\cdot\ t)$ |
