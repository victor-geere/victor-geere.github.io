# `prime-spectrum-tensor/lean/DensityEnclosure.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/DensityEnclosure.lean`](../prime-spectrum-tensor/lean/DensityEnclosure.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../prime-spectrum-tensor/lean/DensityEnclosure.lean#L26) | theorem | `omega_eq_Omega` | $\forall\,t : \mathbb{R},\ \mathrm{omega}\ t=\mathrm{IntersectionForm.Omega}\ t$ |
| [35](../prime-spectrum-tensor/lean/DensityEnclosure.lean#L35) | theorem | `density_integrand_neg` | $\forall\,c\,\sigma\,t : \mathbb{R},\ \mathrm{Real.exp}(-(\sigma\cdot(-t))^{2})\cdot\ \mathrm{Real.cos}(c\cdot(-t))\cdot\ \mathrm{IntersectionForm.Omega}(-t)=\mathrm{Real.exp}(-(\sigma\cdot\ t)^{2})\cdot\ \mathrm{Real.cos}(c\cdot\ t)\cdot\ \mathrm{IntersectionForm.Omega}\ t$ |
| [44](../prime-spectrum-tensor/lean/DensityEnclosure.lean#L44) | theorem | `densityTerm_eq_two_mul_density` | $\forall\,c\,\sigma : \mathbb{R},\ \mathrm{densityTerm}\ c\ \sigma=2\cdot\ \mathrm{IntersectionForm.density}\ \sigma\ c$ |
