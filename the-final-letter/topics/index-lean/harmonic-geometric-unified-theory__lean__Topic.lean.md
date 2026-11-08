# `harmonic-geometric-unified-theory/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-geometric-unified-theory`](../harmonic-geometric-unified-theory/README.md)

### [`harmonic-geometric-unified-theory/lean/Topic.lean`](../harmonic-geometric-unified-theory/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [41](../harmonic-geometric-unified-theory/lean/Topic.lean#L41) | theorem | `egyptWeight_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{egyptWeight}\ n$ |
| [46](../harmonic-geometric-unified-theory/lean/Topic.lean#L46) | theorem | `egyptWeight_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{egyptWeight}$ |
| [55](../harmonic-geometric-unified-theory/lean/Topic.lean#L55) | theorem | `egyptWeight_tendsto_zero` | $:\mathrm{Tendsto}\ \mathrm{egyptWeight}\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [66](../harmonic-geometric-unified-theory/lean/Topic.lean#L66) | theorem | `harmonicAngle_scaled` | $\forall\,n : \mathbb{N},\ ((n:\mathbb{R})+2)\cdot\ \mathrm{harmonicAngle}\ n=\mathrm{Real.pi}$ |
| [73](../harmonic-geometric-unified-theory/lean/Topic.lean#L73) | theorem | `harmonicSum_succ` | $\forall\,N : \mathbb{N},\ \mathrm{harmonicSum}(N+1)=\mathrm{harmonicSum}\ N+\mathrm{egyptWeight}\ N$ |
| [79](../harmonic-geometric-unified-theory/lean/Topic.lean#L79) | theorem | `harmonicSum_mono` | $:\mathrm{Monotone}\ \mathrm{harmonicSum}$ |
| [88](../harmonic-geometric-unified-theory/lean/Topic.lean#L88) | theorem | `harmonicSum_four` | $:\mathrm{harmonicSum}\ 4=25/12$ |
