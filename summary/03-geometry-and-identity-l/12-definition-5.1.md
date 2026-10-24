# Definition 5.1 (Path-closure events in the strip)

| Field | Value |
|---|---|
| Type | Definition |
| Status | Definition |
| Source | [publication.html §5](publication.html#sec5) · 5. Geometric dynamical phase transitions |
| Proof in source | no separate proof block |

## Statement

Fix \(\varepsilon\in(0,1/6)\) and set the isolation exponent \(\kappa=\varepsilon\). For each integer \(N\ge 2\) let \(\Sigma_N\) be the finite grid \[
\Sigma_N=\Bigl(\bigl\{\tfrac12\bigr\}\cup\bigl\{\delta+j N^{-\kappa}(\log N)^{-1}:j\in\mathbb{N}_0\bigr\}\Bigr)\cap[\delta,1-\delta].
\] The critical line is always a grid abscissa, so Corollary 4.1.1 applies on \(\sigma=\tfrac12\) without interpolation. Any finite set of additional abscissae in \([\delta,1-\delta]\), independent of \(N\), may be included in \(\Sigma_N\). A point \(s=\sigma+it\) with \(\sigma\in\Sigma_N\) is an *unrestricted path-closure* of generation \(N\) when

1.  \(\bigl\lvert\eta_N^{(N^2)}(s)\bigr\rvert\le P_N(s)\,N^{-\varepsilon}\) (relative depth, Definition 4.4),
2.  \(t\) is a local minimum of \(u\mapsto\bigl\lvert\eta_N^{(N^2)}(\sigma+iu)\bigr\rvert\) in \((t-N^{-\kappa},t+N^{-\kappa})\),
3.  \(\eta^{\#}(s)\le N^{1/2+\varepsilon}\) (Marty speed, Lemma 4.8: spherical speed of the north-pole lift).

It is a *balanced path-closure* when, in addition,

4.  \(P_N(s)\ge N^{1/2-\varepsilon/2}\),
5.  \(\bigl\lvert\eta_N^{(N^2)}(s)\bigr\rvert\le D_N=N^{1/2-\varepsilon}\) (uniform DQPT depth),
6.  \(\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert\le N^{1/2+\varepsilon}\) (slow passage).

Write \(\mathcal{C}_N\) for the set of balanced closures and \(\mathcal{U}_N\) for the set of unrestricted closures. Both are discrete subsets of \(S_\delta\). On \(\sigma=\tfrac12\) one has \(P_N\asymp N^{1/2}\), so relative and uniform depths coincide, and Lemma 4.5.1 makes (vi) automatic at critical-line zeros for large \(N\). Near a local minimum with \(\lvert\eta\rvert\) small, (iii) and (vi) coincide. The choice \(\kappa=\varepsilon\) with spacing \(N^{-\kappa}(\log N)^{-1}\) makes a grid miss leak a main term \(P_N\,O(N^{-\kappa}/\log N)\), strictly below the relative threshold \(P_N N^{-\varepsilon}\) once \(N\) is large: the logarithm absorbs the implied constant. The grid-line count grows only by the same logarithm, and the tightness exponent \(2\kappa-1/2+\varepsilon=3\varepsilon-1/2\) is negative, so \(N^{3\varepsilon-1/2}\log N\to 0\). Marty speed and slow passage only remove transits; they do not add atoms, so the tightness tail of Theorem 9.1 is unchanged.

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
