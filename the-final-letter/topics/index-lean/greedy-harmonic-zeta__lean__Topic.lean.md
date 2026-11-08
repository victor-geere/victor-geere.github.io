# `greedy-harmonic-zeta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`greedy-harmonic-zeta`](../greedy-harmonic-zeta/README.md)

### [`greedy-harmonic-zeta/lean/Topic.lean`](../greedy-harmonic-zeta/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [42](../greedy-harmonic-zeta/lean/Topic.lean#L42) | theorem | `term_pos` | $\forall\,\sigma : \mathbb{R},\ \forall\,n : \mathbb{N},\ 0<\mathrm{term}\ \sigma\ n$ |
| [47](../greedy-harmonic-zeta/lean/Topic.lean#L47) | theorem | `term_strictAnti` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : 0<\sigma,\ \mathrm{StrictAnti}(\mathrm{term}\ \sigma)$ |
| [57](../greedy-harmonic-zeta/lean/Topic.lean#L57) | theorem | `eta_zeta_even` | $\forall\,\sigma : \mathbb{R},\ \forall\,m : \mathbb{N},\ \mathrm{etaPartial}\ \sigma(2\cdot\ m)=\mathrm{zetaPartial}\ \sigma(2\cdot\ m)-2\cdot(2:\mathbb{R})^{-\sigma}\cdot\ \mathrm{zetaPartial}\ \sigma\ m$ |
| [93](../greedy-harmonic-zeta/lean/Topic.lean#L93) | theorem | `eta_zero_even` | $\forall\,m : \mathbb{N},\ \mathrm{etaPartial}\ 0(2\cdot\ m)=0$ |
| [104](../greedy-harmonic-zeta/lean/Topic.lean#L104) | theorem | `eta_zero_odd` | $\forall\,m : \mathbb{N},\ \mathrm{etaPartial}\ 0(2\cdot\ m+1)=1$ |
| [116](../greedy-harmonic-zeta/lean/Topic.lean#L116) | theorem | `normSq_add_corr` | $\forall\,S\,w : \mathbb{C},\ \mathrm{Complex.normSq}(S+w)=\mathrm{Complex.normSq}\ S+\mathrm{Complex.normSq}\ w+2\cdot\ \mathrm{corr}\ S\ w$ |
| [125](../greedy-harmonic-zeta/lean/Topic.lean#L125) | theorem | `greedy_closer` | $\forall\,S\,w : \mathbb{C},\ \forall\,h : \mathrm{corr}\ S\ w\le\ 0,\ \mathrm{Complex.normSq}(S+w)\le\ \mathrm{Complex.normSq}(S-w)$ |
