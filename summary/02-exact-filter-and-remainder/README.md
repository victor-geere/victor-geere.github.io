# 02 — The exact filter and the quadratic remainder

This is the quantitative engine of the paper. It proves that at the quadratic link $M=N^2$ the polygon is the elementary factor $(1-N^{1-s})$ times $\zeta$ plus an explicit Euler–Maclaurin remainder, uniform in the height. Every later depth, closure and tightness statement is a consequence of this comparison.

## The spine

1. [Lemma 2.2 (Purification identity)](summary/02-exact-filter-and-remainder/01-lemma-2.2.md) — the exact identity $\sum_m c_m^{(N)}m^{-s}=(1-N^{1-s})\zeta(s)$ for $\operatorname{Re}s>1$, continued meromorphically.
2. [Lemma 3.2 (Filter form and the polygonal path)](summary/02-exact-filter-and-remainder/02-lemma-3.2.md) — the same object as a path, and the identification of the quadratic link.
3. [Proposition 4.2 (Geometric distinction of the quadratic link)](summary/02-exact-filter-and-remainder/03-proposition-4.2.md) — among truncations $M=N^\alpha$, only $\alpha=2$ cancels the polar terms while leaving the prefactor of size $N^{1/2}$ on the critical line.
4. [Theorem 4.1 (Explicit remainder)](summary/02-exact-filter-and-remainder/04-theorem-4.1.md) — on the critical line,
   $\eta_N^{(N^2)}(\tfrac12+it)=(1-N^{1/2-it})\zeta(\tfrac12+it)+O(1+\lvert t\rvert)$.
5. [Theorem 4.3 (Remainder in the strip)](summary/02-exact-filter-and-remainder/07-theorem-4.3.md) — the same comparison throughout a closed substrip, with the explicit half-term and error $O((1+\lvert s\rvert)N^{1-2\sigma})$.

The corollaries split the two uses of the remainder:

- **Depth at zeros.** [Corollary 4.1.1](summary/02-exact-filter-and-remainder/05-corollary-4.1.1.md) and [Corollary 4.1.2](summary/02-exact-filter-and-remainder/06-corollary-4.1.2.md) turn the critical-line bound into a per-zero threshold $N_0(\gamma)$ and a uniform threshold $N_0(T)$.
- **Floor off the line.** [Corollary 4.3.1](summary/02-exact-filter-and-remainder/09-corollary-4.3.1.md) gives the upper bound at an off-line zero; [Corollary 4.3.2](summary/02-exact-filter-and-remainder/10-corollary-4.3.2.md) gives the matching lower bound on the tightness window, showing that a zero with $\sigma\le\tfrac14-\varepsilon/2$ cannot be a path-closure of depth $N^{1/2-\varepsilon}$.

## What the remainder actually says

The pole at $s=1$ cancels because $(N^2)^{1-s}=N^{1-s}\cdot N^{1-s}$. The Euler–Maclaurin boundary term leaves the unmatched last chord

$$
H_N(s)=\tfrac12(1-N)N^{-2s},
$$

whose size is $\tfrac12(N-1)N^{-2\sigma}$. That chord is not an error to be hidden; it is the geometric object analysed in [folder 03](summary/03-geometry-and-identity-l/README.md). The three scales of [Definition 4.4](summary/02-exact-filter-and-remainder/11-definition-4.4.md) — prefactor $P_N$, remainder $F_N$, depth $D_N$ — coincide only at $\sigma=\tfrac12$.

## The optional refinement

[Refined remainder (Addendum B)](summary/02-exact-filter-and-remainder/12-refined-remainder.md) records a stronger asymptotic conditional on Bourgain's subconvexity and a van der Corput estimate. It is explicitly *not* required for Theorems 9.1–12.2. The separate file [`publication-addendum-A.html`](publication-addendum-A.html) gives a more detailed stationary-phase proof of a related refinement; it is indexed in [folder 12](summary/12-open-problems/README.md) as a conditional companion, not as part of the main chain.

## Status

The items in this folder are proved from Euler–Maclaurin and classical estimates. The only conditional item is the optional refined remainder. No item here proves the Riemann hypothesis: Theorem 4.1 is an asymptotic comparison, and Corollary 12.3 in [folder 05](summary/05-spectral-measures-and-tightness/README.md) is the conversion, not the conclusion.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/02-exact-filter-and-remainder/TOC.md)
