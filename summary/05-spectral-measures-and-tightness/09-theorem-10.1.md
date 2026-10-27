# Theorem 10.1 (No spurious atoms)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §10](publication.html#sec10) · 10. Exclusion of spurious pure-point mass |
| Proof in source | yes |

## Statement

Every pure-point atom of any weak-star limit point of \(\{\mu_N\}\) or of \(\{\nu_N\}\) is a non-trivial zero of \(\Xi\) in \(S_\delta\). Balanced atoms additionally satisfy \(\operatorname{Re}s\le\tfrac12+\varepsilon/2\).

## Proof

Suppose a limit point of \(\{\nu_N\}\) carries an atom at \(s^*\in S_\delta\) with \(\zeta(s^*)\ne 0\). Along a subsequence \(N_j\to\infty\) there are unrestricted closures \(s_j\to s^*\) with \(\lvert\eta_{N_j}^{(N_j^2)}(s_j)\rvert\le P_{N_j}(s_j)\,N_j^{-\varepsilon}\). Theorem 4.3 gives \[
\bigl\lvert\eta_{N_j}^{(N_j^2)}(s_j)\bigr\rvert
\ge P_{N_j}(s_j)\bigl\lvert\zeta(s_j)\bigr\rvert-O\bigl(F_{N_j}(s_j)\bigr),
\] hence \(\lvert\zeta(s_j)\rvert\le N_j^{-\varepsilon}+O\bigl((1+\lvert s^*\rvert)N_j^{-\sigma_j}\bigr)\to 0\). Continuity of \(\zeta\) off its zeros contradicts \(\zeta(s^*)\ne 0\). There is no second main term of comparable size: the polar terms cancel at \(M=N^2\). The same comparison with the additional bounds \(P_N\ge N^{1/2-\varepsilon/2}\) and \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\) applies to \(\{\mu_N\}\). If \(\zeta(s^*)=0\), there is no contradiction from relative depth alone; Marty speed (Lemma 4.8) still excludes a persistent unrestricted atom on the left of \(\tfrac12-\varepsilon\). The abscissa bound for balanced atoms is Theorem 5.2.
