# Lemma 4.3.3 (Completed curve over \(\mathbb{R}\), tightness window)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](../../geometric-dynamical-phase-transitions/publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

For each fixed \(\sigma\in[\delta,1-\delta]\) the map \[
t\mapsto\eta_N^{(N^2)}(\sigma+it),\qquad t\in\mathbb{R},
\] is a trigonometric polynomial, hence a real-analytic curve \(\mathbb{R}\to\mathbb{C}\). Completing the underlying polygonal path to a continuous fibre curve as in [nested_spheres_RH.html](../../geometric-dynamical-phase-transitions/maths/nested_spheres_RH.html) (sampling error \(O(N^{-1})\) in Hausdorff distance on the fibre; interactive picture in [viz.html](../../geometric-dynamical-phase-transitions/viz.html)) yields a continuous curve \(\gamma_{N,\sigma}:\mathbb{R}\to\mathbb{C}\) with \[
\bigl\lvert\bigl\lvert\eta_N^{(N^2)}(\sigma+it)\bigr\rvert-\operatorname{dist}(0,\gamma_{N,\sigma}(t))\bigr\rvert\ll N^{-1}.
\] The nested sequence of these curves, scaled by successive factors \(N^{-1}\), is the fractal geometry of the construction. Theorem 9.1 localises all but \(o(1)\) of the atomic mass to the window \(\lvert t\rvert\le N^{1/2-\varepsilon}\): that window is built into the fractal because isolation of minima at scale \(N^{-\kappa}\) and packing of the completed curve against the tempering measure \((1+t^2)^{-1}\,dt\) produce a negative exponent only there. Consequently any lower bound for \(\operatorname{dist}(0,\gamma_{N,\sigma})\) on this window transfers to \(\lvert\eta_N^{(N^2)}\rvert\) up to \(O(N^{-1})\). On the same window the unmatched last chord of the completed curve — the order-zero boundary term \(\tfrac12(1-N)N^{-2s}\) — has size \(\tfrac12 N^{1-2\sigma}\) and is not cancelled by the next Bernoulli remainder, which is Corollary 4.3.2. The unique self-similar scale at which this chord is \(O(1+\lvert t\rvert)\) while the prefactor is \(N^{1/2}\) remains \(\sigma=\tfrac12\).

## Proof

The Dirichlet polynomial is a finite sum of characters \(t\mapsto m^{-it}\), hence real-analytic on \(\mathbb{R}\). Each edge of the polygonal path subtends an angle \(O(N^{-1})\) on a fibre of radius \(O(1)\), so the Hausdorff distance to a complete fibre curve is \(O(N^{-1})\) uniformly in \(t\) ([nested_spheres_RH.html](../../geometric-dynamical-phase-transitions/maths/nested_spheres_RH.html), Lemma 3.2). The endpoint of the polygon is \(\eta_N^{(N^2)}\), so the displayed comparison of moduli follows. Tightness is Theorem 9.1: high-height packing on the completed curve contributes mass \(O(N^{3\varepsilon-1/2}\log N)\). Restricting to \(\lvert t\rvert\le N^{1/2-\varepsilon}\) therefore loses only \(o(1)\) mass, and is the range in which Corollary 4.3.2 applies. The last-chord identification is the order-zero Euler–Maclaurin boundary term already used there; \(O(N^{-1})\) is smaller than \(\tfrac14 N^{1-2\sigma}\) throughout \(S_\delta\).
