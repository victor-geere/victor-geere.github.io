# Corollary F.9 (Uniform depth and slow passage on the window, unconditionally)

| Field | Value |
|---|---|
| Type | Corollary |
| Status | Proved (Bourgain 13/84) |
| Source | [publication.html Addendum F](../../geometric-dynamical-phase-transitions/publication.html#addf) · Addendum F. Quantum answers: where the physics literature sits against each gap |
| Proof in source | yes |

## Statement

Let \(\varepsilon\in(13/194,\,1/6)\) be fixed. There is \(N_2(\varepsilon)\) such that for all \(N\ge N_2\) every critical-line zero \(\rho=\tfrac12+i\gamma\) of \(\Xi\) with \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}/C_1\) satisfies simultaneously the prefactor, depth and slow-passage clauses (iv)–(vi) of Definition 5.1 and the Marty clause (iii). Under the Lindelöf hypothesis the same holds for every fixed \(\varepsilon\in(0,1/6)\). The isolation clause (ii) and the component convention remain per zero.

## Proof

(iv): \(P_N(\rho)\ge N^{1/2}-1\). (v): Theorem 4.1 gives \(\lvert\eta(\rho)\rvert\le C_1(1+\lvert\gamma\rvert)\le N^{1/2-\varepsilon}\) on the stated range (Corollary 4.1.2). (vi): Lemma 4.5.1 gives \(\lvert\partial_t\eta(\rho)\rvert\le N^{1/2}\lvert\zeta'(\rho)\rvert+O((1+\lvert\gamma\rvert)\log N)\), and the second term is \(\le N^{1/2+\varepsilon}/2\) for large \(N\). Bourgain's bound \(\zeta(\tfrac12+it)\ll t^{13/84+o(1)}\) [\[10\]](../../geometric-dynamical-phase-transitions/publication.html#ref-bourgain), transferred to the strip \(\lvert\sigma-\tfrac12\rvert\le1/\log t\) by Phragmén–Lindelöf and to \(\zeta'\) by Cauchy's estimate on a disk of radius \(1/\log t\), gives \(\lvert\zeta'(\rho)\rvert\ll\lvert\gamma\rvert^{13/84+o(1)}\le N^{(1/2-\varepsilon)(13/84+o(1))}\), which is \(\le\tfrac12N^{\varepsilon}\) for large \(N\) exactly when \((\tfrac12-\varepsilon)\tfrac{13}{84}<\varepsilon\), i.e. \(\varepsilon>13/194\). (iii): at \(\rho\), \(\eta^{\#}\le\lvert\partial_t\eta\rvert\). Under Lindelöf the exponent \(13/84\) is replaced by \(o(1)\).
