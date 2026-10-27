# 11. Last-chord pairing (algebra, then zeros)

> Source: [`truths.md`](../../geometric-dynamical-phase-transitions/truths.md), §11. Frozen by the canonical paper; corrections from `tensor.md` are noted in the folder README.

## Truth 11.1

For every complex \(s\) and every integer \(N\ge 2\),
\[
H_N(s)\,H_N(1-s)=\frac{(N-1)^2}{4N^2}.
\]
The right-hand side is real, positive, and independent of \(s\). In particular
\[
\bigl\lvert H_N(s)\bigr\rvert\cdot\bigl\lvert H_N(1-s)\bigr\rvert=\frac{(N-1)^2}{4N^2}\to\tfrac14.
\]
Proof: \(N^{-2s}N^{-2(1-s)}=N^{-2}\), and \((1-N)^2=(N-1)^2\).

## Truth 11.2

The same identity in moduli, written at a point and its twin:
\[
\bigl\lvert H_N(\sigma+it)\bigr\rvert=\tfrac12(N-1)N^{-2\sigma},\qquad
\bigl\lvert H_N(1-\sigma-it)\bigr\rvert=\tfrac12(N-1)N^{2\sigma-2}.
\]
The two sizes are equal if and only if \(\sigma=\tfrac12\). One tends to \(0\) and the other to \(\infty\) if and only if \(\sigma\neq\tfrac12\).

## Truth 11.3 — Two-sided last chord at zeros, tightness window

Let \(\rho=\sigma+i\gamma\) be a zero of \(\Xi\), and let \(\varepsilon\in(0,1/6)\). On the window \(\lvert\gamma\rvert\le N^{1/2-\varepsilon}\), the proof of Corollary 4.3.2 gives more than a floor: the \(B_2\) term is \(O(\lvert\gamma\rvert N^{-2\sigma})\) and the next remainder is \(O(\lvert\gamma\rvert^2 N^{-2\sigma})\), so
\[
\eta_N^{(N^2)}(\rho)=H_N(\rho)\bigl(1+\theta_N(\rho)\bigr),\qquad
\lvert\theta_N(\rho)\rvert=O(N^{-2\varepsilon}).
\]
The same expansion holds at \(1-\rho\), with the same \(O(N^{-2\varepsilon})\), because \(\lvert\operatorname{Im}(1-\rho)\rvert=\lvert\gamma\rvert\). Consequently, for all large \(N\),
\[
\bigl\lvert\eta_N^{(N^2)}(\rho)\bigr\rvert=\tfrac12(N-1)N^{-2\sigma}\bigl(1+O(N^{-2\varepsilon})\bigr).
\]
This is two-sided. The floor 4.4 is the lower half; the matching upper bound on the same window is \(\lvert\eta(\rho)\rvert\le N^{1-2\sigma}\). The coarse bound 4.3 remains valid off the window.

## Truth 11.4 — Product at twins

Under the hypotheses of 11.3,
\[
\eta_N^{(N^2)}(\rho)\,\eta_N^{(N^2)}(1-\rho)
=\frac{(N-1)^2}{4N^2}\bigl(1+O(N^{-2\varepsilon})\bigr).
\]
The product is therefore real and positive in the limit, and tends to \(\tfrac14\), independently of \(\sigma\) and of \(\gamma\). This uses only Euler–Maclaurin at a pair of zeros related by 1.1, on the tightness window. It does not use the Riemann hypothesis.

## Truth 11.5 — Dichotomy

Still on that window, exactly one of the following holds.

- \(\sigma=\tfrac12\): both \(\lvert\eta(\rho)\rvert\) and \(\lvert\eta(1-\rho)\rvert\) tend to \(\tfrac12\).
- \(\sigma>\tfrac12\): \(\lvert\eta(\rho)\rvert\to 0\) and \(\lvert\eta(1-\rho)\rvert\to\infty\).
- \(\sigma<\tfrac12\): \(\lvert\eta(\rho)\rvert\to\infty\) and \(\lvert\eta(1-\rho)\rvert\to 0\).

In all three cases the product tends to \(\tfrac14\). Both residuals remain of order one if and only if \(\sigma=\tfrac12\).

## Truth 11.6

Combined with 8.1–8.2: the twin whose residual tends to \(\infty\) lifts to the north pole; the twin whose residual tends to \(0\) lifts to the south pole. An off-line quadruple therefore produces one northern blow-up and one southern envelope collapse. The northern blow-up is not an atom of either geometric family (Lemma 4.8 / 8.3). The southern collapse is a right-half unrestricted atom.

---
