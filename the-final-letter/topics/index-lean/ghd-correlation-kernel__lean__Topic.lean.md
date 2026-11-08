# `ghd-correlation-kernel/lean/Topic.lean`

[Back to the split index](index.md) · Topic: [`ghd-correlation-kernel`](../ghd-correlation-kernel/README.md)

### [`ghd-correlation-kernel/lean/Topic.lean`](../ghd-correlation-kernel/lean/Topic.lean) — 7 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [39](../ghd-correlation-kernel/lean/Topic.lean#L39) | theorem | `alpha_pos` | $\forall\,n : \mathbb{N},\ 0<\mathrm{alpha}\ n$ |
| [43](../ghd-correlation-kernel/lean/Topic.lean#L43) | theorem | `alpha_strictAnti` | $:\mathrm{StrictAnti}\ \mathrm{alpha}$ |
| [52](../ghd-correlation-kernel/lean/Topic.lean#L52) | theorem | `Kdiag_alpha_closed` | $\forall\,n : \mathbb{N},\ \mathrm{Kdiag}(\mathrm{alpha}\ n)=\mathrm{Real.pi}/3\cdot(1+((n:\mathbb{R})+1)^{3})/((n:\mathbb{R})+2)^{3}$ |
| [59](../ghd-correlation-kernel/lean/Topic.lean#L59) | theorem | `Kdiag_pos` | $\forall\,t : \mathbb{R},\ \forall\,h_{0} : 0<t,\ \forall\,h\pi : t<\mathrm{Real.pi},\ 0<\mathrm{Kdiag}\ t$ |
| [67](../ghd-correlation-kernel/lean/Topic.lean#L67) | theorem | `Kdiag_symm` | $\forall\,t : \mathbb{R},\ \mathrm{Kdiag}\ t=\mathrm{Kdiag}(\mathrm{Real.pi}-t)$ |
| [71](../ghd-correlation-kernel/lean/Topic.lean#L71) | theorem | `Kdiag_half` | $:\mathrm{Kdiag}(\mathrm{Real.pi}/2)=\mathrm{Real.pi}/12$ |
| [77](../ghd-correlation-kernel/lean/Topic.lean#L77) | theorem | `Kstep_symm` | $\forall\,a\,b : \mathbb{R},\ \mathrm{Kstep}\ a\ b=\mathrm{Kstep}\ b\ a$ |
