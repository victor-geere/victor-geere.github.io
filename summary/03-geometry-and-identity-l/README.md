# 03 — Path closures, jets, and Identity L

This folder is the geometric heart of the paper. It explains what a *path-closure* is, why the last chord cancels at a zero, and how the speed of that cancellation separates the critical line from the rest of the strip. It is also where the paper’s most misunderstood label, **Identity L**, lives.

## The last chord

The order-zero Euler–Maclaurin boundary term of Theorem 4.3 is

$$
H_N(s)=\tfrac12(1-N)N^{-2s}.
$$

It satisfies the exact monomial identity

$$
H_N(s)H_N(1-s)=\frac{(N-1)^2}{4N^2}\to\tfrac14
$$

for every $s$. The two factors are of order one simultaneously only when $\sigma=\tfrac12$. Off the line, one twin tends to $0$ and the other to $\infty$. This is the algebraic content behind the phrase “off-line quadruple”; the full geometric reading is in Frozen truths §§11–14.

## The items

- [Lemma 4.3.3 (Completed curve over R, tightness window)](summary/03-geometry-and-identity-l/01-lemma-4.3.3.md) and [Lemma 4.3.4 (Hilbert zoom; the envelope scale)](summary/03-geometry-and-identity-l/02-lemma-4.3.4.md) place the polygon on a completed curve and identify the scale at which the last chord is the only surviving term.
- [Lemma 4.5 (Differentiated remainder)](summary/03-geometry-and-identity-l/03-lemma-4.5.md), [Lemma 4.5.1 (Speed at critical-line zeros)](summary/03-geometry-and-identity-l/04-lemma-4.5.1.md), [Lemma 4.5.2 (Speed of last-chord cancellation)](summary/03-geometry-and-identity-l/05-lemma-4.5.2.md) and [Lemma 4.5.3 (Jet of order m)](summary/03-geometry-and-identity-l/06-lemma-4.5.3.md) differentiate the remainder in the height. They compare the main-term slope with the half-term derivative.
- [Identity L (slow passage; proved)](summary/03-geometry-and-identity-l/07-identity-l.md) is the geometric name for the lower bound of Lemma 4.5.2. It is *not* the false envelope $\lvert\eta(\rho)\rvert\ge cD_N$; the paper says so repeatedly. Identity L is a **speed** bound: at a simple zero with $\sigma\le\tfrac12-\varepsilon$, the derivative is at least $N^{1/2+\varepsilon}$ throughout the isolation disk. A balanced closure requires the opposite inequality, so such a zero cannot be balanced.
- [Proposition 4.6 (L excludes off-line simple balanced closures)](summary/03-geometry-and-identity-l/08-proposition-4.6.md) and [Proposition 4.7 (Jet excludes multiple off-line balanced closures)](summary/03-geometry-and-identity-l/09-proposition-4.7.md) turn the speed bound into exclusion statements.
- [Lemma 4.8 (North-pole lift; Marty speed)](summary/03-geometry-and-identity-l/10-lemma-4.8.md) supplies the spherical metric. Marty speed is the fibre metric under the north-pole chart; it removes the left half-strip from both families. The chart itself is documented in [`projection.html`](projection.html) and in Frozen truths 1.8–1.10.
- [Definition 5.0 (Truncated strip)](summary/03-geometry-and-identity-l/11-definition-5.0.md), [Definition 5.1 (Path-closure events)](summary/03-geometry-and-identity-l/12-definition-5.1.md), [Theorem 5.2 (Geometric DQPT criterion)](summary/03-geometry-and-identity-l/13-theorem-5.2.md), [Remark 5.3](summary/03-geometry-and-identity-l/14-remark-5.3.md), [Definition 5.4 (Relative sublevel set)](summary/03-geometry-and-identity-l/15-definition-5.4.md) and [Lemma 5.5 (Rouché localisation)](summary/03-geometry-and-identity-l/16-lemma-5.5.md) formalise the two families and localise their components at zeros of $\Xi$.

## The logical shape

The paper separates **balanced** closures $\mathcal{C}_N$ from **unrestricted** closures $\mathcal{U}_N$.

- A balanced closure is slow ($\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}$), relatively small ($\lvert\eta\rvert\le N^{1/2-\varepsilon}$), and has a prefactor at least $N^{1/2-\varepsilon/2}$. Theorem 5.2 confines it to $\sigma\le\tfrac12+\varepsilon/2$.
- A critical-line zero always produces a balanced closure once $N$ is large (Theorem 5.2 and Corollary 4.1.1).
- A simple off-line zero with $\sigma\le\tfrac12-\varepsilon$ is too fast (Identity L / Proposition 4.6); a multiple off-line zero is excluded by the jet (Proposition 4.7).
- A **right-half** zero remains an unrestricted closure but is not balanced. That asymmetry is the whole conversion: RH is the statement that $\mathcal{U}$ and $\mathcal{C}$ have the same limiting support. It is not proved here.

## What Identity L does not do

Identity L does not place every atom on the line by itself. With a fixed aperture it places simple balanced atoms in the strip $\tfrac12-\varepsilon<\sigma\le\tfrac12+\varepsilon/2$ (Theorem 12.4). Placing them exactly on the line needs a vanishing aperture and the jet of Lemma 4.5.3 (Theorem 12.6). The paper is explicit that neither statement is the Riemann hypothesis; the right-half unrestricted atom is the surviving gap.

**Status.** The lemmas and propositions in this folder are proved. Identity L is a proved speed bound, not a standalone proof of RH. The closure criteria are conditional on the definitions of balanced/unrestricted depth.

[Back to the summary index](summary/README.md) · [Folder TOC](summary/03-geometry-and-identity-l/TOC.md)
