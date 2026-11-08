# `hst-programme/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`hst-programme`](../hst-programme/README.md)

### [`hst-programme/lean/Topic.lean`](../hst-programme/lean/Topic.lean) — 8 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../hst-programme/lean/Topic.lean#L42) | theorem | `d_pos` | $\forall\,n : \mathbb{N},\ 0<d\ n$ |
| [47](../hst-programme/lean/Topic.lean#L47) | theorem | `d_strictAnti` | $:\mathrm{StrictAnti}\ d$ |
| [55](../hst-programme/lean/Topic.lean#L55) | theorem | `rem_succ` | $\forall\,x : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{rem}\ x(n+1)=\mathrm{rem}\ x\ n-(\mathrm{digit}\ x\ n:\mathbb{R})\cdot\ d\ n$ |
| [62](../hst-programme/lean/Topic.lean#L62) | theorem | `rem_nonneg` | $\forall\,x : \mathbb{R},\ \forall\,hx : 0\le\ x,\ \forall\,n : \mathbb{N},\ 0\le\ \mathrm{rem}\ x\ n$ |
| [76](../hst-programme/lean/Topic.lean#L76) | theorem | `rem_lt` | $\forall\,x : \mathbb{R},\ \forall\,hx : x<1,\ \forall\,n : \mathbb{N},\ \mathrm{rem}\ x\ n<1/((n:\mathbb{R})+1)$ |
| [102](../hst-programme/lean/Topic.lean#L102) | theorem | `rem_add_sum` | $\forall\,x : \mathbb{R},\ \forall\,n : \mathbb{N},\ \mathrm{rem}\ x\ n+(\mathrm{Finset.range}\ n).\mathrm{sum}(\lambda\ k\Rightarrow(\mathrm{digit}\ x\ k:\mathbb{R})\cdot\ d\ k)=x$ |
| [112](../hst-programme/lean/Topic.lean#L112) | theorem | `rem_tendsto_zero` | $\forall\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \forall\,hx_{1} : x<1,\ \mathrm{Tendsto}(\lambda\ n\Rightarrow\ \mathrm{rem}\ x\ n)\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [122](../hst-programme/lean/Topic.lean#L122) | theorem | `sum_tendsto` | $\forall\,x : \mathbb{R},\ \forall\,hx_{0} : 0\le\ x,\ \forall\,hx_{1} : x<1,\ \mathrm{Tendsto}(\lambda\ n\Rightarrow(\mathrm{Finset.range}\ n).\mathrm{sum}(\lambda\ k\Rightarrow(\mathrm{digit}\ x\ k:\mathbb{R})\cdot\ d\ k))\ \mathrm{atTop}(\mathcal{N}\ x)$ |
