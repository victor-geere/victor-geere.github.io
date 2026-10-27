# 06 — The Davenport–Heilbronn twist: sharpness

This is the paper’s limitative centre. The same construction is run on the Davenport–Heilbronn function $f$, which has a functional equation and mean-zero periodic coefficients but **no Euler product**. The framework transfers verbatim and reports a false Riemann hypothesis at Spira’s off-line zero. Therefore the conversion is sharp, and no theorem provable from the additive toolbox alone can be the Riemann hypothesis.

## The transfer

- [Definition C.1 (Level-q depth-one Euler sums)](summary/06-davenport-heilbronn/01-definition-c.1.md) and [Lemma C.2 (Every mean-zero periodic polygon is a level-q Euler-sum combination)](summary/06-davenport-heilbronn/02-lemma-c.2.md) place both $\zeta$ and $f$ in one additive basis.
- [Definition C.3 (Davenport–Heilbronn coefficients)](summary/06-davenport-heilbronn/03-definition-c.3.md) and [Lemma C.4 (Self-duality; what f has and lacks)](summary/06-davenport-heilbronn/04-lemma-c.4.md) record the functional equation and the absence of an Euler product.
- [Definition C.5 (The twisted Euler-sum pair)](summary/06-davenport-heilbronn/05-definition-c.5.md) and [Lemma C.6 (Exact filter form)](summary/06-davenport-heilbronn/06-lemma-c.6.md) build the twisted polygon.
- [Theorem C.7 (Theorem 4.3 for the twist)](summary/06-davenport-heilbronn/07-theorem-c.7.md) transfers the remainder; [Theorem C.8 (Transfer)](summary/06-davenport-heilbronn/08-theorem-c.8.md) transfers Sections 5 and 8–12; [Theorem C.9 (The conversion is sharp)](summary/06-davenport-heilbronn/09-theorem-c.9.md) shows that at $\rho_{\mathrm{DH}}=0.80851718\ldots+85.69934849\ldots i$ the relative test fires and the prefactor test fails, so
  $\operatorname{supp}\mu^{\mathrm{DH}}\subsetneq\operatorname{supp}\nu^{\mathrm{DH}}$.

## The consequence

- [Corollary C.10 (Limitative consequence)](summary/06-davenport-heilbronn/10-corollary-c.10.md): without an extra multiplicative hypothesis, no theorem from this toolbox can be RH.
- [Theorem C.12 (Saias–Weingartner dichotomy)](summary/06-davenport-heilbronn/12-theorem-c.12.md), [Corollary C.13](summary/06-davenport-heilbronn/13-corollary-c.13.md) and [Corollary C.14 (Under (M) the obstruction lapses)](summary/06-davenport-heilbronn/14-corollary-c.14.md): among periodic Dirichlet series, non-vanishing in $\sigma>1$ characterises $P(s)L(s,\chi)$. Adjoining the hypothesis

  > **(M)** the limit function has no zeros in $\sigma>1$

  excludes the Davenport–Heilbronn twist and makes the conversion read as GRH for one $L$-function.
- [Remark C.15 (The honest position, in three statements)](summary/06-davenport-heilbronn/15-remark-c.15.md) is the necessary caveat: (M) removes the *obstruction*, it does not prove RH. Multiplicativity is known to reach only within $o(1)$ of $\sigma=1$; the conversion needs $\sigma=\tfrac12$. The gap between them is the whole critical strip.
- [Remark C.11 (Additive basis, multiplicative question)](summary/06-davenport-heilbronn/11-remark-c.11.md) explains why the missing input is not another estimate.

## Why this matters for the summary

This folder is the reason the site should not be read as claiming a proof of RH. The paper proves that its own toolbox cannot prove RH, and identifies precisely what is missing: an arithmetic positivity / multiplicativity input that fails for a sum of two Euler products. The same diagnosis recurs in the tensor folder, the straightening folder, and the quantum placements.

**Status.** C.2, C.4, C.6, C.7, C.8, C.9 and C.10 are proved (C.10 as a limitative consequence). C.12 is cited from Saias–Weingartner. C.14 is proved under (M). (M) itself is not proved.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/06-davenport-heilbronn/TOC.md)
