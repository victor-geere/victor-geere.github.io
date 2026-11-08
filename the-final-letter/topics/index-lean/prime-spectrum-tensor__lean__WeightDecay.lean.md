# `prime-spectrum-tensor/lean/WeightDecay.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/WeightDecay.lean`](../prime-spectrum-tensor/lean/WeightDecay.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [18](../prime-spectrum-tensor/lean/WeightDecay.lean#L18) | theorem | `exp_neg_le_inv_one_add` | $\forall\,u : \mathbb{R},\ \forall\,hu : 0\le\ u,\ \mathrm{Real.exp}(-u)\le\ 1/(1+u)$ |
| [26](../prime-spectrum-tensor/lean/WeightDecay.lean#L26) | theorem | `abs_weight_le_exp` | $\forall\,c\,t : \mathbb{R},\ \vert{}\mathrm{weight}\ c\ t\vert\le(1/400:\mathbb{R})\cdot\ \mathrm{Real.exp}(-(t^{2}/400))$ |
| [39](../prime-spectrum-tensor/lean/WeightDecay.lean#L39) | theorem | `abs_weight_le_div` | $\forall\,c : \mathbb{R},\ \forall\,a\,t : \mathbb{R},\ \forall\,ha : 0\le\ a,\ \forall\,hat : a\le\ t,\ \vert{}\mathrm{weight}\ c\ t\vert\le(1/400:\mathbb{R})/(1+a^{2}/400)$ |
