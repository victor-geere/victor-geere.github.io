# 2. The integer filter and the Dirichlet polynomial

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §2. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 2.1

For \(N\ge 2\),
\[
c_m^{(N)}=\begin{cases}1&N\nmid m,\\1-N&N\mid m.\end{cases}
\]
For \(\operatorname{Re}s>1\),
\[
\sum_{m=1}^\infty c_m^{(N)}m^{-s}=(1-N^{1-s})\zeta(s),
\]
and the identity continues meromorphically. The factor \(1-N^{1-s}\) vanishes only on \(\operatorname{Re}s=1\).

## Truth 2.2

Write \(D_x(s)=\sum_{n\le x}n^{-s}\). Then, identically as Dirichlet polynomials,
\[
\eta_N^{(N^2)}(s)=D_{N^2}(s)-N^{1-s}D_N(s)=\sum_{m=1}^{N^2}c_m^{(N)}m^{-s}.
\]

## Truth 2.3

On the truncated strip \(S_\delta=\{\delta\le\sigma\le 1-\delta\}\) with \(\delta\in(0,1/4)\),
\[
\lvert 1-N^{1-s}\rvert\ge N^{1-\sigma}-1.
\]

## Truth 2.4

For each fixed \(\sigma\), the map \(t\mapsto\eta_N^{(N^2)}(\sigma+it)\) is a trigonometric polynomial, hence real-analytic \(\mathbb{R}\to\mathbb{C}\).

## Truth 2.5

Coefficient sums for the spikes: there are \(N\) multiples of \(N\) up to \(N^2\), each with \(\lvert c_m\rvert=N-1\), so
\[
\sum_{m\le N^2}\lvert c_m\rvert^2\asymp N^3,\qquad
\sum_{m\le N^2}\frac{\lvert c_m\rvert^2}{m}\asymp N\log N.
\]
Mean-zero cancellation is in \(\sum c_m m^{-s}\), not in \(\sum\lvert c_m\rvert^2\). The diagonal of the \(L^2\) mean is not \(O(1)\).

## Truth 2.6

\(\eta_N^{(N^2)}\) is an entire function (a Dirichlet polynomial of length \(N^2\)). It has finitely many zeros. The integer \(N\) may be even or odd; 2.1–2.5 do not use parity.

## Truth 2.7

Because \(N\mid N^2\), one has \(c_{N^2}^{(N)}=1-N\). If the sharp truncation is differentiated in a continuous radius \(R\) through the Leibniz boundary term \(B=c_{\lfloor R^2\rfloor}(R^2)^{-1/2-i\gamma}\cdot 2R\), then at integer \(R=N\) on the critical line \(\lvert B\rvert=2(N-1)\). The integer Euler–Maclaurin theorems do not use \(B\).

## Truth 2.8

The modulus of the order-zero boundary term is exact:
\[
\bigl\lvert\tfrac12(1-N)N^{-2s}\bigr\rvert=\tfrac12(N-1)N^{-2\sigma}.
\]
Its argument is \(\pi-2\gamma\log N\) (since \(1-N<0\)).

---
