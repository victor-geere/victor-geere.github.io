# `prime-spectrum-tensor/lean/SecondDeriv.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/SecondDeriv.lean`](../prime-spectrum-tensor/lean/SecondDeriv.lean) — 13 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [49](../prime-spectrum-tensor/lean/SecondDeriv.lean#L49) | lemma | `norm_sPointR_add_sq` | $\forall\,t : \mathbb{R},\ \forall\,j : \mathbb{N},\ \Vert{}\mathrm{IntersectionForm.sPointR}\ t+(j:\mathbb{C})\Vert^{2}=((j:\mathbb{R})+1/4)^{2}+(t/2)^{2}$ |
| [58](../prime-spectrum-tensor/lean/SecondDeriv.lean#L58) | lemma | `differentiableAt_iteratedDeriv_one` | $\forall\,t : \mathbb{R},\ \mathrm{DifferentiableAt}\ \mathbb{R}(\mathrm{iteratedDeriv}\ 1\ \mathrm{Rh45.Psi})\ t$ |
| [78](../prime-spectrum-tensor/lean/SecondDeriv.lean#L78) | lemma | `norm_polygamma_term_cube_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \forall\,j : \mathbb{N},\ \Vert(\mathrm{IntersectionForm.sPointR}\ t+(j:\mathbb{C}))^{-3:\mathbb{Z}}\Vert\le(2/t)\cdot((((j:\mathbb{R})+1/4)^{2}+(t/2)^{2}))^{-1}$ |
| [115](../prime-spectrum-tensor/lean/SecondDeriv.lean#L115) | lemma | `hasSum_polygamma_cube` | $\forall\,t : \mathbb{R},\ \mathrm{HasSum}(\lambda\ j:\mathbb{N}\Rightarrow(\mathrm{IntersectionForm.sPointR}\ t+(j:\mathbb{C}))^{-3:\mathbb{Z}})(-(1/2)\cdot\ \mathrm{deriv}(\mathrm{deriv}\ \mathrm{Complex.digamma})(\mathrm{IntersectionForm.sPointR}\ t))$ |
| [143](../prime-spectrum-tensor/lean/SecondDeriv.lean#L143) | lemma | `norm_deriv2_digamma_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 1\le\ t,\ \Vert{}\mathrm{deriv}(\mathrm{deriv}\ \mathrm{Complex.digamma})(\mathrm{IntersectionForm.sPointR}\ t)\Vert\le\ 20/t^{2}$ |
| [180](../prime-spectrum-tensor/lean/SecondDeriv.lean#L180) | theorem | `deriv2_Omega_eq` | $\forall\,t : \mathbb{R},\ \mathrm{deriv}(\mathrm{deriv}\ \mathrm{IntersectionForm.Omega})\ t=(\mathrm{iteratedDeriv}\ 2\ \mathrm{Rh45.Psi}\ t).\mathrm{re}$ |
| [194](../prime-spectrum-tensor/lean/SecondDeriv.lean#L194) | lemma | `norm_iteratedDeriv_two_Psi` | $\forall\,t : \mathbb{R},\ \Vert{}\mathrm{iteratedDeriv}\ 2\ \mathrm{Rh45.Psi}\ t\Vert=(1/4)\cdot\ \Vert{}\mathrm{deriv}(\mathrm{deriv}\ \mathrm{Complex.digamma})(\mathrm{Rh45.digammaLine}\ t)\Vert$ |
| [203](../prime-spectrum-tensor/lean/SecondDeriv.lean#L203) | theorem | `abs_deriv2_Omega_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 1\le\ t,\ \vert{}\mathrm{deriv}(\mathrm{deriv}\ \mathrm{IntersectionForm.Omega})\ t\vert\le\ 5/t^{2}$ |
| [219](../prime-spectrum-tensor/lean/SecondDeriv.lean#L219) | theorem | `sum_range_quarter_cube_le` | $\forall\,N : \mathbb{N},\ \sum\ j\ \in\ \mathrm{Finset.range}\ N,((((j:\mathbb{R})+1/4)^{3}))^{-1}\le\ 66$ |
| [252](../prime-spectrum-tensor/lean/SecondDeriv.lean#L252) | theorem | `tsum_quarter_cube_le` | $:\sum'\ j:\mathbb{N},((((j:\mathbb{R})+1/4)^{3}))^{-1}\le\ 66$ |
| [256](../prime-spectrum-tensor/lean/SecondDeriv.lean#L256) | lemma | `norm_term_cube_le_quarter` | $\forall\,t : \mathbb{R},\ \forall\,j : \mathbb{N},\ \Vert(\mathrm{IntersectionForm.sPointR}\ t+(j:\mathbb{C}))^{-3:\mathbb{Z}}\Vert\le((((j:\mathbb{R})+1/4)^{3}))^{-1}$ |
| [296](../prime-spectrum-tensor/lean/SecondDeriv.lean#L296) | theorem | `norm_deriv2_digamma_le_global` | $\forall\,t : \mathbb{R},\ \Vert{}\mathrm{deriv}(\mathrm{deriv}\ \mathrm{Complex.digamma})(\mathrm{IntersectionForm.sPointR}\ t)\Vert\le\ 132$ |
| [315](../prime-spectrum-tensor/lean/SecondDeriv.lean#L315) | theorem | `abs_deriv2_Omega_le_global` | $\forall\,t : \mathbb{R},\ \vert{}\mathrm{deriv}(\mathrm{deriv}\ \mathrm{IntersectionForm.Omega})\ t\vert\le\ 33$ |
