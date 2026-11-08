# `geometric-dynamical-phase-transitions/lean/LastChord.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/LastChord.lean`](../geometric-dynamical-phase-transitions/lean/LastChord.lean) — 6 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [23](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L23) | theorem | `lastChordAbs_eq_half_mul` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \forall\,\sigma : \mathbb{R},\ \mathrm{lastChordAbs}\ N\ \sigma=(1/2:\mathbb{R})\cdot(1-1/(N:\mathbb{R}))\cdot(N:\mathbb{R})^{1-2\cdot\ \sigma}$ |
| [32](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L32) | theorem | `lastChordAbs_half_tendsto` | $:\mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N(1/2))\ \mathrm{atTop}(\mathcal{N}(1/2))$ |
| [50](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L50) | theorem | `lastChordAbs_tendsto_zero_of_half_lt` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : 1/2<\sigma,\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N\ \sigma)\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [92](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L92) | theorem | `lastChordAbs_tendsto_atTop_of_lt_half` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : \sigma<1/2,\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N\ \sigma)\ \mathrm{atTop}\ \mathrm{atTop}$ |
| [119](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L119) | theorem | `lastChordAbs_dichotomy` | $\forall\,\sigma : \mathbb{R},\ \forall\,h\sigma : \sigma\ne\ 1/2,\ (\sigma<1/2\ \land\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N\ \sigma)\ \mathrm{atTop}\ \mathrm{atTop}\ \land\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N(1-\sigma))\ \mathrm{atTop}(\mathcal{N}\ 0))\ \lor(1/2<\sigma\ \land\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N\ \sigma)\ \mathrm{atTop}(\mathcal{N}\ 0)\ \land\ \mathrm{Tendsto}(\lambda\ N:\mathbb{N}\Rightarrow\ \mathrm{lastChordAbs}\ N(1-\sigma))\ \mathrm{atTop}\ \mathrm{atTop})$ |
| [140](../geometric-dynamical-phase-transitions/lean/LastChord.lean#L140) | theorem | `lastChordAbs_ratio` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \forall\,\sigma : \mathbb{R},\ \mathrm{lastChordAbs}\ N\ \sigma/(N:\mathbb{R})^{1-2\cdot\ \sigma}=1/2-1/(2\cdot(N:\mathbb{R}))$ |
