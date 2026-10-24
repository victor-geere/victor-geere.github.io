# 08 — The straightening field

This folder changes coordinates. The ratio $\mathsf{r}_f(s)=f(s)/s$ is treated as a similitude carrying the ray through $s$ onto the ray through $f(s)$. Its punctures are the zeros of $f$, its holonomy is the zero count, and under an explicit Rouché condition that count is computable from the two finite Euler sums alone throughout $\sigma>\tfrac12$. The result is an integer-valued observable far more robust than the modulus tests.

## The field

- [Definition E.1 (Straightening ratio and straightening matrix)](01-definition-e.1.md): $\mathsf{r}_f(s)=f(s)/s$, with the twisted product $\mathsf{A}\star\mathsf{B}=s\mathsf{A}\mathsf{B}$ whose unit is the identity function.
- [Lemma E.2 (Domain, conformal group, and the twisted product)](02-lemma-e.2.md): the assignment $f\mapsto\mathsf{R}_f$ is multiplicative, so the prefactor $1-N^{1-s}$ and $\zeta$ separate exactly.
- [Lemma E.3 (The straightening potential and its branch points)](03-lemma-e.3.md): the punctures of the field are the zeros.
- [Theorem E.4 (Holonomy of the straightening field is the zero count)](04-theorem-e.4.md): the holonomy is the zero count, by the argument principle.
- [Corollary E.5 (The Riemann hypothesis as flatness of the straightening field)](05-corollary-e.5.md): RH is flatness on $\{\tfrac12<\sigma<1\}$. This is a restatement of the argument principle, with no Euler-product input.
- [Lemma E.6 (The normalised polygon has closure vector s)](06-lemma-e.6.md): the normalised polygon’s terminal vertex is $s$, making the three scales dimensionless.

## The finite-data theorem

- [Theorem E.7 (Finite-data argument principle)](07-theorem-e.7.md): under the Rouché condition
  $$(\mathrm{E.1})\qquad \lvert E\rvert<\lvert F\rvert \text{ on } \Gamma,$$
  the zero count $Z_\zeta(\Gamma)$ is computable from $H^{(s)}_{N^2}$ and $H^{(s)}_N$ alone throughout $\sigma>\tfrac12$.
- [Corollary E.8 (Finite-data form of the Riemann hypothesis)](08-corollary-e.8.md): RH holds iff every admissible contour in $\{\sigma>\tfrac12\}$ has holonomy zero.
- [Corollary E.9 (Hypothesis (M) in straightening terms)](09-corollary-e.9.md): (M) is puncture-freeness in $\sigma>1$, equivalently decomposition into local twists there. By Theorem C.12 this holds iff $g=P(s)L(s,\chi)$.
- [Remark E.10](10-remark-e.10.md) and [Remark E.11](11-remark-e.11.md): what the change of coordinates buys, and the unchanged barrier — no admissible contour reaches the critical line.

## The Davenport–Heilbronn test

Applied to the DH twist, Theorem E.7 returns holonomy $+1$ about $\rho_{\mathrm{DH}}$, certified from $N=200$ and already correct at $N=50$ where the relative amplitude error exceeds $200\%$. This is an independent confirmation of Theorem C.9 from the phase rather than the modulus. It is the practical gain of the change of coordinates: integer-valued observables tolerate far more error than the inequality (E.1) admits.

**Status.** The field identities and Theorem E.7 are proved under (E.1). Corollary E.8 is an equivalence, not a construction of a contour known to enclose a zero. Nothing in Sections 1–14 depends on Addendum E.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
