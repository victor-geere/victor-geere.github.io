# 1. Classical facts used as black boxes

> Source: [`truths.md`](truths.md), §1. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 1.1

\(\Xi(s)=\tfrac12 s(s-1)\pi^{-s/2}\Gamma(s/2)\zeta(s)\) and \(\Xi(s)=\Xi(1-s)\). The zeros of \(\Xi\) are exactly the non-trivial zeros of \(\zeta\).

## Truth 1.2

Euler–Maclaurin (Titchmarsh §4.11; Montgomery–Vaughan Theorem 1.12): for \(x\ge 1\), \(\sigma\ge\sigma_0>0\), \(s\neq 1\),
\[
\sum_{n\le x}n^{-s}=\zeta(s)-\frac{x^{1-s}}{1-s}+\tfrac12 x^{-s}+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,x^{-\sigma}\bigr).
\]
Keeping \(B_2=1/6\), the next remainder is \(O_{\sigma_0}(\lvert s\rvert^2 x^{-\sigma-1})\) in the usual form; after the algebra of Theorem 4.3 this is \(O(\lvert s\rvert^2 N^{-2\sigma})\) in \(\eta\).

## Truth 1.3

Apostol: the periodic Bernoulli function satisfies \(\lvert\overline{B}_1\rvert\le\tfrac12\).

## Truth 1.4

Montgomery–Vaughan (Hilbert’s inequality): for finitely supported \((a_m)\) and \(T\ge 1\),
\[
\int_0^T\Bigl\lvert\sum_m a_m m^{-it}\Bigr\rvert^2 dt=\sum_m\lvert a_m\rvert^2 T+\theta\cdot 2\pi\sum_m m\lvert a_m\rvert^2,
\quad\lvert\theta\rvert\le 1.
\]

## Truth 1.5

The Fourier transform of \((1+t^2)^{-1}\) is \(\pi e^{-\lvert\xi\rvert}\).

## Truth 1.6

Gallagher / Sobolev on the line: for \(F\in C^1(\mathbb{R})\) and \(H>0\),
\[
\lvert F(\gamma)\rvert^2\le\frac2H\int_0^H\lvert F(\gamma+u)\rvert^2\,du+2H\int_0^H\lvert F'(\gamma+u)\rvert^2\,du.
\]

## Truth 1.7

Riemann–von Mangoldt: the number of zeros of \(\Xi\) with \(\lvert\gamma\rvert\le T\) is \(O(T\log T)\).

## Truth 1.8

Stereographic projection from the north pole \(N=(0,0,1)\) onto the equatorial plane \(z=0\):
\[
\pi_N(x,y,z)=\frac{x+iy}{1-z},\qquad
\pi_N^{-1}(u+iv)=\Bigl(\frac{2(u+iv)}{1+u^2+v^2},\;\frac{u^2+v^2-1}{1+u^2+v^2}\Bigr).
\]
The south pole maps to the origin; \(N\) is the point at infinity. The round metric pulls back as \(2\lvert dw\rvert/(1+\lvert w\rvert^2)\). The spherical (Marty) derivative of a curve \(w(t)\) in \(\mathbb{C}\) is
\[
w^{\#}(t)=\frac{\lvert w'(t)\rvert}{1+\lvert w(t)\rvert^2}.
\]
Near \(w=0\), \(w^{\#}\sim\lvert w'\rvert\). Circles map to circles or lines; meridians through \(N\) map to straight lines through \(0\). Parallels (constant colatitude) map to concentric circles. The map is conformal, so a rhumb line (constant bearing) maps to a logarithmic spiral. (Page: `projection.html`.)

## Truth 1.9

In spherical coordinates \(P=(\sin\theta\cos\varphi,\sin\theta\sin\varphi,\cos\theta)\) with colatitude \(\theta\in(0,\pi]\) measured from \(N\),
\[
\lvert\pi_N(P)\rvert=\cot(\theta/2).
\]
The equator \(\theta=\pi/2\) is the unit circle. The south pole \(\theta=\pi\) is the origin. As \(\theta\downarrow 0\), \(\lvert\pi_N(P)\rvert\to\infty\).

## Truth 1.10

Chordal distance on the Riemann sphere from \(w\in\mathbb{C}\) to the origin:
\[
\chi(w,0)=\frac{\lvert w\rvert}{\sqrt{1+\lvert w\rvert^2}}.
\]
The height of the lift is \(z=(\lvert w\rvert^2-1)/(\lvert w\rvert^2+1)\). Southern hemisphere: \(\lvert w\rvert<1\). Equator: \(\lvert w\rvert=1\). Northern hemisphere: \(\lvert w\rvert>1\).

## Truth 1.11

A regular \(N\)-gon inscribed in a circle of radius \(R\) has sagitta \(R\bigl(1-\cos(\pi/N)\bigr)=O(R N^{-2})\). The coarser bound “edge subtends angle \(O(N^{-1})\) on a fibre of radius \(O(1)\)” is \(O(N^{-1})\) in Hausdorff distance.

## Truth 1.12

\(\zeta(\overline{s})=\overline{\zeta(s)}\) for real \(\sigma\) off the pole. Non-trivial zeros come in conjugate pairs. Combined with \(\Xi(s)=\Xi(1-s)\), they come in quadruples \(\{\rho,\,\overline{\rho},\,1-\rho,\,1-\overline{\rho}\}\) unless they lie on the critical line or the real axis (none of the latter are non-trivial).

## Truth 1.13

Approximate functional equation dual lengths: the dual of a sum to \(x\) at height \(t\) has length \(\lvert t\rvert/(2\pi x)\). For \(x=N^2\) and \(x=N\), on the window \(\lvert t\rvert\le N^{1/2-\varepsilon}\) both lengths are \(<1\) for \(N\ge 3\). Those dual sums are empty.

## Truth 1.14

\(\exp\bigl(-\lvert\log(m/n)\rvert\bigr)=\min(m,n)/\max(m,n)\) for \(m,n>0\).

## Truth 1.15

Speiser: the Riemann hypothesis is equivalent to \(\zeta'\) having no zeros in \(0<\operatorname{Re}s<\tfrac12\). Recorded as a classical equivalence, not as a theorem of this construction.

---
