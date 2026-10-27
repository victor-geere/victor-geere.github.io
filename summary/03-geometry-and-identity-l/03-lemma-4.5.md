# Lemma 4.5 (Differentiated remainder)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

On the truncated strip of Definition 5.0, for every integer \(N\ge 2\), \[
\partial_t\eta_N^{(N^2)}(s)
=i(1-N^{1-s})\zeta'(s)+i(\log N)\,N^{1-s}\zeta(s)
-i(\log N)(1-N)N^{-2s}
+O_{\sigma_0}\bigl((1+\lvert s\rvert)(\log N)\,N^{1-2\sigma}\bigr).
\]

## Proof

Differentiate the Euler–Maclaurin expansion of Theorem 4.3 in the height. Each monomial \(m^{-s}\) contributes a factor \(-\log m\), and \(\log m\le 2\log N\) throughout \(m\le N^2\). The polar terms continue to cancel at \(M=N^2\). The order-zero boundary term differentiates to the displayed logarithmic multiple of \(\tfrac12(1-N)N^{-2s}\). The remainder of Theorem 4.3 is an Euler–Maclaurin integral of \(f'(x)\) against a periodic Bernoulli function; differentiating under that integral in \(t\) produces one extra logarithm and the same power of \(N\).
