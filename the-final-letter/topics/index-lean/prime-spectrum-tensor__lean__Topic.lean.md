# `prime-spectrum-tensor/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/Topic.lean`](../prime-spectrum-tensor/lean/Topic.lean) — 13 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [64](../prime-spectrum-tensor/lean/Topic.lean#L64) | theorem | `primeWeight_nonneg` | $\forall\,n : \mathbb{N},\ 0\le\ \mathrm{primeWeight}\ n$ |
| [69](../prime-spectrum-tensor/lean/Topic.lean#L69) | theorem | `primeCurrent_nonneg` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,hf : \forall\ x,\ 0\le\ f\ x,\ \forall\,N : \mathbb{N},\ 0\le\ \mathrm{primeCurrent}\ f\ N$ |
| [77](../prime-spectrum-tensor/lean/Topic.lean#L77) | theorem | `jacobiTerm_pos` | $\forall\,n : \mathbb{N},\ \forall\,hn : 1\le\ n,\ \forall\,u : \mathbb{R},\ \forall\,hu : 0\le\ u,\ 0<\mathrm{jacobiTerm}\ n\ u$ |
| [111](../prime-spectrum-tensor/lean/Topic.lean#L111) | theorem | `atom_neg` | $\forall\,w\,\gamma\,x : \mathbb{R},\ \mathrm{atom}\ w\ \gamma(-x)=\mathrm{starRingEnd}\ \mathbb{C}(\mathrm{atom}\ w\ \gamma\ x)$ |
| [127](../prime-spectrum-tensor/lean/Topic.lean#L127) | theorem | `atomForm_eq` | $\forall\,M : \mathbb{N},\ \forall\,w\,\gamma : \mathbb{R},\ \forall\,a : \mathrm{Fin}\ M\to\ \mathbb{C},\ \forall\,u : \mathrm{Fin}\ M\to\ \mathbb{R},\ (\sum\ j,\ \sum\ l,\ a\ j\cdot\ \mathrm{starRingEnd}\ \mathbb{C}(a\ l)\cdot\ \mathrm{atom}\ w\ \gamma(u\ j-u\ l))=(w:\mathbb{C})\cdot(\mathrm{modeSum}\ a\ \gamma\ u\cdot\ \mathrm{starRingEnd}\ \mathbb{C}(\mathrm{modeSum}\ a\ \gamma\ u))$ |
| [162](../prime-spectrum-tensor/lean/Topic.lean#L162) | theorem | `gramForm_eq` | $\forall\,N\,M : \mathbb{N},\ \forall\,w\,\gamma : \mathrm{Fin}\ N\to\ \mathbb{R},\ \forall\,a : \mathrm{Fin}\ M\to\ \mathbb{C},\ \forall\,u : \mathrm{Fin}\ M\to\ \mathbb{R},\ \mathrm{gramForm}\ w\ \gamma\ a\ u=\sum\ k,(w\ k:\mathbb{C})\cdot(\mathrm{modeSum}\ a(\gamma\ k)\ u\cdot\ \mathrm{starRingEnd}\ \mathbb{C}(\mathrm{modeSum}\ a(\gamma\ k)\ u))$ |
| [178](../prime-spectrum-tensor/lean/Topic.lean#L178) | theorem | `gramForm_re_nonneg` | $\forall\,N\,M : \mathbb{N},\ \forall\,w\,\gamma : \mathrm{Fin}\ N\to\ \mathbb{R},\ \forall\,a : \mathrm{Fin}\ M\to\ \mathbb{C},\ \forall\,u : \mathrm{Fin}\ M\to\ \mathbb{R},\ \forall\,hw : \forall\ k,\ 0\le\ w\ k,\ 0\le(\mathrm{gramForm}\ w\ \gamma\ a\ u).\mathrm{re}$ |
| [216](../prime-spectrum-tensor/lean/Topic.lean#L216) | theorem | `G3_eq` | $:\mathrm{G3}=\mathrm{L3}^{H}\cdot\ \mathrm{L3}$ |
| [223](../prime-spectrum-tensor/lean/Topic.lean#L223) | theorem | `G3_posSemidef` | $:\mathrm{G3.PosSemidef}$ |
| [235](../prime-spectrum-tensor/lean/Topic.lean#L235) | theorem | `GDH_not_posSemidef` | $:\neg\ \mathrm{GDH.PosSemidef}$ |
| [242](../prime-spectrum-tensor/lean/Topic.lean#L242) | theorem | `posSemidef_of_cholesky` | $\forall\,n : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ n],\ \forall\,[\mathrm{DecidableEq}\ n],\ \forall\,L : \mathrm{Matrix}\ n\ n\ \mathbb{Q},\ (L^{H}\cdot\ L).\mathrm{PosSemidef}$ |
| [248](../prime-spectrum-tensor/lean/Topic.lean#L248) | theorem | `not_posSemidef_of_neg` | $\forall\,n : \mathrm{Type}\cdot,\ \forall\,[\mathrm{Fintype}\ n],\ \forall\,[\mathrm{DecidableEq}\ n],\ \forall\,M : \mathrm{Matrix}\ n\ n\ \mathbb{Q},\ \forall\,v : n\to\ \mathbb{Q},\ \forall\,h : \mathrm{star}\ v\cdot{}_{v}(M\cdot{}_{v}\ v)<0,\ \neg\ M.\mathrm{PosSemidef}$ |
| [272](../prime-spectrum-tensor/lean/Topic.lean#L272) | theorem | `L4Shadow_posSemidef` | $:(\mathrm{L4Shadow}^{H}\cdot\ \mathrm{L4Shadow}).\mathrm{PosSemidef}$ |
