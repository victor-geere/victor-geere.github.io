# `riemann-helix/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`riemann-helix`](../riemann-helix/README.md)

### [`riemann-helix/lean/Topic.lean`](../riemann-helix/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../riemann-helix/lean/Topic.lean#L44) | theorem | `helix_on_cylinder` | $\forall\,R\,c\,t : \mathbb{R},\ (\mathrm{helix}\ R\ c\ t).1^{2}+(\mathrm{helix}\ R\ c\ t).2.1^{2}=R^{2}$ |
| [50](../riemann-helix/lean/Topic.lean#L50) | theorem | `torsion_pos` | $\forall\,R\,c : \mathbb{R},\ \forall\,hR : 0<R,\ \forall\,hc : 0<c,\ 0<\mathrm{torsion}\ R\ c$ |
| [56](../riemann-helix/lean/Topic.lean#L56) | theorem | `torsion_strictAnti_radius` | $\forall\,R_{1}\,R_{2}\,c : \mathbb{R},\ \forall\,hR_{1} : 0<R_{1},\ \forall\,h_{12} : R_{1}<R_{2},\ \forall\,hc : 0<c,\ \mathrm{torsion}\ R_{2}\ c<\mathrm{torsion}\ R_{1}\ c$ |
| [69](../riemann-helix/lean/Topic.lean#L69) | theorem | `torsion_scale` | $\forall\,R\,c\,lam : \mathbb{R},\ \forall\,hR : 0<R,\ \forall\,hc : 0<c,\ \forall\,hlam : 0<\mathrm{lam},\ \mathrm{torsion}(\mathrm{lam}\cdot\ R)(\mathrm{lam}\cdot\ c)=\mathrm{torsion}\ R\ c/\mathrm{lam}$ |
| [79](../riemann-helix/lean/Topic.lean#L79) | theorem | `torsion_not_scale_invariant` | $\forall\,R\,c\,lam : \mathbb{R},\ \forall\,hR : 0<R,\ \forall\,hc : 0<c,\ \forall\,hlam : 0<\mathrm{lam},\ \forall\,hlam_{1} : \mathrm{lam}\ne\ 1,\ \mathrm{torsion}(\mathrm{lam}\cdot\ R)(\mathrm{lam}\cdot\ c)\ne\ \mathrm{torsion}\ R\ c$ |
| [103](../riemann-helix/lean/Topic.lean#L103) | theorem | `torsion_half_ne_unit` | $:\mathrm{torsion}(1/2)\ 1\ne\ \mathrm{torsion}\ 1\ 1$ |
| [115](../riemann-helix/lean/Topic.lean#L115) | theorem | `curvature_torsion_inversion` | $\forall\,R\,c : \mathbb{R},\ \forall\,h : R^{2}+c^{2}\ne\ 0,\ \mathrm{curvature}\ R\ c^{2}+\mathrm{torsion}\ R\ c^{2}=1/(R^{2}+c^{2})\ \land\ \mathrm{curvature}\ R\ c/(\mathrm{curvature}\ R\ c^{2}+\mathrm{torsion}\ R\ c^{2})=R\ \land\ \mathrm{torsion}\ R\ c/(\mathrm{curvature}\ R\ c^{2}+\mathrm{torsion}\ R\ c^{2})=c$ |
