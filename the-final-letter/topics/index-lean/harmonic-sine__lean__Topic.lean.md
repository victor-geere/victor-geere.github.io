# `harmonic-sine/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`harmonic-sine`](../harmonic-sine/README.md)

### [`harmonic-sine/lean/Topic.lean`](../harmonic-sine/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [44](../harmonic-sine/lean/Topic.lean#L44) | theorem | `eps_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{eps}\ n$ |
| [48](../harmonic-sine/lean/Topic.lean#L48) | theorem | `eps_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{eps}$ |
| [55](../harmonic-sine/lean/Topic.lean#L55) | theorem | `eps_tendsto_zero` | $:\mathrm{Tendsto}\ \mathrm{eps}\ \mathrm{atTop}(\mathcal{N}\ 0)$ |
| [62](../harmonic-sine/lean/Topic.lean#L62) | theorem | `scaled_eps` | $\forall\,n : \mathbb{N},\ ((n:\mathbb{R})+2)\cdot\ \mathrm{eps}\ n=\mathrm{Real.pi}$ |
| [70](../harmonic-sine/lean/Topic.lean#L70) | theorem | `rotate_unit` | $\forall\,p : \mathrm{Point},\ \forall\,h\,ch : \mathbb{R},\ \forall\,hp : p.\mathrm{1}^{2}+p.\mathrm{2}^{2}=1,\ \forall\,hh : h^{2}+\mathrm{ch}^{2}=1,\ (\mathrm{rotate}\ p\ h\ \mathrm{ch}).1^{2}+(\mathrm{rotate}\ p\ h\ \mathrm{ch}).2^{2}=1$ |
| [78](../harmonic-sine/lean/Topic.lean#L78) | theorem | `rotate_trig` | $\forall\,\theta\,\varepsilon : \mathbb{R},\ \mathrm{rotate}(\mathrm{Real.sin}\ \theta,\ \mathrm{Real.cos}\ \theta)(\mathrm{Real.sin}\ \varepsilon)(\mathrm{Real.cos}\ \varepsilon)=(\mathrm{Real.sin}(\theta+\varepsilon),\ \mathrm{Real.cos}(\theta+\varepsilon))$ |
| [88](../harmonic-sine/lean/Topic.lean#L88) | theorem | `residStep_bounds` | $\forall\,r : \mathbb{R},\ \forall\,n : \mathbb{N},\ \forall\,h_{0} : 0\le\ r,\ \forall\,hr : r\le\ \mathrm{eps}\ n,\ 0\le\ \mathrm{residStep}\ r\ n\ \land\ \mathrm{residStep}\ r\ n\le\ \mathrm{eps}\ n$ |
