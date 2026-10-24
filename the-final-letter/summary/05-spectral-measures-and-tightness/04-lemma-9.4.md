# Lemma 9.4 (Classical floor off the zeros)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §9](../../geometric-dynamical-phase-transitions/publication.html#sec9) · 9. Tightness |
| Proof in source | yes |

## Statement

There is an absolute \(C_2\) such that for every \(\omega\in(0,\tfrac14]\) and every \(s=\sigma+it\) with \(-1\le\sigma\le 2\) and \(\lvert t\rvert\ge 2\) whose distance from every zero of \(\zeta\) is at least \(\omega\), \[
\lvert\zeta(s)\rvert\ge(2+\lvert t\rvert)^{-C_2(1+\log(1/\omega))}.
\]

## Proof

Titchmarsh [\[1, §9.6\]](../../geometric-dynamical-phase-transitions/publication.html#ref-titchmarsh): \(\log\zeta(s)=\sum_{\lvert t-\gamma\rvert\le 1}\log(s-\rho)+O(\log\lvert t\rvert)\), uniformly in \(-1\le\sigma\le 2\) away from the zeros. The number of terms is \(O(\log\lvert t\rvert)\) (Riemann–von Mangoldt [\[1, §9.3\]](../../geometric-dynamical-phase-transitions/publication.html#ref-titchmarsh)), and each satisfies \(\log\omega\le\log\lvert s-\rho\rvert\le\log 4\). Take real parts.
