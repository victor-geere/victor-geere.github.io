# Theorem C.9 (The conversion is sharp)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum C](publication.html#addc) · Addendum C. The Davenport–Heilbronn twist: sharpness of the conversion |
| Proof in source | yes |

> **Editorial note.** The Davenport–Heilbronn function has a functional equation and no Euler product; at Spira’s off-line zero the framework reports a false RH. This is the sharpness proof.

## Statement

Fix \(\varepsilon\in(0,1/6)\) and \(\delta\le0.19\). The off-line zero \(\rho_{\mathrm{DH}}\) of Lemma C.4(iii) satisfies, for all sufficiently large \(N\), \[
\bigl\lvert\eta_N^{\mathrm{DH},(N^2)}(\rho_{\mathrm{DH}})\bigr\rvert\le P_N(\rho_{\mathrm{DH}})\,N^{-\varepsilon}
\qquad\text{and}\qquad
P_N(\rho_{\mathrm{DH}})<N^{1/2-\varepsilon/2}.
\] It is therefore an unrestricted closure and not a balanced one, so \(\rho_{\mathrm{DH}}\in\operatorname{supp}\nu^{\mathrm{DH}}\setminus\operatorname{supp}\mu^{\mathrm{DH}}\) and \[
\operatorname{supp}\mu^{\mathrm{DH}}\subsetneq\operatorname{supp}\nu^{\mathrm{DH}}.
\] The analogue of Corollary 12.3 thus returns the correct verdict: the Riemann hypothesis for \(f\) is false.

## Proof

Write \(\sigma^*=0.80851\ldots\) and \(\gamma^*=85.699\ldots\). Since \(f(\rho_{\mathrm{DH}})=0\), Theorem C.7 gives \(\lvert\eta^{\mathrm{DH}}(\rho_{\mathrm{DH}})\rvert=O((1+\lvert\gamma^*\rvert)N^{1-2\sigma^*})\), while \(P_N\asymp N^{1-\sigma^*}\); the ratio is \(O((1+\lvert\gamma^*\rvert)N^{-\sigma^*})\), below \(N^{-\varepsilon}\) once \(N^{\sigma^*-\varepsilon}\ge C(1+\lvert\gamma^*\rvert)\), which holds for every \(\varepsilon<\sigma^*\) and in particular every \(\varepsilon<1/6\). For the second inequality, \(P_N\asymp N^{1-\sigma^*}=N^{0.19148\ldots}\) and \(1-\sigma^*<\tfrac12-\tfrac{\varepsilon}{2}\) precisely when \(\varepsilon<2\sigma^*-1=0.61703\ldots\), again true for every admissible \(\varepsilon\). This is Theorem 5.2 in the contrapositive: the prefactor test confines balanced closures to \(\sigma\le\tfrac12+\varepsilon/2\), and \(\sigma^*\) exceeds that. Direct computation at \(\varepsilon=0.15\), with \(N\equiv1\pmod5\) so that Lemma C.6 applies:

| \(N\) | \(\lvert\eta^{\mathrm{DH}}(\rho_{\mathrm{DH}})\rvert\) | \(P_N\) | \(\lvert\eta^{\mathrm{DH}}\rvert/P_N\) | \(N^{-\varepsilon}\) | relative? | \(N^{1/2-\varepsilon/2}\) | balanced? |
|----|----|----|----|----|----|----|----|
| 11 | 0.264992 | 2.0901 | 0.126785 | 0.69790 | yes | 2.7707 | no |
| 31 | 0.440407 | 1.6439 | 0.267905 | 0.59744 | yes | 4.3036 | no |
| 71 | 0.216526 | 1.8024 | 0.120135 | 0.52761 | yes | 6.1205 | no |
| 151 | 0.023880 | 3.5500 | 0.006727 | 0.47114 | yes | 8.4346 | no |
| 301 | 0.011296 | 2.5763 | 0.004385 | 0.42483 | yes | 11.3081 | no |
