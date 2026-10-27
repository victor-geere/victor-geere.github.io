# Greedy sign sequence conjecture

**Programme:** harmonic sine / greedy eta series.
**Source:** [`sine-harmonic-zeta-v2.html`](../../archive/maths/rh/research/greedy-harmonic-zeta/sine-harmonic-zeta-v2.html), Conjecture 3.1.
**Status:** open. The statement itself is partly conditional on RH.

## Statement

Let $t>0$. The following are equivalent:

1. $\eta(\tfrac12+it)=0$, i.e. $t$ is the imaginary part of a non-trivial zero of $\zeta$ (assuming the Riemann hypothesis).
2. The greedy sign sequence satisfies $\sigma_n(t)=(-1)^{n-1}$ for every $n\ge1$.

In words: the alternating signs are the greedy choices for the origin exactly at the zeros of the eta function (and hence at the zeros of $\zeta$ on the critical line). Equivalently, the Dirichlet eta series is the greedy representation of zero.

The sign sequence is defined by

$$
\sigma_n(t)=-\operatorname{sgn}\Bigl(\operatorname{Re}\bigl(\overline{S_{n-1}}\,w_n(t)\bigr)\Bigr),
$$

where $S_{n-1}$ is the current partial sum and $w_n(t)=n^{-1/2-it}$.

## Status

Open. The parenthetical “assuming the Riemann hypothesis” makes the first clause conditional, so the conjecture is not by itself a route to RH. The archived programme uses it as a structural characterisation of zeros on the line. It is not used by the canonical paper.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
