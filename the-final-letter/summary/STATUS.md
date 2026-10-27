# Status ledger

A single-page view of the programme’s proof status. The folder READMEs give the arguments; this file gives the verdicts and the links.

## 1. The headline

**The Riemann hypothesis is not proved on this site.** The canonical paper proves a conversion theorem: RH is equivalent to the equality of the supports of two measure families (Corollary 12.3). It also proves that its own additive toolbox cannot prove RH (Corollary C.10), by transferring the construction to the Davenport–Heilbronn function and correctly reporting a false RH there. The remaining gap is the absence of a right-half atom of the unrestricted measure, equivalently the joint non-vanishing of $K=\tfrac14\operatorname{Re}\xi$ and $S=\tfrac14\operatorname{Im}\xi$.

Two working notes under `maths/` claim a proof. They depend on an identity the canonical paper records as false. See §7.

## 2. Unconditional core

| Result | What it says | Where |
|---|---|---|
| Lemma 2.2 | Exact identity $\sum_m c_m^{(N)}m^{-s}=(1-N^{1-s})\zeta(s)$. | [01](01-foundations/README.md) / [02](02-exact-filter-and-remainder/01-lemma-2.2.md) |
| Lemma 3.2 | Filter form and polygonal path; quadratic link. | [02](02-exact-filter-and-remainder/02-lemma-3.2.md) |
| Proposition 4.2 | Only $M=N^2$ cancels polar terms while keeping prefactor $N^{1/2}$. | [02](02-exact-filter-and-remainder/03-proposition-4.2.md) |
| Theorem 4.1 | Critical-line remainder $O(1+\lvert t\rvert)$. | [02](02-exact-filter-and-remainder/04-theorem-4.1.md) |
| Theorem 4.3 | Strip remainder with explicit half-term. | [02](02-exact-filter-and-remainder/07-theorem-4.3.md) |
| Corollary 4.1.1 / 4.1.2 | Per-zero and uniform depth thresholds. | [02](02-exact-filter-and-remainder/05-corollary-4.1.1.md) |
| Corollary 4.3.1 / 4.3.2 | Off-line upper bound; floor on the tightness window. | [02](02-exact-filter-and-remainder/09-corollary-4.3.1.md) |
| Lemma 4.5.2 / Identity L | Speed of last-chord cancellation at a simple off-line zero. | [03](03-geometry-and-identity-l/05-lemma-4.5.2.md) |
| Lemma 4.5.3 | Jet of order $m$ at a multiple zero. | [03](03-geometry-and-identity-l/06-lemma-4.5.3.md) |
| Proposition 4.6 / 4.7 | Identity L and the jet exclude off-line balanced closures. | [03](03-geometry-and-identity-l/08-proposition-4.6.md) |
| Lemma 4.8 | North-pole lift; Marty speed removes the left half-strip. | [03](03-geometry-and-identity-l/10-lemma-4.8.md) |
| Theorem 5.2 | Balanced closures confined to $\sigma\le\tfrac12+\varepsilon/2$; critical-line zeros produce them. | [03](03-geometry-and-identity-l/13-theorem-5.2.md) |
| Lemma 5.5 | Rouché localisation of components. | [03](03-geometry-and-identity-l/16-lemma-5.5.md) |
| Lemma 6.1 / 6.3 | C¹ interpolation; the correct local diagonal (not $c_1=\tfrac12$). | [04](04-continuous-radius-and-mean-values/03-lemma-6.3.md) |
| Theorem 7.1 / Lemma 7.2 / 7.3 | Montgomery–Vaughan; exact weighted mean; pointwise from local means. | [04](04-continuous-radius-and-mean-values/README.md) |
| Theorem 9.1 | Tightness, unconditional. | [05](05-spectral-measures-and-tightness/08-theorem-9.1.md) |
| Theorem 10.1 | No spurious atoms; limits supported on zeros of $\Xi$. | [05](05-spectral-measures-and-tightness/09-theorem-10.1.md) |
| Theorem 11.1 | Residual continuous spectrum vanishes. | [05](05-spectral-measures-and-tightness/10-theorem-11.1.md) |
| Theorem 12.1 / 12.2 | Balanced and unrestricted limiting measures. | [05](05-spectral-measures-and-tightness/README.md) |
| Theorem C.9 | Davenport–Heilbronn conversion is sharp at Spira’s zero. | [06](06-davenport-heilbronn/09-theorem-c.9.md) |
| Corollary C.10 | No additive theorem from this toolbox can be RH. | [06](06-davenport-heilbronn/10-corollary-c.10.md) |
| Addendum D | Modular shadow exact at integer weight; no transfer to complex zeros. | [07](07-modular-shadow/README.md) |
| Addendum E | Straightening identities; holonomy is the zero count; finite-data theorem under (E.1). | [08](08-straightening-field/README.md) |

## 3. Proved equivalences (not proofs of RH)

| Equivalence | Statement | Where |
|---|---|---|
| Corollary 12.3 | $\operatorname{supp}\mu=\operatorname{supp}\nu$ iff RH. | [05](05-spectral-measures-and-tightness/13-corollary-12.3.md) |
| Corollary E.5 | RH iff the straightening field is flat on $\{\tfrac12<\sigma<1\}$. | [08](08-straightening-field/05-corollary-e.5.md) |
| Corollary E.8 | Finite-data holonomy form of RH. | [08](08-straightening-field/08-corollary-e.8.md) |
| Theorem C (`tensor.md`) | Weil positivity for $\mathcal{W}$ iff RH. | [10](10-prime-spectrum-tensor/17-theorem-c-weil-criterion.md) |
| Frozen truths 12.6 | Seven classical equivalences. | [11](11-frozen-truths/12-first-principles-of-the-cosine-kernel.md) |

## 4. Conditional

| Result | Hypothesis | Where |
|---|---|---|
| Refined Theorem 4.1 (Addendum A) | Bourgain subconvexity constant fixed; van der Corput; stationary phase order 2. | [12](12-open-problems/addendum-a-refined-theorem.md) |
| Refined remainder (Addendum B) | Bourgain $13/84$ + explicit constant. | [02](02-exact-filter-and-remainder/12-refined-remainder.md) |
| Corollary C.14 | Hypothesis (M): no zeros in $\sigma>1$. | [06](06-davenport-heilbronn/14-corollary-c.14.md) |
| Corollary E.9 | (M) as puncture-freeness. | [08](08-straightening-field/09-corollary-e.9.md) |
| Theorem E.7 | Rouché condition (E.1). | [08](08-straightening-field/07-theorem-e.7.md) |
| Theorem 12.6 | Vanishing aperture $\varepsilon_N\to0$, $\varepsilon_N\log N\to\infty$; jet order. | [05](05-spectral-measures-and-tightness/16-theorem-12.6.md) |
| Corollary F.9 | Bourgain $13/84$ for $\varepsilon>13/194$. | [09](09-quantum-placements/09-corollary-f.9.md) |
| Uniform slow passage | $\lvert\zeta'(\rho)\rvert\le N^\varepsilon$ on the window. | [12](12-open-problems/open-items.md) |

## 5. Open

| Open statement | Equivalent form | Where |
|---|---|---|
| No right-half atom of $\nu$ | $\operatorname{supp}\mu=\operatorname{supp}\nu$ | [05](05-spectral-measures-and-tightness/13-corollary-12.3.md) |
| Joint non-vanishing $K=S=0$ has no $\alpha\neq0$ solution | RH | [12](12-open-problems/remaining-gap.md) |
| Hypothesis (M) | No zeros in $\sigma>1$; characterises $P(s)L(s,\chi)$ | [12](12-open-problems/hypothesis-m.md) |
| F.4 Lee–Yang for the polygon | Ferromagnetic confinement of every finite zero | [09](09-quantum-placements/05-open-item-f.4.md) |
| $\Lambda=0$ | de Bruijn–Newman; $0\le\Lambda\le0.22$ | [12](12-open-problems/remaining-gap.md) |
| Uniform slow passage | GUE/HKO prediction | [12](12-open-problems/open-items.md) |
| A contour reaching the critical line | Remark E.11 | [08](08-straightening-field/11-remark-e.11.md) |

## 6. Refuted or withdrawn

| Statement | Status | Correction | Where |
|---|---|---|---|
| $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$ | False | $-1+R\int\varphi^2$ | [12](12-open-problems/withdrawn-and-refuted.md) |
| Local diagonal $c_1=\tfrac12$ | False | Lemma 6.3 diagonal, not a multiple of $R^{-1}\rho^2$ | [04](04-continuous-radius-and-mean-values/03-lemma-6.3.md) |
| Envelope $\lvert\eta(\rho)\rvert\ge cD_N$ on the band | False | Opposite bound from Corollary 4.3.1 | [12](12-open-problems/withdrawn-and-refuted.md) |
| Tensor inequality $(\star)\ge0$ | False | Witness $-0.6773$; repair is Weil current $\mathcal{W}$ | [10](10-prime-spectrum-tensor/08-theorem-b-star-is-false.md) |
| $\Phi$ is of positive type | False | $\hat\Phi=\tfrac12\Xi_{\cos}$ changes sign | [10](10-prime-spectrum-tensor/12-proposition-5.1-phi-not-positive-type.md) |
| $K(\alpha,\cdot)$ sign law | False for every $\alpha$ | Joint $K=S=0$ | [10](10-prime-spectrum-tensor/15-proposition-6.3-sign-law-false.md) |
| “Exactly the cosine moment vanishes” | Necessary, not sufficient | Joint vanishing | [11](11-frozen-truths/README.md) |
| Diagonal improved to $O(1)$ | Deleted | $N\log N$ diagonal, $O(N^3)$ remainder | [12](12-open-problems/withdrawn-and-refuted.md) |
| Differential inequality used for depth | Not used | Depth from Theorem 4.1 at zeros | [12](12-open-problems/withdrawn-and-refuted.md) |

## 7. Working notes and archived claims

| Claim | Status | Why |
|---|---|---|
| Continuous-cone note proves RH | Not accepted | Rests on $c_1=\tfrac12$; differential inequality not used by the canonical paper. | [13](13-working-notes/continuous-cone.md) |
| Nested-spheres note proves RH | Not accepted | Inherits the same bound; claims support only on the line, stronger than Theorem 10.1/12.2. | [13](13-working-notes/nested-spheres.md) |
| GDST proof | Archived claim; unverified | Finite interval check not independently reproduced here. | [14](14-legacy-conjectures/10-gdst-claimed-proof.md) |
| Harmonic-sine proof | Archived claim; superseded | Replaced by the finite Euler-sum pair and conversion theorem. | [14](14-legacy-conjectures/11-harmonic-sine-claimed-proof.md) |
| GHF/proof-99 proof | Archived claim; source says unverified | Pending peer review and verification of the Mayer–Ruelle construction. | [14](14-legacy-conjectures/12-ghf-claimed-proof.md) |

## 8. What would change the headline

A proof of any of the following would close the programme as stated:

- the joint non-vanishing of $K$ and $S$ for $\alpha\neq0$;
- the absence of a right-half atom of $\nu$;
- Weil positivity for the current $\mathcal{W}$ on the cone;
- a Lee–Yang/confinement theorem for $\eta_N^{(N^2)}$ that passes the DH litmus;
- $\Lambda=0$ in the de Bruijn–Newman flow.

Conversely, a counterexample to any of the unconditional core results would invalidate the conversion; none is known.

[Master README](README.md) · [Master TOC](TABLE-OF-CONTENTS.md) · [Glossary](GLOSSARY.md)
