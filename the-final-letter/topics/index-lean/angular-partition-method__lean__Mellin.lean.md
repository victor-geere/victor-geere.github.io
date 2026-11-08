# `angular-partition-method/lean/Mellin.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/Mellin.lean`](../angular-partition-method/lean/Mellin.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../angular-partition-method/lean/Mellin.lean#L23) | theorem | `hasSum_zetaKernel_real` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{HasSum}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{rexp}(-(((n+1:\mathbb{N}):\mathbb{R}))\cdot\ t))(1/(\mathrm{rexp}\ t-1))$ |
| [47](../angular-partition-method/lean/Mellin.lean#L47) | theorem | `hasSum_zetaKernel` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{HasSum}(\lambda\ n:\mathbb{N}\Rightarrow(1:\mathbb{C})\cdot\ \mathrm{rexp}(-(((n+1:\mathbb{N}):\mathbb{R}))\cdot\ t))(\mathrm{zetaKernel}\ t)$ |
| [57](../angular-partition-method/lean/Mellin.lean#L57) | theorem | `hasSum_mellin_zetaKernel` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{HasSum}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{Gamma}\ s\cdot\ 1/(((n+1:\mathbb{N}):\mathbb{C})^{s}))(\mathrm{mellin}\ \mathrm{zetaKernel}\ s)$ |
| [81](../angular-partition-method/lean/Mellin.lean#L81) | theorem | `mellin_zetaKernel_eq_Gamma_mul_zeta` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{mellin}\ \mathrm{zetaKernel}\ s=\mathrm{Gamma}\ s\cdot\ \mathrm{riemannZeta}\ s$ |
| [93](../angular-partition-method/lean/Mellin.lean#L93) | theorem | `completedRiemannZeta_eq_GammaR_mul_zeta` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{completedRiemannZeta}\ s=\mathrm{Gamma}\mathbb{R}\ s\cdot\ \mathrm{riemannZeta}\ s$ |
| [106](../angular-partition-method/lean/Mellin.lean#L106) | theorem | `completedRiemannZeta_functional_equation` | $\forall\,s : \mathbb{C},\ \mathrm{completedRiemannZeta}(1-s)=\mathrm{completedRiemannZeta}\ s$ |
| [118](../angular-partition-method/lean/Mellin.lean#L118) | theorem | `mellin_zetaKernel_norm_le` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \Vert{}\mathrm{mellin}\ \mathrm{zetaKernel}\ s\Vert\le\ \Vert{}\mathrm{Gamma}\ s\Vert\cdot(\sum'\ n:\mathbb{N},(1:\mathbb{R})/((((n+1:\mathbb{N}):\mathbb{R})^{s.\mathrm{re}})))$ |
