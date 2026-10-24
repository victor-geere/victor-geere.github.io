# Theorem 4.3 (Remainder in the strip)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

Let \(\sigma_0\in(0,1/2)\) and let \(s=\sigma+it\) with \(\sigma\in[\sigma_0,1-\sigma_0]\) and \(s\ne 1\). For every integer \(N\ge 2\), \[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+\tfrac12(1-N)N^{-2s}+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr).
\] In particular \[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr),
\] and on \(\sigma=1/2\) this is Theorem 4.1.

## Proof

Apply the Euler–Maclaurin formula of Section 4 to the Euler sums \(H_{N^2}^{(s)}\) and \(H_N^{(s)}\). The polar terms cancel as before. The order-zero boundary terms contribute \(\tfrac12 N^{-2s}-\tfrac12 N^{1-2s}=\tfrac12(1-N)N^{-2s}\). The remainder for \(H_{N^2}^{(s)}\) is \(O((1+\lvert s\rvert)N^{-2\sigma})\); multiplication of the remainder for \(H_N^{(s)}\) by \(N^{1-s}\) produces \(O((1+\lvert s\rvert)N^{1-2\sigma})\).
