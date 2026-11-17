# `zeta-from-theta/lean/Mellin.lean`

[Back to the split index](index.md) · Topic: [`zeta-from-theta`](../zeta-from-theta/README.md)

### [`zeta-from-theta/lean/Mellin.lean`](../zeta-from-theta/lean/Mellin.lean) — 2 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [19](../zeta-from-theta/lean/Mellin.lean#L19) | theorem | `summable_pi_mul_sq_rpow` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{Summable}(\lambda\ n:\mathbb{N}+\Rightarrow(1:\mathbb{R})/(\mathrm{Real.pi}\cdot(((n:\mathbb{N}):\mathbb{R}))^{2})^{s/2}.\mathrm{re})$ |
| [42](../zeta-from-theta/lean/Mellin.lean#L42) | theorem | `hasSum_mellin_psi` | $\forall\,s : \mathbb{C},\ \forall\,hs : 1<s.\mathrm{re},\ \mathrm{HasSum}(\lambda\ n:\mathbb{N}+\Rightarrow\ \mathrm{Complex.Gamma}(s/2)\cdot(1:\mathbb{C})/((\mathrm{Real.pi}\cdot(((n:\mathbb{N}):\mathbb{R}))^{2}:\mathbb{R}):\mathbb{C})^{s/2})(\mathrm{mellin}\ \mathrm{psi}(s/2))$ |
