# `factorisation-theta/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`factorisation-theta`](../factorisation-theta/README.md)

### [`factorisation-theta/lean/Topic.lean`](../factorisation-theta/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [47](../factorisation-theta/lean/Topic.lean#L47) | theorem | `divisorDetector_nonpos` | $\forall\,k : \mathbb{N},\ \forall\,x : \mathbb{R},\ \mathrm{divisorDetector}\ k\ x\le\ 0$ |
| [54](../factorisation-theta/lean/Topic.lean#L54) | theorem | `divisorDetector_eq_zero_iff` | $\forall\,k : \mathbb{N},\ \forall\,x : \mathbb{R},\ \mathrm{divisorDetector}\ k\ x=0\leftrightarrow\ \mathrm{Real.cos}(2\cdot\ \mathrm{Real.pi}\cdot(k:\mathbb{R})/x)=1\ \land\ \mathrm{Real.cos}(2\cdot\ \mathrm{Real.pi}\cdot\ x)=1$ |
| [69](../factorisation-theta/lean/Topic.lean#L69) | theorem | `divisorDetector_neg` | $\forall\,k : \mathbb{N},\ \forall\,x : \mathbb{R},\ \mathrm{divisorDetector}\ k(-x)=\mathrm{divisorDetector}\ k\ x$ |
| [80](../factorisation-theta/lean/Topic.lean#L80) | theorem | `divisorDetector_of_dvd` | $\forall\,k\,d : \mathbb{N},\ \forall\,hd : d\ \mid\ k,\ \forall\,hd_{0} : d\ne\ 0,\ \mathrm{divisorDetector}\ k(d:\mathbb{R})=0$ |
| [97](../factorisation-theta/lean/Topic.lean#L97) | theorem | `divisorDetector_eq_zero_iff_dvd` | $\forall\,k : \mathbb{N},\ \forall\,x : \mathbb{Z},\ \forall\,hx : x\ne\ 0,\ \mathrm{divisorDetector}\ k(x:\mathbb{R})=0\leftrightarrow\ x\ \mid(k:\mathbb{Z})$ |
| [129](../factorisation-theta/lean/Topic.lean#L129) | theorem | `finiteTheta_pos` | $\forall\,N : \mathbb{N},\ \forall\,hN : 0<N,\ \forall\,t : \mathbb{R},\ 0<\mathrm{finiteTheta}\ N\ t$ |
| [137](../factorisation-theta/lean/Topic.lean#L137) | theorem | `finiteTheta_antitone` | $\forall\,N : \mathbb{N},\ \mathrm{Antitone}(\mathrm{finiteTheta}\ N)$ |
