# Topological realisation of ζ(s)

**Programme:** topological zeta / braided zeta function.
**Sources:** [`topological-zeta-proof-sketch.html`](archive/maths/rh/research/topological-zeta/topological-zeta-proof-sketch.html), Conjecture 1; [`path-to-rh-proof.html`](archive/maths/rh/research/topological-zeta/path-to-rh-proof.html), Conjecture 6.6 and Theorem 6.8.
**Status:** open. A conditional theorem derives RH from it plus an asymmetry lemma.

## Statement

For $s\in\mathbb{C}$ with $\operatorname{Re}s>1$ and positive integer $N$, let

$$
B_N(s)=\prod_{i=1}^{N-1}\sigma_i^{2s}\in B_N
$$

be the braid, and let $\mathrm{RT}_k$ be the Reshetikhin–Turaev invariant. Set

$$
Z_k(s)=\lim_{N\to\infty}\frac{\mathrm{RT}_k(B_N(s))}{\mathrm{RT}_k(B_N(0))}.
$$

**Conjecture.** For every sufficiently large integer $k$, $Z_k(s)$ admits an analytic continuation to $\mathbb{C}$ (except possibly a simple pole at $s=1$), and

$$
\lim_{k\to\infty}Z_k(s)=\zeta(s)
$$

uniformly on compact subsets of $\mathbb{C}\setminus\{1\}$.

## The conditional route

- **Lemma (functional equation).** For all $k,N$,
  $\mathrm{RT}_k(B_N(1-s))=\chi_k(s)\,\mathrm{RT}_k(B_N(s))$,
  where $\chi_k(s)\to2^{1-s}\pi^{-s}\sin(\pi s/2)\Gamma(s)$ as $k\to\infty$.
- **Lemma (asymmetry implies non-vanishing).** If $\operatorname{Re}s\neq\tfrac12$, then for all sufficiently large $k$ and $N\ge N_0(k)$, $\mathrm{RT}_k(B_N(s))\neq0$; moreover the normalised limit $Z_k(s)$ does not vanish.
- **Theorem (topological zeta rigidity).** Assume the conjecture and the asymmetry lemma. Then every non-trivial zero $\rho$ of $\zeta$ satisfies $\operatorname{Re}\rho=\tfrac12$.

## Status

The conjecture is open; the theorem is conditional. The archived paper presents a numerical programme and an analytic programme to close the two remaining conjectures (the convergence $Z_k\to\zeta$ and the uniform non-vanishing floor). It is not a proof of RH, and the current canonical paper does not use it.

[Back to folder README](summary/14-legacy-conjectures/README.md) · [Back to the summary index](summary/README.md)
