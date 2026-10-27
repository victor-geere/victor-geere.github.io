# Lemma 2.1 (the square)

| Field | Value |
|---|---|
| Type | Lemma |
| Status | Proved |
| Source | [`tensor.md`](../../geometric-dynamical-phase-transitions/tensor.md), §2–7 |

## Statement and proof

Let \(f\in\mathcal{W}_\delta\) and \(g=f*\check f\). Then \(g\in\mathcal{W}_\delta\), it is even, and
\[
\hat g(z)=\hat f(z)\,\overline{\hat f(\bar z)} .
\]
In particular \(\hat g=\lvert\hat f\rvert^2\ge0\) on \(\mathbb{R}\), and on the imaginary axis \(\hat g(iy)=\lvert\hat f(iy)\rvert^2\ge0\). Moreover \(\overline{\hat g(\bar z)}=\hat g(z)\) and \(\hat g(-z)=\hat g(z)\).

*Proof.* \(\widehat{\check f}(z)=\int\overline{f(-u)}e^{-izu}du=\overline{\int f(v)e^{-i\bar z v}dv}=\overline{\hat f(\bar z)}\), and the transform of a convolution is the product; holomorphy and the decay \((1+\lvert z\rvert)^{-(4+2\delta)}\) follow. At \(z=iy\): evenness of \(\hat f\) gives \(\hat f(-iy)=\hat f(iy)\), so \(\hat g(iy)=\hat f(iy)\overline{\hat f(-iy)}=\lvert\hat f(iy)\rvert^2\). The symmetries are read off the formula. \(\square\)
