# Definition 5.4 (Relative sublevel set)

| Field | Value |
|---|---|
| Type | Definition |
| Status | Definition |
| Source | [publication.html §5](publication.html#sec5) · 5. Geometric dynamical phase transitions |
| Proof in source | no separate proof block |

## Statement

\[
\Omega_N=\bigl\{s\in\operatorname{int}S_{\delta/2}:\bigl\lvert\eta_N^{(N^2)}(s)\bigr\rvert< P_N(s)\,N^{-\varepsilon}\bigr\}
=\bigl\{s\in\operatorname{int}S_{\delta/2}:\lvert h_N(s)\rvert<N^{-\varepsilon}\bigr\},
\qquad h_N=\frac{\eta_N^{(N^2)}}{1-N^{1-s}},
\] an open set: components are taken in the half-margin strip \(S_{\delta/2}\), on which \(h_N\) is holomorphic (Lemma 2.2), while representatives lie on the grid in \(S_\delta\); the boundary case of equality carries no representative. The unrestricted closures \(\mathcal{U}_N\) are one representative from each connected component of \(\Omega_N\) that meets a grid line and is a slow lift: the minimiser of \(\lvert\eta\rvert\) over the grid points of the component, subject to Definition 5.1 (ii) and (iii). The representative is required to be *anchored*: its component contains a zero of \(\eta_N^{(N^2)}\) within unit distance of the representative — an exact closure of the polygon certifying the event. Lemma 5.5 supplies such a zero within \(N^{-\kappa}\) of every zero of \(\Xi\) once \(N\ge N_0(\rho)\), so anchoring removes no atom at a zero of \(\Xi\); distinct components contain distinct certifying zeros. A component of diameter \(O(N^{-\kappa})\) can meet several of the finer grid lines; the component convention counts it once, so a zero of \(\Xi\) carries a single Dirac mass (Lemma 5.5). The same convention applies to \(\mathcal{C}_N\).

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
