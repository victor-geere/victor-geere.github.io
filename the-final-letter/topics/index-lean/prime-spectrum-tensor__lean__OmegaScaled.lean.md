# `prime-spectrum-tensor/lean/OmegaScaled.lean`

[Back to the split index](index.md) · Topic: [`prime-spectrum-tensor`](../prime-spectrum-tensor/README.md)

### [`prime-spectrum-tensor/lean/OmegaScaled.lean`](../prime-spectrum-tensor/lean/OmegaScaled.lean) — 3 proofs

| Line | Kind | Proof | Statement (LaTeX) |
|---:|---|---|---|
| [32](../prime-spectrum-tensor/lean/OmegaScaled.lean#L32) | theorem | `log4_mem` | $:(\mathrm{log4Lo}:\mathbb{R})\le\ \mathrm{Real.log}\ 4\ \land\ \mathrm{Real.log}\ 4\le(\mathrm{log4Hi}:\mathbb{R})$ |
| [36](../prime-spectrum-tensor/lean/OmegaScaled.lean#L36) | lemma | `panel_log_re_mem_scaled` | $\forall\,t : \mathbb{Q},\ \forall\,N\,M\,j : \mathbb{N},\ \forall\,hj : (4:\mathbb{Q})^{j}\le\ \mathrm{panelQ}\ t\ N,\ (1/2)\cdot((\mathrm{logPointLo}\ M(\mathrm{panelQ}\ t\ N/4^{j}):\mathbb{R})+(j:\mathbb{R})\cdot(\mathrm{log4Lo}:\mathbb{R}))\le(\mathrm{Complex.log}(\mathrm{panelPoint}\ t\ N)).\mathrm{re}\ \land(\mathrm{Complex.log}(\mathrm{panelPoint}\ t\ N)).\mathrm{re}\le(1/2)\cdot((\mathrm{logPointHi}\ M(\mathrm{panelQ}\ t\ N/4^{j}):\mathbb{R})+(j:\mathbb{R})\cdot(\mathrm{log4Hi}:\mathbb{R}))$ |
| [99](../prime-spectrum-tensor/lean/OmegaScaled.lean#L99) | theorem | `omega_mem_scaled` | $\forall\,t : \mathbb{Q},\ \forall\,N\,M\,j : \mathbb{N},\ \forall\,hN : 1\le\ N,\ \forall\,ht : t\ne\ 0,\ \forall\,hj : (4:\mathbb{Q})^{j}\le\ \mathrm{panelQ}\ t\ N,\ (\mathrm{omegaLoS}\ t\ N\ M\ j:\mathbb{R})\le\ \mathrm{Omega}(t:\mathbb{R})\ \land\ \mathrm{Omega}(t:\mathbb{R})\le(\mathrm{omegaHiS}\ t\ N\ M\ j:\mathbb{R})$ |
