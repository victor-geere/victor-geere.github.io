# 3. Euler–Maclaurin for \(\eta\)

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §3. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 3.1 — Theorem 4.1

For \(N\ge 2\) and all real \(t\),
\[
\eta_N^{(N^2)}\bigl(\tfrac12+it\bigr)=(1-N^{1/2-it})\zeta\bigl(\tfrac12+it\bigr)+O(1+\lvert t\rvert),
\]
with an absolute implied constant \(C_1\). Polar terms cancel because \((N^2)^{1-s}=N^{1-s}\cdot N^{1-s}\). At a critical-line zero,
\[
\bigl\lvert\eta_N^{(N^2)}(\tfrac12+i\gamma)\bigr\rvert\le C_1(1+\lvert\gamma\rvert).
\]

## Truth 3.2 — Theorem 4.3

For \(\sigma\in[\sigma_0,1-\sigma_0]\), \(\sigma_0\in(0,1/2)\), \(s\neq 1\),
\[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+\tfrac12(1-N)N^{-2s}+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr).
\]
In particular
\[
\eta_N^{(N^2)}(s)=(1-N^{1-s})\zeta(s)+O_{\sigma_0}\bigl((1+\lvert s\rvert)\,N^{1-2\sigma}\bigr).
\]

## Truth 3.3 — Proposition 4.2

For truncation \(M=N^\alpha\), polar terms cancel if and only if \(\alpha=2\). Only \(\alpha=2\) at \(\sigma=\tfrac12\) makes the error \(O(1+\lvert t\rvert)\) while the prefactor of \(\zeta\) has size \(N^{1/2}\).

## Truth 3.4 — Lemma 4.5

Differentiating 3.2 in the height,
\[
\partial_t\eta_N^{(N^2)}(s)
=i(1-N^{1-s})\zeta'(s)+i(\log N)\,N^{1-s}\zeta(s)
-i(\log N)(1-N)N^{-2s}
+O_{\sigma_0}\bigl((1+\lvert s\rvert)(\log N)\,N^{1-2\sigma}\bigr).
\]

---
