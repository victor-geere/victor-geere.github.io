# Lemma 4.5.3 (Jet of order \(m\))

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](../../geometric-dynamical-phase-transitions/publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Let \(\rho=\sigma+i\gamma\) be a zero of \(\Xi\) of multiplicity \(m\ge 1\), so \(\zeta^{(\,j)}(\rho)=0\) for \(0\le j<m\) and \(\zeta^{(m)}(\rho)\ne 0\). Let \(\varepsilon\in(0,1/6)\). There is \(N_m(\rho)\) such that for all \(N\ge N_m(\rho)\) and every \(s\) with \(\lvert s-\rho\rvert\le N^{-\varepsilon}\), \[
\bigl\lvert\partial_t^{\,m}\eta_N^{(N^2)}(s)\bigr\rvert
\ge\tfrac12 N^{1-\sigma}\lvert\zeta^{(m)}(\rho)\rvert.
\] If \(\sigma\le\tfrac12-\delta\) with \(\delta>\varepsilon\), this exceeds \(N^{1/2+\varepsilon}(2\log N)^m\) for all large \(N\). The case \(m=1\) is Lemma 4.5.2.

## Proof

Leibniz on Lemma 4.5 iterated \(m\) times: \[
\partial_t^{\,m}\bigl[(1-N^{1-s})\zeta(s)\bigr]
=\sum_{j=0}^m\binom{m}{j}\partial_t^{\,j}(1-N^{1-s})\,\partial_t^{\,m-j}\zeta(s).
\] For \(j\ge 1\), \(\partial_t^{\,j}(1-N^{1-s})=-( -i\log N)^j N^{1-s}\). At \(s=\rho+h\) with \(\lvert h\rvert\le N^{-\varepsilon}\), Taylor gives \(\zeta^{(m-j)}(s)=O_\rho(\lvert h\rvert^{j})\) for \(j\ge 1\), since the first \(m-1\) derivatives of \(\zeta\) vanish at \(\rho\). Those terms are therefore \[
O_\rho\bigl(N^{1-\sigma}(\log N)^j N^{-\varepsilon j}\lvert\zeta^{(m)}(\rho)\rvert\bigr)=o\bigl(N^{1-\sigma}\lvert\zeta^{(m)}(\rho)\rvert\bigr),
\] because \(N^{\varepsilon}/\log N\to\infty\). The \(j=0\) term is \((1-N^{1-s})i^m\zeta^{(m)}(s)\), of size \(\bigl(N^{1-\sigma}+O(1)\bigr)\bigl(\lvert\zeta^{(m)}(\rho)\rvert+O(N^{-\varepsilon})\bigr)\). The half-term of Theorem 4.3 differentiates to size \(O\bigl(N^{1-2\sigma}(2\log N)^m\bigr)\), and the Euler–Maclaurin remainder to \(O_\rho\bigl((1+\lvert\gamma\rvert)(2\log N)^m N^{1-2\sigma}\bigr)\), both \(o(N^{1-\sigma})\). For large \(N\) the factor \(\tfrac12\) remains. Comparing \(N^{1-\sigma}\) with \(N^{1/2+\varepsilon}(2\log N)^m\) uses \(1-\sigma\ge\tfrac12+\delta>\tfrac12+\varepsilon\) and \((2\log N)^m=N^{o(1)}\).
