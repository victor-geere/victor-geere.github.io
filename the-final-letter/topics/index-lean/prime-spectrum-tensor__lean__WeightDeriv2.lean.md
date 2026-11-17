# `prime-spectrum-tensor/lean/WeightDeriv2.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/WeightDeriv2.lean`](../prime-spectrum-tensor/lean/WeightDeriv2.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [38](../prime-spectrum-tensor/lean/WeightDeriv2.lean#L38) | theorem | `abs_deriv2_weight_le_decay` | $\forall\,c\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \vert{}\mathrm{deriv}(\mathrm{deriv}(\mathrm{weight}\ c))\ x\vert\le(1/400:\mathbb{R})\cdot\ \mathrm{Real.exp}(-(x^{2}/400))\cdot(1/200+x^{2}/40000+c^{2}+2\cdot(x/200)\cdot\ \vert{}c\vert)$ |
| [99](../prime-spectrum-tensor/lean/WeightDeriv2.lean#L99) | theorem | `abs_deriv2_weight_le_div` | $\forall\,c : \mathbb{R},\ \forall\,a\,b\,t : \mathbb{R},\ \forall\,ha : 0\le\ a,\ \forall\,hat : a\le\ t,\ \forall\,htb : t\le\ b,\ \vert{}\mathrm{deriv}(\mathrm{deriv}(\mathrm{weight}\ c))\ t\vert\le(1/400:\mathbb{R})\cdot\ \mathrm{Real.exp}(-(a^{2}/400))\cdot(1/200+b^{2}/40000+c^{2}+2\cdot(b/200)\cdot\ \vert{}c\vert)$ |
