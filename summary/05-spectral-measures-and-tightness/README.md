# 05 — Spectral measures and the limit

This folder contains the measure-theoretic construction and the paper’s actual conclusion: the two families of path-closures are tight, every weak-star limit is pure-point and supported on zeros of $\Xi$, and the Riemann hypothesis is equivalent to the coincidence of the balanced and unrestricted supports. That equivalence is **not** a proof of the Riemann hypothesis.

## From closures to measures

- [Definition 8.1 (Finite measures on the strip)](summary/05-spectral-measures-and-tightness/01-definition-8.1.md) defines the two components: balanced $\mu_N$ and unrestricted $\nu_N$, with the tempering weight $(1+\lvert s\rvert^2)^{-1}$.
- [Lemma 9.2 (Zeros of η per unit height)](summary/05-spectral-measures-and-tightness/02-lemma-9.2.md) uses Jensen to cap the zeros of the polygon.
- [Lemma 9.3 (ζ at relative closures)](summary/05-spectral-measures-and-tightness/03-lemma-9.3.md), [Lemma 9.4 (Classical floor off the zeros)](summary/05-spectral-measures-and-tightness/04-lemma-9.4.md) and [Lemma 9.5 (Localisation, trapping, exact counts)](summary/05-spectral-measures-and-tightness/05-lemma-9.5.md) trap components at zeros of $\Xi$ below polylogarithmic height.
- [Lemma 9.6 (Tail localisation)](summary/05-spectral-measures-and-tightness/06-lemma-9.6.md) controls the atomic tail above that height. The tail is $O((\log A)^2/A)+O(1/\log N)$.
- [Theorem 9.1 (Tightness)](summary/05-spectral-measures-and-tightness/08-theorem-9.1.md) is unconditional. [Remark 9.7](summary/05-spectral-measures-and-tightness/07-remark-9.7.md) records why Voronin universality is outrun below $(\log N)^2$ and outcounted above.

## The limit

- [Theorem 10.1 (No spurious atoms)](summary/05-spectral-measures-and-tightness/09-theorem-10.1.md): every pure-point limit of the unrestricted family is supported on zeros of $\Xi$.
- [Theorem 11.1 (Residual vanishing)](summary/05-spectral-measures-and-tightness/10-theorem-11.1.md): the residual continuous spectrum vanishes along any weak-star convergent subsequence.
- [Theorem 12.1 (Balanced spectral measure)](summary/05-spectral-measures-and-tightness/11-theorem-12.1.md) and [Theorem 12.2 (Unrestricted spectral measure)](summary/05-spectral-measures-and-tightness/12-theorem-12.2.md) realise the two limits.
- [Corollary 12.3 (Conversion of the Riemann hypothesis)](summary/05-spectral-measures-and-tightness/13-corollary-12.3.md) is the central statement:

$$
\operatorname{supp}\mu=\operatorname{supp}\nu
\quad\Longleftrightarrow\quad
\text{every non-trivial zero of }\Xi\text{ lies on }\operatorname{Re}s=\tfrac12.
$$

The left-hand side is the open statement. The corollary is a conversion of RH into an equality of supports, not a proof of it. The paper says this in the abstract, the conclusion, `gaps.html`, and the changelog.

## Placing balanced atoms

- [Theorem 12.4 (Identity L places simple balanced atoms in an ε-neighbourhood)](summary/05-spectral-measures-and-tightness/14-theorem-12.4.md): with a fixed aperture, simple balanced atoms lie in $\tfrac12-\varepsilon<\sigma\le\tfrac12+\varepsilon/2$.
- [Definition 12.5 (Vanishing aperture)](summary/05-spectral-measures-and-tightness/15-definition-12.5.md) introduces $\varepsilon_N\to0$ with $\varepsilon_N\log N\to\infty$.
- [Theorem 12.6 (Balanced atoms on the line)](summary/05-spectral-measures-and-tightness/16-theorem-12.6.md): with a vanishing aperture and the jet of Lemma 4.5.3, every balanced atom lies on the critical line, of any finite multiplicity.

The right-half zero is not balanced; it remains an unrestricted atom. That is why Theorem 12.6 does not close the gap. [Further research (not a theorem)](summary/05-spectral-measures-and-tightness/17-further-research.md) states the remaining non-vanishing problem in the cosine kernel and refuses to call it a theorem.

## Status

Theorems 9.1, 10.1, 11.1, 12.1 and 12.2 are unconditional. Corollary 12.3 is an equivalence. Theorem 12.4 is unconditional for a fixed aperture. Theorem 12.6 is conditional on a vanishing aperture sequence (which is a definitional choice, not an unproved arithmetic hypothesis) but still does not prove RH. The open statement is the absence of right-half atoms of $\nu$.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/05-spectral-measures-and-tightness/TOC.md)
