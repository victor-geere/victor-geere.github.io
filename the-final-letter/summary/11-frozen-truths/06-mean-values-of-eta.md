# 6. Mean values of \(\eta\)

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §6. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 6.1

On the critical line, Montgomery–Vaughan and 2.5 give
\[
\int_{-T}^T\bigl\lvert\eta_N^{(N^2)}(\tfrac12+it)\bigr\rvert^2 dt\ll TN\log N+N^3.
\]

## Truth 6.2 — Lemma 7.2

Exactly,
\[
\int_{\mathbb{R}}\frac{\bigl\lvert\eta_N^{(N^2)}(\tfrac12+it)\bigr\rvert^2}{1+t^2}\,dt
=\pi\sum_{m,n\le N^2}c_m\overline{c}_n\,(mn)^{-1/2}\frac{\min(m,n)}{\max(m,n)}.
\]
The diagonal is \(\pi\sum\lvert c_m\rvert^2/m\asymp\pi N\log N\). There is no \(N^3\) remainder in this weighted identity.

## Truth 6.3

Lemma 7.3 applied to \(F(t)=\eta_N^{(N^2)}(\tfrac12+it)\) with \(H=1/\log N\) costs two logarithms relative to the local \(L^2\) mean. It does not produce a factor \(N^{-1}\). Depth at zeros is 4.1, not this lemma.

---
