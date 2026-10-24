# Torsion criterion — the Riemann helix

**Programme:** Riemann helix / variable-radius space curve.
**Sources:** [`rh6.html`](../../archive/maths/rh/research/self-adjoint-operator/rh6.html) (Conjecture 3.1, Theorem 4.1); [`rh7.html`](../../archive/maths/rh/research/self-adjoint-operator/rh7.html) (Conjecture 4.1, Theorem 5.1); [`conjecture.html`](../../archive/maths/r-helix/conjecture.html) (Theorem 4.1).
**Status:** open. The equivalence to RH is claimed; the distributional convergence is not proved.

## Statement

There exists an even mollifier $\eta\in C_c^\infty(\mathbb{R})$ such that, as $\varepsilon\to0$, the torsion $\tau[C_\varepsilon]$ of the smoothed argument curve converges in the sense of distributions to the prime-power Dirac comb:

$$
\tau[C_\varepsilon]\xrightarrow{\ \mathcal{D}\ }\tau_0,
\qquad
\tau_0(t)=\sum_{p^m}\log p\;\delta(t-m\log p).
$$

Equivalently, for every test function $\phi\in C_c^\infty(\mathbb{R})$,

$$
\lim_{\varepsilon\to0}\int_{\mathbb{R}}\tau[C_\varepsilon](t)\,\phi(t)\,dt
=\sum_{p^m}\log p\;\phi(m\log p).
$$

## The claimed equivalence

The archived theorem states:

> **Theorem.** Conjecture 3.1 holds if and only if the Riemann Hypothesis is true.

The proof expands $S_\varepsilon'$ using the explicit formula. The singular support of $\tau[C_\varepsilon]$ is the zero set; if an off-line zero exists, its smoothed jump survives in the limit and the torsion cannot equal the prime-only comb. Conversely, if all zeros are on the line, the zero jumps are symmetric and cancel in the torsion, leaving the prime distribution.

## Why it is not a proof

The equivalence is only as strong as the existence of the distributional limit. The archive assumes a mollifier exists and proves the equivalence conditionally; it does not construct one or prove the limit. The later canonical paper does not use this route. The variable-radius helix version (Theorem 4.1 of `conjecture.html`) additionally assumes that the only way the torsion can reduce to the pure Dirac comb is for the radius to be constant; that step is a differential-geometric argument, not an arithmetic one, and it does not establish the prime distribution limit independently.

## What survives

The exact torsion formula for a space curve and the distributional prime comb are well-defined. The criterion is a genuine reformulation of RH in curve geometry. It is not a proof.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
