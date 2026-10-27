# Refined remainder (optional)

| Field | Value |
|---|---|
| Type | Theorem |
| Status | Conditional (Bourgain subconvexity; optional) |
| Source | [publication.html Addendum B](../../geometric-dynamical-phase-transitions/publication.html#addb) · Addendum B. Refined quadratic asymptotic |
| Proof in source | yes |

> **Editorial note.** This is Addendum B in the paper. It is not needed for Theorems 9.1–12.2.

## Statement

There exist a positive exponent \(\delta=29/168-\eta\) and a range \(\delta'=1/3+1/42-\eta\) such that, for \(\lvert t\rvert\le N^{\delta'}\), the remainder in Theorem 4.1 may be replaced by \(O\bigl(N^{1/2-\delta}(1+\lvert t\rvert)^\varepsilon\bigr)\) after inserting Bourgain’s bound \(\mu(1/2)=13/84\) and a van-der-Corput estimate of order 1 on the dual tails, provided an explicit constant in Bourgain’s bound is fixed.

## Proof

On the range \(\lvert t\rvert\le 2\pi N\) both dual sums of the approximate functional equation are empty and Theorem 4.1 already gives \(O(1+\lvert t\rvert)\), which is stronger. For \(2\pi N<\lvert t\rvert\le N^{\delta'}\) write \[
H_x^{(s)}=\zeta(s)-\chi(s)H_{\lvert t\rvert/(2\pi x)}^{(1-s)}+R(x,s)
\] and substitute \(x=N^2\) and \(x=N\) into \(\eta=H_{N^2}^{(s)}-N^{1-s}H_N^{(s)}\). The dual sums have lengths \(\lvert t\rvert/(2\pi N^2)\) and \(\lvert t\rvert/(2\pi N)\). Estimate them by convexity or by Bourgain, and estimate the AFE remainders by van der Corput. Collecting exponents as in the previous seven-step sketch yields \(\delta=1/6+1/168-\eta\) from Weyl plus one van-der-Corput increment, or the displayed value from Bourgain. The dual terms vanish at critical-line zeros because they contain \(\zeta(1-s)\) or a short Dirichlet polynomial that is \(O(1)\) when the length is \(O(1)\).
