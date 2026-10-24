# Theorem 11.1 (Residual vanishing)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §11](publication.html#sec11) · 11. Vanishing of residual continuous spectrum |
| Proof in source | yes |

## Statement

Along any weak-star convergent subsequence the residual densities \(\rho_{N_j}\,d\sigma\,dt\) converge to the zero measure on \(S_\delta\). Consequently every weak-star limit point of \(\{\mu_N\}\) or of \(\{\nu_N\}\) is pure-point.

## Proof

\[
\int_{S_\delta}\rho_N\,d\sigma\,dt\le N^{-1}\int_{S_\delta}(1+\lvert s\rvert^2)^{-1}\,d\sigma\,dt=O(N^{-1}).
\] Thus the total residual mass tends to zero. For every continuous test function \(f\) of compact support in \(S_\delta\), \(\int f\rho_N\to 0\). Any weak-star limit of \(\mu_N=\mu_N^{\mathrm{pp}}+\rho_N\,d\sigma\,dt\) therefore coincides with the corresponding limit of \(\mu_N^{\mathrm{pp}}\), and likewise for \(\nu_N\). Existence of the limits is Theorem 9.1.
