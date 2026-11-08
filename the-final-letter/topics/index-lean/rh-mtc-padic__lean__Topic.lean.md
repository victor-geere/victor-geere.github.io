# `rh-mtc-padic/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`rh-mtc-padic`](../rh-mtc-padic/README.md)

### [`rh-mtc-padic/lean/Topic.lean`](../rh-mtc-padic/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [36](../rh-mtc-padic/lean/Topic.lean#L36) | theorem | `rtWeight_pos` | $\forall\,p : \mathbb{N},\ \forall\,hp : 0<p,\ \forall\,n : \mathbb{N},\ 0<\mathrm{rtWeight}\ p\ n$ |
| [41](../rh-mtc-padic/lean/Topic.lean#L41) | theorem | `rtWeight_mul` | $\forall\,p : \mathbb{N},\ \forall\,n\,m : \mathbb{N},\ \mathrm{rtWeight}\ p(n+m)=\mathrm{rtWeight}\ p\ n\cdot\ \mathrm{rtWeight}\ p\ m$ |
| [48](../rh-mtc-padic/lean/Topic.lean#L48) | theorem | `rtWeight_strictAnti` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ \mathrm{StrictAnti}(\mathrm{rtWeight}\ p)$ |
| [56](../rh-mtc-padic/lean/Topic.lean#L56) | theorem | `rtWeight_le_one` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1\le\ p,\ \forall\,n : \mathbb{N},\ \mathrm{rtWeight}\ p\ n\le\ 1$ |
| [63](../rh-mtc-padic/lean/Topic.lean#L63) | theorem | `partial_sum_bookkeeping` | $\forall\,p : \mathbb{N},\ \forall\,N : \mathbb{N},\ (1-\mathrm{rtWeight}\ p\ 1)\cdot((\mathrm{Finset.range}\ N).\mathrm{sum}(\lambda\ k\Rightarrow\ \mathrm{rtWeight}\ p\ k))=1-\mathrm{rtWeight}\ p\ N$ |
| [77](../rh-mtc-padic/lean/Topic.lean#L77) | theorem | `hasSum_rtWeight` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ \mathrm{HasSum}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{rtWeight}\ p\ n)((p:\mathbb{R})/((p:\mathbb{R})-1))$ |
| [97](../rh-mtc-padic/lean/Topic.lean#L97) | theorem | `rtWeight_tendsto_zero` | $\forall\,p : \mathbb{N},\ \forall\,hp : 1<p,\ \mathrm{Tendsto}(\lambda\ n:\mathbb{N}\Rightarrow\ \mathrm{rtWeight}\ p\ n)\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
