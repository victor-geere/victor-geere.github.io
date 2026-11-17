# `prime-spectrum-tensor/lean/PoleQuadraticForm.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/PoleQuadraticForm.lean`](../prime-spectrum-tensor/lean/PoleQuadraticForm.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../prime-spectrum-tensor/lean/PoleQuadraticForm.lean#L23) | theorem | `cosh_quadratic_form` | $\forall\,\iota : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ \iota],\ \forall\,a\,x : \iota\to\ \mathbb{R},\ \sum\ i,\ \sum\ j,\ x\ i\cdot\ x\ j\cdot\ \mathrm{Real.cosh}((a\ i-a\ j)/2)=(\sum\ i,\ x\ i\cdot\ \mathrm{Real.exp}(a\ i/2))\cdot(\sum\ i,\ x\ i\cdot\ \mathrm{Real.exp}(-(a\ i)/2))$ |
