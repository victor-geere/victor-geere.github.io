# CCM Conjecture 1 — uniform prime-sum representation

**Programme:** Connes–Consani–Moscovici spectral triple / self-adjoint operator.
**Sources:** [`sketch.html`](../../archive/maths/rh/research/self-adjoint-operator/sketch.html); [`rh-ccm-generalised-helix-path.html`](../../archive/maths/rh/research/self-adjoint-operator/rh-ccm-generalised-helix-path.html); [`rh-helix.html`](../../archive/maths/rh/research/self-adjoint-operator/rh-helix.html).
**Status:** open. The archive calls it “the single unproven step” of that programme.

## Statement

Let $Q$ be the truncated Weil quadratic form, $\xi=(\xi_k)$ its ground-state eigenvector, and $c_j=\xi_{j-N}$ the Fourier coefficients. As $N,\lambda\to\infty$ with $L=2\log\lambda\asymp\log N$, there exist absolute constants $C,\delta>0$ such that

$$
c_j=\sum_{p\le\lambda^2}\frac{\log p}{\sqrt p}
\exp\!\Bigl(-i\frac{2\pi}{L}\Bigl(j-N+\tfrac12\Bigr)\log p\Bigr)+E_j,
\qquad |j|\le N,
$$

with

$$
\lvert E_j\rvert\ll\frac{(\log L)^C}{L^\delta}
$$

uniformly in $j$. Consequently,

$$
\log\lvert c_j\rvert
=\log\Bigl\lvert\sum_{p\le\lambda^2}\frac{\log p}{\sqrt p}
e^{-i\mu_{j-N}\log p}\Bigr\rvert+o(1)
$$

uniformly on compact subsets of the scaled index $x=j/N\in[0,1]$ away from limiting zero ordinates.

The generalised-helix version states the same with $\lvert j\rvert\le2N$ and $L\asymp\log N$.

## What it would give

If true, the ground-state eigenvector of the truncated Weil form has Fourier coefficients given by a prime sum. In the limit $\lambda\to\infty$ the spectrum of the full spectral triple is the set of Riemann zeros. This is the quantum counterpart of the classical torsion of the Riemann helix.

## Status and caution

Open. The archive itself says the proof would require a combination of prolate-wavefunction approximation, Beurling–Selberg sieve estimates, and a deep analysis of the truncated Weil explicit formula; all other steps are rigorous *assuming* the conjecture. It is not a theorem, and it is not used in the current canonical paper. The canonical programme’s `tensor.md` Theorem C reaches Weil positivity by a different route, and does not claim this eigenvector asymptotic.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
