# `prime-spectrum-tensor/lean/TrigGram.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/TrigGram.lean`](../prime-spectrum-tensor/lean/TrigGram.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [10](../prime-spectrum-tensor/lean/TrigGram.lean#L10) | theorem | `cos_quadratic_form` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,a\,x : \iota\to\ \mathbb{R},\ \forall\,t : \mathbb{R},\ \sum\ i,\ \sum\ j,\ x\ i\cdot\ x\ j\cdot\ \mathrm{Real.cos}((a\ i-a\ j)\cdot\ t)=(\sum\ i,\ x\ i\cdot\ \mathrm{Real.cos}(a\ i\cdot\ t))^{2}+(\sum\ i,\ x\ i\cdot\ \mathrm{Real.sin}(a\ i\cdot\ t))^{2}$ |
| [21](../prime-spectrum-tensor/lean/TrigGram.lean#L21) | theorem | `cos_quadratic_form_nonneg` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,a\,x : \iota\to\ \mathbb{R},\ \forall\,t : \mathbb{R},\ 0\le\ \sum\ i,\ \sum\ j,\ x\ i\cdot\ x\ j\cdot\ \mathrm{Real.cos}((a\ i-a\ j)\cdot\ t)$ |
