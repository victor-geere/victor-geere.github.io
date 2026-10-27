# Lemma 3.2 (Filter form and the polygonal path)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §3](publication.html#sec3) · 3. Coherent polygonal partial sums |
| Proof in source | yes |

## Statement

With \(c_m^{(N)}\) as in Lemma 2.2, \[
\eta_N^{(M)}(s)=\sum_{m=1}^M c_m^{(N)}m^{-s}.
\] The associated polygonal path in the complex plane is the sequence of partial sums of the vectors \(c_m^{(N)}m^{-s}\); the endpoint of the path is precisely \(\eta_N^{(M)}(s)\), and the coefficients have mean zero over every complete block of \(N\) consecutive integers.

## Proof

\(N^{1-s}H_{\lfloor M/N\rfloor}^{(s)}=N\sum_{j\le\lfloor M/N\rfloor}(Nj)^{-s}=N\sum_{m\le M,\;N\mid m}m^{-s}\), since the multiples of \(N\) not exceeding \(M\) are exactly \(Nj\) with \(j\le\lfloor M/N\rfloor\). Subtracting this from \(H_M^{(s)}=\sum_{m\le M}m^{-s}\) replaces the coefficient \(1\) by \(1-N\) at precisely those multiples.
