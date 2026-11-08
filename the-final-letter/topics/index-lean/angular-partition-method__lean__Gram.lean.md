# `angular-partition-method/lean/Gram.lean`

[Back to the split index](index.md) · Topic: [`angular-partition-method`](../angular-partition-method/README.md)

### [`angular-partition-method/lean/Gram.lean`](../angular-partition-method/lean/Gram.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../angular-partition-method/lean/Gram.lean#L44) | theorem | `gramQuad_eq_norm_sq` | $\forall\,v : \iota\to\ E,\ \forall\,c : \iota\to\ \mathbb{R},\ \mathrm{gramQuad}\ v\ c=\Vert\sum\ i,\ c\ i\ \bullet\ v\ i\Vert^{2}$ |
| [59](../angular-partition-method/lean/Gram.lean#L59) | theorem | `gramQuad_nonneg` | $\forall\,v : \iota\to\ E,\ \forall\,c : \iota\to\ \mathbb{R},\ 0\le\ \mathrm{gramQuad}\ v\ c$ |
| [65](../angular-partition-method/lean/Gram.lean#L65) | theorem | `gramMatrix_posSemidef` | $\forall\,v : \iota\to\ E,\ (\mathrm{gramMatrix}\ v).\mathrm{PosSemidef}$ |
| [73](../angular-partition-method/lean/Gram.lean#L73) | theorem | `gramMatrix_quadForm_nonneg` | $\forall\,v : \iota\to\ E,\ \forall\,c : \iota\to\ \mathbb{R},\ 0\le\ \sum\ i,\ \sum\ j,\ c\ i\cdot\ \mathrm{gramMatrix}\ v\ i\ j\cdot\ c\ j$ |
