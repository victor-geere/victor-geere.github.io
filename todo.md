# Strengthening list for `publication.html`

Working list from the strip-measure conversion. Closed items from the 19 August merge stay in [`gaps.html`](gaps.html). The geometric theory of the measures is complete: tightness is Theorem 9.1 via Lemmas 9.2–9.6, elementarily. The Riemann hypothesis is Corollary 12.3: \(\operatorname{supp}\nu=\operatorname{supp}\mu\).

## Identity L (proved)

- [x] **L.** Lower bound on speed at simple zeros with \(\sigma\le\tfrac12-\delta\), \(\delta>\varepsilon\), on the tightness range:
  \[
  \bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta'(\rho)\rvert>N^{1/2+\varepsilon}
  \qquad\text{throughout }\lvert s-\rho\rvert\le N^{-\varepsilon}.
  \]
  Lemma 4.5.2. Balanced closures require \(\lvert\partial_t\eta\rvert\le N^{1/2+\varepsilon}\). Envelope \(\lvert\eta\rvert\ge c\,D_N\) is false in the band \(\sigma>\tfrac14+\varepsilon/2\) (Corollary 4.3.1; below it the floor of Corollary 4.3.2 makes it true) and is not this identity.

- [x] **L\(_m\).** Jet of order \(m\) at a zero of multiplicity \(m\):
  \[
  \bigl\lvert\partial_t^{m}\eta_N^{(N^2)}(s)\bigr\rvert\ge\tfrac12 N^{1-\sigma}\lvert\zeta^{(m)}(\rho)\rvert
  \]
  throughout the isolation disk (Lemma 4.5.3). Proposition 4.7.

- [x] **L\(_{\mathrm{band}}\).** Vanishing aperture \(\varepsilon_N\to 0\), \(\varepsilon_N\log N\to\infty\), with jet order \(K_N=\max\bigl(1,\lfloor\log\log(N+16)\rfloor\bigr)\): Theorem 12.6 places every balanced atom on the critical line.

## Infrastructure (closed)

- [x] **Three scales.** \(P_N\), \(F_N\), \(D_N\). Coincide (up to \(\lvert t\rvert\)) only at \(\sigma=\tfrac12\).
- [x] **Relative depth for unrestricted closures.** \(\lvert\eta(s)\rvert\le\lvert 1-N^{1-s}\rvert\,N^{-\varepsilon}\).
- [x] **Grid detects zeros.** Isolation \(\kappa=\varepsilon\), spacing \(N^{-\kappa}(\log N)^{-1}\) so the grid-miss leak falls below the relative threshold.
- [x] **Theorem 9.1 split.** Height \((\log N)^2\): trapping below, anchored Jensen count above (Lemma 9.6). The windowed form \(N^{3\varepsilon-1/2}\log N\) survives as the packing bound quoted in Lemma 4.3.3.
- [x] **Theorem 10.1 for \(\nu_N\).** Unrestricted limit atoms are zeros.
- [x] **L\(_0\), floor.** Corollary 4.3.2: \(\lvert\eta\rvert\ge\tfrac14 N^{1-2\sigma}\) on the tightness range.
- [x] **Uniformity in \(\gamma\).** Corollary 4.1.2.
- [x] **Sublevel components.** Lemma 5.5 (Rouché).
- [x] **Numerical check.** Section 13, including \(\lvert\partial_t\eta\rvert/N^{1/2+1/8}\) at \(\gamma_1\).
- [x] **North-pole chart.** Lemma 4.8: Marty speed \(\eta^{\#}\) from <a href="projection.html">projection.html</a>. Unrestricted closures require it. Left half-strip closed for both families.
- [x] **T. Closure localisation.** Closed elementarily, Lemmas 9.2–9.6. Below \((\log N)^2\): a closure forces \(\lvert\zeta\rvert\le 2N^{-\varepsilon_2}\), beneath the Titchmarsh §9.6 floor off zeros, so components are trapped in disks at zeros of \(\Xi\) with exact Rouché counts; tail \(O((\log A)^2/A)\). Above: anchoring (Definition 5.4) certifies every atom by an exact closure — a zero of \(\eta\) in its component — and Jensen caps such zeros at \(20\log N+2\) per unit box; mass \(O(1/\log N)\). No value-distribution input; the Bohr–Jessen sketch is withdrawn. Voronin universality is outrun below, outcounted above (Remark 9.7). Theorem 9.1 is unconditional.

## Dictionary (not a gap)

- **Conversion.** Corollary 12.3, after Lemma 4.8 (north-pole chart, Marty speed): the left half-strip is absent from both families. A right-half zero is unrestricted and not balanced. RH is \(\operatorname{supp}\nu=\operatorname{supp}\mu\). Pairing converts left to right. Not an unfinished lemma.
- **Last-chord product / cosine sieve.** `truths.md` §§11–14. \(H_N(s)H_N(1-s)=(N-1)^2/(4N^2)\); at zeros on the tightness window the product of residuals tends to \(1/4\); both of order one iff \(\sigma=1/2\). The remaining statement is that this occupation of any other scale does not occur for Riemann’s \(\Phi\). That statement is RH, not a further lemma of the polygon.
- **Further research.** Footnote in `publication.html` §14 and `truths.md` 13.5: non-vanishing of \(\int\Phi\cosh(\alpha u)\cos(\gamma u)\,du\) for \(\alpha\neq 0\) is not a theorem of the polygon. Location of that equation: `truths.md` §15, the Jensen tower of the moments of \(\Phi\) at \(t=0\), equivalently Li’s jet at \(\sigma=1\). Native form, without \(\xi\): `tensor.html`, positive type of the completed prime current on \(\mathbb{R}\).

## Not on the critical path

- Addendum B (Bourgain dual sums) is optional and does not touch the band.
- Section 6 is interpolation only; integer theorems do not use it.
