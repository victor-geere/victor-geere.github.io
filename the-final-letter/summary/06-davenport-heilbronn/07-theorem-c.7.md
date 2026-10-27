# Theorem C.7 (Theorem 4.3 for the twist)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html Addendum C](../../geometric-dynamical-phase-transitions/publication.html#addc) · Addendum C. The Davenport–Heilbronn twist: sharpness of the conversion |
| Proof in source | yes |

## Statement

Let \(\sigma_0\in(0,1/2)\) and \(s=\sigma+it\) with \(\sigma\in[\sigma_0,1-\sigma_0]\). For every integer \(N\ge2\), \[
\eta_N^{\mathrm{DH},(N^2)}(s)=(1-N^{1-s})f(s)+O_{\sigma_0}\bigl((1+\lvert s\rvert)N^{1-2\sigma}\bigr),
\] with an *absolute* implied constant — the period \(5\) does not grow with \(N\). There is no half-term: the analogue of \(\tfrac12(1-N)N^{-2s}\) is absorbed by the mean-zero cancellation.

## Proof

Let \(A(u)=\sum_{n\le u}a^{\mathrm{DH}}_n\), bounded by \(\lVert a\rVert_1=2+2\xi\) because the coefficients are periodic with mean zero. Partial summation gives, for \(x\ge1\), \[
\sum_{n>x}a_n n^{-s}=-A(x)x^{-s}+s\int_x^\infty A(u)u^{-s-1}\,du,
\qquad
\Bigl\lvert\sum_{n>x}a_n n^{-s}\Bigr\rvert\le\lVert a\rVert_1\bigl(1+\lvert s\rvert/\sigma_0\bigr)x^{-\sigma}.
\] Hence \(H_x^{(s)}[a]=f(s)+O_{\sigma_0}((1+\lvert s\rvert)x^{-\sigma})\). Apply this at \(x=N^2\) and at \(x=N\), multiply the second by \(N^{1-s}\), and subtract. Numerically the ratio of consecutive remainders at \(\sigma=0.6\), \(N=20,\dots,320\), converges to \(1.148\) against the predicted \(2^{2\sigma-1}=1.149\).
