# GDST equivalence and claimed proof

**Programme:** Greedy Dirichlet Sub-Sum Transform (GDST).
**Source:** [`proof.html`](../../archive/maths/rh/research/gdst/archive/proof.html), Theorem 1.3 and the claimed proof.
**Status:** archived claim. Not accepted by the canonical paper; no independent verification recorded here.

## The equivalence

Let $\theta\in[0,\pi]$, $x=\theta/\pi$, and define greedy digits $\delta_n(\theta)\in\{0,1\}$ by

$$
r_{-1}=x,\qquad
\delta_n=\begin{cases}1,&r_{n-1}\ge\dfrac{1}{n+2},\\0,&\text{otherwise},\end{cases}
\qquad
r_n=r_{n-1}-\frac{\delta_n}{n+2}.
$$

The selected series is

$$
E(\theta,s)=\sum_{n=0}^\infty\frac{\delta_n(\theta)}{(n+2)^s},\qquad \operatorname{Re}s>0.
$$

**Theorem 1.3 (RH equivalence).** All non-trivial zeros of $\zeta$ lie on $\operatorname{Re}s=\tfrac12$ if and only if for every $s$ with $0<\operatorname{Re}s<1$, $\operatorname{Re}s\neq\tfrac12$, and every $\theta\in[0,\pi]$,

$$
\operatorname{Re}E(\theta,s)\neq-\tfrac12.
$$

## The claimed proof

The archived paper reduces the condition to a finite exhaustive check over a linear number of prefixes of the greedy tree, with a uniform tail bound, and reports a deterministic interval-arithmetic verification over a dense cover of the critical strip. It concludes that the exclusion holds and therefore RH is true.

## Status

Archived claim. The reduction is precise, but the finite verification is not independently reproduced in this repository, and the current canonical paper does not use the GDST route. The canonical paper’s own limitative result (Corollary C.10) says no theorem from its additive toolbox can be RH; the GDST is a different additive construction, so that result does not automatically refute it, but neither does it supply independent confirmation. Treat the claim as unverified.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
