# Lemma 2.2 (the archimedean transform)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [`tensor.md`](tensor.md), §2–7 |

## Statement and proof

\(\hat\Phi(t)=\tfrac12\,\Xi_{\cos}(t)\); equivalently the constant in truths.md 12.1 is \(c=4\):
\(\Xi_{\cos}(t)=4\int_0^\infty\Phi(u)\cos(tu)\,du\). Consequently, for every \(g\) in the cone,
\[
\Theta(g)=\frac{1}{4\pi}\int_{\mathbb{R}}\Xi_{\cos}(t)\,\hat g(t)\,dt .
\]

*Proof.* Riemann's integral representation (Riemann 1859; Edwards §1.8; Titchmarsh §10.1) is
\(\xi(s)=4\int_1^\infty \frac{d}{dx}\bigl[x^{3/2}\psi'(x)\bigr]\,x^{-1/4}\cosh\bigl(\tfrac12(s-\tfrac12)\log x\bigr)dx\) with \(\psi(x)=\sum_{n\ge1}e^{-\pi n^2x}\). Since
\(\frac{d}{dx}\bigl[x^{3/2}\psi'(x)\bigr]=\sum_{n\ge1}\bigl(\pi^2n^4x^{3/2}-\tfrac{3\pi}{2}n^2x^{1/2}\bigr)e^{-\pi n^2x}\),
the substitution \(x=e^{2u}\), \(s=\tfrac12+it\) gives
\(\Xi_{\cos}(t)=8\int_0^\infty\sum_n\bigl(\pi^2n^4e^{9u/2}-\tfrac{3\pi}{2}n^2e^{5u/2}\bigr)e^{-\pi n^2e^{2u}}\cos(tu)\,du=4\int_0^\infty\Phi(u)\cos(tu)\,du\)
for exactly the \(\Phi\) of 12.1. (Numerical confirmation: \(\hat\Phi(t)/\Xi_{\cos}(t)=0.5\) to 25 digits at \(t=0,3,15\); Appendix.) The Parseval identity is Fubini: \(\Phi\in L^1\) with doubly-exponential decay, \(\hat g\in L^1\), \(g\) continuous, so
\(\int\Phi g=\frac1{2\pi}\int\hat\Phi(t)\hat g(t)\,dt\), both transforms being even. \(\square\)
