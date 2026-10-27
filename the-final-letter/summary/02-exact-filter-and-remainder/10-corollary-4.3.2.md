# Corollary 4.3.2 (Floor lower bound on the tightness range)

| Field | Value |
|---|---|
| Type | Corollary |
| Status | Proved |
| Source | [publication.html §4](../../geometric-dynamical-phase-transitions/publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Fix \(\varepsilon\in(0,1/6)\). If \(\rho=\sigma+i\gamma\) is a zero of \(\Xi\) in the truncated strip and \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\), then for all sufficiently large \(N\), \[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\ge\tfrac14\,N^{1-2\sigma}.
\] Consequently such a zero with \(\sigma\le\tfrac14-\varepsilon/2\) cannot satisfy \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\). This is Identity L\(_0\) of [gaps.html](../../geometric-dynamical-phase-transitions/gaps.html). The range \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) is the tightness window of Theorem 9.1; it is the same window in which the polygonal path, completed to a continuous curve over \(\mathbb{R}\), has its floor under control (Lemma 4.3.3). On that window \(\lvert\gamma\rvert^2/N\le N^{-2\varepsilon}\to 0\), so the next Euler–Maclaurin remainder is absorbed.

## Proof

Retain the Bernoulli term \(B_2=1/6\) in Euler–Maclaurin: it contributes \(-\frac{s}{12}N^{-2s}(1-N^{-2})\) to \(\eta\), of size \(O(\lvert s\rvert N^{-2\sigma})\). The next remainder is \(O_{\sigma_0}(\lvert s\rvert^2 N^{-2\sigma})\). At a zero the explicit half-term is \(\tfrac12(1-N)N^{-2s}\), of size \(\tfrac12(N-1)N^{-2\sigma}\). The ratio of the remainder to the half-term is \(O(\lvert\gamma\rvert^2/N)\). On the tightness range \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) this is \(O(N^{-2\varepsilon})\), which is less than \(1/8\) for large \(N\), uniformly in \(\gamma\). The parenthesis is then at least \(N/4\). Comparing \(N^{1-2\sigma}\) with \(N^{1/2-\varepsilon}\) yields the abscissa restriction. (The older bound \(\lvert\gamma\rvert\le c_0 N^{1/2}\) with a small absolute \(c_0\) is weaker for large \(N\), since \(N^{1/2-\varepsilon}=o(N^{1/2})\).)
