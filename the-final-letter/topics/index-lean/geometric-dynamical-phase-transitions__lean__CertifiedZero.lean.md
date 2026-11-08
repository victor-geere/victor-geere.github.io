# `geometric-dynamical-phase-transitions/lean/CertifiedZero.lean`

[Back to the split index](index.md) · Topic: [`geometric-dynamical-phase-transitions`](../geometric-dynamical-phase-transitions/README.md)

### [`geometric-dynamical-phase-transitions/lean/CertifiedZero.lean`](../geometric-dynamical-phase-transitions/lean/CertifiedZero.lean) — 4 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [24](../geometric-dynamical-phase-transitions/lean/CertifiedZero.lean#L24) | theorem | `exists_unique_root_of_sign_change` | $\forall\,f : \mathbb{R}\to\ \mathbb{R},\ \forall\,a\,b : \mathbb{R},\ \forall\,hab : a<b,\ \forall\,hf : \mathrm{ContinuousOn}\ f(\mathrm{Icc}\ a\ b),\ \forall\,hf' : \forall\ x\ \in\ \mathrm{Ioo}\ a\ b,\ 0<\mathrm{deriv}\ f\ x,\ \forall\,ha : f\ a<0,\ \forall\,hb : 0<f\ b,\ \exists\ x,\ x\ \in\ \mathrm{Ioo}\ a\ b\ \land\ f\ x=0\ \land\ 0<\mathrm{deriv}\ f\ x\ \land\ \forall\ y,\ y\ \in\ \mathrm{Ioo}\ a\ b\to\ f\ y=0\to\ y=x$ |
| [55](../geometric-dynamical-phase-transitions/lean/CertifiedZero.lean#L55) | theorem | `turing_reduction` | $\forall\,\alpha : \mathrm{Type}\cdot,\ \forall\,[\mathrm{DecidableEq}\ \alpha],\ \forall\,zeros\,certified : \mathrm{Finset}\ \alpha,\ \forall\,hsub : \mathrm{certified}\ \subseteq\ \mathrm{zeros},\ \forall\,hcard : \mathrm{zeros.card}\le\ \mathrm{certified.card},\ \mathrm{zeros}=\mathrm{certified}$ |
| [61](../geometric-dynamical-phase-transitions/lean/CertifiedZero.lean#L61) | theorem | `all_zeros_are_certified` | $\forall\,\alpha : \mathrm{Type}\cdot,\ \forall\,[\mathrm{DecidableEq}\ \alpha],\ \forall\,zeros\,certified : \mathrm{Finset}\ \alpha,\ \forall\,hsub : \mathrm{certified}\ \subseteq\ \mathrm{zeros},\ \forall\,hcard : \mathrm{zeros.card}\le\ \mathrm{certified.card},\ \forall\ z\ \in\ \mathrm{zeros},\ z\ \in\ \mathrm{certified}$ |
| [77](../geometric-dynamical-phase-transitions/lean/CertifiedZero.lean#L77) | theorem | `IsolationCertificate.exhausts` | $\forall\,\alpha : \mathrm{Type}\cdot,\ \forall\,[\mathrm{DecidableEq}\ \alpha],\ \forall\,C : \mathrm{IsolationCertificate}\ \alpha,\ \forall\ z\ \in\ C.\mathrm{zeros},\ z\ \in\ C.\mathrm{certified}$ |
