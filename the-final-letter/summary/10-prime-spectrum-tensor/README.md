# 10 — The prime-spectrum tensor

`tensor.html` proposes a pairing on $\mathbb{R}$ that was hoped to replace the Riemann hypothesis by a positivity statement about a current $\mathcal{P}=\Pi+\Theta$. `tensor.md` resolves the proposal: the exact spectral resolution is computed, the proposed inequality $(\star)$ is **refuted**, and the correct positivity statement is identified as Weil’s criterion for a different current $\mathcal{W}$.

This folder harvests the whole companion, including the numerical verification.

## The result in one paragraph

For $f$ in the Weil cone and $g=f*\check f$, the pairing $\langle\mathcal{P},g\rangle$ has a signed Fourier resolution: a non-negative mass at the two non-real frequencies $\pm i/2$ (the pole of $\zeta$), a **negative atom of weight $\tfrac12$ at every zero frequency**, and a smooth density $W=\tfrac12\Xi_{\cos}+\tfrac12\Omega$ that is negative near the origin. Consequently:

- **Theorem A** computes the pairing exactly.
- **Theorem B** gives an explicit even test function $f_0$ with $\langle\mathcal{P},f_0*\check f_0\rangle=-0.67730247811\ldots<0$. The inequality $(\star)$ is false, unconditionally, and remains false under RH. The negativity is produced by the *on-line* zeros.
- **Proposition 5.1** shows the kernel form fails for a shallower reason: $\Phi$ is positive but not of positive type.
- **Theorem C** repairs the statement: replace $\mathcal{P}$ by the Weil current $\mathcal{W}$ (prime term with the opposite sign, digamma density, pole modes carried). Then $\langle\mathcal{W},g\rangle=\sum_\rho\hat g(\gamma_\rho)$ unconditionally, positivity is RH, and the equivalence is Weil’s classical criterion.

## Reading order

1. [The defining equation (★)](00-the-defining-equation.md) — what was proposed and why it fails.
2. [Lemma 2.1](01-lemma-2.1-the-square.md) to [Lemma 2.4](04-lemma-2.4-explicit-formula-even.md) — the four lemmas: the square, the archimedean transform, the prime current as a line integral, and the even explicit formula.
3. [Theorem A](05-theorem-a-spectrum-of-p.md) and [Corollary 3.1](06-corollary-3.1-signed-spectrum.md) — the exact signed spectrum.
4. [Theorem B](08-theorem-b-star-is-false.md) — the refutation, with the numerical table.
5. [Proposition 5.1](12-proposition-5.1-phi-not-positive-type.md) — the kernel form fails.
6. [Proposition 6.1](13-proposition-6.1-closed-form.md), [Corollary 6.2](14-corollary-6.2-joint-vanishing.md) and [Proposition 6.3](15-proposition-6.3-sign-law-false.md) — the tilted moments are $\xi$; the truths corrections.
7. [Definition 7.1](16-definition-7.1-weil-current.md), [Theorem C](17-theorem-c-weil-criterion.md), [Corollary 7.2](18-corollary-7.2-repaired-section-4.md) — the repair and the equivalence.
8. [Status ledger](20-status-ledger.md) and [numerical appendix](21-numerical-appendix.md).

## What this changes

The tensor was intended as a redefinition of RH on $\mathbb{R}$. It is not: $(\star)$ is false in every world, so it cannot be equivalent to RH. The statement that *is* equivalent is Weil positivity for $\mathcal{W}$. The replacement is classical, not new. The value of the companion is that it proves the dead end is dead, and locates the surviving statement precisely.

Two corrections to `truths.md` come from this folder and should be read with it:

- The cosine moment $K(\alpha,\gamma)$ alone is not the zero condition; $K=S=0$ jointly is.
- The sign law for $K(\alpha,\cdot)$ is false for every $\alpha$.

**Status.** Lemmas 2.1–2.4, Theorems A, B, C, Propositions 5.1, 6.1, 6.3 and Corollaries 3.1, 6.2, 7.2 are proved (Theorem C is the classical Weil criterion, with a proof sketch). The numerical checks are at 25 significant digits with residuals below $10^{-23}$. Nothing here proves or disproves RH.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
