# Theorem 7.1 (Montgomery–Vaughan, explicit constant)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §7](../../geometric-dynamical-phase-transitions/publication.html#sec7) · 7. Mean-value estimates |
| Proof in source | yes |

## Statement

For a finitely supported sequence \((a_m)\) and \(T\ge 1\), \[
\int_0^T\Bigl\lvert\sum_m a_m m^{-it}\Bigr\rvert^2 dt=\sum_m\lvert a_m\rvert^2 T+\theta\cdot 2\pi\sum_m m\lvert a_m\rvert^2,
\] with \(\lvert\theta\rvert\le 1\) (Montgomery–Vaughan [\[13\]](../../geometric-dynamical-phase-transitions/publication.html#ref-mv1974); [\[7, §7.3\]](../../geometric-dynamical-phase-transitions/publication.html#ref-montgomery)). On the critical line, \(a_m=c_m m^{-1/2}\) therefore gives \[
\int_0^T\bigl\lvert\eta_N^{(N^2)}(1/2+it)\bigr\rvert^2 dt=T\sum_{m\le N^2}\frac{\lvert c_m\rvert^2}{m}+\theta\cdot 2\pi\sum_{m\le N^2}\lvert c_m\rvert^2.
\] The coefficient sums are \(\sum\lvert c_m\rvert^2/m\asymp N\log N\) and \(\sum\lvert c_m\rvert^2\asymp N^3\), because the spikes \(c_m=1-N\) dominate. Mean-zero cancellation is in \(\sum c_m m^{-s}\), not in \(\sum\lvert c_m\rvert^2\). In particular the diagonal is not \(O(1)\), and \[
\int_{-T}^T\bigl\lvert\eta_N^{(N^2)}(1/2+it)\bigr\rvert^2 dt\ll TN\log N+N^3.
\]

## Proof

Expand the square. Off-diagonal integrals are bounded by \(\min(T,1/\lvert\log(n/m)\rvert)\). Hilbert’s inequality as generalised in [\[13\]](../../geometric-dynamical-phase-transitions/publication.html#ref-mv1974) produces the constant \(2\pi\). For the spikes: there are \(N\) multiples of \(N\) up to \(N^2\), each with \(\lvert c_m\rvert^2=(N-1)^2\), whence \(\sum\lvert c_m\rvert^2\asymp N^3\) and \(\sum\lvert c_m\rvert^2/m\asymp N\log N\).
