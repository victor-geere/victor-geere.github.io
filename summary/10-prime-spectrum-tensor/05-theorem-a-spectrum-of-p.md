# Theorem A

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [`tensor.md`](tensor.md), §2–7 |

## Statement and proof

For every \(f\) in the Weil cone, with \(g=f*\check f\) and \(\hat g(z)=\hat f(z)\overline{\hat f(\bar z)}\),
\[
\bigl\langle\mathcal{P},f*\check f\bigr\rangle
=\underbrace{\bigl\lvert\hat f(i/2)\bigr\rvert^{2}}_{\text{pole of }\zeta}
\;-\;\frac12\sum_{\rho}\hat g(\gamma_\rho)
\;+\;\frac{1}{2\pi}\int_{\mathbb{R}}\bigl\lvert\hat f(t)\bigr\rvert^{2}\,W(t)\,dt,
\qquad
W:=\tfrac12\,\Xi_{\cos}+\tfrac12\,\Omega .
\]
The zero sum is real (Lemma 2.1 symmetries pair \(\gamma\) with \(-\bar\gamma\)); under the Riemann hypothesis it equals \(\sum_\rho\lvert\hat f(\gamma_\rho)\rvert^2\). For real even \(f\), \(\lvert\hat f(i/2)\rvert^2=\bigl(\int f(u)\cosh\tfrac u2\,du\bigr)^2\).

*Proof.* \(\langle\mathcal{P},g\rangle=\Pi(g)+\Theta(g)\). Halve Lemma 2.4, add Lemma 2.2, and use \(\hat g(\pm i/2)=\lvert\hat f(i/2)\rvert^2\) from Lemma 2.1. \(\square\)
