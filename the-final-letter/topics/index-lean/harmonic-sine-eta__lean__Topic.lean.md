# `harmonic-sine-eta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-sine-eta`](../harmonic-sine-eta/README.md)

### [`harmonic-sine-eta/lean/Topic.lean`](../harmonic-sine-eta/lean/Topic.lean) — 9 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [56](../harmonic-sine-eta/lean/Topic.lean#L56) | theorem | `weight_pos` | $\forall\,\alpha : \mathbb{R},\ \forall\,\_h\alpha : 0<\alpha,\ \forall\,n : \mathbb{N},\ 0<\mathrm{weight}\ \alpha\ n$ |
| [61](../harmonic-sine-eta/lean/Topic.lean#L61) | theorem | `weight_lt_succ` | $\forall\,\alpha : \mathbb{R},\ \forall\,h\alpha : 0<\alpha,\ \forall\,n : \mathbb{N},\ \mathrm{weight}\ \alpha(n+1)<\mathrm{weight}\ \alpha\ n$ |
| [82](../harmonic-sine-eta/lean/Topic.lean#L82) | theorem | `sign_period_two` | $\forall\,n : \mathbb{N},\ (-1:\mathbb{R})^{n+2}=(-1:\mathbb{R})^{n}$ |
| [86](../harmonic-sine-eta/lean/Topic.lean#L86) | theorem | `sum_range_pair` | $\forall\,f : \mathbb{N}\to\ \mathbb{R},\ \forall\,N : \mathbb{N},\ (\mathrm{range}(2\cdot\ N)).\mathrm{sum}\ f=(\mathrm{range}\ N).\mathrm{sum}(\lambda\ k\Rightarrow\ f(2\cdot\ k)+f(2\cdot\ k+1))$ |
| [99](../harmonic-sine-eta/lean/Topic.lean#L99) | theorem | `sum_range_odd_weight` | $\forall\,\alpha : \mathbb{R},\ \forall\,N : \mathbb{N},\ (\mathrm{range}\ N).\mathrm{sum}(\lambda\ k\Rightarrow\ \mathrm{weight}\ \alpha(2\cdot\ k+1))=2^{-\alpha}\cdot(\mathrm{range}\ N).\mathrm{sum}(\lambda\ k\Rightarrow\ \mathrm{weight}\ \alpha\ k)$ |
| [113](../harmonic-sine-eta/lean/Topic.lean#L113) | theorem | `etaPartial_two_mul` | $\forall\,\alpha : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{etaPartial}\ \alpha(2\cdot\ N)=(\mathrm{range}\ N).\mathrm{sum}(\lambda\ k\Rightarrow\ \mathrm{weight}\ \alpha(2\cdot\ k)-\mathrm{weight}\ \alpha(2\cdot\ k+1))$ |
| [132](../harmonic-sine-eta/lean/Topic.lean#L132) | theorem | `etaPartial_even_factor` | $\forall\,\alpha : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{etaPartial}\ \alpha(2\cdot\ N)=(\mathrm{range}(2\cdot\ N)).\mathrm{sum}(\lambda\ n\Rightarrow\ \mathrm{weight}\ \alpha\ n)-2^{1-\alpha}\cdot(\mathrm{range}\ N).\mathrm{sum}(\lambda\ n\Rightarrow\ \mathrm{weight}\ \alpha\ n)$ |
| [145](../harmonic-sine-eta/lean/Topic.lean#L145) | theorem | `etaPartial_even_pos` | $\forall\,\alpha : \mathbb{R},\ \forall\,h\alpha : 0<\alpha,\ \forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ 0<\mathrm{etaPartial}\ \alpha(2\cdot\ N)$ |
| [155](../harmonic-sine-eta/lean/Topic.lean#L155) | theorem | `cos_sin_at_zero` | $\forall\,\alpha : \mathbb{R},\ \forall\,N : \mathbb{N},\ \mathrm{cosPartial}\ \alpha\ 0\ N=\mathrm{etaPartial}\ \alpha\ N\ \land\ \mathrm{sinPartial}\ \alpha\ 0\ N=0$ |
