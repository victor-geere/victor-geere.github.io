# Lemma 2.3 (the prime current as a line integral)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

For \(g\) in the cone, \(c=1+\varepsilon\) with \(0<\varepsilon<\delta\), and
\(F(s):=\hat g\bigl(\tfrac{s-1/2}{i}\bigr)=\int_{\mathbb{R}}g(u)e^{-(s-1/2)u}\,du\) (so \(F(1-s)=F(s)\), \(F(\tfrac12+it)=\hat g(t)\)),
\[
\frac{1}{2\pi i}\int_{(c)}\Bigl(-\frac{\zeta'}{\zeta}(s)\Bigr)F(s)\,ds=\Pi(g).
\]

*Proof.* Expand \(-\zeta'/\zeta(s)=\sum\Lambda(n)n^{-s}\), absolutely convergent on \((c)\), and integrate term by term (justified by \(\int\lvert F(c+it)\rvert dt<\infty\)). With \(s=c+it\),
\(\frac1{2\pi}\int F(c+it)n^{-it}dt=g_c(-\log n)\) by Fourier inversion applied to \(g_c(u):=g(u)e^{-(c-1/2)u}\), whence
\(\frac{1}{2\pi i}\int_{(c)}n^{-s}F(s)ds=n^{-c}\,g(-\log n)\,n^{c-1/2}=g(\log n)/\sqrt n\) using evenness. Summing against \(\Lambda(n)\) gives \(\Pi(g)\). \(\square\)
