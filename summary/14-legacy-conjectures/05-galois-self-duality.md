# Hypothesis 6.1 — Galois self-duality

**Programme:** modular tensor categories (MTC) and a categorical zeta function.
**Source:** [`mtc-dirichlet-functional-equation.html`](archive/maths/rh/research/topological-zeta/mtc-dirichlet-functional-equation.html), Hypothesis 6.1, Theorem 6.2, Open Problem 10.1.
**Status:** open in general; verified case-by-case.

## Statement

Let $\mathcal{C}$ be a weakly integral modular tensor category with twist eigenvalues $\theta_i$ and sign characters $\epsilon_\sigma$, and let $\chi=\chi_\sigma$ be a Galois character with $\sigma\in\mathrm{Gal}(K/\mathbb{Q})$. The hypothesis is:

$$
\theta_{\phi_\sigma(i)}=\overline{\theta_i},
\qquad
\epsilon_\sigma(\phi_\sigma(i))=\epsilon_\sigma(i)
$$

for all $i\in I$, where $\phi_\sigma$ is the Galois permutation of the simple objects. Equivalently, the Galois-conjugate category $\mathcal{C}^\sigma$ (with $S$-matrix $\sigma(S)$) is equivalent to the complex-conjugate category $\overline{\mathcal{C}}$.

## What it gives

Under Hypothesis 6.1, the categorical theta series satisfies a functional equation (Theorem 6.2):

$$
\Lambda_{\mathcal{C},\chi_\sigma}(s)=\varepsilon\,\Lambda_{\mathcal{C}^\sigma,\chi_\sigma^\sigma}(1-s),
\qquad \lvert\varepsilon\rvert=1.
$$

If $\mathcal{C}$ is Galois-self-dual, this is the classical self-dual form. The proof is a finite Poisson summation, using the modular invariance of the torus partition function. Hypothesis 6.1 is what allows the Galois conjugation to permute the theta terms.

## Open problem

**Open Problem 10.1.** Prove, for an arbitrary weakly integral MTC $\mathcal{C}$ and any non-trivial $\sigma\in\mathrm{Gal}(K/\mathbb{Q})$, that Hypothesis 6.1 holds. The Coste–Gannon theorem guarantees the existence of $\phi_\sigma$ and $\epsilon_\sigma$, but does not impose the compatibility condition in general. Counterexamples at rank $r\ge5$ may exist.

## Status

Hypothesis, not theorem. The functional equation is unconditional when verified directly on a finite Dirichlet polynomial; deriving it from first principles requires Hypothesis 6.1. It is not used by the canonical paper.

[Back to folder README](summary/14-legacy-conjectures/README.md) · [Back to the summary index](summary/README.md)
