# `transfer-operator-proof/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`transfer-operator-proof`](../transfer-operator-proof/README.md)

### [`transfer-operator-proof/lean/Topic.lean`](../transfer-operator-proof/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [52](../transfer-operator-proof/lean/Topic.lean#L52) | theorem | `primeWeight_pos` | $\forall\,p : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,s : \mathbb{R},\ 0<\mathrm{primeWeight}\ p\ s$ |
| [59](../transfer-operator-proof/lean/Topic.lean#L59) | theorem | `primeWeight_lt_one` | $\forall\,p : \mathbb{N},\ \forall\,hp : 2\le\ p,\ \forall\,s : \mathbb{R},\ \forall\,hs : 0<s,\ \mathrm{primeWeight}\ p\ s<1$ |
| [67](../transfer-operator-proof/lean/Topic.lean#L67) | theorem | `fredholmDet_pos` | $\forall\,n : \mathbb{N},\ \forall\,eigenvalues : \mathrm{Fin}\ n\to\ \mathbb{R},\ \forall\,h : \forall\ i,\ \mathrm{eigenvalues}\ i<1,\ 0<\mathrm{fredholmDet}\ \mathrm{eigenvalues}$ |
| [75](../transfer-operator-proof/lean/Topic.lean#L75) | theorem | `fredholmDet_eq_zero_iff` | $\forall\,n : \mathbb{N},\ \forall\,eigenvalues : \mathrm{Fin}\ n\to\ \mathbb{R},\ \mathrm{fredholmDet}\ \mathrm{eigenvalues}=0\leftrightarrow\ \exists\ i,\ \mathrm{eigenvalues}\ i=1$ |
| [86](../transfer-operator-proof/lean/Topic.lean#L86) | theorem | `diagForm_symm` | $\forall\,n : \mathbb{N},\ \forall\,w\,x\,y : \mathrm{Fin}\ n\to\ \mathbb{R},\ \mathrm{diagForm}\ w\ x\ y=\mathrm{diagForm}\ w\ y\ x$ |
| [92](../transfer-operator-proof/lean/Topic.lean#L92) | theorem | `diagEnergy_nonneg` | $\forall\,n : \mathbb{N},\ \forall\,w\,x : \mathrm{Fin}\ n\to\ \mathbb{R},\ \forall\,h : \forall\ i,\ 0\le\ w\ i,\ 0\le\ \mathrm{diagEnergy}\ w\ x$ |
| [100](../transfer-operator-proof/lean/Topic.lean#L100) | theorem | `kreinForm_negative_direction` | $\forall\,n : \mathbb{N},\ \forall\,sign : \mathrm{Fin}\ n\to\ \mathbb{R},\ \forall\,j : \mathrm{Fin}\ n,\ \forall\,h : \mathrm{sign}\ j<0,\ \mathrm{kreinForm}\ \mathrm{sign}(\mathrm{Pi.single}\ j\ 1)(\mathrm{Pi.single}\ j\ 1)<0$ |
