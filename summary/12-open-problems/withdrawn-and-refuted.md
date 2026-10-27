# Withdrawn and refuted statements

**Purpose.** The site has been revised heavily. This file is the authoritative list of statements that are **false**, **withdrawn**, or **superseded**, together with the correct replacement. It is compiled from the openings of [`truths.md`](truths.md), the canonical changelog, [`gaps.html`](gaps.html), [`tensor.md`](tensor.md) §8, and [`maths/`](maths/).

Do not restore any row of this table from an older draft or from an archived paper.

## A. Withdrawn internal identities

| # | Withdrawn statement | Correct statement | Source |
|---|---|---|---|
| A1 | $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$ | The integral is $-1+R\int\varphi^2$. | `truths.md` opening; Lemma 6.3 |
| A2 | The local diagonal of Section 6 is $c_1=\tfrac12$ times $\rho^2$ | The local diagonal is $D_k=-\int\frac{\varphi}{k+u}+R\int\frac{\varphi^2}{k+u}+R_{\mathrm{EM}}^{(k)}$; summed, $R(\int\varphi^2)\log R+O_\varphi(R)$, not a multiple of $R^{-1}\rho^2$. | Lemma 6.3; changelog D/D′ |
| A3 | At an off-line zero $\lvert\eta_N^{(N^2)}(\rho)\rvert\ge cN^{1/2-\varepsilon}$ on the tightness range | False if such a zero exists: Corollary 4.3.1 gives $\lvert\eta\rvert\ll(1+\lvert\gamma\rvert)N^{1-2\sigma}=o(N^{1/2-\varepsilon})$ for $\sigma>\tfrac14+\varepsilon/2$. Below that band the floor of Corollary 4.3.2 makes the inequality true, but it is not Identity L. | `truths.md` opening; `gaps.html` |
| A4 | “The diagonal is improved to $O(1)$.” | Deleted. Theorem 7.1 has diagonal $\asymp N\log N$ and remainder $O(N^3)$; Lemma 7.2 is the exact weighted identity. | Changelog E |
| A5 | The absolutely continuous measure of the old `proof.html` | Not used. Definition 8.1 is the two-component measure $\mu_N,\nu_N$ on the strip. | Changelog F |
| A6 | Tails via Bohr–Jessen / value-distribution theory | Withdrawn. Lemmas 9.2–9.6 prove tail localisation elementarily, using Jensen and the classical floor for $\zeta$. | Changelog T; Remark 9.7 |
| A7 | The differential inequality $c_1=\tfrac12$ is used for depth | Not used. Depth of closure follows from Theorem 4.1 at zeros: $\lvert\eta\rvert=O(1+\lvert\gamma\rvert)$. Section 6 is interpolation only. | Changelog D/D′; `gaps.html` |
| A8 | “Polar sign” in §4 (pre-21 August) | Corrected in the 21 August revision; the exact pair $H_{N^2}^{(s)}-N^{1-s}H_N^{(s)}$ is the object. No proof status changes. | `gaps.html` introduction |

## B. Refuted claims in the tensor programme

| # | Refuted statement | Correct statement | Source |
|---|---|---|---|
| B1 | $\langle\mathcal{P},f*\check f\rangle\ge0$ for every $f$ in the Weil cone — the defining equation $(\star)$ | False. The witness $f_0$ gives $-0.67730247811\ldots$. The negativity is produced by on-line zeros; the failure persists under RH. | `tensor.md` Theorem B |
| B2 | The kernel $K(u,v)=\mathcal{P}(u-v)$ is positive semi-definite | False. The tuple form fails already for the density part: $\Phi$ is positive but not of positive type. | `tensor.md` Proposition 5.1 |
| B3 | Positivity of $\Phi$ is enough for the $\gamma=0$ slice / the kernel form | Positivity of a function and positivity of its type are transverse. $\Phi$ is positive; $\hat\Phi=\tfrac12\Xi_{\cos}$ changes sign. Only the constant mode is solved by positivity. | `tensor.md` §5 |
| B4 | “The zeros are real because the group is $\mathbb{R}$.” | False. $\mathcal{P}$ is not tempered and has mass off $\mathbb{R}$; living on $\mathbb{R}$ does not make the spectrum a positive measure. The correct current is $\mathcal{W}$, and positivity is Weil’s criterion. | `tensor.md` Remark 3.2, Theorem C |
| B5 | If $(\star)$ fails, the Laplace picture will show poles off the line | Non sequitur. $(\star)$ fails unconditionally because of on-line zeros, with no off-line consequence. | `tensor.md` Remark 4.2 |
| B6 | $(\star)$ is equivalent to RH / replaces RH | No. $(\star)$ is false while RH is open, so they are not equivalent. The equivalent statement is Weil positivity for $\mathcal{W}$. | `tensor.md` §8 |

## C. Corrections to `truths.md`

| # | Correction | Source |
|---|---|---|
| C1 | Truth 12.3 says an off-line zero is *exactly* the vanishing of the cosine moment. It is necessary but not sufficient. The zero condition is the **joint** vanishing $K(\alpha,\gamma)=S(\alpha,\gamma)=0$. | `tensor.md` Corollary 6.2 |
| C2 | Truth 15.3’s sign law for $K(\alpha,\cdot)$ is **false for every $\alpha$**; $K$ changes sign near every simple on-line zero and infinitely often. The surviving statement is the joint non-vanishing. | `tensor.md` Proposition 6.3 |
| C3 | Truth 12.1’s constant is $c=4$ for the printed $\Phi$, i.e. $\hat\Phi=\tfrac12\Xi_{\cos}$. | `tensor.md` Lemma 2.2 |

## D. Working notes that claim a proof of RH

| # | Claim | Status |
|---|---|---|
| D1 | The continuous-cone differential inequality yields a power-saving depth bound and hence RH. | Not accepted. It rests on A1/A2. See [continuous-cone audit](summary/13-working-notes/continuous-cone.md). |
| D2 | Nested spheres plus continuous radius imply every weak-star limit is supported on critical-line zeros, hence RH. | Not accepted. It inherits D1 and claims support only on the line, which is stronger than the canonical Theorem 10.1/12.2. See [nested-spheres audit](summary/13-working-notes/nested-spheres.md). |

## E. Overclaims explicitly downgraded in the canonical paper

| # | Overclaim | Canonical position |
|---|---|---|
| E1 | The paper proves RH. | It proves a conversion: RH iff $\operatorname{supp}\mu=\operatorname{supp}\nu$ (Corollary 12.3). The abstract, conclusion, `gaps.html`, and changelog all say this is not a proof of RH. |
| E2 | Identity L places all atoms on the line. | With a fixed aperture it places simple balanced atoms in $\tfrac12-\varepsilon<\sigma\le\tfrac12+\varepsilon/2$ (Theorem 12.4). The vanishing aperture is needed for Theorem 12.6, and a right-half zero remains unrestricted. |
| E3 | The Davenport–Heilbronn transfer proves RH. | It proves the conversion is sharp and, via Corollary C.10, that no additive theorem from this toolbox can be RH. |
| E4 | The modular shadow constrains complex zeros. | No transfer. The shadow is exact at positive integer weight only (Remark D.8). |
| E5 | The straightening field computes zeros on the critical line. | Theorem E.7 computes the zero count under the Rouché condition (E.1) throughout $\sigma>\tfrac12$. No admissible contour is known to reach the line (Remark E.11). |

## The rule

If an archived page, an older revision, or a summary outside this folder contradicts a row above, the row above and its canonical source win. The only exception is a newer canonical revision that explicitly supersedes the cited statement; check the `publication.html` changelog before restoring anything.

[Back to folder README](summary/12-open-problems/README.md) · [Back to the summary index](summary/README.md)
