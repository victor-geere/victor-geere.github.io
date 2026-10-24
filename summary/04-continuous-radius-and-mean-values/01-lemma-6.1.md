# Lemma 6.1 (\(C^1\) regularity)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §6](publication.html#sec6) · 6. Continuous-radius interpolation |
| Proof in source | yes |

## Statement

After smoothing the upper limit, \(R\mapsto\eta_R(R^2)(s)\) is \(C^1\) on \([2,\infty)\) for each fixed \(s\) with \(\operatorname{Re}s\in(0,1)\). Differentiation under the sum is justified by \[
\sum_{m\le R^2}\lvert\partial_R(c_m(R)m^{-s})\rvert\ll_\varphi R^{1-\sigma}\log R.
\]

## Proof

The coefficients are smooth in \(R\). On the support of \(\varphi\), \(\lvert\partial_R c_m\rvert\ll 1+\lvert\varphi'\rvert_\infty(1+m/R)\). Absolute convergence of the differentiated series follows from the majorant. For the sharp cutoff at \(m\le R^2\) the map is piecewise \(C^1\), with jumps of size \(2\lvert c_{\lfloor R^2\rfloor}\rvert\) when \(R^2\) is an integer (Definition 6.2).
