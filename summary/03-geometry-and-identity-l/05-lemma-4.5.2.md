# Lemma 4.5.2 (Speed of last-chord cancellation)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Let \(\rho=\sigma+i\gamma\) be a simple zero of \(\Xi\) in the interior of \(S_\delta\), and let \(\varepsilon\in(0,1/6)\). There is \(N_1(\rho)\) such that for all \(N\ge N_1(\rho)\) and every \(s\) with \(\lvert s-\rho\rvert\le N^{-\varepsilon}\), \[
\bigl\lvert\partial_t\eta_N^{(N^2)}(s)\bigr\rvert
\ge\tfrac12 N^{1-\sigma}\lvert\zeta'(\rho)\rvert.
\] If also \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), then for all large \(N\) this exceeds \(N^{1/2+\varepsilon}\).

## Proof

Write \(s=\rho+h\) with \(\lvert h\rvert\le N^{-\varepsilon}\). Then \(\zeta(s)=\zeta'(\rho)h+O_\rho(h^2)\) and \(\zeta'(s)=\zeta'(\rho)+O_\rho(h)\). Substitute into Lemma 4.5. The leading term is \(i(1-N^{1-s})\zeta'(s)\), of size \(\bigl(N^{1-\sigma}+O(1)\bigr)\bigl(\lvert\zeta'(\rho)\rvert+O(N^{-\varepsilon})\bigr)\). The term \(N^{1-s}(\log N)\zeta(s)\) has size \(O_\rho\bigl(N^{1-\sigma-\varepsilon}\log N\bigr)\), which is \(o\bigl(N^{1-\sigma}\bigr)\). The half-term derivative has size \(O\bigl(N^{1-2\sigma}\log N\bigr)\), likewise \(o\bigl(N^{1-\sigma}\bigr)\). The Euler–Maclaurin remainder contributes \(O_\rho\bigl(N^{1-2\sigma}\log N\bigr)\). For large \(N\) the leading term dominates and the factor \(\tfrac12\) remains. Comparing \(N^{1-\sigma}\) with \(N^{1/2+\varepsilon}\) uses \(1-\sigma\ge\tfrac12+\delta>\tfrac12+\varepsilon\).
