# `geometric-dynamical-phase-transitions/lean/Bridges.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/Bridges.lean`](../geometric-dynamical-phase-transitions/lean/Bridges.lean) — 14 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [22](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L22) | theorem | `lastChordAbs_pos` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,\sigma : \mathbb{R},\ 0<\mathrm{lastChordAbs}\ N\ \sigma$ |
| [31](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L31) | theorem | `lastChordAbs_mul_twin` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,\sigma : \mathbb{R},\ \mathrm{lastChordAbs}\ N\ \sigma\cdot\ \mathrm{lastChordAbs}\ N(1-\sigma)=((N:\mathbb{R})-1)^{2}/(4\cdot(N:\mathbb{R})^{2})$ |
| [49](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L49) | theorem | `lastChordAbs_twin_eq_iff` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,\sigma : \mathbb{R},\ \mathrm{lastChordAbs}\ N\ \sigma=\mathrm{lastChordAbs}\ N(1-\sigma)\leftrightarrow\ \sigma=1/2$ |
| [70](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L70) | theorem | `clock_zero_iff` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,s : \mathbb{C},\ (N:\mathbb{C})^{1-s}=1\leftrightarrow\ \exists\ n:\mathbb{Z},\ s=1-(n\cdot(2\cdot\ \mathrm{Real.pi}\cdot\ \mathrm{Complex}.I))/(\mathrm{Real.log}\ N:\mathbb{C})$ |
| [99](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L99) | theorem | `prefactor_lower_bound` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,\sigma\,t : \mathbb{R},\ (N:\mathbb{R})^{1-\sigma}-1\le\ \Vert(1:\mathbb{C})-(N:\mathbb{C})^{1-(\sigma+t\cdot\ \mathrm{Complex}.I)}\Vert$ |
| [122](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L122) | theorem | `local_diagonal_identity` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,hf : \mathrm{Continuous}\ f,\ \forall\,R : \mathbb{R},\ \int\ u\ \text{in}(-1)..1,(1-R\cdot\ f\ u)\cdot(-f\ u)=-(\int\ u\ \text{in}(-1)..1,\ f\ u)+R\cdot(\int\ u\ \text{in}(-1)..1,(f\ u)^{2})$ |
| [141](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L141) | theorem | `local_diagonal_normalized` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,hf : \mathrm{Continuous}\ f,\ \forall\,R : \mathbb{R},\ \forall\,hnormal : \int\ u\ \text{in}(-1)..1,\ f\ u=1,\ \int\ u\ \text{in}(-1)..1,(1-R\cdot\ f\ u)\cdot(-f\ u)=-1+R\cdot(\int\ u\ \text{in}(-1)..1,(f\ u)^{2})$ |
| [157](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L157) | theorem | `dhCoeff_odd` | $\forall\,r : \mathrm{Fin}\ 5,\ \mathrm{dhCoeff}(3-r)=-\mathrm{dhCoeff}\ r$ |
| [161](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L161) | theorem | `dhCoeff_mean_zero` | $:(\sum\ r:\mathrm{Fin}\ 5,\ \mathrm{dhCoeff}\ r)=0$ |
| [166](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L166) | theorem | `dhCoeff_five` | $:\mathrm{dhCoeff}\ 4=0$ |
| [174](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L174) | theorem | `lastChord_mul_twin_complex` | $\forall\,N : \mathbb{N},\ \forall\,hN : 1<N,\ \forall\,s : \mathbb{C},\ \mathrm{lastChord}\ N\ s\cdot\ \mathrm{lastChord}\ N(1-s)=((N:\mathbb{C})-1)^{2}/(4\cdot(N:\mathbb{C})^{2})$ |
| [198](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L198) | theorem | `dhXi_pos` | $:0<\mathrm{dhXi}$ |
| [211](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L211) | theorem | `dhXi_lt_one` | $:\mathrm{dhXi}<1$ |
| [226](../geometric-dynamical-phase-transitions/lean/Bridges.lean#L226) | theorem | `dhCoeff_two_abs_ne_one` | $:\vert{}\mathrm{dhCoeff}\ 1\vert\ne\ 1$ |
