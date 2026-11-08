# `prime-spectrum-tensor/lean/OmegaGlobal.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/OmegaGlobal.lean`](../prime-spectrum-tensor/lean/OmegaGlobal.lean) — 11 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [25](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L25) | theorem | `omegaPoint_re` | $\forall\,t : \mathbb{R},\ (\mathrm{omegaPoint}\ t).\mathrm{re}=1/4$ |
| [27](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L27) | theorem | `omegaPoint_im` | $\forall\,t : \mathbb{R},\ (\mathrm{omegaPoint}\ t).\mathrm{im}=t/2$ |
| [29](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L29) | theorem | `omegaPoint_norm_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0\le\ t,\ \Vert{}\mathrm{omegaPoint}\ t\Vert\le\ 1/4+t/2$ |
| [38](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L38) | theorem | `quarter_le_norm_omegaPoint` | $\forall\,t : \mathbb{R},\ 1/4\le\ \Vert{}\mathrm{omegaPoint}\ t\Vert$ |
| [43](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L43) | theorem | `Omega_eq_re_digamma` | $\forall\,t : \mathbb{R},\ \mathrm{IntersectionForm.Omega}\ t=(\mathrm{Complex.digamma}(\mathrm{omegaPoint}\ t)).\mathrm{re}-\mathrm{Real.log}\ \mathrm{Real.pi}$ |
| [49](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L49) | theorem | `abs_six_le` | $\forall\,a\,b\,c\,d\,e\,f : \mathbb{R},\ \vert{}a-b-c-d+e-f\vert\le\ \vert{}a\vert+\vert{}b\vert+\vert{}c\vert+\vert{}d\vert+\vert{}e\vert+\vert{}f\vert$ |
| [69](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L69) | theorem | `omegaRem_norm_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \Vert{}\mathrm{omegaRem}\ t\Vert\le\ 13$ |
| [79](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L79) | theorem | `Omega_expansion` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \mathrm{IntersectionForm.Omega}\ t=(\mathrm{Complex.log}(\mathrm{omegaPoint}\ t)).\mathrm{re}-\mathrm{Real.log}\ \mathrm{Real.pi}-(1/(2\cdot\ \mathrm{omegaPoint}\ t)).\mathrm{re}-(1/(12\cdot(\mathrm{omegaPoint}\ t)^{2})).\mathrm{re}+(1/(120\cdot(\mathrm{omegaPoint}\ t)^{4})).\mathrm{re}-(\mathrm{omegaRem}\ t).\mathrm{re}$ |
| [91](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L91) | theorem | `log_four_le_two` | $:\mathrm{Real.log}\ 4\le\ 2$ |
| [100](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L100) | theorem | `abs_log_omegaPoint_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \vert(\mathrm{Complex.log}(\mathrm{omegaPoint}\ t)).\mathrm{re}\vert\le\ \mathrm{Real.log}(t+2)+2$ |
| [123](../prime-spectrum-tensor/lean/OmegaGlobal.lean#L123) | theorem | `abs_Omega_le` | $\forall\,t : \mathbb{R},\ \forall\,ht : 0<t,\ \vert{}\mathrm{IntersectionForm.Omega}\ t\vert\le\ \mathrm{Real.log}(t+2)+24$ |
