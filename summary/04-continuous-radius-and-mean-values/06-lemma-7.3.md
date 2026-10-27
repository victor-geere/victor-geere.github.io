# Lemma 7.3 (Pointwise from local means)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [publication.html §7](publication.html#sec7) · 7. Mean-value estimates |
| Proof in source | yes |

## Statement

For \(F\in C^1(\mathbb{R})\) and \(H>0\), \[
\lvert F(\gamma)\rvert^2\le\frac2H\int_0^H\lvert F(\gamma+u)\rvert^2\,du+2H\int_0^H\lvert F'(\gamma+u)\rvert^2\,du.
\] If \(F(t)=\eta_N^{(N^2)}(1/2+it)\), then \(\lvert F'\rvert\le 2(\log N)\,F_{\log}\). Taking \(H=1/\log N\) costs two logarithms relative to the local \(L^2\) mean, and does not produce a power of \(N^{-1}\). Depth of closure is not taken from this lemma; it is Corollary 4.1.1.

## Proof

Write \(F(\gamma)=\frac1H\int_0^H\bigl(F(\gamma+u)-\int_0^u F'(\gamma+v)\,dv\bigr)du\) and apply \(\lvert x+y\rvert^2\le 2\lvert x\rvert^2+2\lvert y\rvert^2\).
