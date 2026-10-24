# Proposition F.2 (Free-energy density of the polygon; the transition has latent drop \(\sigma\))

| Field | Value |
|---|---|
| Type | Proposition |
| Status | Proved |
| Source | [publication.html Addendum F](../../geometric-dynamical-phase-transitions/publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Write \(\varphi_N(s)=\log\bigl\lvert\eta_N^{(N^2)}(s)\bigr\rvert/\log N\) for \(s\in S_\delta\) on the tightness window \(\lvert t\rvert\le N^{1/2-\varepsilon}\). Then, as \(N\to\infty\) at fixed \(s\):

1.  if \(\zeta(s)\ne0\), \(\varphi_N(s)\to1-\sigma\) (the main-term scale \(P_N\));
2.  if \(\zeta(s)=0\), \(\varphi_N(s)\to1-2\sigma\) (the Euler–Maclaurin floor \(F_N\), attained: Corollaries 4.3.1 and 4.3.2);
3.  the DQPT depth \(D_N\) is the level \(\tfrac12-\varepsilon\), and the slow-passage cap is the level \(\tfrac12+\varepsilon\) for \(\log\lvert\partial_t\eta\rvert/\log N\).

The drop of the density at a zero is \((1-\sigma)-(1-2\sigma)=\sigma\) for every abscissa. A balanced closure (Definition 5.1) is a drop from a generic level at least \(\tfrac12-\varepsilon/2\) to a level at most \(\tfrac12-\varepsilon\); the generic level, the zero level and the depth level coincide, up to \(\varepsilon\), at \(\sigma=\tfrac12\) and nowhere else. On the critical line the zero level is \(0\): \(\lvert\eta(\rho)\rvert\to\tfrac12\) for every critical-line zero on the window, which is the value \(0.49\)–\(0.50\) recorded in Section 13.

## Proof

\(i\) and (ii) are Theorem 4.3 and Corollary 4.3.2 read in base \(N\): off the zeros \(\lvert\eta\rvert=P_N\lvert\zeta\rvert+O(F_N)\) with \(P_N\asymp N^{1-\sigma}\) and \(F_N=o(P_N)\) on \(S_\delta\); at a zero the half-term \(\tfrac12(1-N)N^{-2s}\) has modulus \(\tfrac12(N-1)N^{-2\sigma}\) and dominates the next Bernoulli remainder by the factor \(N/\lvert s\rvert^2\ge N^{2\varepsilon}\) on the window, for every \(\sigma\in[\delta,1-\delta]\) (the proof of Corollary 4.3.2 does not use \(\sigma\le\tfrac12\)). (iii) is Definition 4.4. At \(\sigma=\tfrac12\) the half-term is \(\tfrac12(1-N)N^{-1-2i\gamma}\), of modulus \(\tfrac12(1-N^{-1})\).
