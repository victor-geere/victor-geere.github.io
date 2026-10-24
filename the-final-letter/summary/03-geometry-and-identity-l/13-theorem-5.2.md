# Theorem 5.2 (Geometric DQPT criterion)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §5](../../geometric-dynamical-phase-transitions/publication.html#sec5) · 5. Geometric dynamical phase transitions |
| Proof in source | yes |

## Statement

Every balanced path-closure \(s=\sigma+it\in\mathcal{C}_N\) satisfies \(\sigma\le\tfrac12+\varepsilon/2\). Every critical-line zero of \(\Xi\) with \(\lvert\gamma\rvert\le T\) produces a balanced closure for all \(N\ge N_0(T,\rho)\), with \(N_0\) as in Corollary 4.1.2 enlarged if necessary so that Lemma 4.5.1 supplies the slow-passage bound (if \(\zeta'(\rho)=0\) the speed is \(O((1+\lvert\gamma\rvert)\log N)\), which is even smaller). Relative depth without Marty speed holds at every zero of real part \(\sigma\ge\varepsilon\). Marty speed (iii) holds at simple zeros with \(\sigma\ge\tfrac12-\varepsilon\) and fails with \(\sigma\le\tfrac12-\varepsilon\) (Lemma 4.8). Thus an unrestricted fibre-closure occurs at critical-line zeros and at simple zeros in the right half-strip, not at simple zeros in the left half-strip.

## Proof

On \(S_\delta\) one has \(P_N(s)\ge N^{1-\sigma}-1\). Condition (iv) therefore forces \(\sigma\le\tfrac12+\varepsilon/2\) for large \(N\). On the critical line, which belongs to \(\Sigma_N\), \(P_N\ge N^{1/2}-1\), so (iv) and (v) reduce to Corollary 4.1.1, and (iii) and (vi) are Lemma 4.5.1. Local isolation (ii) holds for large \(N\) because the zeros of \(\Xi\) are isolated and \(N^{-\kappa}\) is eventually smaller than half the gap to the neighbouring zero. For an off-line zero \(\rho=\sigma+i\gamma\), Corollary 4.3.1 and \(P_N(\rho)\asymp N^{1-\sigma}\) give the relative inequality as soon as \(N^{\sigma-\varepsilon}\ge 1+\lvert\gamma\rvert\). At the nearest \(\sigma_N\in\Sigma_N\), \(\lvert\sigma_N-\sigma\rvert\le N^{-\kappa}(\log N)^{-1}\) and \(\zeta(\sigma_N+i\gamma)=O_\rho(N^{-\kappa}/\log N)\) by analyticity, so the leaked main term is at most \(P_N N^{-\varepsilon}\) once \(N\ge N(\rho)\): the logarithm in the spacing absorbs the implied constant. Marty speed at the minimiser is Lemma 4.8: it fails on the left of \(\tfrac12-\varepsilon\) and holds on the right.
