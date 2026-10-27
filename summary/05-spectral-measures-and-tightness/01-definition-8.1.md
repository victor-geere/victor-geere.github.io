# Definition 8.1 (Finite measures on the strip)

| Field | Value |
|---|---|
| Type | Definition |
| Status | Definition |
| Source | [publication.html §8](publication.html#sec8) · 8. Construction of finite spectral measures |
| Proof in source | no separate proof block |

## Statement

With \(\mathcal{C}_N\) and \(\mathcal{U}_N\) as in Definition 5.1, set \[
\mu_N^{\mathrm{pp}}=\sum_{s\in\mathcal{C}_N}(1+\lvert s\rvert^2)^{-1}\,\delta_s,
\qquad
\nu_N^{\mathrm{pp}}=\sum_{s\in\mathcal{U}_N}(1+\lvert s\rvert^2)^{-1}\,\delta_s,
\] and let \(\rho_N\) be the residual density on \(S_\delta\) \[
\rho_N(\sigma+it)=\frac1N\min\Bigl(1,\bigl\lvert\eta_N^{(N^2)}(\sigma+it)\bigr\rvert^2\Bigr)\,(1+\lvert s\rvert^2)^{-1}.
\] Then \(\mu_N=\mu_N^{\mathrm{pp}}+\rho_N\,d\sigma\,dt\) is the *balanced* measure and \(\nu_N=\nu_N^{\mathrm{pp}}+\rho_N\,d\sigma\,dt\) is the *unrestricted* measure. The factor \(1/N\) makes \(\int_{S_\delta}\rho_N=O(N^{-1})\), since \(\int_{S_\delta}(1+\lvert s\rvert^2)^{-1}\,d\sigma\,dt\ll 1\). The atomic weights are independent of \(N\).

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
