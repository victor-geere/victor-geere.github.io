# `adelic-transfer-operator/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`adelic-transfer-operator`](../adelic-transfer-operator/README.md)

### [`adelic-transfer-operator/lean/Topic.lean`](../adelic-transfer-operator/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [54](../adelic-transfer-operator/lean/Topic.lean#L54) | theorem | `qdim_one` | $\forall\,p : \mathbb{N},\ \forall\,h : \mathrm{Real.sin}(\mathrm{Real.pi}/p)\ne\ 0,\ \mathrm{qdim}\ p\ 1=1$ |
| [62](../adelic-transfer-operator/lean/Topic.lean#L62) | theorem | `qdim_pos` | $\forall\,p\,a : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,ha_{0} : 0<a,\ \forall\,hap : a<p,\ 0<\mathrm{qdim}\ p\ a$ |
| [82](../adelic-transfer-operator/lean/Topic.lean#L82) | theorem | `sEntry_symm` | $\forall\,p\,a\,b : \mathbb{N},\ \mathrm{sEntry}\ p\ a\ b=\mathrm{sEntry}\ p\ b\ a$ |
| [90](../adelic-transfer-operator/lean/Topic.lean#L90) | theorem | `sEntry_one_eq_mul_qdim` | $\forall\,p\,b : \mathbb{N},\ \forall\,h : \mathrm{Real.sin}(\mathrm{Real.pi}/p)\ne\ 0,\ \mathrm{sEntry}\ p\ 1\ b=\mathrm{sEntry}\ p\ 1\ 1\cdot\ \mathrm{qdim}\ p\ b$ |
| [98](../adelic-transfer-operator/lean/Topic.lean#L98) | theorem | `rtWeight_geom` | $\forall\,p\,N : \mathbb{N},\ \forall\,hp : p\ne\ 1,\ (\sum\ k\ \in\ \mathrm{Finset.range}\ N,\ \mathrm{rtWeight}\ p\ k)=(\mathrm{rtWeight}\ p\ N-1)/(\mathrm{rtWeight}\ p\ 1-1)$ |
| [113](../adelic-transfer-operator/lean/Topic.lean#L113) | theorem | `localDet_gt_one` | $\forall\,x : \mathbb{R},\ \forall\,h_{0} : 0<x,\ \forall\,h_{1} : x<1,\ 1<\mathrm{localDet}\ x$ |
| [122](../adelic-transfer-operator/lean/Topic.lean#L122) | theorem | `localDet_eq_tsum` | $\forall\,x : \mathbb{R},\ \forall\,h : \Vert{}x\Vert<1,\ \mathrm{localDet}\ x=\sum'\ n:\mathbb{N},\ x^{n}$ |
