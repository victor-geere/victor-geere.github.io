# `qefe/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`qefe`](../qefe/README.md)

### [`qefe/lean/Topic.lean`](../qefe/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [34](../qefe/lean/Topic.lean#L34) | theorem | `egyptianDenom_pos` | $\forall\,D_{2}\,d_{2} : \mathbb{R},\ \forall\,hD : 0<\mathrm{D2},\ \forall\,hd : 0<\mathrm{d2},\ 0<\mathrm{egyptianDenom}\ \mathrm{D2}\ \mathrm{d2}$ |
| [41](../qefe/lean/Topic.lean#L41) | theorem | `inv_egyptianDenom` | $\forall\,D_{2}\,d_{2} : \mathbb{R},\ \forall\,hD : \mathrm{D2}\ne\ 0,\ \forall\,hd : \mathrm{d2}\ne\ 0,\ (\mathrm{egyptianDenom}\ \mathrm{D2}\ \mathrm{d2})^{-1}=\mathrm{d2}/\mathrm{D2}$ |
| [47](../qefe/lean/Topic.lean#L47) | theorem | `egyptianUnit_pos` | $\forall\,D_{2} : \mathbb{R},\ \forall\,hD : 1<\mathrm{D2},\ 0<\mathrm{egyptianUnit}\ \mathrm{D2}$ |
| [54](../qefe/lean/Topic.lean#L54) | theorem | `egyptian_total` | $\forall\,n : \mathbb{N},\ \forall\,d_{2} : \mathrm{Fin}(n+1)\to\ \mathbb{R},\ \forall\,D_{2} : \mathbb{R},\ \forall\,hD : \mathrm{D2}=\sum\ i,\ \mathrm{d2}\ i,\ \forall\,hd : \forall\ i,\ \mathrm{d2}\ i\ne\ 0,\ \forall\,hD_{0} : \mathrm{D2}\ne\ 0,\ \sum\ i,(\mathrm{egyptianDenom}\ \mathrm{D2}(\mathrm{d2}\ i))^{-1}=1$ |
| [67](../qefe/lean/Topic.lean#L67) | theorem | `egyptian_fraction_identity` | $\forall\,n : \mathbb{N},\ \forall\,d_{2} : \mathrm{Fin}(n+1)\to\ \mathbb{R},\ \forall\,D_{2} : \mathbb{R},\ \forall\,hD : \mathrm{D2}=\sum\ i,\ \mathrm{d2}\ i,\ \forall\,h_{0} : \mathrm{d2}\ 0=1,\ \forall\,hd : \forall\ i,\ \mathrm{d2}\ i\ne\ 0,\ \forall\,hD_{0} : \mathrm{D2}\ne\ 0,\ \sum\ i\ \in\ \mathrm{Finset.univ.erase}\ 0,(\mathrm{egyptianDenom}\ \mathrm{D2}(\mathrm{d2}\ i))^{-1}=1-1/\mathrm{D2}$ |
| [87](../qefe/lean/Topic.lean#L87) | theorem | `gammaRatio_center` | $\forall\,a : \mathbb{R},\ \forall\,ha : 0\le\ a,\ \mathrm{gammaRatio}\ a(1/2)=1$ |
| [101](../qefe/lean/Topic.lean#L101) | theorem | `qefePrefactor_center` | $\forall\,D_{2}\,a : \mathbb{R},\ \forall\,\_hD : 0<\mathrm{D2},\ \forall\,ha : 0\le\ a,\ \mathrm{qefePrefactor}\ \mathrm{D2}\ a(1/2)=1$ |
