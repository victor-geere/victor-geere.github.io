# `zeta-from-theta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`zeta-from-theta`](../zeta-from-theta/README.md)

### [`zeta-from-theta/lean/Topic.lean`](../zeta-from-theta/lean/Topic.lean) — 14 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../zeta-from-theta/lean/Topic.lean#L39) | theorem | `summable_zetaSeries` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{Summable}(\lambda\ n:\mathbb{N}\Rightarrow(1:\mathbb{C})/(n:\mathbb{C})^{s})$ |
| [60](../zeta-from-theta/lean/Topic.lean#L60) | theorem | `zetaSeries_eq_riemannZeta` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{zetaSeries}\ s=\mathrm{riemannZeta}\ s$ |
| [66](../zeta-from-theta/lean/Topic.lean#L66) | theorem | `zetaSeries_eq_completed_div` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{zetaSeries}\ s=\mathrm{completedRiemannZeta}\ s/\mathrm{Complex.Gamma}\mathbb{R}\ s$ |
| [88](../zeta-from-theta/lean/Topic.lean#L88) | theorem | `LambdaTheta_eq_mellin` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{LambdaTheta}\ s=\mathrm{mellin}\ \mathrm{ZetaTheta.psi}(s/2)$ |
| [95](../zeta-from-theta/lean/Topic.lean#L95) | theorem | `LambdaTheta_one_sub` | $\forall\,s : \mathbb{C},\ \mathrm{LambdaTheta}(1-s)=\mathrm{LambdaTheta}\ s$ |
| [99](../zeta-from-theta/lean/Topic.lean#L99) | theorem | `differentiableAt_LambdaTheta` | $\forall\,s : \mathbb{C},\ \forall\,hs_{0} : s\ne\ 0,\ \forall\,hs_{1} : s\ne\ 1,\ \mathrm{DifferentiableAt}\ \mathbb{C}\ \mathrm{LambdaTheta}\ s$ |
| [111](../zeta-from-theta/lean/Topic.lean#L111) | theorem | `zetaTheta_eq_zetaSeries` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{zetaTheta}\ s=\mathrm{zetaSeries}\ s$ |
| [122](../zeta-from-theta/lean/Topic.lean#L122) | theorem | `zetaTheta_one_sub` | $\forall\,s : \mathbb{C},\ \forall\,hs : \forall\ n:\mathbb{N},\ s\ne-(n:\mathbb{C}),\ \forall\,\_hs' : s\ne\ 1,\ \forall\,hG : \mathrm{Complex.Gamma}\mathbb{R}(1-s)\ne\ 0,\ \mathrm{zetaTheta}(1-s)=2\cdot(2\cdot(\mathrm{Real.pi}:\mathbb{C}))^{-s}\cdot\ \mathrm{Complex.Gamma}\ s\cdot\ \mathrm{Complex.cos}(\mathrm{Real.pi}\cdot\ s/2)\cdot\ \mathrm{zetaTheta}\ s$ |
| [152](../zeta-from-theta/lean/Topic.lean#L152) | theorem | `zetaTheta_eq_riemannZeta` | $\forall\,s : \mathbb{C},\ \forall\,hs : \forall\ n:\mathbb{N},\ s\ne-(n:\mathbb{C}),\ \forall\,hs' : s\ne\ 1,\ \mathrm{zetaTheta}\ s=\mathrm{riemannZeta}\ s$ |
| [167](../zeta-from-theta/lean/Topic.lean#L167) | theorem | `zetaTheta_eq_riemannZeta_of_ne_zero_one` | $\forall\,s : \mathbb{C},\ \forall\,hs_{0} : s\ne\ 0,\ \forall\,hs_{1} : s\ne\ 1,\ \mathrm{zetaTheta}\ s=\mathrm{riemannZeta}\ s$ |
| [178](../zeta-from-theta/lean/Topic.lean#L178) | theorem | `zetaTheta_trivial_zero` | $\forall\,n : \mathbb{N},\ \mathrm{zetaTheta}(-(2\cdot((n+1:\mathbb{N}):\mathbb{C})))=0$ |
| [188](../zeta-from-theta/lean/Topic.lean#L188) | theorem | `zetaTheta_removable_at_trivial_zero` | $\forall\,n : \mathbb{N},\ \mathrm{Tendsto}\ \mathrm{zetaTheta}(\mathcal{N}[\ne](-(2\cdot((n+1:\mathbb{N}):\mathbb{C}))))(\mathcal{N}\ 0)$ |
| [226](../zeta-from-theta/lean/Topic.lean#L226) | theorem | `riemannZeta_one_sub_from_theta` | $\forall\,s : \mathbb{C},\ \forall\,hs : \forall\ n:\mathbb{N},\ s\ne-(n:\mathbb{C}),\ \forall\,hs' : s\ne\ 1,\ \forall\,hG : \mathrm{Complex.Gamma}\mathbb{R}(1-s)\ne\ 0,\ \mathrm{riemannZeta}(1-s)=2\cdot(2\cdot(\mathrm{Real.pi}:\mathbb{C}))^{-s}\cdot\ \mathrm{Complex.Gamma}\ s\cdot\ \mathrm{Complex.cos}(\mathrm{Real.pi}\cdot\ s/2)\cdot\ \mathrm{riemannZeta}\ s$ |
| [251](../zeta-from-theta/lean/Topic.lean#L251) | theorem | `riemannZeta_one_sub_from_theta'` | $\forall\,s : \mathbb{C},\ \forall\,hs : \forall\ n:\mathbb{N},\ s\ne-(n:\mathbb{C}),\ \forall\,hs' : s\ne\ 1,\ \mathrm{riemannZeta}(1-s)=2\cdot(2\cdot(\mathrm{Real.pi}:\mathbb{C}))^{-s}\cdot\ \mathrm{Complex.Gamma}\ s\cdot\ \mathrm{Complex.cos}(\mathrm{Real.pi}\cdot\ s/2)\cdot\ \mathrm{riemannZeta}\ s$ |
