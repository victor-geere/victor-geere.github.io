# 4. Size of \(\eta\) at zeros of \(\Xi\)

> Source: [`truths.md`](truths.md), §4. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 4.1 — Corollary 4.1.1

If \(\sigma=\tfrac12\) and \(\varepsilon\in(0,1/4)\), then
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\le N^{1/2-\varepsilon}
\]
for all integers \(N\ge N_0(\gamma)=\bigl(C_1(1+\lvert\gamma\rvert)\bigr)^{2/(1-2\varepsilon)}\). In particular \(\log N_0(\gamma)\ll\log(2+\lvert\gamma\rvert)\).

## Truth 4.2

For all critical-line zeros with \(\lvert\gamma\rvert\le T\), the same bound holds uniformly for \(N\ge N_0(T)=\bigl(C_1(1+T)\bigr)^{2/(1-2\varepsilon)}\). There are \(O(T\log T)\) such zeros.

## Truth 4.3 — Corollary 4.3.1

In the strip \(\sigma\in[\sigma_0,1-\sigma_0]\),
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\ll(1+\lvert\gamma\rvert)\,N^{1-2\sigma}.
\]
This is \(\le N^{1/2-\varepsilon}\) as soon as \((1+\lvert\gamma\rvert)N^{1-2\sigma}\le N^{1/2-\varepsilon}\). For each **fixed** such \(\rho\) with \(\sigma>\tfrac14+\varepsilon/2\), this happens for all large \(N\).

## Truth 4.4 — Corollary 4.3.2

Fix \(\varepsilon\in(0,1/6)\). If \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) and \(N\) is large enough (uniformly in that range of \(\gamma\)), then
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert\ge\tfrac14\,N^{1-2\sigma}.
\]
Reason: the explicit half-term has size \(\tfrac12(N-1)N^{-2\sigma}\); the next Euler–Maclaurin remainder is \(O(\lvert\gamma\rvert^2 N^{-2\sigma})\); the ratio is \(O(\lvert\gamma\rvert^2/N)=O(N^{-2\varepsilon})\). Consequently a zero in this height window with \(\sigma\le\tfrac14-\varepsilon/2\) cannot satisfy \(\lvert\eta\rvert\le N^{1/2-\varepsilon}\).

## Truth 4.5

The three comparison scales
\[
P_N(s)=\lvert 1-N^{1-s}\rvert,\qquad
F_N(s)=(1+\lvert t\rvert)\,N^{1-2\sigma},\qquad
D_N=N^{1/2-\varepsilon}
\]
satisfy \(\lvert\eta\rvert=P_N\lvert\zeta\rvert+O(F_N)\). They are of the same order (up to \(1+\lvert t\rvert\)) if and only if \(\sigma=\tfrac12\).

## Truth 4.6

At a zero, the relative size of the remainder against the prefactor is
\[
\frac{F_N(\rho)}{P_N(\rho)}\ll(1+\lvert\gamma\rvert)N^{-\sigma}.
\]
This is \(\le N^{-\varepsilon}\) once \(N^{\sigma-\varepsilon}\ge 1+\lvert\gamma\rvert\). For each **fixed** \(\rho\) with \(\sigma>0\), that happens for all large \(N\).

## Truth 4.7

On the window \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\) one has \(\lvert\gamma\rvert^2/N\le N^{-2\varepsilon}\). This is the only input that makes the \(B_2\) remainder smaller than the half-term in 4.4.

## Truth 4.8

For \(\sigma>\tfrac12\) and \(\lvert\gamma\rvert\) fixed, \(\lvert\eta(\rho)\rvert\ll N^{1-2\sigma}\to 0\). For \(\sigma<\tfrac12\) and \(\lvert\gamma\rvert\) in the window of 4.4, \(\lvert\eta(\rho)\rvert\to\infty\). For \(\sigma=\tfrac12\), \(\lvert\eta(\rho)\rvert\) stays \(O(1+\lvert\gamma\rvert)\), independent of \(N\).

---
