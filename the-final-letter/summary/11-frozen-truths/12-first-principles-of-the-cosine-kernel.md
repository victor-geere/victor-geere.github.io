# 12. First principles of the cosine kernel

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §12. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 12.1 — Riemann

There is an even, real, rapidly decreasing function \(\Phi\), given by the Jacobi theta expansion
\[
\Phi(u)=\sum_{n=1}^\infty\bigl(2\pi^2 n^4 e^{9u/2}-3\pi n^2 e^{5u/2}\bigr)\exp(-\pi n^2 e^{2u}),
\]
such that \(\Phi(u)>0\) for all real \(u\), \(\Phi(-u)=\Phi(u)\), and
\[
\Xi_{\mathrm{cos}}(t)=c\int_0^\infty\Phi(u)\cos(tu)\,du
\]
for an absolute constant \(c\neq 0\). The constant does not move zeros. Super-exponential decay of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) entire of order one. Evenness of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) even. Reality of \(\Phi\) makes \(\Xi_{\mathrm{cos}}\) real on the real axis.

## Truth 12.2

The identity \(\Xi(s)=\Xi(1-s)\) is the statement that \(\Xi_{\mathrm{cos}}\) is even. Conjugation 1.12 is the statement that \(\Xi_{\mathrm{cos}}(\overline{t})=\overline{\Xi_{\mathrm{cos}}(t)}\). Off-line zeros therefore come in quadruples, which in the \(t\)-plane are \(\{\,t,\,-t,\,\overline{t},\,-\overline{t}\,\}\).

## Truth 12.3 — Off-line zero as a hyperbolic cosine moment

Write \(t=\gamma-i\alpha\) with \(\alpha=\sigma-\tfrac12\) real. Evenness of \(\Phi\) expands the cosine transform as
\[
\Xi_{\mathrm{cos}}(\gamma-i\alpha)=c\int_0^\infty\Phi(u)\cosh(\alpha u)\cos(\gamma u)\,du.
\]
A zero with \(\sigma\neq\tfrac12\) is exactly the vanishing of this moment for some \(\alpha\neq 0\). The weight \(\cosh(\alpha u)\) is even, convex, and strictly greater than \(1\) for \(u\neq 0\).

## Truth 12.4 — (What positivity of \(\Phi\) does not give).

\(\Phi>0\) and even does not force \(\Xi_{\mathrm{cos}}\) to have only real zeros. The Fourier cosine transform of a positive even bump may have non-real zeros. Log-concavity of \(\Phi\) (the kernel \(\Phi(x-y)\) totally positive of order \(2\)) is likewise insufficient: \(e^{-u^4}\) is positive, even, and log-concave, and its cosine transform has non-real zeros. The Gaussian \(e^{-u^2}\) is the boundary case: it is totally positive of every order, and its cosine transform has no zeros at all.

## Truth 12.5 — What does force real zeros

If \(\Phi(x-y)\) is totally positive of every order (a Pólya frequency function of order \(\infty\)), then \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class, hence has only real zeros (Schoenberg). This is a sufficient condition for the Riemann hypothesis, not a necessary one: Laguerre–Pólya does not imply that the inverse Fourier transform is a Pólya frequency function.

## Truth 12.6 — Equivalences, classical

The following are equivalent to the Riemann hypothesis. They are recorded as equivalences, not as theorems of the Dirichlet polygon.

1. Every non-trivial zero of \(\zeta\) has real part \(\tfrac12\).
2. \(\Xi_{\mathrm{cos}}\) has only real zeros.
3. \(\Xi_{\mathrm{cos}}\) lies in the Laguerre–Pólya class.
4. Weil positivity: the explicit-formula pairing \(W(h)\ge 0\) for the Weil class of test functions.
5. de Bruijn–Newman: \(\Lambda\le 0\). Combined with Rodgers–Tao \(\Lambda\ge 0\), this is \(\Lambda=0\).
6. Speiser: \(\zeta'\) has no zero in \(0<\operatorname{Re}s<\tfrac12\) (already 1.15).
7. In the language of `publication.html`, after Lemma 4.8: \(\operatorname{supp}\nu=\operatorname{supp}\mu\), equivalently \(\nu\) has no atom with real part greater than \(\tfrac12\).

## Truth 12.7

The quadratic truncation \(\alpha=2\) of Proposition 4.2 is the discrete Poisson scale: the approximate-functional-equation dual of a sum to \(N^2\) at height \(\lvert t\rvert\le N^{1/2-\varepsilon}\) is empty (1.13). That is why the last chord is a pure boundary term \(H_N(s)\) rather than a dual Dirichlet polynomial. The cosine kernel and the mean-zero filter see the same self-dual length.

---
