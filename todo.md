# Strengthening list for `publication.html`

Working list from the strip-measure conversion. Closed items from the 19 August merge stay in [`gaps.html`](gaps.html). The identity that would change the status of the paper is **L**.

## Identity that would prove RH in this language

- [ ] **L.** Lower bound at off-line zeros, on the tightness range:
  \[
  \bigl\lvert\eta_N^{(N^2)}(\sigma+i\gamma)\bigr\rvert\ge c\,N^{1/2-\varepsilon}
  \qquad\text{whenever }\lvert\sigma-\tfrac12\rvert\ge\delta,\quad \lvert\gamma\rvert\le N^{1/2-\varepsilon}.
  \]
  Geometrically: non-degeneracy of the Hilbert zoom (Lemma 4.3.4) — nested curves, granularity \(N^{-1}\), tightness window as unit interval, rescaling by \(D_N\). The fractal *limits* L to that scale and window. Analytically still open: Corollary 4.3.1 gives \(\lvert\eta\rvert\ll(1+\lvert\gamma\rvert)N^{1-2\sigma}=o(D_N)\) in the band, so Euler–Maclaurin predicts collapse of the same zoom at off-line zeros.

## Infrastructure for that comparison

These make L a checkable statement against a well-defined family of closures, rather than against a construction that already misses off-line zeros or floods the right half-strip.

- [x] **Three scales.** Name the main-term scale \(\lvert 1-N^{1-s}\rvert\asymp N^{1-\sigma}\), the Euler–Maclaurin floor \((1+\lvert t\rvert)N^{1-2\sigma}\), and the DQPT depth \(N^{1/2-\varepsilon}\). They coincide (up to \(\lvert t\rvert\)) only at \(\sigma=\tfrac12\).
- [x] **Relative depth for unrestricted closures.** Replace \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\) off the line by \(\lvert\eta(s)\rvert\le\lvert 1-N^{1-s}\rvert\,N^{-\varepsilon}\), so the right half-strip is not filled with truncation artifacts.
- [x] **Grid detects zeros.** Isolation \(\kappa=\varepsilon\), so a miss of size \(N^{-\kappa}\) does not leak a main term above the relative threshold.
- [x] **Theorem 9.1 split.** Divide by the prefactor and split at height \(N^{1/2-\varepsilon}\), recovering \(\lvert\zeta\rvert\ll N^{-\varepsilon/2}\) rather than \(O(1)\).
- [x] **Theorem 10.1 for \(\nu_N\).** Relative depth implies \(\lvert\zeta\rvert\le N^{-\varepsilon}+O((1+\lvert t\rvert)N^{-\sigma})\), so unrestricted limit atoms are zeros.
- [x] **Conditional implication.** Proposition 4.6 / Theorem 12.4: Identity L \(\Rightarrow\) no balanced atom with \(\lvert\sigma-\tfrac12\rvert\ge\delta\) \(\Rightarrow\) Corollary 12.3 (i).

## Still open after the infrastructure

- [ ] **L itself.** See above.
- [x] **L\(_0\), floor on the tightness range.** Corollary 4.3.2 and Lemma 4.3.3: the polygonal path, completed to a continuous curve over \(\mathbb{R}\), has its atomic mass in \(\lvert t\rvert\le N^{1/2-\varepsilon}\) by fractal packing; on that window \(\lvert\gamma\rvert^2/N\le N^{-2\varepsilon}\to 0\). Floor \(\tfrac14 N^{1-2\sigma}\), not \(D_N\).
- [x] **Uniformity in \(\gamma\).** Corollary 4.1.2: \(N_0(T)=(C(1+T))^{2/(1-2\varepsilon)}\), count \(O(T\log T)\).
- [x] **Sublevel components.** Definition 5.4 and Lemma 5.5 (Rouché). Extra Dirichlet-polynomial zeros do not persist, by Theorem 10.1.
- [x] **Numerical check off the line.** Section 13 and `geometric_dqpt_test.py`: three-scale scan at \(\gamma_1\) for \(\sigma\in\{0.35,0.40,0.50,0.60,0.65\}\). Not a test of L at zeros of \(\zeta\).

## Not on the critical path

- Addendum B (Bourgain dual sums) is optional and does not touch the band.
- Section 6 is interpolation only; integer theorems do not use it.
