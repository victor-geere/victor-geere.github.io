# Lemma 4.8 (North-pole lift; Marty speed)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Identify the nested-sphere fibre with \(\mathbb{C}\) by stereographic projection from the north pole \(N=(0,0,1)\) onto the equatorial plane, as in [projection.html](projection.html): \[
\pi_N(x,y,z)=\frac{x+iy}{1-z},\qquad
\pi_N^{-1}(w)=\Bigl(\frac{2w}{1+\lvert w\rvert^2},\;\frac{\lvert w\rvert^2-1}{1+\lvert w\rvert^2}\Bigr)\in\mathbb{C}\times\mathbb{R}.
\] The south pole \(S\) is the origin of \(\mathbb{C}\); \(N\) is the point at infinity. The round metric on \(S^2\) pulls back to the spherical derivative (Marty) \[
\eta^{\#}(s)=\frac{\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert}{1+\bigl\lvert\eta_N^{(N^2)}(s)\bigr\rvert^2}.
\] Near \(S\) one has \(\eta^{\#}\sim\lvert\partial_t\eta\rvert\). A Hilbert-cell visit on the fibre is a slow visit to \(S\), not a Euclidean-small value in the unbounded chart. Let \(\rho=\sigma+i\gamma\) be a simple zero of \(\Xi\). If \(\sigma<\tfrac12\), then \(\lvert\eta(\rho)\rvert\ge\tfrac14 N^{1-2\sigma}\to\infty\) (Corollary 4.3.2), so \(\pi_N^{-1}(\eta(\rho))\to N\): the endpoint at the zero itself tends to the projection centre, not to \(S\). At a local minimiser of \(\lvert\eta\rvert\) in the isolation disk one has \(\lvert\eta\rvert\) small, hence \(\eta^{\#}\sim\lvert\partial_t\eta\rvert\), and Identity L gives \(\eta^{\#}>N^{1/2+\varepsilon}\) once \(\sigma\le\tfrac12-\varepsilon\). If \(\sigma>\tfrac12\), then \(\lvert\partial_t\eta\rvert\asymp N^{1-\sigma}\lvert\zeta'(\rho)\rvert=o(N^{1/2+\varepsilon})\) and \(\eta^{\#}\) passes the same cap.

## Proof

The identities for \(\pi_N\) are the standard north-pole chart of \(S^2\); the spherical element is \(2\lvert dw\rvert/(1+\lvert w\rvert^2)\), whence the displayed formula for \(\eta^{\#}\). The limit \(\pi_N^{-1}(\eta(\rho))\to N\) is \(\lvert\eta(\rho)\rvert\to\infty\). At a minimiser, \(\lvert\eta\rvert\to 0\) along the \(\eta\)-zeros supplied by Lemma 5.5, so the denominator tends to \(1\). The comparison of \(\lvert\partial_t\eta\rvert\) with \(N^{1/2+\varepsilon}\) is Lemma 4.5.2 on the left and the same expansion with \(1-\sigma<1/2\) on the right.
