# `prime-spectrum-tensor/lean/OmegaPanel.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/OmegaPanel.lean`](../prime-spectrum-tensor/lean/OmegaPanel.lean) — 1 proof

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [21](../prime-spectrum-tensor/lean/OmegaPanel.lean#L21) | theorem | `omega_panel_enclosure` | $\forall\,a\,b\,lipx\,qmlo\,qmhi : \mathbb{R},\ \forall\,hab : a\le\ b,\ \forall\,hlip : \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \vert{}\mathrm{deriv}\ \mathrm{IntersectionForm.Omega}\ t\vert\le\ \mathrm{lipx},\ \forall\,hderiv : \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \mathrm{DifferentiableAt}\ \mathbb{R}\ \mathrm{IntersectionForm.Omega}\ t,\ \forall\,hm : \mathrm{qmlo}\le\ \mathrm{IntersectionForm.Omega}((a+b)/2),\ \forall\,hm_{2} : \mathrm{IntersectionForm.Omega}((a+b)/2)\le\ \mathrm{qmhi},\ \forall\ t\ \in\ \mathrm{Set.Icc}\ a\ b,\ \mathrm{qmlo}-\mathrm{lipx}\cdot(b-a)/2\le\ \mathrm{IntersectionForm.Omega}\ t\ \land\ \mathrm{IntersectionForm.Omega}\ t\le\ \mathrm{qmhi}+\mathrm{lipx}\cdot(b-a)/2$ |
