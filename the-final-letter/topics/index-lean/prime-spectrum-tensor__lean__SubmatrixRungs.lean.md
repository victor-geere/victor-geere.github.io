# `prime-spectrum-tensor/lean/SubmatrixRungs.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/SubmatrixRungs.lean`](../prime-spectrum-tensor/lean/SubmatrixRungs.lean) — 6 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [18](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L18) | theorem | `gaussianGram4_submatrix_posDef` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 4,\ \forall\,he : \mathrm{Function.Injective}\ e,\ ((\mathrm{gaussianGram4}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{PosDef}$ |
| [24](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L24) | theorem | `gaussianGram4_submatrix_posSemidef` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 4,\ \forall\,he : \mathrm{Function.Injective}\ e,\ ((\mathrm{gaussianGram4}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{PosSemidef}$ |
| [30](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L30) | theorem | `gaussianGram5_submatrix_posDef` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 5,\ \forall\,he : \mathrm{Function.Injective}\ e,\ ((\mathrm{gaussianGram5}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{PosDef}$ |
| [36](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L36) | theorem | `gaussianGram5_submatrix_posSemidef` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 5,\ \forall\,he : \mathrm{Function.Injective}\ e,\ ((\mathrm{gaussianGram5}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{PosSemidef}$ |
| [42](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L42) | theorem | `gaussianGram4_principal_minor_pos` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 4,\ \forall\,he : \mathrm{Function.Injective}\ e,\ 0<((\mathrm{gaussianGram4}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{det}$ |
| [48](../prime-spectrum-tensor/lean/SubmatrixRungs.lean#L48) | theorem | `gaussianGram5_principal_minor_pos` | $\forall\,m : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ m],\ \forall\,[\mathrm{DecidableEq}\ m],\ \forall\,e : m\to\ \mathrm{Fin}\ 5,\ \forall\,he : \mathrm{Function.Injective}\ e,\ 0<((\mathrm{gaussianGram5}(1/20)).\mathrm{submatrix}\ e\ e).\mathrm{det}$ |
