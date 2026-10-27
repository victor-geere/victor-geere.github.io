# Theorem 9.1 (Tightness)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §9](../../geometric-dynamical-phase-transitions/publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

The families \(\{\mu_N\}_{N\ge 2}\) and \(\{\nu_N\}_{N\ge 2}\) are tight in the weak-star topology of tempered measures on \(S_\delta\).

## Proof

The abscissa interval \([\delta,1-\delta]\) is compact, so it is enough to control imaginary tails. The residual satisfies \[
\int_{\lvert t\rvert>A}\rho_N\,d\sigma\,dt\le N^{-1}\int_\delta^{1-\delta}d\sigma\int_{\lvert t\rvert>A}(1+t^2)^{-1}\,dt=O(N^{-1}A^{-1}),
\] uniformly in \(N\). For the atomic part, Lemma 9.6 gives, for all \(N\ge N_1(\delta,\varepsilon)\) and \(A\ge 3\), \[
\nu_N^{\mathrm{pp}}\bigl(\{\lvert t\rvert>A\}\bigr)\le C\,\frac{(\log A)^2}{A}+\frac{C}{\log N},
\] and the same for \(\mu_N^{\mathrm{pp}}\subset\nu_N^{\mathrm{pp}}\). Given \(\eta>0\), choose \(A\) so that \(C(\log A)^2/A\) and the residual tail are each \(<\eta/3\); then choose \(N_2\ge N_1\) with \(C/\log N<\eta/3\) for \(N\ge N_2\); the finitely many measures with \(N<N_2\) are handled by enlarging \(A\), each \(\nu_N\) being a finite measure. Prokhorov’s theorem [\[3\]](../../geometric-dynamical-phase-transitions/publication.html#ref-prokhorov) then yields tightness of both families. (On a balanced closure one may in addition divide by the prefactor lower bound \(P_N\ge N^{1/2-\varepsilon/2}\), recovering \(\lvert\zeta\rvert\le N^{-\varepsilon/2}+O\bigl((1+\lvert t\rvert)N^{1/2+\varepsilon/2-2\sigma}\bigr)\) on the window — the comparison used for depth; it is not needed for tightness.)
