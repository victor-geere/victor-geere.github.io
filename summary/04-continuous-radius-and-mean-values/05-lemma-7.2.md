# Lemma 7.2 (Weighted second moment, exact)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §7](publication.html#sec7) · 7. Mean-value estimates |
| Proof in source | yes |

## Statement

The Fourier transform of \((1+t^2)^{-1}\) is \(\pi e^{-\lvert\xi\rvert}\), so \[
\int_{\mathbb{R}}\frac{\bigl\lvert\eta_N^{(N^2)}(1/2+it)\bigr\rvert^2}{1+t^2}\,dt
=\pi\sum_{m,n\le N^2}c_m\overline{c}_n\,(mn)^{-1/2}\frac{\min(m,n)}{\max(m,n)}.
\] The diagonal is \(\pi\sum\lvert c_m\rvert^2/m\asymp\pi N\log N\). There is no remainder of size \(N^3\).

## Proof

Expand the square and integrate termwise. Each pair \((m,n)\) produces \(\pi\exp(-\lvert\log(m/n)\rvert)\).
