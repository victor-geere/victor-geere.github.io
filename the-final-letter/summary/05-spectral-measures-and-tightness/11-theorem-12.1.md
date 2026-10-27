# Theorem 12.1 (Balanced spectral measure)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §12](../../geometric-dynamical-phase-transitions/publication.html#sec12) · 12. Realisation of the limiting measure |
| Proof in source | yes |

## Statement

Any weak-star limit point \(\mu\) of \(\{\mu_N\}\) is a tempered pure-point measure on \(S_\delta\) whose support consists of non-trivial zeros of \(\Xi\) with real part at most \(\tfrac12+\varepsilon/2\). Every critical-line zero of \(\Xi\) is an atom of \(\mu\), with mass \((1+\lvert\rho\rvert^2)^{-1}\). There are no atoms at non-zeros. There are no simple atoms with \(\sigma\le\tfrac12-\varepsilon\).

## Proof

Tightness is Theorem 9.1. Residual vanishing is Theorem 11.1, so the limit is pure-point. Theorem 10.1 identifies atoms with zeros of \(\Xi\) in \(S_\delta\) and restricts balanced atoms to \(\operatorname{Re}s\le\tfrac12+\varepsilon/2\). Simple atoms with \(\sigma\le\tfrac12-\varepsilon\) are excluded by Proposition 4.6. Conversely, if \(\rho=\tfrac12+i\gamma\) is a critical-line zero of \(\Xi\), Corollary 4.1.2 produces a path-closure of depth \(D_N\) for every \(N\ge N_0(\lvert\gamma\rvert)\), on the grid abscissa \(\sigma=\tfrac12\); Lemma 4.5.1 makes it slow for all large \(N\), hence balanced. For all large \(N\) this closure is the unique local minimum in its isolation interval. The atomic weight \((1+\lvert\rho\rvert^2)^{-1}\) is independent of \(N\), so \(\rho\) is an atom of every weak-star limit.
