# 04 — Continuous radius and mean values

This folder covers the interpolation from integer $N$ to a real radius $R$ and the mean-value estimates used in tightness. It also contains the paper’s explicit correction of an earlier false identity: the local diagonal of the continuous filter is *not* $\tfrac12 R^{-1}\rho^2$.

## Continuous radius

- [Lemma 6.1 (C¹ regularity)](01-lemma-6.1.md) shows that after smoothing the upper limit, $R\mapsto\eta_R(R^2)(s)$ is $C^1$ and differentiation under the sum is justified.
- [Definition 6.2 (Splitting of ∂_R η)](02-definition-6.2.md) records the decomposition used only in the interpolation.
- [Lemma 6.3 (Local diagonal)](03-lemma-6.3.md) evaluates the diagonal as it actually is:

$$
D_k=-\int_{-1}^{1}\frac{\varphi(u)}{k+u}\,du+R\int_{-1}^{1}\frac{\varphi(u)^2}{k+u}\,du+R_{\mathrm{EM}}^{(k)},
$$

and summing gives $R(\int\varphi^2)\log R+O_\varphi(R)$ plus Apostol remainders. This is **not** a multiple of $R^{-1}\rho^2$. The alleged evaluation $\int(1-R\varphi)(-\varphi)\,du=-\tfrac12$ is false; the integral equals $-1+R\int\varphi^2$.

## Why this matters

The two working notes under [`maths/`](../../geometric-dynamical-phase-transitions/maths) build a differential inequality on the false constant $c_1=\tfrac12$. The canonical paper withdrew that identity in the changelog: the differential inequality is **not used**, and depth of closure comes from Theorem 4.1 at zeros instead. See [folder 13](../13-working-notes/README.md) for the audit. Section 6 is interpolation only; the integer theorems do not depend on it.

## Mean values

- [Theorem 7.1 (Montgomery–Vaughan, explicit constant)](04-theorem-7.1.md) gives the second-moment bound with the constant $2\pi$.
- [Lemma 7.2 (Weighted second moment, exact)](05-lemma-7.2.md) is an exact identity for the $(1+t^2)^{-1}$-weighted mean, with diagonal $\asymp N\log N$ and no $N^3$ remainder.
- [Lemma 7.3 (Pointwise from local means)](06-lemma-7.3.md) is Gallagher/Sobolev; it costs logarithms and is not used for depth.

## Status

All items are proved. The folder is a correction node: if a later draft reintroduces $c_1=\tfrac12$ or derives a decay from the differential inequality, this folder and the canonical changelog are the sources that refute it.

[Back to the summary index](../README.md) · [Folder TOC](TOC.md)
