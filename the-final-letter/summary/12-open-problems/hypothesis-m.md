# Hypothesis (M): the multiplicative input

**Source:** [`publication.html`](../../geometric-dynamical-phase-transitions/publication.html) §C.4, Addendum C; [`gaps.html`](../../geometric-dynamical-phase-transitions/gaps.html), “The remaining gap, collapsed”; [`todo.md`](../../geometric-dynamical-phase-transitions/todo.md).

## Statement

> **(M)** The limit function $g$ has no zeros in $\sigma>1$.

For the paper’s limit $g(s)=(1-N^{1-s})\zeta(s)$, (M) is true by the Euler product. For the Davenport–Heilbronn function $f=bL(s,\chi)+\overline bL(s,\overline\chi)$, (M) is false: $f$ has zeros in $\sigma>1$. That is the whole point of the hypothesis.

## Why this is the right separator

Addendum C places both $\zeta$ and $f$ in the same additive basis of level-$q$ depth-one Euler sums twisted by additive characters. Every estimate in Sections 4–12 transfers verbatim to $f$ (Theorems C.7 and C.8). At Spira’s off-line zero $\rho_{\mathrm{DH}}=0.80851718\ldots+85.69934849\ldots i$ the framework correctly reports a false Riemann hypothesis (Theorem C.9). Hence:

> **Corollary C.10.** No theorem provable from the additive toolbox used in Sections 4–12 can be the Riemann hypothesis.

The missing input must therefore be a statement that **fails** for $f$. The cleanest such statement is (M). By the Saias–Weingartner theorem (Theorem C.12), among Dirichlet series with periodic coefficients, non-vanishing in $\sigma>1$ characterises exactly

$$
P(s)L(s,\chi),
$$

one Euler product times an elementary factor. The paper’s limit is of that form; the DH twist is a sum of two Euler products and is not.

## What (M) buys

Under (M), the litmus of Corollary C.10 is excluded: the twist violates (M), so it is not an admissible counterexample. The limitative result lapses (Corollary C.14), and the conversion of Corollary 12.3 reads:

$$
\operatorname{supp}\mu=\operatorname{supp}\nu
\quad\Longleftrightarrow\quad
\text{every non-trivial zero of }L(s,\chi)\text{ in }S_\delta
\text{ lies on }\operatorname{Re}s=\tfrac12.
$$

For principal $\chi$ this is RH; in general it is GRH for one $L$-function.

## What (M) does not buy

It does **not** prove RH. The shortfall is the whole critical strip:

- Non-vanishing in $\sigma>1$ is free from the Euler product.
- Its classical refinements — de la Vallée Poussin’s $\beta\le1-c/\log\lvert\gamma\rvert$, and the Vinogradov–Korobov sharpening — move the zero-free half-plane only to within $o(1)$ of $\sigma=1$.
- The conversion needs $\sigma=\tfrac12$.

Remark C.15 states the position in three sentences: (i) without (M), the framework cannot prove RH; (ii) with (M), it is not obstructed but still does not prove RH; (iii) the gap between what multiplicativity delivers and what the conversion consumes is the critical strip.

## In straightening coordinates

Corollary E.9 restates (M): the straightening field $\mathsf{R}_g$ is puncture-free in $\sigma>1$, equivalently $g$ admits a decomposition into local twists there. By Theorem C.12 this holds iff $g=P(s)L(s,\chi)$. The DH function is a sum of two similitudes, not a product; local factorisation fails and the field is punctured in $\sigma>1$.

## Status

(M) is an explicit hypothesis, not a theorem. It is the sharpest known description of the missing arithmetic input. Adopting it changes the limitative result into a conditional GRH conversion; it does not close the strip.

[Back to folder README](README.md) · [Back to the summary index](../README.md)
