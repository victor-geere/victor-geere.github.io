# `harmonic-sine-transform/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-sine-transform`](../harmonic-sine-transform/README.md)

### [`harmonic-sine-transform/lean/Topic.lean`](../harmonic-sine-transform/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [47](../harmonic-sine-transform/lean/Topic.lean#L47) | theorem | `alpha_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{alpha}\ n$ |
| [52](../harmonic-sine-transform/lean/Topic.lean#L52) | theorem | `alpha_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{alpha}$ |
| [61](../harmonic-sine-transform/lean/Topic.lean#L61) | theorem | `accum_le_self` | $\forall\,n : \mathbb{N},\ \forall\,\theta : \mathbb{R},\ \forall\,h\theta : 0\le\ \theta,\ \mathrm{accum}\ n\ \theta\le\ \theta$ |
| [72](../harmonic-sine-transform/lean/Topic.lean#L72) | theorem | `accum_eq_zero_of_lt` | $\forall\,n : \mathbb{N},\ \forall\,\theta : \mathbb{R},\ \forall\,h : \theta<\mathrm{alpha}\ n,\ \mathrm{accum}\ n\ \theta=0$ |
| [83](../harmonic-sine-transform/lean/Topic.lean#L83) | theorem | `threshold_isLeast` | $\forall\,n : \mathbb{N},\ \mathrm{IsLeast}\ \{\theta:\mathbb{R}\ \vert\ \mathrm{digit}\ n\ \theta=1\}(\mathrm{alpha}\ n)$ |
| [117](../harmonic-sine-transform/lean/Topic.lean#L117) | theorem | `haar_normSq` | $\forall\,a\,b\,L : \mathbb{R},\ \forall\,ha : 0<a,\ \forall\,hb : 0<b,\ \forall\,hL : L=a+b,\ a\cdot\ \mathrm{haarL}\ a\ b\ L^{2}+b\cdot\ \mathrm{haarR}\ a\ b\ L^{2}=1$ |
| [131](../harmonic-sine-transform/lean/Topic.lean#L131) | theorem | `haar_mean_zero` | $\forall\,a\,b\,L : \mathbb{R},\ \forall\,ha : 0<a,\ \forall\,hb : 0<b,\ \forall\,hL : L=a+b,\ \mathrm{haarL}\ a\ b\ L\cdot\ a-\mathrm{haarR}\ a\ b\ L\cdot\ b=0$ |
