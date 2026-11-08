# `angular-partition-method/lean/CriticalStrip.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/CriticalStrip.lean`](../angular-partition-method/lean/CriticalStrip.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [30](../angular-partition-method/lean/CriticalStrip.lean#L30) | theorem | `regularizedMellin_eq_mellin_sub_poles` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{regularizedMellin}\ s=\mathrm{mellin}\ \mathrm{zetaKernel}\ s-1/(s-1)+1/(2\cdot\ s)$ |
| [38](../angular-partition-method/lean/CriticalStrip.lean#L38) | theorem | `regularizedMellin_differentiableAt_of_ne` | $\forall\,s : \mathbb{C},\ \forall\,hs_{0} : 0<s.\mathrm{re},\ \forall\,hs_{1} : s\ne\ 1,\ \mathrm{DifferentiableAt}\ \mathbb{C}\ \mathrm{regularizedMellin}\ s$ |
| [69](../angular-partition-method/lean/CriticalStrip.lean#L69) | theorem | `regularizedMellin_differentiableAt` | $\forall\,s : \mathbb{C},\ \forall\,hs_{0} : 0<s.\mathrm{re},\ \forall\,hs_{1} : s.\mathrm{re}<1,\ \mathrm{DifferentiableAt}\ \mathbb{C}\ \mathrm{regularizedMellin}\ s$ |
| [79](../angular-partition-method/lean/CriticalStrip.lean#L79) | theorem | `completedRiemannZeta_finite_part` | $\forall\,s : \mathbb{C},\ \mathrm{completedRiemannZeta}\ s=\mathrm{completedRiemannZeta}_{0}\ s-1/s-1/(1-s)$ |
| [84](../angular-partition-method/lean/CriticalStrip.lean#L84) | theorem | `completedRiemannZeta₀_functional_equation` | $\forall\,s : \mathbb{C},\ \mathrm{completedRiemannZeta}_{0}(1-s)=\mathrm{completedRiemannZeta}_{0}\ s$ |
| [94](../angular-partition-method/lean/CriticalStrip.lean#L94) | theorem | `regularizedMellin_residue_one` | $:\mathrm{Filter.Tendsto}(\lambda\ s:\mathbb{C}\Rightarrow(s-1)\cdot(\mathrm{Gamma}\ s\cdot\ \mathrm{riemannZeta}\ s))(\mathrm{nhdsWithin}\ 1(\{1\}:\mathrm{Set}\ \mathbb{C})^{c})(\mathrm{nhds}\ 1)$ |
| [109](../angular-partition-method/lean/CriticalStrip.lean#L109) | theorem | `regularizedMellin_residue_zero` | $:\mathrm{Filter.Tendsto}(\lambda\ s:\mathbb{C}\Rightarrow\ s\cdot(\mathrm{Gamma}\ s\cdot\ \mathrm{riemannZeta}\ s))(\mathrm{nhdsWithin}\ 0(\{0\}:\mathrm{Set}\ \mathbb{C})^{c})(\mathrm{nhds}(-(2^{-1})))$ |
