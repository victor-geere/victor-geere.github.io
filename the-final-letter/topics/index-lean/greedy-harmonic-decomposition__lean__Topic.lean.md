# `greedy-harmonic-decomposition/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`greedy-harmonic-decomposition`](../greedy-harmonic-decomposition/README.md)

### [`greedy-harmonic-decomposition/lean/Topic.lean`](../greedy-harmonic-decomposition/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [26](../greedy-harmonic-decomposition/lean/Topic.lean#L26) | theorem | `alpha_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{alpha}\ n$ |
| [30](../greedy-harmonic-decomposition/lean/Topic.lean#L30) | theorem | `alpha_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{alpha}$ |
| [37](../greedy-harmonic-decomposition/lean/Topic.lean#L37) | theorem | `alpha_tendsto_zero` | $:\mathrm{Tendsto}\ \mathrm{alpha}\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [44](../greedy-harmonic-decomposition/lean/Topic.lean#L44) | theorem | `scaled_alpha` | $\forall\,n : \mathbb{N},\ ((n:\mathbb{R})+2)\cdot\ \mathrm{alpha}\ n=\mathrm{Real.pi}$ |
| [49](../greedy-harmonic-decomposition/lean/Topic.lean#L49) | theorem | `Kdiag_pos` | $\forall\,t : \mathbb{R},\ \forall\,h_{0} : 0<t,\ \forall\,h\pi : t<\mathrm{Real.pi},\ 0<\mathrm{Kdiag}\ t$ |
| [58](../greedy-harmonic-decomposition/lean/Topic.lean#L58) | theorem | `Kdiag_symm` | $\forall\,t : \mathbb{R},\ \mathrm{Kdiag}\ t=\mathrm{Kdiag}(\mathrm{Real.pi}-t)$ |
| [62](../greedy-harmonic-decomposition/lean/Topic.lean#L62) | theorem | `Kdiag_half` | $:\mathrm{Kdiag}(\mathrm{Real.pi}/2)=\mathrm{Real.pi}/12$ |
