# `zeta-from-theta/lean/Theta.lean`

[Back to the split index](index.md) · Topic: [`zeta-from-theta`](../zeta-from-theta/README.md)

### [`zeta-from-theta/lean/Theta.lean`](../zeta-from-theta/lean/Theta.lean) — 5 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [25](../zeta-from-theta/lean/Theta.lean#L25) | theorem | `summable_theta` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{Summable}(\lambda\ n:\mathbb{Z}\Rightarrow\ \mathrm{Real.exp}(-\mathrm{Real.pi}\cdot\ t\cdot(n:\mathbb{R})^{2}))$ |
| [63](../zeta-from-theta/lean/Theta.lean#L63) | theorem | `theta_pos` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ 0<\mathrm{theta}\ t$ |
| [69](../zeta-from-theta/lean/Theta.lean#L69) | theorem | `theta_one_div` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{theta}(1/t)=\mathrm{Real.sqrt}\ t\cdot\ \mathrm{theta}\ t$ |
| [84](../zeta-from-theta/lean/Theta.lean#L84) | theorem | `theta_eq_one_add_two_tsum` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{theta}\ t=1+2\cdot\ \sum'\ n:\mathbb{N}+,\ \mathrm{Real.exp}(-\mathrm{Real.pi}\cdot\ t\cdot(((n:\mathbb{N}):\mathbb{R}))^{2})$ |
| [104](../zeta-from-theta/lean/Theta.lean#L104) | theorem | `psi_eq_tsum` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{psi}\ t=\sum'\ n:\mathbb{N}+,(\mathrm{Real.exp}(-\mathrm{Real.pi}\cdot\ t\cdot(((n:\mathbb{N}):\mathbb{R}))^{2}):\mathbb{R})$ |
