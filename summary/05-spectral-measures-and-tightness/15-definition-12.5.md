# Definition 12.5 (Vanishing aperture)

| Field | Value |
|---|---|
| Type | Definition |
| Status | Definition |
| Source | [publication.html §12](publication.html#sec12) · 12. Realisation of the limiting measure |
| Proof in source | no separate proof block |

## Statement

A sequence \(\varepsilon_N\in(0,1/6)\) is a *vanishing aperture* when \(\varepsilon_N\to 0\) and \(\varepsilon_N\log N\to\infty\). (For instance \(\varepsilon_N=(\log N)^{-1/2}\) for all large \(N\).) For the tightness constants of Lemma 9.6, require also \(\varepsilon_N\log N\,/\,\bigl((\log\log N)(\log\log\log N)\bigr)\to\infty\), which the example satisfies. The second condition makes \(N^{-\varepsilon_N}\to 0\), so isolation still shrinks, and \(N^{\varepsilon_N}\to\infty\), so the slow-passage cap \(N^{1/2+\varepsilon_N}\) still admits every fixed critical-line zero (Lemma 4.5.1). Write \(K_N=\max\bigl(1,\lfloor\log\log(N+16)\rfloor\bigr)\). The measures of Definition 8.1 may be formed with the parameter \(\varepsilon=\varepsilon_N\) at generation \(N\), with the additional jet condition that a balanced closure \(s\) satisfies \[
\bigl\lvert\partial_t^{\,k}\eta_N^{(N^2)}(s)\bigr\rvert\le N^{1/2+\varepsilon_N}(2\log N)^k
\qquad\text{for every integer }k=1,\dots,K_N.
\] The \(k=1\) clause is Definition 5.1 (vi), relaxed by the factor \(2\log N\). Every zero of \(\Xi\) has finite multiplicity, and \(K_N\to\infty\), so for each fixed zero one has \(K_N\ge m(\rho)\) for all large \(N\).

## Proof

_No separate proof is given in the source. The statement is either a definition, a remark, a cited result, or is argued inline in the surrounding section._
