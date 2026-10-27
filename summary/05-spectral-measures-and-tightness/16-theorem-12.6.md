# Theorem 12.6 (Balanced atoms on the line)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved, conditionally on a vanishing aperture sequence |
| Source | [publication.html §12](publication.html#sec12) · 12. Realisation of the limiting measure |
| Proof in source | yes |

> **Editorial note.** The aperture $\varepsilon_N\to0$ with $\varepsilon_N\log N\to\infty$ is essential; a fixed aperture gives only Theorem 12.4.

## Statement

Let \(\varepsilon_N\) be a vanishing aperture, and let \(\{\mu_N\}\) be the balanced jet measures of Definition 12.5. Then every atom of any weak-star limit of \(\{\mu_N\}\) lies on the critical line. Every critical-line zero of \(\Xi\), of any finite multiplicity, remains an atom. Marty speed (Lemma 4.8) likewise excludes the left half-strip from \(\{\nu_N\}\). A right-half zero remains an unrestricted atom, so Corollary 12.3 is the conversion of the Riemann hypothesis, not a theorem.

## Proof

The estimates of Theorems 9.1–11.1 use \(\varepsilon\in(0,1/6)\) only through \(N^{-\varepsilon}\to 0\) and the negative tightness exponent \(3\varepsilon-1/2\). Both persist along a vanishing aperture: \(N^{3\varepsilon_N-1/2}\log N\to 0\). Lemma 9.6 uses the aperture only through \(N^{-\varepsilon_N}\le\kappa_N/2\), i.e. \(\varepsilon_N\log N\gg(\log\log N)(\log\log\log N)\); the example \(\varepsilon_N=(\log N)^{-1/2}\) of Definition 12.5 satisfies this, so the moderate-range mass remains \(o(1)\). The jet condition only removes closures, so tightness is unchanged. Theorem 10.1 is unchanged. Let \(\rho=\sigma+i\gamma\) be a zero of multiplicity \(m\ge 1\), off the line, and write \(\delta=\lvert\sigma-\tfrac12\rvert>0\). If \(\sigma>\tfrac12\), the prefactor test of Theorem 5.2 requires \(\sigma\le\tfrac12+\varepsilon_N/2\) for a balanced closure; since \(\varepsilon_N\to 0\), this fails for all large \(N\). If \(\sigma<\tfrac12\), then \(\varepsilon_N<\delta\) and \(K_N\ge m\) for all large \(N\), so \(\sigma\le\tfrac12-\delta<\tfrac12-\varepsilon_N\), and Proposition 4.7 with \(K=K_N\) and Lemma 4.5.3 exclude \(\rho\). Thus no off-line zero is a persistent balanced atom. Conversely, if \(\rho=\tfrac12+i\gamma\) is a critical-line zero of multiplicity \(m\), Corollary 4.1.1 gives \(\lvert\eta\rvert\le C_1(1+\lvert\gamma\rvert)\le N^{1/2-\varepsilon_N}\) once \(N\) is large. For each fixed \(k\le m\), Leibniz as in Lemma 4.5.3 and \(\zeta^{(\,j)}(\rho)=0\) for \(j<m\) give \[
\bigl\lvert\partial_t^{\,k}\eta_N^{(N^2)}(\rho)\bigr\rvert
\le N^{1/2}\lvert\zeta^{(k)}(\rho)\rvert+O_\rho\bigl((1+\lvert\gamma\rvert)(2\log N)^k\bigr).
\] (The bound extends to \(k\le K_N\) with a constant depending on \(\rho\) and \(k\), by Cauchy’s estimates for \(\zeta^{(k)}(\rho)\) on a fixed disk about \(\rho\).) The condition \(\varepsilon_N\log N\to\infty\) yields \(N^{\varepsilon_N}\to\infty\), so for this fixed \(\rho\) the jet inequalities hold for all \(k\le K_N\) once \(N\) is large. The height \(\gamma\) enters the tightness window once \(N^{1/2-\varepsilon_N}\ge\lvert\gamma\rvert\). Hence \(\rho\) is a balanced jet-closure for all large \(N\), and is an atom of every weak-star limit. Marty speed for \(\nu_N\) (Lemma 4.8) excludes the left half-strip at the minimiser, the same comparison as the jet. A right-half zero remains unrestricted and not balanced, so \(\operatorname{supp}\nu\) meets the right half-strip if such a zero exists, and Corollary 12.3 remains the conversion.
