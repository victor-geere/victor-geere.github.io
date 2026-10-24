# Lemma 9.3 (\(\zeta\) at relative closures)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §9](publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

There are \(C_\delta\) and \(N(\delta)\) such that for \(N\ge N(\delta)\) and every \(s\in S_{\delta/2}\) with \(\lvert\eta_N^{(N^2)}(s)\rvert\le P_N(s)\,N^{-\varepsilon}\), \[
\lvert\zeta(s)\rvert\le N^{-\varepsilon}+C_\delta\,(2+\lvert t\rvert)\,N^{-\sigma}.
\] At a zero \(s_0\) of \(\eta_N^{(N^2)}\) in \(S_{\delta/2}\) the first term is absent.

## Proof

Theorem 4.3 with \(\sigma_0=\delta/4\): \((1-N^{1-s})\zeta=\eta-\tfrac12(1-N)N^{-2s}+O_\delta\bigl((1+\lvert s\rvert)N^{1-2\sigma}\bigr)\). Divide by \(P_N\ge N^{1-\sigma}-1\ge\tfrac12 N^{1-\sigma}\), valid once \(N^{\delta/2}\ge 2\): the half-term and the remainder together contribute \(C_\delta(2+\lvert t\rvert)N^{-\sigma}\).
