# `prime-spectrum-tensor/lean/WeightBound.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/WeightBound.lean`](../prime-spectrum-tensor/lean/WeightBound.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [52](../prime-spectrum-tensor/lean/WeightBound.lean#L52) | theorem | `hasDerivAt_gauss` | $\forall\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\lambda\ t:\mathbb{R}\Rightarrow\ \mathrm{Real.exp}(-((1/20:\mathbb{R})\cdot\ t)^{2}))(-(x/200)\cdot\ \mathrm{Real.exp}(-((1/20:\mathbb{R})\cdot\ x)^{2}))\ x$ |
| [65](../prime-spectrum-tensor/lean/WeightBound.lean#L65) | theorem | `hasDerivAt_cos` | $\forall\,c\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\lambda\ t:\mathbb{R}\Rightarrow\ \mathrm{Real.cos}(c\cdot\ t))(-(c\cdot\ \mathrm{Real.sin}(c\cdot\ x)))\ x$ |
| [71](../prime-spectrum-tensor/lean/WeightBound.lean#L71) | theorem | `hasDerivAt_weight` | $\forall\,c\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\mathrm{weight}\ c)(\mathrm{weight1}\ c\ x)\ x$ |
| [79](../prime-spectrum-tensor/lean/WeightBound.lean#L79) | theorem | `hasDerivAt_weight2` | $\forall\,c\,x : \mathbb{R},\ \mathrm{HasDerivAt}(\mathrm{weight1}\ c)(\mathrm{weight2}\ c\ x)\ x$ |
| [112](../prime-spectrum-tensor/lean/WeightBound.lean#L112) | theorem | `abs_deriv2_weight_le` | $\forall\,c : \mathbb{R},\ \forall\,hc : \vert{}c\vert\le\ 3/5,\ \forall\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \forall\,hx_{60} : x\le\ 60,\ \vert{}\mathrm{deriv}(\mathrm{deriv}(\mathrm{weight}\ c))\ x\vert\le\ 1/400$ |
| [179](../prime-spectrum-tensor/lean/WeightBound.lean#L179) | theorem | `abs_deriv2_weight_le_four_fifths` | $\forall\,c : \mathbb{R},\ \forall\,hc : \vert{}c\vert\le\ 4/5,\ \forall\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \forall\,hx_{60} : x\le\ 60,\ \vert{}\mathrm{deriv}(\mathrm{deriv}(\mathrm{weight}\ c))\ x\vert\le\ 1/200$ |
| [238](../prime-spectrum-tensor/lean/WeightBound.lean#L238) | theorem | `abs_deriv2_weight_le_one` | $\forall\,c : \mathbb{R},\ \forall\,hc : \vert{}c\vert\le\ 1,\ \forall\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \forall\,hx_{60} : x\le\ 60,\ \vert{}\mathrm{deriv}(\mathrm{deriv}(\mathrm{weight}\ c))\ x\vert\le\ 1/200$ |
