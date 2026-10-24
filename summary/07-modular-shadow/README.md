# 07 — The modular shadow

This folder is a finite, exact side-story. It reduces the polygon modulo a prime in the Kaneko–Zagier ring $\mathcal{A}$ and proves that the untwisted filter collapses to a Fermat-quotient congruence while the Davenport–Heilbronn twist does not. It is exact and error-free, but it lives at positive integer weight and carries **no transfer** to the complex zeros.

## The construction

- [Definition D.1 (The ring A and the modular polygon)](summary/07-modular-shadow/01-definition-d.1.md) sets up the finite multiple-zeta ring and the reduction of a periodic coefficient sequence.
- [Lemma D.2 (Vanishing of the untwisted depth-one sum)](summary/07-modular-shadow/02-lemma-d.2.md): the depth-one Euler sum vanishes identically in $\mathcal{A}$.
- [Lemma D.2.1 (Faithfulness: the kernel of the shadow is exactly the constants)](summary/07-modular-shadow/03-lemma-d.2.1.md): the modular shadow loses exactly the constant sequence, nothing else.
- [Lemma D.3 (Only the zero class reindexes)](summary/07-modular-shadow/04-lemma-d.3.md): among residue classes mod $q$, only $n\equiv0$ contributes a reindexed term.
- [Theorem D.4 (The modular polygon of the mean-zero filter)](summary/07-modular-shadow/05-theorem-d.4.md): the filter collapses exactly,
  $\sum_{n<p}c_n^{(N)}n^{-k}=-N^{1-k}H^{(k)}_{\lfloor(p-1)/N\rfloor}$ in $\mathbb{F}_p$.
- [Corollary D.5 (Weight one: Fermat quotients)](summary/07-modular-shadow/06-corollary-d.5.md) and [Corollary D.6 (Exact closure criterion at N=2, k=1)](summary/07-modular-shadow/07-corollary-d.6.md): at $k=1$ the period-two polygon closes mod $p$ iff $p$ is a Wieferich prime.
- [Theorem D.7 (No modular collapse for the twist)](summary/07-modular-shadow/08-theorem-d.7.md): the DH twist has $a_5=0$, killing the one class that reindexes; its modular values do not collapse.
- [Remark D.8](summary/07-modular-shadow/09-remark-d.8.md) and [Remark D.9](summary/07-modular-shadow/10-remark-d.9.md) state the limits: no transfer to complex zeros; rank one has no Hecke theory.

## What it proves, and what it does not

It proves that the additive filter has a clean arithmetic shadow at integer weight, and that the twist is genuinely different already at that finite level. It does **not** prove anything about the position of complex zeros: the zeros of $\zeta$ are properties of the analytic continuation, and the finite sums $\sum_{n<p}a_nn^{-k}$ do not possess that continuation. Lemma D.2.1(iii) says the shadow is an invertible relabelling, so it constrains the zeros of $\sum a_nn^{-s}$ exactly as much as the coefficients do and no more. The observed vanishing set of the DH twist is statistically indistinguishable from coincidence.

**Status.** All items are proved. The folder is an exact sideshow, not a step toward RH.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/07-modular-shadow/TOC.md)
