# Theorem 4.1 (Explicit remainder)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Proved |
| Source | [publication.html §4](publication.html#sec4) · 4. Quadratic scaling and the explicit remainder |
| Proof in source | yes |

## Statement

For every integer \(N\ge 2\) and every real \(t\), \[
\eta_N^{(N^2)}\Bigl(\tfrac12+it\Bigr)
=(1-N^{1/2-it})\zeta\Bigl(\tfrac12+it\Bigr)+O(1+\lvert t\rvert),
\] with an absolute implied constant \(C_1\). In particular, at a critical-line zero one has \(\lvert\eta\rvert\le C_1(1+\lvert t\rvert)\).

## Proof

Apply the displayed Euler–Maclaurin formula at \(\sigma=1/2\) to both Euler sums \(H_{N^2}^{(s)}\) and \(H_N^{(s)}\). The remainders are \(O((1+\lvert t\rvert)N^{-1})\) and \(O((1+\lvert t\rvert)N^{-1/2})\) respectively. Multiplication of the second remainder by \(N^{1-s}=N^{1/2-it}\) produces \(O(1+\lvert t\rvert)\). The polar terms cancel: \[
\frac{(N^2)^{1-s}}{1-s}=N^{1-s}\cdot\frac{N^{1-s}}{1-s}.
\] The order-zero boundary terms \(\tfrac12 x^{-s}\) contribute \(\tfrac12 N^{-1-2it}\) from \(H_{N^2}^{(s)}\) and \(\tfrac12 N^{1-s}N^{-s}=\tfrac12 N^{-2it}\) from \(N^{1-s}H_N^{(s)}\), both \(O(1)\). Collecting the main terms gives \((1-N^{1-s})\zeta(s)\) on the critical line.
