# Lemma 5.5 (Rouché localisation of components)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §5](../../geometric-dynamical-phase-transitions/publication.html#sec5) · 5. Geometric dynamical phase transitions |
| Proof in source | yes |

## Statement

Let \(\rho\) be a zero of \(\Xi\) in the interior of \(S_\delta\), of finite multiplicity. For all \(N\ge N_0(\rho)\) the disk \(\lvert s-\rho\rvert<N^{-\kappa}\) contains exactly as many zeros of \(\eta_N^{(N^2)}\) as the multiplicity of \(\rho\), and meets \(\Omega_N\) in a single connected component. Extra components of \(\Omega_N\) are Dirichlet-polynomial zeros; their tempered mass on the moderate range is Lemma 9.6, and they cannot accumulate at a fixed non-zero (Theorem 10.1).

## Proof

On the circle \(\lvert s-\rho\rvert=N^{-\kappa}\), one has \(\lvert\zeta(s)\rvert\asymp_\rho N^{-\kappa}\). Theorem 4.3 gives \(\bigl\lvert\eta-(1-N^{1-s})\zeta\bigr\rvert=O(F_N)\). The main term has size \(P_N\lvert\zeta\rvert\asymp_\rho N^{1-\sigma-\kappa}\). This dominates \(F_N\asymp(1+\lvert\gamma\rvert)N^{1-2\sigma}\) once \(N^{\sigma-\kappa}\gg 1+\lvert\gamma\rvert\), the threshold of Theorem 5.2 with \(\kappa=\varepsilon\). Rouché therefore equates the zeros of \(\eta\) and of \((1-N^{1-s})\zeta\) inside the disk. The elementary factor \(1-N^{1-s}\) has no zero in \(S_\delta\) (Lemma 2.2), so the count equals the multiplicity of \(\rho\). A holomorphic function has \(\lvert f\rvert\) small throughout a neighbourhood of its zeros and not elsewhere on the circle, so that disk meets \(\Omega_N\) in one component. Extra components are Dirichlet-polynomial zeros, controlled globally by Lemma 9.6 rather than by a pointwise exclusion.
